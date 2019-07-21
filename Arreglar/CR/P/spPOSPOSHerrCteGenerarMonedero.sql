SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSPOSHerrCteGenerarMonedero
@Estacion   int

AS
BEGIN
DECLARE
@Cliente      varchar(10),
@ID           int,
@Consecutivo  int,
@Ok           int,
@Monedero     varchar(20)
DECLARE crArticulo CURSOR FOR
SELECT ID, Cliente
FROM POSHerrCteFrecuente
WHERE ID IN (SELECT ID FROM ListaID  WHERE Estacion = @Estacion)
OPEN crArticulo
FETCH NEXT FROM crArticulo INTO @ID, @Cliente
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Consecutivo = COUNT(*)
FROM POSValeSerie
WHERE Cliente = @Cliente
SELECT @Consecutivo = ISNULL(NULLIF(@Consecutivo,0),1)
SELECT @Monedero = @Cliente + '-'+CONVERT(varchar,@Consecutivo+1)
WHILE EXISTS(SELECT * FROM POSValeSerie WHERE Serie = @Monedero)
BEGIN
SELECT @Consecutivo = @Consecutivo +1
SELECT @Monedero = @Cliente + '-'+CONVERT(varchar,@Consecutivo)
END
UPDATE POSHerrCteFrecuente SET Monedero = @Monedero WHERE ID = @ID
FETCH NEXT FROM crArticulo INTO @ID, @Cliente
END
CLOSE crArticulo
DEALLOCATE crArticulo
END

