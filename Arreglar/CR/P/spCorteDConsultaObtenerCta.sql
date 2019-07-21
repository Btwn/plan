SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteDConsultaObtenerCta
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
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS
BEGIN
SELECT ContAux.ID,				ContAux.Empresa,					ContAux.Cuenta,						ContAux.SubCuenta,
ContAux.Ejercicio,			ContAux.Periodo,					ContAux.Renglon,					ContAux.RenglonSub,
ContAux.Concepto,			ContAux.Debe/@TipoCambio 'Debe',	ContAux.Haber/@TipoCambio 'Haber',	ContAux.FechaContable,
ContAux.Movimiento,		ContMov = ContAux.Mov,				ContAux.Referencia,					ContAux.Estatus,
ContAux.SucursalContable,	ContAux.MovID,						ContAux.ContactoTipo,				ContAux.Contacto
INTO #TempContAux
FROM ContAux
JOIN dbo.fnCtaAuxiliar(@CCuenta) Cta ON ContAux.Cuenta = Cta.Cuenta
WHERE ISNULL(ContAux.Empresa, '')			= ISNULL(@CEmpresa, ISNULL(ContAux.Empresa, ''))
AND ISNULL(ContAux.Estatus, '')			= ISNULL(@CEstatus, ISNULL(ContAux.Estatus, ''))
AND ContAux.FechaContable					>= ISNULL(@CFechaD, ContAux.FechaContable)
AND ContAux.FechaContable					<= ISNULL(@CFechaA, ContAux.FechaContable)
AND ISNULL(ContAux.Ejercicio, 0)			= ISNULL(@CEjercicio, ISNULL(ContAux.Ejercicio, 0))
AND ISNULL(ContAux.Periodo, 0)				= ISNULL(@CPeriodo, ISNULL(ContAux.Periodo, 0))
AND ISNULL(ContAux.Mov, '')				= ISNULL(@CMovimiento, ISNULL(ContAux.Mov, ''))
AND ISNULL(ContAux.SucursalContable, 0)	= ISNULL(@CSucursal, ISNULL(ContAux.SucursalContable, 0))
AND ISNULL(ContAux.UEN, 0)					= ISNULL(@CUEN, ISNULL(ContAux.UEN, 0))
AND ISNULL(ContAux.Proyecto, '')			= ISNULL(@CProyecto, ISNULL(ContAux.Proyecto, ''))
AND ISNULL(ContAux.ContactoTipo, '')		= ISNULL(@CContactoTipo, ISNULL(ContAux.ContactoTipo, ''))
AND ISNULL(ContAux.Contacto, '')			= ISNULL(@CContacto, ISNULL(ContAux.Contacto, ''))
AND (ISNULL(ContAux.Debe, 0)				BETWEEN ISNULL(@CImporteMin, ISNULL(ContAux.Debe, 0)) AND ISNULL(@CImporteMax, ISNULL(ContAux.Debe, 0))
OR ISNULL(ContAux.Haber, 0)				BETWEEN ISNULL(@CImporteMin, ISNULL(ContAux.Haber, 0)) AND ISNULL(@CImporteMax, ISNULL(ContAux.Haber, 0))
)
ORDER BY ContAux.Cuenta, ContAux.FechaContable, ContAux.ID
SELECT @ID,								Cta.Cuenta,					t.SubCuenta,
t.Debe,							t.Haber,					t.SucursalContable,
@RID,								t.ContMov,					t.MovID,
t.Periodo,							t.Ejercicio,				dbo.fnCtaMayor(Cta.Cuenta),
dbo.fnCtaSubCuenta(Cta.Cuenta),	t.Empresa,					t.FechaContable
FROM Cta
JOIN #TempContAux t ON Cta.Cuenta = t.Cuenta
WHERE Cta.TieneMovimientos	 = 1
AND Cta.EsAcumulativa		 = 0
AND ISNULL(Cta.Categoria, 0) = ISNULL(ISNULL(@CCtaCategoria, Cta.Categoria), 0)
AND ISNULL(Cta.Familia, 0)	 = ISNULL(ISNULL(@CCtaFamilia, Cta.Familia), 0)
AND ISNULL(Cta.Grupo, 0)	 = ISNULL(ISNULL(@CCtaGrupo, Cta.Grupo), 0)
ORDER BY Cta.Cuenta, t.FechaContable, t.ID  ASC
RETURN
END

