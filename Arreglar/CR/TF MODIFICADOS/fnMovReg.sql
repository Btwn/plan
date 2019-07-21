SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMovReg (@Modulo char(5), @ID int)
RETURNS @Resultado
TABLE (Modulo char(5), ID int, Mov char(20), MovID varchar(20), Estatus char(15), Sucursal int, UEN int, FechaEmision datetime, Empresa char(5), CtoTipo varchar(20), Contacto char(10), EnviarA int,
Situacion varchar(50), SituacionFecha datetime, SituacionUsuario varchar(10), SituacionNota varchar(100), Proyecto varchar(50), Concepto varchar(50), Referencia varchar(50), Usuario char(10), MovTipo varchar(20), Ejercicio int, Periodo int,
FechaCancelacion datetime, Clase varchar(50), SubClase varchar(50), Causa varchar(50), FormaEnvio varchar(50), Condicion varchar(50), ZonaImpuesto varchar(30), CtaDinero varchar(10),
Cajero varchar(10), Moneda varchar(10), TipoCambio float, Deudor char(10), Acreedor char(10), Personal char(10), Agente char(10), Importe money, ImporteMN money, ContID int)

AS BEGIN
DECLARE
@Mov		char(20),
@MovID		varchar(20),
@Estatus		char(15),
@Sucursal		int,
@UEN		int,
@FechaEmision	datetime,
@Empresa		char(5),
@CtoTipo		varchar(20),
@Contacto		char(10),
@EnviarA		int,
@Deudor		char(10),
@Acreedor		char(10),
@Personal		char(10),
@Agente		char(10),
@Situacion		varchar(50),
@SituacionFecha	datetime,
@SituacionUsuario	varchar(10),
@SituacionNota	varchar(100),
@Proyecto		varchar(50),
@Concepto		varchar(50),
@Referencia		varchar(50),
@Usuario		char(10),
@MovTipo		varchar(20),
@Ejercicio		int,
@Periodo		int,
@FechaCancelacion 	datetime,
@Clase		varchar(50),
@SubClase		varchar(50),
@Causa		varchar(50),
@FormaEnvio		varchar(50),
@Condicion		varchar(50),
@ZonaImpuesto	varchar(30),
@CtaDinero		varchar(10),
@Cajero		varchar(10),
@Moneda		varchar(10),
@TipoCambio 	float,
@Importe		money,
@ImporteMN		money,
@ContID		int,
@AutoEndoso		varchar(10)
IF @ID IS NOT NULL
SELECT @Mov = NULL, @MovID = NULL
IF @Modulo = 'VTAS'  SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @CtoTipo = 'Cliente',    @Contacto = Cliente,   @EnviarA = EnviarA, @Clase = Clase, @SubClase = SubClase, @Causa = Causa, @FormaEnvio = FormaEnvio, @Condicion = Condicion, @ZonaImpuesto = ZonaImpuesto, @Moneda = Moneda, @TipoCambio = TipoCambio, @CtaDinero = CtaDinero, @Agente = Agente, @Importe = Importe FROM Venta WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @CtoTipo = 'Cliente',    @Contacto = Cliente,   @EnviarA = ClienteEnviarA, @Condicion = Condicion, @Moneda = Moneda, @TipoCambio = TipoCambio, @Cajero = Cajero, @CtaDinero = CtaDinero, @Agente = Agente, @Importe = Importe FROM Cxc WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'ST'    SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @CtoTipo = 'Cliente',    @Contacto = Cliente,   @EnviarA = EnviarA, @Clase = Clase, @SubClase = SubClase, @Agente = Agente, @Importe = Importe FROM Soporte WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @CtoTipo = 'Proveedor',  @Contacto = Proveedor, @Causa = Causa, @FormaEnvio = FormaEnvio, @Condicion = Condicion, @ZonaImpuesto = ZonaImpuesto, @Moneda = Moneda, @TipoCambio = TipoCambio, @Agente = Agente, @Importe = Importe FROM Compra WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @CtoTipo = 'Proveedor',  @Contacto = Proveedor, @Condicion = Condicion, @Moneda = Moneda, @TipoCambio = TipoCambio, @Cajero = Cajero, @CtaDinero = CtaDinero, @Importe = Importe FROM Cxp WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @CtoTipo = 'Agente',     @Contacto = Agente,    @Moneda = Moneda, @TipoCambio = TipoCambio, @CtaDinero = CtaDinero, @Importe = Importe FROM Agent WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = NULL,     @Referencia = NULL,       @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @CtoTipo = 'Proveedor',  @Contacto = Acreedor,  @Clase = Clase, @SubClase = SubClase, @Condicion = Condicion, @Moneda = Moneda, @TipoCambio = TipoCambio, @CtaDinero = CtaDinero, @Importe = Importe FROM Gasto WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @CtoTipo = ContactoTipo, @Contacto = Contacto,  @Moneda = Moneda, @TipoCambio = TipoCambio, @Cajero = Cajero, @CtaDinero = CtaDinero, @Importe = Importe FROM Dinero WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'AF'    SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @CtoTipo = 'Proveedor',  @Contacto = Proveedor, @Condicion = Condicion, @Moneda = Moneda, @TipoCambio = TipoCambio, @CtaDinero = CtaDinero, @Importe = Importe FROM ActivoFijo WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @CtoTipo = 'Cliente',    @Contacto = Cliente,   @Condicion = Condicion, @Moneda = Moneda, @TipoCambio = TipoCambio, @CtaDinero = CtaDinero, @Agente = Agente, @Importe = Importe FROM Vale WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CR'    SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @CtoTipo = 'Agente',     @Contacto = Cajero,    @Moneda = Moneda, @TipoCambio = TipoCambio, @Cajero = Cajero FROM CR WITH(NOLOCK) WHERE ID = @ID  ELSE
IF @Modulo = 'CAM'   SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @CtoTipo = 'Cliente',    @Contacto = Cliente,   @Agente = Agente FROM Cambio WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' SELECT @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @CtoTipo = ContactoTipo,    @Contacto = (CASE ContactoTipo WHEN 'Cliente' THEN Cliente WHEN 'Prospecto' THEN Prospecto WHEN 'Proveedor' THEN Proveedor WHEN 'Personal' THEN Personal WHEN 'Agente' THEN Agente ELSE NULL END),   @Agente = Agente, @Moneda = Moneda, @TipoCambio = TipoCambio FROM Contrato WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Moneda = Moneda, @TipoCambio = TipoCambio FROM Capital WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'INC'   SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Moneda = Moneda, @TipoCambio = TipoCambio FROM Incidencia WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Moneda = Moneda, @TipoCambio = TipoCambio FROM Conciliacion WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Moneda = Moneda, @TipoCambio = TipoCambio FROM Presup WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Moneda = Moneda, @TipoCambio = TipoCambio FROM Credito WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   SELECT /*@ContID = ContID, */@FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN FROM TMA WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   SELECT /*@ContID = ContID, */@FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN FROM RSS WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   SELECT /*@ContID = ContID, */@FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN FROM Campana WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Moneda = Moneda, @TipoCambio = TipoCambio FROM Fiscal WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN FROM ContParalela WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Moneda = Moneda, @TipoCambio = TipoCambio FROM Oportunidad WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' SELECT @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN FROM Corte WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   SELECT /*@ContID = ContID, */@FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN FROM FormaExtra WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  SELECT /*@ContID = ContID, */@FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN FROM Captura WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'GES'   SELECT /*@ContID = ContID, */@FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN FROM Gestion WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CP'    SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Moneda = Moneda, @TipoCambio = TipoCambio FROM CP WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Moneda = Moneda, @TipoCambio = TipoCambio FROM PCP WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  SELECT /*@ContID = ContID, */@FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, /*@Proyecto = Proyecto, */@Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Moneda = Moneda, @TipoCambio = TipoCambio FROM Proyecto WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, /*@Proyecto = Proyecto, */@Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Moneda = Moneda, @TipoCambio = TipoCambio FROM Organiza WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'RE'    SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, /*@Proyecto = Proyecto, */@Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Moneda = Moneda, @TipoCambio = TipoCambio FROM Recluta WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, /*@Proyecto = Proyecto, */@Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Moneda = Moneda, @TipoCambio = TipoCambio FROM ISL WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CONT'  SELECT /*@ContID = ContID, */@FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Moneda = Moneda, @TipoCambio = TipoCambio, @Importe = Importe, @CtoTipo = ContactoTipo, @Contacto = Contacto FROM Cont WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Moneda = Moneda, @TipoCambio = TipoCambio, @Importe = Importe FROM Prod WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'INV'   SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @FormaEnvio = FormaEnvio, @Condicion = Condicion, @Moneda = Moneda, @TipoCambio = TipoCambio, @Agente = Agente, @Importe = Importe FROM Inv WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PC'    SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Moneda = Moneda, @TipoCambio = TipoCambio FROM PC WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Moneda = Moneda, @TipoCambio = TipoCambio FROM Oferta WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = NULL,       @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Condicion = Condicion, @Moneda = Moneda, @TipoCambio = TipoCambio FROM Nomina WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'RH'    SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Moneda = Moneda, @TipoCambio = TipoCambio FROM RH WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = NULL,     @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Moneda = Moneda, @TipoCambio = TipoCambio FROM Asiste WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   SELECT @ContID = ContID, @FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN, @Condicion = Condicion, @Moneda = Moneda, @TipoCambio = TipoCambio, @CtaDinero = CtaDinero, @Agente = Agente, @Importe = Importe FROM Embarque WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  SELECT /*@ContID = ContID, */@FechaEmision = FechaEmision, @FechaCancelacion = FechaCancelacion, @Ejercicio = Ejercicio, @Periodo = Periodo, @Empresa = Empresa, @Usuario = Usuario, @Proyecto = Proyecto, @Concepto = Concepto, @Referencia = Referencia, @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = SituacionUsuario, @SituacionNota = SituacionNota, @UEN = UEN FROM SAUX WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'COMS' AND (SELECT CompraAutoEndoso FROM EmpresaCfg WITH(NOLOCK) WHERE Empresa = @Empresa) = 1
BEGIN
SELECT @AutoEndoso = NULL
SELECT @AutoEndoso = NULLIF(RTRIM(AutoEndoso), '') FROM Prov WITH(NOLOCK) WHERE Proveedor = @Contacto
IF @AutoEndoso IS NOT NULL SELECT @Contacto = @AutoEndoso
END
SELECT @MovTipo = Clave FROM MovTipo WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov
IF @CtoTipo = 'Cliente'   SELECT @Deudor   = @Contacto ELSE
IF @CtoTipo = 'Proveedor' SELECT @Acreedor = @Contacto ELSE
IF @CtoTipo = 'Agente'    SELECT @Agente   = @Contacto ELSE
IF @CtoTipo = 'Personal'  SELECT @Personal = @Contacto
SELECT @ImporteMN = @Importe * @TipoCambio
INSERT @Resultado (
Modulo,  ID,  Mov,  MovID,  Estatus,  Sucursal,  UEN,  FechaEmision,  Empresa,  CtoTipo,  Contacto,  EnviarA,  Situacion,  SituacionFecha,  SituacionUsuario,  SituacionNota,  Proyecto,  Concepto,  Referencia,  Usuario,  MovTipo,  Ejercicio,  Periodo,  FechaCancelacion,  Clase,  SubClase,  Causa,  FormaEnvio,  Condicion,  ZonaImpuesto,  CtaDinero,  Cajero,  Moneda,  TipoCambio,  Deudor,  Acreedor,  Personal,  Agente,  Importe,  ImporteMN,  ContID)
VALUES (@Modulo, @ID, @Mov, @MovID, @Estatus, @Sucursal, @UEN, @FechaEmision, @Empresa, @CtoTipo, @Contacto, @EnviarA, @Situacion, @SituacionFecha, @SituacionUsuario, @SituacionNota, @Proyecto, @Concepto, @Referencia, @Usuario, @MovTipo, @Ejercicio, @Periodo, @FechaCancelacion, @Clase, @SubClase, @Causa, @FormaEnvio, @Condicion, @ZonaImpuesto, @CtaDinero, @Cajero, @Moneda, @TipoCambio, @Deudor, @Acreedor, @Personal, @Agente, @Importe, @ImporteMN, @ContID)
RETURN
END

