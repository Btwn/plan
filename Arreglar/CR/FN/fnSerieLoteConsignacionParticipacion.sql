SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSerieLoteConsignacionParticipacion
(
@Empresa				varchar(5),
@OModuloID				int,
@Articulo				varchar(20),
@SubCuenta				varchar(50),
@SerieLote				varchar(50)
)
RETURNS float

AS BEGIN
DECLARE
@Resultado				float,
@ImporteTotal			float,
@DetalleImporteTotal	float
SELECT
@ImporteTotal = SUM(ImporteTotal)
FROM CompraTCalc
WHERE ID = @OModuloID
SELECT
@DetalleImporteTotal = SUM((ISNULL(slm.Cantidad,0.0)/ISNULL(cd.Cantidad,0.0))*ctc.ImporteTotal)
FROM SerieLoteMov slm JOIN CompraD cd
ON cd.RenglonID = slm.RenglonID AND cd.ID = slm.ID AND 'COMS' = slm.Modulo JOIN CompraTCalc ctc
ON ctc.RenglonSub = cd.RenglonSub AND ctc.Renglon = cd.Renglon AND ctc.ID = cd.ID
WHERE RTRIM(slm.SerieLote) = RTRIM(@SerieLote)
AND ISNULL(slm.SubCuenta,'') = ISNULL(@SubCuenta,'')
AND RTRIM(slm.Articulo) = RTRIM(@Articulo)
AND RTRIM(slm.ID) = RTRIM(@OModuloID)
AND RTRIM(slm.Modulo) = 'COMS'
AND RTRIM(slm.Empresa) = RTRIM(@Empresa)
SET @Resultado = ISNULL(@DetalleImporteTotal,0.0) / ISNULL(@ImporteTotal,0.0)
RETURN (@Resultado)
END

