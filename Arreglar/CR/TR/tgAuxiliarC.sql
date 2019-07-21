SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgAuxiliarC ON Auxiliar

FOR UPDATE
AS BEGIN
DECLARE
@ConciliadoAnterior 	bit,
@ConciliadoNuevo		bit,
@Importe			money,
@Sucursal			int,
@Empresa            	char(5),
@Usuario			varchar(10),
@Rama	      		char(5),
@Moneda	       		char(10),
@Grupo	       		char(10),
@Cuenta	       		char(20),
@SubCuenta          	varchar(50),
@Modulo			char(5),
@ModuloID			int,
@Mov			char(20),
@MovID			varchar(20),
@MovTipo			varchar(20),
@FechaConciliacion		datetime,
@FechaAnterior		datetime,
@FechaRegistro		datetime,
@CfgConciliarEstatus	bit,
@Estatus			varchar(15),
@ModificarEstatus		bit,
@ContAuto			bit,
@ContAutoEstatus		varchar(15)
IF dbo.fnEstaSincronizando() = 1 RETURN
IF UPDATE(Conciliado) OR UPDATE(FechaConciliacion)
BEGIN
SELECT @ConciliadoAnterior = Conciliado,
@FechaAnterior      = FechaConciliacion
FROM Deleted
SELECT @ConciliadoNuevo    = Conciliado,
@Sucursal	       = Sucursal,
@Empresa            = RTRIM(Empresa),
@Rama	       = Rama,
@Moneda	       = Moneda,
@Grupo	       = Grupo,
@Cuenta	       = RTRIM(Cuenta),
@SubCuenta          = SubCuenta,
@Modulo	       = Modulo,
@ModuloID	       = ModuloID,
@Mov		       = RTRIM(Mov),
@MovID	       = RTRIM(MovID),
@FechaConciliacion  = FechaConciliacion
FROM Inserted
IF @ConciliadoNuevo <> @ConciliadoAnterior
BEGIN
SELECT @Estatus = NULL, @ModificarEstatus = 0
SELECT @CfgConciliarEstatus = ISNULL(DineroConciliarEstatus, 0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @ContAuto = ISNULL(ContAuto, 0)
FROM EmpresaGral
WHERE Empresa = @Empresa
IF @CfgConciliarEstatus = 1 AND @Modulo = 'DIN'
BEGIN
SELECT @Estatus = Estatus FROM Dinero WHERE ID = @ModuloID
IF (@ConciliadoNuevo = 1 AND @Estatus = 'CONCLUIDO') OR (@ConciliadoNuevo = 0 AND @Estatus = 'CONCILIADO')
BEGIN
IF @ConciliadoNuevo = 1 SELECT @Estatus = 'CONCILIADO' ELSE SELECT @Estatus = 'CONCLUIDO'
SELECT @ModificarEstatus = 1
END
END
SELECT @Importe = (ISNULL(Cargo, 0.0) - ISNULL(Abono, 0.0)) FROM Inserted
UPDATE Saldo WITH (ROWLOCK)
SET PorConciliar = CASE @ConciliadoNuevo WHEN 1 THEN ISNULL(PorConciliar, 0.0) - @Importe ELSE ISNULL(PorConciliar, 0.0) + @Importe END
WHERE Empresa   = @Empresa
AND Sucursal  = @Sucursal
AND Rama      = @Rama
AND Moneda    = @Moneda
AND Grupo     = @Grupo
AND Cuenta    = @Cuenta
AND SubCuenta = @SubCuenta
IF @Modulo = 'DIN'
BEGIN
UPDATE Dinero WITH (ROWLOCK) SET Conciliado       = @ConciliadoNuevo, FechaConciliacion       = @FechaConciliacion, Estatus = ISNULL(@Estatus, Estatus) WHERE ID = @ModuloID
UPDATE Cxc    WITH (ROWLOCK) SET DineroConciliado = @ConciliadoNuevo, DineroFechaConciliacion = @FechaConciliacion WHERE Empresa = @Empresa AND Dinero = @Mov AND DineroID = @MovID AND DineroCtaDinero = @Cuenta
UPDATE Cxp    WITH (ROWLOCK) SET DineroConciliado = @ConciliadoNuevo, DineroFechaConciliacion = @FechaConciliacion WHERE Empresa = @Empresa AND Dinero = @Mov AND DineroID = @MovID AND DineroCtaDinero = @Cuenta
UPDATE Gasto  WITH (ROWLOCK) SET DineroConciliado = @ConciliadoNuevo, DineroFechaConciliacion = @FechaConciliacion WHERE Empresa = @Empresa AND Dinero = @Mov AND DineroID = @MovID AND DineroCtaDinero = @Cuenta
UPDATE Venta  WITH (ROWLOCK) SET DineroConciliado = @ConciliadoNuevo, DineroFechaConciliacion = @FechaConciliacion WHERE Empresa = @Empresa AND Dinero = @Mov AND DineroID = @MovID AND DineroCtaDinero = @Cuenta
IF @CfgConciliarEstatus = 1 AND @ContAuto = 1 AND @ModificarEstatus = 1
BEGIN
SELECT @FechaRegistro = GETDATE()
IF @ConciliadoNuevo = 1 SELECT @ContAutoEstatus = @Estatus ELSE SELECT @ContAutoEstatus = 'CANCELADO'
SELECT @MovTipo = Clave FROM MovTipo WHERE Modulo = 'DIN' AND Mov = @Mov
SELECT @Usuario = Usuario FROM Dinero WHERE ID = @ModuloID
EXEC spMovContAuto @Empresa, @Sucursal, 'DIN', @ModuloID, 'CONCILIADO', @ContAutoEstatus, @Usuario, @FechaConciliacion, @FechaRegistro, @Mov, @MovID, @MovTipo, NULL, NULL, NULL
END
END
END
IF @FechaAnterior <> @FechaConciliacion AND @Modulo = 'DIN'
BEGIN
UPDATE Dinero WITH (ROWLOCK) SET FechaConciliacion       = @FechaConciliacion WHERE ID = @ModuloID
UPDATE Cxc    WITH (ROWLOCK) SET DineroFechaConciliacion = @FechaConciliacion WHERE Empresa = @Empresa AND Dinero = @Mov AND DineroID = @MovID AND DineroCtaDinero = @Cuenta
UPDATE Cxp    WITH (ROWLOCK) SET DineroFechaConciliacion = @FechaConciliacion WHERE Empresa = @Empresa AND Dinero = @Mov AND DineroID = @MovID AND DineroCtaDinero = @Cuenta
UPDATE Gasto  WITH (ROWLOCK) SET DineroFechaConciliacion = @FechaConciliacion WHERE Empresa = @Empresa AND Dinero = @Mov AND DineroID = @MovID AND DineroCtaDinero = @Cuenta
UPDATE Venta  WITH (ROWLOCK) SET DineroFechaConciliacion = @FechaConciliacion WHERE Empresa = @Empresa AND Dinero = @Mov AND DineroID = @MovID AND DineroCtaDinero = @Cuenta
END
END
END

