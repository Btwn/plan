SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSFechaCierre2 (
@Empresa        varchar(5),
@Sucursal       int,
@Fecha          varchar(25),
@Caja           varchar(10)
)
RETURNS datetime

AS
BEGIN
DECLARE
@Resultado            datetime,
@FechaActual          datetime,
@HoraCierreDia        varchar(10),
@DiasHabiles          varchar(20),
@Hora                 int,
@Minutos              int,
@HoraMinutos          int,
@Dia                  int,
@SumarDias            int
SELECT @FechaActual = GETDATE()
SELECT @Hora = DATEPART(HOUR,@FechaActual)
SELECT @Minutos= DATEPART(MINUTE,@FechaActual)
SELECT @HoraMinutos = (@Hora*60)+@Minutos
SELECT @SumarDias =1
SELECT @HoraCierreDia = HoraCierreDia, @DiasHabiles = DiasHabiles
FROM POSCfg
WHERE Empresa = @Empresa
IF @Fecha IS NULL
SELECT @Resultado = ISNULL(dbo.fnPOSFechaCierre(@Empresa,@Sucursal,@Fecha,@Caja),@FechaActual)
IF @HoraMinutos >=  dbo.fnHoraEnEntero(@HoraCierreDia) 
BEGIN
SELECT @Resultado = Fecha
FROM POSEstatusCajasCierre
WHERE Sucursal = @Sucursal AND Caja = @Caja
SELECT @Resultado = ISNULL(@Resultado,@FechaActual)
SELECT @Dia = DATEPART(weekday,ISNULL(@Resultado,@FechaActual))
IF @DiasHabiles = 'Lun-Vie'
BEGIN
IF @Dia = 6
SELECT @SumarDias = 3
IF @Dia = 7
SELECT @SumarDias = 2
END
ELSE
IF @DiasHabiles = 'Lun-Sab'
BEGIN
IF @Dia = 7
SELECT @SumarDias = 2
END
SELECT @Resultado = DATEADD(day,@SumarDias,@FechaActual)
END
IF @Resultado IS NULL
SELECT @Resultado = @FechaActual
IF EXISTS(SELECT * FROM POSFechaCierre WHERE Sucursal = @Sucursal AND Fecha > dbo.fnFechaSinHora(@Resultado))
SELECT @Resultado = Fecha
FROM POSFechaCierre
WHERE Sucursal = @Sucursal
SELECT @Resultado = dbo.fnFechaSinHora(@Resultado)
RETURN (@Resultado)
END

