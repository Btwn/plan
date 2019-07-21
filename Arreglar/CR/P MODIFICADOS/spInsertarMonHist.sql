SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInsertarMonHist
@Estacion             int,
@Moneda	        varchar(10),
@Sucursal	        int

AS BEGIN
INSERT MonHist(Moneda, Fecha, TipoCambio, Sucursal, FechaSinHora)
SELECT         Moneda, Fecha, TipoCambio, Sucursal, dbo.fnFechaSinHora(Fecha)
FROM MonHistTemp
WITH(NOLOCK) WHERE Estacion = @Estacion
EXCEPT
SELECT Moneda, Fecha, TipoCambio, Sucursal, FechaSinHora
FROM MonHist WITH(NOLOCK)
WHERE Moneda = @Moneda AND Sucursal = @Sucursal
DELETE  MonHistTemp WHERE Estacion = @Estacion
SELECT 'SE ACTUALIZARON LOS REGISTROS EXISTOSAMENTE'
END

