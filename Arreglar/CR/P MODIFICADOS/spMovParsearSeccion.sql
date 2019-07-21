SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovParsearSeccion
(
@Estacion			int,
@Modulo			varchar(5),
@Mov				varchar(20),
@Exportacion			varchar(50),
@IDSeccion			int,
@Tabla			varchar(50),
@ID				int,
@Texto			varchar(MAX),
@SubSeccionDe			varchar(50),
@Cierre			bit,
@Select			varchar(MAX) OUTPUT,
@OrdenSeccion			int OUTPUT,
@Ok				int OUTPUT,
@OkRef			varchar(255) OUTPUT
)

AS
BEGIN
DECLARE @OrdenSeccionTexto	varchar(3)
IF @SubSeccionDe IS NULL SET @OrdenSeccion = @OrdenSeccion + 1
SET @OrdenSeccionTexto = REPLICATE('0',3-LEN(RTRIM(LTRIM(CONVERT(varchar,@OrdenSeccion))))) + RTRIM(LTRIM(CONVERT(varchar,@OrdenSeccion)))
EXEC spParsearTexto @Modulo, @Mov, @Exportacion, @IDSeccion, @Tabla, @Texto OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SET @Select =
'INSERT MovExportacionDatos (Estacion, Modulo, ModuloID, OrdenExportacion, Documento) SELECT ' +
RTRIM(LTRIM(CONVERT(varchar,@Estacion))) + ', ' + CHAR(39) + RTRIM(@Modulo) + CHAR(39) +
', ' + RTRIM(LTRIM(CONVERT(varchar,@ID))) + ', ' +
CASE ISNULL(@Cierre,0)
WHEN 0 THEN CHAR(39) + @OrdenSeccionTexto + CHAR(39) + ' + OrdenExportacion'
WHEN 1 THEN ' + RTRIM(' + CHAR(39) + @OrdenSeccionTexto + CHAR(39) + ' + OrdenExportacion) + REPLICATE(CHAR(255),255 - LEN(RTRIM(LTRIM(' + CHAR(39) + @OrdenSeccionTexto + CHAR(39) + ' + OrdenExportacion))))'
END +
', ' + @Texto + ' FROM ' + RTRIM(@Tabla) + ' WITH(NOLOCK) WHERE ID = ' + RTRIM(CONVERT(varchar,@ID))
END

