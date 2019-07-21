SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCapturaFoto
@ID               	int,
@Tabla		varchar(100),
@Clave		varchar(50),
@Accion		varchar(20)

AS BEGIN
DECLARE
@Llave	varchar(255),
@SELECT	varchar(max),
@SQL	varchar(max)
SELECT @Accion = UPPER(@Accion)
IF @Accion IN ('ANTES', 'CANCELAR')
DELETE CapturaD WHERE ID = @ID
IF @Accion <> 'CANCELAR'
BEGIN
CREATE TABLE #Resultado (Campo varchar(255) NOT NULL, Valor varchar(255) NULL)
SELECT TOP (1) @Llave = Campo FROM dbo.fnTablaPK(@Tabla)
SELECT @Llave = @Llave +'='''+@Clave+''''
EXEC spTablaEstructura @Tabla,  @SELECT = @SELECT OUTPUT, @ExcluirTimeStamp = 1, @ExcluirCalculados = 1, @Prefijo = 'CONVERT(varchar(255), ', @Sufijo = ')', @ASCampo = 1
SELECT @SQL = 'INSERT #Resultado(Campo, Valor) SELECT Campo, Valor FROM (SELECT '+@SELECT
EXEC spTablaEstructura @Tabla,  @SELECT = @SELECT OUTPUT, @ExcluirTimeStamp = 1, @ExcluirCalculados = 1
SELECT @SQL = @SQL +' FROM '+@Tabla+' WHERE '+@Llave+') Origen UNPIVOT (Valor FOR Campo IN ('+@SELECT+')) AS Resultado'
EXEC (@SQL)
IF @Accion = 'ANTES'
INSERT CapturaD (ID, Campo, ValorAnterior) SELECT @ID, Campo, Valor FROM #Resultado
ELSE
BEGIN
INSERT CapturaD (ID, Campo, Valor) SELECT @ID, Campo, Valor FROM #Resultado WHERE Campo NOT IN (SELECT Campo FROM CapturaD WITH (NOLOCK) WHERE ID = @ID)
UPDATE CapturaD WITH (ROWLOCK)
SET Valor = t.Valor
FROM CapturaD d WITH (NOLOCK)
JOIN #Resultado t ON t.Campo = d.Campo
WHERE d.ID = @ID
DELETE CapturaD
WHERE ID = @ID AND ISNULL(RTRIM(Valor), '') = ISNULL(RTRIM(ValorAnterior), '')
END
DROP TABLE #Resultado
END
RETURN
END

