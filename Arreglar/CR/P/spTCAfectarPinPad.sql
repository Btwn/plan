SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTCAfectarPinPad
@Empresa	varchar(5),
@Modulo		varchar(5),
@ID			int,
@Sucursal	int,
@Estacion	int,
@Accion		varchar(20),
@Usuario	varchar(10),
@CancelaRID	int				= NULL,
@Ok			int				= NULL OUTPUT,
@OkRef		varchar(255)	= NULL OUTPUT,
@Generar	bit				= 0

AS
BEGIN
DECLARE @RutaArchivosXML		varchar(255),
@Ubicacion			varchar(255),
@FormaPago			varchar(50),
@Importe				float,
@Campo				varchar(50),
@OkDesc				varchar(255),
@OkTipo				varchar(50),
@RID					int,
@ProcesadorTrans		varchar(15),
@CodigoAutorizacion	varchar(255),
@IDOrden				varchar(255),
@CxcID				int,
@ArchivoCfg			varchar(255),
@ArchivoProceso		varchar(255),
@Referencia			varchar(50),
@MonedaCodigoNumerico varchar(5),
@Moneda				varchar(5),
@Shell				varchar(max)
EXEC spTCVerificarPinPad @Empresa, @Modulo, @ID, @Sucursal, @Estacion, @Accion, @Usuario, @CancelaRID, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @Ubicacion			= ISNULL(Ubicacion, ''),
@RutaArchivosXML	= ISNULL(RutaArchivosXML, ''),
@ProcesadorTrans = dbo.fnTCProcesadorTransCfg(@Empresa, @Sucursal)
FROM TCCfg
WHERE Empresa = @Empresa
SELECT @ArchivoProceso = dbo.fnDirectorioEliminarDiagonalFinal(ISNULL(@RutaArchivosXML, '')) + '\Procesamiento' + CONVERT(varchar(max), @Estacion) + '.xml'
DELETE TCEstacionTransaccion WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND Estacion = @Estacion
BEGIN TRANSACTION
IF @Ok IS NULL
EXEC spTCObtenerFormasPago @Empresa, @Modulo, @ID, @Sucursal, @Estacion, @Accion, @CancelaRID, @FormaPago OUTPUT, @Importe OUTPUT, @Campo OUTPUT, @IDOrden OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, @Referencia = @Referencia OUTPUT
IF @Generar = 1
BEGIN
IF @Ok IS NULL
EXEC spEliminarArchivo @ArchivoCfg, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spEliminarArchivo @ArchivoProceso, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spTCHashTableTransaccionEliminar @Estacion
IF @Ok IS NULL
EXEC spTCGenerarXML @Empresa, @Sucursal, @Estacion, @Modulo, @ID, @Accion, @CancelaRID, @FormaPago, @Importe, @Campo, @IDOrden, @RutaArchivosXML, @Referencia, @Usuario, @Ok OUTPUT, @OkRef OUTPUT, @ArchivoCfg OUTPUT
IF @Ok IS NULL
EXEC spTCShellAplicacion @Ubicacion, @RutaArchivosXML, @ArchivoCfg, @Shell OUTPUT
END
ELSE IF @Generar = 0
BEGIN
IF @Ok IS NULL
EXEC spTCLeerXML @Empresa, @Sucursal, @Estacion, @Modulo, @ID, @Accion, @CancelaRID, @FormaPago, @Importe, @Campo, @IDOrden, @RutaArchivosXML, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spTCValidarTransaccion @Estacion, @Modulo, @ID, @FormaPago, @Importe, @Campo, @ProcesadorTrans, @Accion, @CxcID, @CodigoAutorizacion OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spTCGenerarAfectarCxc @Empresa, @Modulo, @ID, @CodigoAutorizacion, @FormaPago, @Importe, @Accion, @CancelaRID, @Usuario, @CxcID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spTCActualizarVentaCobro @Modulo, @ID, @RID, @CodigoAutorizacion, @FormaPago, @Importe, @Campo, @Accion, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spTCRegistrarTransaccion @Estacion, @Modulo, @ID, @FormaPago, @Importe, @Campo, @ProcesadorTrans, @Accion, @CxcID, @RID OUTPUT, @CodigoAutorizacion OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
INSERT INTO TCEstacionTransaccion(Empresa, Sucursal, Estacion, RID) VALUES(@Empresa, @Sucursal, @Estacion, @RID)
END
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
SELECT @OkDesc = Descripcion,
@OkTipo = Tipo
FROM MensajeLista
WHERE Mensaje = @Ok
IF @Generar = 1
BEGIN
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
SELECT @Shell
ELSE
SELECT 'Error<BR><BR>' + ISNULL(@OkDesc, '') + '<BR><BR>' + ISNULL(@OkRef, '')
END
ELSE IF @Generar = 0
SELECT @Ok, @OkDesc, @OkTipo, @OkRef, @RID
RETURN ISNULL(@RID, 0)
END

