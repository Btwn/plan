SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisMovilAgendaActualizar
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int          = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
SET nocount ON
BEGIN TRY
UPDATE CampanaD
SET CampanaD.FechaD = TablaPaso.FechaD, CampanaD.FechaA = TablaPaso.FechaA
FROM (SELECT * FROM OPENXML(@iSolicitud, N'Intelisis/Resultado/AgendaEstacion', 2)
WITH (ID varchar(max), RID varchar(max), FechaD varchar(max), FechaA varchar(max))) TablaPaso
WHERE TablaPaso.ID = CampanaD.ID AND TablaPaso.RID = CampanaD.RID
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(Referencia,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '>' + '<Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),ISNULL (CAST((SELECT (SELECT DISTINCT ID FROM OPENXML(@iSolicitud, N'Intelisis/Solicitud/Parametro/AgendaEstacion', 2) WITH (ID varchar(max))) ID FOR XML PATH('MovilAgendaActualizar'), ELEMENTS) AS NVARCHAR(MAX)),'')) + '</Resultado></Intelisis>'
FROM OPENXML(@iSolicitud, N'Intelisis')
WITH (Referencia varchar(max), SubReferencia varchar(max))
END TRY
BEGIN CATCH
SELECT @Ok = 1, @OkRef = ERROR_MESSAGE()
END CATCH
SET nocount OFF
END

