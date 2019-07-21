SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGasto
@ID                  	int,
@Modulo	      		char(5),
@Accion			char(20),
@Base			char(20),
@FechaRegistro		datetime,
@GenerarMov			char(20),
@Usuario			char(10),
@Conexion			bit,
@SincroFinal			bit,
@Mov	      			char(20)	OUTPUT,
@MovID            		varchar(20)	OUTPUT,
@IDGenerar			int		OUTPUT,
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Sucursal			int,
@SucursalDestino		int,
@SucursalOrigen		int,
@EnLinea			bit,
@PuedeEditar		bit,
@ValidarSucursal		bit,
@Empresa	      		char(5),
@MovTipo   			char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision     		datetime,
@FechaAfectacion		datetime,
@FechaConclusion		datetime,
@FechaRequerida		datetime,
@Proyecto	      		varchar(50),
@Actividad			varchar(50),
@AF				bit,
@AFArticulo			varchar(20),
@AFSerie			varchar(50),	
@MovUsuario	      		char(10),
@Autorizacion     		char(10),
@Importe			money,
@RetencionTotal		money,
@Impuestos			money,
@Saldo			money,
@Anticipo			money,
@DocFuente	      		int,
@CXP			bit,
@Observaciones    		varchar(255),
@Estatus          		char(15),
@EstatusNuevo		char(15),
@Ejercicio	      		int,
@Periodo	      		int,
@GenerarMovID		varchar(20),
@GenerarPoliza		bit,
@CfgContX			bit,
@CfgContXGenerar		char(20),
@CfgGastoCopiarImporte	bit,
@CfgGastoSolicitudAnticipoImpuesto bit,
@CfgRetencionMov		char(20),
@RetencionAlPago		bit,
@CfgRetencionAlPago		bit,
@CfgRetencionAcreedor	char(10),
@CfgRetencionConcepto	varchar(50),
@CfgRetencion2Acreedor	char(10),
@CfgRetencion2Concepto	varchar(50),
@CfgRetencion3Acreedor	char(10),
@CfgRetencion3Concepto	varchar(50),
@CfgGastoAutoCargos		bit,
@CfgBorradorComprobantes	bit,
@CfgBorradorCajaChica	bit,
@CfgGenerarAnticiposBorrador bit,
@CfgActividadDetalle	bit,
@CfgAFDetalle		bit,
@CfgProyectoDetalle		bit,
@CfgUENDetalle		bit,
@CfgClaseRequerida		bit,
@CfgValidarCC		bit,
@CfgConceptoCxp		bit,
@CfgPresupuestoPendiente	bit,
@ConceptoCxp		varchar(50),
@Clase			varchar(50),
@SubClase			varchar(50),
@MovAplica			char(20),
@MovAplicaID		varchar(20),
@Multiple			bit,
@Nota			varchar(100),
@AntecedenteID		int,
@AntecedenteSaldo		money,
@AntecedenteEstatus		char(15),
@AntecedenteImporteTotal	money,
@AntecedenteMovTipo		char(20),
@Acreedor		        char(10),
@AcreedorTipo		char(20),
@Periodicidad		char(20),
@Condicion			varchar(50),
@Vencimiento		datetime,
@CtaDinero			char(10),
@FormaPago			varchar(50),
@OrigenTipo			char(10),
@Origen			varchar(20),
@OrigenID			varchar(20),
@OrigenMovTipo		char(20),
@CfgRetencion2BaseImpuesto1	bit,
@CfgImpuesto2Info		bit,
@CfgImpuesto3Info		bit,
@UEN			int,
@AnexoModulo		char(5),
@AnexoID			int,
@Autorizar			bit,
@SubClave			varchar(20),
@Factor			int,
@MovFactor			varchar(20)/*,
@Verificar			bit*/
SELECT @MovFactor = Mov FROM Gasto WHERE ID = @ID
SELECT @Factor = Factor FROM MovTipo WHERE Modulo = @Modulo AND Mov = @MovFactor
SELECT @CfgImpuesto2Info = ISNULL(Impuesto2Info, 0),
@CfgImpuesto3Info = ISNULL(Impuesto2Info, 0),
@CfgRetencion2BaseImpuesto1 = ISNULL(Retencion2BaseImpuesto1, 0)
FROM Version
SELECT @CfgContX        = 0,
@CfgContXGenerar = 'NO',
@AcreedorTipo    = NULL,
@OrigenMovTipo	  = NULL,
@ValidarSucursal = 1,
@Autorizar       = 0,
@Nota            = NULL/*,
@Verificar	  = 1*/
IF @Accion = 'CANCELAR' SELECT @EstatusNuevo = 'CANCELADO' ELSE SELECT @EstatusNuevo = 'CONCLUIDO'
SELECT @Sucursal = Sucursal, @SucursalDestino = SucursalDestino, @SucursalOrigen = SucursalOrigen, @Empresa = Empresa, @MovID = MovID, @Mov = Mov, @MovMoneda = Moneda, @MovTipoCambio = TipoCambio, @FechaEmision = FechaEmision, @Proyecto = Proyecto,
@MovUsuario = Usuario, @Autorizacion = Autorizacion, @CXP = CXP,
@DocFuente = DocFuente, @Observaciones = Observaciones, @Estatus = UPPER(Estatus),
@Acreedor = NULLIF(RTRIM(Acreedor), ''), @Periodicidad = NULLIF(RTRIM(Periodicidad), ''), @Condicion = NULLIF(RTRIM(Condicion), ''), @Vencimiento = Vencimiento,
@CtaDinero = NULLIF(RTRIM(CtaDinero), ''), @FormaPago = NULLIF(RTRIM(FormaPago), ''),
@Importe = ISNULL(Importe, 0.0), @RetencionTotal = ISNULL(Retencion, 0.0), @Impuestos = ISNULL(Impuestos, 0.0), @Saldo = ISNULL(Saldo, 0.0),
@Anticipo = ISNULL(Anticipo, 0.0), @MovAplica = NULLIF(RTRIM(MovAplica), ''), @MovAplicaID = MovAplicaID, @Multiple = Multiple,
@GenerarPoliza = GenerarPoliza, @FechaConclusion = FechaConclusion,
@AnexoModulo = NULLIF(RTRIM(AnexoModulo), ''), @AnexoID = AnexoID,
@OrigenTipo = NULLIF(RTRIM(OrigenTipo), ''), @Origen = NULLIF(RTRIM(Origen), ''), @OrigenID = OrigenID, @UEN = UEN,
@Clase = NULLIF(RTRIM(Clase), ''), @SubClase = NULLIF(RTRIM(SubClase), ''),
@Actividad = Actividad, @AF = ISNULL(AF, 0), @AFArticulo = NULLIF(RTRIM(AFArticulo), ''), @AFSerie = NULLIF(RTRIM(AFSerie), ''), @Nota = Nota,
@FechaRequerida = FechaRequerida
FROM Gasto
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @AcreedorTipo = UPPER(Tipo)
FROM Prov
WHERE Proveedor = @Acreedor
IF @Accion = 'AUTORIZAR'
SELECT @Autorizacion = @Usuario, @Accion = 'AFECTAR'
IF @AcreedorTipo = 'ESTRUCTURA' SELECT @Ok = 20680
IF NULLIF(RTRIM(@Usuario), '') IS NULL SELECT @Usuario = @MovUsuario
EXEC spFechaAfectacion @Empresa, @Modulo, @ID, @Accion, @FechaEmision OUTPUT, @FechaRegistro, @FechaAfectacion OUTPUT
EXEC spExtraerFecha @FechaAfectacion OUTPUT
EXEC spMovTipo @Modulo, @Mov, @FechaAfectacion, @Empresa, NULL, NULL, @MovTipo OUTPUT, @Periodo OUTPUT, @Ejercicio OUTPUT, @Ok OUTPUT, @SubClave = @SubClave OUTPUT
EXEC spMovOk @SincroFinal, @ID, @Estatus, @Sucursal, @Accion, @Empresa, @Usuario, @Modulo, @Mov, @FechaAfectacion, @FechaRegistro, @Ejercicio, @Periodo, @Proyecto, @Ok OUTPUT, @OkRef OUTPUT
IF @Origen IS NOT NULL
SELECT @OrigenMovTipo = Clave FROM MovTipo WHERE Modulo = @OrigenTipo AND Mov = @Origen
IF @MovTipo NOT IN ('GAS.DA','GAS.ASC','GAS.SR')
SELECT @Importe = ISNULL(SUM(Importe), 0),
@RetencionTotal = SUM(ISNULL(Retencion, 0)+ISNULL(Retencion2, 0)+ISNULL(Retencion3, 0)),
@Impuestos = SUM(ISNULL(Impuestos, 0)+ISNULL(CASE WHEN @CfgImpuesto2Info = 1 THEN 0.0 ELSE Impuestos2 END, 0)+ISNULL(CASE WHEN @CfgImpuesto3Info = 1 THEN 0.0 ELSE Impuestos3 END, 0))
FROM GastoD
WHERE ID = @ID
IF @Ok IS NULL
BEGIN
IF @SucursalDestino IS NOT NULL AND @SucursalDestino <> @Sucursal AND @Accion = 'AFECTAR'
BEGIN
EXEC spSucursalEnLinea @SucursalDestino, @EnLinea OUTPUT
IF @EnLinea = 1
BEGIN
EXEC spMovConsecutivo @Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @Usuario, @Modulo, @Ejercicio, @Periodo, @ID, @Mov, NULL, @Estatus, NULL, @Accion, @Conexion, @SincroFinal, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spAsignarSucursalEstatus @ID, @Modulo, @SucursalDestino, NULL
SELECT @Sucursal = @SucursalDestino
END ELSE
SELECT @Accion = 'SINCRO'
END
IF @Estatus = 'SINCRO' AND @Accion = 'CANCELAR'
BEGIN
EXEC spPuedeEditarMovMatrizSucursal @Sucursal, @SucursalOrigen, @ID, @Modulo, @Empresa, @Usuario, @Mov, @Estatus, 1, @PuedeEditar OUTPUT
IF @PuedeEditar = 0
SELECT @Ok = 60300
ELSE BEGIN
SELECT @Estatus = 'SINAFECTAR'/*, @Verificar = 0*/
EXEC spAsignarSucursalEstatus @ID, @Modulo, @Sucursal, @Estatus
END
END
END
IF (@Accion <> 'CANCELAR' AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'PENDIENTE', 'RECURRENTE')) OR
(@Accion = 'CANCELAR'  AND @Estatus IN ('CONCLUIDO', 'PENDIENTE','RECURRENTE')) OR
(@Accion = 'GENERAR')
BEGIN
SELECT @CfgContX = ContX
FROM EmpresaGral
WHERE Empresa = @Empresa
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @CfgRetencionMov = CASE WHEN @MovTipo IN ('GAS.DG', 'GAS.DGP', 'GAS.DC') THEN CxpDevRetencion ELSE CxpRetencion END
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @CfgValidarCC = ISNULL(CentroCostosValidar, 0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @CfgGastoCopiarImporte = ISNULL(GastoCopiarImporte, 0),
@CfgGastoSolicitudAnticipoImpuesto = ISNULL(GastoSolicitudAnticipoImpuesto, 0),
@CfgRetencionAlPago    = ISNULL(RetencionAlPago, 0),
@CfgRetencionAcreedor  = NULLIF(RTRIM(GastoRetencionAcreedor), ''),
@CfgRetencionConcepto  = NULLIF(RTRIM(GastoRetencionConcepto), ''),
@CfgRetencion2Acreedor  = NULLIF(RTRIM(GastoRetencion2Acreedor), ''),
@CfgRetencion2Concepto  = NULLIF(RTRIM(GastoRetencion2Concepto), ''),
@CfgRetencion3Acreedor  = NULLIF(RTRIM(GastoRetencion3Acreedor), ''),
@CfgRetencion3Concepto  = NULLIF(RTRIM(GastoRetencion3Concepto), ''),
@CfgActividadDetalle	= ISNULL(GastoActividad, 0),
@CfgAFDetalle = GastoAFDetalle,
@CfgProyectoDetalle	= ISNULL(GastoProyectoDetalle, 0),
@CfgUENDetalle = GastoUENDetalle,
@CfgClaseRequerida = ISNULL(GastoClaseRequerida, 0),
@CfgGastoAutoCargos = ISNULL(GastoAutoCargos, 0),
@CfgBorradorComprobantes = ISNULL(GastoBorradorComprobantes, 0),
@CfgBorradorCajaChica = ISNULL(GastoBorradorCajaChica, 0),
@CfgGenerarAnticiposBorrador = ISNULL(GastoGenerarAnticiposBorrador,0),
@CfgConceptoCxp = ISNULL(GastoConceptoCxp, 0),
@CfgPresupuestoPendiente = ISNULL(GastoPresupuestoPendiente, 0)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF @@ERROR <> 0 SELECT @Ok = 1
IF @CfgContX = 1
SELECT @CfgContXGenerar = ContXGenerar
FROM EmpresaCfgModulo
WHERE Empresa = @Empresa
AND Modulo  = @Modulo
IF @@ERROR <> 0 SELECT @Ok = 1
IF (@MovTipo IN ('GAS.S', 'GAS.P', 'GAS.A') OR (@MovTipo = 'GAS.PR' AND @CfgPresupuestoPendiente = 1)) AND
@Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @Accion <> 'CANCELAR' SELECT @EstatusNuevo = 'PENDIENTE'
IF @MovTipo = 'GAS.GR' AND @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @Accion <> 'CANCELAR' SELECT @EstatusNuevo = 'RECURRENTE'
IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'SINCRO')
BEGIN
IF @CfgActividadDetalle = 0 UPDATE GastoD SET Actividad  = @Actividad  WHERE ID = @ID AND Actividad <> @Actividad
IF @CfgActividadDetalle = 1 UPDATE GastoD SET Actividad  = @Actividad  WHERE ID = @ID AND NULLIF(RTRIM(Actividad), '') IS NULL
IF @CfgProyectoDetalle  = 0 UPDATE GastoD SET Proyecto   = @Proyecto   WHERE ID = @ID AND Proyecto  <> @Proyecto
IF @CfgProyectoDetalle  = 1 UPDATE GastoD SET Proyecto   = @Proyecto   WHERE ID = @ID AND NULLIF(RTRIM(Proyecto), '') IS NULL
IF @CfgUENDetalle       = 0 UPDATE GastoD SET UEN        = @UEN        WHERE ID = @ID AND UEN <> @UEN
IF @CfgUENDetalle       = 1 UPDATE GastoD SET UEN        = @UEN        WHERE ID = @ID AND UEN IS NULL
IF @CfgAFDetalle        = 0 UPDATE GastoD SET AFArticulo = @AFArticulo, AFSerie = @AFSerie WHERE ID = @ID AND (AFArticulo <> @AFArticulo OR AFSerie <> @AFSerie)
IF @CfgAFDetalle        = 1 UPDATE GastoD SET AFArticulo = @AFArticulo, AFSerie = @AFSerie WHERE ID = @ID AND (NULLIF(RTRIM(AFArticulo), '') IS NULL OR NULLIF(RTRIM(AFSerie), '') IS NULL)
END
IF ((@Conexion = 0 OR @Accion = 'CANCELAR') AND @Accion NOT IN ('GENERAR', 'CONSECUTIVO'/*, 'SINCRO'*/) AND @Ok IS NULL) OR
(@Ok IS NULL AND @Accion = 'AFECTAR' AND @MovTipo = 'GAS.CI')
BEGIN
EXEC spGastoVerificar @ID, @Accion, @Empresa, @Usuario, @Autorizacion, @Modulo, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio, @FechaEmision, @Estatus,
@Acreedor, @Importe, @RetencionTotal, @Impuestos, @Saldo, @Condicion, @Vencimiento, @MovAplica, @MovAplicaID, @Multiple,
@Conexion, @SincroFinal, @Sucursal, @OrigenMovTipo, @FechaRequerida,
@AF, @AFArticulo, @AFSerie,
@Clase, @SubClase, @CfgClaseRequerida, @CfgValidarCC, @CfgConceptoCxp, @FormaPago, @ConceptoCxp OUTPUT,
@AntecedenteID OUTPUT, @AntecedenteEstatus OUTPUT, @AntecedenteSaldo OUTPUT, @AntecedenteImporteTotal OUTPUT, @AntecedenteMovTipo OUTPUT,
@Autorizar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Autorizar = 1
UPDATE Gasto SET Mensaje = @Ok WHERE ID = @ID
IF @Ok BETWEEN 80000 AND 89999 AND @Accion IN ('AFECTAR', 'CANCELAR') SELECT @Ok = NULL ELSE
IF @Accion = 'VERIFICAR' AND @Ok IS NULL
BEGIN
SELECT @Ok = 80000
EXEC xpOk_80000 @Empresa, @Usuario, @Accion, @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
END
IF @Accion IN ('AFECTAR', 'GENERAR', 'CANCELAR', 'CONSECUTIVO', 'SINCRO') AND @Ok IS NULL
BEGIN
SELECT @RetencionAlPago = ISNULL(RetencionAlPago, 0)
FROM Gasto
WHERE ID = @ID
IF @CfgRetencionAlPago = 1 SELECT @RetencionAlPago = 1
IF (@MovTipo IN ('GAS.C', 'GAS.CP', 'GAS.CCH', 'GAS.DC')) OR (@SubClave = 'GAS.GE/GT') SELECT @RetencionAlPago = 0
EXEC spGastoAfectar @ID, @Accion, @Base, @Empresa, @Modulo, @Mov, @MovID OUTPUT, @MovTipo, @MovMoneda, @MovTipoCambio, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Usuario, @Autorizacion, @DocFuente, @Observaciones,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo,
@Acreedor, @Periodicidad, @Condicion, @Vencimiento, @CtaDinero, @FormaPago, @Importe, @RetencionTotal, @Impuestos, @Saldo, @Anticipo, @MovAplica, @MovAplicaID, @Multiple, @Nota,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen,
@AntecedenteID, @AntecedenteEstatus, @AntecedenteSaldo, @AntecedenteImporteTotal, @AntecedenteMovTipo, @CXP, @Origen, @OrigenID, @OrigenMovTipo, @AnexoModulo, @AnexoID,
@CfgGastoCopiarImporte, @CfgGastoSolicitudAnticipoImpuesto,
@RetencionAlPago, @CfgRetencionMov, @CfgRetencionAcreedor, @CfgRetencionConcepto, @CfgRetencion2Acreedor, @CfgRetencion2Concepto, @CfgRetencion3Acreedor, @CfgRetencion3Concepto, @CfgContX, @CfgContXGenerar, @CfgGastoAutoCargos, @CfgBorradorComprobantes, @CfgBorradorCajaChica, @CfgGenerarAnticiposBorrador, @CfgConceptoCxp, @ConceptoCxp,
@GenerarPoliza, @GenerarMov, @IDGenerar OUTPUT, @GenerarMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END
END ELSE
BEGIN
IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @Accion = 'CANCELAR' EXEC spMovCancelarSinAfectar @Modulo, @ID, @Ok OUTPUT ELSE
IF @Estatus = 'AFECTANDO' SELECT @Ok = 80020 ELSE
IF @Estatus = 'CONCLUIDO' SELECT @Ok = 80010
IF @OrigenTipo <> 'PROY' SELECT @Ok = 60040, @OkRef = 'Estatus: '+@Estatus
END
IF @Accion = 'SINCRO' AND @Ok = 80060
BEGIN
SELECT @Ok = NULL, @OkRef = NULL
EXEC spSucursalEnLinea @SucursalDestino, @EnLinea OUTPUT
IF @EnLinea = 1 EXEC spSincroFinalModulo @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NOT NULL AND @OkRef IS NULL
IF @Ok = 80030
SELECT @OkRef = 'Movimiento: '+RTRIM(@GenerarMov)+' '+LTRIM(Convert(Char, @GenerarMovID))
ELSE
SELECT @OkRef = 'Movimiento: '+RTRIM(@Mov)+' '+LTRIM(Convert(Char, @MovID)), @IDGenerar = NULL
RETURN
END

