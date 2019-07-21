SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPNETConsultaVtasFactED
@ID varchar(max)
AS BEGIN
SELECT DISTINCT TOP 1500 CASE WHEN d.RenglonTipo = 'C' THEN '    '+a.Descripcion1 ELSE a.Descripcion1 END [Descripcion],
ISNULL(d.SubCuenta,'') AS [SubCuenta],
ISNULL(d.Cantidad,'') AS [Cantidad],
ISNULL(d.Unidad,'') AS [Unidad],
d.Precio AS [Precio],
d.Importe AS [Importe],
CONVERT(FLOAT,ISNULL(d.DescuentoLinea,'')) AS DescuentoLinea,
d.SubTotal AS [SubTotal],
d.Impuestos AS [Impuestos],
d.ImporteTotal AS [ImporteTotal],
d.RenglonID
FROM VentaTCalc d
JOIN Art a ON d.Articulo = a.Articulo
WHERE ID = CONVERT(INT,RTRIM(@ID))
ORDER BY d.RenglonID
RETURN
END

