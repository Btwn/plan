SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteDConsultaObtenerUnidades
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
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS
BEGIN
SELECT InvAuxU.Empresa,				InvAuxU.Cuenta,					InvAuxU.SubCuenta,					InvAuxU.Fecha,							InvAuxU.CargoU,
Art.PrecioLista/@TipoCambio,	Art.Precio2/@TipoCambio,		Art.Precio3/@TipoCambio,			InvAuxU.AbonoU,							Art.Precio4/@TipoCambio,
Art.Precio5/@TipoCambio,		Art.Precio6/@TipoCambio,		Art.Precio7/@TipoCambio,			Art.Precio8/@TipoCambio,				Art.Precio9/@TipoCambio,
Art.Precio10/@TipoCambio,		Art.CostoEstandar/@TipoCambio,	Art.CostoReposicion/@TipoCambio,	ArtConCosto.CostoPromedio/@TipoCambio,	ArtConCosto.UltimoCosto/@TipoCambio,
InvAuxU.Mov,					InvAuxU.MovID,					@ID,								@RID,									ID,
EsCancelacion,					InvAuxU.Grupo
FROM InvAuxU
RIGHT OUTER JOIN Art ON InvAuxU.Articulo=Art.Articulo
RIGHT OUTER JOIN ArtConCosto ON Art.Articulo=ArtConCosto.Articulo AND ISNULL(ArtConCosto.Empresa, '') = ISNULL(@CEmpresa, ISNULL(ArtConCosto.Empresa, ''))
WHERE ISNULL(InvAuxU.Empresa, '') =  ISNULL(@CEmpresa, ISNULL(InvAuxU.Empresa, ''))
AND ISNULL(InvAuxU.Rama, '')	 =  ISNULL(@CRama, ISNULL(InvAuxU.Rama, ''))
AND ISNULL(InvAuxU.Moneda, '')	 =  ISNULL(@CMoneda, ISNULL(InvAuxU.Moneda, ''))
AND ISNULL(Art.Articulo, '')	 = ISNULL(@CCuenta, ISNULL(Art.Articulo, ''))
AND ISNULL(InvAuxU.Mov, '')	 =  ISNULL(@CMovimiento, ISNULL(InvAuxU.Mov, ''))
AND ISNULL(InvAuxU.Grupo, '')	 =  ISNULL(@CAlmacen, ISNULL(InvAuxU.Grupo, ''))
AND ISNULL(Art.Categoria, '')	 =  ISNULL(@CCtaCategoria, ISNULL(Art.Categoria, ''))
AND ISNULL(Art.Familia, '')	 =  ISNULL(@CCtaFamilia, ISNULL(Art.Familia, ''))
AND ISNULL(Art.Grupo, '')		 =  ISNULL(@CCtaGrupo, ISNULL(Art.Grupo, ''))
AND ISNULL(Art.Fabricante, '')	 =  ISNULL(@CCtaFabricante, ISNULL(Art.Fabricante, ''))
AND ISNULL(Art.Linea, '')		 =  ISNULL(@CCtaLinea, ISNULL(Art.Linea, ''))
AND InvAuxU.Fecha				 >= ISNULL(@CFechaD, InvAuxU.Fecha)
AND InvAuxU.Fecha				 <= ISNULL(@CFechaA, InvAuxU.Fecha)
AND ISNULL(InvAuxU.Ejercicio, 0)= ISNULL(@CEjercicio, ISNULL(InvAuxU.Ejercicio, 0))
AND ISNULL(InvAuxU.Periodo, 0)	 = ISNULL(@CPeriodo, ISNULL(InvAuxU.Periodo, 0))
ORDER BY Art.Articulo, InvAuxU.SubCuenta, InvAuxU.Fecha, InvAuxU.ID
RETURN
END

