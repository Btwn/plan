SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpIportal
@Accion           Varchar(40) = '',
@Sitio			Varchar(20) = '',
@SesionID			Varchar(50) = '',
@UsuarioWeb		Varchar(50) = '',
@Pagina			Varchar(20) = '',
@Dia				Varchar(20) = '',
@Origen			Varchar(40) = ''
AS BEGIN
DECLARE
@ID              VARCHAR(10),
@Nombre_Temp            Varchar(250),
@Descripcion_Temp       Varchar(250),
@Html_Temp              Varchar(3500),
@Url_Temp               Varchar(250)
IF @Accion = 'GUID'
BEGIN
SELECT NEWID()
AS 'GUID'
END
IF @Accion = 'LOGIN'
BEGIN
SELECT * FROM WebUsuario
Where Estatus='ALTA'
and UPPER(UsuarioWeb) = UPPER(@UsuarioWeb) and (UPPER(Contrasena) = @Origen or Contrasena = @Origen OR UPPER(Contrasena) = UPPER(@Dia))
END
IF @Accion = 'ENCABEZADOPIE'
BEGIN
SELECT EncabezadoHTML, PieHTML
FROM    WebSitio
WHERE      Estatus = 'ALTA'
AND Sitio = @Sitio
END
IF @Accion = 'OLVIDOPASSWORD'
BEGIN
SELECT  *
FROM WebSitio
INNER  JOIN WebPagina ON WebSitio.PaginaOlvidoclave = WebPagina.Pagina
WHERE  (WebSitio.Sitio = @Sitio)
AND (WebSitio.Estatus = 'ALTA')
AND (WebPagina.Estatus = 'ALTA')
END
IF @Accion = 'INICIO'
BEGIN
SELECT    *
FROM    WebSitio
WHERE      Estatus = 'ALTA'
AND Sitio = @Sitio
END
IF @Accion = 'MENU'
BEGIN
SELECT  WebSitio.Sitio, WebSitioD.Referencia, WebSitioD.EsGrupo, WebSitioD.MenuPosicion, WebSitioD.Orden,
WebSitioD.Pagina, WebSitioD.Nombre, WebPagina.Descripcion,WebPagina.Tipo, WebPagina.TieneParametros,
WebPagina.ModoVentana, WebPagina.CatalogoRama, WebPagina.CatalogoClasificacion,WebPagina.TipoClasificacion,
WebPagina.CatalogoSP, WebPagina.SP , WebSitio.AnchoMenuEncabezado, WebSitio.AnchoMenuCuerpo,
WebSitio.AnchoMenuPie,
CASE LEN(WebPagina.Icono)
WHEN 0 THEN ''
ELSE WebPagina.Icono
END	AS 'Icono'
FROM  WebSitioD
INNER  JOIN WebPagina ON WebSitioD.Pagina = WebPagina.Pagina
INNER  JOIN WebSitio ON WebSitioD.Sitio = WebSitio.Sitio
INNER  JOIN WebPaginaAcceso ON WebSitioD.Pagina = WebPaginaAcceso.Pagina
WHERE       (WebSitio.Estatus = 'ALTA')
AND (WebSitio.Sitio = @Sitio)
AND (WebPagina.Estatus = 'ALTA')
AND (WebPaginaAcceso.Rol = @UsuarioWeb)
AND (WebPagina.ControlAcceso = 1)
AND (WebSitioD.MenuPosicion<>'')
ORDER  BY WebSitioD.Orden
END
IF @Accion = 'PAGINA'
BEGIN
SELECT  *
FROM  WebSitioD
INNER  JOIN WebPagina ON WebSitioD.Pagina = WebPagina.Pagina
INNER  JOIN WebPaginaAcceso ON WebSitioD.Pagina = WebPaginaAcceso.Pagina
INNER  JOIN WebSitio ON WebSitioD.Sitio = WebSitio.Sitio
WHERE       (WebSitioD.Sitio = @Sitio)
AND (WebPaginaAcceso.Rol = @UsuarioWeb)
AND (WebSitio.Estatus = 'ALTA')
AND (WebPagina.Estatus = 'ALTA')
AND (WebPagina.Pagina = @Pagina)
END
IF @Accion = 'BLOGCOMENTARIOS'
BEGIN
SELECT WebPaginaBlog.UsuarioWeb, WebPaginaBlog.Comentarios , WebPaginaBlog.Fecha, WebPaginaBlog.URL, WebPaginaBlog.Calificacion
FROM WebPagina
INNER JOIN WebPaginaBlog ON WebPagina.Pagina = WebPaginaBlog.Pagina
WHERE (WebPagina.Pagina = @Pagina)
AND (WebPagina.Estatus = 'ALTA')
AND (WebPagina.Tipo = 'Blog')
ORDER BY WebPaginaBlog.Fecha DESC
END
IF @Accion = 'BLOGCUENTA'
BEGIN
SELECT COUNT(Pagina)
FROM WebPaginaBlog
WHERE Pagina = @Pagina
END
IF @Accion = 'CALENDARIO'
BEGIN
SELECT WebPaginaCalendario.RID, WebPaginaCalendario.Asunto, WebPaginaCalendario.Ubicacion,
dbo.fnFormatDateTime(WebPaginaCalendario.Comienzo, 'MM/DD/YYYY') + ' ' + dbo.fnFormatDateTime(WebPaginaCalendario.Comienzo, 'HH:MM 24') as Comienzo,
dbo.fnFormatDateTime(WebPaginaCalendario.Fin, 'MM/DD/YYYY') + ' ' + dbo.fnFormatDateTime(WebPaginaCalendario.Fin, 'HH:MM 24') as Fin,
WebPaginaCalendario.TodoElDia,
WebPaginaCalendario.Comentarios, WebPaginaTipoEvento.Numero as TipoCita,
WebPaginaCalendario.TipoEvento, WebPaginaTipoEvento.Color
FROM WebPaginaTipoEvento INNER JOIN WebPaginaCalendario ON WebPaginaTipoEvento.Tipo = WebPaginaCalendario.TipoEvento
WHERE Pagina = @Pagina
END
IF @Accion = 'HORAS'
BEGIN
SELECT Asunto, Ubicacion,
dbo.fnFormatDateTime(Comienzo, 'DD/MM/YYYY') as Comienzo,
dbo.fnFormatDateTime(Comienzo, 'HH:MM 24') as Hora_Comienzo,
dbo.fnFormatDateTime(Fin, 'DD/MM/YYYY') as Fin,
dbo.fnFormatDateTime(Fin, 'HH:MM 24') as Hora_Fin,
TodoElDia, Comentarios
FROM WebPaginaCalendario
WHERE Pagina = @Pagina
AND dbo.fnFormatDateTime(Comienzo, 'DD/MM/YYYY')= @Dia
END
IF @Accion = 'VISTA'
BEGIN
SELECT Vista, Datos
FROM WebPaginaVista
WHERE Pagina = @Pagina
END
IF @Accion = 'DOCUMENTOS'
BEGIN
IF (@Origen <> 0)
SELECT  @Pagina AS Pagina, 1 AS Orden, Nombre, Descripcion, Archivo
FROM WebSitioDoc
WHERE  Documento = @Origen
ELSE
SELECT WebPaginaDoc.Pagina, WebPaginaDoc.Orden, WebSitioDoc.Nombre, WebSitioDoc.Descripcion, WebSitioDoc.Archivo
FROM WebPaginaDoc
INNER JOIN WebSitioDoc ON WebPaginaDoc.Documento = WebSitioDoc.Documento
WHERE WebPaginaDoc.PAGINA = @Pagina
ORDER BY WebPaginaDoc.ORDEN
END
IF @Accion = 'METODO'
BEGIN
SELECT 'FUNCIONANDO' AS UNO,'OK' AS DOS
END
IF @Accion = 'BUSQUEDA'
BEGIN
SELECT * FROM WEBPAGINA
WHERE Descripcion LIKE @Dia +'%'
END
IF @Accion = 'WIKIINICIO'
BEGIN
IF @Origen != '0'
BEGIN
SELECT WikiPagina.Pagina, WikiPagina.PaginaID, WikiPagina.Titulo, WikiPagina.FechaModificacion, WikiPagina.Autor, UsuariosWeb.Nombre, WikiPagina.CategoriaID,
WikiCategoria.Descripcion, WikiPagina.Discusiones
FROM WikiPagina AS WikiPagina INNER JOIN
WikiCategoria AS WikiCategoria ON WikiPagina.CategoriaID = WikiCategoria.CategoriaID INNER JOIN
WebUsuario AS UsuariosWeb ON UsuariosWeb.UsuarioWeb = WikiPagina.Autor
WHERE (WikiPagina.CategoriaID = CONVERT(varchar, @Origen)) AND (WikiPagina.Estado = 'ALTA')
END
ELSE
BEGIN
SELECT WikiPagina.Pagina, WikiPagina.PaginaID, WikiPagina.Titulo, WikiPagina.FechaModificacion, WikiPagina.Autor, UsuariosWeb.Nombre, WikiPagina.CategoriaID,
WikiCategoria.Descripcion, WikiPagina.Discusiones
FROM WikiPagina AS WikiPagina INNER JOIN
WikiCategoria AS WikiCategoria ON WikiPagina.CategoriaID = WikiCategoria.CategoriaID INNER JOIN
WebUsuario AS UsuariosWeb ON UsuariosWeb.UsuarioWeb = WikiPagina.Autor
WHERE WikiPagina.Estado = 'ALTA'
END
END
IF @Accion = 'WIKIINFOPAGINA'
BEGIN
IF @Dia='0'
BEGIN
SELECT WikiPagina.PaginaID,  WikiPagina.Titulo,  WikiPagina.Mensaje,  WikiPagina.FechaModificacion,  WikiPagina.Autor,
WebUsuario.Nombre,  WikiPagina.CategoriaID,  WikiCategoria.Descripcion,  WikiPagina.Discusiones
FROM   WikiCategoria INNER JOIN
WikiPagina ON  WikiCategoria.CategoriaID =  WikiPagina.CategoriaID INNER JOIN
WebUsuario ON  WikiPagina.Autor =  WebUsuario.UsuarioWeb
WHERE Pagina=@Pagina and PaginaID=@Origen AND WikiPagina.Estado='ALTA'
END
ELSE
BEGIN
SELECT WikiPaginaHistoria.PaginaID,  WikiPaginaHistoria.Titulo,  WikiPaginaHistoria.Mensaje,  WikiPaginaHistoria.FechaModificacion,  WikiPaginaHistoria.Autor,
WebUsuario.Nombre,  WikiPaginaHistoria.CategoriaID,  WikiCategoria.Descripcion,  WikiPaginaHistoria.Discusiones
FROM   WikiCategoria INNER JOIN
WikiPaginaHistoria ON  WikiCategoria.CategoriaID =  WikiPaginaHistoria.CategoriaID INNER JOIN
WebUsuario ON  WikiPaginaHistoria.Autor =  WebUsuario.UsuarioWeb
WHERE PaginaHistoriaID=@Dia and WikiPaginaHistoria.Estado='ALTA'
END
END
IF @Accion = 'WIKIHISTORIA'
BEGIN
SELECT *
FROM WikiPaginaHistoria
WHERE paginaID= @Origen AND
Pagina = @Pagina
ORDER BY PaginaHistoriaID DESC
END
IF @Accion = 'FOROS'
BEGIN
IF (@Origen='0')
SELECT WebPaginaForo.ID, WebPaginaForo.Pagina, WebPaginaForo.Foro, WebPaginaForo.Descripcion, WebPaginaForo.Temas, WebPaginaForo.Participaciones,
WebPaginaForoComentario.ID AS 'ComentarioID', WebPaginaForoComentario.TemaID, WebPaginaForoComentario.Titulo, WebPaginaForoComentario.Usuario,
WebPaginaForoComentario.Fecha AS 'FechaComentario'
FROM  WebPaginaForoComentario INNER JOIN
WebPaginaForoTema ON WebPaginaForoComentario.TemaID = WebPaginaForoTema.ID RIGHT OUTER JOIN
WebPaginaForo ON WebPaginaForoComentario.ID = WebPaginaForo.ComentarioID
WHERE WebPaginaForo.Estatus = 'ALTA' AND Pagina = @Pagina
ELSE
SELECT WebPaginaForo.ID, WebPaginaForo.Pagina, WebPaginaForo.Foro, WebPaginaForo.Descripcion, WebPaginaForo.Temas, WebPaginaForo.Participaciones,
WebPaginaForoComentario.ID AS 'ComentarioID', WebPaginaForoComentario.TemaID, WebPaginaForoComentario.Titulo, WebPaginaForoComentario.Usuario,
WebPaginaForoComentario.Fecha AS 'FechaComentario'
FROM  WebPaginaForoComentario INNER JOIN
WebPaginaForoTema ON WebPaginaForoComentario.TemaID = WebPaginaForoTema.ID RIGHT OUTER JOIN
WebPaginaForo ON WebPaginaForoComentario.ID = WebPaginaForo.ComentarioID
WHERE WebPaginaForo.Estatus = 'ALTA' AND Pagina = @Pagina
And (FORO LIKE '%' + @Origen + '%' OR Descripcion LIKE '%' + @Origen + '%' )
END
IF @Accion = 'COMENTARIOSPORAPROBAR'
BEGIN
SELECT     WebPaginaForo.ID AS IDForo,   WebPaginaForo.Foro,   WebPaginaForoTema.ID AS IDTema,   WebPaginaForoTema.Titulo AS Tema, COUNT(  WebPaginaForoComentario.ID) AS Comentarios
FROM       WebPagina INNER JOIN
WebPaginaForo ON  WebPagina.Pagina =  WebPaginaForo.Pagina INNER JOIN
WebPaginaForoTema ON  WebPaginaForo.ID =  WebPaginaForoTema.MovID INNER JOIN
WebPaginaForoComentario ON  WebPaginaForoTema.ID =  WebPaginaForoComentario.TemaID INNER JOIN
WebUsuario ON  WebPagina.AdminPagina =  WebUsuario.eMail
WHERE     ( WebPagina.Estatus = 'ALTA') AND ( WebPagina.Pagina = @Pagina) AND ( WebPaginaForo.Estatus = 'ALTA') AND
( WebPaginaForoComentario.Estatus = 'ALTA') AND ( WebPaginaForoComentario.Aprobado = 'False') AND
( WebUsuario.UsuarioWeb = @UsuarioWeb)
GROUP BY   WebPaginaForo.ID,   WebPaginaForo.Foro,   WebPaginaForoTema.ID,   WebPaginaForoTema.Titulo
ORDER BY WebPaginaForo.Foro
END
IF @Accion = 'MULTIPAGINAINFO'
BEGIN
DECLARE @Estatus varchar(20)
SELECT    @Estatus= Estatus FROM WebPagina WHERE Pagina=@Pagina
SELECT    WebPaginaMultiPagina.Pagina, @Estatus AS 'Estatus', (Select max(fila) from WebPaginaMultiPagina where Pagina=@Pagina) as 'NumeroFilas',
WebPaginaMultiPagina.RID, WebPaginaMultiPagina.WebPagina, WebPagina.Nombre,WebPagina.Tipo,
WebPaginaMultiPagina.Fila,  WebPaginaMultiPagina.Columna,   WebPaginaMultiPagina.WebPaginaAlto, WebPaginaMultiPagina.PonerBorde,
WebPaginaMultiPagina.WebPaginaAncho, WebPaginaMultiPagina.VerScroll,WebPaginaMultiPagina.WebPaginaAnchoPorcentaje
FROM      WebPaginaMultiPagina INNER JOIN
WebPagina ON   WebPaginaMultiPagina.WebPagina =   WebPagina.Pagina
WHERE     WebPaginaMultiPagina.Pagina=@Pagina and @Estatus='ALTA' and WebPagina.Estatus='ALTA'
ORDER BY  WebPaginaMultiPagina.Fila,WebPaginaMultiPagina.Columna
END
IF @Accion = 'TEMASPORAPROBAR'
BEGIN
SELECT   WebPaginaForo.ID AS IDForo,   WebPaginaForo.Foro, COUNT(WebPaginaForoTema.ID) as 'Temas'
FROM     WebPagina INNER JOIN
WebPaginaForo ON   WebPagina.Pagina =   WebPaginaForo.Pagina INNER JOIN
WebPaginaForoTema ON   WebPaginaForo.ID =   WebPaginaForoTema.MovID
WHERE    (WebPagina.Pagina = @Pagina) AND (WebPagina.Estatus = 'ALTA') AND (  WebPaginaForo.Estatus = 'ALTA') and WebPaginaForoTema.Aprobado='False'
GROUP BY  WebPaginaForo.ID,   WebPaginaForo.Foro
END
IF @Accion = 'USUARIOINFO'
BEGIN
SELECT   *
FROM     WebUsuario
WHERE    (WebUsuario.Estatus = 'ALTA') AND (  WebUsuario.UsuarioWeb=@UsuarioWeb)
END
IF @Accion = 'PORAPROBAR_PORUSUARIO'
BEGIN
SELECT     WebPagina.pagina,WebPaginaForo.ID AS IDForo,   WebPaginaForo.Foro,   WebPaginaForoTema.ID AS IDTema,   WebPaginaForoTema.Titulo AS Tema, COUNT(  WebPaginaForoComentario.ID) AS Comentarios
FROM       WebPagina INNER JOIN
WebPaginaForo ON  WebPagina.Pagina =  WebPaginaForo.Pagina INNER JOIN
WebPaginaForoTema ON  WebPaginaForo.ID =  WebPaginaForoTema.MovID INNER JOIN
WebPaginaForoComentario ON  WebPaginaForoTema.ID =  WebPaginaForoComentario.TemaID INNER JOIN
WebUsuario ON  WebPagina.AdminPagina =  WebUsuario.eMail
WHERE     ( WebPagina.Estatus = 'ALTA')  AND ( WebPaginaForo.Estatus = 'ALTA') AND
( WebPaginaForoComentario.Estatus = 'ALTA') AND ( WebPaginaForoComentario.Aprobado = 'False') AND ( WebUsuario.UsuarioWeb = @UsuarioWeb)
GROUP BY   WebPagina.pagina,WebPaginaForo.ID,   WebPaginaForo.Foro,   WebPaginaForoTema.ID,   WebPaginaForoTema.Titulo
ORDER BY WebPaginaForo.Foro
END
RETURN
END

