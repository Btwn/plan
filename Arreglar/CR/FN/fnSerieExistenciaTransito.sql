SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSerieExistenciaTransito(
@SerieLote		varchar(50),
@Articulo		varchar(20),
@SubCuenta		varchar(50),
@Empresa		varchar(5)
)
RETURNS bit
AS
BEGIN
DECLARE @Valor	bit
IF EXISTS(SELECT i.ID
FROM SerieLoteMov sm
JOIN Inv i ON sm.Empresa = i.Empresa AND sm.Modulo = 'INV' AND sm.ID = i.ID
JOIN InvD id ON i.ID = id.ID AND sm.Articulo = id.Articulo AND ISNULL(id.SubCuenta, '') = ISNULL(sm.SubCuenta, '') AND id.RenglonID = sm.RenglonID
JOIN MovTipo mt ON i.Mov = mt.Mov
JOIN Art ON id.Articulo = Art.Articulo
WHERE sm.Articulo = @Articulo
AND ISNULL(sm.SubCuenta, '') = ISNULL(@SubCuenta, '')
AND i.Empresa = @Empresa
AND sm.SerieLote = @SerieLote
AND mt.Clave IN('INV.TI', 'INV.TIF', 'INV.TIS')
AND i.Estatus IN('PENDIENTE', 'SINCRO')
AND Art.Tipo IN ('SERIE', 'VIN'))
SELECT @Valor = 1
ELSE
SELECT @Valor = 0
RETURN @Valor
END

