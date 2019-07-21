SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisSLHQ
@Licencia	varchar(50),
@Fecha126	varchar(50),
@Usuario	varchar(255),
@NT_Equipo	varchar(255),
@NT_Dominio	varchar(255),
@NT_IP	varchar(20),
@XMLEnLista	bit = 0

AS BEGIN
DECLARE
@Fecha		datetime,
@Ok  		int,
@OkDesc		varchar(255),
@OkRef		varchar(255),
@Cliente		varchar(10),
@ClienteNombre	varchar(255),
@Dominio		varchar(100),
@Nombre		varchar(255),
@Observaciones	varchar(255),
@Fabricacion	datetime,
@Vencimiento	datetime,
@Mantenimiento	datetime,
@Tipo		varchar(20),
@CantidadTotal	int,
@Firma		varchar(40),
@Estatus            varchar(15),
@Usuarios		varchar(8000)
SELECT @Ok = NULL, @OkDesc = NULL, @OkRef = NULL, @Nombre = NULL, @Observaciones = NULL, @Cliente = NULL,
@ClienteNombre = NULL, @Firma = NULL, @Dominio = NULL, @Vencimiento = NULL, @CantidadTotal = 0, @Usuarios = NULL,
@Fecha = CONVERT(datetime, @Fecha126, 126)
SELECT @Cliente = sl.Cliente,
@ClienteNombre = c.Nombre,
@Nombre = sl.Nombre,
@Observaciones = sl.Observaciones,
@Mantenimiento = sl.Mantenimiento,
@Vencimiento = sl.Vencimiento,
@Fabricacion = sl.Fabricacion,
@Tipo = sl.Tipo,
@Estatus = sl.Estatus,
@Firma = sl.Firma,
@Dominio = sl.Dominio
FROM IntelisisSL sl
JOIN Cte c ON c.Cliente = sl.Cliente
WHERE sl.Licencia = @Licencia
IF @@ROWCOUNT = 0 OR @Estatus IS NULL SELECT @Ok = 9010 ELSE
IF @Estatus = 'BLOQUEADO' SELECT @Ok = 9020 ELSE
IF @Estatus <> 'ALTA' SELECT @Ok = 9030
IF @Ok IS NULL
BEGIN
UPDATE IntelisisSL  SET TieneMovimientos = 1 WHERE Licencia = @Licencia AND TieneMovimientos = 0
UPDATE IntelisisSLD SET TieneMovimientos = 1 WHERE Licencia = @Licencia AND TieneMovimientos = 0
SELECT @Usuarios = (SELECT Licenciamiento, Cantidad FROM IntelisisSLD WHERE Licencia = @Licencia AND Estatus = 'ALTA' FOR XML RAW ('Acceso'), ROOT ('Usuarios'))
SELECT @CantidadTotal = SUM(Cantidad) FROM IntelisisSLD WHERE Licencia = @Licencia AND Estatus = 'ALTA'
END
IF @Ok IS NOT NULL
BEGIN
SELECT @OkDesc = Descripcion
FROM MensajeLista
WHERE Mensaje = @Ok
IF @OkRef IS NULL SELECT @OkRef = @Licencia
END
INSERT IntelisisSLLog
(Licencia,  Fecha,  Usuario,  Equipo,     Dominio,     IP,     Ok,  OkRef)
VALUES (@Licencia, @Fecha, @Usuario, @NT_Equipo, @NT_Dominio, @NT_IP, @Ok, @OkRef)
IF @XMLEnLista = 1
BEGIN
CREATE TABLE #Resultado (ID int IDENTITY(1,1) NOT NULL PRIMARY KEY, Valor varchar(255) COLLATE Database_Default NULL)
INSERT #Resultado (Valor) SELECT '<?xml version="1.0" encoding="windows-1252"?>'
INSERT #Resultado (Valor) SELECT '<Intelisis Contenido="Licencia">'
INSERT #Resultado (Valor) SELECT '<Licencia>'
INSERT #Resultado (Valor) SELECT '<Licencia>'+@Licencia+'</Licencia>'
INSERT #Resultado (Valor) SELECT '<Nombre>'+ISNULL(@Nombre, '')+'</Nombre>'
INSERT #Resultado (Valor) SELECT '<Observaciones>'+ISNULL(@Observaciones, '')+'</Observaciones>'
INSERT #Resultado (Valor) SELECT '<Cliente>'+ISNULL(@Cliente, '')+'</Cliente>'
INSERT #Resultado (Valor) SELECT '<ClienteNombre>'+ISNULL(@ClienteNombre, '')+'</ClienteNombre>'
INSERT #Resultado (Valor) SELECT '<Dominio>'+ISNULL(@Dominio, '')+'</Dominio>'
INSERT #Resultado (Valor) SELECT '<FechaSolicitud>'+ISNULL(@Fecha126, '')+'</FechaSolicitud>'
INSERT #Resultado (Valor) SELECT '<Fabricacion>'+ISNULL(CONVERT(varchar, @Fabricacion, 126), '')+'</Fabricacion>'
INSERT #Resultado (Valor) SELECT '<Vencimiento>'+ISNULL(CONVERT(varchar, @Vencimiento, 126), '')+'</Vencimiento>'
INSERT #Resultado (Valor) SELECT '<Mantenimiento>'+ISNULL(CONVERT(varchar, @Mantenimiento, 126), '')+'</Mantenimiento>'
INSERT #Resultado (Valor) SELECT '<Tipo>'+ISNULL(@Tipo, '')+'</Tipo>'
INSERT #Resultado (Valor) SELECT ISNULL(@Usuarios, '')
INSERT #Resultado (Valor) SELECT '<Firma>'+ISNULL(@Firma, '')+'</Firma>'
INSERT #Resultado (Valor) SELECT '<Version>1.1</Version>'
INSERT #Resultado (Valor) SELECT '</Licencia>'
IF @Ok IS NOT NULL
BEGIN
INSERT #Resultado (Valor) SELECT '<Mensaje>'
INSERT #Resultado (Valor) SELECT '<Ok>'+CONVERT(varchar, @Ok)+'</Ok>'
INSERT #Resultado (Valor) SELECT '<OkDesc>'+ISNULL(@OkDesc, '')+'</OkDesc>'
INSERT #Resultado (Valor) SELECT '<OkRef>'+ISNULL(@OkRef, '')+'</OkRef>'
INSERT #Resultado (Valor) SELECT '</Mensaje>'
END
INSERT #Resultado (Valor) SELECT '<LicenciaLlave></LicenciaLlave>'
INSERT #Resultado (Valor) SELECT '</Intelisis>'
SELECT Valor FROM #Resultado ORDER BY ID
DROP TABLE #Resultado
END ELSE
SELECT "Ok" = @Ok, "OkDesc" = @OkDesc, "OkRef" = @OkRef,
"Nombre" = @Nombre, "Observaciones" = @Observaciones,
"Cliente" = @Cliente, "ClienteNombre" = @ClienteNombre,
"Fabricacion" = @Fabricacion, "Vencimiento" = @Vencimiento, "Mantenimiento" = @Mantenimiento, "Tipo" = @Tipo,
"Firma" = REPLACE(@Firma, '-', ''), "CantidadTotal" = @CantidadTotal,
"XML" = @Usuarios
RETURN
END

