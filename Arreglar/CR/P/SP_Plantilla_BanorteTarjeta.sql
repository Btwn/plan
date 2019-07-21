SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE SP_Plantilla_BanorteTarjeta
@Pagina       Varchar(20) = null

AS BEGIN
SET NOCOUNT ON
IF NOT EXISTS(SELECT Pagina FROM WebPaginaParam WITH(NOLOCK) WHERE Pagina = @Pagina)
BEGIN
DELETE WebPaginaParam WHERE Pagina = @Pagina
INSERT INTO WebPaginaParam (Pagina,Parametro,Nombre,TipoDatos,Tamano,EsContrasena,EsMayusculas,EsRequerido,ValorPorOmision,TipoAyuda,AyudaTabla,AyudaValor,AyudaNombre,AyudaCondicion,AyudaOrden,Orden,EspacioPrevio,Grupo,EsSoloLectura,EsOculto) Values
(@Pagina,'ClientId','ClientId','Texto',NULL,0,0,0,'19','No',NULL,NULL,NULL,NULL,NULL,1,0,NULL,0,1)
INSERT INTO WebPaginaParam (Pagina,Parametro,Nombre,TipoDatos,Tamano,EsContrasena,EsMayusculas,EsRequerido,ValorPorOmision,TipoAyuda,AyudaTabla,AyudaValor,AyudaNombre,AyudaCondicion,AyudaOrden,Orden,EspacioPrevio,Grupo,EsSoloLectura,EsOculto) Values
(@Pagina,'Expires','Fecha:','Texto',NULL,0,0,0,'10/10','No',NULL,NULL,NULL,NULL,NULL,7,1,'',1,0)
INSERT INTO WebPaginaParam (Pagina,Parametro,Nombre,TipoDatos,Tamano,EsContrasena,EsMayusculas,EsRequerido,ValorPorOmision,TipoAyuda,AyudaTabla,AyudaValor,AyudaNombre,AyudaCondicion,AyudaOrden,Orden,EspacioPrevio,Grupo,EsSoloLectura,EsOculto) Values
(@Pagina,'Mode','Mode','Texto',NULL,0,0,0,'R','No',NULL,NULL,NULL,NULL,NULL,5,1,NULL,0,1)
INSERT INTO WebPaginaParam (Pagina,Parametro,Nombre,TipoDatos,Tamano,EsContrasena,EsMayusculas,EsRequerido,ValorPorOmision,TipoAyuda,AyudaTabla,AyudaValor,AyudaNombre,AyudaCondicion,AyudaOrden,Orden,EspacioPrevio,Grupo,EsSoloLectura,EsOculto) Values
(@Pagina,'Name','Name','Texto',NULL,0,0,0,'tienda19','No',NULL,NULL,NULL,NULL,NULL,3,0,NULL,0,1)
INSERT INTO WebPaginaParam (Pagina,Parametro,Nombre,TipoDatos,Tamano,EsContrasena,EsMayusculas,EsRequerido,ValorPorOmision,TipoAyuda,AyudaTabla,AyudaValor,AyudaNombre,AyudaCondicion,AyudaOrden,Orden,EspacioPrevio,Grupo,EsSoloLectura,EsOculto) Values
(@Pagina,'Number','Tarjeta','Tarjeta',NULL,0,0,1,'4242424242424242','No',NULL,NULL,NULL,NULL,NULL,6,1,NULL,0,0)
INSERT INTO WebPaginaParam (Pagina,Parametro,Nombre,TipoDatos,Tamano,EsContrasena,EsMayusculas,EsRequerido,ValorPorOmision,TipoAyuda,AyudaTabla,AyudaValor,AyudaNombre,AyudaCondicion,AyudaOrden,Orden,EspacioPrevio,Grupo,EsSoloLectura,EsOculto) Values
(@Pagina,'Password','Password','Texto',NULL,0,0,0,'2006','No',NULL,NULL,NULL,NULL,NULL,2,0,NULL,0,1)
INSERT INTO WebPaginaParam (Pagina,Parametro,Nombre,TipoDatos,Tamano,EsContrasena,EsMayusculas,EsRequerido,ValorPorOmision,TipoAyuda,AyudaTabla,AyudaValor,AyudaNombre,AyudaCondicion,AyudaOrden,Orden,EspacioPrevio,Grupo,EsSoloLectura,EsOculto) Values
(@Pagina,'Total','Total Compra:','Numerico',NULL,0,0,0,'10.25','No',NULL,NULL,NULL,NULL,NULL,8,1,'',1,0)
INSERT INTO WebPaginaParam (Pagina,Parametro,Nombre,TipoDatos,Tamano,EsContrasena,EsMayusculas,EsRequerido,ValorPorOmision,TipoAyuda,AyudaTabla,AyudaValor,AyudaNombre,AyudaCondicion,AyudaOrden,Orden,EspacioPrevio,Grupo,EsSoloLectura,EsOculto) Values
(@Pagina,'TransType','TransType','Texto',NULL,0,0,0,'Auth','No',NULL,NULL,NULL,NULL,NULL,4,1,NULL,0,1) 		END
RETURN
END

