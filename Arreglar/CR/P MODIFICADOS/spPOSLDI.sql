SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSLDI
@Servicio				varchar(20),
@ID					varchar(36),
@NoTarjeta				varchar(36),
@Empresa               varchar(5),
@Usuario               varchar(10),
@Sucursal              int,
@NoTarjetaReemplazo	varchar(36) = NULL,
@Importe				float = NULL,
@EnSilencio			bit = 0,
@NoTelefono			varchar(10) = NULL,
@Ok					int = NULL	OUTPUT,
@OkRef					varchar(255) = NULL OUTPUT,
@Modulo				varchar(5) = 'POS',
@Cuenta                varchar(255) = NULL,
@Referencia            varchar(255) = NULL,
@RIDCobro              int = NULL,
@ADO                   bit = 0,
@Mes                   varchar(2) = NULL,
@Ano                   varchar(4) = NULL,
@FechaD                datetime = NULL,
@FechaA                datetime = NULL

AS
BEGIN
DECLARE
@Cadena					nvarchar(2048),
@CadenaRespuesta		nvarchar(2048),
@MensajeError			nvarchar(2048),
@DireccionIP			varchar(15),
@Puerto					varchar(10),
@TiempoEspera			nvarchar(4),
@Cliente				varchar(10),
@ImporteOUT				varchar(20),
@OkLDI	                varchar(255),
@OkRefLDI	            varchar(500),
@Mensaje	            varchar(255),
@Voucher	            varchar(MAX),
@Voucher2	            varchar(MAX),
@Banco	                varchar(255),
@IDLDI                  int,
@MonedaMonedero         varchar(10),
@Moneda                 varchar(10),
@TipoCambio             float,
@MonederoTipoCambio		float
IF (SELECT ISNULL(VentaMonederoA,0) FROM EmpresaCfg2 WITH (NOLOCK) WHERE Empresa = @Empresa) = 1 AND @Servicio LIKE 'MON %'
RETURN
IF @Modulo = 'POS'
IF NOT EXISTS (SELECT * FROM POSL WITH (NOLOCK) WHERE ID = @ID)
SELECT @Ok = 14055
IF @Modulo = 'NOM'
IF NOT EXISTS (SELECT * FROM Nomina WITH (NOLOCK) WHERE ID = @ID)
SELECT @Ok = 14055
DELETE POSLDIIDTemp WHERE Estacion = @@SPID
SELECT @TiempoEspera = '45'
SELECT
@DireccionIP = pls.DireccionIP,
@Puerto = pls.Puerto
FROM POSLDIServicio pls WITH (NOLOCK)
WHERE pls.Servicio = @Servicio
IF @Ok IS NULL
EXEC spPOSLDIGeneraCadena @Servicio, @ID, @NoTarjeta, @NoTarjetaReemplazo, @Cadena OUTPUT, @Importe, @NoTelefono, @Modulo, @Ok OUTPUT, @OkRef OUTPUT, @Cuenta, @Referencia, @Mes = @Mes, @Ano = @Ano, @FechaD = @FechaD, @FechaA = @FechaA
IF @OK IS NULL
EXEC usp_EnviarMensaje @Cadena, @DireccionIP, @Puerto, @TiempoEspera, @CadenaRespuesta OUTPUT, @MensajeError OUTPUT
IF NULLIF(@CadenaRespuesta,'') IS NULL
SELECT @Ok = 2, @OkRef ='El Proveedor No envio Ninguna Respuesta'
/* Determina si fue exitosa o hubo error */
EXEC spPOSLDIAnalizaCadena @CadenaRespuesta, '14', @OkLDI OUTPUT
/* Si @MensajeError Es diferente de NULL, significa que hubo error de conexion */
IF @MensajeError IS NOT NULL
SELECT @Ok = 2, @OkRef = @MensajeError
/* Determina el voucher */
EXEC spPOSLDIAnalizaCadena @CadenaRespuesta, '163', @Voucher OUTPUT
EXEC spPOSLDIAnalizaCadena @CadenaRespuesta, '27', @Banco OUTPUT
IF @Voucher IS NOT NULL OR @Banco IS NOT NULL AND @Modulo = 'POS'
BEGIN
INSERT POSLRefBancaria (ID, Voucher, Banco)
VALUES                (@ID, @Voucher, @Banco)
SELECT @Voucher2 = REPLACE(@Voucher,'^',':')
IF NOT EXISTS (SELECT * FROM POSLDIVentaID WITH (NOLOCK) WHERE ID = @ID)
INSERT POSLDIVentaID(ID,Referencia2)
SELECT              @ID,@Voucher2
IF EXISTS (SELECT * FROM POSLDIVentaID WITH (NOLOCK) WHERE ID = @ID)
UPDATE POSLDIVentaID WITH (ROWLOCK) SET Referencia2= @Voucher2 WHERE ID = @ID
END
/* Si @OKLDI es diferente de 0, es que hubo error de LDI o de los proveedores de servicio*/
IF @Ok IS NULL AND @OkLDI <> 0
BEGIN
EXEC spPOSLDIAnalizaCadena @CadenaRespuesta, '16', @OkRefLDI OUTPUT
SELECT @Ok = 2, @OkRef = 'El Proveedor de transacción mandó el mensaje ' + @OkRefLDI
END
IF @Ok IS NULL
BEGIN
/* Inserta el dato del monedero solo cuando se dio de alta*/
IF @Servicio = 'MON ALTA NUEVO'
BEGIN
EXEC spPOSLDIAnalizaCadena @Cadena, '41', @Cliente OUTPUT
INSERT POSLDIMonedero (Monedero, Cliente)
VALUES (@NoTarjeta, @Cliente)
IF @Modulo = 'POS'
EXEC spPOSAltaMonedero @ID, @Usuario, @Empresa ,@Sucursal, @Cliente, @NoTarjeta, @Ok OUTPUT
IF @Ok IS NULL
SELECT @Mensaje = 'Monedero Registrado Exitosamente'
END
IF @Servicio = 'MON CONSULTA'
BEGIN
DELETE POSLDISaldoMonederoTemp
WHERE Estacion = @@SPID
SELECT @MonedaMonedero = Moneda, @Cliente = Cliente
FROM POSValeSerie WITH (NOLOCK)
WHERE Serie = @NoTarjeta
SELECT @Moneda = Moneda, @TipoCambio = TipoCambio
FROM POSLTipoCambioRef WITH (NOLOCK)
WHERE EsPrincipal = 1 AND Sucursal = @Sucursal
SELECT @MonederoTipoCambio = TipoCambio
FROM POSLTipoCambioRef WITH (NOLOCK)
WHERE Sucursal = @Sucursal AND Moneda = @MonedaMonedero
EXEC spPOSLDIAnalizaCadena @CadenaRespuesta, '45', @Importe OUTPUT
SELECT @Mensaje = 'El Saldo del Monedero es de :<BR>' + dbo.fnFormatoMoneda(@Importe,@Empresa)+' '+
@MonedaMonedero+'<BR>'+ CASE WHEN @Moneda <> @MonedaMonedero THEN dbo.fnFormatoMoneda(dbo.fnImporteMonTarjeta(@Importe, ISNULL(NULLIF(@MonedaMonedero,''),'Pesos'), ISNULL(@MonederoTipoCambio,1), ISNULL(NULLIF(@Moneda,''),'Pesos'), ISNULL(@TipoCambio,1), @Sucursal ),@Empresa)+' '+@Moneda ELSE '' END+
'<BR> Desea Imprimir El Saldo?'
IF @Ok IS NULL
INSERT POSLDISaldoMonederoTemp(
Estacion, Monedero, Cliente, MonedaMonedero, TipoCambio, Importe, ImporteMonedaSuc)
SELECT
@@SPID, @NoTarjeta, @Cliente, @MonedaMonedero, @MonederoTipoCambio, @Importe, @TipoCambio
END
/* Inserta el dato del monedero solo cuando se hizo una modificacion*/
IF @Servicio = 'MON ALTA MODIFICA'
BEGIN
UPDATE POSLDIMonedero WITH (ROWLOCK) SET Monedero = @NoTarjetaReemplazo
WHERE Monedero = @NoTarjeta
END
IF @Servicio IN ('IUSACELL', 'MOVISTAR', 'NEXTEL', 'TELCEL', 'UNEFON')
BEGIN
SELECT @Mensaje = 'Recarga Exitosa'
IF NOT EXISTS (SELECT * FROM POSLDIVentaID WITH (NOLOCK) WHERE ID = @ID)
INSERT POSLDIVentaID (
ID, Referencia1)
SELECT
@ID, @NoTelefono
IF EXISTS (SELECT * FROM POSLDIVentaID WITH (NOLOCK) WHERE ID = @ID)
UPDATE POSLDIVentaID WITH (ROWLOCK) SET Referencia1= @NoTelefono WHERE ID = @ID
END
END
IF @CadenaRespuesta IS NOT NULL
BEGIN
INSERT POSLDILog(
IDModulo, Servicio, Modulo, Cadena, CadenaRespuesta, Importe, RIDCobro, Fecha, TipoTransaccion,
TipoSubservicio, CodigoRespuesta, DescripcionRespuesta, OrigenRespuesta, InfoAdicional, IDTransaccion,
CodigoAutorizacion, Comprobante, TotalRegistros, ListaMontos, ListaReferencias, ListaFechas,
ListaConceptos, ListaMovimientos)
SELECT
@ID, @Servicio, @Modulo, @Cadena, @CadenaRespuesta, @Importe, @RIDCobro, *
FROM(SELECT Parametro, Valor FROM dbo.fnPOSLDISeparaCadena (@CadenaRespuesta)) tabla
PIVOT( MAX(Valor)
FOR [Parametro] IN ([[3], [7], [56], [14], [16], [13], [27],  [8], [50],  [163], [111],[45],[51],[149],[174],[239])) p
SELECT @IDLDI = SCOPE_IDENTITY()
UPDATE POSLDILog WITH (ROWLOCK) SET   Comprobante = REPLACE(REPLACE(REPLACE(Comprobante,'^',':'),'@dd',':'),CHAR(10),'<BR>')
WHERE  ID = @IDLDI
INSERT POSLDIIDTemp(ID,Estacion) SELECT @IDLDI, @@SPID
IF @Servicio IN('EDOCTAMES','EDOCTAPERIODO')
EXEC spPOSReporteEdoCtaLDI @IDLDI
END
IF @EnSilencio = 0
SELECT @Ok, @OkRef, @Mensaje, @CadenaRespuesta, @Cadena
IF @ADO = 1
BEGIN
IF EXISTS(SELECT * FROM POSLDIRespuestaTemp WITH (NOLOCK) WHERE ID = @ID)
DELETE POSLDIRespuestaTemp WHERE ID = @ID
INSERT POSLDIRespuestaTemp(
ID, Ok, OkRef, Mensaje, CadenaRespuesta, Cadena, IDLog)
SELECT
@ID, @Ok, @OkRef, @Mensaje, @CadenaRespuesta, @Cadena, @IDLDI
END
END

