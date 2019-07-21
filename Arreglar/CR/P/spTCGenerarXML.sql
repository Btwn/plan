SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTCGenerarXML
@Empresa			varchar(5),
@Sucursal			int,
@Estacion			int,
@Modulo				varchar(5),
@ID					int,
@Accion				varchar(20),
@CancelaRID			int,
@FormaPago			varchar(50),
@Importe			float,
@Campo				varchar(50),
@IDOrden			varchar(255),
@RutaArchivosXML	varchar(255),
@Referencia			varchar(50),
@Usuario			varchar(10),
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT,
@ArchivoCfg			varchar(255)	OUTPUT

AS
BEGIN
DECLARE @XML				varchar(max),
@XMLCfg			varchar(max),
@XMLTransaccion	varchar(max),
@ManejadorObjeto	int,
@IDArchivo		int
SELECT @ManejadorObjeto = NULL, @IDArchivo = NULL, @ArchivoCfg = dbo.fnDirectorioEliminarDiagonalFinal(ISNULL(@RutaArchivosXML, '')) + '\Peticion' + CONVERT(varchar(max), @Estacion) + '.xml'
EXEC spTCCfg @Empresa, @Sucursal, @Estacion, @Usuario, @XMLCfg OUTPUT
EXEC spTCObtenerDatosTransaccion @Modulo, @ID, @FormaPago, @Importe, @Accion, @CancelaRID, @Sucursal, @Estacion, @Campo, @Referencia, @XMLTransaccion OUTPUT
SELECT @XML = '<IntelisisTC>' + @XMLCfg + @XMLTransaccion + '</IntelisisTC>'
IF @Ok IS NULL
EXEC spCrearRuta @RutaArchivosXML, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spCrearArchivo @ArchivoCfg, @ManejadorObjeto OUTPUT, @IDArchivo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spInsertaEnArchivo @IDArchivo, @XML, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spCerrarArchivo @IDArchivo, @ManejadorObjeto, @Ok OUTPUT, @OkRef OUTPUT
END

