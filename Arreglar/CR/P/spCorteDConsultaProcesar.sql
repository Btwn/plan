SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteDConsultaProcesar
@ID					int,
@RID				int,
@CEmpresa			varchar(5),
@CSucursal			int,
@CUEN				int,
@CUsuario			varchar(10),
@CModulo			varchar(5),
@CMovimiento		varchar(20),
@CEstatus			varchar(15),
@CSituacion			varchar(50),
@CProyecto			varchar(50),
@CContactoTipo		varchar(20),
@CContacto			varchar(10),
@CImporteMin		float,
@CImporteMax		float,
@CValidarAlEmitir	bit,
@CAccion			varchar(8),
@CDesglosar			varchar(20),
@CAgrupador			varchar(50),
@CMoneda			varchar(10),
@Moneda				varchar(10),
@TipoCambio			float,
@MovTipo     		char(20),
@SubMovTipo			char(20),
@CFiltrarFechas		bit,
@CPeriodo			int,
@CEjercicio			int,
@CFechaD			datetime,
@CFechaA			datetime,
@CTotalizador		varchar(255),
@CCuenta			varchar(20),
@CCtaCategoria		varchar(50),
@CCtaFamilia		varchar(50),
@CCtaGrupo			varchar(50),
@CCtaFabricante		varchar(50),
@CCtaLinea			varchar(50),
@CRama				varchar(50),
@CAlmacen			varchar(50),
@CValuacion			varchar(50),
@CCtaTipo			varchar(50),
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS
BEGIN
CREATE TABLE #CorteDTmp(
Mov				varchar(20)	COLLATE DATABASE_DEFAULT NULL,
MovID			varchar(20)	COLLATE DATABASE_DEFAULT NULL,
Fecha			datetime	NULL,
Moneda			varchar(10)	COLLATE DATABASE_DEFAULT NULL,
Referencia		varchar(50)	COLLATE DATABASE_DEFAULT NULL,
Grupo			varchar(10)	COLLATE DATABASE_DEFAULT NULL,
Sucursal		int			NULL,
Modulo			varchar(5)	COLLATE DATABASE_DEFAULT NULL,
ModuloID		int			NULL,
Importe			float		NULL,
RIDConsulta		int			NULL,
ID				int			NULL,
TipoCambio		float		NULL,
Periodo			int			NULL,
Ejercicio		int			NULL,
Cuenta			varchar(20)	COLLATE DATABASE_DEFAULT NULL,
SubCuenta		varchar(50)	COLLATE DATABASE_DEFAULT NULL,
Cargo			float		NULL,
Abono			float		NULL,
Estatus			varchar(15)	NULL,
CtaMayor		varchar(20)	COLLATE DATABASE_DEFAULT NULL,
CtaSubCuenta	varchar(20)	COLLATE DATABASE_DEFAULT NULL,
Empresa			varchar(5)	COLLATE DATABASE_DEFAULT NULL,
CargoU			float		NULL,
PrecioLista		float		NULL,
Precio2			float		NULL,
Precio3			float		NULL,
AbonoU			float		NULL,
Precio4			float		NULL,
Precio5			float		NULL,
Precio6			float		NULL,
Precio7			float		NULL,
Precio8			float		NULL,
Precio9			float		NULL,
Precio10		float		NULL,
CostoEstandar	float		NULL,
CostoReposicion	float		NULL,
CostoPromedio	float		NULL,
UltimoCosto		float		NULL,
AuxID			int			NULL,
EsCancelacion	bit			NULL,
SaldoU			float		NULL,
SaldoUI			float		NULL
)
IF @MovTipo = 'CORTE.CORTEIMPORTE'
BEGIN
INSERT INTO #CorteDTmp(Mov, MovID, Fecha, Moneda, Referencia, Grupo, Sucursal, Modulo, ModuloID, Importe, RIDConsulta, ID, TipoCambio, Periodo, Ejercicio, Estatus)
EXEC spCorteDConsultaObtenerMov @ID, @RID, @CEmpresa, @CSucursal, @CUEN, @CUsuario, @CModulo, @CMovimiento, @CEstatus,
@CSituacion, @CProyecto, @CContactoTipo, @CContacto, @CImporteMin, @CImporteMax, @CValidarAlEmitir,
@CAccion, @CDesglosar, @CAgrupador, @CMoneda, @Moneda, @TipoCambio, @CFiltrarFechas,
@CPeriodo, @CEjercicio, @CFechaD, @CFechaA, @CTotalizador,
@Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
EXEC spCorteDConsultaMovImporte @ID, @RID, @CEmpresa, @CSucursal, @CUEN, @CUsuario, @CModulo, @CMovimiento, @CEstatus,
@CSituacion, @CProyecto, @CContactoTipo, @CContacto, @CImporteMin, @CImporteMax, @CValidarAlEmitir,
@CAccion, @CDesglosar, @CAgrupador, @CMoneda, @Moneda, @TipoCambio, @CFiltrarFechas,
@CPeriodo, @CEjercicio, @CFechaD, @CFechaA, @CTotalizador,
@Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @CDesglosar IN('Movimiento', 'No')
INSERT INTO #CorteD(
Mov,		MovID,			Fecha,		Moneda,			Referencia,			Grupo,		Sucursal,		Modulo,			ModuloID,
Importe,	RIDConsulta,	ID,			TipoCambio,		Periodo,			Ejercicio,	Estatus,		SaldoU)
SELECT Mov,		MovID,			Fecha,		Moneda,			Referencia,			Grupo,		Sucursal,		Modulo,			ModuloID,
Importe,	RIDConsulta,	ID,			TipoCambio,		Periodo,			Ejercicio,	Estatus,		SaldoU
FROM #CorteDTmp
WHERE ID			= @ID
AND RIDConsulta	= @RID
ORDER BY Fecha, Mov, MovID
ELSE IF @CDesglosar = 'Periodo'
INSERT INTO #CorteD(
Mov,			MovID,			Fecha,		Moneda,			Referencia,			Grupo,		Sucursal,		Modulo,			ModuloID,
Importe,		RIDConsulta,	ID,			TipoCambio,		Periodo,			Ejercicio,	Estatus,		SaldoU)
SELECT NULL,			NULL,			NULL,		NULL,			NULL,				NULL,		NULL,			NULL,			NULL,
SUM(Importe),	RIDConsulta,	ID,			NULL,			Periodo,			Ejercicio,	NULL,			SUM(SaldoU)
FROM #CorteDTmp
WHERE ID			= @ID
AND RIDConsulta	= @RID
GROUP BY RIDConsulta, ID, Periodo, Ejercicio
ORDER BY RIDConsulta, ID, Periodo, Ejercicio
ELSE IF @CDesglosar = 'Ejercicio'
INSERT INTO #CorteD(
Mov,			MovID,			Fecha,		Moneda,			Referencia,			Grupo,		Sucursal,		Modulo,			ModuloID,
Importe,		RIDConsulta,	ID,			TipoCambio,		Periodo,			Ejercicio,	Estatus,		SaldoU)
SELECT NULL,			NULL,			NULL,		NULL,			NULL,				NULL,		NULL,			NULL,			NULL,
SUM(Importe),	RIDConsulta,	ID,			NULL,			NULL,				Ejercicio,	NULL,			SUM(SaldoU)
FROM #CorteDTmp
WHERE ID			= @ID
AND RIDConsulta	= @RID
GROUP BY RIDConsulta, ID, Ejercicio
ORDER BY RIDConsulta, ID, Ejercicio
END
ELSE IF @MovTipo = 'CORTE.CORTECONTABLE'
BEGIN
INSERT INTO #CorteDTmp(ID, Cuenta, SubCuenta, Cargo, Abono, Sucursal, RIDConsulta, Mov, MovID, Periodo, Ejercicio, CtaMayor, CtaSubCuenta, Empresa, Fecha)
EXEC spCorteDConsultaObtenerCta @ID, @RID, @CEmpresa, @CSucursal, @CUEN, @CUsuario, @CModulo, @CMovimiento, @CEstatus,
@CSituacion, @CProyecto, @CContactoTipo, @CContacto, @CImporteMin, @CImporteMax, @CValidarAlEmitir,
@CAccion, @CDesglosar, @CAgrupador, @CMoneda, @Moneda, @TipoCambio, @CFiltrarFechas,
@CPeriodo, @CEjercicio, @CFechaD, @CFechaA, @CTotalizador, @CCuenta, @CCtaCategoria,
@CCtaFamilia, @CCtaGrupo, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @CDesglosar IN('Movimiento')
INSERT INTO #CorteD(
RIDConsulta,	ID,			Cuenta,			Cargo,			Abono,		Mov,		MovID,		Empresa,
Sucursal)
SELECT RIDConsulta,	ID,			Cuenta,			Cargo,			Abono,		Mov,		MovID,		Empresa,
Sucursal
FROM #CorteDTmp
ORDER BY Cuenta, Fecha, ID  ASC
IF @CDesglosar IN('No', 'Auxiliar')
INSERT INTO #CorteD(
RIDConsulta,	ID,			Cuenta,			Cargo,			Abono,			Empresa,
Sucursal)
SELECT RIDConsulta,	ID,			Cuenta,			SUM(Cargo),		SUM(Abono),		Empresa,
Sucursal
FROM #CorteDTmp
GROUP BY RIDConsulta, ID, Cuenta, Empresa, Sucursal
ORDER BY RIDConsulta, ID, Cuenta, Empresa, Sucursal
ELSE IF @CDesglosar IN('Mayor')
INSERT INTO #CorteD(
RIDConsulta,		ID,			Cuenta,			Cargo,			Abono,			Empresa,
Sucursal)
SELECT RIDConsulta,		ID,			CtaMayor,		SUM(Cargo),		SUM(Abono),		Empresa,
Sucursal
FROM #CorteDTmp
GROUP BY RIDConsulta, ID, CtaMayor, Empresa, Sucursal
ELSE IF @CDesglosar IN('SubCuenta')
INSERT INTO #CorteD(
RIDConsulta,		ID,			Cuenta,			Cargo,			Abono,			Empresa,
Sucursal)
SELECT RIDConsulta,		ID,			CtaSubCuenta,	SUM(Cargo),		SUM(Abono),		Empresa,
Sucursal
FROM #CorteDTmp
GROUP BY RIDConsulta, ID, CtaSubCuenta, Empresa, Sucursal
ORDER BY RIDConsulta, ID, CtaSubCuenta, Empresa, Sucursal
END
ELSE IF @MovTipo = 'CORTE.CORTEUNIDADES'
BEGIN
INSERT INTO #CorteDTmp(Empresa, Cuenta, SubCuenta, Fecha, CargoU, PrecioLista, Precio2, Precio3, AbonoU, Precio4, Precio5, Precio6, Precio7, Precio8, Precio9, Precio10, CostoEstandar, CostoReposicion, CostoPromedio, UltimoCosto, Mov, MovID, ID, RIDConsulta, AUXID, EsCancelacion, Grupo)
EXEC spCorteDConsultaObtenerUnidades @ID, @RID, @CEmpresa, @CSucursal, @CUEN, @CUsuario, @CModulo, @CMovimiento, @CEstatus,
@CSituacion, @CProyecto, @CContactoTipo, @CContacto, @CImporteMin, @CImporteMax, @CValidarAlEmitir,
@CAccion, @CDesglosar, @CAgrupador, @CMoneda, @Moneda, @TipoCambio, @CFiltrarFechas,
@CPeriodo, @CEjercicio, @CFechaD, @CFechaA, @CTotalizador, @CCuenta, @CCtaCategoria,
@CCtaFamilia, @CCtaGrupo, @CCtaFabricante, @CCtaLinea, @CRama, @CAlmacen, @CValuacion,
@Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @CDesglosar IN('Movimiento')
INSERT INTO #CorteD(
Empresa,		Cuenta,				SubCuenta,		Fecha,			CargoU,			PrecioLista,		Precio2,		Precio3,
AbonoU,			Precio4,			Precio5,		Precio6,		Precio7,		Precio8,			Precio9,		Precio10,
CostoEstandar,	CostoReposicion,	CostoPromedio,	UltimoCosto,	Mov,			MovID,				ID,				RIDConsulta,
EsCancelacion,	Grupo)
SELECT Empresa,		Cuenta,				SubCuenta,		Fecha,			CargoU,			PrecioLista,		Precio2,		Precio3,
AbonoU,			Precio4,			Precio5,		Precio6,		Precio7,		Precio8,			Precio9,		Precio10,
CostoEstandar,	CostoReposicion,	CostoPromedio,	UltimoCosto,	Mov,			MovID,				ID,				RIDConsulta,
EsCancelacion,	Grupo
FROM #CorteDTmp
ORDER BY Cuenta, SubCuenta, Fecha, ID
ELSE IF @CDesglosar IN('Articulo', 'No')
INSERT INTO #CorteD(
Empresa,		Cuenta,				SubCuenta,		Fecha,			CargoU,			PrecioLista,		Precio2,		Precio3,
AbonoU,			Precio4,			Precio5,		Precio6,		Precio7,		Precio8,			Precio9,		Precio10,
CostoEstandar,	CostoReposicion,	CostoPromedio,	UltimoCosto,	Mov,			MovID,				ID,				RIDConsulta,
EsCancelacion,	Grupo)
SELECT Empresa,		Cuenta,				SubCuenta,		NULL,			SUM(CargoU),	PrecioLista,		Precio2,		Precio3,
SUM(AbonoU),	Precio4,			Precio5,		Precio6,		Precio7,		Precio8,			Precio9,		Precio10,
CostoEstandar,	CostoReposicion,	CostoPromedio,	UltimoCosto,	NULL,			NULL,				ID,				RIDConsulta,
NULL,			Grupo
FROM #CorteDTmp
GROUP BY Empresa, Cuenta, SubCuenta, PrecioLista, Precio2, Precio3, Precio4, Precio5, Precio6, Precio7, Precio8, Precio9, Precio10,
CostoEstandar, CostoReposicion, CostoPromedio, UltimoCosto, ID, RIDConsulta, Grupo
ORDER BY Cuenta, SubCuenta
END
IF @MovTipo = 'CORTE.CORTECX'
BEGIN
INSERT INTO #CorteDTmp(Empresa, AUXID, Fecha, Cargo, Abono, Cuenta, ID, RIDConsulta, Mov, MovID, EsCancelacion)
EXEC spCorteDConsultaObtenerCx @ID, @RID, @CEmpresa, @CSucursal, @CUEN, @CUsuario, @CModulo, @CMovimiento, @CEstatus,
@CSituacion, @CProyecto, @CContactoTipo, @CContacto, @CImporteMin, @CImporteMax, @CValidarAlEmitir,
@CAccion, @CDesglosar, @CAgrupador, @CMoneda, @Moneda, @TipoCambio, @CFiltrarFechas,
@CPeriodo, @CEjercicio, @CFechaD, @CFechaA, @CTotalizador, @CCuenta, @CCtaCategoria,
@CCtaFamilia, @CCtaGrupo, @CCtaFabricante, @CCtaLinea, @CRama, @CAlmacen, @CValuacion,
@CCtaTipo,
@Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @CDesglosar IN('Movimiento')
INSERT INTO #CorteD(
Empresa,		Fecha,		Cargo,			Abono,		Cuenta,		ID,		RIDConsulta,
Mov,			MovID,		EsCancelacion)
SELECT Empresa,		Fecha,		Cargo,			Abono,		Cuenta,		ID,		RIDConsulta,
Mov,			MovID,		EsCancelacion
FROM #CorteDTmp
ORDER BY Cuenta, Fecha, AuxID
ELSE IF @CDesglosar IN('Contacto', 'No')
INSERT INTO #CorteD(
Empresa,		Cargo,			Abono,			Cuenta,		ID,		RIDConsulta)
SELECT Empresa,		SUM(Cargo),		SUM(Abono),		Cuenta,		ID,		RIDConsulta
FROM #CorteDTmp
GROUP BY Empresa, Cuenta, ID, RIDConsulta
ORDER BY Cuenta
END
IF @MovTipo IN('CORTE.CORTECX', 'CORTE.CORTEUNIDADES', 'CORTE.CORTECONTABLE', 'CORTE.CORTECX') AND NULLIF(NULLIF(@CMovimiento, ''), '(TODOS)') IS NULL
EXEC spCorteDConsultaCtaSaldoI @ID, @RID, @CFiltrarFechas, @CPeriodo, @CEjercicio, @CFechaD, @CFechaA, @CDesglosar,
@CMoneda, @Moneda, @TipoCambio, @MovTipo, @CAlmacen, @CValuacion, @CModulo, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
EXEC spCorteDConsultaImporte @ID, @RID, @MovTipo, @CValuacion, @CDesglosar, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
RETURN
END

