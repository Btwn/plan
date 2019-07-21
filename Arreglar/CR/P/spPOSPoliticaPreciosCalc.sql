SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSPoliticaPreciosCalc
@FechaEmision		dateTime,
@Agente				varchar(10),
@Moneda				varchar(10),
@TipoCambio			float,
@Condicion			varchar(50),
@Almacen			varchar(10),
@Proyecto			varchar(50),
@FormaEnvio			varchar(50),
@Mov				varchar(20),
@ServicioTipo		varchar(50),
@ContratoTipo		varchar(50),
@Empresa			varchar(50),
@Region				varchar(50),
@Sucursal			int,
@ListaPreciosEsp	varchar(20),
@Cliente			varchar(10),
@Articulo			varchar(20),
@Subcuenta			varchar(50),
@Cantidad			float,
@UnidadVenta		varchar(50),
@Precio				float				OUTPUT,
@Descuento			float				OUTPUT,
@Politica			varchar(MAX) = NULL	OUTPUT,
@DescuentoMonto		float = NULL		OUTPUT

AS
BEGIN
DECLARE
@ArtCat							varchar(50),
@ArtGrupo						varchar(50),
@ArtFam							varchar(50),
@ArtAbc							varchar(1),
@Fabricante						varchar(50),
@ArtLinea						varchar(50),
@ArtRama						varchar(20),
@CteGrupo						varchar(50),
@CteCat							varchar(50),
@CteFam							varchar(50),
@CteZona						varchar(30),
@Tipo							varchar(50),
@Nivel							varchar(50),
@NivelPolitica					varchar(50),
@Costo							money,
@TipoCosteo						varchar(20),
@PrecioLista					money,
@Precio2						money,
@Precio3						money,
@Precio4						money,
@Precio5						money,
@Precio6						money,
@Precio7						money,
@Precio8						money,
@Precio9						money,
@Precio10						money,
@DescuentoAcum					float,
@Ponderado						float,
@CalcDescuento					float,
@PrecioAcum						float,
@PrecioTemp						float,
@Descripcion					varchar(50),
@ConVigencia					bit,
@FechaD							datetime,
@FechaA							datetime,
@PromocionExclusiva				bit,
@CalcDescuentoExclusivo			float,
@DescuentoExclusivo				float,
@PonderadoExclusivo				float,
@PromocionPromocion				bit,
@CalcDescuentoPromocion			float,
@DescuentoPromocion				float,
@PonderadoPromocion				float,
@PromocionParticular			bit,
@CalcDescuentoParticular		float,
@DescuentoParticular			float,
@PonderadoParticular			float,
@PromocionExclusivaAplicada		bit,
@PromocionPromocionAplicada		bit,
@PromocionParticularAplicada	bit
SET @PromocionExclusiva  = 0
SET @PromocionPromocion  = 0
SET @PromocionParticular = 0
SET @PromocionExclusivaAplicada = 0
SET @PromocionPromocionAplicada = 0
SET @PromocionParticularAplicada = 0
SELECT
@ArtCat  = a.Categoria,
@ArtGrupo = a.Grupo,
@ArtFam = a.Familia,
@ArtAbc = a.ABC,
@Fabricante = a.Fabricante,
@ArtLinea = a.Linea,
@ArtRama = a.Rama,
@PrecioLista = a.PrecioLista,
@Precio2 = a.Precio2,
@Precio3 = a.Precio3,
@Precio4 = a.Precio4,
@Precio5 = a.Precio5,
@Precio6 = a.Precio6,
@Precio7 = a.Precio7,
@Precio8 = a.Precio8,
@Precio9 = a.Precio9,
@Precio10 = a.Precio10
FROM Art a
WHERE a.Articulo = @Articulo
SELECT
@CteGrupo = c.Grupo,
@CteCat   = c.Categoria,
@CteFam   = c.Familia,
@CteZona  = c.Zona
FROM Cte c
WHERE c.Cliente = @Cliente
SELECT @TipoCosteo = TipoCosteo
FROM EmpresaCfg ec
WHERE ec.Empresa = @Empresa
EXEC spPCGet @Sucursal, @Empresa, @Articulo, @SubCuenta, @UnidadVenta, @Moneda, @TipoCambio, @ListaPreciosEsp, @PrecioTemp OUTPUT
SELECT @DescuentoMonto = SUM(pd.Monto)
FROM Precio p
INNER JOIN PrecioD pd ON p.ID = pd.ID AND @Cantidad >= pd.Cantidad
WHERE ((ISNULL(p.ConVigencia,0) = 0) OR (@FechaEmision BETWEEN p.FechaD AND p.FechaA))
AND ((ISNULL(p.NivelArticulo,0) = 0) OR (p.Articulo = @Articulo))
AND ((ISNULL(p.NivelSubCuenta,0) = 0) OR (p.SubCuenta = @Subcuenta))
AND ((ISNULL(p.NivelUnidadVenta,0) = 0) OR (p.UnidadVenta = @UnidadVenta))
AND ((ISNULL(p.NivelArtCat,0) = 0) OR (p.ArtCat = @ArtCat))
AND ((ISNULL(p.NivelArtGrupo,0) = 0) OR (p.ArtGrupo = @ArtGrupo))
AND ((ISNULL(p.NivelArtFam,0) = 0) OR (p.ArtFam = @ArtFam))
AND ((ISNULL(p.NivelArtABC,0) = 0) OR (p.ArtAbc = @ArtAbc))
AND ((ISNULL(p.NivelFabricante,0) = 0) OR (p.Fabricante = @Fabricante))
AND ((ISNULL(p.NivelArtLinea,0) = 0) OR (p.ArtLinea = @ArtLinea))
AND ((ISNULL(p.NivelArtRama,0) = 0) OR (p.ArtRama = @ArtRama))
AND ((ISNULL(p.NivelCliente,0) = 0) OR (p.Cliente = @Cliente))
AND ((ISNULL(p.NivelCteGrupo,0) = 0) OR (p.CteGrupo = @CteGrupo))
AND ((ISNULL(p.NivelCteCat,0) = 0) OR (p.CteCat = @CteCat))
AND ((ISNULL(p.NivelCteFam,0) = 0) OR (p.CteFam = @CteFam))
AND ((ISNULL(p.NivelCteZona,0) = 0) OR (p.CteZona = @CteZona))
AND ((ISNULL(p.NivelAgente,0) = 0) OR (p.Agente = @Agente))
AND ((ISNULL(p.NivelMoneda,0) = 0) OR (p.Moneda = @Moneda))
AND ((ISNULL(p.NivelCondicion,0) = 0) OR (p.Condicion = @Condicion))
AND ((ISNULL(p.NivelAlmacen,0) = 0) OR (p.Almacen = @Almacen))
AND ((ISNULL(p.NivelProyecto,0) = 0) OR (p.Proyecto = @Proyecto))
AND ((ISNULL(p.NivelFormaEnvio,0) = 0) OR (p.FormaEnvio = @FormaEnvio))
AND ((ISNULL(p.NivelMov,0) = 0) OR (p.Mov = @Mov))
AND ((ISNULL(p.NivelServicioTipo,0) = 0) OR (p.ServicioTipo = @ServicioTipo))
AND ((ISNULL(p.NivelContratoTipo,0) = 0) OR (p.ContratoTipo = @ContratoTipo))
AND ((ISNULL(p.NivelEmpresa,0) = 0) OR (p.Empresa = @Empresa))
AND ((ISNULL(p.NivelRegion,0) = 0) OR (p.Region = @Region))
AND ((ISNULL(p.NivelSucursal,0) = 0) OR (p.Sucursal = @Sucursal))
AND ((ISNULL(p.ListaPrecios,'Todas') = 'Todas') OR (p.ListaPrecios = @ListaPreciosEsp))
AND p.Tipo LIKE '$ Descuento%'
AND p.Estatus = 'ACTIVA'
AND pd.Cantidad = (SELECT MAX(Cantidad)
FROM PrecioD pd2
WHERE p.ID = pd2.ID
AND @Cantidad >= pd2.Cantidad)
DECLARE crDescto CURSOR LOCAL FOR
SELECT pd.Monto,
p.Nivel,
p.Descripcion,
p.FechaD,
p.FechaA,
p.ConVigencia
FROM Precio p
INNER JOIN PrecioD pd ON p.ID = pd.ID AND @Cantidad >= pd.Cantidad
WHERE ((ISNULL(p.ConVigencia,0) = 0) OR (@FechaEmision BETWEEN p.FechaD AND p.FechaA))
AND ((ISNULL(p.NivelArticulo,0) = 0) OR (p.Articulo = @Articulo))
AND ((ISNULL(p.NivelSubCuenta,0) = 0) OR (p.SubCuenta = @Subcuenta))
AND ((ISNULL(p.NivelUnidadVenta,0) = 0) OR (p.UnidadVenta = @UnidadVenta))
AND ((ISNULL(p.NivelArtCat,0) = 0) OR (p.ArtCat = @ArtCat))
AND ((ISNULL(p.NivelArtGrupo,0) = 0) OR (p.ArtGrupo = @ArtGrupo))
AND ((ISNULL(p.NivelArtFam,0) = 0) OR (p.ArtFam = @ArtFam))
AND ((ISNULL(p.NivelArtABC,0) = 0) OR (p.ArtAbc = @ArtAbc))
AND ((ISNULL(p.NivelFabricante,0) = 0) OR (p.Fabricante = @Fabricante))
AND ((ISNULL(p.NivelArtLinea,0) = 0) OR (p.ArtLinea = @ArtLinea))
AND ((ISNULL(p.NivelArtRama,0) = 0) OR (p.ArtRama = @ArtRama))
AND ((ISNULL(p.NivelCliente,0) = 0) OR (p.Cliente = @Cliente))
AND ((ISNULL(p.NivelCteGrupo,0) = 0) OR (p.CteGrupo = @CteGrupo))
AND ((ISNULL(p.NivelCteCat,0) = 0) OR (p.CteCat = @CteCat))
AND ((ISNULL(p.NivelCteFam,0) = 0) OR (p.CteFam = @CteFam))
AND ((ISNULL(p.NivelCteZona,0) = 0) OR (p.CteZona = @CteZona))
AND ((ISNULL(p.NivelAgente,0) = 0) OR (p.Agente = @Agente))
AND ((ISNULL(p.NivelMoneda,0) = 0) OR (p.Moneda = @Moneda))
AND ((ISNULL(p.NivelCondicion,0) = 0) OR (p.Condicion = @Condicion))
AND ((ISNULL(p.NivelAlmacen,0) = 0) OR (p.Almacen = @Almacen))
AND ((ISNULL(p.NivelProyecto,0) = 0) OR (p.Proyecto = @Proyecto))
AND ((ISNULL(p.NivelFormaEnvio,0) = 0) OR (p.FormaEnvio = @FormaEnvio))
AND ((ISNULL(p.NivelMov,0) = 0) OR (p.Mov = @Mov))
AND ((ISNULL(p.NivelServicioTipo,0) = 0) OR (p.ServicioTipo = @ServicioTipo))
AND ((ISNULL(p.NivelContratoTipo,0) = 0) OR (p.ContratoTipo = @ContratoTipo))
AND ((ISNULL(p.NivelEmpresa,0) = 0) OR (p.Empresa = @Empresa))
AND ((ISNULL(p.NivelRegion,0) = 0) OR (p.Region = @Region))
AND ((ISNULL(p.NivelSucursal,0) = 0) OR (p.Sucursal = @Sucursal))
AND ((ISNULL(p.ListaPrecios,'Todas') = 'Todas') OR (p.ListaPrecios = @ListaPreciosEsp))
AND p.Tipo = '% Descuento'
AND p.Estatus = 'ACTIVA'
AND pd.Cantidad = (SELECT MAX(Cantidad)
FROM PrecioD pd2
WHERE p.ID = pd2.ID
AND @Cantidad >= pd2.Cantidad)
OPEN crDescto
FETCH NEXT FROM CrDescto INTO @DescuentoAcum, @Nivel, @Descripcion, @FechaD, @FechaA, @ConVigencia
IF @Nivel IN ('Exclusiva')
BEGIN
SET @PromocionExclusivaAplicada = 1
SET @PromocionExclusiva = 1
END
ELSE
IF @Nivel IN ('Promocion')
BEGIN
SET @PromocionPromocionAplicada = 1
SET @PromocionPromocion = 1
END
ELSE
IF @Nivel IN ('Particular')
BEGIN
SET @PromocionParticularAplicada = 1
SET @PromocionParticular = 1
END
SELECT @Ponderado = 100
SELECT @CalcDescuento = (@DescuentoAcum /100) * @Ponderado
SELECT @Descuento = @CalcDescuento
SELECT @Ponderado = @Ponderado - @CalcDescuento
SELECT @PonderadoExclusivo = 100
SELECT @CalcDescuentoExclusivo = (@DescuentoAcum /100) * @PonderadoExclusivo
SELECT @DescuentoExclusivo = @CalcDescuentoExclusivo
SELECT @PonderadoExclusivo = @PonderadoExclusivo - @CalcDescuentoExclusivo
SELECT @PonderadoPromocion = 100
SELECT @CalcDescuentoPromocion = (@DescuentoAcum /100) * @PonderadoPromocion
SELECT @DescuentoPromocion = @CalcDescuentoPromocion
SELECT @PonderadoPromocion = @PonderadoPromocion - @CalcDescuentoPromocion
SELECT @PonderadoParticular = 100
SELECT @CalcDescuentoParticular = (@DescuentoAcum /100) * @PonderadoParticular
SELECT @DescuentoParticular = @CalcDescuentoParticular
SELECT @PonderadoParticular = @PonderadoParticular - @CalcDescuentoParticular
WHILE @@FETCH_STATUS = 0
BEGIN
FETCH NEXT FROM CrDescto INTO @DescuentoAcum, @Nivel, @Descripcion, @FechaD, @FechaA, @ConVigencia
IF @@FETCH_STATUS = 0
BEGIN
IF @Nivel IN ('Exclusiva')
BEGIN
SET @PromocionExclusiva = 1
END
ELSE IF @Nivel IN ('Promocion')
BEGIN
SET @PromocionPromocion = 1
END
ELSE IF @Nivel IN ('Particular')
BEGIN
SET @PromocionParticular = 1
END
SELECT @CalcDescuento = (@DescuentoAcum /100) * @Ponderado
SELECT @Descuento = @Descuento + @CalcDescuento
SELECT @Ponderado = @Ponderado - @CalcDescuento
IF (@Nivel IN ('Siempre')) OR (@Nivel IN ('Exclusiva') AND @PromocionExclusivaAplicada = 0)
BEGIN
SELECT @CalcDescuentoExclusivo = (@DescuentoAcum /100) * @PonderadoExclusivo
SELECT @DescuentoExclusivo = @DescuentoExclusivo + @CalcDescuentoExclusivo
SELECT @PonderadoExclusivo = @PonderadoExclusivo - @CalcDescuentoExclusivo
IF @Nivel IN ('Exclusiva') SET @PromocionExclusivaAplicada = 1
END
ELSE IF (@Nivel IN ('Siempre')) OR (@Nivel IN ('Promocion') AND @PromocionPromocionAplicada = 0)
BEGIN
SELECT @CalcDescuentoPromocion = (@DescuentoAcum /100) * @PonderadoPromocion
SELECT @DescuentoPromocion = @DescuentoPromocion + @CalcDescuentoPromocion
SELECT @PonderadoPromocion = @PonderadoPromocion - @CalcDescuentoPromocion
IF @Nivel IN ('Promocion') SET @PromocionPromocionAplicada = 1
END
ELSE IF (@Nivel IN ('Siempre')) OR (@Nivel IN ('Particular') AND @PromocionParticularAplicada = 0)
BEGIN
SELECT @CalcDescuentoParticular = (@DescuentoAcum /100) * @PonderadoParticular
SELECT @DescuentoParticular = @DescuentoParticular + @CalcDescuentoParticular
SELECT @PonderadoParticular = @PonderadoParticular - @CalcDescuentoParticular
IF @Nivel IN ('Particular') SET @PromocionParticularAplicada = 1
END
END
END
CLOSE crDescto
DEALLOCATE crDescto
IF @PromocionPromocion = 1
SET @Descuento = @DescuentoPromocion
ELSE IF @PromocionPromocion = 0 AND @PromocionParticular = 1
SET @Descuento = @DescuentoParticular
ELSE IF @PromocionPromocion = 0 AND @PromocionParticular = 0 AND @PromocionExclusiva = 1
SET @Descuento = @DescuentoExclusivo
EXEC spVerCosto @Sucursal, @Empresa, NULL, @Articulo, @Subcuenta, @UnidadVenta, @TipoCosteo, @Moneda, @TipoCambio, @MovCosto = @Costo OUTPUT, @ConReturn = 0
SELECT Precio = CASE WHEN p.Tipo = 'Precio' THEN MIN(ISNULL(pd.Monto,0))
WHEN p.Tipo = 'Precio=Costo+[%]' THEN MIN(@Costo + (@Costo * (ISNULL(pd.Monto,0) / 100.00)))
WHEN p.Tipo = 'Precio=Costo+[$]' THEN MIN(@Costo + ISNULL(pd.Monto,0))
WHEN p.Tipo = 'Precio=Costo+[% margen]' THEN MIN(@Costo / (1 - (ISNULL(pd.Monto,0) / 100.00)))
WHEN p.Tipo = 'Precio=Costo*[Factor]' THEN MIN(@Costo * pd.Monto)
WHEN p.Tipo = 'Precio=Precio+[%]' THEN MIN(@PrecioTemp + (@PrecioTemp * (ISNULL(pd.Monto,0) / 100.00)))
WHEN p.Tipo = 'Precio=Precio Lista+[%]' THEN MIN(@PrecioLista + (@PrecioLista * (ISNULL(pd.Monto,0) / 100.00)))
WHEN p.Tipo = 'Precio=Precio 2+[%]' THEN MIN(@Precio2 + (@Precio2 * (ISNULL(pd.Monto,0) / 100.00)))
WHEN p.Tipo = 'Precio=Precio 3+[%]' THEN MIN(@Precio3 + (@Precio3 * (ISNULL(pd.Monto,0) / 100.00)))
WHEN p.Tipo = 'Precio=Precio 4+[%]' THEN MIN(@Precio4 + (@Precio4 * (ISNULL(pd.Monto,0) / 100.00)))
WHEN p.Tipo = 'Precio=Precio 5+[%]' THEN MIN(@Precio5 + (@Precio5 * (ISNULL(pd.Monto,0) / 100.00)))
WHEN p.Tipo = 'Precio=Precio 6+[%]' THEN MIN(@Precio6 + (@Precio6 * (ISNULL(pd.Monto,0) / 100.00)))
WHEN p.Tipo = 'Precio=Precio 7+[%]' THEN MIN(@Precio7 + (@Precio7 * (ISNULL(pd.Monto,0) / 100.00)))
WHEN p.Tipo = 'Precio=Precio 8+[%]' THEN MIN(@Precio8 + (@Precio8 * (ISNULL(pd.Monto,0) / 100.00)))
WHEN p.Tipo = 'Precio=Precio 9+[%]' THEN MIN(@Precio9 + (@Precio9 * (ISNULL(pd.Monto,0) / 100.00)))
WHEN p.Tipo = 'Precio=Precio 10+[%]' THEN MIN(@Precio10 + (@Precio10 * (ISNULL(pd.Monto,0) / 100.00)))
END,
Orden = CASE WHEN p.Tipo = 'Precio' THEN 1
WHEN p.Tipo = 'Precio=Costo+[%]' THEN 2
WHEN p.Tipo = 'Precio=Costo+[$]' THEN 3
WHEN p.Tipo = 'Precio=Costo+[% margen]' THEN 4
WHEN p.Tipo = 'Precio=Costo*[Factor]' THEN 5
WHEN p.Tipo = 'Precio=Precio+[%]' THEN 6
WHEN p.Tipo = 'Precio=Precio Lista+[%]' THEN 7
WHEN p.Tipo = 'Precio=Precio 2+[%]' THEN 8
WHEN p.Tipo = 'Precio=Precio 3+[%]' THEN 9
WHEN p.Tipo = 'Precio=Precio 4+[%]' THEN 10
WHEN p.Tipo = 'Precio=Precio 5+[%]' THEN 11
WHEN p.Tipo = 'Precio=Precio 6+[%]' THEN 12
WHEN p.Tipo = 'Precio=Precio 7+[%]' THEN 13
WHEN p.Tipo = 'Precio=Precio 8+[%]' THEN 14
WHEN p.Tipo = 'Precio=Precio 9+[%]' THEN 15
WHEN p.Tipo = 'Precio=Precio 10+[%]' THEN 16
ELSE 99999999
END,
p.Tipo,
p.Nivel
INTO #PrecioTemp
FROM Precio p
INNER JOIN PrecioD pd ON p.ID = pd.ID AND @Cantidad >= pd.Cantidad
WHERE ((ISNULL(p.ConVigencia,0) = 0) OR (@FechaEmision BETWEEN p.FechaD AND p.FechaA))
AND ((ISNULL(p.NivelArticulo,0) = 0) OR (p.Articulo = @Articulo))
AND ((ISNULL(p.NivelSubCuenta,0) = 0) OR (p.SubCuenta = @Subcuenta))
AND ((ISNULL(p.NivelUnidadVenta,0) = 0) OR (p.UnidadVenta = @UnidadVenta))
AND ((ISNULL(p.NivelArtCat,0) = 0) OR (p.ArtCat = @ArtCat))
AND ((ISNULL(p.NivelArtGrupo,0) = 0) OR (p.ArtGrupo = @ArtGrupo))
AND ((ISNULL(p.NivelArtFam,0) = 0) OR (p.ArtFam = @ArtFam))
AND ((ISNULL(p.NivelArtABC,0) = 0) OR (p.ArtAbc = @ArtAbc))
AND ((ISNULL(p.NivelFabricante,0) = 0) OR (p.Fabricante = @Fabricante))
AND ((ISNULL(p.NivelArtLinea,0) = 0) OR (p.ArtLinea = @ArtLinea))
AND ((ISNULL(p.NivelArtRama,0) = 0) OR (p.ArtRama = @ArtRama))
AND ((ISNULL(p.NivelCliente,0) = 0) OR (p.Cliente = @Cliente))
AND ((ISNULL(p.NivelCteGrupo,0) = 0) OR (p.CteGrupo = @CteGrupo))
AND ((ISNULL(p.NivelCteCat,0) = 0) OR (p.CteCat = @CteCat))
AND ((ISNULL(p.NivelCteFam,0) = 0) OR (p.CteFam = @CteFam))
AND ((ISNULL(p.NivelCteZona,0) = 0) OR (p.CteZona = @CteZona))
AND ((ISNULL(p.NivelAgente,0) = 0) OR (p.Agente = @Agente))
AND ((ISNULL(p.NivelMoneda,0) = 0) OR (p.Moneda = @Moneda))
AND ((ISNULL(p.NivelCondicion,0) = 0) OR (p.Condicion = @Condicion))
AND ((ISNULL(p.NivelAlmacen,0) = 0) OR (p.Almacen = @Almacen))
AND ((ISNULL(p.NivelProyecto,0) = 0) OR (p.Proyecto = @Proyecto))
AND ((ISNULL(p.NivelFormaEnvio,0) = 0) OR (p.FormaEnvio = @FormaEnvio))
AND ((ISNULL(p.NivelMov,0) = 0) OR (p.Mov = @Mov))
AND ((ISNULL(p.NivelServicioTipo,0) = 0) OR (p.ServicioTipo = @ServicioTipo))
AND ((ISNULL(p.NivelContratoTipo,0) = 0) OR (p.ContratoTipo = @ContratoTipo))
AND ((ISNULL(p.NivelEmpresa,0) = 0) OR (p.Empresa = @Empresa))
AND ((ISNULL(p.NivelRegion,0) = 0) OR (p.Region = @Region))
AND ((ISNULL(p.NivelSucursal,0) = 0) OR (p.Sucursal = @Sucursal))
AND ((ISNULL(p.ListaPrecios,'Todas') = 'Todas') OR (p.ListaPrecios = @ListaPreciosEsp))
AND p.Tipo LIKE ('Precio%')
AND p.Estatus = 'ACTIVA'
AND pd.Cantidad = (SELECT MAX(Cantidad)
FROM PrecioD pd2
WHERE p.ID = pd2.ID
AND @Cantidad >= pd2.Cantidad)
GROUP BY p.Tipo, p.Nivel
ORDER BY Orden
SELECT TOP 1
@Precio = Precio,
@NivelPolitica = Nivel
FROM #PrecioTemp
ORDER BY Orden
IF @NivelPolitica = 'Exclusiva'
SELECT @Descuento = 0
END

