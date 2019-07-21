SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInteresesDevengados
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
@UEN			int
SELECT @ID = NULL
SELECT @CfgMov = CASE @Modulo
WHEN 'CXC' THEN NULLIF(RTRIM(CxcInteresesDevengados), '')
WHEN 'CXP' THEN NULLIF(RTRIM(CxpInteresesDevengados), '')
END
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
IF @Ok IS NULL
BEGIN
IF @Modulo = 'CXC'
DECLARE crIntereses CURSOR FOR
SELECT ISNULL(c.RamaID, c.ID), m.Moneda, m.TipoCambio, c.Concepto, c.Proyecto, c.UEN, c.Cliente, SUM(ISNULL(c.Saldo*ISNULL(mt.Factor, 1)*(c.TasaDiaria/100.0)/**DATEDIFF(day, ISNULL(UltimoDevengado, FechaEmision), @Hoy)*/, 0))
FROM Cxc c, Mon m, MovTipo mt
WHERE c.Empresa = @Empresa
AND m.Moneda = c.Moneda
AND c.Estatus = 'PENDIENTE'
AND mt.Modulo = @Modulo AND mt.Mov = c.Mov AND mt.Clave IN ('CXC.F', 'CXC.FAC', 'CXC.CA', 'CXC.CAD', 'CXC.D', 'CXC.DAC', 'CXC.A', 'CXC.AR', 'CXC.DA', 'CXC.NC', 'CXC.NCD', 'CXC.NCF', 'CXC.DV')
AND ISNULL(c.Saldo, 0) > 0.0 AND NULLIF(c.TasaDiaria, 0) IS NOT NULL AND c.Vencimiento > @Hoy
GROUP BY ISNULL(c.RamaID, c.ID), m.Moneda, m.TipoCambio, c.Concepto, c.Proyecto, c.UEN, c.Cliente
ELSE
IF @Modulo = 'CXP'
DECLARE crIntereses CURSOR FOR
SELECT ISNULL(c.RamaID, c.ID), m.Moneda, m.TipoCambio, c.Concepto, c.Proyecto, c.UEN, c.Proveedor, SUM(ISNULL(c.Saldo*ISNULL(mt.Factor, 1)*(c.TasaDiaria/100.0)/**DATEDIFF(day, ISNULL(UltimoDevengado, FechaEmision), @Hoy)*/, 0))
FROM Cxp c, Mon m, MovTipo mt
WHERE c.Empresa = @Empresa
AND m.Moneda = c.Moneda
AND c.Estatus = 'PENDIENTE'
AND mt.Modulo = @Modulo AND mt.Mov = c.Mov AND mt.Clave IN ('CXP.F', 'CXP.FAC', 'CXP.CA', 'CXP.CAD', 'CXP.D', 'CXP.DAC', 'CXP.A', 'CXP.DA', 'CXP.NC', 'CXP.NCD', 'CXP.NCF')
AND ISNULL(c.Saldo, 0) > 0.0 AND NULLIF(c.TasaDiaria, 0) IS NOT NULL AND c.Vencimiento > @Hoy
GROUP BY ISNULL(c.RamaID, c.ID), m.Moneda, m.TipoCambio, c.Concepto, c.Proyecto, c.UEN, c.Proveedor
OPEN crIntereses
FETCH NEXT FROM crIntereses INTO @RamaID, @Moneda, @TipoCambio, @Concepto, @Proyecto, @UEN, @Contacto, @Importe
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL AND NULLIF(@Importe, 0) IS NOT NULL
BEGIN
IF @Modulo = 'CXC'
INSERT Cxc (OrigenTipo, Sucursal,  Empresa,  Mov,     FechaEmision,  Moneda,  TipoCambio,  Importe,  Usuario,   Estatus,     UltimoCambio,   Cliente,   ClienteMoneda, ClienteTipoCambio, RamaID,  Concepto,  Proyecto,  UEN)
VALUES ('AUTO/ID',  @Sucursal, @Empresa, @CfgMov, @Hoy,          @Moneda, @TipoCambio, @Importe, @Usuario, 'SINAFECTAR', @FechaRegistro, @Contacto, @Moneda,       @TipoCambio,       @RamaID, @Concepto, @Proyecto, @UEN)
ELSE
IF @Modulo = 'CXP'
INSERT Cxp (OrigenTipo, Sucursal,  Empresa,  Mov,     FechaEmision,  Moneda,  TipoCambio,  Importe,  Usuario,  Estatus,      UltimoCambio,   Proveedor, ProveedorMoneda, ProveedorTipoCambio,   RamaID,  Concepto,  Proyecto,  UEN)
VALUES ('AUTO/ID',  @Sucursal, @Empresa, @CfgMov, @Hoy,          @Moneda, @TipoCambio, @Importe, @Usuario, 'SINAFECTAR', @FechaRegistro, @Contacto, @Moneda,         @TipoCambio, 	  @RamaID, @Concepto, @Proyecto, @UEN)
SELECT @ID = SCOPE_IDENTITY()
EXEC spCx @ID, @Modulo, 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @MovGenerar OUTPUT, @MovIDGenerar OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SELECT @Conteo = @Conteo + 1
END
FETCH NEXT FROM crIntereses INTO @RamaID, @Moneda, @TipoCambio, @Concepto, @Proyecto, @UEN, @Contacto, @Importe
END
CLOSE crIntereses
DEALLOCATE crIntereses
END
RETURN
END

