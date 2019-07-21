SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnNotificacionObtenerParametro
(
@Notificacion				varchar(50),
@Parametro					varchar(100)
)
RETURNS varchar(255)

AS BEGIN
DECLARE
@Resultado	varchar(255)
SELECT @Resultado = ISNULL(Valor,'') FROM NotificacionParam WITH(NOLOCK) WHERE Notificacion = @Notificacion AND Parametro = @Parametro
RETURN (ISNULL(@Resultado,''))
END

