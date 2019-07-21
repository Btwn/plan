SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spProductosPropuestaEconomica
@ID			INT

AS
BEGIN
DECLARE
@OrigenTipo			VARCHAR(20),
@Origen	     		VARCHAR(20),
@OrigenID			VARCHAR(20)
SELECT @OrigenTipo=OrigenTipo, @Origen=Origen, @OrigenID=OrigenID FROM Venta WHERE ID=@ID
CREATE TABLE #VentaCalcularPropEco
(
ID				    int,
Renglon			    float null,
MaterialServicio    varchar(100) null,
Costo               money null,
Descripcion         varchar(100) null,
RenglonID		    int identity
)
INSERT INTO #VentaCalcularPropEco (ID, Renglon, MaterialServicio, Costo, Descripcion)
SELECT @ID, NULL, b.Articulo, b.Costo+ISNULL(b.Impuesto1,0) Costo, c.Descripcion1
FROM Compra a
LEFT OUTER JOIN CompraD b ON b.ID=a.ID
JOIN Art c ON c.Articulo = b.Articulo
WHERE a.Estatus='CONCLUIDO'
AND OrigenTipo=@OrigenTipo
AND Origen=@Origen
AND OrigenID=@OrigenID
IF  (SELECT COUNT(*) FROM VentaCalcularPropEconomica WHERE ID=@ID)=0
BEGIN
INSERT INTO VentaCalcularPropEconomica (ID, Renglon, MaterialServicio, Costo, Descripcion, RenglonID)
SELECT ID, Renglon, MaterialServicio, Costo, Descripcion, RenglonID FROM #VentaCalcularPropEco
END
RETURN
END

