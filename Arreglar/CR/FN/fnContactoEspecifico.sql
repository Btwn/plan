SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnContactoEspecifico (@ContAutoContactoEsp varchar(50), @Contacto varchar(10), @ContactoAplica varchar(10), @ContactoDetalle varchar(10), @Agente varchar(10), @Personal varchar(10), @CtaDinero varchar(10), @CtaDineroDestino varchar(10), @Almacen varchar(10), @AlmacenDestino varchar(10), @AlmacenDetalle varchar(10))
RETURNS varchar(10)

AS BEGIN
DECLARE
@Resultado varchar(10)
SELECT @Resultado = NULL
SELECT @Resultado =
CASE UPPER(@ContAutoContactoEsp)
WHEN 'CONTACTO'		THEN @Contacto
WHEN 'CONTACTO APLICA'		THEN @ContactoAplica
WHEN 'CONTACTO DETALLE'	THEN @ContactoDetalle
WHEN 'CONTACTO ARRASTRE'	THEN @ContactoDetalle
WHEN 'AGENTE'			THEN @Agente
WHEN 'PERSONAL'		THEN @Personal
WHEN 'CUENTA DINERO'		THEN @CtaDinero
WHEN 'CUENTA DINERO DESTINO'   THEN @CtaDineroDestino
WHEN 'ALMACEN'			THEN @Almacen
WHEN 'ALMACEN DESTINO'		THEN @AlmacenDestino
WHEN 'ALMACEN DETALLE'		THEN @AlmacenDetalle
END
RETURN(@Resultado)
END

