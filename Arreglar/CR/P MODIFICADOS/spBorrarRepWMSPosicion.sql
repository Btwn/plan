SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spBorrarRepWMSPosicion
@Estacion		int

AS BEGIN
IF NOT EXISTS(SELECT * FROM RepParam WITH (NOLOCK) WHERE Estacion = @Estacion)
INSERT RepParam (Estacion) VALUES (@Estacion)
UPDATE RepParam WITH (ROWLOCK)
SET InfoEstatusTarima	= 'Alta',
InfoTipo			= '(Todos)',
InfoAlmacenWMS		= '(Todos)',
InfoOrdenWMS		= 'Tarima',
RepTitulo			= 'Layout de las posiciones del Almac�n'
WHERE Estacion = @Estacion
RETURN
END

