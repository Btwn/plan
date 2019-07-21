SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovCartaPorte
(
@Estacion		varchar(5),
@Empresa		varchar(5),
@Modulo			varchar(5),
@FechaInicio	datetime,
@FechaFin		datetime
)

AS
BEGIN
DECLARE
@Ruta		varchar(255),
@Ok			int,
@OkRef		varchar(255)
IF @Modulo = 'VTAS'
BEGIN
DELETE FROM MovCartaPorteD WHERE Estacion = @Estacion AND Modulo = @Modulo
DELETE FROM MovCartaPorte WHERE Estacion = @Estacion AND Modulo = @Modulo
INSERT MovCartaPorte(Estacion, Modulo, ModuloID, Mov, MovID, Sucursal,
Almacen, Cliente, Condicion, FormaPago, Moneda, NoCertificado,
NoCertificadoSAT, CadenaOriginal, UUID, EmbarqueID, Proveedor, Ruta, Observaciones,
FechaTimbrado)
SELECT @Estacion, @Modulo, A.ID, A.Mov, A.MovID, A.Sucursal,
A.Almacen, A.Cliente, A.Condicion, A.FormaPagoTipo, A.Moneda, B.NoCertificado,
B.NoCertificadoSAT, B.CadenaOriginal, B.UUID, E.ID, G.Proveedor,
REPLACE(
REPLACE(
REPLACE(C.RutaCartaPorte,'<Empresa>','\'+@Empresa),
'<Ejercicio>','\'+CAST(YEAR(A.FechaEmision) as varchar(4))),
'<Periodo>','\'+CAST(MONTH(A.FechaEmision) as varchar(2))),
ISNULL(E.Observaciones,''),
B.FechaTimbrado
FROM Venta A
JOIN CFD B ON B.ModuloID = A.ID
JOIN MovTipo C ON C.Mov = A.Mov
JOIN EmbarqueMov D ON D.ModuloID = A.ID
JOIN Embarque E ON E.ID = D.AsignadoID
JOIN Vehiculo F ON F.Vehiculo = E.Vehiculo
LEFT JOIN Prov G ON G.Proveedor = F.Proveedor
WHERE A.FechaEmision >= @FechaInicio
AND A.FechaEmision <= @FechaFin
AND A.Empresa = @Empresa
AND B.Modulo = @Modulo
AND C.Modulo = @Modulo
AND ISNULL(C.CartaPorte,0) = 1
AND A.Estatus = C.EstatusCartaPorte
AND B.UUID IS NOT NULL
INSERT MovCartaPorteD(Estacion, Modulo, ModuloID, Renglon, RenglonSub, Articulo, Cantidad,
Unidad, Precio, Importe, Impuestos, Retenciones)
SELECT @Estacion, @Modulo, B.ID, B.Renglon, B.RenglonSub, B.Articulo, B.Cantidad,
B.Unidad, B.Precio, B.Cantidad*B.Precio, ISNULL(B.Impuesto1,0)+ISNULL(B.Impuesto1,0)+ISNULL(B.Impuesto1,0), ISNULL(B.Retencion1,0)+ISNULL(B.Retencion2,0)+ISNULL(B.Retencion3,0)
FROM MovCartaPorte A
JOIN VentaD B ON B.ID = A.ModuloID
WHERE A.Estacion = @Estacion
DECLARE cRuta CURSOR FOR
SELECT DISTINCT B.Ruta
FROM MovTipo A
JOIN MovCartaPorte B
ON A.Modulo = B.Modulo
AND A.Mov = B.Mov
WHERE B.Estacion = @Estacion
OPEN cRuta
FETCH NEXT FROM cRuta INTO @Ruta
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC spCrearRuta @Ruta, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF ISNULL(@Ok,0) = 0
FETCH NEXT FROM cRuta INTO @Ruta
ELSE
BREAK
END
CLOSE cRuta
DEALLOCATE cRuta
IF ISNULL(@Ok,0) <> 0
BEGIN
DELETE FROM MovCartaPorteD WHERE Estacion = @Estacion AND Modulo = @Modulo
DELETE FROM MovCartaPorte WHERE Estacion = @Estacion AND Modulo = @Modulo
SELECT @OkRef
END
END
END

