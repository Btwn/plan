SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneDocInGenerarInsertTabla
(
@eDocIn				varchar(50),
@Ruta				varchar(50),
@Tabla				varchar(50)
)
RETURNS nvarchar(max)

AS BEGIN
DECLARE
@Resultado				nvarchar(max),
@CampoXML				nvarchar(max),
@ExpresionXML			nvarchar(max),
@CampoTabla				nvarchar(max),
@CampoTablaTipo			nvarchar(100),
@CampoXMLRuta			nvarchar(max),
@CampoXMLAtributo		        nvarchar(255),
@CampoXMLTipo			nvarchar(50),
@CampoXMLTipoXML		        nvarchar(50),
@EsIndependiente		        bit,
@Traducir				bit,
@TablaST				varchar(50),
@DeclareVariables		        nvarchar(max),
@DeclareTabla			nvarchar(max),
@DeclareTablaPostfijo	        nvarchar(max),
@PrepareDocument		        nvarchar(max),
@Insert				nvarchar(max),
@ListaSeleccion			nvarchar(max),
@With				nvarchar(max),
@RemoveDocument			nvarchar(max),
@InsertModulo			nvarchar(max),
@ListaSeleccionModulo	        nvarchar(max),
@IDTabla             	        nvarchar(max),
@eDocInRutaTablaNodo	        nvarchar(max),
@eDocInRutaTablaNodoN	        nvarchar(max),
@eDocInRutaTabla		        nvarchar(50),
@TablaVirtual			nvarchar(50),
@Ok					int,
@TablaPrincipal			bit,
@Modulo				varchar(5),
@XMLNS				varchar(max),
@ListaSeleccionEspecial	        bit
DECLARE @TablaWith table(Campo varchar(max))
SET @Ok = NULL
SET @eDocIn = RTRIM(NULLIF(@eDocIn,''))
SET @Ruta = RTRIM(NULLIF(@Ruta,''))
SET @Tabla = RTRIM(NULLIF(@Tabla,''))
SELECT
@Modulo = ISNULL(Modulo,'')
FROM eDocInRuta
WHERE RTRIM(eDocIn) = @eDocIn
AND RTRIM(Ruta) = @Ruta
SELECT @TablaPrincipal = CASE WHEN @Tabla = dbo.fnMovTabla(@Modulo) THEN 1 ELSE 0 END
SELECT
@eDocInRutaTablaNodo = ISNULL(Nodo,''),
@eDocInRutaTabla = ISNULL(Tablas,''),
@TablaVirtual = '@' + ISNULL(Tablas,'') + LTRIM(RTRIM(CONVERT(varchar,@@SPID)))
FROM eDocInRutaTabla
WHERE RTRIM(eDocIn) = @eDocIn
AND RTRIM(Ruta) = @Ruta
AND RTRIM(Tablas) = @Tabla
IF SUBSTRING(@eDocInRutaTablaNodo,LEN(@eDocInRutaTablaNodo),1) = '/' SET @eDocInRutaTablaNodoN = SUBSTRING(@eDocInRutaTablaNodo,1,LEN(@eDocInRutaTablaNodo)-1)
IF @eDocIn IS NULL RETURN '' ELSE
IF @Ruta  IS NULL RETURN '' ELSE
IF @Tabla  IS NULL RETURN ''
SET @Resultado = N''
SET @DeclareTabla = N''
SET @Insert = N''
SET @ListaSeleccion = N''
SET @With = N''
SET @InsertModulo = N''
SET @ListaSeleccionModulo = N''
SET @IDTabla = N''
IF @TablaPrincipal = 1
SELECT @IDTabla = N' SELECT @ID =  SCOPE_IDENTITY()'
DECLARE creDocInRutaTablaD CURSOR FOR
SELECT REPLACE(NULLIF(CampoXML,''),':','_'), NULLIF(CampoTabla,''), ISNULL(CampoXMLRuta,''), NULLIF(CampoXMLAtributo,''), NULLIF(CampoXMLTipo,''), NULLIF(CampoXMLTipoXML,''), dbo.fneDocInExpresionParsear(NULLIF(ISNULL(REPLACE(NULLIF(ExpresionXML,''),':','_'),REPLACE(NULLIF(CampoXML,''),':','_')),'')), ISNULL(EsIndependiente,0), ISNULL(Traducir,0), NULLIF(TablaST,'')
FROM eDocInRutaTablaD
WHERE eDocIn = @eDocIn
AND Ruta = @Ruta
AND Tablas = @Tabla
OPEN creDocInRutaTablaD
FETCH NEXT FROM creDocInRutaTablaD INTO @CampoXML, @CampoTabla, @CampoXMLRuta, @CampoXMLAtributo, @CampoXMLTipo, @CampoXMLTipoXML, @ExpresionXML, @EsIndependiente, @Traducir, @TablaST
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SET @ListaSeleccionEspecial = 0
IF ISNULL(@CampoXMLRuta,'') = @eDocInRutaTablaNodo
BEGIN
SET @CampoXMLRuta = ''
END ELSE
BEGIN
IF RTRIM(ISNULL(@CampoXMLTipoXML,'ATRIBUTO')) = 'ATRIBUTO'
BEGIN
SET @CampoXMLRuta = ' ' + CHAR(39) + ISNULL(@CampoXMLRuta,'') + '@' + RTRIM(ISNULL(@CampoXMLAtributo,'')) + CHAR(39)
END ELSE IF RTRIM(ISNULL(@CampoXMLTipoXML,'ATRIBUTO')) = 'NODO'
BEGIN
SET @CampoXMLRuta = ' ' + CHAR(39) + ISNULL(@CampoXMLRuta,'') + RTRIM(ISNULL(@CampoXMLAtributo,'')) + CHAR(39)
END
SET @ListaSeleccionEspecial = 1
END
IF @CampoXMLTipo IS NULL      SET @CampoTablaTipo = N'varchar(max)' ELSE
IF @CampoXMLTipo = 'TEXTO'    SET @CampoTablaTipo = N'varchar(max)' ELSE
IF @CampoXMLTipo = 'NUMERICO' SET @CampoTablaTipo = N'float'        ELSE
IF @CampoXMLTipo = 'FECHA'    SET @CampoTablaTipo = N'datetime'     ELSE
IF @CampoXMLTipo = 'LOGICO'   SET @CampoTablaTipo = N'bit'
IF @CampoTablaTipo = N'varchar(max)'
BEGIN
SET @DeclareTablaPostfijo = N' COLLATE DATABASE_DEFAULT NULL'
END
ELSE IF @CampoTablaTipo IN ('float','datetime','bit')
BEGIN
SET @DeclareTablaPostfijo = N' NULL'
END
IF @DeclareTabla = N''
SET @DeclareTabla = @DeclareTabla + @CampoXML + N' ' + @CampoTablaTipo + @DeclareTablaPostFijo
ELSE
SET @DeclareTabla = @DeclareTabla + N', ' + @CampoXML + N' ' + @CampoTablaTipo + @DeclareTablaPostFijo
IF @Insert = N''
SET @Insert = @Insert + @CampoXML
ELSE
SET @Insert = @Insert + N', ' + @CampoXML
IF @ListaSeleccion = N''
BEGIN
IF @EsIndependiente = 0
BEGIN
IF @ListaSeleccionEspecial = 0
BEGIN
SET @ListaSeleccion = @ListaSeleccion + @CampoXMLAtributo + N' AS ' + @CampoXML
END ELSE
BEGIN
SET @ListaSeleccion = @ListaSeleccion + @CampoXML + N' AS ' + @CampoXML
END
END
ELSE IF @EsIndependiente = 1
SET @ListaSeleccion = @ListaSeleccion + @ExpresionXML + N' AS ' + @CampoXML
END
ELSE
BEGIN
IF @EsIndependiente = 0
BEGIN
IF @ListaSeleccionEspecial = 0
BEGIN
SET @ListaSeleccion = @ListaSeleccion + N', ' + @CampoXMLAtributo + N' AS ' + @CampoXML
END ELSE
BEGIN
SET @ListaSeleccion = @ListaSeleccion + N', ' + @CampoXML + N' AS ' + @CampoXML
END
END
ELSE IF @EsIndependiente = 1
BEGIN
SET @ListaSeleccion = @ListaSeleccion + N', ' + @ExpresionXML + N' AS ' + @CampoXML
END
END
IF @EsIndependiente = 0
BEGIN
IF @With = N''
BEGIN
IF @ListaSeleccionEspecial = 0
BEGIN
IF NOT EXISTS(SELECT * FROM @TablaWith WHERE Campo = @CampoXMLAtributo)
SET @With = @With + @CampoXMLAtributo + N' ' + @CampoTablaTipo + @CampoXMLRuta
END ELSE
BEGIN
IF NOT EXISTS(SELECT * FROM @TablaWith WHERE Campo = @CampoXML)
SET @With = @With + @CampoXML + N' ' + @CampoTablaTipo + @CampoXMLRuta
END
END
ELSE
BEGIN
IF @ListaSeleccionEspecial = 0
BEGIN
IF NOT EXISTS(SELECT * FROM @TablaWith WHERE Campo = @CampoXMLAtributo)
SET @With = @With + N', ' + @CampoXMLAtributo + N' ' + @CampoTablaTipo + @CampoXMLRuta
END ELSE
BEGIN
IF NOT EXISTS(SELECT * FROM @TablaWith WHERE Campo = @CampoXML)
SET @With = @With + N', ' + @CampoXML + N' ' + @CampoTablaTipo + @CampoXMLRuta
END
END
INSERT @TablaWith(campo)SELECT @CampoXMLAtributo
INSERT @TablaWith(campo)SELECT @CampoXML
END
IF @InsertModulo = N''
SET @InsertModulo = @InsertModulo + @CampoTabla
ELSE
SET @InsertModulo = @InsertModulo + N', ' + @CampoTabla
IF @CampoXMLTipo = 'TEXTO' AND @Traducir = 1 AND @TablaST IS NOT NULL
BEGIN
SET @ExpresionXML = 'dbo.fneDocInTraducir(' + CHAR(39) + RTRIM(@TablaST) + CHAR(39) + ',' + @ExpresionXML + ')'
END
IF @ListaSeleccionModulo = N''
SET @ListaSeleccionModulo = @ListaSeleccionModulo + @ExpresionXML
ELSE
SET @ListaSeleccionModulo = @ListaSeleccionModulo + N', ' + @ExpresionXML
FETCH NEXT FROM creDocInRutaTablaD INTO @CampoXML, @CampoTabla, @CampoXMLRuta, @CampoXMLAtributo, @CampoXMLTipo, @CampoXMLTipoXML, @ExpresionXML, @EsIndependiente, @Traducir, @TablaST
END
CLOSE creDocInRutaTablaD
DEALLOCATE creDocInRutaTablaD
IF @With = N''
SET @With =@With+ N'A_A varchar(10)'
IF @InsertModulo IS NOT NULL AND @DeclareTabla IS NOT NULL AND @Insert IS NOT NULL AND @ListaSeleccion IS NOT NULL AND @With IS NOT NULL
BEGIN
SET @DeclareVariables = N'DECLARE @ixml int, @XMLNS		varchar(max) '
SET @DeclareTabla = N'DECLARE ' + @TablaVirtual + N' TABLE (' + @DeclareTabla + N') '
SET @XMLNS =   N'SET @XMLNS = dbo.fneDocInXmlns(CONVERT(varchar(max),@XML),1) SELECT  @XMLNS = NULLIF(@XMLNS,'+CHAR(39)+CHAR(39)+') '
SET @PrepareDocument = N' EXEC sp_xml_preparedocument @iXML OUTPUT, @xml, @XMLNS '
SET @Insert = N' INSERT ' + @TablaVirtual + N' (' + @Insert + N') '
SET @ListaSeleccion = N' SELECT ' + @ListaSeleccion + N' FROM OPENXML (@iXML,' + CHAR(39) + @eDocInRutaTablaNodoN + CHAR(39) + N') '
SET @With = N' WITH (' + @With + N')'
SET @RemoveDocument = N' EXEC sp_xml_removedocument @iXML '
SET @InsertModulo = N' INSERT ' + @eDocInRutaTabla + N' (' + @InsertModulo + N') '
SET @ListaSeleccionModulo = N' SELECT ' + @ListaSeleccionModulo + N' FROM ' + @TablaVirtual + N' '
SET @Resultado = @DeclareVariables +
N' BEGIN TRY ' +
@DeclareTabla +
@XMLNS +
@PrepareDocument +
@Insert +
@ListaSeleccion +
@With +
@RemoveDocument +
@InsertModulo +
@ListaSeleccionModulo +
@IDTabla +
N' END TRY ' +
N' BEGIN CATCH ' +
N'   SELECT @Ok = @@ERROR,  @OkRef = ERROR_MESSAGE() ' +
N'   IF XACT_STATE() = -1 ' +
N'   BEGIN ' +
N'      ROLLBACK TRAN ' +
N'      SET @OkRef = ' + CHAR(39) + N'Error  ' + CHAR(39) + N' + CONVERT(varchar,@Ok) + ' + CHAR(39) + N', ' + CHAR(39) + N' + @OkRef ' +
N'      RAISERROR(@OkRef,20,1) WITH LOG ' +
N'   END ' +
N' END CATCH '
END
RETURN (@Resultado)
END

