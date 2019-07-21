SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarAsisteJustificar
@Empresa		char(5),
@Personal		char(10),
@Fecha		datetime,
@Registro		char(10),
@FechaHoraD		datetime,
@FechaHoraA		datetime,
@Ausencia		int,
@Extra		int,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Concepto		varchar(50),
@TotalPermisos	int,
@Permiso		int
IF @Ausencia > 0
BEGIN
SELECT @TotalPermisos = 0
DECLARE crPermisos CURSOR FOR
SELECT PermisoConcepto, SUM(Ausencia)
FROM PersonalAsisteDifMin
WHERE Empresa = @Empresa AND Personal = @Personal AND Fecha = @Fecha AND Ausencia > 0 AND Permiso IS NOT NULL AND PermisoID IS NOT NULL
AND @FechaHoraD >= FechaHoraD
AND @FechaHoraA  <= FechaHoraA
GROUP BY PermisoConcepto, FechaHoraD
ORDER BY PermisoConcepto, FechaHoraD
OPEN crPermisos
FETCH NEXT FROM crPermisos INTO @Concepto, @Permiso
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL AND @Ausencia > @TotalPermisos
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @Permiso + @TotalPermisos > @Ausencia SELECT @Permiso = @Ausencia - @TotalPermisos
INSERT PersonalAsisteDif (Empresa,  Personal,  Fecha,  Registro,  Concepto,  Cantidad, Tipo)
VALUES (@Empresa, @Personal, @Fecha, @Registro, @Concepto, @Permiso, 'Minutos Ausencia')
SELECT @TotalPermisos = @TotalPermisos + @Permiso
END
FETCH NEXT FROM crPermisos INTO @Concepto, @Permiso
END  
CLOSE crPermisos
DEALLOCATE crPermisos
IF @Ausencia > @TotalPermisos
INSERT PersonalAsisteDif (Empresa,  Personal,  Fecha,  Registro,  Cantidad,                     Tipo)
VALUES (@Empresa, @Personal, @Fecha, @Registro, (@Ausencia - @TotalPermisos), 'Minutos Ausencia')
END
IF @Extra > 0
BEGIN
SELECT @TotalPermisos = 0
DECLARE crPermisos CURSOR FOR
SELECT PermisoConcepto, SUM(Extra)
FROM PersonalAsisteDifMin
WHERE Empresa = @Empresa AND Personal = @Personal AND Fecha = @Fecha AND Extra > 0 AND Permiso IS NOT NULL AND PermisoID IS NOT NULL AND FechaHoraD >= @FechaHoraD AND @FechaHoraA BETWEEN FechaHoraD AND FechaHoraA
GROUP BY PermisoConcepto, FechaHoraD
ORDER BY PermisoConcepto, FechaHoraD
OPEN crPermisos
FETCH NEXT FROM crPermisos INTO @Concepto, @Permiso
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL AND @Extra > @TotalPermisos
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @Permiso + @TotalPermisos > @Extra SELECT @Permiso = @Extra - @TotalPermisos
INSERT PersonalAsisteDif (Empresa,  Personal,  Fecha,  Registro,  Concepto,  Cantidad, Tipo)
VALUES (@Empresa, @Personal, @Fecha, @Registro, @Concepto, @Permiso, 'Minutos Extras')
SELECT @TotalPermisos = @TotalPermisos + @Permiso
END
FETCH NEXT FROM crPermisos INTO @Concepto, @Permiso
END  
CLOSE crPermisos
DEALLOCATE crPermisos
END
RETURN
END

