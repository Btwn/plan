SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOfertaLog
@OfertaID			      int,
@Tipo				        varchar(50),
@Forma				      varchar(50),
@Usar				        varchar(50),
@Articulo			      varchar(20),
@SubCuenta			    varchar(50),
@Unidad				      varchar(50),
@Descuento			    float = 0.00,
@DescuentoImporte	  float = 0.00,
@Costo				      float = 0.00,
@PrecioBaseCosto	  float = 0.00,
@PrecioBaseLista	  float = 0.00,
@Precio				      float = 0.00,
@Puntos				      float = 0.00,
@PuntosPorcentaje	  float = 0.00,
@Comision			      float = 0.00,
@ComisionPorcentaje	float = 0.00,
@ArtCantidadTotal   float = 0.00,
@ArticuloObsequio   varchar(20)=NULL,
@SubCuentaObsequio  varchar(50)=NULL,
@UnidadObsequio		  varchar(50) = NULL,
@DescuentoP1			  float = 0.00,
@DescuentoP2			  float = 0.00,
@DescuentoP3			  float = 0.00,
@DescuentoG1			  float = 0.00,
@DescuentoG2			  float = 0.00,
@DescuentoG3			  float = 0.00,
@OfertaIDP1         int = 0,
@OfertaIDP2         int = 0,
@OfertaIDP3         int = 0,
@OfertaIDG1         int = 0,
@OfertaIDG2         int = 0,
@OfertaIDG3         int = 0,
@Descripcion		    varchar(255) = NULL

AS BEGIN
DECLARE
@Cantidad		int,
@Impuesto		float,
@Empresa		varchar(5),
@Mov				varchar(20),
@MovID			varchar(20),
@Moneda			varchar(20),
@TipoCambio float,
@Prioridad	int,
@PrioridadG	int
SELECT @Mov = Mov,
@MovID = MovID,
@Prioridad = Prioridad,
@PrioridadG = PrioridadG
FROM Oferta
WHERE ID = @OfertaID
IF @ArticuloObsequio IS NOT NULL AND EXISTS(SELECT * FROM #OfertaLog WHERE Articulo = @Articulo AND ArticuloObsequio = @ArticuloObsequio AND UnidadObsequio = @UnidadObsequio and SubCuentaObsequio =@SubCuentaObsequio)
BEGIN
UPDATE #OfertaLog SET CantidadObsequio = CantidadObsequio + 1 WHERE ArticuloObsequio = @ArticuloObsequio AND UnidadObsequio = @UnidadObsequio and SubCuentaObsequio =@SubCuentaObsequio
END
IF @ArticuloObsequio IS NULL OR NOT EXISTS(SELECT * FROM #OfertaLog WHERE Articulo = @Articulo AND ArticuloObsequio = @ArticuloObsequio AND UnidadObsequio = @UnidadObsequio and SubCuentaObsequio = @SubCuentaObsequio)
BEGIN
INSERT #OfertaLog(OfertaID, Prioridad, PrioridadG, Mov, MovID,
Tipo, Forma, Usar, Articulo, SubCuenta,
Unidad, Descuento, DescuentoImporte, Costo, PrecioBaseCosto,
PrecioBaseLista, Precio, Puntos, PuntosPorcentaje, Comision,
ArticuloObsequio, SubCuentaObsequio,	CantidadObsequio, ComisionPorcentaje, UnidadObsequio,
DescuentoP1, DescuentoP2, DescuentoP3, DescuentoG1, DescuentoG2,
DescuentoG3, OfertaIDP1, OfertaIDP2, OfertaIDP3, OfertaIDG1,
OfertaIDG2, OfertaIDG3, Descripcion)
VALUES  (@OfertaID, @Prioridad, @PrioridadG, @Mov, @MovID,
@Tipo, @Forma, @Usar,	@Articulo, @SubCuenta,
@Unidad, @Descuento, @DescuentoImporte, @Costo, @PrecioBaseCosto,
@PrecioBaseLista,	@Precio, @Puntos, @PuntosPorcentaje, @Comision,
@ArticuloObsequio, @SubCuentaObsequio, @ArtCantidadTotal,	@ComisionPorcentaje, @UnidadObsequio,
@DescuentoP1, @DescuentoP2, @DescuentoP3, @DescuentoG1, @DescuentoG2,
@DescuentoG3, @OfertaIDP1, @OfertaIDP2, @OfertaIDP3, @OfertaIDG1,
@OfertaIDG2, @OfertaIDG3, @Descripcion)
END
RETURN
END

