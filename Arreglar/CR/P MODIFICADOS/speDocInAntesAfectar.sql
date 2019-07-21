SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInAntesAfectar
@AntesAfectar     varchar(50),
@eDocIn		  varchar(50),
@Ruta		  varchar(50),
@ID               int,
@Modulo           varchar(5),
@Ok               int           OUTPUT,
@OkRef            varchar(255)  OUTPUT

AS BEGIN
DECLARE
@SQL            nvarchar(max),
@SQL2           varchar(max),
@SP             varchar(100),
@Param1         bit,
@Param2         bit
SELECT @SP = SP, @Param1 = Param1, @Param2 =Param2
FROM eDocInRutaExpresion WITH(NOLOCK)
 WHERE  eDocIn = @eDocIn AND Ruta = @Ruta
IF @AntesAfectar = 'Stored Procedure'
BEGIN
SELECT @SQL2 = @SP+' '+ CASE WHEN @Param1 = 1 THEN ISNULL(CONVERT(varchar,@ID),'') ELSE '' END+ CASE WHEN @Param2 = 1 AND @Param1 =1 THEN ' ,'+CHAR(39)+ISNULL(@Modulo,'')+CHAR(39) ELSE '' END
SET @SQL = N'SET ANSI_NULLS ON ' +
N'SET ANSI_WARNINGS ON ' +
N'SET QUOTED_IDENTIFIER ON ' +
N'BEGIN TRY ' +
N'  EXEC  ' + @SQL2
+N'  END TRY ' +
N'BEGIN CATCH ' +
N'  SELECT @Ok = @@ERROR,  @OkRef = ERROR_MESSAGE() ' +
N'  IF XACT_STATE() = -1 ' +
N'  BEGIN ' +
N'    ROLLBACK TRAN ' +
N'    SET @OkRef = ' + CHAR(39) + N'Error  ' +@SP+' '+ CHAR(39) + N' + CONVERT(varchar,@Ok) + ' + CHAR(39) + N', ' + CHAR(39) + N' + @OkRef ' +
N'    RAISERROR(@OkRef,20,1) WITH LOG ' +
N'  END ' +
N'END CATCH '
EXEC sp_executesql @SQL, N'@Ok   int OUTPUT, @OkRef varchar(255) OUTPUT', @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @OK IS NOT NULL
SET @OkRef = ' Error al ejecutar el Stored Procedure ' +@SP+' (' + CONVERT(varchar,@Ok) +') '+@OkRef
END
IF @AntesAfectar = 'ReCalcular Gasto'
EXEC spGastoRecalcularDetalle @ID, @Modulo, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

