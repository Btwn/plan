SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContAutoGetDatos
@Modulo		char(5),
@ID			int,
@ContID		int		= NULL OUTPUT,
@Poliza		varchar(20)	= NULL OUTPUT,
@PolizaID		varchar(20)	= NULL OUTPUT,
@Concepto		varchar(50)	= NULL OUTPUT,
@Proyecto		varchar(50)	= NULL OUTPUT,
@UEN			int		= NULL OUTPUT,
@OrigenTipo		varchar(10)	= NULL OUTPUT,
@CtaClase		varchar(20)	= NULL OUTPUT,
@CtaCtoTipo		varchar(20)	= NULL OUTPUT,
@CtaCtoTipoAplica	varchar(20)	= NULL OUTPUT,
@Contacto		varchar(10)	= NULL OUTPUT,
@CtaDinero		varchar(10)	= NULL OUTPUT,
@CtaDineroDestino	varchar(10)	= NULL OUTPUT,
@FormaPago		varchar(50)	= NULL OUTPUT,
@ConDesglose		bit		= NULL OUTPUT,
@GenerarPoliza	bit		= NULL OUTPUT,
@ContactoTipo	varchar(20)	= NULL OUTPUT,
@ContactoSubTipo	varchar(20)	= NULL OUTPUT,
@Clase		varchar(50)	= NULL OUTPUT,
@SubClase		varchar(50)	= NULL OUTPUT,
@Intercompania	bit		= NULL OUTPUT,
@OrigenMoneda	varchar(10)	= NULL OUTPUT,
@OrigenTipoCambio	float		= NULL OUTPUT,
@CentroCostosSucursal varchar(20)    = NULL OUTPUT,
@CentroCostosDestino  varchar(20)    = NULL OUTPUT,
@CentroCostosMatriz	 varchar(20)    = NULL OUTPUT,
@RetencionPorcentaje	float		= NULL OUTPUT,
@Directo		bit		= NULL OUTPUT,
@ContactoAplica	varchar(10)	= NULL OUTPUT

AS BEGIN
DECLARE
@Empresa			char(5),
@MovSucursal		int,
@MovAplica			varchar(20),
@MovAplicaID		varchar(20),
@AlmacenDestino		char(10),
@ContactoTipoAplica 	varchar(20),
@ContactoSubTipoAplica 	varchar(20)
SELECT @ContactoTipo = NULL, @ContactoSubTipo = NULL, @Contacto = NULL, @Clase = NULL, @SubClase = NULL, @CtaClase = NULL, @CtaCtoTipo = NULL, @CtaCtoTipoAplica = NULL, @Concepto = NULL, @Proyecto = NULL, @UEN = NULL, @OrigenTipo = NULL, @CtaDinero = NULL, @CtaDineroDestino = NULL, @FormaPago = NULL, @ConDesglose = 0, @OrigenMoneda = NULL, @OrigenTipoCambio = NULL,
@CentroCostosSucursal = NULL, @CentroCostosDestino = NULL, @CentroCostosMatriz = NULL, @AlmacenDestino = NULL, @RetencionPorcentaje = NULL, @Directo = 0, @ContactoAplica = NULL
IF @Modulo = 'DIN'   SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @ContactoTipo = ContactoTipo, @Contacto = Contacto,  @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto, @CtaDinero = CtaDinero, @CtaDineroDestino = CtaDineroDestino, @ConDesglose = ConDesglose, @Directo = Directo, @FormaPago = FormaPago FROM Dinero WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @ContactoTipo = 'Proveedor',  @Contacto = Proveedor, @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto, @Directo = Directo FROM Compra WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @ContactoTipo = 'Cliente',    @Contacto = Cliente,   @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto FROM Vale WITH (NOLOCK)  WHERE ID = @ID ELSE
IF @Modulo = 'CR'    SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @ContactoTipo = 'Agente',     @Contacto = Cajero,    @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto FROM CR WITH (NOLOCK)    WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, /*@OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, */@ContactoTipo = 'Cliente',    @Contacto = Cliente,   @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto FROM Cambio WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @ContactoTipo = 'Cliente',    @Contacto = Cliente,   @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto, @CtaDinero = CtaDinero, @MovAplica = MovAplica, @MovAplicaID = MovAplicaID FROM Cxc WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @ContactoTipo = 'Proveedor',  @Contacto = Proveedor, @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto, @CtaDinero = CtaDinero, @MovAplica = MovAplica, @MovAplicaID = MovAplicaID FROM Cxp WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @ContactoTipo = 'Cliente',    @Contacto = Cliente,   @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto, @Clase = Clase, @SubClase = SubClase, @RetencionPorcentaje = NULLIF(CONVERT(float,Retencion), 0.0)/NULLIF(CONVERT(float,Importe), 0.0)*100, @Directo = Directo FROM Venta WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @ContactoTipo = 'Proveedor',  @Contacto = Acreedor,  @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @CtaDinero = CtaDinero, @Clase = Clase, @SubClase = SubClase FROM Gasto WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'AF'    SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @ContactoTipo = 'Proveedor',  @Contacto = Proveedor, @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto FROM ActivoFijo WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @ContactoTipo = 'Agente',     @Contacto = Agente,    @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto FROM Agent WITH (NOLOCK)  WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto, @Directo = Directo FROM Prod WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'INV'   SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto, @AlmacenDestino = NULLIF(RTRIM(AlmacenDestino), ''), @Directo = Directo FROM Inv WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto  FROM Embarque WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto  FROM Nomina WITH (NOLOCK) 	WHERE ID = @ID ELSE
IF @Modulo = 'RH'    SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto  FROM RH WITH (NOLOCK) 	WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN		          FROM Asiste WITH (NOLOCK)	WHERE ID = @ID ELSE
IF @Modulo = 'PC'    SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto  FROM PC WITH (NOLOCK) 	WHERE ID = @ID ELSE
IF @Modulo = 'ST'    SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, /*@OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, */@OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto  FROM Soporte WITH (NOLOCK)  WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto  FROM Capital WITH (NOLOCK)     WHERE ID = @ID ELSE
IF @Modulo = 'INC'   SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto  FROM Incidencia WITH (NOLOCK)  WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto  FROM Conciliacion WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto  FROM Presup WITH (NOLOCK)      WHERE ID = @ID ELSE
IF @Modulo = 'CP'    SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto  FROM CP WITH (NOLOCK)          WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' SELECT @Empresa = Empresa, @MovSucursal = ISNULL(SucursalDestino, Sucursal), @Poliza = Poliza, @PolizaID = PolizaID, @ContID = ContID, @GenerarPoliza = GenerarPoliza, @OrigenMoneda = Moneda, @OrigenTipoCambio = TipoCambio, @OrigenTipo = OrigenTipo, @Proyecto = Proyecto, @UEN = UEN, @Concepto = Concepto  FROM Credito WITH (NOLOCK)     WHERE ID = @ID
SELECT @Concepto = NULLIF(RTRIM(@Concepto), '')
EXEC spContactoSubTipo @Contacto, @ContactoTipo, @ContactoSubTipo OUTPUT, @Intercompania OUTPUT
SELECT @CtaCtoTipo = Cuenta FROM CtoTipo WITH (NOLOCK) WHERE Tipo = @ContactoTipo AND SubTipo = @ContactoSubTipo
IF @Clase IS NOT NULL
EXEC spCuentaClase @Modulo, @Clase, @SubClase, @CtaClase OUTPUT
SELECT @CentroCostosSucursal = CentroCostos FROM Sucursal WITH (NOLOCK) WHERE Sucursal = @MovSucursal
IF @AlmacenDestino IS NOT NULL
SELECT @CentroCostosDestino = s.CentroCostos FROM Alm a WITH (NOLOCK), Sucursal s WITH (NOLOCK) WHERE a.Almacen = @AlmacenDestino AND a.Sucursal = s.Sucursal
SELECT @CentroCostosMatriz = CentroCostos FROM Sucursal WITH (NOLOCK) WHERE Sucursal = 0
/*
IF @Modulo IN ('CXC', 'CXP') AND @MovAplica IS NOT NULL AND @MovAplicaID IS NOT NULL
BEGIN
IF @Modulo = 'CXC' SELECT @ContactoAplica = Cliente   FROM Cxc WHERE Empresa = @Empresa AND Mov = @MovAplica AND MovID = @MovAplicaID AND Estatus IN ('PENDIENTE', 'CONCLUIDO') ELSE
IF @Modulo = 'CXP' SELECT @ContactoAplica = Proveedor FROM Cxp WHERE Empresa = @Empresa AND Mov = @MovAplica AND MovID = @MovAplicaID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
END ELSE*/
IF @Modulo IN ('CXC', 'CXP') AND @MovAplica IS NOT NULL AND @MovAplicaID IS NOT NULL
BEGIN
IF @Modulo = 'CXC' SELECT @ContactoAplica = Cliente,   @ContactoTipoAplica = 'CLIENTE'   FROM Cxc WITH (NOLOCK) WHERE Empresa = @Empresa AND Mov = @MovAplica AND MovID = @MovAplicaID AND Estatus IN ('PENDIENTE', 'CONCLUIDO') ELSE
IF @Modulo = 'CXP' SELECT @ContactoAplica = Proveedor, @ContactoTipoAplica = 'PROVEEDOR' FROM Cxp WITH (NOLOCK) WHERE Empresa = @Empresa AND Mov = @MovAplica AND MovID = @MovAplicaID AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
EXEC spContactoSubTipo @ContactoAplica, @ContactoTipoAplica, @ContactoSubTipoAplica OUTPUT, @Intercompania OUTPUT
SELECT @CtaCtoTipoAplica = Cuenta FROM CtoTipo WITH (NOLOCK) WHERE Tipo = @ContactoTipoAplica AND SubTipo = @ContactoSubTipoAplica
END ELSE
IF @Modulo = 'DIN' SELECT @ContactoAplica = @CtaDineroDestino ELSE
IF @Modulo = 'INV' SELECT @ContactoAplica = @AlmacenDestino ELSE
IF @Modulo = 'COMS'
BEGIN
IF (SELECT CompraAutoEndoso FROM EmpresaCfg WITH (NOLOCK) WHERE Empresa = @Empresa) = 1
SELECT @ContactoAplica = AutoEndoso FROM Prov WITH (NOLOCK) WHERE Proveedor = @Contacto
END
IF @ContactoAplica = @Contacto SELECT @ContactoAplica = NULL
RETURN
END

