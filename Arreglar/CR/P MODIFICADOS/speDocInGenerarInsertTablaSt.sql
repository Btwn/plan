SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInGenerarInsertTablaSt
@Estacion         int

AS BEGIN
DECLARE
@TablaSt        varchar(50),
@Tablas         varchar(50),
@CampoNombre    varchar(50),
@CampoValor     varchar(50),
@Ok             int,
@OkRef          varchar(255),
@SQL            nvarchar(max),
@Operando1      varchar(8000),
@Operando2      varchar(8000),
@Operador       varchar(50)
SELECT @TablaSt = TablaSt, @Tablas = Tablas, @CampoNombre = CampoNombre, @CampoValor = CampoValor
FROM eDocInHerrTablaST
WITH(NOLOCK) WHERE Estacion = @Estacion
SELECT @SQL = N'IF NOT EXISTS (SELECT * FROM TablaSt WHERE TablaSt = '+CHAR(39)+@TablaSt+CHAR(39)+')
INSERT TablaSt(TablaSt)
SELECT  '+CHAR(39)+@TablaSt+CHAR(39)+ N'
IF @@ERROR <> 0 SET @Ok = 1
IF NOT EXISTS (SELECT * FROM TablaStD WHERE TablaSt = '+CHAR(39)+@TablaSt+CHAR(39)+N') AND @Ok IS NULL
INSERT TablaStD(TablaSt, Nombre, Valor)
SELECT  '+CHAR(39)+@TablaSt+CHAR(39)+N', '+@CampoNombre+N','+@CampoValor+N'
FROM  '+@Tablas +N'   WHERE '+@CampoNombre+N' IS NOT NULL  AND  '+@CampoValor+N' IS NOT NULL AND  '
IF EXISTS (SELECT * FROM eDocInHerrTablaSTD WHERE Estacion = @Estacion)
BEGIN
DECLARE crTablaD CURSOR FOR
SELECT Operando1, Operador, Operando2
FROM eDocInHerrTablaSTD WITH(NOLOCK)
WHERE Estacion = @Estacion
ORDER BY ID
OPEN crTablaD
FETCH NEXT FROM crTablaD  INTO @Operando1, @Operador, @Operando2
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @SQL = @SQL +@Operando1+' '+ CASE WHEN @Operador = 'IGUAL QUE' THEN '='
WHEN @Operador = 'DIFERENTE QUE' THEN '<>'
WHEN @Operador = 'MAYOR QUE' THEN '>'
WHEN @Operador = 'MENOR QUE' THEN '<'
WHEN @Operador = 'MAYOR O IGUAL QUE' THEN '>='
WHEN @Operador = 'MENOR O IGUAL QUE' THEN '<='
END +' '+CHAR(39)+@Operando2+CHAR(39)+ '  AND  '
FETCH NEXT FROM crTablaD  INTO @Operando1, @Operador, @Operando2
END
CLOSE crTablaD
DEALLOCATE crTablaD
END
SELECT @SQL = @SQL + N' 1 = 1'
BEGIN TRY
EXEC sp_executesql @SQL, N'@Ok int  OUTPUT', @Ok= @Ok OUTPUT
END TRY
BEGIN CATCH
SELECT @Ok = @@ERROR,  @OkRef = ERROR_MESSAGE()
IF XACT_STATE() = -1
BEGIN
ROLLBACK TRAN
SET @OkRef = ' Error  ' + CONVERT(varchar,@Ok) + @OkRef
RAISERROR(@OkRef,20,1) WITH LOG
END
END CATCH
IF @Ok IS NULL
SELECT 'SE GENERO LA TABLA '+@TablaSt
ELSE
SELECT @OkRef
END

