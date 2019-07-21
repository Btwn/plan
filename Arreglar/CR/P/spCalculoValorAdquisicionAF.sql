SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spCalculoValorAdquisicionAF
@Estacion	    int,
@IdMov		    int,
@Renglon        int,
@Empresa	    varchar(5),
@Modulo         varchar(5),
@Bandera        int = 0,
@Ok			    int          = NULL OUTPUT,
@OkRef		    varchar(255) = NULL OUTPUT

AS BEGIN
SET NOCOUNT ON
DECLARE @Id                 int,
@Ids                int,
@Articulo           varchar(20),
@Serie              varchar(50),
@AFArticulo         varchar(20),
@AFSerie			varchar(50),
@AdquisicionValor   money,
@Importe            money,
@FechaEmision       datetime,
@Cantidad           float,
@DepreciacionInicio datetime,
@Total              money,
@EsActivoFijo       bit,
@SerieLote          varchar(50),
@Renglones          int,
@CantidadNeta       money,
@CostoTotal         money,
@DescLinea          money,
@ImpuestoIVA        bit,
@DescGlobal         money,
@Subtotal           money,
@iva                money,
@Impuesto1          money,
@ImpuestoIVA2       bit,
@SubImpuesto2       money,
@Impuesto           money,
@Costo              money,
@Gastodiverso       money,
@TotalCA            money,
@ImporteMov         money,
@Factor             money,
@TotalGD            money,
@ClaveMov           varchar(20),
@Estatus            varchar(15),
@Conteo             int,
@ConteoID           int,
@RenglonID          int,
@ExisteArt			int,
@ExisteSer			int
IF @Renglon IS NULL
RETURN
IF @Modulo = 'GAS'
BEGIN
IF EXISTS (SELECT * FROM AuxiliarActivoFijo WHERE IDMov = @IdMov AND @Modulo = @Modulo AND Empresa = @Empresa AND Aplicar <> 1)
DELETE AuxiliarActivoFijo WHERE IDMov = @IdMov AND @Modulo = @Modulo AND Empresa = @Empresa
SELECT @Estatus =  Estatus FROM Gasto WHERE ID = @IdMov
IF @Estatus = 'CONCLUIDO'
RETURN
SELECT @ExisteArt = 0, @ExisteSer = 0
IF (SELECT COUNT(AFArticulo) FROM Gasto WHERE ID = @IdMov AND AFArticulo <> '') >= 1
SET @ExisteArt = 1
IF (SELECT COUNT(AFSerie) FROM Gasto WHERE ID = @IdMov AND AFSerie <> '') >= 1
SET @ExisteSer = 1
DECLARE crArtSLS CURSOR FOR
SELECT GD.Importe + ISNULL(GD.Impuestos,0),
G.FechaEmision,
G.AFArticulo,
G.AFSerie,
G.AF,
GD.Cantidad
FROM Gasto AS G
JOIN GastoD AS GD ON GD.ID = G.ID
WHERE G.Id = @IdMov
AND G.Empresa = @Empresa
OPEN crArtSLS
FETCH NEXT FROM crArtSLS INTO @Importe, @FechaEmision, @AFArticulo, @AFSerie, @EsActivoFijo, @Cantidad
WHILE @@FETCH_STATUS = 0
BEGIN
IF ISNULL(@AFArticulo,'') <> '' AND ISNULL(@AFSerie,'') <> '' AND @EsActivoFijo = 1
BEGIN
SELECT @AdquisicionValor   = AdquisicionValor,
@DepreciacionInicio = DepreciacionInicio,
@Id                 = ID
FROM ActivoF
WHERE Articulo = @AFArticulo AND Serie = @AFSerie
AND Empresa = @Empresa
AND @FechaEmision <= ISNULL(DepreciacionInicio,@FechaEmision)
SET @Total = ISNULL(@AdquisicionValor,0) + @Importe
IF /*ISNULL(CONVERT(VARCHAR(50),@AdquisicionValor),'') <> '' AND*/ ISNULL(CONVERT(VARCHAR(50),@DepreciacionInicio),'') <> '' AND ISNULL(@Id,0) > 0
BEGIN
IF EXISTS(SELECT * FROM AuxiliarActivoFijo WHERE IDMov = @IDMov AND Articulo = @AFArticulo AND Serie = @AFSerie)
BEGIN
UPDATE AuxiliarActivoFijo
SET ImporteMov = (ImporteMov + @Importe), Total = (@Total + ImporteMov)
WHERE IDMov = @IDMov AND Articulo = @AFArticulo AND Serie = @AFSerie AND Empresa = @Empresa
END
ELSE
BEGIN
INSERT INTO AuxiliarActivoFijo (ID, IDMov, Renglon, Empresa, Modulo, Articulo, Serie, Cantidad, ValorAdquisicion, ImporteMov, Total, FechaEmision,
FechaInicioDepreciacion)
SELECT  ISNULL(@Id,0), @IDMov, ISNULL(@Renglon,0), @Empresa, @Modulo, @AFArticulo, @AFSerie,  @Cantidad,  @AdquisicionValor, @Importe, @Total, @FechaEmision,
@DepreciacionInicio
EXCEPT
SELECT @Id, IDMov, @Renglon, Empresa, Modulo, Articulo, Serie, Cantidad, ValorAdquisicion, ImporteMov, Total, FechaEmision,
FechaInicioDepreciacion
FROM AuxiliarActivoFijo WHERE IDMov = @IDMov AND Articulo = @AFArticulo AND Serie = @AFSerie
END
END
END
FETCH NEXT FROM crArtSLS INTO @Importe, @FechaEmision, @AFArticulo, @AFSerie, @EsActivoFijo, @Cantidad
END
CLOSE crArtSLS
DEALLOCATE crArtSLS
IF (ISNULL(@AFArticulo,'') = '' OR ISNULL(@AFSerie,'') = '') AND @EsActivoFijo = 1
BEGIN
DECLARE crArtAF CURSOR FOR
SELECT A.id
FROM ListaID A
WHERE A.Estacion = @Estacion
UNION
SELECT B.ID
FROM AuxiliarActivoFijo B
WHERE B.Modulo = @Modulo
AND B.IDMov = @IdMov
AND B.Empresa = @Empresa
OPEN crArtAF
FETCH NEXT FROM crArtAF INTO @Ids
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Importe = 0
SELECT @Importe = SUM((GD.Importe + ISNULL(GD.Impuestos,0)))
FROM Gasto AS G
JOIN GastoD AS GD ON GD.ID = G.ID
WHERE G.Id = @IdMov
AND G.Empresa = @Empresa
SELECT @Conteo = COUNT(*) FROM (SELECT A.id
FROM ListaID A
WHERE A.Estacion = @Estacion
UNION
SELECT B.ID
FROM AuxiliarActivoFijo B
WHERE B.Modulo = @Modulo
AND B.IDMov = @IdMov
AND B.Empresa = @Empresa
) A
SELECT @Importe = ROUND(@Importe / @Conteo,2)
FROM Gasto AS G
JOIN GastoD AS GD ON GD.ID = G.ID
WHERE G.Id = @IdMov
AND GD.Renglon = @Renglon
SELECT @Articulo           = Articulo,
@Serie              = Serie,
@AdquisicionValor   = AdquisicionValor,
@DepreciacionInicio = DepreciacionInicio
FROM ActivoF
WHERE ID = @Ids
AND Empresa = @Empresa
AND @FechaEmision <= ISNULL(DepreciacionInicio,@FechaEmision)
SET @Total = ISNULL(@AdquisicionValor,0) + @Importe
IF ISNULL(@Articulo,'') <> '' AND ISNULL(@Serie, '') <> '' /*AND /SNULL(CONVERT(VARCHAR(50),@AdquisicionValor),'') <> '' */AND ISNULL(CONVERT(VARCHAR(50),@DepreciacionInicio),'') <> ''
BEGIN
IF EXISTS(SELECT * FROM AuxiliarActivoFijo WHERE IDMov = @IDMov AND Articulo = @Articulo AND Serie = @Serie AND Renglon = @Renglon)
BEGIN
UPDATE AuxiliarActivoFijo
SET ImporteMov = @Importe, Total = (@AdquisicionValor + @Importe) 
WHERE IDMov = @IDMov AND Articulo = @Articulo AND Serie = @Serie AND Renglon = @Renglon AND ID = @Ids AND Empresa = @Empresa
END
IF NOT EXISTS(SELECT * FROM AuxiliarActivoFijo WHERE IDMov = @IDMov AND Articulo = @Articulo AND Serie = @Serie AND Renglon = @Renglon)
BEGIN
INSERT INTO AuxiliarActivoFijo (ID, IDMov, Renglon, Empresa, Modulo, Articulo, Serie, Cantidad, ValorAdquisicion, ImporteMov, Total, FechaEmision,
FechaInicioDepreciacion)
SELECT  @Ids, @IDMov, @Renglon, @Empresa, @Modulo, @Articulo, @Serie,  @Cantidad,  @AdquisicionValor, @Importe, @Total, @FechaEmision,
@DepreciacionInicio
EXCEPT
SELECT ID, IDMov, Renglon, Empresa, Modulo, Articulo, Serie, Cantidad, ValorAdquisicion, ImporteMov, Total, FechaEmision,
FechaInicioDepreciacion
FROM AuxiliarActivoFijo WHERE IDMov = @IDMov AND Articulo = @Articulo AND Serie = @Serie AND Renglon = @Renglon
END
END
FETCH NEXT FROM crArtAF INTO @Ids
END
CLOSE crArtAF
DEALLOCATE crArtAF
END
END
IF @Modulo = 'COMS'
BEGIN
IF EXISTS (SELECT * FROM AuxiliarActivoFijo WHERE IDMov = @IdMov AND Modulo = @Modulo AND Empresa = @Empresa)
DELETE AuxiliarActivoFijo WHERE IDMov = @IdMov AND @Modulo = Modulo AND Empresa = @Empresa
SELECT @ExisteArt = 1, @ExisteSer = 1, @Bandera = 1
SET @ConteoID = 0
DECLARE @RenglonLista TABLE (ConteoID int identity(1,1) NOT NULL, RenglonID int NOT NULL)
SELECT @Estatus =  Estatus FROM Compra WHERE ID = @IdMov
IF @Estatus = 'CONCLUIDO'
RETURN
IF NOT EXISTS (SELECT * FROM Compragastodiverso WHERE ID = @IdMov)
RETURN
DECLARE crArtAF CURSOR FOR
SELECT CD.Articulo, CD.Renglon FROM Compra AS C JOIN CompraD AS CD ON CD.ID = C.ID WHERE C.Id = @IdMov AND C.Empresa = @Empresa
OPEN crArtAF
FETCH NEXT FROM crArtAF INTO @Articulo, @Renglon
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Cantidad     = CD.Cantidad,
@FechaEmision = C.FechaEmision,
@ClaveMov     = MovTipo.Clave
FROM Compra AS C JOIN CompraD AS CD ON CD.ID = C.ID
JOIN MovTipo ON C.Mov = MovTipo.Mov AND MovTipo.Modulo = @Modulo
WHERE C.Id = @IdMov AND CD.Renglon = @Renglon
AND C.Empresa = @Empresa
SELECT @ImpuestoIVA  = Impuesto2BaseImpuesto1,
@ImpuestoIVA2 = Impuesto2Info
FROM Version
SELECT @DepreciacionInicio =CASE InicioDepreciacion WHEN 'Siguiente Mes'
THEN DATEADD(MONTH,1,CONVERT(DATETIME,'01/'+CAST(DATEPART(MONTH,@FechaEmision) AS VARCHAR)+'/'+
CAST(DATEPART(YEAR,@FechaEmision) AS VARCHAR)))
WHEN 'Siguiente Año'
THEN DATEADD(YEAR,1,CONVERT(DATETIME,'01/'+CAST(DATEPART(MONTH,@FechaEmision) AS VARCHAR)+'/'+
CAST(DATEPART(YEAR,@FechaEmision) AS VARCHAR)))
ELSE @FechaEmision
END
FROM Art A
JOIN ActivoFCat B
ON A.CategoriaActivoFijo = B.Categoria
WHERE A.Articulo = @Articulo
SET @ConteoID = @ConteoID + 1
DECLARE crArtSLS CURSOR FOR
SELECT DISTINCT RenglonID FROM SerieLoteMov WHERE ID = @IdMov AND Articulo = @Articulo AND Modulo = @Modulo AND Empresa = @Empresa
OPEN crArtSLS
FETCH NEXT FROM crArtSLS INTO @RenglonID
WHILE @@FETCH_STATUS = 0
BEGIN
IF NOT EXISTS (SELECT * FROM @RenglonLista WHERE RenglonID = @RenglonID)
INSERT INTO @RenglonLista (RenglonID) VALUES (@RenglonID)
FETCH NEXT FROM crArtSLS INTO @RenglonID
END
CLOSE crArtSLS
DEALLOCATE crArtSLS
SELECT @RenglonID = RenglonID
FROM @RenglonLista
WHERE ConteoID = @ConteoID
DECLARE crArtSL CURSOR FOR
SELECT Articulo, SerieLote FROM SerieLoteMov WHERE ID = @IdMov AND Articulo = @Articulo AND Modulo = @Modulo AND Empresa = @Empresa AND RenglonID = @RenglonID
OPEN crArtSL
FETCH NEXT FROM crArtSL INTO @Articulo, @SerieLote
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @CantidadNeta = ISNULL(CD.Cantidad,0) - ISNULL(CD.CantidadCancelada,0),
@CostoTotal   = ISNULL(CD.Costo,0), 
@DescLinea    = CASE WHEN ISNULL(CD.DescuentoTipo,'') = '$' THEN ISNULL(CD.DescuentoLinea,0) ELSE @CostoTotal * (ISNULL(CD.DescuentoLinea,0)/100) END,
@Importe      = @CostoTotal - @DescLinea,
@DescGlobal   = @Importe * (ISNULL(C.DescuentoGlobal,0)/100),
@Subtotal     = @Importe - @DescGlobal,
@SubImpuesto2 = CASE WHEN @ImpuestoIVA2 = 1 THEN 0 ELSE @SubTotal * (ISNULL(CD.Impuesto2,0)/100) END,
@Impuesto     = CASE WHEN @ImpuestoIVA = 1 THEN @SubImpuesto2 ELSE 0 END,
@Impuesto1    = ISNULL(CD.Impuesto1,0),
@IVA          = (@Subtotal + @Impuesto) * (ISNULL(cd.Impuesto1,0)/100),
@Costo        = (@Importe + @IVA)* C.TipoCambio
FROM Compra AS C
JOIN CompraD AS CD ON CD.ID = C.ID
WHERE C.Id = @IdMov
AND C.Empresa = @Empresa
AND CD.Renglon = @Renglon
SELECT @Cantidad = @CantidadNeta / COUNT(*) FROM SerieLoteMov WHERE ID = @IdMov AND Articulo = @Articulo AND Modulo = @Modulo AND Empresa = @Empresa
IF @ClaveMov IN ('COMS.EG','COMS.EI')
BEGIN
SELECT @AdquisicionValor   = @CostoTotal,
@Ids                = ID
FROM ActivoF
WHERE Articulo = @Articulo
AND Empresa = @Empresa
ORDER BY ID DESC
END
SET @Total = ISNULL(@AdquisicionValor,0) + @Importe
IF ISNULL(@Articulo,'') <> '' AND ISNULL(@SerieLote, '') <> '' AND ISNULL(@Ids,0) > 0
BEGIN
INSERT INTO AuxiliarActivoFijo (ID, IDMov, Renglon, Empresa, Modulo, Articulo, Serie, Cantidad, ValorAdquisicion, ImporteMov, Total, FechaEmision,
FechaInicioDepreciacion)
SELECT  ISNULL(@Ids,0), @IDMov, ISNULL(@Renglon,0), @Empresa, @Modulo, @Articulo, @SerieLote,  @Cantidad,  @AdquisicionValor, @Costo, 0, @FechaEmision,
@DepreciacionInicio
EXCEPT
SELECT ID, IDMov, Renglon, Empresa, Modulo, Articulo, Serie, Cantidad, ValorAdquisicion, ImporteMov, 0, FechaEmision,
FechaInicioDepreciacion
FROM AuxiliarActivoFijo
WHERE IDMov = @IDMov AND Articulo = @Articulo AND Serie = @SerieLote AND Renglon = @Renglon
END
FETCH NEXT FROM crArtSL INTO @Articulo, @SerieLote
END
CLOSE crArtSL
DEALLOCATE crArtSL
FETCH NEXT FROM crArtAF INTO @Articulo, @Renglon
END
CLOSE crArtAF
DEALLOCATE crArtAF
SELECT @Gastodiverso = SUM(((Importe + Impuestos)-(Retencion + Retencion2 + Retencion3))*TipoCambio)
FROM Compragastodiverso
WHERE ID = @IdMov
SELECT @TotalCA = SUM(ImporteMov)
FROM AuxiliarActivoFijo
WHERE IDMov = @IdMov AND Modulo = @Modulo AND Empresa = @Empresa
DECLARE crAuxArtAF CURSOR FOR
SELECT IDMov, Renglon, Articulo, Serie, ImporteMov FROM AuxiliarActivoFijo WHERE IDMov = @IdMov
AND Modulo = @Modulo
OPEN crAuxArtAF
FETCH NEXT FROM crAuxArtAF INTO @IDMov, @Renglon, @Articulo, @Serie, @ImporteMov
WHILE @@FETCH_STATUS = 0
BEGIN
IF @ImporteMov <> 0 AND @TotalCA <> 0
BEGIN
SET @Factor  = @ImporteMov / @TotalCA
SET @TotalGD = @Factor * @Gastodiverso
SET @Factor = ROUND(@Factor,2)
END
ELSE
IF @ImporteMov = 0 AND @TotalCA = 0
BEGIN
SET @Factor  = 0
SET @TotalGD = 0
END
IF @ClaveMov IN ('COMS.D','COMS.B')
SET @Total = @ImporteMov - @TotalGD
ELSE
SET @Total = @ImporteMov + @TotalGD
UPDATE AuxiliarActivoFijo
SET FactorCalculo = @Factor, Total = @Total, ImporteMov = @TotalGD, ValorAdquisicion = @ImporteMov
WHERE Articulo = @Articulo AND Serie = @Serie AND IDMov = @IDMov AND Renglon = @Renglon AND Empresa = @Empresa
FETCH NEXT FROM crAuxArtAF INTO @IDMov, @Renglon, @Articulo, @Serie, @ImporteMov
END
CLOSE crAuxArtAF
DEALLOCATE crAuxArtAF
END
IF NOT EXISTS (SELECT * FROM AuxiliarActivoFijo WHERE IDMov = @IDMov AND Modulo = @Modulo) AND ((@ExisteArt = 0 AND @ExisteSer = 0 AND @Bandera = 1) OR (@ExisteArt = 1 AND @ExisteSer = 1 AND @Bandera = 0))
BEGIN
SELECT 'La Fecha de Inicio de la depreciación del Artículo AF dede ser mayor o igual a la fecha emisión del movimiento'
END
ELSE
BEGIN
SELECT 'Proceso concluido.'
END
DELETE ListaID WHERE Estacion = @Estacion
END
SET NOCOUNT OFF

