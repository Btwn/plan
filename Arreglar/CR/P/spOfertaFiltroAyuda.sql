SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOfertaFiltroAyuda
@Campo		varchar(50)

AS BEGIN
IF @Campo = 'Almacen'  		    SELECT 'Clave' = CONVERT(varchar(50), Almacen), 	'Nombre' = CONVERT(varchar(100), Nombre) FROM Alm		    ELSE
IF @Campo = 'Grupo Almacen'  		SELECT 'Clave' = CONVERT(varchar(50), Grupo), 		'Nombre' = CONVERT(varchar(100), NULL)   FROM AlmGrupo		ELSE
IF @Campo = 'Cliente'  		    SELECT 'Clave' = CONVERT(varchar(50), Cliente), 	'Nombre' = CONVERT(varchar(100), Nombre) FROM Cte		    ELSE
IF @Campo = 'Categoria Cliente'  	SELECT 'Clave' = CONVERT(varchar(50), Categoria), 	'Nombre' = CONVERT(varchar(100), NULL)   FROM CteCat		ELSE
IF @Campo = 'Grupo Cliente'  		SELECT 'Clave' = CONVERT(varchar(50), Grupo), 		'Nombre' = CONVERT(varchar(100), NULL)   FROM CteGrupo		ELSE
IF @Campo = 'Familia Cliente'  	SELECT 'Clave' = CONVERT(varchar(50), Familia), 	'Nombre' = CONVERT(varchar(100), NULL)   FROM CteFam		ELSE
IF @Campo = 'Zona Cliente'  		SELECT 'Clave' = CONVERT(varchar(50), Zona), 		'Nombre' = CONVERT(varchar(100), NULL)   FROM Zona		    ELSE
IF @Campo = 'Agente'  		    SELECT 'Clave' = CONVERT(varchar(50), Agente), 		'Nombre' = CONVERT(varchar(100), Nombre) FROM Agente		ELSE
IF @Campo = 'Categoria Agente'  	SELECT 'Clave' = CONVERT(varchar(50), Categoria), 	'Nombre' = CONVERT(varchar(100), NULL)   FROM AgenteCat		ELSE
IF @Campo = 'Grupo Agente'  		SELECT 'Clave' = CONVERT(varchar(50), Grupo), 		'Nombre' = CONVERT(varchar(100), NULL)   FROM AgenteGrupo	ELSE
IF @Campo = 'Familia Agente'  	SELECT 'Clave' = CONVERT(varchar(50), Familia), 	'Nombre' = CONVERT(varchar(100), NULL)   FROM AgenteFam		ELSE
IF @Campo = 'Movimiento'  		SELECT 'Clave' = CONVERT(varchar(50), Mov), 		'Nombre' = CONVERT(varchar(100), NULL)   FROM MovTipo WHERE Modulo = 'VTAS' ELSE
IF @Campo = 'Moneda'  		    SELECT 'Clave' = CONVERT(varchar(50), Moneda), 		'Nombre' = CONVERT(varchar(100), Nombre) FROM Mon		    ELSE
IF @Campo = 'Condicion Pago'  	SELECT 'Clave' = CONVERT(varchar(50), Condicion), 	'Nombre' = CONVERT(varchar(100), NULL)   FROM Condicion		ELSE
IF @Campo = 'Tipo Forma Pago'  	SELECT 'Clave' = CONVERT(varchar(50), Tipo), 		'Nombre' = CONVERT(varchar(100), NULL)   FROM FormaPagoTipo	ELSE
IF @Campo = 'Forma Envio'  		SELECT 'Clave' = CONVERT(varchar(50), FormaEnvio), 	'Nombre' = CONVERT(varchar(100), NULL)   FROM FormaEnvio	ELSE
IF @Campo = 'Lista Precios'  		SELECT 'Clave' = CONVERT(varchar(50), Lista), 		'Nombre' = CONVERT(varchar(100), NULL)   FROM ListaPrecios  ELSE
IF @Campo = 'Tipo de Servicio'    SELECT 'Clave' = CONVERT(varchar(50), Tipo), 	    'Nombre' = CONVERT(varchar(100), NULL)   FROM ServicioTipo  ELSE
IF @Campo = 'Region'              SELECT 'Clave' = CONVERT(varchar(50), Region), 		'Nombre' = CONVERT(varchar(100), NULL)   FROM SucursalRegion    ELSE
IF @Campo = 'Tipo de Contrato'    SELECT 'Clave' = CONVERT(varchar(50), Tipo), 		'Nombre' = CONVERT(varchar(100), NULL)   FROM VentaContratoTipo ELSE
IF @Campo = 'Proyecto'            SELECT 'Clave' = CONVERT(varchar(50), Proyecto),    'Nombre' = CONVERT(varchar(100), Descripcion)   FROM Proy ELSE
SELECT 'Clave' = CONVERT(varchar(50), NULL),        'Nombre' = CONVERT(varchar(100), NULL)
RETURN
END

