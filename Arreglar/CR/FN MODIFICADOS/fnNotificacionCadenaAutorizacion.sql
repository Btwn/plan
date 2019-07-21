SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnNotificacionCadenaAutorizacion
(
@Empresa					varchar(5),
@Sucursal					int,
@Modulo						varchar(5),
@ID							int,
@Estatus					varchar(15),
@Situacion					varchar(50),
@Usuario					varchar(10)
)
RETURNS varchar(255)

AS BEGIN
DECLARE
@Resultado			varchar(255),
@SucursalTexto		varchar(20),
@IDTexto				varchar(20),
@CheckSum				int,
@CheckSumTexto		varchar(50)
SET @Empresa  = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @SucursalTexto = LTRIM(RTRIM(CONVERT(varchar,ISNULL(@Sucursal,-1))))
SET @Modulo = LTRIM(RTRIM(ISNULL(@Modulo,'')))
SET @IDTexto = LTRIM(RTRIM(CONVERT(varchar,ISNULL(@ID,0))))
SET @Estatus  = LTRIM(RTRIM(ISNULL(@Estatus,'')))
SET @Situacion  = LTRIM(RTRIM(ISNULL(@Situacion,'')))
SET @Usuario  = LTRIM(RTRIM(ISNULL(@Usuario,'')))
SET @Checksum = CHECKSUM('AUT' + LTRIM(RTRIM(@@SERVERNAME)) + LTRIM(RTRIM(DB_NAME())) + @Empresa + @SucursalTexto + @Modulo + @IDTexto + @Estatus + @Situacion + @Usuario)
SET @CheckSumTexto = LTRIM(RTRIM(CONVERT(varchar,ISNULL(@Checksum,0))))
SELECT @Resultado = '||AUTORIZACION|' + @Empresa + '|' + @SucursalTexto + '|' + @Modulo + '|' + @IDTexto + '|' + @Estatus + '|' + @Situacion + '|' + @Usuario + '|' + @ChecksumTexto + '||'
RETURN @Resultado
END

