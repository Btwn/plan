SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepCartaPorte
(
@Estacion		int,
@Modulo			varchar(5),
@Empresa		varchar(5),
@ID				int
)

AS
BEGIN
IF @Modulo = 'VTAS'
BEGIN
SELECT A.ModuloID, ISNULL(F.Direccion,'') AS Calle, ISNULL(F.DireccionNumero,'') AS NumeroExt, ISNULL(F.DireccionNumeroInt,'') AS NumeroInt,
ISNULL(F.Delegacion,'') AS Delegacion, ISNULL(F.Colonia,'') AS Colonia, ISNULL(F.Poblacion,'') AS Poblacion, ISNULL(F.Estado,'') AS Estado,
ISNULL(F.CodigoPostal,'') AS CodigoPostal, ISNULL(F.RFC,'') AS RFC,dbo.fnDivideRenglon(A.CadenaOriginal,140) AS CadenaOriginal, A.NoCertificado,
A.NoCertificadoSAT, A.UUID, ISNULL(A.Condicion,'NA') AS Condicion, ISNULL(A.FormaPago,'') AS FormaPago, ISNULL(A.Moneda,'') AS Moneda,
ISNULL(D.Direccion,'') AS CalleCte, ISNULL(D.DireccionNumero,'') AS NumeroExtCte, ISNULL(D.DireccionNumeroInt,'') AS NumeroIntCte, ISNULL(D.Delegacion,'') AS DelegacionCte,
ISNULL(D.Colonia,'') AS ColoniaCte, ISNULL(D.Poblacion,'') AS PoblacionCte, ISNULL(D.Estado,'') AS EstadoCte, ISNULL(D.CodigoPostal,'') AS CodigoPostalCte,
ISNULL(D.RFC,'') AS RFCCte, ISNULL(B.Importe,0) AS Importe, ISNULL(B.Impuestos,0) AS Impuestos, ISNULL(B.Retenciones,0) AS Retenciones,
ISNULL(E.Direccion,'') AS CalleAlm, ISNULL(E.Colonia, '') AS ColoniaAlm, ISNULL(E.Delegacion,'') AS DelegacionAlm, ISNULL(E.Poblacion, '') AS PoblacionAlm,
ISNULL(E.Estado,'') AS EstadoAlm, ISNULL(G.Descripcion1,'')+' '+ISNULL(G.Descripcion2,'') AS ArtNombre, B.Cantidad, B.Unidad,
B.Precio, H.Nombre AS NombreEmpresa, D.Nombre AS NombreCte, ISNULL(A.Observaciones,'') AS Observaciones,
II.Mov AS Embarque, I.Importe AS ImporteEmb, ISNULL(I.Impuestos,0) AS ImpuestosEmb, I.Peso,
I.Volumen, I.Paquetes,
CASE WHEN ISNULL(K.Proveedor,'') = '' THEN ISNULL(H.RFC,'') ELSE ISNULL(K.RFC,'') END AS RFCProv,
CASE WHEN ISNULL(K.Proveedor,'') = '' THEN ISNULL(H.Nombre,'') ELSE ISNULL(K.Nombre,'') END AS NombreProv,
CASE WHEN ISNULL(K.Proveedor,'') = '' THEN ISNULL(H.FiscalRegimen,'') ELSE ISNULL(L.Descripcion,'') END AS RegimenFiscalProv,
CASE WHEN ISNULL(K.Proveedor,'') = '' THEN ISNULL(F.Direccion,'') ELSE ISNULL(K.Direccion,'') END AS CalleProv,
CASE WHEN ISNULL(K.Proveedor,'') = '' THEN ISNULL(F.DireccionNumero,'') ELSE ISNULL(K.DireccionNumero,'') END AS NumeroExtProv,
CASE WHEN ISNULL(K.Proveedor,'') = '' THEN ISNULL(F.DireccionNumeroInt,'') ELSE ISNULL(K.DireccionNumeroInt,'') END AS NumeroIntProv,
CASE WHEN ISNULL(K.Proveedor,'') = '' THEN ISNULL(F.Colonia,'') ELSE ISNULL(K.Colonia,'') END AS ColoniaProv,
CASE WHEN ISNULL(K.Proveedor,'') = '' THEN ISNULL(F.Delegacion,'') ELSE ISNULL(K.Delegacion,'') END AS DelegacionProv,
CASE WHEN ISNULL(K.Proveedor,'') = '' THEN ISNULL(F.Poblacion,'') ELSE ISNULL(K.Poblacion,'') END AS PoblacionProv,
CASE WHEN ISNULL(K.Proveedor,'') = '' THEN ISNULL(F.Estado,'') ELSE ISNULL(K.Estado,'') END AS EstadoProv,
CASE WHEN ISNULL(K.Proveedor,'') = '' THEN ISNULL(F.CodigoPostal,'') ELSE ISNULL(K.CodigoPostal,'') END AS CodigoPostalProv,
A.FechaTimbrado, G.MaterialPeligroso, I.Vencimiento
FROM MovCartaPorte A
JOIN MovCartaPorteD B ON B.ModuloID = A.ModuloID AND B.Modulo = A.Modulo
JOIN ListaID C ON C.Estacion = A.Estacion AND C.ID = A.ModuloID
JOIN Cte D ON D.Cliente = A.Cliente
JOIN Alm E ON E.Almacen = A.Almacen
JOIN Sucursal F ON F.Sucursal = A.Sucursal
JOIN Art G ON G.Articulo = B.Articulo
JOIN Empresa H ON H.Empresa = @Empresa
JOIN EmbarqueMov I ON I.AsignadoID = A.EmbarqueID
JOIN Embarque II ON II.ID = I.AsignadoID
JOIN EmbarqueD J ON J.ID = I.AsignadoID
LEFT JOIN Prov K ON K.Proveedor = A.Proveedor
LEFT JOIN FiscalRegimen L ON L.FiscalRegimen = K.FiscalRegimen
WHERE C.Estacion = @Estacion
AND A.ModuloID = @ID
END
END

