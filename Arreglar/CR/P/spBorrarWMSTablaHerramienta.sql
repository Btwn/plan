SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spBorrarWMSTablaHerramienta
@Estacion		int

AS BEGIN
DECLARE
@InfoContacto		varchar(50)
SELECT @InfoContacto = InfoContacto FROM RepParam WHERE Estacion = @Estacion
IF @InfoContacto = '(Todos)'
UPDATE RepParam
SET InfoContactoRuta		= NULL,
InfoContactoEstado	= NULL,
InfoContactoZona		= NULL,
InfoContactoPais		= NULL,
InfoContactoCP		= NULL,
InfoClienteEnviarA   = NULL,
InfoContactoEspecifico = NULL,
InfoArticuloEsp		= NULL
WHERE Estacion = @Estacion
ELSE
IF @InfoContacto = 'Almacen'
UPDATE RepParam
SET InfoContactoGrupo	= NULL,
InfoContactoFam		= NULL,
InfoContactoCat		= NULL,
InfoContactoRuta		= NULL,
InfoContactoEstado	= NULL,
InfoContactoZona		= NULL,
InfoContactoPais		= NULL,
InfoContactoCP		= NULL,
InfoClienteEnviarA   = NULL,
InfoContactoEspecifico = NULL,
InfoArticuloEsp		= NULL
WHERE Estacion = @Estacion
ELSE
IF @InfoContacto = 'Proveedor'
UPDATE RepParam
SET InfoContactoGrupo	= NULL,
InfoContactoRuta		= NULL,
InfoContactoEstado	= NULL,
InfoContactoZona		= NULL,
InfoContactoPais		= NULL,
InfoContactoCP		= NULL,
InfoClienteEnviarA   = NULL,
InfoContactoEspecifico = NULL,
InfoArticuloEsp		= NULL
WHERE Estacion = @Estacion
RETURN
END

