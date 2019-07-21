SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.vwPNETcteConsultaFacturaD
AS
SELECT d.RenglonID,
CONVERT(INT,RTRIM(ID)) ID,
CASE WHEN d.RenglonTipo = 'C' THEN '    '+a.Descripcion1 ELSE a.Descripcion1 END [Descripcion],
ISNULL(d.SubCuenta,'') AS [SubCuenta],
ISNULL(d.Cantidad,'') AS [Cantidad],
ISNULL(d.Unidad,'') AS [Unidad],
d.Precio AS [Precio],
d.Importe AS [Importe],
CONVERT(FLOAT,ISNULL(d.DescuentoLinea,'')) AS DescuentoLinea,
d.SubTotal AS [SubTotal],
d.Impuestos AS [Impuestos],
d.ImporteTotal AS [ImporteTotal]
FROM	VentaTCalc d JOIN Art a ON d.Articulo = a.Articulo

