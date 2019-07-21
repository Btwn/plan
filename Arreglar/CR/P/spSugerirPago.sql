SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSugerirPago
@ID			int,
@Empresa		char(5),
@Moneda		char(10),
@Proveedor		char(10),
@Vencimiento	datetime

AS BEGIN
DECLARE
@Maximo		float,
@Renglon		float,
@Aplica		char(20),
@AplicaID		char(20),
@Importe		money,
@AbonoMaximo	money,
@TotalCargos	money,
@TotalAbonos	money
SELECT @Maximo = ISNULL(MaximoAplicacionPagos, 0) FROM Prov WHERE Proveedor = @Proveedor
SELECT @Renglon = 0, @TotalCargos = 0.0, @TotalAbonos = 0.0
BEGIN TRANSACTION
DELETE CxpD WHERE ID = @ID
DECLARE crCxp CURSOR FOR
SELECT fn.Mov, fn.MovID, fn.Saldo
FROM dbo.fnCxpInfo(@Empresa, @Proveedor, @Proveedor) fn
JOIN CxpDMov c ON fn.Mov = c.Mov
WHERE fn.Moneda = @Moneda AND fn.Vencimiento <= @Vencimiento
ORDER BY Saldo DESC
OPEN crCxp
FETCH NEXT FROM crCxp INTO @Aplica, @AplicaID, @Importe
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Renglon = @Renglon + 2048
IF @Importe > 0
SELECT @TotalCargos = @TotalCargos + @Importe
ELSE
BEGIN
SELECT @AbonoMaximo = @TotalCargos * (@Maximo/100.0)
IF @TotalAbonos - @Importe > @AbonoMaximo
SELECT @Importe = -(@AbonoMaximo - @TotalAbonos)
SELECT @TotalAbonos = @TotalAbonos - @Importe
END
IF @Importe <> 0.0
INSERT CxpD (ID,  Renglon,  Aplica,  AplicaID,  Importe)
VALUES (@ID, @Renglon, @Aplica, @AplicaID, @Importe)
END
FETCH NEXT FROM crCxp INTO @Aplica, @AplicaID, @Importe
END 
CLOSE crCxp
DEALLOCATE crCxp
SELECT @Importe = SUM(Importe) FROM CxpD WHERE ID = @ID
UPDATE Cxp SET Importe = @Importe, Impuestos = NULL, AplicaManual = 1 WHERE ID = @ID
COMMIT TRANSACTION
RETURN
END

