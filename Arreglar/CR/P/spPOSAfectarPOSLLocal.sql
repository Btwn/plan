SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSAfectarPOSLLocal

AS
BEGIN
DECLARE
@Empresa		varchar(5),
@Modulo			varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@Host			varchar(20),
@ID				varchar(36),
@Empresa2		varchar(5),
@Modulo2		varchar(5),
@Sucursal2		int,
@Usuario2		varchar(10),
@Host2			varchar(20),
@ID2			varchar(36),
@Ok				int,
@OkRef			varchar(255),
@Mov            varchar(20),
@Mov2           varchar(20),
@MovClave       varchar(20),
@MovAfectar     varchar(20)
BEGIN TRAN
DECLARE crPOSL CURSOR LOCAL FOR
SELECT
p.Empresa,
p.Modulo,
p.Sucursal,
p.Usuario,
p.ID,
p.Host,
p.Mov
FROM POSL p
INNER JOIN MovTipo mt ON p.Mov = mt.Mov
AND mt.Modulo = 'POS'
WHERE p.Estatus IN ('CONCLUIDO','TRASPASADO') AND ISNULL(p.AfectadoLocal,0) = 0
ORDER BY p.FechaRegistro, p.Orden, p.IDR
OPEN crPOSL
FETCH NEXT FROM crPOSL INTO @Empresa, @Modulo, @Sucursal, @Usuario, @ID, @Host, @Mov
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @MovClave = Clave FROM MovTipo WHERE Mov = @Mov AND Modulo = 'POS'
IF @MovClave NOT IN ('POS.FTE','POS.STE','POS.CC','POS.CCM','POS.TCAC','POS.CTCAC','POS.CTCRC','POS.TCRC') AND @Ok IS NULL
BEGIN
EXEC spPOSAfectar @Empresa, @Modulo, @Sucursal, @Usuario, @ID, @Host, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NOT NULL
SELECT @MovAfectar = @Mov
IF @MovClave IN ('POS.TCM','POS.CTCM') AND @Ok IS NULL
BEGIN
IF EXISTS (SELECT * FROM POSL p JOIN MovTipo m ON p.Mov = m.Mov AND m.Modulo = 'POS'
WHERE p.IDR = @ID AND p.Estatus IN('CONCLUIDO') AND m.Clave IN('POS.TCM','POS.CTCM'))
UPDATE POSL SET AfectadoLocal = 1 WHERE ID IN (SELECT ID FROM POSL p JOIN MovTipo m ON p.Mov = m.Mov AND m.Modulo = 'POS'
WHERE p.IDR = @ID AND p.Estatus IN('CONCLUIDO') AND m.Clave IN('POS.TCM','POS.CTCM'))
END
IF @MovClave IN ('POS.TRM','POS.CTRM' ) AND @Ok IS NULL
BEGIN
IF EXISTS (SELECT * FROM POSL p JOIN MovTipo m ON p.Mov = m.Mov AND m.Modulo = 'POS'
WHERE p.IDR = @ID AND p.Estatus IN('CONCLUIDO') AND m.Clave IN('POS.TRM','POS.CTRM'))
UPDATE POSL SET AfectadoLocal = 1 WHERE ID IN (SELECT ID FROM POSL p JOIN MovTipo m ON p.Mov = m.Mov AND m.Modulo = 'POS'
WHERE p.IDR = @ID AND p.Estatus IN('CONCLUIDO')
AND m.Clave IN('POS.CTCRC','POS.TCRC'))
END
END
IF @MovClave IN ('POS.CC','POS.CCM')AND @Ok IS NULL
BEGIN
IF  EXISTS(SELECT * FROM POSL p JOIN MovTipo m ON p.Mov = m.Mov  AND m.Modulo = 'POS'
WHERE p.IDR = @ID AND m.Clave IN ('POS.FTE','POS.STE') AND p.Estatus = 'CONCLUIDO')
BEGIN
DECLARE crFaltanteSobrante CURSOR FOR
SELECT p.Empresa, p.Modulo, p.Sucursal, p.Usuario, p.ID, p.Host, p.Mov
FROM POSL p
INNER JOIN MovTipo mt ON p.Mov = mt.Mov  AND mt.Modulo = 'POS'AND mt.Clave IN ('POS.FTE','POS.STE')
WHERE p.Estatus IN ('CONCLUIDO') AND p.IDR = @ID
ORDER BY FechaRegistro
OPEN crFaltanteSobrante
FETCH NEXT FROM crFaltanteSobrante INTO @Empresa2, @Modulo2, @Sucursal2, @Usuario2, @ID2, @Host2, @Mov2
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
EXEC spPOSAfectar @Empresa2, @Modulo2, @Sucursal2, @Usuario2, @ID2, @Host2, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NOT NULL
SELECT @MovAfectar = @Mov2,  @ID = @ID2
IF @Ok IS NULL
UPDATE POSL Set AfectadoLocal = 1 WHERE ID = @ID2
FETCH NEXT FROM crFaltanteSobrante INTO @Empresa2, @Modulo2, @Sucursal2, @Usuario2, @ID2, @Host2, @Mov2
END
CLOSE crFaltanteSobrante
DEALLOCATE crFaltanteSobrante
IF @Ok IS NULL
EXEC spPOSAfectar @Empresa, @Modulo, @Sucursal, @Usuario, @ID, @Host, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NOT NULL
SELECT @MovAfectar = @Mov
END
ELSE
BEGIN
EXEC spPOSAfectar @Empresa, @Modulo, @Sucursal, @Usuario, @ID, @Host, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NOT NULL
SELECT @MovAfectar = @Mov
END
END
IF @Ok IS NULL
UPDATE POSL Set AfectadoLocal = 1 WHERE ID = @ID
END
FETCH NEXT FROM crPOSL INTO @Empresa, @Modulo, @Sucursal, @Usuario, @ID, @Host, @Mov
END
CLOSE crPOSL
DEALLOCATE crPOSL
IF @Ok IS NULL
COMMIT TRAN
ELSE
ROLLBACK TRAN
IF @Ok IS NOT NULL
SELECT @OkRef = Descripcion +' '+ISNULL(@OkRef,'')
FROM MensajeLista WHERE Mensaje = @Ok
IF @Ok IS NOT NULL
SELECT @Ok, @OkRef, @Modulo, @ID, @MovAfectar
END

