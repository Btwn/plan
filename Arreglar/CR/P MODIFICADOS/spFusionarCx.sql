SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFusionarCx
@Empresa	char(5),
@Usuario	char(10),
@Sucursal	int,
@Modulo		char(5),
@FechaEmision	datetime,
@Contacto	char(10),
@CxMov		char(20)

AS BEGIN
DECLARE
@Moneda		char(10),
@TipoCambio		float,
@Vencimiento	datetime,
@Importe		money,
@Mov		char(20),
@MovID		varchar(20),
@CxID		int,
@Renglon		float,
@Ok			int,
@OkRef		varchar(255),
@Conteo		int,
@Mensaje		varchar(255)
SELECT @Ok = NULL, @OkRef = NULL, @Conteo = 0
CREATE TABLE #Aplica (
Moneda		char(10) 	COLLATE Database_Default NULL,
Contacto	char(10) 	COLLATE Database_Default NULL,
Vencimiento	datetime	NULL,
Mov		char(20)	COLLATE Database_Default NULL,
MovID		varchar(20)	COLLATE Database_Default NULL,
Importe		money		NULL,
Renglon		float		NULL)
IF @Modulo = 'CXC'
INSERT #Aplica (Moneda, Contacto, Vencimiento, Mov, MovID, Importe)
SELECT c.Moneda, c.Cliente, c.Vencimiento, c.Mov, c.MovID, c.Saldo
FROM Cxc c, MovTipo mt
WITH(NOLOCK) WHERE c.Empresa = @Empresa AND c.Cliente = @Contacto AND c.Estatus = 'PENDIENTE' AND NULLIF(c.Saldo, 0) IS NOT NULL
AND mt.Modulo = @Modulo AND mt.Mov = c.Mov AND mt.Clave IN ('CXC.F','CXC.FA','CXC.AF','CXC.CA','CXC.CAD','CXC.CAP','CXC.CD','CXC.D','CXC.DM','CXC.DA','CXC.IM','CXC.RM')
IF @Modulo = 'CXP'
INSERT #Aplica (Moneda, Contacto, Vencimiento, Mov, MovID, Importe)
SELECT c.Moneda, c.Proveedor, c.Vencimiento, c.Mov, c.MovID, c.Saldo
FROM Cxp c, MovTipo mt
WITH(NOLOCK) WHERE c.Empresa = @Empresa AND c.Proveedor = @Contacto AND c.Estatus = 'PENDIENTE' AND NULLIF(c.Saldo, 0) IS NOT NULL
AND mt.Modulo = @Modulo AND mt.Mov = c.Mov AND mt.Clave IN ('CXP.F','CXP.FA','CXP.AF','CXP.CA', 'CXP.CAD','CXP.CAP','CXP.CD','CXP.D','CXP.DM','CXP.DA')
DECLARE crAplica CURSOR FOR
SELECT Moneda, Contacto, Vencimiento, SUM(Importe)
FROM #Aplica
GROUP BY Moneda, Contacto, Vencimiento
HAVING COUNT(*) > 1
ORDER BY Moneda, Contacto, Vencimiento
OPEN crAplica
FETCH NEXT FROM crAplica  INTO @Moneda, @Contacto, @Vencimiento, @Importe
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Renglon = 0.0
UPDATE #Aplica
SET @Renglon = Renglon = ISNULL(Renglon, 0) + @Renglon + 2048.0
WHERE Moneda = @Moneda AND Contacto = @Contacto AND Vencimiento = @Vencimiento
SELECT @TipoCambio = TipoCambio FROM Mon WITH(NOLOCK) WHERE Moneda = @Moneda
IF @Modulo = 'CXC'
BEGIN
INSERT Cxc (Sucursal, Empresa,  Mov,    FechaEmision,  Moneda,  TipoCambio,  Usuario,  Estatus,      Cliente,   ClienteMoneda, ClienteTipoCambio, Importe,  Condicion, Vencimiento,  AplicaManual, PersonalCobrador)
SELECT @Sucursal, @Empresa, @CxMov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Contacto, @Moneda,       @TipoCambio,       @Importe, '(Fecha)', @Vencimiento, 1,            c.PersonalCobrador
FROM Cte c
WITH(NOLOCK) WHERE c.Cliente = @Contacto
SELECT @CxID = SCOPE_IDENTITY()
INSERT CxcD (Sucursal,  ID,   Renglon, Aplica, AplicaID, Importe)
SELECT @Sucursal, @CxID, Renglon, Mov,    MovID,    Importe
FROM #Aplica
WHERE Moneda = @Moneda AND Contacto = @Contacto AND Vencimiento = @Vencimiento
END ELSE
IF @Modulo = 'CXP'
BEGIN
INSERT Cxp (Sucursal,  Empresa,  Mov,    FechaEmision,  Moneda,  TipoCambio,  Usuario,  Estatus,      Proveedor, ProveedorMoneda, ProveedorTipoCambio, Importe,  Condicion, Vencimiento,  AplicaManual)
VALUES (@Sucursal, @Empresa, @CxMov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @Contacto, @Moneda,         @TipoCambio,         @Importe, '(Fecha)', @Vencimiento, 1)
SELECT @CxID = SCOPE_IDENTITY()
INSERT CxpD (Sucursal,  ID,   Renglon, Aplica, AplicaID, Importe)
SELECT @Sucursal, @CxID, Renglon, Mov,    MovID,    Importe
FROM #Aplica
WHERE Moneda = @Moneda AND Contacto = @Contacto AND Vencimiento = @Vencimiento
END
EXEC spAfectar @Modulo, @CxID, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL SELECT @Conteo = @Conteo + 1
END
FETCH NEXT FROM crAplica  INTO @Moneda, @Contacto, @Vencimiento, @Importe
END
CLOSE crAplica
DEALLOCATE crAplica
IF @Ok IS NULL
SELECT @Mensaje = LTRIM(CONVERT(char, @Conteo))+' Documentos Generados.'
ELSE
SELECT @Mensaje = Descripcion+' '+RTRIM(ISNULL(@OkRef, '')) FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Mensaje
RETURN
END

