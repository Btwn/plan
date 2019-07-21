SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTCRegistrarTransaccion
@Estacion			int,
@Modulo				varchar(5),
@ID					int,
@FormaPago			varchar(50),
@Importe			float,
@Campo				varchar(50),
@ProcesadorTrans	varchar(15),
@Accion				varchar(20),
@CxcID				int,
@RID				int			 OUTPUT,
@CodigoAutorizacion	varchar(255) OUTPUT,
@Ok					int			 OUTPUT,
@OkRef				varchar(255) OUTPUT

AS
BEGIN
DECLARE @ARQC					varchar(255),
@BancoEmisor			varchar(255),
@CodigoError			varchar(255),
@CodigoProcesador		varchar(255),
@E1					varchar(255),
@E2					varchar(255),
@E3					varchar(255),
@Estatus				varchar(255),
@FechaExpiracion		varchar(5),
@FechaFin				datetime,
@FechaInicio			datetime,
@IDOrden				varchar(255),
@MensajeError			varchar(255),
@MensajeProcesador	varchar(255),
@NumeroTarjeta		varchar(255),
@SeveridadError		varchar(255),
@Tarjetahabiente		varchar(255),
@Texto				varchar(255),
@TipoOperacion		varchar(255),
@TipoTarjeta			varchar(255),
@TipoTransaccion		varchar(255),
@Total				float,
@Track1				varchar(255),
@Track2				varchar(255),
@TCTipoPlan			varchar(20),
@TCNoMeses			int,
@TCDiferirMeses		int
SELECT @TCTipoPlan = TCTipoPlan,
@TCNoMeses		 = CASE TCTipoPlan
WHEN 'Normal'				THEN 0
WHEN 'Diferimiento Inicial' THEN 0
WHEN 'Con Intereses'		THEN ISNULL(TCNoMeses, 0)
WHEN 'Sin Intereses'		THEN ISNULL(TCNoMeses, 0)
END,
@TCDiferirMeses = CASE TCTipoPlan
WHEN 'Normal'				THEN 0
WHEN 'Diferimiento Inicial' THEN ISNULL(TCDiferirMeses, 0)
WHEN 'Con Intereses'		THEN 0
WHEN 'Sin Intereses'		THEN 0
END
FROM FormaPago
WHERE FormaPago = @FormaPago
SELECT @ARQC = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'ARQC'
SELECT @BancoEmisor = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Banco Emisor'
SELECT @CodigoAutorizacion = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Codigo Autorizacion'
SELECT @CodigoError = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Codigo Error'
SELECT @CodigoProcesador = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Codigo Procesador'
SELECT @E1 = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'E1'
SELECT @E2 = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'E2'
SELECT @E3 = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'E3'
SELECT @Estatus = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Estatus'
SELECT @IDOrden = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'ID Orden'
SELECT @MensajeError = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Mensaje Error'
SELECT @MensajeProcesador = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Mensaje Procesador'
SELECT @NumeroTarjeta = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Numero Tarjeta'
SELECT @SeveridadError = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Severidad Error'
SELECT @Tarjetahabiente = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Tarjetahabiente'
SELECT @Texto = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Texto'
SELECT @TipoOperacion = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Tipo Operacion'
SELECT @TipoTarjeta = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Tipo Tarjeta'
SELECT @TipoTransaccion = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Tipo Transaccion'
SELECT @Total = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Total'
SELECT @Track1 = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Track1'
SELECT @Track2 = TCHashTableTransaccion.Valor FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Track2'
IF @ProcesadorTrans = 'BANORTE'
BEGIN
SELECT @FechaFin = dbo.fnTCBanorteFecha(TCHashTableTransaccion.Valor) FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Fecha Fin'
SELECT @FechaInicio = dbo.fnTCBanorteFecha(TCHashTableTransaccion.Valor) FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Fecha Inicio'
SELECT @FechaExpiracion = SUBSTRING(TCHashTableTransaccion.Valor, 1, 2) + '/' + SUBSTRING(TCHashTableTransaccion.Valor, 3, 2) FROM TCHashTableTransaccion JOIN TCHashTableDefinicion ON TCHashTableTransaccion.Columna = TCHashTableDefinicion.Columna WHERE Estacion = @Estacion AND ProcesadorTrans = @ProcesadorTrans AND TCHashTableDefinicion.Campo = 'Fecha Expiracion'
END
INSERT INTO TCTransaccion(
Modulo,  Accion,  ModuloID,  FormaPago,  Campo,  Importe,  ARQC,  BancoEmisor,  CodigoAutorizacion,  CodigoError,  CodigoProcesador,  E1,  E2,  E3,  Estatus,  FechaExpiracion,  FechaFin,  FechaInicio,  IDOrden,  MensajeError,  MensajeProcesador,  NumeroTarjeta,  SeveridadError,  Tarjetahabiente,  Texto,  TipoOperacion,  TipoTarjeta,  TipoTransaccion,  Total,  Track1,  Track2,  Ok,  OkRef,  TCTipoPlan,  TCNoMeses,  TCDiferirMeses,  CxcID)
SELECT @Modulo, @Accion, @ID,       @FormaPago, @Campo, @Importe, @ARQC, @BancoEmisor, @CodigoAutorizacion, @CodigoError, @CodigoProcesador, @E1, @E2, @E3, @Estatus, @FechaExpiracion, @FechaFin, @FechaInicio, @IDOrden, @MensajeError, @MensajeProcesador, @NumeroTarjeta, @SeveridadError, @Tarjetahabiente, @Texto, @TipoOperacion, @TipoTarjeta, @TipoTransaccion, @Total, @Track1, @Track2, @Ok, @OkRef, @TCTipoPlan, @TCNoMeses, @TCDiferirMeses, @CxcID
SELECT @RID = @@IDENTITY
END

