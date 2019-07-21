SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTCLeerXML
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
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @XML				varchar(max),
@ManejadorObjeto	int,
@IDArchivo		int,
@Archivo			varchar(255),
@iDatos			int
SELECT @Archivo = dbo.fnDirectorioEliminarDiagonalFinal(ISNULL(@RutaArchivosXML, '')) + '\Procesamiento' + CONVERT(varchar(max), @Estacion) + '.xml'
EXEC spLeerArchivo @Archivo, @Archivo = @XML OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
EXEC sp_xml_preparedocument @iDatos OUTPUT, @XML
INSERT INTO TCHashTableTransaccion(
Estacion,  Modulo,  ModuloID,  FormaPago,  Importe, Columna, Valor)
SELECT @Estacion, @Modulo, @ID,       @FormaPago, @Importe, Columna, Valor
FROM OPENXML (@iDatos, '/IntelisisTC/Procesamiento', 3)
WITH (Columna varchar(50), Valor varchar(255))
EXEC sp_xml_removedocument @iDatos
END

