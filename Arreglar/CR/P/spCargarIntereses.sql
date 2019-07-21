SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCargarIntereses
@Sucursal		int,
@Empresa		char(5),
@Usuario		char(10),
@Modulo		char(5),
@Hoy			datetime,
@FechaRegistro	datetime,
@Conteo		int		OUTPUT,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@CfgMov			char(20),
@RamaID			int,
@ID				int,
@Renglon			float,
@CtaDinero			char(10),
@Contacto			char(10),
@Intereses			money,
@Importe			money,
@Moneda			char(10),
@TipoCambio			float,
@MovTipoCambio		float,
@MovGenerar			char(20),
@MovIDGenerar		varchar(20),
@IDGenerar			int,
@Concepto			varchar(50),
@Proyecto			varchar(50),
@UEN			int,
@Tasa			varchar(50),
@NuevaTasaDiaria		float
EXEC spExtraerFecha @Hoy OUTPUT
SELECT @FechaRegistro = GETDATE()
SELECT @ID = NULL
SELECT @CfgMov = CASE @Modulo
WHEN 'CXC' THEN NULLIF(RTRIM(CxcCargoIntereses), '')
WHEN 'CXP' THEN NULLIF(RTRIM(CxpAbonoIntereses), '')
END
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
CREATE TABLE #Devengados (
Renglon	float		NULL,
Mov		varchar(20)	COLLATE Database_Default NULL,
MovID	varchar(20)	COLLATE Database_Default NULL,
Importe	money		NULL)
IF @Ok IS NULL
BEGIN
IF @Modulo = 'CXC'
DECLARE crIntereses CURSOR FOR
SELECT ISNULL(c.RamaID, c.ID), m.Moneda, m.TipoCambio, c.Concepto, c.Proyecto, c.UEN, c.Cliente, c.Tasa
FROM Cxc c, Mon m, MovTipo mt
WHERE c.Empresa = @Empresa
AND m.Moneda = c.Moneda
AND c.Estatus = 'PENDIENTE'
AND mt.Modulo = @Modulo AND mt.Mov = c.Mov AND mt.Clave IN ('CXC.F', 'CXC.FAC', 'CXC.CA', 'CXC.CAD', 'CXC.D', 'CXC.DAC', 'CXC.A', 'CXC.AR', 'CXC.DA', 'CXC.NC', 'CXC.NCD', 'CXC.NCF', 'CXC.DV')
AND ISNULL(c.Saldo, 0) > 0.0 AND NULLIF(c.TasaDiaria, 0) IS NOT NULL AND c.Vencimiento = @Hoy
ORDER BY ISNULL(c.RamaID, c.ID), m.Moneda, m.TipoCambio, c.Concepto, c.Proyecto, c.UEN, c.Cliente
ELSE
IF @Modulo = 'CXP'
DECLARE crIntereses CURSOR FOR
SELECT ISNULL(c.RamaID, c.ID), m.Moneda, m.TipoCambio, c.Concepto, c.Proyecto, c.UEN, c.Proveedor, c.Tasa
FROM Cxp c, Mon m, MovTipo mt
WHERE c.Empresa = @Empresa
AND m.Moneda = c.Moneda
AND c.Estatus = 'PENDIENTE'
AND mt.Modulo = @Modulo AND mt.Mov = c.Mov AND mt.Clave IN ('CXP.F', 'CXP.FAC', 'CXP.CA', 'CXP.CAD', 'CXP.D', 'CXP.DAC', 'CXP.A', 'CXP.DA', 'CXP.NC', 'CXP.NCD', 'CXP.NCF')
AND ISNULL(c.Saldo, 0) > 0.0 AND NULLIF(c.TasaDiaria, 0) IS NOT NULL AND c.Vencimiento = @Hoy
ORDER BY ISNULL(c.RamaID, c.ID), m.Moneda, m.TipoCambio, c.Concepto, c.Proyecto, c.UEN, c.Proveedor
OPEN crIntereses
FETCH NEXT FROM crIntereses INTO @RamaID, @Moneda, @TipoCambio, @Concepto, @Proyecto, @UEN, @Contacto, @Tasa
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
TRUNCATE TABLE #Devengados
IF @Modulo = 'CXC'
BEGIN
INSERT Cxc (OrigenTipo, Sucursal,  Empresa,  Mov,     FechaEmision,  Moneda,  TipoCambio,  Usuario,   Estatus,     UltimoCambio,   Cliente,   ClienteMoneda, ClienteTipoCambio, AplicaManual, RamaID,  Concepto,  Proyecto,  UEN)
VALUES ('AUTO/CI',  @Sucursal, @Empresa, @CfgMov, @Hoy,          @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @FechaRegistro, @Contacto, @Moneda,       @TipoCambio,       1,            @RamaID, @Concepto, @Proyecto, @UEN)
SELECT @ID = SCOPE_IDENTITY()
INSERT #Devengados (Mov, MovID, Importe)
SELECT Mov, MovID, Saldo
FROM Cxc
WHERE Empresa = @Empresa AND Estatus = 'PENDIENTE' AND NULLIF(Saldo, 0) IS NOT NULL
AND Moneda = @Moneda AND ISNULL(RamaID, ID) = @RamaID AND OrigenTipo = 'AUTO/ID'
AND Cliente = @Contacto
END ELSE
IF @Modulo = 'CXP'
BEGIN
INSERT Cxp (OrigenTipo, Sucursal,  Empresa,  Mov,     FechaEmision,  Moneda,  TipoCambio,  Usuario,  Estatus,      UltimoCambio,   Proveedor, ProveedorMoneda, ProveedorTipoCambio,   AplicaManual, RamaID,  Concepto,  Proyecto,  UEN)
VALUES ('AUTO/CI',  @Sucursal, @Empresa, @CfgMov, @Hoy,          @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR', @FechaRegistro, @Contacto, @Moneda,         @TipoCambio, 	  1,            @RamaID, @Concepto, @Proyecto, @UEN)
SELECT @ID = SCOPE_IDENTITY()
INSERT #Devengados (Mov, MovID, Importe)
SELECT Mov, MovID, Saldo
FROM Cxp
WHERE Empresa = @Empresa AND Estatus = 'PENDIENTE' AND NULLIF(Saldo, 0) IS NOT NULL
AND Moneda = @Moneda AND ISNULL(RamaID, ID) = @RamaID AND OrigenTipo = 'AUTO/ID'
AND Proveedor = @Contacto
END
SELECT @Renglon = 0.0
UPDATE #Devengados SET @Renglon = Renglon = ISNULL(Renglon, 0) + @Renglon + 2048
IF @Modulo = 'CXC'
BEGIN
INSERT CxcD (Sucursal, ID, Renglon, Aplica, AplicaID, Importe)
SELECT @Sucursal, @ID, Renglon, Mov, MovID, Importe FROM #Devengados
IF EXISTS(SELECT * FROM CxcD)
UPDATE Cxc SET Importe = (SELECT SUM(Importe) FROM CxcD WHERE ID = @ID) WHERE ID = @ID
ELSE BEGIN
DELETE Cxc WHERE ID = @ID
SELECT @ID = NULL
END
END ELSE
IF @Modulo = 'CXP'
BEGIN
INSERT CxpD (Sucursal, ID, Renglon, Aplica, AplicaID, Importe)
SELECT @Sucursal, @ID, Renglon, Mov, MovID, Importe FROM #Devengados
IF EXISTS(SELECT * FROM CxpD)
UPDATE Cxp SET Importe = (SELECT SUM(Importe) FROM CxpD WHERE ID = @ID) WHERE ID = @ID
ELSE BEGIN
DELETE Cxp WHERE ID = @ID
SELECT @ID = NULL
END
END
IF @ID IS NOT NULL
EXEC spCx @ID, @Modulo, 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @MovGenerar OUTPUT, @MovIDGenerar OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SELECT @Conteo = @Conteo + 1
EXEC spVerTasaDiaria @Tasa, @Hoy, @NuevaTasaDiaria OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Modulo = 'CXC' UPDATE Cxc SET TasaDiaria = @NuevaTasaDiaria WHERE ISNULL(RamaID, ID) = @RamaID AND Vencimiento > @Hoy ELSE
IF @Modulo = 'CXP' UPDATE Cxp SET TasaDiaria = @NuevaTasaDiaria WHERE ISNULL(RamaID, ID) = @RamaID AND Vencimiento > @Hoy
END
FETCH NEXT FROM crIntereses INTO @RamaID, @Moneda, @TipoCambio, @Concepto, @Proyecto, @UEN, @Contacto, @Tasa
END
CLOSE crIntereses
DEALLOCATE crIntereses
END
RETURN
END

