SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMesInvTransferLanzamiento
@Empresa          varchar(5),
@Usuario          varchar(10),
@Lanzamiento      int

AS
BEGIN
DELETE FROM MesInvTransfer WHERE Usuario = @Usuario
DELETE FROM MesInvTransferSerieLote WHERE Usuario = @Usuario
INSERT INTO MesInvTransfer
(Usuario,     Lanzamiento,     Padre,     Hijo,   Almacen,      AlmacenD,       Cantidad,
CantidadA,
UltimoPrecioCoste, PrecioCosteMedio, UnidMedidaCompra, UnidMedidaAlmacen, Transferido)
SELECT @Usuario, pcm.Lanzamiento, pcm.Padre, pcm.Hijo, a.AlmMesComs, a.AlmacenROP, pcm.CantidadTotalHijo,
CASE WHEN ISNULL(ad.Disponible, 0)<= 0 THEN 0 ELSE pcm.CantidadTotalHijo END,
pcm.UltimoPrecioCoste, pcm.PrecioCosteMedio, pcm.UnidMedidaCompra, pcm.UnidMedidaAlmacen, pcm.Transferido
FROM PrevisionesConsumoMES pcm
JOIN Art a ON pcm.Hijo = a.Articulo
LEFT OUTER JOIN ArtDisponible ad ON ad.Empresa = @Empresa AND ad.Articulo = a.Articulo AND ad.Almacen = a.AlmMesComs
WHERE pcm.Lanzamiento = @Lanzamiento
AND ISNULL(pcm.EstatusIntelIMES, 0) IN (0,1)
RETURN
END

