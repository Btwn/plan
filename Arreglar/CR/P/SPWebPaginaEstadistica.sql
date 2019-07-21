SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [SPWebPaginaEstadistica]
@Pagina varchar(20),
@Sitio varchar(20),
@SesionID Uniqueidentifier,
@Navegador varchar(50),
@PaginaAnterior varchar(250),
@Usuario varchar(20),
@IpUsuario varchar(20),
@Documento varchar(255)

AS BEGIN
IF NOT EXISTS(SELECT Sitio
FROM WebPaginaEstadistica
WHERE Sitio = @Sitio AND
SesionID = @SesionID AND
Pagina= @Pagina AND
IpUsuario = @IpUsuario AND
Navegador = @Navegador AND
PaginaAnterior = @PaginaAnterior AND
Usuario=@Usuario AND Documento=@Documento )
BEGIN
insert into WebPaginaEstadistica
(Sitio ,Pagina ,SesionID, IpUsuario  ,Navegador ,PaginaAnterior ,Usuario,Documento)
values
(@Sitio,@Pagina,@SesionID, @IpUsuario,@Navegador,@PaginaAnterior,@Usuario,@Documento)
END
END

