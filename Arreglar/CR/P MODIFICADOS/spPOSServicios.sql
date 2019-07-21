SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSServicios
@ID		varchar(255)

AS
BEGIN
SELECT
A.ID,
A.Empresa,
A.Mov,
A.MovID,
A.FechaEmision,
A.Moneda,
A.TipoCambio,
A.Usuario,
A.Referencia,
A.Estatus,
A.Cliente,
A.Nombre,
A.Cajero,
A.CtaDinero,
A.CtaDineroDestino,
A.Sucursal,
B.Articulo,
B.Cantidad,
B.Precio,
B.LDIServicio,
C.FormaPago,
C.Importe,
D.Referencia1,
D.Referencia2,
'Carrier'=SUBSTRING(Referencia2,294,8),
D.Referencia3,
E.Nombre,
E.RFC,
E.Direccion,
E.DireccionNumero,
E.DireccionNumeroInt,
E.Colonia,
E.CodigoPostal,
E.Estado,
E.Telefonos,
F.Nombre,
F.Colonia,
F.Estado,
F.Telefonos
FROM POSL A WITH (NOLOCK)
JOIN POSLVenta B WITH (NOLOCK) ON B.ID=A.ID
JOIN  POSLCobro C WITH (NOLOCK) ON C.ID=A.ID
LEFT OUTER JOIN POSLDIVentaID D WITH (NOLOCK) ON D.ID=A.ID
JOIN Empresa E WITH (NOLOCK) ON E.Empresa=A.Empresa
JOIN Sucursal F WITH (NOLOCK) ON F.Sucursal=A.Sucursal
WHERE A.ID=@ID
RETURN
END

