SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPCPValidarReglaVigencia
(
@ReglaID						int,
@Fecha							datetime
)
RETURNS bit

AS BEGIN
DECLARE
@Resultado					bit,
@FechaD						datetime,
@FechaA						datetime,
@MascaraFecha				varchar(10),
@ConRegistros				bit,
@Salir						bit,
@FechaTexto					varchar(10),
@Dia						varchar(2),
@Mes						varchar(2),
@Anio						varchar(4)
SELECT @Resultado = 0, @ConRegistros = 0, @Salir = 0
SET @Dia  = CONVERT(varchar,DATEPART(dd,@Fecha))
SET @Mes  = CONVERT(varchar,DATEPART(mm,@Fecha))
SET @Anio = CONVERT(varchar,DATEPART(yyyy,@Fecha))
SELECT @FechaTexto = REPLICATE('0',2-LEN(@Dia)) + @Dia + '/' + REPLICATE('0',2-LEN(@Mes)) + @Mes + '/' + @Anio
DECLARE crVigencia CURSOR FOR
SELECT FechaD, FechaA, MascaraFecha
FROM ProyClavePresupuestalReglaVig
WHERE ID = @ReglaID
OPEN crVigencia
FETCH NEXT FROM crVigencia INTO @FechaD, @FechaA, @MascaraFecha
WHILE @@FETCH_STATUS = 0 AND @Salir = 0
BEGIN
SET @ConRegistros = 1
IF @FechaD IS NOT NULL AND @FechaA IS NOT NULL
BEGIN
IF @Fecha BETWEEN @FechaD AND @FechaA SELECT @Resultado = 1, @Salir = 1
END
IF @MascaraFecha IS NOT NULL
BEGIN
IF dbo.fnPCPValidarMascaraFecha(@FechaTexto,@MascaraFecha) = 1 SELECT @Resultado = 1, @Salir = 1
END
FETCH NEXT FROM crVigencia INTO @FechaD, @FechaA, @MascaraFecha
END
CLOSE crVigencia
DEALLOCATE crVigencia
IF @ConRegistros = 0 SET @Resultado = 1
RETURN (@Resultado)
END

