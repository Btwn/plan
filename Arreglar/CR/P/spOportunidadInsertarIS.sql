SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOportunidadInsertarIS
@Empresa					varchar(5),
@Usuario					varchar(10),
@ContactoTipo				varchar(20),
@Contacto					varchar(10),
@ModuloID					int,
@FechaRegistro				datetime,
@Para						varchar(max),
@Asunto						varchar(255),
@Mensaje					varchar(max),
@Anexos						varchar(max),
@Ok							int			 OUTPUT,
@OkRef						varchar(255) OUTPUT

AS BEGIN
DECLARE
@Solicitud				varchar(max),
@FechaXML					varchar(50),
@ModuloIDXML				varchar(20),
@Contrasena				varchar(32),
@Resultado				varchar(max),
@IntelisisServiceID		int,
@ParaXML					varchar(max),
@AsuntoXML				varchar(255),
@MensajeXML				varchar(max),
@AnexosXML				varchar(max)
SELECT @Contrasena = Contrasena FROM Usuario WHERE Usuario = @Usuario
SET @FechaRegistro = dbo.fnFechaSinHora(GETDATE())
SET @ModuloIDXML = LTRIM(RTRIM(CONVERT(varchar,ISNULL(@ModuloID,0))))
SET @ParaXML = dbo.fneDocXMLAUTF8(ISNULL(@Para,''),0,1)
SET @AsuntoXML = dbo.fneDocXMLAUTF8(ISNULL(@Asunto,''),0,1)
SET @FechaXML = RTRIM(CONVERT(varchar,@FechaRegistro,126))
SET @MensajeXML = dbo.fneDocXMLAUTF8(ISNULL(@Mensaje,''),0,1)
SET @AnexosXML = dbo.fneDocXMLAUTF8(ISNULL(@Anexos,''),0,1)
SET @Solicitud = '<Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.Oportunidad" Version="1.0">' +
'  <Solicitud>' +
'    <Oportunidad ContactoTipo = "' + @ContactoTipo + '" Contacto = "' + @Contacto + '" Usuario = "' + @Usuario + '" Empresa = "' + @Empresa + '" Fecha="' + @FechaXML  + '" Para="' + @ParaXML + '" Asunto="' + @AsuntoXML + '" Mensaje="' + @MensajeXML + '" ModuloID="' + @ModuloIDXML + '" Anexos="' + @AnexosXML +'" />' +
'  </Solicitud>' +
'</Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Solicitud, @Resultado OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, 1, 0, @IntelisisServiceID OUTPUT
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
BEGIN
INSERT OportunidadeMailHist (Fecha,     IntelisisServiceID,  Empresa,  ModuloID,  Asunto,  Mensaje,  Para,  Anexos,   ContactoTipo,  Contacto)
VALUES (GETDATE(), @IntelisisServiceID, @Empresa, @ModuloID, @Asunto, @Mensaje, @Para, @Anexos, @ContactoTipo, @Contacto)
IF @@ERROR <> 0 SELECT @Ok = 1, @OkRef = 'OportunidadeMailHist'
END
END

