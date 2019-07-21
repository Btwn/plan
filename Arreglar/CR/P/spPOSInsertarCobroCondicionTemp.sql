SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spPOSInsertarCobroCondicionTemp
@ID      		varchar(50),
@Empresa        varchar(5),
@Estacion       int,
@Sucursal       int,
@Usuario        varchar(10)

AS
BEGIN
DECLARE
@POSImpuestoIncluido		bit,
@ArticuloRedondeo			varchar(20),
@ArtOfertaFP				varchar(20),
@ArtOfertaImporte			varchar(20),
@CodigoRedondeo				varchar(30),
@Mes						varchar(35),
@Categoria					varchar(35),
@Grupo						varchar(35),
@Familia					varchar(35),
@Linea						varchar(35),
@Fabricante					varchar(35),
@Articulo					varchar(35),
@FormaPago					varchar(45),
@FechaD						datetime,
@FechaA						datetime,
@HoraD						varchar(5),
@HoraA						varchar(5),
@Hoy						dateTime
SELECT @Hoy = dbo.fnfechasinhora(GETDATE())
TRUNCATE TABLE FormaPagoPos
SELECT @POSImpuestoIncluido = ISNULL(ImpuestoIncluido,0),@CodigoRedondeo = RedondeoVentaCodigo , @ArtOfertaFP = ArtOfertaFP, @ArtOfertaImporte = ArtOfertaImporte
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @ArticuloRedondeo = cb.Cuenta
FROM CB
WHERE CB.Cuenta = @CodigoRedondeo AND CB.TipoCuenta = 'Articulos'
IF EXISTS(SELECT * FROM POSCobroCondicionTemp WHERE Estacion = @Estacion)
DELETE POSCobroCondicionTemp WHERE Estacion = @Estacion
INSERT POSCobroCondicionTemp(
Estacion, ID, Renglon, Cantidad, Articulo, FormaPago,
Precio, PrecioTotal)
SELECT
@Estacion, @ID, p.Renglon, p.Cantidad, p.Articulo, '',
CASE WHEN @POSImpuestoIncluido =1
THEN p.PrecioImpuestoInc
ELSE p.Precio
END, (p.Cantidad - ISNULL(p.CantidadObsequio, 0.0)) * ISNULL((p.PrecioImpuestoInc - (p.PrecioImpuestoInc * (ISNULL(p.DescuentoLinea,0.0)/100))),0.0)
FROM POSLVenta p
LEFT OUTER JOIN OfertaD od ON  p.Articulo = od.Articulo
LEFT OUTER JOIN Oferta o ON  od.ID = o.ID
LEFT OUTER JOIN MovTipo mt ON  o.Mov  = mt.Mov AND mt.Modulo = 'OFER' AND mt.Clave = 'OFER.OF'
WHERE p.ID = @ID
AND ISNULL((p.Cantidad - ISNULL(p.CantidadObsequio, 0.0)) * ISNULL((p.Precio - (p.Precio * (ISNULL(p.DescuentoLinea,0.0)/100))),0.0),0.0) >0.0
AND p.Articulo NOT IN(@ArticuloRedondeo,@ArtOfertaFP,@ArtOfertaImporte )
AND p.RenglonTipo <> 'K'
AND o.Estatus = 'VIGENTE'
AND o.Forma =  'Meses sin Intereses'
AND od.Articulo = p.Articulo
AND o.FechaD IS NULL AND o.FormaPago IS NOT NULL
GROUP BY p.Renglon, p.Cantidad, p.Articulo, p.PrecioImpuestoInc, p.Precio , p.Cantidad ,p.CantidadObsequio, p.PrecioImpuestoInc, p.PrecioImpuestoInc, p.DescuentoLinea
DECLARE CrPOSInt CURSOR LOCAL FOR
SELECT Articulo
FROM POSCobroCondicionTemp
OPEN CrPOSInt
FETCH NEXT FROM CrPOSInt INTO @Articulo
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
INSERT INTO FormaPagoPos (
ID, Articulo, FormaPago)
SELECT
@ID, @Articulo, Oferta.FormaPago
FROM Oferta
LEFT OUTER JOIN OfertaD ON Oferta.ID = OfertaD.ID
LEFT OUTER JOIN MovTipo ON MovTipo.Mov = Oferta.Mov AND MovTipo.Modulo = 'OFER'
WHERE Oferta.Estatus = 'VIGENTE' AND Oferta.Forma = 'Meses sin Intereses' AND Oferta.Mov ='Oferta Normal'
AND OfertaD.Articulo = @Articulo AND Oferta.FechaD IS NULL AND Oferta.FormaPago IS NOT NULL
SELECT  @FormaPago = Oferta.FormaPago
FROM Oferta
LEFT OUTER JOIN OfertaD ON Oferta.ID = OfertaD.ID
LEFT OUTER JOIN MovTipo ON MovTipo.Mov = Oferta.Mov AND MovTipo.Modulo = 'OFER'
WHERE Oferta.Estatus = 'VIGENTE' AND Oferta.Forma = 'Meses sin Intereses' AND Oferta.Mov ='Oferta Normal'
AND OfertaD.Articulo = @Articulo AND Oferta.FechaD IS NULL AND Oferta.FormaPago IS NOT NULL
IF @FormaPago IS NULL
DELETE POSCobroCondicionTemp WHERE Estacion = @Estacion
SELECT
@Categoria = Categoria,
@Grupo = Oferta.Grupo,
@Familia = Oferta.Familia,
@Linea = Oferta.Linea,
@Fabricante = Oferta.Fabricante,
@FormaPago = Oferta.FormaPago,
@FechaD = Oferta.FechaD,
@FechaA = Oferta.FechaA,
@HoraD = Oferta.HoraD,
@HoraA = Oferta.HoraA
FROM Oferta
LEFT OUTER JOIN OfertaD ON Oferta.ID = OfertaD.ID
LEFT OUTER JOIN MovTipo ON MovTipo.Mov = Oferta.Mov AND MovTipo.Modulo = 'OFER'
WHERE Oferta.Estatus = 'VIGENTE' AND Oferta.Forma = 'Meses sin Intereses' AND Oferta.Mov ='Oferta Grupal'
IF @Categoria IS NOT NULL
BEGIN
IF EXISTS (SELECT * FROM ART WHERE Categoria = @Categoria AND Articulo = @Articulo)
BEGIN
INSERT INTO FormaPagoPos (
ID, Articulo, FormaPago)
VALUES(
@ID, @Articulo, @FormaPago)
END
END
IF @Grupo IS NOT NULL
BEGIN
IF EXISTS (SELECT * FROM ART WHERE Grupo = @Grupo AND Articulo = @Articulo)
BEGIN
INSERT INTO FormaPagoPos (
ID, Articulo, FormaPago)
VALUES(
@ID, @Articulo, @FormaPago)
END
END
IF @Familia IS NOT NULL
BEGIN
IF EXISTS (SELECT * FROM ART WHERE Familia = @Familia AND Articulo = @Articulo)
BEGIN
INSERT INTO FormaPagoPos (
ID, Articulo, FormaPago)
VALUES(
@ID, @Articulo, @FormaPago)
END
END
IF @Linea IS NOT NULL
BEGIN
IF EXISTS (SELECT * FROM ART WHERE Linea = @Linea AND Articulo = @Articulo)
BEGIN
INSERT INTO FormaPagoPos (
ID, Articulo, FormaPago)
VALUES(
@ID, @Articulo, @FormaPago)
END
END
IF @Fabricante IS NOT NULL
BEGIN
IF EXISTS (SELECT * FROM ART WHERE Fabricante = @Fabricante AND Articulo = @Articulo)
BEGIN
INSERT INTO FormaPagoPos (
ID, Articulo, FormaPago)
VALUES(
@ID, @Articulo, @FormaPago)
END
END
END
FETCH NEXT FROM CrPOSInt INTO @Articulo
END
CLOSE CrPOSInt
DEALLOCATE CrPOSInt
IF EXISTS (SELECT * FROM POSCobroCondicionTemp WHERE ID = @ID)
SELECT  1
ELSE
SELECT 0
END

