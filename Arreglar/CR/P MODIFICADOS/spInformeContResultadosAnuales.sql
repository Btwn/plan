SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInformeContResultadosAnuales
@EstacionTrabajo		int

AS BEGIN
DECLARE
@Empresa		char(5),
@Clase			varchar	(30),
@ClaseAnt		varchar	(30),
@Contador		int,
@Orden			int,
@Saldo			float,
@ID				int,
@Ejercicio1		int,
@Saldo1			float,
@Ejercicio2		int,
@Saldo2			float,
@Ejercicio3		int,
@Saldo3			float,
@Ejercicio4		int,
@Saldo4			float,
@Ejercicio5		int,
@Saldo5			float,
@EmpresaNombre	varchar	(100),
@Titulo			varchar	(100),
@Reporte		varchar	(100),
@Direccion2		varchar	(100),
@Direccion3		varchar	(100),
@Direccion4		varchar	(100),
@EjercicioD			int,
@EjercicioA			int,
@PeriodoA			int,
@ConMovs			varchar	(50),
@Desglosar			varchar	(50),
@ReporteInf			varchar	(50),
@ContMoneda			varchar	(50),
@CentroCostos		varchar	(50),
@CentroCostos2		varchar	(50),
@CentroCostos3		varchar	(50),
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
@EjercicioD			=	InfoEjercicioD,
@EjercicioA			=	InfoEjercicioA,
@PeriodoA			=	InfoPeriodoA,
@ConMovs			=	InfoConMovs,
@Desglosar			=	InfoDesglosar,
@ReporteInf			=	InfoContResAnual,
@ContMoneda			=	InfoContMoneda,
@CentroCostos		=	InfoCentroCostos,
@CentroCostos2		=	InfoCentroCostos2,
@CentroCostos3		=	InfoCentroCostos3,
@Proyecto			=	InfoProyecto,
@UEN				=	InfoUEN,
@Sucursal			=	InfoSucursal,
@Agrupador			=	InfoAgrupadoCC,
@Grupo				=	InfoGrupoLista,
@Titulo				=	InfoTituloContResAnual,
@Etiqueta			=	ISNULL(InfoEtiqueta, @Falso),
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
SELECT @Reporte = 'Del Ejercicio ' + CONVERT(varchar,@EjercicioD) + ' Al  ' + CONVERT(varchar,@EjercicioA) + ' En Moneda ' + ISNULL(@ContMoneda,'')
DECLARE @VerContResultadosAnuales TABLE
(
Orden				int			NULL,
ID					int			NULL,
Clase				char(30)	COLLATE Database_Default NULL,
SubClase			char(20)	COLLATE Database_Default NULL,
Rama				char(20)	COLLATE Database_Default NULL,
RamaDesc			varchar(100)COLLATE Database_Default NULL,
RamaEsAcreedora	bit		NOT NULL DEFAULT 0,
Cuenta				char(20)	COLLATE Database_Default NULL,
Descripcion		varchar(100)COLLATE Database_Default NULL,
EsAcreedora		bit		NOT NULL DEFAULT 0,
SubCuenta			varchar(50)	COLLATE Database_Default NULL,
CentroCostos		varchar(100)COLLATE Database_Default NULL,
Ejercicio1			int			NULL,
Saldo1				money		NULL,
Ingresos1			money		NULL,
Porcentaje1		float		NULL,
Ejercicio2			int			NULL,
Saldo2				money		NULL,
Ingresos2			money		NULL,
Porcentaje2		float		NULL,
Ejercicio3			int			NULL,
Saldo3				money		NULL,
Ingresos3			money		NULL,
Porcentaje3		float		NULL,
Ejercicio4			int			NULL,
Saldo4				money		NULL,
Ingresos4			money		NULL,
Porcentaje4		float		NULL,
Ejercicio5			int			NULL,
Saldo5				money		NULL,
Ingresos5			money		NULL,
Porcentaje5		float		NULL,
Grupo				varchar(50)	NULL,
SubGrupo			varchar(50)	NULL,
SubSubGrupo		varchar(50)	NULL
)
DECLARE @ContResultadosAnuales TABLE
(
Orden				int			NULL,
ID					int			NULL,
Clase				char(30)	COLLATE Database_Default NULL,
SubClase			char(20)	COLLATE Database_Default NULL,
Rama				char(20)	COLLATE Database_Default NULL,
RamaDesc			varchar(100)COLLATE Database_Default NULL,
RamaEsAcreedora	bit		NOT NULL DEFAULT 0,
Cuenta				char(20)	COLLATE Database_Default NULL,
Descripcion		varchar(100)COLLATE Database_Default NULL,
EsAcreedora		bit		NOT NULL DEFAULT 0,
SubCuenta			varchar(50)	COLLATE Database_Default NULL,
CentroCostos		varchar(100)COLLATE Database_Default NULL,
Ejercicio1			int			NULL,
Saldo1				money		NULL,
Ingresos1			money		NULL,
Porcentaje1		float		NULL,
Ejercicio2			int			NULL,
Saldo2				money		NULL,
Ingresos2			money		NULL,
Porcentaje2		float		NULL,
Ejercicio3			int			NULL,
Saldo3				money		NULL,
Ingresos3			money		NULL,
Porcentaje3		float		NULL,
Ejercicio4			int			NULL,
Saldo4				money		NULL,
Ingresos4			money		NULL,
Porcentaje4		float		NULL,
Ejercicio5			int			NULL,
Saldo5				money		NULL,
Ingresos5			money		NULL,
Porcentaje5		float		NULL,
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
GraficaSerie		varchar(100) COLLATE DATABASE_DEFAULT NULL
)
SET ARITHABORT OFF
SET ANSI_WARNINGS OFF
SET ARITHIGNORE ON
INSERT INTO @VerContResultadosAnuales
EXEC spVerContResultadosAnuales @Empresa, @EjercicioD, @EjercicioA, @PeriodoA, @ReporteInf, @ConMovs, @CentroCostos, @Sucursal, @Agrupador, @ContMoneda, @Grupo, @UEN, @Proyecto, @CentroCostos2, @CentroCostos3
SET ARITHABORT ON
SET ANSI_WARNINGS ON
SET ARITHIGNORE ON
INSERT INTO @ContResultadosAnuales
SELECT *, @Desglosar, NULL, NULL, NULL, 0, 0, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, NULL FROM @VerContResultadosAnuales
SELECT @Contador = 0
DECLARE crOrden CURSOR FAST_FORWARD FOR
SELECT DISTINCT Clase, Orden
FROM @VerContResultadosAnuales
ORDER BY Orden, Clase
OPEN crOrden
FETCH NEXT FROM crOrden  INTO @Clase, @Orden
WHILE @@FETCH_STATUS = 0
BEGIN
IF EXISTS(SELECT * FROM @ContResultadosAnuales WHERE Clase = @Clase AND Orden1 IS NULL)
BEGIN
SELECT @Contador = @Contador + 1
UPDATE @ContResultadosAnuales SET Orden1 = @Contador WHERE Clase = @Clase
END
FETCH NEXT FROM crOrden  INTO @Clase, @Orden
END
CLOSE crOrden
DEALLOCATE crOrden
SELECT @Saldo1 = 0.00, @Saldo2 = 0.00, @Saldo3 = 0.00, @Saldo4 = 0.00, @Saldo5 = 0.00, @ClaseAnt = ''
DECLARE crOrden CURSOR FAST_FORWARD FOR
SELECT ID, Clase, Ejercicio1, Ejercicio2, Ejercicio3, Ejercicio4, Ejercicio5
FROM @ContResultadosAnuales
GROUP BY ID, Clase, Orden, Ejercicio1, Ejercicio2, Ejercicio3, Ejercicio4, Ejercicio5
ORDER BY ID, Ejercicio1, Ejercicio2, Ejercicio3, Ejercicio4, Ejercicio5
OPEN crOrden
FETCH NEXT FROM crOrden  INTO @ID, @Clase, @Ejercicio1, @Ejercicio2, @Ejercicio3, @Ejercicio4, @Ejercicio5
WHILE @@FETCH_STATUS = 0
BEGIN
IF @ClaseAnt = '' SELECT @ClaseAnt = @Clase
IF @ClaseAnt <> @Clase
BEGIN
INSERT INTO @ContResultadosAnuales(GraficaArgumento, GraficaValor, GraficaSerie,  Grafica1, Grafica2, Orden, Orden1, Titulo, Reporte, Direccion2, Direccion3, Direccion4, Desglosar)
SELECT @ClaseAnt, @Saldo1, @Ejercicio1, 1, 0, 999999999, 999999999, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @Desglosar
INSERT INTO @ContResultadosAnuales(GraficaArgumento, GraficaValor, GraficaSerie,  Grafica1, Grafica2, Orden, Orden1, Titulo, Reporte, Direccion2, Direccion3, Direccion4, Desglosar)
SELECT @ClaseAnt, @Saldo2, @Ejercicio2, 1, 0, 999999999, 999999999, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @Desglosar
INSERT INTO @ContResultadosAnuales(GraficaArgumento, GraficaValor, GraficaSerie,  Grafica1, Grafica2, Orden, Orden1, Titulo, Reporte, Direccion2, Direccion3, Direccion4, Desglosar)
SELECT @ClaseAnt, @Saldo3, @Ejercicio3, 1, 0, 999999999, 999999999, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @Desglosar
INSERT INTO @ContResultadosAnuales(GraficaArgumento, GraficaValor, GraficaSerie,  Grafica1, Grafica2, Orden, Orden1, Titulo, Reporte, Direccion2, Direccion3, Direccion4, Desglosar)
SELECT @ClaseAnt, @Saldo4, @Ejercicio4, 1, 0, 999999999, 999999999, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @Desglosar
INSERT INTO @ContResultadosAnuales(GraficaArgumento, GraficaValor, GraficaSerie,  Grafica1, Grafica2, Orden, Orden1, Titulo, Reporte, Direccion2, Direccion3, Direccion4, Desglosar)
SELECT @ClaseAnt, @Saldo5, @Ejercicio5, 1, 0, 999999999, 999999999, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @Desglosar
END
SELECT @Saldo1 = @Saldo1 - ISNULL(Saldo1,0.00),
@Saldo2 = @Saldo2 - ISNULL(Saldo2,0.00),
@Saldo3 = @Saldo3 - ISNULL(Saldo3,0.00),
@Saldo4 = @Saldo4 - ISNULL(Saldo4,0.00),
@Saldo5 = @Saldo5 - ISNULL(Saldo5,0.00)
FROM @ContResultadosAnuales
WHERE ID = @ID
SELECT @ClaseAnt = @Clase
FETCH NEXT FROM crOrden  INTO @ID, @Clase, @Ejercicio1, @Ejercicio2, @Ejercicio3, @Ejercicio4, @Ejercicio5
END
INSERT INTO @ContResultadosAnuales(GraficaArgumento, GraficaValor, GraficaSerie,  Grafica1, Grafica2, Orden, Orden1, Titulo, Reporte, Direccion2, Direccion3, Direccion4, Desglosar)
SELECT @ClaseAnt, @Saldo1, @Ejercicio1, 1, 0, 999999999, 999999999, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @Desglosar
INSERT INTO @ContResultadosAnuales(GraficaArgumento, GraficaValor, GraficaSerie,  Grafica1, Grafica2, Orden, Orden1, Titulo, Reporte, Direccion2, Direccion3, Direccion4, Desglosar)
SELECT @ClaseAnt, @Saldo2, @Ejercicio2, 1, 0, 999999999, 999999999, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @Desglosar
INSERT INTO @ContResultadosAnuales(GraficaArgumento, GraficaValor, GraficaSerie,  Grafica1, Grafica2, Orden, Orden1, Titulo, Reporte, Direccion2, Direccion3, Direccion4, Desglosar)
SELECT @ClaseAnt, @Saldo3, @Ejercicio3, 1, 0, 999999999, 999999999, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @Desglosar
INSERT INTO @ContResultadosAnuales(GraficaArgumento, GraficaValor, GraficaSerie,  Grafica1, Grafica2, Orden, Orden1, Titulo, Reporte, Direccion2, Direccion3, Direccion4, Desglosar)
SELECT @ClaseAnt, @Saldo4, @Ejercicio4, 1, 0, 999999999, 999999999, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @Desglosar
INSERT INTO @ContResultadosAnuales(GraficaArgumento, GraficaValor, GraficaSerie,  Grafica1, Grafica2, Orden, Orden1, Titulo, Reporte, Direccion2, Direccion3, Direccion4, Desglosar)
SELECT @ClaseAnt, @Saldo5, @Ejercicio5, 1, 0, 999999999, 999999999, @Titulo, @Reporte, @Direccion2, @Direccion3, @Direccion4, @Desglosar
CLOSE crOrden
DEALLOCATE crOrden
UPDATE @ContResultadosAnuales
SET Saldo1 = 0.00
WHERE Saldo1 IS NULL
UPDATE @ContResultadosAnuales
SET Porcentaje1 = 0.00
WHERE Porcentaje1 IS NULL
UPDATE @ContResultadosAnuales
SET Saldo2 = 0.00
WHERE Saldo2 IS NULL
UPDATE @ContResultadosAnuales
SET Porcentaje2 = 0.00
WHERE Porcentaje2 IS NULL
UPDATE @ContResultadosAnuales
SET Saldo3 = 0.00
WHERE Saldo3 IS NULL
UPDATE @ContResultadosAnuales
SET Porcentaje3 = 0.00
WHERE Porcentaje3 IS NULL
UPDATE @ContResultadosAnuales
SET Saldo4 = 0.00
WHERE Saldo4 IS NULL
UPDATE @ContResultadosAnuales
SET Porcentaje4 = 0.00
WHERE Porcentaje4 IS NULL
UPDATE @ContResultadosAnuales
SET Saldo5 = 0.00
WHERE Saldo5 IS NULL
UPDATE @ContResultadosAnuales
SET Porcentaje5 = 0.00
WHERE Porcentaje5 IS NULL
SELECT *, @Etiqueta as Etiqueta, @VerGraficaDetalle as VerGraficaDetalle FROM @ContResultadosAnuales
END

