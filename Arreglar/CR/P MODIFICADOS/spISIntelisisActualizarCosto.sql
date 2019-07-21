SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisActualizarCosto
@ID                        int,
@iSolicitud                           int,
@Version                              float,
@Resultado                         varchar(max) = NULL OUTPUT,
@Ok                                       int = NULL OUTPUT,
@OkRef                                 varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Estacion                        int,
@SubReferencia                                            varchar(100),
@ReferenciaIS                       varchar(100),
@IDAcceso                           int
DECLARE @Tabla table (
Articulo                            varchar(20),
Costo                                float,
CostoReposicion    float
)
SELECT @IDAcceso = dbo.fnAccesoID(@@SPID)
SELECT @Estacion = EstacionTrabajo  FROM Acceso WITH (NOLOCK) WHERE ID = @IDAcceso
INSERT @Tabla (Articulo, Costo, CostoReposicion )
SELECT         Articulo, NuevoCostoEstandar, CostoReposicion
FROM OPENXML(@iSolicitud, '/Intelisis/Solicitud/Scosto/DetalleAct',1)
WITH (Articulo  varchar(100), NuevoCostoEstandar float, CostoReposicion float )
IF EXISTS(SELECT * FROM @Tabla)
UPDATE Art SET CostoEstandar = ISNULL(NULLIF(t.Costo,0.0),a.CostoEstandar), CostoReposicion = ISNULL(NULLIF(t.CostoReposicion,0.0),a.CostoReposicion)
FROM @Tabla t JOIN Art a WITH (NOLOCK) ON a.Articulo = t.Articulo
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
SELECT @ReferenciaIS = Referencia
FROM IntelisisService WITH (NOLOCK)
WHERE ID = @ID
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
END

