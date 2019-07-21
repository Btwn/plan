SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCampanaCorreoEnviarPara
@ID				int,
@Pagina				varchar(20),
@Asunto				varchar(100),
@Para				varchar(255),
@Perfil				varchar(50),
@RID				int,
@HTML				varchar(max),
@PaginaTipo			varchar(20),
@Sitio				varchar(20),
@EncuestaWeb			bit,
@EncuestaEtiqueta		varchar(100),
@EncuestaPagina			varchar(20),
@CancelarSuscripcion		bit,
@CancelarSuscripcionEtiqueta	varchar(100),
@Ok				int		OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Vinculo		varchar(max)
IF @EncuestaWeb = 1 AND UPPER(@PaginaTipo) IN ('ENCUESTA', 'HTML')
BEGIN
SELECT @Vinculo = WebSitio.URL_Sitio+'encuesta.aspx?pagina='+@EncuestaPagina+'&Origen=CMP|'+CONVERT(varchar, @ID)+'|'+CONVERT(varchar, @RID)
FROM WebSitio WITH (NOLOCK)
WHERE Sitio = @Sitio
SELECT @HTML = @HTML + '<p align="center"><a href="'+@Vinculo+'">'+ISNULL(@EncuestaEtiqueta, @Vinculo)+'</a></p>'
END
IF @CancelarSuscripcion = 1
BEGIN
SELECT @Vinculo = WebSitio.URL_Sitio+'cancelarsuscripcion.aspx?Origen=CMP|'+CONVERT(varchar, @ID)+'|'+CONVERT(varchar, @RID)
FROM WebSitio WITH (NOLOCK)
WHERE Sitio = @Sitio
SELECT @HTML = @HTML + '<p align="center"><a href="'+@Vinculo+'">'+ISNULL(@CancelarSuscripcionEtiqueta, @Vinculo)+'</a></p>'
END
EXEC spWebPaginaParcear NULL, NULL, @Pagina, @Asunto OUTPUT, NULL, @HTML OUTPUT, NULL, @ID, @RID, @Ok OUTPUT, @OkRef OUTPUT
EXEC spEnviarDBMail @Perfil, @Para, @Asunto = @Asunto, @Mensaje = @HTML, @Formato = 'HTML'
RETURN
END

