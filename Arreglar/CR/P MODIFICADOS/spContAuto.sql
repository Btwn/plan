SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContAuto
@Empresa		char(5),
@Sucursal		int,
@Modulo		char(5),
@ID			int,
@Estatus		char(15),
@EstatusNuevo	char(15),
@Usuario		char(10),
@FechaEmision	datetime,
@FechaRegistro 	datetime,
@Mov			char(20),
@MovID		varchar(20),
@MovTipo		char(20),
@ContMov		char(20),
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT,
@ContAutoEmpresa	varchar(10)	= '(Todas)'

AS BEGIN
DECLARE
@Hoy			datetime,
@FechaPoliza		datetime,
@Referencia			varchar(50),
@Concepto			varchar(50),
@Proyecto			varchar(50),
@UEN			int,
@Contacto			varchar(10),
@ContactoTipo		varchar(20),
@ContactoAplica		varchar(10),
@ContID			int,
@ContMovID			varchar(20),
@ContMoneda			char(10),
@ContTipoCambio		float,
@ContContacto		varchar(10),
@ContContactoTipo		varchar(20),
@ContFechaEmision		datetime,
@ContFechaContable		datetime,
@SaveOk			int,
@SaveOkRef			varchar(255),
@CfgClaseConceptoGastos 	bit,
@CfgPartidasSinImporte  	bit,
@CfgRegistro		bit,
@CfgConsolidacion   	bit,
@CfgTipoFilial		varchar(20),
@CfgCancelarMismoMes 	bit,
@CfgContArticulo		bit,
@GenerarPoliza		bit,
@Poliza			varchar(20),
@PolizaID			varchar(20),
@ContSucursal		int,
@ContSucursalOrigen		int,
@ContEstatus		varchar(15),
@PermitirCancelacionOrigen	bit,
@PuedeEditar		bit,
@CancelarID			int,
@CancelarMov		char(20),
@CancelarMovID		varchar(20),
@FechaTrabajo		datetime,
@Intercompania		bit,
@OrigenMoneda 		varchar(10),
@OrigenTipoCambio 		float,
/* Variable para tener el modulo inicial*/
@ModuloInicial      char(5)
IF @Modulo = 'DIN'  SELECT @ModuloInicial = OrigenTipo FROM Dinero WITH (NOLOCK) WHERE ID = @ID
IF @Modulo = 'CXC'  SELECT @ModuloInicial = OrigenTipo FROM Cxc WITH (NOLOCK) WHERE ID = @ID
IF @Modulo = 'CXP'  SELECT @ModuloInicial = OrigenTipo FROM Cxp WITH (NOLOCK) WHERE ID = @ID
IF @Modulo = 'CONC' SELECT @ModuloInicial = @Modulo
SELECT @SaveOk = @Ok, @SaveOkRef = @OkRef
SELECT @Ok = NULL, @OkRef = NULL, @ContID = NULL, @Intercompania = 0, @OrigenMoneda = NULL, @OrigenTipoCambio = NULL
SELECT @ContMoneda = cfg.ContMoneda, @ContTipoCambio = m.TipoCambio, @PermitirCancelacionOrigen = ISNULL(ContPermitirCancelacionOrigen, 0)
FROM Mon m WITH (NOLOCK), EmpresaCfg cfg WITH (NOLOCK)
WHERE cfg.Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
SELECT @CfgContArticulo = ISNULL(ContArticulo, 0)
FROM EmpresaCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @CfgCancelarMismoMes = ContAutoCancelarMismoMes
FROM EmpresaGral WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @Hoy = @FechaRegistro
EXEC spExtraerFecha @Hoy OUTPUT
EXEC xpContAuto @Empresa, @Sucursal, @Modulo,  @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @ContMov, @Ok OUTPUT, @OkRef OUTPUT, @Referencia OUTPUT
IF @EstatusNuevo = 'CANCELADO'
BEGIN
EXEC spContAutoGetDatos @Modulo, @ID,
@ContID OUTPUT, @Poliza OUTPUT, @PolizaID OUTPUT
IF @ContID IS NOT NULL
BEGIN
SELECT @PuedeEditar = 1
SELECT @ContMov = Mov,
@ContSucursal = Sucursal,
@ContSucursalOrigen = SucursalOrigen,
@ContEstatus = Estatus,
@ContContacto = Contacto,
@ContContactoTipo = ContactoTipo,
@ContFechaEmision = FechaEmision,
@ContFechaContable = FechaContable
FROM Cont WITH (NOLOCK)
WHERE ID = @ContID
EXEC spPuedeEditarMovMatrizSucursal @ContSucursal, @ContSucursalOrigen, @ContID, 'CONT', @Empresa, @Usuario, @ContMov, @ContEstatus, 1, @PuedeEditar OUTPUT
IF @PuedeEditar = 1 AND ((DATEPART(month, @FechaEmision)=DATEPART(month, @FechaRegistro) AND DATEPART(year, @FechaEmision)=DATEPART(year, @FechaRegistro))
OR (@CfgCancelarMismoMes = 1))
BEGIN
IF NOT (@PermitirCancelacionOrigen = 1 AND (NOT EXISTS(SELECT * FROM Cont WITH (NOLOCK) WHERE ID = @ContID AND Estatus IN ('CONCLUIDO', 'SINCRO'))))
BEGIN
EXEC spCont @ContID, 'CONT', 'CANCELAR', 'TODO', @FechaRegistro, NULL, @Usuario,  1, 0,
@ContMov OUTPUT, @ContMovID OUTPUT,  NULL, @Ok OUTPUT, @OkRef OUTPUT, @ContAuto = 1, @ModuloInicial = @ModuloInicial
EXEC spCancelarFlujo @Empresa, 'CONT', @ContID, @Ok OUTPUT
END
END ELSE
BEGIN
SELECT @FechaTrabajo = @FechaRegistro
EXEC spExtraerFecha @FechaTrabajo OUTPUT
SELECT @CancelarMov = @Poliza, @CancelarMovID = NULL
EXEC @CancelarID = spMovCopiar @Sucursal, 'CONT', @ContID, @Usuario, @FechaTrabajo, 1
IF @CfgCancelarMismoMes = 1 UPDATE Cont WITH (ROWLOCK) SET FechaEmision = @ContFechaEmision, FechaContable = @ContFechaContable WHERE ID = @CancelarID
UPDATE ContD WITH (ROWLOCK)
SET Debe=-Debe, Haber=-Haber, Debe2=-Debe2, Haber2=-Haber2
WHERE ID = @CancelarID
UPDATE Cont WITH (ROWLOCK)
SET Contacto = @ContContacto,
ContactoTipo = @ContContactoTipo
WHERE ID = @CancelarID
EXEC spCont @CancelarID, 'CONT', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario,  1, 0,
@CancelarMov OUTPUT, @CancelarMovID OUTPUT,  NULL, @Ok OUTPUT, @OkRef OUTPUT, @ContAuto = 1, @ModuloInicial = @ModuloInicial
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @ID, @Mov, @MovID, 'CONT', @CancelarID, @CancelarMov, @CancelarMovID, @Ok OUTPUT
END
END
END ELSE
BEGIN
SELECT @CfgClaseConceptoGastos = ISNULL(ContAutoClaseConceptoGastos, 0),
@CfgPartidasSinImporte  = ISNULL(ContAutoPartidasSinImporte, 0),
@CfgConsolidacion       = ISNULL(ContAutoConsolidacion, 0),
@CfgTipoFilial          = ContAutoCteTipoFilial,
@CfgRegistro		   = ISNULL(Registro, 0)
FROM EmpresaGral WITH (NOLOCK)
WHERE Empresa = @Empresa
CREATE TABLE #Poliza (
Renglon			float		NULL,
RenglonSub		int		NULL,
Presupuesto		bit		NULL	DEFAULT 0,
Orden			int		NULL,
Cuenta			char(20) 	COLLATE Database_Default NULL,
SubCuenta 		varchar(50) 	COLLATE Database_Default NULL,
SubCuenta2 		varchar(50) 	COLLATE Database_Default NULL,
SubCuenta3 		varchar(50) 	COLLATE Database_Default NULL,
SucursalContable		int		NULL,
Concepto			varchar(50) 	COLLATE Database_Default NULL,
ContactoEspecifico	varchar(20)	COLLATE Database_Default NULL,
Articulo			varchar(20)	COLLATE Database_Default NULL,
DepartamentoDetallista 	int		NULL,
Debe			money		NULL,
Haber			money		NULL,
Campo			varchar(20)	COLLATE Database_Default NULL,
ContactoTipo		varchar(20)	COLLATE Database_Default NULL) 
CREATE INDEX Presupuesto ON #Poliza(Presupuesto)
CREATE INDEX Cuenta ON #Poliza(Cuenta)
CREATE INDEX Consulta ON #Poliza(Presupuesto, Orden, Cuenta, SubCuenta, SucursalContable, Concepto, ContactoEspecifico, Articulo, DepartamentoDetallista)
IF @EstatusNuevo = 'CANCELADO' AND @CfgCancelarMismoMes = 0 SELECT @FechaPoliza = @Hoy ELSE SELECT @FechaPoliza = @FechaEmision
EXEC spContAutoPoliza @Empresa, @Sucursal, @Modulo,  @ID, @Mov, @MovID, @MovTipo, @Estatus, @EstatusNuevo, @Usuario, @FechaPoliza, @FechaRegistro, @CfgClaseConceptoGastos, @Concepto OUTPUT, @Proyecto OUTPUT, @UEN OUTPUT, @Contacto OUTPUT, @ContactoTipo OUTPUT, @ContactoAplica OUTPUT, @Intercompania OUTPUT, @OrigenMoneda OUTPUT, @OrigenTipoCambio OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @CfgPartidasSinImporte, @CfgConsolidacion, @CfgTipoFilial, @CfgContArticulo, @ContAutoEmpresa = @ContAutoEmpresa
IF @Ok IS NULL
EXEC spContAutoRegistrar @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaPoliza, @FechaRegistro, @Mov, @MovID, @MovTipo,
@ContMov, @ContMovID, @ContMoneda, @ContTipoCambio, @Referencia, @Concepto, @Proyecto, @UEN, @Contacto, @ContactoTipo, @ContactoAplica, @Intercompania, @OrigenMoneda, @OrigenTipoCambio, @CfgPartidasSinImporte, @CfgRegistro,
@Ok OUTPUT, @OkRef OUTPUT, @ModuloInicial = @ModuloInicial
END
IF @Ok IS NULL
SELECT @Ok = @SaveOk, @OkRef = @SaveOkRef
RETURN
END

