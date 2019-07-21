SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speCommerceWebUsuarioClienteEnviarA
@ID                    int,
@iSolicitud            int,
@Solicitud             varchar(max),
@Version               float,
@Resultado             varchar(max) = NULL OUTPUT,
@Ok                    int = NULL OUTPUT,
@OkRef                 varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa       varchar(5),
@Sucursal      int,
@ReferenciaIS  varchar(100),
@SubReferencia varchar(100),
@Cliente       varchar(10),
@IDEnviar      int,
@GUID          varchar(50),
@GUIDUsuario   varchar(50),
@UsuarioID     int,
@IDEnviarA     int
DECLARE @Direccion table(Cliente    varchar(10),
Direccion1 varchar(255),
Direccion2 varchar(255),
Ciudad     varchar(100),
Pais       varchar(100),
Estado     varchar(100),
ID         int,
CP         varchar(30),
GUID       varchar(50),
Delegacion varchar(50),
Colonia    varchar(50),
GUIDUsuario varchar(50),
NoExterior varchar(50),
IDEnviarA  int,
Nombre  varchar(100),
Apellido varchar(100),
eMail varchar(250),
Telefono varchar(50) )
BEGIN TRANSACTION
IF @Ok IS NULL
BEGIN
IF @Ok IS NULL
SELECT @ReferenciaIS = Referencia, @SubReferencia = SubReferencia
FROM IntelisisService WITH(NOLOCK)
 WHERE ID = @ID
SELECT   @GUID = GUID, @UsuarioID = UsuarioID, @GUIDUsuario = GUIDUsuario, @IDEnviarA =ISNULL(NULLIF(ID,''),-1)
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/Direccion',1)
WITH (GUID varchar(50),GUIDUsuario varchar(50), UsuarioID int, ID int)
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @Solicitud
INSERT @Direccion(Cliente,Direccion1, Direccion2, Ciudad, Pais , Estado, CP ,ID , GUID, Delegacion , NoExterior, Colonia ,GUIDUsuario, IDEnviarA, Nombre, Apellido, eMail, Telefono)
SELECT            Cliente,Direccion1 , Direccion2, Ciudad, Pais , Estado, CP,UsuarioID, GUID , Delegacion , NoExterior, Colonia , GUIDUsuario, ISNULL(NULLIF(ID,''),-1),Nombre, Apellido, eMail, Telefono
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/Direccion',1)
WITH (Direccion1 varchar(255), Direccion2 varchar(255),Ciudad varchar(100),Pais varchar(100),Estado varchar(100),CP varchar(30),Cliente varchar(10),UsuarioID int, GUID varchar(50),Delegacion varchar(50), Colonia    varchar(50), NoExterior varchar(50),GUIDUsuario varchar(50), ID int,Nombre varchar(100), Apellido varchar(100), eMail varchar(250), Telefono  varchar(50))
EXEC sp_xml_removedocument @iSolicitud
IF @@ERROR<>0 SET @Ok = 1
SELECT @Cliente = NULLIF(Cliente,'') FROM WebUsuarios WITH(NOLOCK) WHERE GUID = @GUIDUsuario
IF NOT EXISTS(SELECT * FROM Cte WITH(NOLOCK) WHERE Cliente = @Cliente) SET @Ok = 10040
IF @IDEnviarA <> 0
BEGIN
IF @Ok IS NULL AND NOT EXISTS(SELECT * FROM CteEnviarA WITH(NOLOCK) WHERE GUID = @GUID AND Cliente = @Cliente )
BEGIN
SELECT @IDEnviar =  MAX(ID) FROM CteEnviarA WITH(NOLOCK) WHERE Cliente = @Cliente
SELECT @IDEnviar = ISNULL(@IDEnviar,0)+1
IF @IDEnviar IS NOT NULL
INSERT CteEnviarA(ID,        Cliente,  Nombre,                                        Direccion,          DireccionNumeroInt,                                       Pais,     Estado,   Poblacion, CodigoPostal, Estatus, GUID, Delegacion, DireccionNumero, Colonia,eMail1, Telefonos)
SELECT            @IDEnviar, @Cliente,ISNULL(d.Nombre,'')+' '+ISNULL(d.Apellido,''), ISNULL(d.Direccion1,''), ISNULL(d.Direccion2,''), d.Pais, d.Estado, d.Ciudad,  d.CP,         'ALTA', d.GUID, d.Delegacion, d.NoExterior, d.Colonia,d.eMail,d.Telefono
FROM @Direccion d /*JOIN WebPais p  WITH(NOLOCK) ON d.Pais = p.ID
JOIN WebPaisEstado e  WITH(NOLOCK) ON  e.IDPais = p.ID AND e.ID = d.Estado */
JOIN WebUsuarios c  WITH(NOLOCK) ON d.GUIDUsuario = c.GUID
IF @@ERROR<>0 SET @Ok = 1
END
IF EXISTS(SELECT * FROM CteEnviarA WITH(NOLOCK) WHERE Cliente = @Cliente AND GUID = @GUID)
BEGIN
SELECT @IDEnviar = ID FROM CteEnviarA WITH(NOLOCK) WHERE Cliente = @Cliente AND GUID = @GUID
UPDATE CteEnviarA  WITH(ROWLOCK) SET Nombre = ISNULL(d.Nombre,'')+' '+ISNULL(d.Apellido,''), Direccion = ISNULL(d.Direccion1,''), DireccionNumeroInt = ISNULL(d.Direccion2,''), Pais = d.Pais, Estado = d.Estado, Poblacion= d.Ciudad, CodigoPostal=  d.CP, Delegacion = d.Delegacion , DireccionNumero = d.NoExterior , Colonia = d.Colonia, eMail1=d.eMail, Telefonos= d.Telefono
FROM @Direccion d /*JOIN WebPais p  WITH(NOLOCK) ON d.Pais = p.ID
JOIN WebPaisEstado e  WITH(NOLOCK) ON  e.IDPais = p.ID AND e.ID = d.Estado */
LEFT JOIN WebUsuarios c  WITH(NOLOCK) ON 1=1 AND  c.ID = @UsuarioID
JOIN CteEnviarA a  WITH(NOLOCK) ON a.Cliente = @Cliente
WHERE a.Cliente = @Cliente  AND a.GUID = @GUID
END
END
IF  @IDEnviarA = 0
BEGIN
UPDATE Cte  WITH(ROWLOCK) SET  Direccion = ISNULL(d.Direccion1,''), DireccionNumeroInt = ISNULL(d.Direccion2,''), Pais = d.Pais, Estado = d.Estado, Poblacion= d.Ciudad, CodigoPostal=  d.CP, Delegacion = d.Delegacion , DireccionNumero = d.NoExterior , Colonia = d.Colonia, Telefonos = d.Telefono, eMail1 = d.eMail
FROM @Direccion d /*JOIN WebPais p  WITH(NOLOCK) ON d.Pais = p.ID
JOIN WebPaisEstado e  WITH(NOLOCK) ON  e.IDPais = p.ID AND e.ID = d.Estado */
JOIN Cte a  WITH(NOLOCK) ON a.Cliente = @Cliente
LEFT JOIN WebUsuarios c  WITH(NOLOCK) ON 1=1 AND  c.ID = @UsuarioID
WHERE a.Cliente = @Cliente
UPDATE WebUsuarios  WITH(ROWLOCK) SET  eMail = eMail WHERE Cliente = @Cliente
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT @OkRef = 'ERROR: ' + CONVERT(varchar,@Ok) + (SELECT Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok) +'. ' + ISNULL(@OkRef,'')
END
SET @Resultado = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '>    <Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Cliente=' + CHAR(34) + ISNULL(@Cliente,'') + CHAR(34) + ' EnviarAID='+ CHAR(34) +ISNULL(CONVERT(varchar,@IDEnviar),'')+ CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
END
END

