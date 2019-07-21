SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebPaginaSuscripcion
@Accion			VARCHAR(20)	 = '',
@Pagina			VARCHAR(20) = '',
@Usuario		VARCHAR(100) = '',
@Correo			VARCHAR(100) = '',
@URL			VARCHAR(300) = '',
@Sitio			VARCHAR(250) = ''

AS BEGIN
Declare
@Mensaje		VARCHAR(Max),
@Propietario	VARCHAR(100)
IF @ACCION ='AGREGAR'
BEGIN
IF NOT EXISTS(SELECT ID FROM WebPaginaSuscripcion WHERE Pagina = @Pagina  AND Usuario = @Usuario AND eMail = @Correo AND Estatus='ALTA')
BEGIN
INSERT INTO WebPaginaSuscripcion
(Pagina,  Usuario,  eMail,   Fecha,	  Estatus) VALUES
(@Pagina, @Usuario, @Correo, Getdate(), 'ALTA')
SELECT '0000' 
END
ELSE
BEGIN
SELECT '1111' 
END
END
IF @ACCION ='CANCELAR'
BEGIN
IF EXISTS(SELECT ID FROM WebPaginaSuscripcion WHERE Pagina = @Pagina  AND Usuario = @Usuario AND eMail = @Correo AND Estatus='ALTA')
BEGIN
UPDATE WebPaginaSuscripcion SET Estatus = 'BAJA' WHERE Pagina = @Pagina  AND Usuario = @Usuario AND eMail = @Correo
SELECT '0000' 
END
ELSE
SELECT '2222' 
END
IF @ACCION ='ENVIAR'
BEGIN
declare @CorreoEnviar as VARCHAR(100)
declare CURSORITO cursor for
select eMail FROM WebPaginaSuscripcion WHERE Pagina = @Pagina AND Estatus = 'ALTA'
open CURSORITO
fetch next from CURSORITO
into @CorreoEnviar
while @@fetch_status = 0
begin
declare @WebServer as varchar(255)
select @WebServer =URL_Sitio from WebSitio where Sitio= @Sitio
SELECT @Mensaje = '<html>
<head>
<meta http-equiv="Content-Language" content="es-mx">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Tienes un nuevo Comentario</title>
</head>
<body>
<div style=" width' + CHAR(58) + '100%; border-style' + CHAR(58) + ' none; border-width' + CHAR(58) + ' 0px; padding-left' + CHAR(58) + ' 4px; padding-right' + CHAR(58) + ' 4px; padding-top' + CHAR(58) + ' 1px; padding-bottom' + CHAR(58) + ' 1px" >
<table border="0" width="100%" height="287" >
<tr>
<td  height="23" bgcolor="#C0C0C0" width="100%>
<p style="margin-left' + CHAR(58) + ' 10px"><b>
<font face="Arial Unicode MS" color="#0A78BE">&nbsp;</font></b>
</td>
</tr>
<tr>
<td>
<br/>
<br/>
<br/>
Existe una participacion en el Foro ' + CONVERT(VARCHAR(300),@URL) + '
<br/>
<br/>
<br/>
</td>
</tr>
<tr>
<td height="23" bgcolor="#0A78BE" >
<p align="center" style=" width' + CHAR(58) + '100%"><font color="#FFFFFF" face="Arial Unicode MS" size="2"><b>By Power
I-Portal</b></font></p>
</td>
</tr>
<tr>
<td  height="23" bgcolor="#C0C0C0"  align="center">
<p style="text-align' + CHAR(58) + 'center;width' + CHAR(58) + '100%">
<a style="color' + CHAR(58) + ' blue; text-decoration' + CHAR(58) + ' underline; text-underline' + CHAR(58) + ' single" href="' + @WebServer + 'Administracion.aspx?Pagina=' + @Pagina + '&Origen=' +  @Usuario + '|' + @Correo + 'CS">
<font face="Arial Unicode MS" color="#0A78BE" size="2">Para cancelar su suscripcion haga click aqui</font>
</a>
</p>
</td>
</tr>
<tr>
<td    align="center">
<p style="text-align' + CHAR(58) + 'center;width' + CHAR(58) + '100%">
<font face="Arial Unicode MS" size="2">Base de datos de suscriptores registrada en Intelisis S.A </font> <br/>
<font face="Arial Unicode MS" size="2">Copyright U2008. Todos los derechos reservados.</font>
</p>
</td>
</tr>
</table>
</div>
</body>
</html>'
EXEC msdb.dbo.sp_send_dbmail
@profile_name ='Desarrollo',
@recipients=@CorreoEnviar,
@subject = 'Nuevo Comentario...',
@body = @Mensaje,
@body_format = 'HTML';
fetch next from CURSORITO
into @CorreoEnviar
end
close CURSORITO
deallocate CURSORITO
END
RETURN
END

