SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [SPWebPaginaComunidad]
@Accion			VARCHAR(25)= null,
@Pagina			VARCHAR(20) = null,
@ID				VARCHAR(255) = null,
@RamaID			VARCHAR(255) = null,
@Usuario			VARCHAR(255) = null,
@Correo			VARCHAR(100) = null,
@Tipo			VARCHAR(20) = null,
@Descripcion		VARCHAR(2000)= null,
@HTML			VARCHAR(Max) = null,
@URL				VARCHAR(300)= null,
@Sitio			VARCHAR(250) = null ,
@Categoria		VARCHAR(250) = null ,
@valor			VARCHAR(10)= null ,
@TipoDoc			VARCHAR(15)= null ,
@HistoricoID		VARCHAR(255) = null ,
@Nivel			int = 1

AS BEGIN
Declare
@Propietario				Varchar(100),
@Autorizado					Bit,
@Notificar					BIT,
@TituloComentario			VARCHAR(20),
@VerHistoria				BIT,
@TemValor					NUMERIC,
@TemValor2					NUMERIC,
@TemValor3					NUMERIC	,
@ArticuloID					int
IF @Accion = 'CONSULTA1'
BEGIN
PRINT @TipoDoc
IF EXISTS(SELECT AdminPagina FROM WebPagina WHERE Pagina = @Pagina AND AdminPagina = @Usuario)
IF UPPER(@TipoDoc)='WIKI'
BEGIN
SELECT dbo.WebArticulo.*,CONVERT(int, Calificacion) AS 'Calificacion1', CASE Autorizado WHEN 1 THEN 0 ELSE 1 END AS VerAutorizados, 'No. Discuciones:' AS 'lblTituloComentario', 1 AS 'VerHistoria', CASE Autorizado WHEN 1 THEN 'App_Themes/FORO/AUTORIZAR-BN.gif' ELSE 'App_Themes/FORO/AUTORIZAR2.gif' END AS 'ImagenAutorizado', dbo.WebUsuario.Foto
FROM   dbo.WebArticulo LEFT OUTER JOIN dbo.WebUsuario ON dbo.WebArticulo.Usuario = dbo.WebUsuario.UsuarioWeb
WHERE  (dbo.WebArticulo.Pagina = @Pagina) AND (dbo.WebArticulo.RamaID IS NULL) AND (dbo.WebArticulo.Tipo = @Tipo) AND (dbo.WebArticulo.HistoricoID IS NOT NULL) AND (dbo.WebArticulo.ID IN
(SELECT     MAX(ID) AS Expr1 FROM dbo.WebArticulo AS WebArticulo_1 GROUP BY HistoricoID))
ORDER BY dbo.WebArticulo.FechaHora DESC
END
ELSE
BEGIN
SELECT WebArticulo.*, CONVERT(int, Calificacion) AS 'Calificacion1',CASE Autorizado WHEN 1 THEN 0 ELSE 1 END AS VerAutorizados, 'No. Comentarios:' AS 'lblTituloComentario', 0 AS 'VerHistoria', CASE Autorizado WHEN 1 THEN 'App_Themes/FORO/AUTORIZAR-BN.gif' ELSE 'App_Themes/FORO/AUTORIZAR2.gif' END AS 'ImagenAutorizado', dbo.WebUsuario.Foto
FROM  dbo.WebArticulo LEFT OUTER JOIN dbo.WebUsuario ON dbo.WebArticulo.Usuario = dbo.WebUsuario.UsuarioWeb
WHERE (dbo.WebArticulo.Pagina = @Pagina) AND (dbo.WebArticulo.RamaID IS NULL) AND (dbo.WebArticulo.Tipo = @Tipo)
ORDER BY dbo.WebArticulo.FechaHora DESC
END
ELSE
IF UPPER(@TipoDoc)='WIKI'
BEGIN
SELECT dbo.WebArticulo.*, CONVERT(int, Calificacion) AS 'Calificacion1',CASE Autorizado WHEN 1 THEN 0 ELSE 1 END AS VerAutorizados, 'No. Discuciones:' AS 'lblTituloComentario', 1 AS 'VerHistoria', CASE Autorizado WHEN 1 THEN 'App_Themes/FORO/AUTORIZAR-BN.gif' ELSE 'App_Themes/FORO/AUTORIZAR2.gif' END AS 'ImagenAutorizado', dbo.WebUsuario.Foto
FROM         dbo.WebArticulo LEFT OUTER JOIN dbo.WebUsuario ON dbo.WebArticulo.Usuario = dbo.WebUsuario.UsuarioWeb
WHERE     (dbo.WebArticulo.Pagina = @Pagina) AND (dbo.WebArticulo.RamaID IS NULL) AND (dbo.WebArticulo.Tipo = @Tipo) AND (dbo.WebArticulo.Autorizado = 1) AND (dbo.WebArticulo.HistoricoID IS NOT NULL) AND (dbo.WebArticulo.ID IN (SELECT     MAX(ID) AS Expr1 FROM          dbo.WebArticulo AS WebArticulo_1 GROUP BY HistoricoID))
ORDER BY dbo.WebArticulo.FechaHora DESC
END
ELSE
BEGIN
SELECT dbo.WebArticulo.*, CONVERT(int, Calificacion) AS 'Calificacion1',CASE Autorizado WHEN 1 THEN 0 ELSE 1 END AS VerAutorizados, 'No. Comentarios:' AS 'lblTituloComentario', 0 AS 'VerHistoria', CASE Autorizado WHEN 1 THEN 'App_Themes/FORO/AUTORIZAR-BN.gif' ELSE 'App_Themes/FORO/AUTORIZAR2.gif' END AS 'ImagenAutorizado', dbo.WebUsuario.Foto
FROM         dbo.WebArticulo LEFT OUTER JOIN dbo.WebUsuario ON dbo.WebArticulo.Usuario = dbo.WebUsuario.UsuarioWeb
WHERE     (dbo.WebArticulo.Pagina = @Pagina) AND (dbo.WebArticulo.RamaID IS NULL) AND (dbo.WebArticulo.Tipo = @Tipo) AND (dbo.WebArticulo.Autorizado = 1)
ORDER BY dbo.WebArticulo.FechaHora DESC
end
END
IF @Accion = 'CONSULTA2'
BEGIN
IF UPPER(@TipoDoc)='WIKI'
begin
SET @TituloComentario= 'No. Discuciones:'
SET @VerHistoria=1
end
ELSE
begin
SET @TituloComentario= 'No. Comentarios:'
SET @VerHistoria=0
end
IF EXISTS(SELECT AdminPagina FROM WebPagina WHERE Pagina = @Pagina AND AdminPagina = @Usuario)
SELECT dbo.WebArticulo.*, CONVERT(int, Calificacion) AS 'Calificacion1', CASE Autorizado WHEN 1 THEN 0 ELSE 1 END AS VerAutorizados, @TituloComentario AS 'lblTituloComentario', @VerHistoria AS 'VerHistoria', CASE Autorizado WHEN 1 THEN 'App_Themes/FORO/AUTORIZAR-BN.gif' ELSE 'App_Themes/FORO/AUTORIZAR2.gif' END AS 'ImagenAutorizado', dbo.WebUsuario.Foto, 0 AS 'ArticuloPagado'
FROM         dbo.WebArticulo LEFT OUTER JOIN dbo.WebUsuario ON dbo.WebArticulo.Usuario = dbo.WebUsuario.UsuarioWeb
WHERE     (dbo.WebArticulo.Pagina = @Pagina) AND (dbo.WebArticulo.Tipo = @Tipo) AND (dbo.WebArticulo.ID = @ID )
ORDER BY dbo.WebArticulo.FechaHora ASC
ELSE
SELECT dbo.WebArticulo.*, CONVERT(int, Calificacion) AS 'Calificacion1', CASE Autorizado WHEN 1 THEN 0 ELSE 1 END AS VerAutorizados, @TituloComentario AS 'lblTituloComentario', @VerHistoria AS 'VerHistoria', CASE Autorizado WHEN 1 THEN 'App_Themes/FORO/AUTORIZAR-BN.gif' ELSE 'App_Themes/FORO/AUTORIZAR2.gif' END AS 'ImagenAutorizado', dbo.WebUsuario.Foto, 0 AS 'ArticuloPagado'
FROM dbo.WebArticulo LEFT OUTER JOIN dbo.WebUsuario ON dbo.WebArticulo.Usuario = dbo.WebUsuario.UsuarioWeb
WHERE (dbo.WebArticulo.Pagina = @Pagina) AND (dbo.WebArticulo.Tipo = @Tipo) AND (dbo.WebArticulo.ID = @ID) AND (dbo.WebArticulo.Autorizado = 1)
ORDER BY dbo.WebArticulo.FechaHora ASC
END
IF @Accion = 'CONSULTA3'
BEGIN
IF UPPER(@TipoDoc)='WIKI'
begin
SET @TituloComentario= 'No. Discuciones:'
SET @VerHistoria=1
end
ELSE
begin
SET @TituloComentario= 'No. Comentarios:'
SET @VerHistoria=0
end
IF UPPER(@TipoDoc)='EXPERTS'
IF EXISTS(SELECT AdminPagina FROM WebPagina WHERE Pagina = @Pagina AND AdminPagina = @Usuario)
SELECT  1 AS 'uno',dbo.WebArticulo.*, CONVERT(int, Calificacion) AS 'Calificacion1', CASE Tipo WHEN 'Comentario' THEN 0 WHEN 'Discucion' THEN 0 ELSE 1 END AS VisibleArticulo, CASE Autorizado WHEN 1 THEN 0 ELSE 1 END AS VerAutorizados, CASE Pagado WHEN 1 THEN 0 ELSE 1 END AS 'ArticuloPagado', dbo.WebArticulo.ItemPagado AS Expr1, @TituloComentario AS 'lblTituloComentario', @VerHistoria AS 'VerHistoria', CASE Autorizado WHEN 1 THEN 'App_Themes/FORO/AUTORIZAR-BN.gif' ELSE 'App_Themes/FORO/AUTORIZAR2.gif' END AS 'ImagenAutorizado', dbo.WebUsuario.Foto
FROM         dbo.WebArticulo LEFT OUTER JOIN dbo.WebUsuario ON dbo.WebArticulo.Usuario = dbo.WebUsuario.UsuarioWeb
WHERE     (dbo.WebArticulo.Pagina = @Pagina) AND (dbo.WebArticulo.RamaID = @ID)
ORDER BY dbo.WebArticulo.FechaHora DESC
ELSE
SELECT  2 AS 'dos',dbo.WebArticulo.*, CONVERT(int, Calificacion) AS 'Calificacion1', CASE Tipo WHEN 'Comentario' THEN 0 WHEN 'Discucion' THEN 0 ELSE 1 END AS VisibleArticulo, CASE Autorizado WHEN 1 THEN 0 ELSE 1 END AS VerAutorizados, CASE Pagado WHEN 1 THEN 0 ELSE 1 END AS 'ArticuloPagado', dbo.WebArticulo.ItemPagado AS Expr1, @TituloComentario AS 'lblTituloComentario', @VerHistoria AS 'VerHistoria', CASE Autorizado WHEN 1 THEN 'App_Themes/FORO/AUTORIZAR-BN.gif' ELSE 'App_Themes/FORO/AUTORIZAR2.gif' END AS 'ImagenAutorizado', dbo.WebUsuario.Foto
FROM         dbo.WebArticulo LEFT OUTER JOIN dbo.WebUsuario ON dbo.WebArticulo.Usuario = dbo.WebUsuario.UsuarioWeb
WHERE     (dbo.WebArticulo.Pagina = @Pagina) AND (dbo.WebArticulo.RamaID = @ID) AND (Autorizado = 1 )
ORDER BY dbo.WebArticulo.FechaHora DESC
ELSE
IF EXISTS(SELECT AdminPagina FROM WebPagina WHERE Pagina = @Pagina AND AdminPagina = @Usuario)
begin
IF UPPER(@TipoDoc)='FORO' AND @Nivel=2
begin
SELECT  1 AS 'uno',dbo.WebArticulo.*, CONVERT(int, Calificacion) AS 'Calificacion1', CASE Tipo WHEN 'Comentario' THEN 0 WHEN 'Discucion' THEN 0 ELSE 1 END AS VisibleArticulo, CASE Autorizado WHEN 1 THEN 0 ELSE 1 END AS VerAutorizados, 0 AS 'ArticuloPagado', dbo.WebArticulo.ItemPagado AS Expr1, @TituloComentario AS 'lblTituloComentario', @VerHistoria AS 'VerHistoria', CASE Autorizado WHEN 1 THEN 'App_Themes/FORO/AUTORIZAR-BN.gif' ELSE 'App_Themes/FORO/AUTORIZAR2.gif' END AS 'ImagenAutorizado', dbo.WebUsuario.Foto
FROM         dbo.WebArticulo LEFT OUTER JOIN dbo.WebUsuario ON dbo.WebArticulo.Usuario = dbo.WebUsuario.UsuarioWeb
WHERE     (dbo.WebArticulo.Pagina = @Pagina) AND (dbo.WebArticulo.RamaID = @ID)
ORDER BY dbo.WebArticulo.FechaHora DESC
end
ELSE
SELECT  1 AS 'uno',dbo.WebArticulo.*, CONVERT(int, Calificacion) AS 'Calificacion1', CASE Tipo WHEN 'Comentario' THEN 0 WHEN 'Discucion' THEN 0 ELSE 1 END AS VisibleArticulo, CASE Autorizado WHEN 1 THEN 0 ELSE 1 END AS VerAutorizados, 0 AS 'ArticuloPagado', dbo.WebArticulo.ItemPagado AS Expr1, @TituloComentario AS 'lblTituloComentario', @VerHistoria AS 'VerHistoria', CASE Autorizado WHEN 1 THEN 'App_Themes/FORO/AUTORIZAR-BN.gif' ELSE 'App_Themes/FORO/AUTORIZAR2.gif' END AS 'ImagenAutorizado', dbo.WebUsuario.Foto
FROM         dbo.WebArticulo LEFT OUTER JOIN dbo.WebUsuario ON dbo.WebArticulo.Usuario = dbo.WebUsuario.UsuarioWeb
WHERE     (dbo.WebArticulo.Pagina = @Pagina) AND (dbo.WebArticulo.RamaID = @ID)
ORDER BY dbo.WebArticulo.FechaHora ASC
end
ELSE
IF UPPER(@TipoDoc)='FORO' AND @Nivel=2
begin
SELECT  1 AS 'uno',dbo.WebArticulo.*, CONVERT(int, Calificacion) AS 'Calificacion1', CASE Tipo WHEN 'Comentario' THEN 0 WHEN 'Discucion' THEN 0 ELSE 1 END AS VisibleArticulo, CASE Autorizado WHEN 1 THEN 0 ELSE 1 END AS VerAutorizados, 0 AS 'ArticuloPagado', dbo.WebArticulo.ItemPagado AS Expr1, @TituloComentario AS 'lblTituloComentario', @VerHistoria AS 'VerHistoria', CASE Autorizado WHEN 1 THEN 'App_Themes/FORO/AUTORIZAR-BN.gif' ELSE 'App_Themes/FORO/AUTORIZAR2.gif' END AS 'ImagenAutorizado', dbo.WebUsuario.Foto
FROM         dbo.WebArticulo LEFT OUTER JOIN dbo.WebUsuario ON dbo.WebArticulo.Usuario = dbo.WebUsuario.UsuarioWeb
WHERE     (dbo.WebArticulo.Pagina = @Pagina) AND (dbo.WebArticulo.RamaID = @ID)
ORDER BY dbo.WebArticulo.FechaHora DESC
end
ELSE
SELECT  2 AS 'dos',dbo.WebArticulo.*, CONVERT(int, Calificacion) AS 'Calificacion1', CASE Tipo WHEN 'Comentario' THEN 0 WHEN 'Discucion' THEN 0 ELSE 1 END AS VisibleArticulo, CASE Autorizado WHEN 1 THEN 0 ELSE 1 END AS VerAutorizados, 0 AS 'ArticuloPagado', dbo.WebArticulo.ItemPagado AS Expr1, @TituloComentario AS 'lblTituloComentario', @VerHistoria AS 'VerHistoria', CASE Autorizado WHEN 1 THEN 'App_Themes/FORO/AUTORIZAR-BN.gif' ELSE 'App_Themes/FORO/AUTORIZAR2.gif' END AS 'ImagenAutorizado', dbo.WebUsuario.Foto
FROM         dbo.WebArticulo LEFT OUTER JOIN dbo.WebUsuario ON dbo.WebArticulo.Usuario = dbo.WebUsuario.UsuarioWeb
WHERE     (dbo.WebArticulo.Pagina = @Pagina) AND (dbo.WebArticulo.RamaID = @ID) AND (Autorizado = 1 )
ORDER BY dbo.WebArticulo.FechaHora ASC
END
IF @Accion = 'CONSULTA4'
BEGIN
IF UPPER(@TipoDoc)='WIKI'
begin
SET @TituloComentario= 'No. Discuciones:'
SET @VerHistoria=1
end
ELSE
begin
SET @TituloComentario= 'No. Comentarios:'
SET @VerHistoria=0
end
SELECT @HistoricoID=HistoricoID FROM WebArticulo WHERE ID=@ID
IF EXISTS(SELECT AdminPagina FROM WebPagina WHERE Pagina = @Pagina AND AdminPagina = @Usuario)
SELECT dbo.WebArticulo.*,CONVERT(int, Calificacion) AS 'Calificacion1', 0 AS VisibleArticulo, CASE Autorizado WHEN 1 THEN 0 ELSE 1 END AS VerAutorizados, 0 AS 'ArticuloPagado', dbo.WebArticulo.ItemPagado AS Expr1, @TituloComentario AS 'lblTituloComentario', @VerHistoria AS 'VerHistoria', CASE Autorizado WHEN 1 THEN 'App_Themes/FORO/AUTORIZAR-BN.gif' ELSE 'App_Themes/FORO/AUTORIZAR2.gif' END AS 'ImagenAutorizado', dbo.WebUsuario.Foto
FROM         dbo.WebArticulo LEFT OUTER JOIN dbo.WebUsuario ON dbo.WebArticulo.Usuario = dbo.WebUsuario.UsuarioWeb
WHERE     (dbo.WebArticulo.Pagina = @Pagina) AND (dbo.WebArticulo.HistoricoID = @HistoricoID)
ORDER BY dbo.WebArticulo.FechaHora DESC
ELSE
SELECT dbo.WebArticulo.*, CONVERT(int, Calificacion) AS 'Calificacion1', CONVERT(int, Calificacion) AS 'Calificacion1', 0 AS VisibleArticulo, CASE Autorizado WHEN 1 THEN 0 ELSE 1 END AS VerAutorizados, 0 AS 'ArticuloPagado', dbo.WebArticulo.ItemPagado AS Expr1, @TituloComentario AS 'lblTituloComentario', @VerHistoria AS 'VerHistoria', CASE Autorizado WHEN 1 THEN 'App_Themes/FORO/AUTORIZAR-BN.gif' ELSE 'App_Themes/FORO/AUTORIZAR2.gif' END AS 'ImagenAutorizado', dbo.WebUsuario.Foto
FROM         dbo.WebArticulo LEFT OUTER JOIN dbo.WebUsuario ON dbo.WebArticulo.Usuario = dbo.WebUsuario.UsuarioWeb
WHERE     (dbo.WebArticulo.Pagina = @Pagina) AND (dbo.WebArticulo.HistoricoID = @HistoricoID) AND (Autorizado = 1)
ORDER BY dbo.WebArticulo.FechaHora DESC
END
IF @Accion = 'EDITAID'
BEGIN
SELECT * FROM WebArticulo WHERE ID = @ID
END
IF @Accion = 'ELIMINA'
BEGIN
DELETE WebArticulo WHERE ID =  @ID
UPDATE WebArticulo SET Comentarios = (SELECT COUNT(RAMAID) FROM  WebArticulo WHERE pagina = @Pagina AND Ramaid = @RamaID  And Autorizado = 1) WHERE ID = @RamaID
END
IF @Accion = 'ACTUALIZA'
BEGIN
UPDATE WebArticulo SET Autorizado = 1 WHERE ID = @ID
UPDATE WebArticulo SET Comentarios = (SELECT COUNT(RAMAID) FROM  WebArticulo WHERE pagina = @Pagina AND Ramaid = @RamaID  And Autorizado = 1) WHERE ID = @RamaID
EXEC spWebPaginaSuscripcion 'ENVIAR',@Pagina,'','',@URL,@Sitio  
END
IF @Accion = 'AUTORIZA_PAGO'
BEGIN
SELECT @Propietario=Usuario,@RamaID=RamaID FROM WebArticulo  WHERE id=@ID
UPDATE WebArticulo SET Pagado = 1 WHERE RamaID = @RamaID  OR id=@RamaID
UPDATE WebArticulo SET ItemPagado = 1 WHERE id=@ID
SELECT @valor=CostoArticulo FROM WebArticulo WHERE id=@RamaID
UPDATE WebUsuario SET  PuntosAcumulados=PuntosAcumulados + CONVERT(INT,@valor) WHERE UsuarioWeb=@Propietario
UPDATE WebUsuario SET  PuntosAcumulados=PuntosAcumulados - CONVERT(INT,@valor) WHERE UsuarioWeb=@Usuario
END
IF @Accion = 'GRABAARTICULO'
BEGIN
SELECT @Autorizado = CASE RequiereAutorizacion WHEN 1 THEN 0 ELSE 1 END FROM WEBPAGINA WHERE Pagina = @Pagina
INSERT INTO WEBARTICULO (Pagina,   FechaHora, Usuario,  CorreoElectronico,  Tipo,  Descripcion,  HTML,  Autorizado,  Categoria, CostoArticulo,HistoricoID)
VALUES             (@Pagina,  getdate(), @Usuario, @Correo,            @Tipo, @Descripcion, @HTML, @Autorizado, @Categoria,@valor,@HistoricoID)
SET @ArticuloID=SCOPE_IDENTITY()
IF (ISNULL(@HistoricoID,0)=0  OR @HistoricoID='') AND UPPER(@TipoDoc)='WIKI'
UPDATE webarticulo SET HistoricoID=@ArticuloID WHERE ID=@ArticuloID
IF (@Autorizado = 1)
EXEC spWebPaginaSuscripcion 'ENVIAR',@Pagina,'','',@URL,@Sitio  
END
IF @Accion = 'GRABACOMENTARIO'
BEGIN
SELECT @Autorizado = CASE RequiereAutorizacion WHEN 1 THEN 0 ELSE 1 END FROM WEBPAGINA WHERE Pagina = @Pagina
INSERT INTO WEBARTICULO (Pagina,   RamaID,  FechaHora, Usuario,  CorreoElectronico,  Tipo,  Descripcion,  HTML  ,Autorizado,  Categoria,CostoArticulo)
VALUES             (@Pagina,  @RamaID, getdate(), @Usuario, @Correo,            @Tipo, @Descripcion, @HTML ,@Autorizado, @Categoria,@valor)
IF @Autorizado = 1
BEGIN
UPDATE WebArticulo set Comentarios = (SELECT COUNT(RAMAID) FROM  WebArticulo WHERE pagina = @Pagina AND Ramaid = @RamaID And Autorizado = 1	) WHERE pagina = @Pagina AND id = @RamaID
EXEC spWebPaginaSuscripcion 'ENVIAR',@Pagina,'','',@URL,@Sitio  
END
END
IF @Accion = 'ACTUALIZAREGISTRO'
BEGIN
UPDATE WEBARTICULO set Descripcion = @Descripcion, HTML = @HTML  , Categoria = @Categoria
WHERE ID = @ID
END
IF @Accion = 'ACTUALIZAWIKI'
BEGIN
SELECT @Autorizado = CASE RequiereAutorizacion WHEN 1 THEN 0 ELSE 1 END FROM WEBPAGINA WHERE Pagina = @Pagina
UPDATE WEBARTICULO set HistoricoID=@HistoricoID
WHERE ID = @HistoricoID
INSERT INTO WEBARTICULO (Pagina,   HistoricoID,  FechaHora, Usuario,  CorreoElectronico,  Tipo,  Descripcion,  HTML  ,Autorizado,  Categoria) VALUES
(@Pagina,  @HistoricoID,          getdate(), @Usuario, @Correo,            @Tipo, @Descripcion, @HTML ,@Autorizado, @Categoria)
END
IF @Accion = 'BUSCAR'
BEGIN
IF (@Categoria='Categoria')
SELECT 'Comunidad.aspx?Pagina=' + Pagina + '&Origen=' + CONVERT(VARCHAR,id) as 'URL', Pagina, ID,  Descripcion, Usuario,  FechaHora , Categoria, Comentarios
FROM webarticulo
WHERE (Categoria = @Descripcion)
AND Autorizado = 1  And Tipo = 'Articulo'
ELSE
SELECT 'Comunidad.aspx?Pagina=' + Pagina + '&Origen=' + CONVERT(VARCHAR,id) as 'URL', Pagina, ID,  Descripcion, Usuario,  FechaHora,  Categoria, Comentarios, Tipo
FROM webarticulo
WHERE (Descripcion Like '%' + @Descripcion + '%' OR
HTML Like '%' + @Descripcion + '%' OR
Tipo Like '%' + @Descripcion + '%' OR Categoria = @Descripcion)
AND Autorizado = 1  And Tipo = 'Articulo'
END
IF @Accion = 'CUENTACATEGORIAS'
BEGIN
SELECT  TOP (100) COUNT(Categoria) AS Cantidad, Categoria
FROM  WebArticulo
GROUP BY Categoria, Autorizado, Tipo, Pagina
HAVING  (Categoria IS NOT NULL) AND (Autorizado = 1) AND (Tipo = 'Articulo') AND (Pagina = @Pagina)
END
IF @Accion = 'POSTRECIENTES'
BEGIN
SELECT TOP 10 SUBSTRING(Descripcion,1,20) + '...' AS Descripcion, Pagina, ID, RamaID
FROM WebArticulo
WHERE Tipo = 'Articulo' AND
Autorizado = 1 AND
Pagina = @Pagina
ORDER BY FechaHora desc
END
IF @Accion = 'PORAUTORIZAR'
BEGIN
SELECT     TOP (100) COUNT(Categoria) AS Cantidad, Categoria,  Pagina,  Tipo
FROM         dbo.WebArticulo
WHERE     (Pagina = @Pagina)
GROUP BY Categoria, Autorizado,  Tipo, Pagina
HAVING      (Categoria IS NOT NULL) AND (Autorizado = 0)
END
IF @Accion = 'CALIFICAPOST'
BEGIN
SELECT @TemValor2 = CONVERT(NUMERIC, @valor)
SELECT @TemValor = CASE  WHEN Calificacion IS NULL THEN 0 ELSE Calificacion END FROM WebArticulo WHERE id = @ID
IF (@TemValor = 0)
SELECT @TemValor3 =  @TemValor2
ELSE
SELECT @TemValor3 = (@TemValor + @TemValor2)/ 2
UPDATE WebArticulo SET	Calificacion =  @TemValor3 WHERE id = @ID
END
RETURN
END

