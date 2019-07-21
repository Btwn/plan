SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISeCommerceWebUsuarioDireccion
@ID                     int,
@iSolicitud             int,
@Version                float,
@Resultado              varchar(max) = NULL OUTPUT,
@Ok                     int = NULL OUTPUT,
@OkRef                  varchar(255) = NULL OUTPUT

AS BEGIN
SET nocount ON
DECLARE
@IDUsuario            int,
@Cliente              varchar(10),
@Estatus              varchar(10),
@Empresa              varchar(5),
@Sucursal             int,
@eCommerceSucursal    varchar(10),
@ReferenciaIS         varchar(100),
@Tabla                varchar(max),
@Resultado2           varchar(max)
SELECT @Empresa = Empresa,
@IDUsuario = IDUsuario,
@Cliente = Cliente,
@Sucursal = Sucursal,
@eCommerceSucursal = eCommerceSucursal,
@Estatus = Estatus
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/WebUsuarioEnviarA')
WITH (Empresa varchar(5), IDUsuario int, Sucursal int, eCommerceSucursal  varchar(10), Estatus varchar(10), Cliente varchar(10))
SELECT @ReferenciaIS = Referencia
FROM IntelisisService
WHERE ID = @ID
IF @Estatus IN ('ALTA','CAMBIO')
SELECT @Tabla = '<WebUsuarioEnviarA '+(SELECT  ' ID='+CHAR(34)+ISNULL(CONVERT(varchar,0),'')+CHAR(34)+
' Cliente='+CHAR(34)+ISNULL(Cliente,'')+CHAR(34)+
' Direccion='+CHAR(34)+ISNULL(dbo.fneWebConvertirDescripcionHTML(ISNULL(Direccion,'')),'') +CHAR(34)+
' NoExterior='+CHAR(34)+ISNULL(DireccionNumero,'')+CHAR(34)+
' Direccion2='+CHAR(34)+ISNULL(DireccionNumeroInt,'')+CHAR(34)+
' Pais='+CHAR(34)+ISNULL(Pais,'')+CHAR(34)+
' Estado='+CHAR(34)+ISNULL(Estado,'')+CHAR(34)+
' Ciudad='+CHAR(34)+ISNULL(Poblacion,'')+CHAR(34)+
' eMail='+CHAR(34)+ISNULL(eMail1,'')+CHAR(34)+
' Nombre='+CHAR(34)+ISNULL(Nombre,'')+CHAR(34)+
' Telefono='+CHAR(34)+ISNULL(Telefonos,'')+CHAR(34)+
' Delegacion='+CHAR(34)+ISNULL(Delegacion,'')+CHAR(34)+
' Colonia='+CHAR(34)+ISNULL(Colonia,'')+CHAR(34)+
' CP='+CHAR(34)+ISNULL(CodigoPostal,'')+CHAR(34)+
' UsuarioID='+CHAR(34)+ISNULL(CONVERT(varchar,@IDUsuario),'')+CHAR(34)
FROM Cte WHERE Cliente = @Cliente)+' />'
ELSE   SELECT @Tabla = ''
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia="WebUsuario" Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) +' Empresa=' + CHAR(34) + ISNULL(@Empresa,'') + CHAR(34)+ ' Sucursal=' + CHAR(34) + ISNULL(CONVERT(varchar,@Sucursal),'') + CHAR(34)+' eCommerceSucursal=' + CHAR(34) + ISNULL(@eCommerceSucursal,'') + CHAR(34)+ ' Estatus=' + CHAR(34) + ISNULL(@Estatus,'') + CHAR(34) +' IDUsuario=' + CHAR(34) + CONVERT(varchar,ISNULL(@IDUsuario,'')) + CHAR(34)+' Cliente=' + CHAR(34) + CONVERT(varchar,ISNULL(@Cliente,'')) + CHAR(34) +' >' +ISNULL(@Tabla,'')+'</Resultado></Intelisis>'
END

