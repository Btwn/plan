SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC dbo.spPNetConsultaGarantiaD
@ID     int
AS BEGIN
SELECT a.Descripcion1, vd.Cantidad, vd.Unidad, vd.Precio, vd.DescuentoLinea, vd.DescuentoImporte,
vc.Impuesto1Total - vc.Retencion1Total as Impuestos,
vc.TotalNeto Importe
FROM VentaD vd JOIN VentaTCalc vc ON vd.ID = vc.ID AND vd.Renglon = vc.Renglon
JOIN Art a ON vd.Articulo = a.Articulo
WHERE vd.ID = @ID
RETURN
END

