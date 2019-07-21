SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInformeContBalanza
@EstacionTrabajo		int

AS BEGIN
DECLARE
@Empresa		varchar	(5),
@Ejercicio		int,
@PeriodoD		int,
@PeriodoA		int,
@ConMovs		varchar	(20),
@Tipo			varchar	(20),
@CuentaD		varchar	(20),
@CuentaA		varchar	(20),
@CentroCostos	varchar	(20),
@Cuenta		varchar	(50),
@Grupo			varchar	(50),
@Familia		varchar	(50),
@Sucursal		int,
@Moneda			varchar	(10),
@Controladora	varchar	(5),
@UEN			int,
@Proyecto		varchar	(50),
@CentroCostos2	varchar	(50),
@CentroCostos3	varchar	(50),
@EmpresaNombre	varchar	(100),
@Titulo			varchar	(100),
@Reporte		varchar	(100),
@Direccion2		varchar	(100),
@Direccion3		varchar	(100),
@Direccion4		varchar	(100),
@Graficar				int,
@GraficarFecha			int,
@GraficarTipo			varchar(30),
@Etiqueta				bit,
@GraficarCantidad		int,
@Verdadero				bit,
@Falso					bit,
@Inicio					float,
@Cargos					float,
@Abonos					float,
@Final					float,
@VerGraficaDetalle		bit
SELECT @Verdadero = 1, @Falso = 0
SELECT
@Empresa		=	InfoEmpresa,
@Ejercicio		=	InfoEjercicio,
@PeriodoD		=	InfoPeriodoD,
@PeriodoA		=	InfoPeriodoA,
@ConMovs		=	InfoConMovs,
@Tipo			=	InfoCtaNivel,
@CuentaD		=	InfoCtaD,
@CuentaA		=	InfoCtaA,
@CentroCostos	=	InfoCentroCostos,
@Cuenta			=	InfoCtaCat,
@Grupo			=	InfoCtaGrupo,
@Familia		=	InfoCtaFam,
@Sucursal		=	InfoSucursal,
@Moneda			=	InfoMoneda,
@Controladora	=	NULL,
@UEN			=	InfoUEN,
@Proyecto		=	InfoProyecto,
@CentroCostos2	=	InfoCentroCostos2,
@CentroCostos3	=	InfoCentroCostos3,
@Titulo			=	RepTitulo,
@GraficarTipo	=	ISNULL(InformeGraficarTipo,  '(Todos)'),
@Etiqueta		=	ISNULL(InfoEtiqueta, @Falso),
@GraficarCantidad = ISNULL(InformeGraficarCantidad, 5),
@VerGraficaDetalle = ISNULL(VerGraficaDetalle,0)
FROM RepParam
WHERE Estacion = @EstacionTrabajo
SELECT @EmpresaNombre = Nombre FROM Empresa WHERE Empresa = @Empresa
SELECT @Reporte = 'Ejercicio ' + CONVERT(varchar,@Ejercicio) + ' de ' + dbo.fnMesNumeroNombre(@PeriodoD) + ' a ' + dbo.fnMesNumeroNombre(@PeriodoA) + ' En Moneda ' + @Moneda
EXEC spContactoDireccionHorizontal @EstacionTrabajo, 'Empresa', @Empresa, @Empresa, 1, 1, 1, 1
SELECT @Direccion2 = Direccion2,
@Direccion3 = Direccion3,
@Direccion4 = Direccion4
FROM ContactoDireccionHorizontal
WHERE Estacion = @EstacionTrabajo
DECLARE @Datos TABLE
(
Estacion					int,
Empresa					varchar(5) COLLATE DATABASE_DEFAULT NULL,
EmpresaNombre			varchar(100) COLLATE DATABASE_DEFAULT NULL,
Cuenta					varchar(20) COLLATE DATABASE_DEFAULT NULL,
CuentaNombre				varchar(100) COLLATE DATABASE_DEFAULT NULL,
Tipo						varchar(20) COLLATE DATABASE_DEFAULT NULL,
Inicio					float NULL,
Cargos					float NULL,
Abonos					float NULL,
Periodo					int NULL,
Final					float NULL,
GraficaArgumento			varchar(100) COLLATE DATABASE_DEFAULT NULL,
GraficaValor				float NULL,
Grafica					int NULL DEFAULT 0,
Titulo					varchar(100) NULL,
Reporte					varchar(100) NULL,
Direccion2				varchar(100) NULL,
Direccion3				varchar(100) NULL,
Direccion4				varchar(100) NULL,
Total					bit DEFAULT 0 NULL
)
DECLARE @DatosTotal TABLE
(
Inicio					float NULL,
Cargos					float NULL,
Abonos					float NULL
)
DECLARE @ContBalanza TABLE
(
Cuenta				varchar(20) COLLATE DATABASE_DEFAULT NULL,
Descripcion			varchar(100) COLLATE DATABASE_DEFAULT NULL,
Tipo					varchar(20) COLLATE DATABASE_DEFAULT NULL,
EsAcumulativa		bit,
EsAcreedora			bit,
Inicio				float NULL,
Cargos				float NULL,
Abonos				float NULL
)
DECLARE @ContBalanzaMayorPorMes TABLE
(
Cuenta				varchar(20) COLLATE DATABASE_DEFAULT NULL,
Descripcion			varchar(100) COLLATE DATABASE_DEFAULT NULL,
Tipo					varchar(20) COLLATE DATABASE_DEFAULT NULL,
EsAcumulativa		bit,
EsAcreedora			bit,
Inicio				float NULL,
Cargos				float NULL,
Abonos				float NULL,
Periodo				int NULL,
Final				float NULL
)
INSERT INTO @ContBalanza
EXEC spVerContBalanza @Empresa, @Ejercicio, @PeriodoD, @PeriodoA, @ConMovs, @Tipo, @CuentaD, @CuentaA, @CentroCostos, @Cuenta, @Grupo, @Familia, @Sucursal, @Moneda, @Controladora, @UEN, @Proyecto, @CentroCostos2, @CentroCostos3
INSERT INTO @ContBalanzaMayorPorMes
EXEC spVerContBalanzaMayorPorMes @Empresa, @Ejercicio, @PeriodoD, @PeriodoA, @ConMovs, @CuentaD, @CuentaA, @CentroCostos, @Cuenta, @Grupo, @Familia, @Sucursal, @Moneda, @Controladora, @UEN, @Proyecto, @CentroCostos2, @CentroCostos3
INSERT INTO @Datos(Estacion,  Empresa, EmpresaNombre,  Cuenta, CuentaNombre, Tipo, Inicio, Cargos, Abonos, Final,															  Titulo,  Reporte,  Direccion2,  Direccion3,  Direccion4)
SELECT	 @EstacionTrabajo, @Empresa, @EmpresaNombre, Cuenta, Descripcion,  Tipo, Inicio, Cargos, Abonos, ISNULL(Inicio,0.00) + ISNULL(Cargos,0.00) - ISNULL(Abonos,0.00), @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4
FROM @ContBalanza
INSERT INTO @Datos(Estacion,  Empresa, EmpresaNombre,  Cuenta, CuentaNombre,				   Tipo, Periodo, GraficaArgumento,                                   GraficaValor,																													Grafica, Titulo, Reporte,  Direccion2,  Direccion3,  Direccion4)
SELECT   @EstacionTrabajo, @Empresa, @EmpresaNombre, Cuenta, SUBSTRING(Descripcion,1,25),  Tipo, Periodo, ISNULL(dbo.fnMesNumeroNombre(Periodo), 'Inicial') , CASE WHEN ISNULL(dbo.fnMesNumeroNombre(Periodo), 'Inicial') = 'Inicial' THEN ISNULL(Inicio,0.00) ELSE ISNULL(Final,0.00) END, 1,		@Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4
FROM @ContBalanzaMayorPorMes
INSERT INTO @Datos(Estacion,        Empresa,  EmpresaNombre,   Cuenta, CuentaNombre,				   Tipo, Periodo, GraficaArgumento, GraficaValor,	  Grafica, Titulo,  Reporte,  Direccion2,  Direccion3,  Direccion4)
SELECT DISTINCT @EstacionTrabajo, @Empresa, @EmpresaNombre,  Cuenta, SUBSTRING(CuentaNombre,1,25), Tipo, 0,		  'Inicial',        ISNULL(Inicio,0), 1,	   @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4
FROM @Datos
WHERE Periodo IN (NULL)
AND Cuenta IN (
SELECT DISTINCT Cuenta
FROM @Datos
WHERE Periodo NOT IN (0, NULL))
DELETE @Datos WHERE Cuenta IN(SELECT Cuenta FROM @Datos WHERE Grafica = 1  GROUP BY Cuenta HAVING COUNT(Periodo) = 1) AND Grafica = 1
SELECT @Graficar = NULL
SELECT @Graficar = ISNULL(COUNT(DISTINCT Cuenta),0)
FROM @Datos
WHERE Estacion = @EstacionTrabajo
AND Grafica = 1
IF @GraficarTipo = 'Mas Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @Datos
WHERE Cuenta NOT IN(
SELECT  TOP (@GraficarCantidad) Cuenta
FROM
(
SELECT
'Cuenta'         = Cuenta,
'GraficaValor'   = SUM(ISNULL(GraficaValor,0.00))
FROM @Datos
WHERE Estacion = @EstacionTrabajo
AND Grafica = 1
GROUP BY Cuenta
) AS x
GROUP BY x.Cuenta
ORDER BY SUM(ISNULL(x.GraficaValor,0.00))DESC)
AND Estacion = @EstacionTrabajo
AND Grafica = 1
IF @GraficarTipo = 'Menos Sobresalientes' AND @Graficar > @GraficarCantidad
DELETE @Datos
WHERE Cuenta NOT IN(
SELECT  TOP (@GraficarCantidad) Cuenta
FROM
(
SELECT
'Cuenta'         = Cuenta,
'GraficaValor'   = SUM(ISNULL(GraficaValor,0.00))
FROM @Datos
WHERE Estacion = @EstacionTrabajo
AND Grafica = 1
GROUP BY Cuenta
) AS x
GROUP BY x.Cuenta
ORDER BY SUM(ISNULL(x.GraficaValor,0.00))ASC)
AND Estacion = @EstacionTrabajo
AND Grafica = 1
INSERT INTO @DatosTotal (Inicio, Cargos, Abonos)
Exec spVerContBalanzaTotal  @Empresa, @Ejercicio, @PeriodoD, @PeriodoA, @CuentaD, @CuentaA, @CentroCostos, @Cuenta, @Grupo, @Familia, @Sucursal, @Moneda, @Controladora, @UEN, @Proyecto, @CentroCostos2, @CentroCostos3
/**
SELECT @Inicio = SUM(ISNULL(Inicio,0.00)), @Cargos = SUM(ISNULL(Cargos,0.00)), @Abonos =SUM(ISNULL(Abonos,0.00))
FROM @Datos
WHERE Grafica = 0
AND Tipo = @Tipo
**/
SELECT @Inicio = ISNULL(Inicio,0.00), @Cargos = ISNULL(Cargos,0.00), @Abonos =ISNULL(Abonos,0.00)
FROM @DatosTotal
SELECT @Final = @Inicio + @Cargos - @Abonos
INSERT INTO @Datos(   Estacion,  Empresa, EmpresaNombre,    Inicio,  Cargos,  Abonos,       Final, Titulo,  Reporte,  Direccion2,  Direccion3,  Direccion4,  Total)
SELECT TOP 1  @EstacionTrabajo, @Empresa, @EmpresaNombre,  @Inicio, @Cargos, @Abonos,      @Final, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4,      1
FROM @ContBalanza
DELETE @Datos WHERE Cuenta IS NULL AND Total=0
SELECT *, @Etiqueta as Etiqueta, @VerGraficaDetalle as VerGraficaDetalle FROM @Datos ORDER BY Grafica, Total, Cuenta, Periodo
END

