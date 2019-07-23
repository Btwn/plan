SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spSincroSSBIniciarConversacion]
 @SucursalOrigen INT
,@SucursalDestino INT
,@Conversacion UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
	DECLARE
		@SQL NVARCHAR(MAX)
	   ,@ServicioLocal VARCHAR(100)
	   ,@ServicioRemoto VARCHAR(100)
	   ,@MismaInstancia BIT
	   ,@EncriptarOrigen BIT
	   ,@EncriptarDestino BIT
	SELECT @EncriptarOrigen = ComunicacionEncriptada
	FROM Sucursal WITH(NOLOCK)
	WHERE Sucursal = @SucursalOrigen
	SELECT @EncriptarDestino = ComunicacionEncriptada
	FROM Sucursal WITH(NOLOCK)
	WHERE Sucursal = @SucursalDestino
	SELECT @MismaInstancia = ISNULL(SincroSSBMismaInstancia, 0)
	FROM Version WITH(NOLOCK)
	SELECT @ServicioLocal = 'ServicioSSB_' + CONVERT(VARCHAR, @SucursalOrigen)
		  ,@ServicioRemoto = 'ServicioSSB_' + CONVERT(VARCHAR, @SucursalDestino)
	SELECT @SQL = N'BEGIN DIALOG CONVERSATION @Conversacion
FROM SERVICE ' + @ServicioLocal + '
TO SERVICE ''' + @ServicioRemoto + '''
ON CONTRACT ContratoSSB'

	IF @MismaInstancia = 0
		AND (ISNULL(@EncriptarOrigen, 0) = 1 OR ISNULL(@EncriptarDestino, 0) = 1)
		SELECT @SQL = @SQL + N' = ON'

	EXEC sp_executesql @SQL
					  ,N'@Conversacion uniqueidentifier OUTPUT'
					  ,@Conversacion OUTPUT
	RETURN
END
GO