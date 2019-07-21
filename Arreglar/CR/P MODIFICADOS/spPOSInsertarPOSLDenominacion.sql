SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertarPOSLDenominacion
@Estacion     int,
@ID           varchar(36)

AS
BEGIN
DECLARE
@FormaPago          varchar(50),
@Denominacion       float,
@Nombre             varchar(50),
@Cantidad           int
IF EXISTS(SELECT * FROM POSLDenominacionTemp WITH(NOLOCK) WHERE ID = @ID AND Estacion = @Estacion)
BEGIN
DECLARE crDenominacion CURSOR FOR
SELECT FormaPago, Denominacion,Nombre, ISNULL(Cantidad,0)
FROM POSLDenominacionTemp WITH(NOLOCK)
WHERE ID = @ID AND Estacion = @Estacion
OPEN crDenominacion
FETCH NEXT FROM crDenominacion INTO  @FormaPago, @Denominacion, @Nombre, @Cantidad
WHILE @@FETCH_STATUS <> -1
BEGIN
IF NOT EXISTS(SELECT * FROM POSLDenominacion WHERE ID = @ID AND FormaPago = @FormaPago AND Denominacion =@Denominacion)
INSERT POSLDenominacion(
ID, FormaPago, Denominacion, Nombre, Cantidad)
SELECT
@ID, @FormaPago, @Denominacion, @Nombre, @Cantidad
ELSE
UPDATE   POSLDenominacion WITH(ROWLOCK)
SET Cantidad = Cantidad+@Cantidad
WHERE ID = @ID AND FormaPago = @FormaPago AND Denominacion =@Denominacion
FETCH NEXT FROM crDenominacion INTO @FormaPago, @Denominacion, @Nombre, @Cantidad
END
CLOSE crDenominacion
DEALLOCATE crDenominacion
END
END

