SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.NombreArchivoDIOT(
@Estacion		int
)
RETURNS varchar(50)
BEGIN
DECLARE
@Nombre				varchar(50),
@RFC				varchar(13),
@TipoPeriodo		varchar(2),
@Periodo			varchar(2),
@TipoDeclaracion	varchar(1),
@MesInicio			varchar(2),
@MesFin				varchar(2),
@Anio				varchar(4),
@Contador			int,
@Empresa			varchar(5)
SELECT @RFC = B.RFC, @Empresa = B.Empresa
FROM DiotD A WITH(NOLOCK)
JOIN Empresa B WITH(NOLOCK) ON A.Empresa = B.Empresa
WHERE A.EstacionTrabajo = @Estacion
SELECT @Anio = Ejercicio, @TipoPeriodo = TipoPeriodo, @Periodo = Periodo, @TipoDeclaracion = CASE WHEN TipoDec = 0 THEN 'N' ELSE 'C' END
FROM DIOTParamXML WITH(NOLOCK)
WHERE Estacion = @Estacion
SELECT @MesInicio = SUBSTRING(FechaInicio,4,2), @MesFin = SUBSTRING(FechaFin,4,2)
FROM DIOTCatPeriodo WITH(NOLOCK)
WHERE ClavePeriodicidad = @TipoPeriodo
AND ClavePeriodo = @Periodo
SELECT @Contador = COUNT(*)+1
FROM DIOTHistArchivos WITH(NOLOCK)
WHERE Empresa = @Empresa
AND Ejercicio = @Anio
AND TipoPeriodo = @TipoPeriodo
AND Periodo = @Periodo
AND TipoDeclaracion = @TipoDeclaracion
SELECT @Nombre = @RFC+@TipoPeriodo+@Periodo+@TipoDeclaracion+@MesInicio+@MesFin+SUBSTRING(@Anio,3,2)+
CASE WHEN @Contador < 9 THEN '0'+CAST(@Contador AS VARCHAR(2)) ELSE CAST(@Contador AS VARCHAR(2)) END
RETURN @Nombre
END

