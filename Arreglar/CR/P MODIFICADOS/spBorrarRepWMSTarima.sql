SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spBorrarRepWMSTarima
@Estacion		int

AS BEGIN
IF NOT EXISTS(SELECT * FROM RepParam WITH (NOLOCK) WHERE Estacion = @Estacion)
INSERT RepParam (Estacion) VALUES (@Estacion)
UPDATE RepParam WITH (ROWLOCK)
SET InfoEstatusTarima	= 'Alta',
InfoOrdenWMS		= 'Tarima',
InfoAlmacenWMS		= '(Todos)',
InfoTipo			= '(Todos)',
RepTitulo			= 'Existencia por Tarima'
WHERE Estacion = @Estacion
RETURN
END

