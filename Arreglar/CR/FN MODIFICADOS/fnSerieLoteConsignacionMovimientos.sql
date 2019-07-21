SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSerieLoteConsignacionMovimientos
(
@Estacion				int,
@GenerarModulo			varchar(5),
@GenerarID				int,
@Empresa				varchar(5),
@OModulo				varchar(5),
@OModuloID				int,
@Articulo				varchar(20),
@SubCuenta				varchar(50),
@SerieLote				varchar(50),
@FechaCorte				datetime
)
RETURNS float

AS BEGIN
DECLARE
@Resultado	float
SELECT
@Resultado =ISNULL(SUM(ISNULL(AbonoU,0.0)-ISNULL(CargoU,0.0)),0.0)
FROM SerieLoteConsignacionAuxTemp slca WITH(NOLOCK)
WHERE NULLIF(CorteID,0) IS NULL
AND slca.Fecha <= @FechaCorte
AND slca.SerieLote = @SerieLote
AND ISNULL(slca.SubCuenta,'') = ISNULL(@SubCuenta,'')
AND slca.Articulo = @Articulo
AND slca.OModuloID = @OModuloID
AND slca.OModulo = @OModulo
AND slca.Empresa = @Empresa
AND slca.Estacion = @Estacion
AND slca.Modulo = @GenerarModulo
AND slca.ModuloID = @GenerarID
AND (slca.OModuloID <> slca.MModuloID OR slca.OModulo <> slca.MModulo)
RETURN (@Resultado)
END

