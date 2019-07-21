SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOfertaObsequiosMultiples
@Empresa		varchar(5),
@Sucursal		int,
@Moneda			varchar(10),
@TipoCambio		float

AS BEGIN
DECLARE
@OfertaID				int,
@Articulo				varchar(20),
@SubCuenta				varchar(50),
@ArtUnidad              varchar(50),
@Salir					bit,
@CfgOfertaNivelopcion	bit,
@OfertaAplicaLog        bit,
@Tipo                   varchar(50),
@Forma                  varchar(50),
@Usar                   varchar(50)
SELECT @CfgOfertaNivelopcion = ISNULL(OfertaNivelopcion, 0),
@OfertaAplicaLog = ISNULL(OfertaAplicaLog, 0)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
DECLARE @OfertaObsequiosMultiples TABLE(
Orden     int identity(1,1)PRIMARY KEY,
ID		int,
Tipo		varchar(50)NULL,
Forma		varchar(50)NULL,
Usar		varchar(50)NULL)
INSERT @OfertaObsequiosMultiples (ID, Tipo, Forma, Usar)
SELECT o.ID,o.Tipo,o.Forma,o.Usar
FROM Oferta o
JOIN MovTipo mt ON mt.Modulo = 'OFER' AND mt.Mov = o.Mov AND mt.Clave = 'OFER.OM'
JOIN #OfertaActiva oa ON oa.ID = o.ID
ORDER BY o.Prioridad ASC,o.MontoMinimo*o.TipoCambio DESC, o.FechaEmision  ASC
SELECT @Salir = 0
DECLARE crOfertaObsequiosMultiples CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
SELECT ID, Tipo, Forma, Usar
FROM @OfertaObsequiosMultiples
OPEN crOfertaObsequiosMultiples
FETCH NEXT FROM crOfertaObsequiosMultiples INTO @OfertaID, @Tipo, @Forma, @Usar
WHILE @@FETCH_STATUS <> -1 AND @Salir = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Articulo = NULL
IF @CfgOfertaNivelopcion = 1
SELECT @Articulo = MIN(o.Articulo), @SubCuenta = MIN(ISNULL(o.SubCuenta, '')),@ArtUnidad = MIN(ISNULL(o.Unidad, ''))
FROM OfertaD o
JOIN #VentaD d ON d.Articulo = o.Articulo AND ISNULL(d.SubCuenta, '') = ISNULL(o.SubCuenta, '') AND d.Unidad = o.Unidad
WHERE o.ID = @OfertaID
ELSE
SELECT @Articulo = MIN(o.Articulo),@ArtUnidad = MIN(ISNULL(o.Unidad, ''))
FROM OfertaD o
JOIN #VentaD d ON d.Articulo = o.Articulo AND d.Unidad = o.Unidad
WHERE o.ID = @OfertaID
IF @Articulo IS NOT NULL
BEGIN
UPDATE #VentaD
SET CantidadObsequio = 1.0,
OfertaID = @OfertaID
WHERE NULLIF(OfertaID, 0) IS NULL
AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = @SubCuenta AND Unidad = @ArtUnidad
SELECT @Salir = 1
IF @OfertaAplicaLog = 1 AND @OfertaID IS NOT NULL
EXEC spOfertaLog @OfertaID,@Tipo, @Forma, @Usar, @Articulo, @SubCuenta, @ArtUnidad, @ArticuloObsequio = @Articulo, @ArtCantidadTotal = 1
END
END
FETCH NEXT FROM crOfertaObsequiosMultiples INTO @OfertaID, @Tipo, @Forma, @Usar
END  
CLOSE crOfertaObsequiosMultiples
DEALLOCATE crOfertaObsequiosMultiples
RETURN
END

