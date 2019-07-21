SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW PosicionExistencia

AS
SELECT al.Empresa, al.Almacen, al.Posicion, al.Articulo, al.SubCuenta,Unidad=ISNULL(u.Unidad,AL.Unidad), Existencia = SUM((ISNULL(al.Entrada, 0.0)-ISNULL(al.Salida, 0.0))) /*SUM((ISNULL(Entrada, 0.0)-ISNULL(Salida, 0.0))/ISNULL(Factor, 1.0))*/, ExistenciaAlterna = SUM((ISNULL(al.Entrada, 0.0)-ISNULL(al.Salida, 0.0)))
FROM AuxiliarAlterno al WITH(NOLOCK)
Join art a WITH(NOLOCK) ON al.Articulo = a.Articulo
LEFT OUTER JOIN ArtUnidad u WITH(NOLOCK) ON u.Articulo = a.Articulo AND u.Factor = 1
GROUP BY al.Empresa, al.Almacen, al.Posicion, al.Articulo, al.SubCuenta,ISNULL(u.Unidad,AL.Unidad)

