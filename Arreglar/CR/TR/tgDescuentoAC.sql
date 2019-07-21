SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgDescuentoAC ON Descuento

FOR INSERT, UPDATE
AS BEGIN
DECLARE
@Descuento  varchar(50),
@Porcentaje float
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Porcentaje = 100 - ((100-ISNULL(Descuento1,0))/100 * (100-ISNULL(Descuento2,0))/100 * (100-ISNULL(Descuento3,0))/100 * (100-ISNULL(Descuento4,0))/100 * (100-ISNULL(Descuento5,0))/100 * (100-ISNULL(Descuento6,0))/100 * (100-ISNULL(Descuento7,0))/100 * (100-ISNULL(Descuento8,0))/100 * (100-ISNULL(Descuento9,0))/100 * (100-ISNULL(Descuento10,0))/100 ) * 100,
@Descuento  = Descuento
FROM Inserted
UPDATE Descuento SET Porcentaje = @Porcentaje WHERE Descuento = @Descuento
END

