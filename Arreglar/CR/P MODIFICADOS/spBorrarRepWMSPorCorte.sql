SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spBorrarRepWMSPorCorte
@Estacion		int

AS BEGIN
IF NOT EXISTS(SELECT * FROM RepParam WITH (NOLOCK) WHERE Estacion = @Estacion)
INSERT RepParam (Estacion) VALUES (@Estacion)
UPDATE RepParam WITH (ROWLOCK)
SET InfoArtCat			= '(Todos)',
InfoArtFam			= '(Todos)',
InfoArtGrupo		= '(Todos)',
InfoArtFabricante	= '(Todos)',
InfoArtLinea		= '(Todos)',
InfoMovimientoEsp	= '',
InfoNivel			= 'Desglosado',
InfoValuacion		= 'Costo Promedio',
InfoAlmacenWMS		= '(Todos)',
RepTitulo			= 'Existencia por producto y Tarima a una fecha de corte'
WHERE Estacion = @Estacion
RETURN
END

