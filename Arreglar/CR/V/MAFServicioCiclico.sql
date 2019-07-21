SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MAFServicioCiclico
AS
SELECT
v.ServicioTipo,
v.AFArticulo,
v.AFSerie,
v.ID,
v.Mov,
v.MovID,
v.Estatus,
v.MAFCiclo
FROM Venta v JOIN MovTipo mt
ON v.Mov = mt.Mov AND mt.Modulo = 'VTAS' JOIN ActivoFTipoServicio afts
ON v.ServicioTipo = afts.Servicio
WHERE mt.SubClave = 'MAF.S'
AND v.Estatus NOT IN ('CANCELADO')

