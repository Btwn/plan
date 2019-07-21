SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgListaPreciosBC ON ListaPrecios

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@ListaA  	varchar(20),
@ListaN	varchar(20),
@MonedaA	varchar(10),
@MonedaN	varchar(10),
@RegionA	varchar(50),
@RegionN	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @ListaN = Lista, @MonedaN = Moneda, @RegionN = Region FROM Inserted
SELECT @ListaA = Lista, @MonedaA = Moneda, @RegionA = Region FROM Deleted
IF @ListaN=@ListaA AND @MonedaN=@MonedaA AND @RegionN=@RegionA RETURN
IF @ListaN IS NULL
BEGIN
DELETE ListaPreciosD   		WHERE Lista = @ListaA AND Moneda = @MonedaA
DELETE ListaPreciosDUnidad  	WHERE Lista = @ListaA AND Moneda = @MonedaA
DELETE ListaPreciosSub 		WHERE Lista = @ListaA AND Moneda = @MonedaA
DELETE ListaPreciosSubUnidad  	WHERE Lista = @ListaA AND Moneda = @MonedaA
DELETE ListaPrecios_H1	 	WHERE Lista = @ListaA AND Moneda = @MonedaA
DELETE ListaPreciosD_H1	 	WHERE Lista = @ListaA AND Moneda = @MonedaA
END ELSE
BEGIN
UPDATE ListaPreciosD   		SET Lista = @ListaN, Moneda = @MonedaN, Region = @RegionN WHERE Lista = @ListaA AND Moneda = @MonedaA
UPDATE ListaPreciosDUnidad   	SET Lista = @ListaN, Moneda = @MonedaN, Region = @RegionN WHERE Lista = @ListaA AND Moneda = @MonedaA
UPDATE ListaPreciosSub 		SET Lista = @ListaN, Moneda = @MonedaN, Region = @RegionN WHERE Lista = @ListaA AND Moneda = @MonedaA
UPDATE ListaPreciosSubUnidad	SET Lista = @ListaN, Moneda = @MonedaN, Region = @RegionN WHERE Lista = @ListaA AND Moneda = @MonedaA
UPDATE ListaPrecios_H1		SET Lista = @ListaN, Moneda = @MonedaN WHERE Lista = @ListaA AND Moneda = @MonedaA
UPDATE ListaPreciosD_H1		SET Lista = @ListaN, Moneda = @MonedaN WHERE Lista = @ListaA AND Moneda = @MonedaA
UPDATE Cte SET ListaPreciosEsp = @ListaN WHERE ListaPreciosEsp = @ListaA
END
END

