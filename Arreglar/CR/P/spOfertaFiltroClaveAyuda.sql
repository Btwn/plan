SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOfertaFiltroClaveAyuda
@Campo		varchar(50)

AS BEGIN
IF @Campo = 'Almacen'  		    SELECT 'Clave' = CONVERT(varchar(50), Almacen)	 	FROM Alm		    ORDER BY Almacen  ELSE
IF @Campo = 'Grupo Almacen'  		SELECT 'Clave' = CONVERT(varchar(50), Grupo)		FROM AlmGrupo	    ORDER BY Grupo    ELSE
IF @Campo = 'Cliente'  		    SELECT 'Clave' = CONVERT(varchar(50), 'Oprima F9 para ver la Lista de Clientes') ELSE
IF @Campo = 'Categoria Cliente'  	SELECT 'Clave' = CONVERT(varchar(50), Categoria) 	FROM CteCat		    ORDER BY Categoria ELSE
IF @Campo = 'Grupo Cliente'  		SELECT 'Clave' = CONVERT(varchar(50), Grupo) 		FROM CteGrupo	    ORDER BY Grupo    ELSE
IF @Campo = 'Familia Cliente'  	SELECT 'Clave' = CONVERT(varchar(50), Familia) 		FROM CteFam		    ORDER BY Familia  ELSE
IF @Campo = 'Zona Cliente'  		SELECT 'Clave' = CONVERT(varchar(50), Zona) 		FROM Zona		    ORDER BY Zona     ELSE
IF @Campo = 'Agente'  		    SELECT 'Clave' = CONVERT(varchar(50), Agente) 		FROM Agente		    ORDER BY Agente   ELSE
IF @Campo = 'Categoria Agente'  	SELECT 'Clave' = CONVERT(varchar(50), Categoria) 	FROM AgenteCat		ORDER BY Categoria ELSE
IF @Campo = 'Grupo Agente'  		SELECT 'Clave' = CONVERT(varchar(50), Grupo) 		FROM AgenteGrupo	ORDER BY Grupo    ELSE
IF @Campo = 'Familia Agente'  	SELECT 'Clave' = CONVERT(varchar(50), Familia) 		FROM AgenteFam		ORDER BY Familia  ELSE
IF @Campo = 'Movimiento'  		SELECT 'Clave' = CONVERT(varchar(50), Mov) 		    FROM MovTipo WHERE Modulo = 'VTAS' ORDER BY Mov ELSE
IF @Campo = 'Moneda'  		    SELECT 'Clave' = CONVERT(varchar(50), Moneda) 		FROM Mon		    ORDER BY Moneda ELSE
IF @Campo = 'Condicion Pago'  	SELECT 'Clave' = CONVERT(varchar(50), Condicion) 	FROM Condicion		ORDER BY Condicion ELSE
IF @Campo = 'Tipo Forma Pago'  	SELECT 'Clave' = CONVERT(varchar(50), Tipo) 		FROM FormaPagoTipo	ORDER BY Tipo       ELSE
IF @Campo = 'Forma Envio'  		SELECT 'Clave' = CONVERT(varchar(50), FormaEnvio) 	FROM FormaEnvio	    ORDER BY FormaEnvio ELSE
IF @Campo = 'Lista Precios'  		SELECT 'Clave' = CONVERT(varchar(50), Lista) 		FROM ListaPrecios   ORDER BY Lista ELSE
IF @Campo = 'Tipo de Servicio'    SELECT 'Clave' = CONVERT(varchar(50), Tipo)  	    FROM ServicioTipo ORDER BY Tipo  ELSE
IF @Campo = 'Region'              SELECT 'Clave' = CONVERT(varchar(50), Region)       FROM SucursalRegion ORDER BY Region  ELSE
IF @Campo = 'Tipo de Contrato'    SELECT 'Clave' = CONVERT(varchar(50), Tipo)         FROM VentaContratoTipo ELSE
IF @Campo = 'Proyecto'            SELECT 'Clave' = CONVERT(varchar(50), Proyecto)     FROM Proy ELSE
SELECT 'Clave' = CONVERT(varchar(50), NULL)
RETURN
END

