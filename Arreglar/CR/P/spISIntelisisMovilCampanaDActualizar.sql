SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spISIntelisisMovilCampanaDActualizar
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Agente		  varchar(10),
@Usuario	  varchar(10),
@IdVisita	  varchar(10),
@AccionMovil  varchar(20),
@Situacion    varchar(50),
@SubSituacion varchar(50),
@IDO          int
SELECT
@Usuario      = Usuario,
@IdVisita     = IdVisita,
@AccionMovil  = Accion,
@SubSituacion = SubSituacion
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud')
WITH (Usuario varchar(10), IdVisita varchar(10), Accion varchar(20), SubSituacion varchar(50))
IF @AccionMovil NOT IN ('Cancelado', 'Confirmado')
SELECT @Ok = 73040, @OkRef = @AccionMovil
IF @Ok IS NULL
BEGIN
SELECT @Agente = Agente
FROM MovilUsuarioCfg
WHERE Usuario = @Usuario
SELECT @Situacion = Situacion
FROM CampanaTipoSituacion
WHERE AccionMovil = @AccionMovil
UPDATE CampanaD
SET Usuario = @Usuario, Situacion = @Situacion, SubSituacion = @SubSituacion, SituacionFecha = GETDATE()
WHERE RID = @IdVisita
SELECT TOP 1 @IDO = ID
FROM CampanaD
WHERE RID=@IdVisita
INSERT CampanaEvento(ID,RID,FechaHora,Tipo,Situacion,SituacionFecha,Observaciones,Comentarios,Sucursal,SucursalOrigen)
VALUES (@IDO,@IdVisita,GETDATE(),'Cita',@Situacion,GETDATE(),'','',0,0)
SELECT @Resultado = CAST((
SELECT * FROM (
SELECT	Visitas.RID IdVisita,
@AccionMovil Accion,
Visitas.SubSituacion,
Visitas.SituacionFecha
FROM	CampanaD Visitas
WHERE	Visitas.RID = @IdVisita
) AS MovilCampanaDActualizacion FOR XML AUTO, TYPE, ELEMENTS
) AS NVARCHAR(MAX))
END
END

