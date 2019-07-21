SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgListaPreciosDA ON ListaPreciosD

FOR INSERT
AS BEGIN
DECLARE
@Lista	varchar(20),
@Moneda	varchar(10),
@Articulo	varchar(20),
@Region	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Lista = Lista, @Moneda = Moneda, @Articulo = Articulo FROM Inserted
SELECT @Region = Region FROM ListaPrecios WHERE Lista = @Lista AND Moneda = @Moneda
UPDATE ListaPreciosD SET Region = @Region WHERE Lista = @Lista AND Moneda = @Moneda AND Articulo = @Articulo
END

