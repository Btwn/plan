SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCtePresupuesto
@Periodo                int,
@Ejercicio              int,
@Familia                varchar(50),
@VentaNetaFam           float,
@PresupuestoFam         float,
@Moneda                 char(10)

AS BEGIN
DECLARE
@Cliente        char(10),
@EnviarA        int,
@ListaPrecios   varchar(50),
@Cantidad       float,
@Precio         float,
@Importe        money,
@Articulo	    varchar(20)
DECLARE crCteQuiebre CURSOR FOR
SELECT cq.Cliente, cq.EnviarA, c.ListaPrecios, cq.VentaNeta / @VentaNetaFam * @PresupuestoFam
FROM CteQuiebre cq, Cte c
WHERE cq.Familia = @Familia AND cq.Cliente = c.Cliente
OPEN crCteQuiebre
FETCH NEXT FROM crCteQuiebre INTO @Cliente, @EnviarA, @ListaPrecios, @Cantidad
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Articulo = MIN(Articulo) FROM ListaPreciosD WHERE Lista = @ListaPrecios
EXEC spPrecioEsp @ListaPrecios, @Moneda, @Articulo, NULL, @Precio OUTPUT
SELECT @Importe = @Precio * @Cantidad
INSERT CtePresupuesto
(Cliente,  Ejercicio,  Periodo,  EnviarA,  Familia,  Cantidad,  Importe,  ImporteAjustado)
VALUES (@Cliente, @Ejercicio, @Periodo, @EnviarA, @Familia, @Cantidad, @Importe, @Importe)
END
FETCH NEXT FROM crCteQuiebre INTO @Cliente, @EnviarA, @ListaPrecios, @Cantidad
END
CLOSE crCteQuiebre
DEALLOCATE crCteQuiebre
RETURN
END

