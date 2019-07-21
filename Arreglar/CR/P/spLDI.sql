SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLDI
@Servicio			varchar(20),
@ID			varchar(36),
@NoTarjeta			varchar(36),
@Empresa                   varchar(5),
@Usuario                   varchar(10),
@Sucursal                  int,
@NoTarjetaReemplazo	varchar(36) = NULL,
@Importe			float = NULL,
@EnSilencio		bit = 0,
@NoTelefono		varchar(10) = NULL,
@Ok			int = NULL	OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT,
@Modulo			varchar(5) = NULL,
@Cuenta                    varchar(255) = NULL,
@Referencia                varchar(255) = NULL,
@RIDCobro                  int = NULL,
@ADO                       bit = 0,
@EsCancelacion             bit = 0,
@EsConsulta                bit = 0,
@Mes                       varchar(2) = NULL,
@Ano                       varchar(4) = NULL,
@FechaD                    datetime = NULL,
@FechaA                    datetime = NULL,
@Accion                    varchar(20) = NULL,
@Estatus                   varchar(20) = NULL,
@Estacion                  int = NULL,
@EstacionFija              int = NULL

AS BEGIN
DECLARE @Cadena			nvarchar(2048),
@CadenaRespuesta		nvarchar(2048),
@MensajeError			nvarchar(2048),
@DireccionIP			varchar(15),
@Puerto			varchar(10),
@TiempoEspera			nvarchar(4),
@Cliente			varchar(10),
@ImporteOUT			varchar(20),
@OkLDI	                varchar(255),
@OkRefLDI	                varchar(500),
@Mensaje	                varchar(255),
@Voucher	                varchar(MAX),
@Voucher2	                varchar(MAX),
@Banco	                varchar(255),
@IDLDI                        int,
@MonedaMonedero               varchar(10),
@Moneda                       varchar(10),
@TipoCambio                   float,
@MonederoTipoCambio           float
IF (SELECT ISNULL(VentaMonederoA,0) FROM EmpresaCfg2 WHERE Empresa = @Empresa) = 1 
RETURN
IF @Accion = 'CANCELAR'
SELECT @Ok = 60050
IF @Modulo = 'POS'
IF NOT EXISTS (SELECT * FROM POSL WHERE ID = @ID)
SELECT @Ok = 14055
IF @Modulo = 'NOM'
IF NOT EXISTS (SELECT * FROM Nomina WHERE ID = @ID)
SELECT @Ok = 14055
IF @Modulo = 'VTAS'
IF NOT EXISTS (SELECT * FROM Venta WHERE ID = @ID)
SELECT @Ok = 14055
DELETE LDIIDTemp WHERE Estacion = @@SPID
/* Tiempo Espera, es el tiempo maximo que la DLL local, espera respuesta del servidor de LDI, en caso de no recibirla en ese tiempo, responderá cadena con error */
SELECT @TiempoEspera = '45'
/* Determina la direccion a donde se enviara */
SELECT @DireccionIP = pls.DireccionIP,
@Puerto = pls.Puerto
FROM LDIServicio pls
WHERE pls.Servicio = @Servicio
IF @Servicio ='TDCLDI' AND NULLIF(@EstacionFija,0) IS NOT NULL
SELECT @DireccionIP = DireccionIP, @Puerto = Puerto
FROM LDIServicioEstacion
WHERE EstacionFija = @EstacionFija
IF @Ok IS NULL
EXEC spLDIGeneraCadena @Servicio, @ID, @NoTarjeta, @NoTarjetaReemplazo, @Cadena OUTPUT, @Importe, @NoTelefono, @Modulo, @Ok OUTPUT, @OkRef OUTPUT, @Cuenta, @Referencia, @EsCancelacion, @EsConsulta, @Empresa, @Sucursal, @Mes, @Ano, @FechaD, @FechaA
IF @OK IS NULL
EXEC usp_EnviarMensaje @Cadena, @DireccionIP, @Puerto, @TiempoEspera, @CadenaRespuesta OUTPUT, @MensajeError OUTPUT
IF NULLIF(@CadenaRespuesta,'') IS NULL
SELECT @Ok = 2, @OkRef ='El Proveedor No envio Ninguna Respuesta'
/* Determina si fue exitosa o hubo error */
EXEC spLDIAnalizaCadena @CadenaRespuesta, '14', @OkLDI OUTPUT
/* Si @MensajeError Es diferente de NULL, significa que hubo error de conexion */
IF @MensajeError IS NOT NULL
SELECT @Ok = 2, @OkRef = @MensajeError
/* Determina el voucher */
EXEC spLDIAnalizaCadena @CadenaRespuesta, '163', @Voucher OUTPUT
EXEC spLDIAnalizaCadena @CadenaRespuesta, '27', @Banco OUTPUT
/* Si @OKLDI es diferente de 0, es que hubo error de LDI o de los proveedores de servicio*/
IF @Ok IS NULL AND @OkLDI <> 0
BEGIN
EXEC spLDIAnalizaCadena @CadenaRespuesta, '16', @OkRefLDI OUTPUT
SELECT @Ok = 2, @OkRef = 'El Proveedor de transacción mandó el mensaje ' + @OkRefLDI
END
IF @Ok IS NULL
BEGIN
/* Inserta el dato del monedero solo cuando se dio de alta*/
IF @Servicio = 'MON ALTA NUEVO'
BEGIN
EXEC spLDIAnalizaCadena @Cadena, '41', @Cliente OUTPUT
IF @Modulo = 'POS'
BEGIN
EXEC spPOSAltaMonedero @ID, @Usuario, @Empresa ,@Sucursal, @Cliente, @NoTarjeta, @Ok OUTPUT
INSERT POSLDIMonedero (Monedero,   Cliente)
VALUES (@NoTarjeta, @Cliente)
END
IF @Ok IS NULL
SELECT @Mensaje = 'Monedero Registrado Exitosamente'
END
IF @Servicio = 'MON CONSULTA'AND @Modulo = 'POS'
BEGIN
DELETE POSLDISaldoMonederoTemp WHERE Estacion = @@SPID
SELECT @MonedaMonedero = Moneda, @Cliente = Cliente FROM POSValeSerie WHERE Serie = @NoTarjeta
SELECT @Moneda = Moneda, @TipoCambio = TipoCambio FROM POSLTipoCambioRef WHERE EsPrincipal = 1 AND Sucursal = @Sucursal
SELECT @MonederoTipoCambio = TipoCambio FROM POSLTipoCambioRef WHERE Sucursal = @Sucursal AND Moneda = @MonedaMonedero
EXEC spLDIAnalizaCadena @CadenaRespuesta, '45', @Importe OUTPUT
SELECT @Mensaje = 'El Saldo del Monedero es de :<BR>' + dbo.fnFormatoMoneda(@Importe,@Empresa)+' '+@MonedaMonedero+'<BR>'+
CASE WHEN @Moneda <> @MonedaMonedero THEN dbo.fnFormatoMoneda(dbo.fnImporteMonTarjeta(@Importe, ISNULL(NULLIF(@MonedaMonedero,''),'Pesos'), ISNULL(@MonederoTipoCambio,1), ISNULL(NULLIF(@Moneda,''),'Pesos'), ISNULL(@TipoCambio,1), @Sucursal ),@Empresa)+' '+@Moneda ELSE '' END+
'<BR> Desea Imprimir El Saldo?'
IF @Ok IS NULL
INSERT POSLDISaldoMonederoTemp(Estacion, Monedero,  Cliente, MonedaMonedero,  TipoCambio,          Importe,  MonedaSucursal, ImporteMonedaSuc)
SELECT                         @@SPID,   @NoTarjeta,@Cliente,   @MonedaMonedero, @MonederoTipoCambio, @Importe,  @Moneda,dbo.fnImporteMonTarjeta(@Importe, ISNULL(NULLIF(@MonedaMonedero,''),'Pesos'), ISNULL(@MonederoTipoCambio,1), ISNULL(NULLIF(@Moneda,''),'Pesos'), ISNULL(@TipoCambio,1), @Sucursal )
END
IF @Servicio = 'MON CONSULTA' AND @Modulo <> 'POS'
BEGIN
EXEC spLDIAnalizaCadena @CadenaRespuesta, '45', @Importe OUTPUT
SELECT @Mensaje = 'El Saldo del Monedero es de ' + dbo.fnFormatoMoneda(@Importe,@Empresa)
END
/* Inserta el dato del monedero solo cuando se hizo una modificacion*/
IF @Servicio = 'MON ALTA MODIFICA'
BEGIN
UPDATE POSLDIMonedero SET Monedero = @NoTarjetaReemplazo
WHERE Monedero = @NoTarjeta
END
END
IF @CadenaRespuesta IS NOT NULL
BEGIN
INSERT LDIMovLog(IDModulo, Servicio,  Modulo,  Cadena,  CadenaRespuesta,  Importe,  RIDCobro,  Fecha, TipoTransaccion, TipoSubservicio,CodigoRespuesta, DescripcionRespuesta, OrigenRespuesta, InfoAdicional, IDTransaccion,CodigoAutorizacion,Comprobante, TotalRegistros, ListaMontos, ListaReferencias, ListaFechas, ListaConceptos, ListaMovimientos   )
SELECT           @ID,      @Servicio, @Modulo, @Cadena, @CadenaRespuesta, @Importe, @RIDCobro, *
FROM(SELECT Parametro,Valor FROM dbo.fnLDISeparaCadena (@CadenaRespuesta)) tabla
PIVOT( MAX(Valor)
FOR [Parametro] IN ([[3], [7], [56], [14], [16], [13], [27],  [8], [50],  [163], [111],[45],[51],[149],[174],[239])) p
SELECT @IDLDI = SCOPE_IDENTITY()
UPDATE LDIMovLog SET   Comprobante = REPLACE(REPLACE(REPLACE(Comprobante,'^',':'),'@dd',':'),CHAR(10),'<BR>') ,Fecha = dbo.fnLDIFecha(Fecha)
WHERE  ID = @IDLDI
INSERT LDIIDTemp(ID,Estacion, Modulo) SELECT @IDLDI, @@SPID ,@Modulo
IF @Servicio IN('EDOCTAMES','EDOCTAPERIODO')
BEGIN
EXEC spPOSReporteEdoCtaLDI @IDLDI, @Importe
END
END
ELSE
INSERT LDIMovLog(IDModulo, Servicio,  Modulo,  Cadena,  CadenaRespuesta,                          Importe,   RIDCobro,  Fecha,   DescripcionRespuesta, OrigenRespuesta, InfoAdicional, IDTransaccion,CodigoAutorizacion,Comprobante   )
SELECT           @ID,      @Servicio, @Modulo, @Cadena, '27:'+@OkRef+'16:'+CONVERT(varchar,@Ok),  @Importe, @RIDCobro,  GETDATE(),'','','','','',''
IF @EnSilencio = 0
SELECT @Ok, @OkRef, @Mensaje, @CadenaRespuesta, @Cadena
IF @ADO = 1
BEGIN
IF EXISTS(SELECT * FROM POSLDIRespuestaTemp WHERE ID = @ID)
DELETE POSLDIRespuestaTemp WHERE ID = @ID
INSERT POSLDIRespuestaTemp(ID,  Ok,  OkRef,  Mensaje,  CadenaRespuesta,  Cadena, IDLog)
SELECT                     @ID, @Ok, @OkRef, @Mensaje, @CadenaRespuesta, @Cadena, @IDLDI
END
END

