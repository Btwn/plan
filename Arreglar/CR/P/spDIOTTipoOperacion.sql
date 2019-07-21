SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spDIOTTipoOperacion
@EsExcento			bit,
@EsImportacion		bit,
@Tasa				float,
@TipoDocumento		varchar(20),
@TipoTercero		varchar(20),
@Rubro				int			OUTPUT

AS
BEGIN
DECLARE @RubroAnt			int,
@SQL				nvarchar(max),
@Parametros		nvarchar(max),
@RID				int,
@RIDAnt			int,
@Concepto			varchar(255),
@Operador			varchar(255),
@Valor			varchar(max),
@ValidaCondicion	bit
SELECT @Parametros = '@EsExcento			bit,
@EsImportacion		bit,
@Tasa			    float,
@TipoDocumento		varchar(20),
@TipoTercero	    varchar(20),
@ValidaCondicion	bit			OUTPUT'
SELECT @RubroAnt = 0
WHILE(1=1)
BEGIN
SELECT @Rubro = MIN(Rubro)
FROM DIOTIVARubro
WHERE Rubro > @RubroAnt
IF @Rubro IS NULL BREAK
SELECT @RubroAnt = @Rubro
IF NOT EXISTS(SELECT * FROM DIOTIVARubroCondicion WHERE Rubro = @Rubro)
SELECT @ValidaCondicion = 0
ELSE
BEGIN
SELECT @RIDAnt = 0
SELECT @SQL = 'SET ANSI_NULLS OFF IF '
WHILE(1=1)
BEGIN
SELECT @RID = MIN(RID)
FROM DIOTIVARubroCondicion
WHERE Rubro = @Rubro
AND RID > @RIDAnt
IF @RID IS NULL BREAK
SELECT @RIDAnt = @RID
SELECT @Concepto = NULL, @Operador = NULL, @Valor = NULL
SELECT @Concepto = '@'+ REPLACE(Concepto, ' ', ''),
@Operador = Operador,
@Valor = Valor
FROM DIOTIVARubroCondicion
WHERE Rubro = @Rubro AND RID = @RID
IF @Operador = 'Igual a'
SELECT @SQL = @SQL + ' (' + @Concepto + ' = ''' + RTRIM(LTRIM(@Valor)) + ''') ' + ' AND '
ELSE IF @Operador = 'Distinto que'
SELECT @SQL = @SQL + ' (' + @Concepto + ' <> ''' + RTRIM(LTRIM(@Valor)) + ''') '  + ' AND '
ELSE IF @Operador = 'En'
SELECT @SQL = @SQL + ' (' + @Concepto + ' IN (' + RTRIM(LTRIM(@Valor)) + ')) ' + ' AND '
ELSE IF @Operador = 'No En'
SELECT @SQL = @SQL + ' (' + @Concepto + ' NOT IN (' + RTRIM(LTRIM(@Valor)) + ')) ' + ' AND '
END
BEGIN TRY
SELECT @SQL = LEFT(@SQL, LEN(@SQL) - 3)
SELECT @SQL = @SQL + ' SELECT @ValidaCondicion = 1 ELSE SELECT @ValidaCondicion = 0'
EXEC sp_executesql @SQL, @Parametros, @EsExcento, @EsImportacion, @Tasa, @TipoDocumento, @TipoTercero, @ValidaCondicion OUTPUT
END TRY
BEGIN CATCH
SELECT @ValidaCondicion = 0
END CATCH
END
IF @ValidaCondicion = 1 BREAK
END
RETURN
END

