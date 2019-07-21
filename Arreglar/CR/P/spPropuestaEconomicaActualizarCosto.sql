SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spPropuestaEconomicaActualizarCosto
@ID			INT,
@Estacion   INT,
@Renglon    FLOAT

AS
BEGIN
DECLARE
@Costo        money
SELECT @Costo=SUM(Costo) FROM VentaCalcularPropEconomica WHERE ID=@ID AND RenglonID IN (SELECT Clave FROM ListaST WHERE Estacion=@Estacion)
UPDATE VentaD SET Precio = Precio + ISNULL(@Costo,0)  WHERE ID=@ID AND Renglon=@Renglon
UPDATE VentaCalcularPropEconomica SET Renglon=@Renglon WHERE ID=@ID AND RenglonID IN (SELECT Clave FROM ListaST WHERE Estacion=@Estacion)
SELECT 'Asignación Correcta'
RETURN
END

