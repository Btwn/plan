SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.vwIntelisisServiceFactoryMonitor
AS
SELECT top 200 F.ID, F.Sistema, F.Contenido, F.Referencia, F.SubReferencia,
F.[Version], F.Usuario, F.Solicitud, I.Resultado, F.Estatus, F.FechaEstatus,
F.Ok, F.OkRef, F.RID, F.Modulo, F.ModuloID
FROM IntelisisServiceFactory F JOIN IntelisisService I
on F.RID = I.ID AND F.Referencia NOT IN ('Intelisis.INV.InsertarMov.INV_SOL', 'Intelisis.Art.ActCosto')
WHERE F.Estatus <> 'PROCESADO' OR ISNULL(F.ModuloID, 0) = 0
ORDER BY ID DESC

