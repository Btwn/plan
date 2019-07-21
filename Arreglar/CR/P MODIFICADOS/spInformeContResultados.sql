SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInformeContResultados
@EstacionTrabajo		int

AS BEGIN
DECLARE
@Empresa			varchar	(5),
@Clase				varchar	(30),
@ClaseAnt			varchar	(30),
@Contador			int,
@Orden				int,
@SaldoAl			float,
@Saldo				float,
@ID					int,
@EmpresaNombre		varchar	(100),
@Titulo				varchar	(100),
@Reporte			varchar	(100),
@Direccion2			varchar	(100),
@Direccion3			varchar	(100),
@Direccion4			varchar	(100),
@Ejercicio			int,
@PeriodoD			int,
@PeriodoA			int,
@ConMovs			varchar	(50),
@Desglosar			varchar	(50),
@ContMoneda			varchar	(50),
@CentroCostos		varchar	(50),
@CentroCostos2		varchar	(50),
@CentroCostos3		varchar	(50),
@AlCentroCostos		varchar	(50),
@AlCentroCostos2	varchar	(50),
@AlCentroCostos3	varchar	(50),
@Proyecto			varchar	(50),
@UEN				varchar	(50),
@Sucursal			int,
@Agrupador			varchar	(50),
@Grupo				varchar	(50),
@Etiqueta			bit,
@Verdadero			bit,
@Falso				bit,
@VerGraficaDetalle		bit
SELECT @Verdadero = 1, @Falso = 0
SELECT
@Empresa			=	InfoEmpresa,
@Ejercicio			=	InfoEjercicio,
@PeriodoD			=	InfoPeriodoD,
@PeriodoA			=	InfoPeriodoA,
@ConMovs			=	InfoConMovs,
@Desglosar			=	InfoDesglosar,
@ContMoneda			=	InfoContMoneda,
@CentroCostos		=	InfoCentroCostos,
@CentroCostos2		=	InfoCentroCostos2,
@CentroCostos3		=	InfoCentroCostos3,
@AlCentroCostos		=	InfoAlCentroCostos,
@AlCentroCostos2	=	InfoAlCentroCostos2,
@AlCentroCostos3	=	InfoAlCentroCostos3,
@Proyecto			=	InfoProyecto,
@UEN				=	InfoUEN,
@Sucursal			=	InfoSucursal,
@Agrupador			=	InfoAgrupadoCC,
@Grupo				=	InfoGrupoLista,
@Titulo				=	InfoTituloContRes,
@Etiqueta			= ISNULL(InfoEtiqueta, @Falso),
@VerGraficaDetalle = ISNULL(VerGraficaDetalle,0)
FROM RepParam
WITH(NOLOCK) WHERE Estacion = @EstacionTrabajo
SELECT @EmpresaNombre = Nombre FROM Empresa WITH(NOLOCK) WHERE Empresa = @Empresa
EXEC spContactoDireccionHorizontal @EstacionTrabajo, 'Empresa', @Empresa, @Empresa, 1, 1, 1, 1
SELECT @Direccion2 = Direccion2,
@Direccion3 = Direccion3,
@Direccion4 = Direccion4
FROM ContactoDireccionHorizontal
WITH(NOLOCK) WHERE Estacion = @EstacionTrabajo
SELECT @Reporte = 'Ejercicio ' + CONVERT(varchar,@Ejercicio) + ' de ' + dbo.fnMesNumeroNombre(@PeriodoD) + ' a ' + dbo.fnMesNumeroNombre(@PeriodoA) + ' En Moneda ' + ISNULL(@ContMoneda,'')
DECLARE @VerContResultados TABLE
(
Orden				int		NOT NULL,
ID					int			NULL,
Clase				varchar(30)	COLLATE Database_Default NULL,
SubClase			varchar(20)	COLLATE Database_Default NULL,
Rama				varchar(20)	COLLATE Database_Default NULL,
RamaDesc			varchar(100)COLLATE Database_Default NULL,
RamaEsAcreedora	bit		NOT NULL DEFAULT 0,
Cuenta				varchar(20)	COLLATE Database_Default NULL,
Descripcion		varchar(100)COLLATE Database_Default NULL,
EsAcreedora		bit		NOT NULL DEFAULT 0,
SubCuenta			varchar(20)	COLLATE Database_Default NULL,
CentroCostos		varchar(100)COLLATE Database_Default NULL,
Saldo				money		NULL,
Ingresos			money		NULL,
Porcentaje			float		NULL,
SaldoAl			money		NULL,
IngresosAl			money		NULL,
PorcentajeAl		float		NULL,
Grupo				varchar(50)	NULL,
SubGrupo			varchar(50)	NULL,
SubSubGrupo		varchar(50)	NULL
)
DECLARE @ContResultados TABLE
(
Orden				int		NOT NULL,
ID					int			NULL,
Clase				varchar(30)	COLLATE Database_Default NULL,
SubClase			varchar(20)	COLLATE Database_Default NULL,
Rama				varchar(20)	COLLATE Database_Default NULL,
RamaDesc			varchar(100)COLLATE Database_Default NULL,
RamaEsAcreedora	bit		NOT NULL DEFAULT 0,
Cuenta				varchar(20)	COLLATE Database_Default NULL,
Descripcion		varchar(100)COLLATE Database_Default NULL,
EsAcreedora		bit		NOT NULL DEFAULT 0,
SubCuenta			varchar(20)	COLLATE Database_Default NULL,
CentroCostos		varchar(100)COLLATE Database_Default NULL,
Saldo				money		NULL,
Ingresos			money		NULL,
Porcentaje			float		NULL,
SaldoAl			money		NULL,
IngresosAl			money		NULL,
PorcentajeAl		float		NULL,
Grupo				varchar(50)	NULL,
SubGrupo			varchar(50)	NULL,
SubSubGrupo		varchar(50)	NULL,
Desglosar			varchar(5)	NULL,
Orden1				int			NULL,
GraficaArgumento	varchar(100) COLLATE DATABASE_DEFAULT NULL,
GraficaValor		float		NULL,
Grafica1			int			NULL DEFAULT 0,
Grafica2			int			NULL DEFAULT 0,
Titulo				varchar(100)NULL,
Reporte			varchar(100)NULL,
Direccion2			varchar(100)NULL,
Direccion3			varchar(100)NULL,
Direccion4			varchar(100)NULL,
GraficaSerie		varchar(100) COLLATE DATABASE_DEFAULT NULL,
EmpresaNombre		varchar(100) COLLATE DATABASE_DEFAULT NULL,
PeriodoA			varchar(100) COLLATE DATABASE_DEFAULT NULL
)
DECLARE @Totales TABLE
(
Orden				int		    NULL,
ID					int			NULL,
Clase				varchar(30)	COLLATE Database_Default NULL,
SubClase			varchar(20)	COLLATE Database_Default NULL,
Rama				varchar(20)	COLLATE Database_Default NULL,
RamaDesc			varchar(100)COLLATE Database_Default NULL,
RamaEsAcreedora	bit		NOT NULL DEFAULT 0,
Cuenta				varchar(20)	COLLATE Database_Default NULL,
Descripcion		varchar(100)COLLATE Database_Default NULL,
EsAcreedora		bit		NOT NULL DEFAULT 0,
SubCuenta			varchar(20)	COLLATE Database_Default NULL,
CentroCostos		varchar(100)COLLATE Database_Default NULL,
Saldo				money		NULL,
Ingresos			money		NULL,
Porcentaje			float		NULL,
SaldoAl			money		NULL,
IngresosAl			money		NULL,
PorcentajeAl		float		NULL,
Grupo				varchar(50)	NULL,
SubGrupo			varchar(50)	NULL,
SubSubGrupo		varchar(50)	NULL,
Desglosar			varchar(5)	NULL,
Orden1				int			NULL
)
INSERT INTO @VerContResultados
EXEC spVerContResultados @Empresa, @Ejercicio, @PeriodoD, @PeriodoA, @ConMovs, @CentroCostos, @Sucursal, @Agrupador, @ContMoneda, @Grupo, 'NULL'
INSERT INTO @ContResultados
SELECT *, @Desglosar, NULL, NULL, NULL, 0, 0, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, NULL, @EmpresaNombre, dbo.fnMesNumeroNombre(@PeriodoA) FROM @VerContResultados
SELECT @Contador = 0
DECLARE crOrden CURSOR FAST_FORWARD FOR
SELECT DISTINCT Clase, Orden
FROM @VerContResultados
ORDER BY Orden, Clase
OPEN crOrden
FETCH NEXT FROM crOrden  INTO @Clase, @Orden
WHILE @@FETCH_STATUS = 0
BEGIN
IF EXISTS(SELECT * FROM @ContResultados WHERE Clase = @Clase AND Orden1 IS NULL)
BEGIN
SELECT @Contador = @Contador + 1
UPDATE @ContResultados SET Orden1 = @Contador WHERE Clase = @Clase
END
FETCH NEXT FROM crOrden  INTO @Clase, @Orden
END
CLOSE crOrden
DEALLOCATE crOrden
SELECT @SaldoAl = 0.00, @Saldo = 0.00, @ClaseAnt = ''
DECLARE crOrden CURSOR FAST_FORWARD FOR
SELECT ID, Clase
FROM @ContResultados
GROUP BY ID, Clase, Orden
ORDER BY ID
OPEN crOrden
FETCH NEXT FROM crOrden  INTO @ID, @Clase
WHILE @@FETCH_STATUS = 0
BEGIN
IF @ClaseAnt = '' SELECT @ClaseAnt = @Clase
IF @ClaseAnt <> @Clase
BEGIN
INSERT INTO @ContResultados(GraficaArgumento, GraficaValor, Grafica1, Grafica2, Orden, GraficaSerie, Titulo, Reporte, Direccion2, Direccion3, Direccion4, EmpresaNombre, Desglosar, PeriodoA)
SELECT @ClaseAnt, @SaldoAl, 1, 0, 999999999, dbo.fnMesNumeroNombre(@PeriodoA), @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @EmpresaNombre, @Desglosar, dbo.fnMesNumeroNombre(@PeriodoA)
INSERT INTO @ContResultados(GraficaArgumento, GraficaValor, Grafica1, Grafica2, Orden, GraficaSerie, Titulo, Reporte, Direccion2, Direccion3, Direccion4, EmpresaNombre, Desglosar, PeriodoA)
SELECT @ClaseAnt, @Saldo, 1, 1, 999999999, 'Acumulado', @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @EmpresaNombre, @Desglosar, dbo.fnMesNumeroNombre(@PeriodoA)
END
SELECT @SaldoAl = @SaldoAl -ISNULL(SaldoAl,0.00), @Saldo = @Saldo -ISNULL(Saldo,0.00)
FROM @ContResultados
WHERE ID = @ID
SELECT @ClaseAnt = @Clase
FETCH NEXT FROM crOrden  INTO @ID, @Clase
END
INSERT INTO @ContResultados(GraficaArgumento, GraficaValor, Grafica1, Grafica2, Orden, GraficaSerie, Titulo, Reporte, Direccion2, Direccion3, Direccion4, EmpresaNombre, Desglosar, PeriodoA)
SELECT @ClaseAnt, @SaldoAl, 1, 0, 999999999, dbo.fnMesNumeroNombre(@PeriodoA), @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @EmpresaNombre, @Desglosar, dbo.fnMesNumeroNombre(@PeriodoA)
INSERT INTO @ContResultados(GraficaArgumento, GraficaValor, Grafica1, Grafica2, Orden, GraficaSerie, Titulo, Reporte, Direccion2, Direccion3, Direccion4, EmpresaNombre, Desglosar, PeriodoA)
SELECT @ClaseAnt, @Saldo, 1, 1, 999999999, 'Acumulado', @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @EmpresaNombre, @Desglosar, dbo.fnMesNumeroNombre(@PeriodoA)
CLOSE crOrden
DEALLOCATE crOrden
UPDATE @ContResultados
SET Saldo = 0.00
WHERE Saldo IS NULL
UPDATE @ContResultados
SET Ingresos = 0.00
WHERE Ingresos IS NULL
UPDATE @ContResultados
SET Porcentaje = 0.00
WHERE Porcentaje IS NULL
UPDATE @ContResultados
SET SaldoAl = 0.00
WHERE SaldoAl IS NULL
UPDATE @ContResultados
SET IngresosAl = 0.00
WHERE IngresosAl IS NULL
UPDATE @ContResultados
SET PorcentajeAl = 0.00
WHERE PorcentajeAl IS NULL
SELECT *, @Etiqueta as Etiqueta, @VerGraficaDetalle as VerGraficaDetalle FROM @ContResultados
END

