SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCargaCta
@ID		int,
@Debug		bit = 0

AS BEGIN
DECLARE
@Catalogo		varchar(20),
@Clave		varchar(20),	
@ClavePrefijo	varchar(10),
@ClaveFolioInicial	int,
@Tabla		varchar(50),
@TablaCto		varchar(50),
@CampoLlave		varchar(50),
@Campo		varchar(50),
@Expresion		varchar(255),
@SELECT		varchar(max),
@SELECT_CLAVE	varchar(max),
@INSERT		varchar(max),
@INSERT_CLAVE	varchar(max),
@SQL		varchar(max),
@TieneEstatus	bit,
@Nivel		int,
@FormaTipo		varchar(20),
@Ok			int,
@OkRef		varchar(255),
@Mensaje		varchar(255),
@Estatus		varchar(15)
SELECT @Ok = NULL, @OkRef = NULL
SELECT @Tabla = NULL, @TablaCto = NULL, @SELECT = '', @SELECT_CLAVE = '', @INSERT = '', @INSERT_CLAVE = '', @TieneEstatus = 0
SELECT @Catalogo = Catalogo, @Clave = UPPER(Clave), @ClavePrefijo = UPPER(ClavePrefijo), @ClaveFolioInicial = ISNULL(ClaveFolioInicial, 1), @Estatus = Estatus, @FormaTipo = NULLIF(RTRIM(FormaTipo), '')
FROM CargaCta
WHERE ID = @ID
IF @Catalogo = 'Prospectos' SELECT @Tabla = 'Prospecto', @TablaCto = 'ProspectoCto', @CampoLlave = 'Prospecto'
BEGIN TRY
BEGIN TRANSACTION
IF @Estatus <> 'SINAFECTAR' SELECT @Ok = 80010
IF @Tabla IS NOT NULL AND @Ok IS NULL
BEGIN
DECLARE crCargaCtaMapa CURSOR LOCAL FOR
SELECT Campo, Expresion
FROM CargaCtaMapa
WHERE ID = @ID AND TablaCampo = 'Principal'
OPEN crCargaCtaMapa
FETCH NEXT FROM crCargaCtaMapa INTO @Campo, @Expresion
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Campo = 'Estatus' SELECT @TieneEstatus = 1
SELECT @INSERT = dbo.fnConcatenar(@INSERT, @Campo, ', '),
@SELECT = dbo.fnConcatenar(@SELECT, @Expresion, ', ')
END
FETCH NEXT FROM crCargaCtaMapa INTO @Campo, @Expresion
END
CLOSE crCargaCtaMapa
DEALLOCATE crCargaCtaMapa
IF @TieneEstatus = 0
SELECT @INSERT = dbo.fnConcatenar(@INSERT, 'Estatus', ', '),
@SELECT = dbo.fnConcatenar(@SELECT, dbo.fnComillas('ALTA'), ', ')
IF @Clave IN('AUTOMATICA','AUTOMaTICA','AUTOMATICO','AUTOMaTICO')
SELECT @SELECT_CLAVE = dbo.fnComillas(@ClavePrefijo)+'+CONVERT(varchar, '+CONVERT(varchar, @ClaveFolioInicial)+'+ROW_NUMBER() OVER(ORDER BY RID)-1), ',
@INSERT_CLAVE = @CampoLlave+', '
SELECT @SQL = 'INSERT '+@Tabla+' (CargaRID, '+@INSERT_CLAVE+@INSERT+') '+
'SELECT RID, '+@SELECT_CLAVE+@SELECT+
'  FROM CargaCtaD'+
' WHERE ID='+CONVERT(varchar, @ID)
IF @Debug = 1
SELECT 'Principal' = @SQL
ELSE
EXEC (@SQL)
END
IF @TablaCto IS NOT NULL AND @Ok IS NULL
BEGIN
SELECT @Nivel = 1
WHILE EXISTS(SELECT * FROM CargaCtaMapa WHERE ID = @ID AND TablaCampo = 'Contactos' AND ISNULL(Nivel, 1) = @Nivel)
BEGIN
SELECT @SELECT = '', @INSERT = ''
DECLARE crCargaCtaMapa CURSOR LOCAL FOR
SELECT Campo, Expresion
FROM CargaCtaMapa
WHERE ID = @ID AND TablaCampo = 'Contactos' AND ISNULL(Nivel, 1) = @Nivel
OPEN crCargaCtaMapa
FETCH NEXT FROM crCargaCtaMapa INTO @Campo, @Expresion
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND @Campo <> @CampoLlave
BEGIN
IF @Campo='Cargo'
BEGIN
SELECT @SQL = 'INSERT Cargo (Cargo) SELECT DISTINCT '+@Expresion+' FROM CargaCtaD WHERE ID='+CONVERT(varchar, @ID)+' AND NULLIF(RTRIM('+@Expresion+'), "") IS NOT NULL AND '+@Expresion+' NOT IN (SELECT Cargo FROM Cargo)'
EXEC (@SQL)
END
SELECT @INSERT = dbo.fnConcatenar(@INSERT, @Campo, ', '),
@SELECT = dbo.fnConcatenar(@SELECT, @Expresion, ', ')
END
FETCH NEXT FROM crCargaCtaMapa INTO @Campo, @Expresion
END
CLOSE crCargaCtaMapa
DEALLOCATE crCargaCtaMapa
SELECT @SQL = 'INSERT '+@TablaCto+' ('+@CampoLlave+', '+@INSERT+') '+
'SELECT (SELECT MIN('+@CampoLlave+') FROM '+@Tabla+' WHERE CargaRID=CargaCtaD.RID), '+@SELECT+
'  FROM CargaCtaD'+
' WHERE ID='+CONVERT(varchar, @ID)
IF @Debug = 1
SELECT 'Contactos' = @SQL
ELSE
EXEC (@SQL)
SELECT @Nivel = @Nivel + 1
END
END
IF @Tabla IS NOT NULL AND @FormaTipo IS NOT NULL AND @Ok IS NULL
BEGIN
DECLARE crCargaCtaMapa CURSOR LOCAL FOR
SELECT Campo, Expresion
FROM CargaCtaMapa
WHERE ID = @ID AND TablaCampo = 'Caracteristicas'
OPEN crCargaCtaMapa
FETCH NEXT FROM crCargaCtaMapa INTO @Campo, @Expresion
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @SQL = 'INSERT FormaExtraValor (FormaTipo, Aplica, AplicaClave, Campo, Valor) '+
'SELECT '+dbo.fnComillas(@FormaTipo)+', '+dbo.fnComillas(@Tabla)+', (SELECT '+@CampoLlave+' FROM '+@Tabla+' WHERE CargaRID=CargaCtaD.RID), '+dbo.fnComillas(@Campo)+', '+@Expresion+
'  FROM CargaCtaD'+
' WHERE ID='+CONVERT(varchar, @ID)
IF @Debug = 1
SELECT 'Caracteristicas' = @SQL
ELSE
EXEC (@SQL)
END
FETCH NEXT FROM crCargaCtaMapa INTO @Campo, @Expresion
END
CLOSE crCargaCtaMapa
DEALLOCATE crCargaCtaMapa
END
IF @Debug = 0
UPDATE CargaCta SET Estatus = 'CONCLUIDO' WHERE ID = @ID
COMMIT TRANSACTION
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION
SELECT @Ok = 1, @OkRef = dbo.fnOkRefSQL(ERROR_NUMBER(), ERROR_MESSAGE())
END CATCH
IF @Ok IS NULL
SELECT @Mensaje = 'Proceso Concluido con Exito'
ELSE
SELECT @Mensaje = Tipo+': '+Descripcion+' '+RTRIM(ISNULL(@OkRef, '')) FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Mensaje
RETURN
END

