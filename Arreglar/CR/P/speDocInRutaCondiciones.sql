SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInRutaCondiciones
@eDocIn					varchar(50),
@Ruta					varchar(50),
@XML                                    varchar(max),
@Tipo                                   varchar(50),
@Origen                                 varchar(max),
@Empresa                                varchar(5),
@Valido                                 bit =NULL OUTPUT,
@Ok					int = NULL OUTPUT,
@OkRef					varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@GUID                 varchar(36),
@Cadena               varchar(max),
@OperadorLogico       varchar(1),
@Caracter             varchar(1),
@Contador             int,
@Operando1            varchar(max),
@Operador             varchar(50),
@Operando2            varchar(max),
@Existe               bit,
@SQL                  nvarchar(max),
@TipoError            varchar(50),
@TotalCondicion       int
IF @Tipo = 'Condicion' SET @TipoError = 'Condiciones'
IF @Tipo = 'Validar' SET @TipoError = 'Validaciones'
SET @Cadena = ''
IF NOT EXISTS( SELECT * FROM eDocInRutaD  WHERE eDocIn = @eDocIn AND Ruta = @Ruta AND Tipo = @Tipo)
SELECT @Cadena = '(1)'
ELSE
BEGIN
DECLARE crRutaDGrupo CURSOR FOR
SELECT GUID, OperadorLogico
FROM eDocInRutaD
WHERE eDocIn = @eDocIn AND Ruta = @Ruta AND Tipo = @Tipo
SET @Contador = 1
OPEN crRutaDGrupo
FETCH NEXT FROM crRutaDGrupo INTO @GUID, @OperadorLogico
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF @Contador = 1
SET @Cadena = '('
ELSE
SET @Cadena = @Cadena + ' & ('
SELECT @TotalCondicion = Count(*)
FROM eDocInRutaDCondicion
WHERE eDocIn = @eDocIn AND Ruta = @Ruta AND GUID = @GUID
IF @TotalCondicion = 0 OR NOT EXISTS(SELECT * FROM eDocInRutaDCondicion WHERE eDocIn = @eDocIn AND Ruta = @Ruta AND GUID = @GUID)
SET @Cadena =@Cadena+ '1'
ELSE
BEGIN
DECLARE crRutaDCondicion CURSOR FOR
SELECT ISNULL(Operando1,''), ISNULL(Operador,''), ISNULL(Operando2,'')
FROM eDocInRutaDCondicion
WHERE eDocIn = @eDocIn AND Ruta = @Ruta AND GUID = @GUID
ORDER BY RID
OPEN crRutaDCondicion
FETCH NEXT FROM crRutaDCondicion INTO @Operando1, @Operador, @Operando2
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Caracter = CASE WHEN @OperadorLogico = 'Y' THEN '&' WHEN @OperadorLogico = 'O' THEN '|' END
EXEC speDocInRutaCondicion @XML, @Operando1, @Operador, @Operando2, @Origen, @Empresa, @Existe  OUTPUT,  @Ok  OUTPUT,  @OkRef  OUTPUT
IF @Ok IS NOT NULL SET @OkRef =  '('+@Ruta+') ' +@OkRef
SET @Cadena = @Cadena+CONVERT(varchar,@Existe)
SET @TotalCondicion = @TotalCondicion -1
IF @TotalCondicion > 0
SET @Cadena = @Cadena + @Caracter
FETCH NEXT FROM crRutaDCondicion INTO @Operando1, @Operador, @Operando2
END
CLOSE crRutaDCondicion
DEALLOCATE crRutaDCondicion
END
SET @Cadena = @Cadena + ')'
SET @Contador = @Contador + 1
FETCH NEXT FROM crRutaDGrupo INTO @GUID, @OperadorLogico
END
CLOSE crRutaDGrupo
DEALLOCATE crRutaDGrupo
END
SET @SQL =N'IF '+@Cadena+' = 1 SET @Valido = 1 ELSE SET @Valido = 0'
IF @Ok IS NULL
BEGIN TRY
EXEC sp_executesql @SQL, N' @Valido  bit OUTPUT', @Valido = @Valido OUTPUT
END TRY
BEGIN CATCH
SELECT @Ok = @@ERROR,  @OkRef = ERROR_MESSAGE()
IF XACT_STATE() = -1
BEGIN
ROLLBACK TRAN
SET @OkRef = ' Error  al verificar '+@TipoError + CONVERT(varchar,@Ok) + @OkRef
RAISERROR(@OkRef,20,1) WITH LOG
END
END CATCH
IF @Ok IS NOT NULL
SET @OkRef = ' Error  al verificar '+@TipoError+'(' + CONVERT(varchar,@Ok) +') ' + @OkRef
END

