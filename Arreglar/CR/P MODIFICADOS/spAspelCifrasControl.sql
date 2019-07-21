SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spAspelCifrasControl]

AS DECLARE
@Origen		decimal(17,5),
@Destino	decimal(17,5)
BEGIN
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspelCifrasControl]') AND type in (N'U'))
DROP TABLE [dbo].[AspelCifrasControl]
CREATE TABLE AspelCifrasControl
(
Descripcion	varchar(50),
Origen		decimal(17,5),
Destino		decimal(17,5)
)
SELECT @Origen = count(*) FROM AspelCargaProp WITH (NOLOCK)
WHERE Campo = 'Cliente'
SELECT @Destino = count(*) FROM Cte WITH (NOLOCK)
INSERT INTO AspelCifrasControl(Descripcion, Origen, Destino)
VALUES ('Clientes', @Origen, @Destino)
SELECT @Origen = count(*) FROM AspelCargaProp WITH (NOLOCK) 
WHERE Campo = 'Proveedor'
SELECT @Destino = count(*) FROM Prov WITH (NOLOCK) 
WHERE Observaciones like 'Aspel:%'
INSERT INTO AspelCifrasControl(Descripcion, Origen, Destino)
VALUES ('Proveedores', @Origen, @Destino)
SELECT @Origen = count(*) FROM AspelCargaProp WITH (NOLOCK) 
WHERE Campo = 'Articulo'
SELECT @Destino = count(*) FROM Art WITH (NOLOCK) 
INSERT INTO AspelCifrasControl(Descripcion, Origen, Destino)
VALUES ('Articulos', @Origen, @Destino)
INSERT INTO AspelCifrasControl(Descripcion, Origen, Destino)
VALUES ('Proveedores', @Origen, @Destino)
SELECT @Origen = count(*) FROM AspelCargaProp WITH (NOLOCK) 
WHERE Campo = 'Almacen'
SELECT @Destino = count(*) FROM Alm WITH (NOLOCK) 
INSERT INTO AspelCifrasControl(Descripcion, Origen, Destino)
VALUES ('Almacenes', @Origen, @Destino)
SELECT @Origen = count(*) FROM AspelCargaProp WITH (NOLOCK) 
WHERE Campo = 'Agente'
SELECT @Destino = count(*) FROM Agente WITH (NOLOCK) 
INSERT INTO AspelCifrasControl(Descripcion, Origen, Destino)
VALUES ('Agentes', @Origen, @Destino)
SELECT @Origen = count(*) FROM AspelCargaProp WITH (NOLOCK) 
WHERE Campo = 'Moneda'
SELECT @Destino = count(*) FROM Mon WITH (NOLOCK) 
INSERT INTO AspelCifrasControl(Descripcion, Origen, Destino)
VALUES ('Monedas', @Origen, @Destino)
SELECT @Origen = count(*) FROM AspelCargaProp WITH (NOLOCK) 
WHERE Campo = 'Unidad'
SELECT @Destino = count(*) FROM ArtUnidad WITH (NOLOCK) 
INSERT INTO AspelCifrasControl(Descripcion, Origen, Destino)
VALUES ('Unidades', @Origen, @Destino)
SELECT @Origen = count(*) FROM CTA WITH (NOLOCK) 
SELECT @Destino = count(*) FROM CTA WITH (NOLOCK) 
INSERT INTO AspelCifrasControl(Descripcion, Origen, Destino)
VALUES ('Cuentas', @Origen, @Destino)
SELECT @Origen = convert(decimal(15,2),SUM((Precio * Cantidad) - (Precio * Cantidad * Descuento1 / 100)))
FROM AspelCargaReg WITH (NOLOCK) 
WHERE Modulo = 'VTAS' AND Mov = 'Facasp'
SELECT @Destino = convert(decimal(15,2), sum(Importe))
FROM Venta WITH (NOLOCK) 
WHERE Mov = 'Facasp'
INSERT INTO AspelCifrasControl(Descripcion, Origen, Destino)
VALUES ('Facturas', @Origen, @Destino)
SELECT @Origen = convert(decimal(15,2),SUM((Precio * Cantidad) - (Precio * Cantidad * Descuento1 / 100)))
FROM AspelCargaReg WITH (NOLOCK) 
WHERE Modulo = 'VTAS' AND Mov = 'Devasp'
SELECT @Destino = convert(decimal(15,2), sum(Importe))
FROM Venta WITH (NOLOCK) 
WHERE Mov = 'Devasp'
INSERT INTO AspelCifrasControl(Descripcion, Origen, Destino)
VALUES ('Dev. Facturas', @Origen, @Destino)
SELECT @Origen = convert(decimal(15,2),SUM(debe))
FROM AspelCargaReg WITH (NOLOCK) 
WHERE Modulo = 'COMS' AND Mov = 'Compasp'
SELECT @Destino = convert(decimal(15,2), sum(Importe))
FROM Compra WITH (NOLOCK) 
WHERE Mov = 'Compasp'
INSERT INTO AspelCifrasControl(Descripcion, Origen, Destino)
VALUES ('Compras', @Origen, @Destino)
SELECT @Origen = convert(decimal(15,2),SUM(Haber))
FROM AspelCargaReg WITH (NOLOCK) 
WHERE Modulo = 'COMS' AND Mov = 'Devasp'
SELECT @Destino = convert(decimal(15,2), sum(Importe))
FROM Compra WITH (NOLOCK) 
WHERE Mov = 'Devasp'
INSERT INTO AspelCifrasControl(Descripcion, Origen, Destino)
VALUES ('Dev. Compras', @Origen, @Destino)
SELECT @Origen = convert(decimal(15,2),SUM(Debe + Haber))
FROM AspelCargaReg WITH (NOLOCK) 
WHERE Modulo = 'CxC'
SELECT @Destino = convert(decimal(15,2), sum(Importe))
FROM CxC WITH (NOLOCK) 
INSERT INTO AspelCifrasControl(Descripcion, Origen, Destino)
VALUES ('CxC', @Origen, @Destino)
SELECT @Origen = convert(decimal(15,2),SUM(Debe + Haber))
FROM AspelCargaReg WITH (NOLOCK) 
WHERE Modulo = 'CxP'
SELECT @Destino = convert(decimal(15,2), sum(Importe))
FROM CxP WITH (NOLOCK) 
INSERT INTO AspelCifrasControl(Descripcion, Origen, Destino)
VALUES ('CxP', @Origen, @Destino)
SELECT @Origen = convert(decimal(15,2),SUM(Debe))
FROM AspelCargaReg WITH (NOLOCK) 
WHERE Modulo = 'INV'
SELECT @Destino = convert(decimal(15,2), sum(Importe))
FROM Inv WITH (NOLOCK) 
INSERT INTO AspelCifrasControl(Descripcion, Origen, Destino)
VALUES ('Movimientos Inventario', @Origen, @Destino)
SELECT @Origen = convert(decimal(15,2),SUM(Debe + haber))
FROM AspelCargaReg WITH (NOLOCK) 
WHERE Modulo = 'CONT'
SELECT @Destino = convert(decimal(15,2), isnull(sum(Importe),0))
FROM Cont WITH (NOLOCK) 
WHERE Estatus = 'CONCLUIDO'
INSERT INTO AspelCifrasControl(Descripcion, Origen, Destino)
VALUES ('Polizas', @Origen, @Destino)
SELECT * FROM AspelCifrasControl WITH (NOLOCK) 
END

