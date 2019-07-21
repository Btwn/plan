SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTCObtenerFormasPago
@Empresa		varchar(5),
@Modulo			varchar(5),
@ID				int,
@Sucursal		int,
@Estacion		int,
@Accion			varchar(20),
@RID			int,
@FormaPago		varchar(50)		= NULL OUTPUT,
@Importe		float			= NULL OUTPUT,
@Campo			varchar(50)		= NULL OUTPUT,
@IDOrden		varchar(255)	= NULL OUTPUT,
@Ok				int				= NULL OUTPUT,
@OkRef			varchar(255)	= NULL OUTPUT,
@XMLTransaccion	varchar(max)	= NULL OUTPUT,
@Referencia		varchar(50)		= NULL OUTPUT,
@EnSilencio		bit				= 1

AS
BEGIN
CREATE TABLE #Pendientes(
RID				int	IDENTITY,
Campo			varchar(50),
FormaPago		varchar(50)	NULL,
Referencia		varchar(50)	NULL,
TCProcesado		bit			NULL,
Importe			float		NULL
)
IF @Accion = 'VOID'
BEGIN
SELECT @FormaPago = FormaPago, @Importe = Importe, @Campo = Campo, @IDOrden = IDOrden FROM TCTransaccion WHERE RID = @RID
END
ELSE
BEGIN
INSERT INTO #Pendientes(Campo, FormaPago, Importe, TCProcesado, Referencia) SELECT 'FormaCobro1', FormaCobro1, Importe1, TCProcesado1, Referencia1 FROM VentaCobro JOIN FormaPago ON FormaCobro1 = FormaPago WHERE ID = @ID AND ISNULL(TCActivarInterfaz, 0) = 1
INSERT INTO #Pendientes(Campo, FormaPago, Importe, TCProcesado, Referencia) SELECT 'FormaCobro2', FormaCobro2, Importe2, TCProcesado2, Referencia2 FROM VentaCobro JOIN FormaPago ON FormaCobro2 = FormaPago WHERE ID = @ID AND ISNULL(TCActivarInterfaz, 0) = 1
INSERT INTO #Pendientes(Campo, FormaPago, Importe, TCProcesado, Referencia) SELECT 'FormaCobro3', FormaCobro3, Importe3, TCProcesado3, Referencia3 FROM VentaCobro JOIN FormaPago ON FormaCobro3 = FormaPago WHERE ID = @ID AND ISNULL(TCActivarInterfaz, 0) = 1
INSERT INTO #Pendientes(Campo, FormaPago, Importe, TCProcesado, Referencia) SELECT 'FormaCobro4', FormaCobro4, Importe4, TCProcesado4, Referencia4 FROM VentaCobro JOIN FormaPago ON FormaCobro4 = FormaPago WHERE ID = @ID AND ISNULL(TCActivarInterfaz, 0) = 1
INSERT INTO #Pendientes(Campo, FormaPago, Importe, TCProcesado, Referencia) SELECT 'FormaCobro5', FormaCobro5, Importe5, TCProcesado5, Referencia5 FROM VentaCobro JOIN FormaPago ON FormaCobro5 = FormaPago WHERE ID = @ID AND ISNULL(TCActivarInterfaz, 0) = 1
SELECT @FormaPago	= FormaPago,
@Importe		= Importe,
@Campo		= Campo,
@Referencia	= Referencia
FROM #Pendientes WHERE RID = (SELECT MIN(RID) FROM #Pendientes WHERE ISNULL(TCProcesado, 0) = 0)
END
IF @EnSilencio = 1
BEGIN
IF @FormaPago IS NULL
SELECT @Ok = 60010
IF @FormaPago IS NOT NULL AND ISNULL(@Importe, 0) = 0
SELECT @Ok = 30100, @OkRef = @FormaPago
END
ELSE
SELECT @FormaPago, @Importe, @Referencia, @Campo
END

