SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE SpAddendaSorianaASSENSA
@ID         int ,
@Referencia varchar(20)

AS BEGIN
DECLARE
@cmd  varchar(90),
@Cantidad  int,
@Factor    int,
@Paquete   int,
@Empaque   int,
@Until     int,
@i         int,
@j         int;
SET NOCOUNT ON
SET CONCAT_NULL_YIELDS_NULL OFF
TRUNCATE TABLE LayoutSoriana
CREATE TABLE #CFDSoriana
(
Orden   int         NULL,
Alfa    varchar(2)  COLLATE Database_Default NULL,
Tipo    varchar(5)  COLLATE Database_Default NULL,
C1		 varchar(20) COLLATE Database_Default NULL,
C2		 varchar(20) COLLATE Database_Default NULL,
C3		 varchar(20) COLLATE Database_Default NULL,
C4		 varchar(20) COLLATE Database_Default NULL,
C5		 varchar(20) COLLATE Database_Default NULL,
C6		 varchar(20) COLLATE Database_Default NULL,
C7		 varchar(20) COLLATE Database_Default NULL,
);
CREATE TABLE #Layout
(
Orden  int,
Alfa   varchar(2)   COLLATE Database_Default NULL,
Campo  varchar(200) COLLATE Database_Default NULL,
)
SELECT 'FolioFactura' =v1.MovID,
'FolioPedido'  =v3.MovID,
'Proveedor'    =CONVERT(varchar,REPLACE(STR((v3.cliente),8,0),' ','0')),
'Sucursal'     =v3.enviara,
'Articulo'     =vd.articulo,
'CodigoBarras' =cb.codigo,
'Paquete'      =vd.paquete,
'Factor'       =au.Factor,
'Cantidad'     =(ISNULL(vd.cantidada,0)),
'Cajas'        =(ISNULL(vd.cantidada,0)/au.factor),
'PrecioEmpaque'=(ISNULL(vd.Precio,0) * au.factor),
vd.Precio,
vd.DescripcionExtra
INTO #Pedido
FROM Venta v1 JOIN Venta v2  ON  v1.Origen=v2.Mov AND v1.OrigenID=v2.MovID
JOIN ( SELECT ID,Aplica,AplicaID
FROM VentaD a WHERE ID=(
SELECT b.ID  FROM Venta a JOIN Venta b  ON  a.Origen=b.Mov AND a.OrigenID=b.MovID
WHERE a.Mov IN('Factura','Factura CFD') AND a.ID =@ID
)
GROUP BY ID,Aplica,AplicaID
) vd1  ON vd1.ID =v2.ID
JOIN Venta  v3    ON v3.Mov=vd1.Aplica  AND v3.MovID=Vd1.AplicaID
JOIN VentaD vd    ON vd.ID=v3.ID
LEFT OUTER JOIN cb           ON vd.articulo = cb.cuenta
LEFT OUTER JOIN artunidad au ON au.Articulo =vd.Articulo
WHERE  v1.ID =@ID
AND v1.Referencia =@Referencia
AND v1.Mov IN  ('Factura','Factura CFD')
AND v3.estatus <>'CANCELADO'
AND au.Unidad  = 'Empaque'
AND vd.Articulo IN (SELECT Articulo FROM VentaD WHERE ID=@ID)
ORDER BY v3.MovID
ALTER TABLE #Pedido ADD  ID Int Identity
SELECT @Until=COUNT(0),@i=1 FROM #Pedido
WHILE @i <=  @Until
BEGIN
SELECT @Cantidad=Cantidad,
@Factor  =Factor,
@Paquete =Paquete,
@Empaque =Cajas,
@j=1
FROM #Pedido  WHERE ID=@i
IF @Cantidad>@Factor
BEGIN
UPDATE #Pedido SET Cantidad=@Factor,Cajas=1 WHERE  ID=@i
WHILE @j <=  @Empaque
BEGIN
SELECT @Cantidad=@Cantidad-@Factor,@Paquete =@Paquete +1
IF @Cantidad=0 BREAK
INSERT INTO #Pedido
SELECT FolioFactura,FolioPedido,Proveedor,Sucursal,Articulo,CodigoBarras,
@Paquete,@Factor,@Factor,1,PrecioEmpaque,Precio,DescripcionExtra
FROM #Pedido WHERE ID=@i
SET @j=@j+1
END
END
SET @i=@i+1
END
ALTER TABLE #Pedido DROP COLUMN ID
SELECT 'FolioFactura'    =FolioFactura+SPACE(10-LEN(FolioFactura)),FolioPedido,Proveedor,CodigoBarras,
'Sucursal'        =CONVERT(varchar,REPLACE(STR((Sucursal),10,0),' ','0')),
'NumCajaTarima'   =CONVERT(varchar,REPLACE(STR((Paquete) ,8,0 ),' ','0')),
'UnidadCompra'    =CONVERT(varchar,REPLACE(STR((Factor)  ,8,0 ),' ','0')),
'Tienda'          =0,
'CodigoCajaTarima'=0
INTO #AddendaPedidos
FROM #Pedido
INSERT  INTO #CFDSoriana (Orden,Alfa,Tipo,C1,C2,C3,C4,C5)
SELECT  1,'A','[P]',Proveedor,FolioFactura,FolioPedido,Tienda,CONVERT(varchar,REPLACE(STR((COUNT (0) )  ,8,0 ),' ','0')) FROM #AddendaPedidos
GROUP BY Proveedor,FolioFactura,FolioPedido,Tienda
INSERT  INTO #CFDSoriana (Orden,Alfa,Tipo,C1,C2,C3,C4,C5,C6)
SELECT  DENSE_RANK() OVER (ORDER BY NumCajaTarima,Sucursal),'B','[C]',Proveedor,FolioFactura,NumCajaTarima,CodigoCajaTarima,Sucursal,
CONVERT(varchar,REPLACE(STR((COUNT (0) )  ,8,0 ),' ','0'))
FROM #AddendaPedidos
GROUP BY Proveedor,FolioFactura,NumCajaTarima,CodigoCajaTarima,Sucursal
ORDER BY NumCajaTarima,Sucursal
INSERT  INTO #CFDSoriana (Orden,Alfa,Tipo,C1,C2,C3,C4,C5,C6,C7)
SELECT  DENSE_RANK() OVER (ORDER BY NumCajaTarima,Sucursal),'C','[A]',Proveedor,FolioFactura,FolioPedido,NumCajaTarima,Sucursal,CodigoBarras,UnidadCompra FROM #AddendaPedidos
ORDER BY NumCajaTarima,Sucursal
INSERT INTO #Layout
SELECT Orden,Alfa,Tipo+'|'+C1+'|'+C2+'|'+C3+'|'+C4+'|'+C5 FROM #CFDSoriana WHERE Alfa='A' order by Orden,Alfa
INSERT INTO #Layout
SELECT Orden,Alfa,Tipo+'|'+C1+'|'+C2+'|'+C3+'|'+C4+'|'+C5+'|'+C6 from #CFDSoriana a WHERE Alfa='B'
INSERT INTO #Layout
SELECT Orden,Alfa,Tipo+'|'+C1+'|'+C2+'|'+C3+'|'+C4+'|'+C5+'|'+C6+'|'+C7 from  #CFDSoriana a WHERE Alfa='C'
INSERT INTO #Layout
SELECT 1000,'D','[F]'
SELECT Campo FROM #Layout ORDER BY Orden,Alfa
SET CONCAT_NULL_YIELDS_NULL ON
RETURN
END

