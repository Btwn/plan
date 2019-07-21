SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCxpPagarEnLoteProcesar
@Empresa	varchar(5),
@Estacion	int

AS BEGIN
DECLARE
@ID			int,
@APagar		money,
@Conteo		int,
@Ok			int,
@OkRef		varchar(255),
@PagoID		int,
@PagoMov		varchar(20)
SELECT @PagoMov = CxpPago FROM EmpresaCfgMov WHERE Empresa = @Empresa
SELECT @Ok = NULL, @OkRef = NULL, @Conteo = 0
DECLARE crCxpPagarEnLote CURSOR LOCAL FOR
SELECT p.ID, ImporteAPagar
FROM CxpPagarEnLote l
JOIN Cxp p ON p.ID = l.ID
WHERE l.Estacion = @Estacion AND ISNULL(ImporteAPagar, 0.0) > 0.0
ORDER BY l.Calificacion, p.Proveedor, p.Vencimiento, p.ID
OPEN crCxpPagarEnLote
FETCH NEXT FROM crCxpPagarEnLote INTO @ID, @APagar
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
BEGIN TRANSACTION
EXEC @PagoID = spAfectar 'CXP', @ID, 'GENERAR', 'TODO', @PagoMov, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @PagoID IS NOT NULL
BEGIN
UPDATE Cxp  SET Importe = @APagar, Impuestos = NULL WHERE ID = @PagoID
UPDATE CxpD SET Importe = @APagar WHERE ID = @PagoID
END
EXEC spAfectar 'CXP', @PagoID, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @Ok IS NULL
BEGIN
SELECT @Conteo = @Conteo + 1
DELETE CxpPagarEnLote WHERE CURRENT OF crCxpPagarEnLote
COMMIT TRANSACTION
END ELSE
ROLLBACK TRANSACTION
END
FETCH NEXT FROM crCxpPagarEnLote INTO @ID, @APagar
END
CLOSE crCxpPagarEnLote
DEALLOCATE crCxpPagarEnLote
IF @Ok IN (NULL, 80300)
SELECT 'Se Procesaron '+LTRIM(CONVERT(char, @Conteo))+ ' Movimientos'
ELSE
SELECT Descripcion+' '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
RETURN
END

