SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteDConsultaObtenerCx
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
SELECT CxcAux.Empresa,	CxcAux.ID,				CxcAux.Fecha,			(CxcAux.Cargo*TipoCambio)/@TipoCambio,		(CxcAux.Cargo*TipoCambio)/CxcAux.Abono,
Cte.Cliente,		@ID,					@RID,					CxcAux.Mov,									CxcAux.MovID,
EsCancelacion
FROM CxcAux
JOIN Cte ON CxcAux.Cliente = Cte.Cliente
WHERE ISNULL(CxcAux.Empresa, '')  =  ISNULL(@CEmpresa, ISNULL(CxcAux.Empresa, ''))
AND ISNULL(CxcAux.Moneda, '')	 =  ISNULL(@CMoneda, ISNULL(CxcAux.Moneda, ''))
AND ISNULL(Cte.Cliente, '')	 = ISNULL(@CContacto, ISNULL(Cte.Cliente, ''))
AND CxcAux.Fecha				 >= ISNULL(@CFechaD, CxcAux.Fecha)
AND CxcAux.Fecha				 <= ISNULL(@CFechaA, CxcAux.Fecha)
AND ISNULL(CxcAux.Ejercicio, 0) = ISNULL(@CEjercicio, ISNULL(CxcAux.Ejercicio, 0))
AND ISNULL(CxcAux.Periodo, 0)	 = ISNULL(@CPeriodo, ISNULL(CxcAux.Periodo, 0))
AND ISNULL(CxcAux.Mov, '')		 =  ISNULL(@CMovimiento, ISNULL(CxcAux.Mov, ''))
AND ISNULL(Cte.Categoria, '')	 =  ISNULL(@CCtaCategoria, ISNULL(Cte.Categoria, ''))
AND ISNULL(Cte.Familia, '')	 =  ISNULL(@CCtaFamilia, ISNULL(Cte.Familia, ''))
AND ISNULL(Cte.Grupo, '')		 =  ISNULL(@CCtaGrupo, ISNULL(Cte.Grupo, ''))
AND ISNULL(Cte.Tipo, '')		 =  ISNULL(@CCtaTipo, ISNULL(Cte.Tipo, ''))
AND ISNULL(CxcAux.Rama, '')	 =  ISNULL(@CRama, ISNULL(CxcAux.Rama, ''))
ORDER BY Cte.Cliente, CxcAux.Fecha, CxcAux.ID
RETURN
END

