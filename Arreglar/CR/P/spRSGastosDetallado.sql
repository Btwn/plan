SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRSGastosDetallado
@Empresa		varchar(10),
@Sucursal	    int,
@Ejercicio     int,
@Clase         varchar(max),
@SubClase      varchar(100)

AS BEGIN
DECLARE @EstacionTrabajo int
CREATE TABLE #DatosClase(Descripcion varchar(100) COLLATE Database_Default )
SELECT  @Empresa     = CASE WHEN @Empresa IN( '(Todas)', '') THEN NULL ELSE @Empresa END,
@Clase       = CASE WHEN @Clase IN( '(Todas)', '') THEN NULL ELSE @Clase END,
@SubClase    = CASE WHEN @SubClase IN( '(Todas)', '') THEN NULL ELSE @SubClase END
IF @Clase IS NULL
BEGIN
INSERT #DatosClase
SELECT Descripcion
FROM Cta
WHERE Rama='R'
END
IF @Clase IS NOT NULL
INSERT INTO #DatosClase SELECT ValorTexto FROM dbo.fnParseaCadena(@Clase, ',')
SELECT
Acum.Empresa AS TEmpresa,
Acum.Sucursal AS TSucursal,
Acum.Ejercicio AS TEjercicio,
Acum.Periodo AS TPeriodo,
Acum.Rama,
C.Rama AS RamaPrincipal,
TMov = Ctx.Descripcion,
TClase = C.Descripcion,
TSubClase = Ct.Descripcion,
TConcepto = Ctx.Cuenta,
TCC = Acum.SubCuenta,
Gasto1 = Case  when Acum.Periodo = 1 then ISNULL(Acum.Cargos,0) - ISNULL(Acum.Abonos,0) end,
Gasto2 = Case when  Acum.Periodo = 2 then ISNULL(Acum.Cargos,0) - ISNULL(Acum.Abonos,0) end,
Gasto3 = Case  when  Acum.Periodo = 3 then ISNULL(Acum.Cargos,0) - ISNULL(Acum.Abonos,0) end,
Gasto4 = Case  when  Acum.Periodo = 4 then ISNULL(Acum.Cargos,0) - ISNULL(Acum.Abonos,0) end,
Gasto5 = Case  when  Acum.Periodo = 5 then ISNULL(Acum.Cargos,0) - ISNULL(Acum.Abonos,0) end,
Gasto6 = Case  when  Acum.Periodo = 6 then ISNULL(Acum.Cargos,0) - ISNULL(Acum.Abonos,0) end,
Gasto7 = Case  when  Acum.Periodo = 7 then ISNULL(Acum.Cargos,0) - ISNULL(Acum.Abonos,0) end,
Gasto8 = Case  when  Acum.Periodo = 8 then ISNULL(Acum.Cargos,0) - ISNULL(Acum.Abonos,0) end,
Gasto9 = Case  when  Acum.Periodo = 9 then ISNULL(Acum.Cargos,0) - ISNULL(Acum.Abonos,0) end,
Gasto10 = Case  when  Acum.Periodo = 10 then ISNULL(Acum.Cargos,0) - ISNULL(Acum.Abonos,0) end,
Gasto11 = Case  when  Acum.Periodo = 11 then ISNULL(Acum.Cargos,0) - ISNULL(Acum.Abonos,0) end,
Gasto12 = Case  when  Acum.Periodo = 12 then ISNULL(Acum.Cargos,0) - ISNULL(Acum.Abonos,0) end
FROM Cta
JOIN Cta C ON C.Rama = Cta.Cuenta
JOIN Cta Ct ON Ct.Rama = C.Cuenta
JOIN Cta Ctx ON Ctx.Rama = Ct.Cuenta
JOIN Acum ON Acum.Cuenta = Ctx.Cuenta
JOIN #DatosClase Dc ON Dc.Descripcion=C.Descripcion
WHERE Acum.Empresa=ISNULL(@Empresa, Acum.Empresa)
AND Acum.Sucursal=ISNULL(@Sucursal, Acum.Sucursal)
AND Acum.Ejercicio = @Ejercicio
AND Acum.Rama = 'CONT' AND Moneda='Pesos'
AND C.Rama  = 'R'
AND Ct.Descripcion = ISNULL(@SubClase, Ct.Descripcion)
END

