SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisMovilAgendaListado
@ID                     int,
@iSolicitud       int,
@Version          float,
@Resultado        varchar(max) = NULL OUTPUT,
@Ok                     int = NULL OUTPUT,
@OkRef                  varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Estacion           int,
@IDCampana          int,
@Texto                       xml,
@TextoCfg           xml,
@ReferenciaIS       varchar(100),
@SubReferencia           varchar(100),
@fechaD             varchar(23),
@fechaA             varchar(23),
@fechaC             varchar(23),
@Vacio              varchar(1),
@Empresa            char(5),
@Editable           int
DECLARE @AgendaEstacion TABLE(
EstacionTrabajo int NOT NULL,
ID              int NOT NULL,
RID             int NOT NULL,
ContactoTipo    varchar(20) NOT NULL,
Contacto        varchar(10) NOT NULL,
EnviarA         int NOT NULL,
Nombre          varchar(200)NOT NULL,
Tipo            varchar(20) NULL,
Asunto          varchar(255) NULL,
Ubicacion       varchar(255) NULL,
ColorEtiqueta   int NULL,
FechaD          varchar(23) NULL,
FechaA          varchar(23) NULL,
DiaCompleto     bit NULL DEFAULT (0),
Recordar        bit NULL,
RecordarMinutos int NULL,
RecordarFecha   varchar(23) NULL,
Estado          varchar(100) NULL,
Mensaje         text NULL,
PRIMARY KEY(ID,RID,EstacionTrabajo))
DECLARE @HorarioCgf TABLE(
HorarioD    varchar(5)NULL,
HorarioA    varchar(5)NULL,
Duracion    int NULL,
Habilitar   int NULL)
BEGIN TRANSACTION
IF @Ok IS NULL
BEGIN
SET @Vacio = ' '
SELECT @Estacion = Valor FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Parametro')
WITH (Estacion varchar(255), Valor int)
SELECT @SubReferencia= SubReferencia FROM openxml (@iSolicitud,'/Intelisis')
WITH (SubReferencia varchar(255))
SELECT @ReferenciaIS= Referencia FROM openxml (@iSolicitud,'/Intelisis')
WITH (Referencia varchar(255))
END
SET @fechaD = CONVERT(VARCHAR,DAY(GETDATE()))+'/'+RIGHT('00'+CONVERT(VARCHAR,MONTH(GETDATE())),2)+'/'+CONVERT(VARCHAR,YEAR(GETDATE()))+' '+RIGHT('00'+CONVERT(VARCHAR,DATEPART(HOUR,GETDATE())),2)+':'+RIGHT('00'+CONVERT(VARCHAR,DATEPART(MINUTE,GETDATE())),2)+':00'
SET @fechaA = CONVERT(VARCHAR,DAY(DATEADD(hh,1,GETDATE())))+'/'+RIGHT('00'+CONVERT(VARCHAR,MONTH(DATEADD(hh,1,GETDATE()))),2)+'/'+CONVERT(VARCHAR,YEAR(DATEADD(hh,1,GETDATE())))+' '+RIGHT('00'+CONVERT(VARCHAR,DATEPART(HOUR,DATEADD(hh,1,GETDATE()))),2)+':'+RIGHT('00'+CONVERT(VARCHAR,DATEPART(MINUTE,DATEADD(hh,1,GETDATE()))),2)+':00'
SET @fechaC = CONVERT(VARCHAR,DAY(DATEADD(dd,1,GETDATE())))+'/'+RIGHT('00'+CONVERT(VARCHAR,MONTH(DATEADD(dd,1,GETDATE()))),2)+'/'+CONVERT(VARCHAR,YEAR(DATEADD(dd,1,GETDATE())))+' '+RIGHT('00'+CONVERT(VARCHAR,DATEPART(HOUR,DATEADD(dd,1,GETDATE()))),2)+':'+RIGHT('00'+CONVERT(VARCHAR,DATEPART(MINUTE,DATEADD(dd,1,GETDATE()))),2)+':00'
SELECT @IDCampana = ID
FROM CampanaAM WITH (NOLOCK) 
WHERE Estacion = @Estacion
IF @SubReferencia='ALTA' AND @IDCampana IS NOT NULL
BEGIN
SELECT @Empresa = Empresa,@Editable = CASE WHEN Estatus = 'SINAFECTAR' THEN 1 ELSE 0 END FROM Campana WITH (NOLOCK) WHERE ID = @IDCampana
INSERT INTO @HorarioCgf(HorarioD,HorarioA,Duracion,Habilitar)
SELECT
ISNULL(CONVERT(VARCHAR,RIGHT('00'+CONVERT(VARCHAR,DATEPART(HOUR,HorarioD)),2)+':'+RIGHT('00'+CONVERT(VARCHAR,DATEPART(MINUTE,HorarioD)),2)),''),
ISNULL(CONVERT(VARCHAR,RIGHT('00'+CONVERT(VARCHAR,DATEPART(HOUR,HorarioA)),2)+':'+RIGHT('00'+CONVERT(VARCHAR,DATEPART(MINUTE,HorarioA)),2)),''),
ISNULL(Duracion,0),
@Editable
FROM CampanaMovilCfg WITH (NOLOCK) 
WHERE Empresa = @Empresa
IF NOT EXISTS(SELECT * FROM @HorarioCgf)
INSERT INTO @HorarioCgf(HorarioD,HorarioA,Duracion)VALUES('09:00','18:00',30)
INSERT INTO @AgendaEstacion(EstacionTrabajo, ID, RID, ContactoTipo, Contacto,
EnviarA, Nombre, Tipo, Asunto, Ubicacion, ColorEtiqueta,
FechaD,
FechaA,
DiaCompleto, Recordar,
RecordarMinutos,
RecordarFecha,
Estado, Mensaje)
SELECT @Estacion, d.ID, d.RID, ISNULL(d.ContactoTipo,''), ISNULL(d.Contacto,''),
ISNULL(d.EnviarA,0), '' AS Nombre, ISNULL(c.CampanaTipo,''), ISNULL(d.Instruccion,''), '' AS Ubicacion, 1,
ISNULL(CONVERT(VARCHAR,DAY(d.FechaD))+'/'+RIGHT('00'+CONVERT(VARCHAR,MONTH(d.FechaD)),2)+'/'+CONVERT(VARCHAR,YEAR(d.FechaD))+' '+RIGHT('00'+CONVERT(VARCHAR,DATEPART(HOUR,d.FechaD)),2)+':'+RIGHT('00'+CONVERT(VARCHAR,DATEPART(MINUTE,d.FechaD)),2)+':00',' '),
ISNULL(CONVERT(VARCHAR,DAY(d.FechaA))+'/'+RIGHT('00'+CONVERT(VARCHAR,MONTH(d.FechaA)),2)+'/'+CONVERT(VARCHAR,YEAR(d.FechaA))+' '+RIGHT('00'+CONVERT(VARCHAR,DATEPART(HOUR,d.FechaA)),2)+':'+RIGHT('00'+CONVERT(VARCHAR,DATEPART(MINUTE,d.FechaA)),2)+':00',' '),
0, 0, 0,
' ',
ISNULL(d.Situacion,''), ISNULL(d.Observaciones,'')
FROM Campana c WITH (NOLOCK) 
JOIN CampanaD d WITH (NOLOCK) ON c.ID = d.ID 
WHERE c.ID = @IDCampana
UPDATE @AgendaEstacion
SET Nombre = c.Nombre
FROM @AgendaEstacion a
JOIN Cte c WITH (NOLOCK)  ON a.Contacto = c.Cliente 
WHERE ISNULL(a.EnviarA,0) = 0
UPDATE @AgendaEstacion
SET Nombre = e.Nombre
FROM @AgendaEstacion a
JOIN Cte c WITH (NOLOCK)  ON a.Contacto = c.Cliente
JOIN CteEnviarA e WITH (NOLOCK)  ON c.Cliente = e.Cliente AND a.EnviarA = e.ID
WHERE ISNULL(a.EnviarA,0) <> 0
END
COMMIT
SELECT @Texto =(SELECT * FROM @AgendaEstacion AgendaEstacion
FOR XML AUTO,ELEMENTS)
SELECT @TextoCfg      = (SELECT * FROM @HorarioCgf HorarioCgf FOR XML AUTO,ELEMENTS)
SELECT @ReferenciaIS = Referencia
FROM IntelisisService WITH (NOLOCK)  
WHERE ID = @ID
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '>' + CONVERT(varchar(max),ISNULL (@Texto,'')) + CONVERT(varchar(max),ISNULL (@TextoCfg,''))+'</Resultado></Intelisis>'
IF @@ERROR <> 0 SET @Ok = 1
END

