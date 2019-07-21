SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLDIGeneraCadena
@Servicio			varchar(20),
@ID			varchar(36),
@NoTarjeta			varchar(36),
@NoTarjetaReemplazo	varchar(36),
@Cadena			nvarchar(2048) OUTPUT,
@Importe			float = NULL,
@NoTelefono		varchar(10) = NULL,
@Modulo			varchar(5),
@Ok			int	OUTPUT,
@OkRef			varchar(255) OUTPUT,
@Cuenta                    varchar(255) = NULL,
@Referencia                varchar(255) = NULL,
@EsCancelacion             bit = 0,
@EsConsulta                bit = 0,
@Empresa                   varchar(5) = NULL,
@Sucursal                  int = NULL,
@Mes                       varchar(2) = NULL,
@Ano                       varchar(4) = NULL,
@FechaD                    datetime = NULL,
@FechaA                    datetime = NULL

AS BEGIN
DECLARE @Separador		        varchar(1),
@CadenaRespuesta	        nvarchar(max),
@MensajeError		        nvarchar(MAX),
@ReferenciaLDI                varchar(255),
@CuentaLDI                    varchar(255),
@NoTarjetaLDI		        varchar(45),
@NoTarjetaReemplazoLDI	varchar(45),
@NoTelefonoLDI	        varchar(45),
@EmpresaLDI		        varchar(20),
@SucursalLDI		        varchar(20),
@Caja			        varchar(20),
@CajaLDI		        varchar(30),
@FechaEmision			datetime,
@FechaEmisionLDI		varchar(16),
@FechaEmisionEjercicio	varchar(4),
@FechaEmisionPeriodo		varchar(2),
@FechaEmisionDia		varchar(2),
@FechaEmisionHora		varchar(2),
@FechaEmisionMinuto		varchar(2),
@FechaEmisionSegundo		varchar(2),
@Cliente			varchar(20),
@ClienteLDI			varchar(20),
@MovID			varchar(20),
@MovIDLDI			varchar(30),
@ImporteLDI			varchar(30),
@ServicioLDI			varchar(30),
@TrxType			varchar(10),
@TrxTypeLDI			varchar(20),
@TrxSubType			varchar(10),
@TrxSubTypeLDI		varchar(20),
@EntryMode			varchar(10),
@EntryModeLDI			varchar(20),
@GeneraVoucher		varchar(10),
@GeneraVoucherLDI		varchar(20),
@AnchoVoucher			int,
@AnchoVoucherLDI		varchar(20),
@Tipo				varchar(20),
@TipoLDI			varchar(30),
@TransaccionesManuales	varchar(50),
@Consulta                     varchar(50),
@ConceptoMonedero             varchar(50),
@PuntosLDI                    varchar(50),
@TrxID                        int,
@TrxIDLDI                     varchar(50),
@AutCode                      varchar(50),
@AutCodeLDI                   varchar(50),
@LDIMes                       varchar(50),
@LDIAno                       varchar(50),
@LDIFechaD                    varchar(50),
@LDIFechaA                    varchar(50),
@Consecutivo                  varchar(50),
@NotasLDI                     varchar(50)
/* Siempre el separador de campos será ; y el string se abrira con {	   */
SELECT @Separador = ';',
@Cadena = '{'
/* Aqui jala los campos del movimiento */
IF @Modulo = 'POS'
BEGIN
SELECT @Empresa = pl.Empresa,
@Sucursal = pl.Sucursal,
@Caja = ISNULL(NULLIF(CONVERT(varchar,c.ClaveLDI),''),'1'),
@FechaEmision = GETDATE(),
@MovID ='a'+ pl.MovID,
@Cliente = pl.Cliente
FROM POSL pl WITH (NOLOCK)  LEFT JOIN CtaDinero c ON pl.CtaDinero = c.CtaDinero
WHERE pl.ID = @ID
END
IF @Modulo = 'VTAS'
BEGIN
SELECT @Empresa = v.Empresa,
@Sucursal = v.Sucursal,
@Caja = '1',
@FechaEmision = GETDATE(),
@MovID = v.MovID,
@Cliente = v.Cliente
FROM Venta v  WITH (NOLOCK) LEFT JOIN CtaDinero c WITH (NOLOCK)  ON v.CtaDinero = c.CtaDinero
WHERE v.ID = @ID
END
IF @Modulo = 'VALE'
BEGIN
SELECT @Empresa = n.Empresa,
@Sucursal = n.Sucursal,
@Caja = '1',
@FechaEmision = GETDATE(),
@MovID = n.MovID ,
@Cliente = ISNULL(Cliente,''),
@Consecutivo = n.Mov+' '+n.MovID
FROM Vale n WITH (NOLOCK) 
WHERE n.ID = @ID
END
IF @Modulo = 'PV'
BEGIN
SELECT @Caja = '1', @FechaEmision = GETDATE(),@Cliente =''
END
/* Determina los Datos del Servicio */
SELECT @TrxType = pls.TrxType,
@TrxSubType = pls.TrxSubType,
@EntryMode = pls.EntryMode,
@GeneraVoucher = pls.GeneraVoucher,
@AnchoVoucher = pls.AnchoVoucher,
@Tipo = pls.Tipo
FROM LDIServicio pls WITH (NOLOCK) 
WHERE pls.Servicio = @Servicio
/* Determina el numero de Originador (Sucursal) asignado por LDI */
SELECT @SucursalLDI = '1:' + SucursalLDI
FROM Sucursal WITH (NOLOCK) 
WHERE Sucursal = @Sucursal
SELECT @FechaEmision = GETDATE()
/* Determina el numero de Nodo (Caja) asignado por LDI y el No Ticket (MovID) del movimiento*/
SELECT @CajaLDI = '2:' + @Caja
/*Fecha y Hora de Emision(El formato debe ser AAAAMMDDHHMMSS)*/
SELECT @FechaEmisionEjercicio = CONVERT(varchar(4), YEAR(@FechaEmision)),
@FechaEmisionPeriodo = RIGHT('00' + CONVERT(varchar(2), MONTH(@FechaEmision)),2),
@FechaEmisionDia = RIGHT('00' + CONVERT(varchar(2), DAY(@FechaEmision)),2),
@FechaEmisionHora = RIGHT('00' + CONVERT(varchar(2), DatePart(hh, @FechaEmision)),2),
@FechaEmisionMinuto = RIGHT('00' + CONVERT(varchar(2), DatePart(mi, @FechaEmision)),2),
@FechaEmisionSegundo = RIGHT('00' + CONVERT(varchar(2), DatePart(ss, @FechaEmision)),2)
SELECT @FechaEmisionLDI = '3:' + @FechaEmisionEjercicio + @FechaEmisionPeriodo + @FechaEmisionDia + @FechaEmisionHora + @FechaEmisionMinuto + @FechaEmisionSegundo
/* Determina el numero de empresa asignado por LDI */
SELECT @EmpresaLDI = '161:' + EmpresaLDI
FROM Empresa WITH (NOLOCK) 
WHERE Empresa = @Empresa
/* Type, SubType y Tipo*/
SELECT @TrxTypeLDI = '7:' + @TrxType,
@MovIDLDI = '19:' + ISNULL(@MovID, 1),
@TrxSubTypeLDI = '56:'+ @TrxSubType,
@TipoLDI = '36:' + @Tipo
/* Importe, va sin centavos*/
IF @Servicio IN ('MON ABONO','MON CARGO','TDCLDI')
SELECT @ImporteLDI = '45:' + CONVERT(varchar, ROUND(@Importe, 2))
ELSE
SELECT @ImporteLDI = '45:' + CONVERT(varchar, ROUND(@Importe, 2)  * 100)
IF @Servicio IN ('MON ABONO','MON CARGO')
BEGIN
SELECT @ConceptoMonedero = '174:'+CASE WHEN @Servicio = 'MON ABONO' THEN '1' ELSE '2' END,
@PuntosLDI ='266:'+ CONVERT(varchar, ROUND(0.0, 2)) ,
@NotasLDI ='239:'+@Consecutivo
END
/* Si se debe generar voucher */
SELECT @GeneraVoucherLDI ='163:'+@GeneraVoucher ,
@NoTelefonoLDI = '82:' + ISNULL(@NoTelefono,'000000')
/* Cliente para el alta del monedero*/
IF @Servicio IN ('MON ABONO', 'MON ALTA MODIFICA', 'MON ALTA NUEVO','MON ALTA REEMPLAZO','MON CARGO','MON CONSULTA')
BEGIN
SELECT @ClienteLDI = '41:' + @Cliente,
@NoTarjetaLDI = '35:' + @NoTarjeta,
@NoTarjetaReemplazoLDI = '265:' + @NoTarjetaReemplazo
END
/*Cuenta para pago servicios*/
SELECT @CuentaLDI = '42:'+@Cuenta
/*Referencia para pago servicios*/
SELECT @ReferenciaLDI = '57:'+ISNULL(@Referencia,'')
IF @EsConsulta = 1
SELECT @Consulta = '86:C'
IF @Servicio IN('EDOCTAMES')
BEGIN
SELECT @LDIMes = '254:'+@Mes,@LDIAno = '255:'+@Ano,
@NoTarjetaLDI = '35:' + @NoTarjeta
END
IF @Servicio IN('EDOCTAPERIODO')
BEGIN
SELECT @LDIFechaD= '83:'+dbo.fnDateTimeFmt(@FechaD,'AAAAMMDD'), @LDIFechaA = '84:'+dbo.fnDateTimeFmt(@FechaA,'AAAAMMDD'),
@NoTarjetaLDI = '35:' + @NoTarjeta
END
/* Type, SubType y Tipo*/
SELECT @TrxTypeLDI = '7:' + @TrxType,
@TrxSubTypeLDI = '56:'+ @TrxSubType,
@TipoLDI = '36:' + @Tipo
IF @EsCancelacion = 1
BEGIN
IF @TrxTypeLDI = '251'
SELECT @TrxTypeLDI = '7:' + '253'
IF @TrxTypeLDI = '241'
SELECT @TrxTypeLDI = '7:' + '243'
IF @TrxTypeLDI = '611'
SELECT @TrxTypeLDI = '7:' + '613'
SELECT TOP 1 @TrxID = IDTransaccion,  @AutCode = CodigoAutorizacion
FROM LDIMovLog  WITH (NOLOCK) WHERE IDModulo = @ID AND Modulo = @Modulo AND Servicio = @Servicio AND CodigoRespuesta = 0 AND Importe = @Importe
SELECT @TrxIDLDI = '74:' + CONVERT(varchar,@TrxID), @AutCodeLDI = '50:' + CONVERT(varchar,@AutCode)
END
/*Concatena la Cadena */
SELECT @Cadena = @Cadena + CASE WHEN @EmpresaLDI IS NOT NULL THEN ISNULL(@EmpresaLDI, '') ELSE '' END
+ ISNULL(@Separador + @SucursalLDI, '')
+ ISNULL(@Separador + @CajaLDI, '')
+ ISNULL(@Separador + @TrxTypeLDI, '')
+ CASE WHEN @TrxSubType IS NOT NULL THEN ISNULL(@Separador + @TrxSubTypeLDI, '') ELSE '' END
+ ISNULL(@Separador + @CuentaLDI, '')
+ ISNULL(@Separador + @ReferenciaLDI, '')
+ ISNULL(@Separador + @TipoLDI, '')
+ CASE WHEN @NoTarjeta IS NOT NULL THEN ISNULL(@Separador + @NoTarjetaLDI, '') ELSE '' END
+ CASE WHEN @NoTarjetaReemplazo IS NOT NULL THEN ISNULL(@Separador + @NoTarjetaReemplazoLDI, '') ELSE '' END
+ ISNULL(@Separador + @ConceptoMonedero, '')
+ ISNULL(@Separador + @PuntosLDI, '')
+ ISNULL(@Separador + @NotasLDI, '')
+ ISNULL(@Separador + @NoTelefonoLDI, '')
+ ISNULL(@Separador + @FechaEmisionLDI, '')
+ ISNULL(@Separador + @MovIDLDI, '')
+ ISNULL(@Separador + @ClienteLDI, '')
+ ISNULL(@Separador + @ImporteLDI, '')
+ ISNULL(@Separador + @GeneraVoucherLDI, '')
+ ISNULL(@Separador + @Consulta, '')
+ ISNULL(@Separador + @TrxIDLDI, '')
+ ISNULL(@Separador + @AutCodeLDI, '')
+ ISNULL(@Separador + @LDIMes, '')
+ ISNULL(@Separador + @LDIAno, '')
+ ISNULL(@Separador + @LDIFechaD, '')
+ ISNULL(@Separador + @LDIFechaA, '')
+ ISNULL(@Separador + @TransaccionesManuales, '')
+ '}'
END

