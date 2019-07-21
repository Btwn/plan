SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ExistenciaInvPosicionSerieLote

AS
SELECT Empresa, Almacen, SerieLote, Articulo, SubCuenta, Existencia = SUM((ISNULL(Entrada, 0.0)-ISNULL(Salida, 0.0))/ISNULL(Factor, 1.0)), ExistenciaAlterna = SUM((ISNULL(Entrada, 0.0)-ISNULL(Salida, 0.0))), Posicion
FROM AuxiliarAlterno WITH (NOLOCK)
GROUP BY Empresa, Almacen, SerieLote, Articulo, SubCuenta, Posicion

