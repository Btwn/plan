SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE SP_Plantilla_PagosOnLine
@Pagina       Varchar(20) = null

AS BEGIN
SET NOCOUNT ON
IF NOT EXISTS(SELECT Pagina FROM WebPaginaParam WITH(NOLOCK) WHERE Pagina = @Pagina)
BEGIN
DELETE WebPaginaParam WHERE Pagina = @Pagina
INSERT INTO WebPaginaParam (Pagina,Parametro,Nombre,TipoDatos,Tamano,EsContrasena,EsMayusculas,EsRequerido,ValorPorOmision,TipoAyuda,AyudaTabla,AyudaValor,AyudaNombre,AyudaCondicion,AyudaOrden,Orden,EspacioPrevio,Grupo,EsSoloLectura,EsOculto) Values
(@Pagina,'baseDevolucionIva','Base Devolucion Iva:','Texto',NULL,0,0,0,'','No',NULL,NULL,NULL,NULL,NULL,6,1,NULL,1,0)
INSERT INTO WebPaginaParam (Pagina,Parametro,Nombre,TipoDatos,Tamano,EsContrasena,EsMayusculas,EsRequerido,ValorPorOmision,TipoAyuda,AyudaTabla,AyudaValor,AyudaNombre,AyudaCondicion,AyudaOrden,Orden,EspacioPrevio,Grupo,EsSoloLectura,EsOculto) Values
(@Pagina,'descripcion','Descripcion:','Texto',NULL,0,0,0,'','No',NULL,NULL,NULL,NULL,NULL,3,1,NULL,1,0)
INSERT INTO WebPaginaParam (Pagina,Parametro,Nombre,TipoDatos,Tamano,EsContrasena,EsMayusculas,EsRequerido,ValorPorOmision,TipoAyuda,AyudaTabla,AyudaValor,AyudaNombre,AyudaCondicion,AyudaOrden,Orden,EspacioPrevio,Grupo,EsSoloLectura,EsOculto) Values
(@Pagina,'extra1','Campo Usado para validar la respuesta','Texto',NULL,0,0,0,NULL,'No',NULL,NULL,NULL,NULL,NULL,10,1,NULL,0,1)
INSERT INTO WebPaginaParam (Pagina,Parametro,Nombre,TipoDatos,Tamano,EsContrasena,EsMayusculas,EsRequerido,ValorPorOmision,TipoAyuda,AyudaTabla,AyudaValor,AyudaNombre,AyudaCondicion,AyudaOrden,Orden,EspacioPrevio,Grupo,EsSoloLectura,EsOculto) Values
(@Pagina,'firma','firma','Texto',NULL,0,0,0,'','No',NULL,NULL,NULL,NULL,NULL,7,1,NULL,0,1)
INSERT INTO WebPaginaParam (Pagina,Parametro,Nombre,TipoDatos,Tamano,EsContrasena,EsMayusculas,EsRequerido,ValorPorOmision,TipoAyuda,AyudaTabla,AyudaValor,AyudaNombre,AyudaCondicion,AyudaOrden,Orden,EspacioPrevio,Grupo,EsSoloLectura,EsOculto) Values
(@Pagina,'iva','Iva:','Texto',NULL,0,0,0,'','No',NULL,NULL,NULL,NULL,NULL,5,1,NULL,1,0)
INSERT INTO WebPaginaParam (Pagina,Parametro,Nombre,TipoDatos,Tamano,EsContrasena,EsMayusculas,EsRequerido,ValorPorOmision,TipoAyuda,AyudaTabla,AyudaValor,AyudaNombre,AyudaCondicion,AyudaOrden,Orden,EspacioPrevio,Grupo,EsSoloLectura,EsOculto) Values
(@Pagina,'PagOnvalor','Total aPagar:','Texto',NULL,0,0,0,'','No',NULL,NULL,NULL,NULL,NULL,4,1,NULL,1,0)
INSERT INTO WebPaginaParam (Pagina,Parametro,Nombre,TipoDatos,Tamano,EsContrasena,EsMayusculas,EsRequerido,ValorPorOmision,TipoAyuda,AyudaTabla,AyudaValor,AyudaNombre,AyudaCondicion,AyudaOrden,Orden,EspacioPrevio,Grupo,EsSoloLectura,EsOculto) Values
(@Pagina,'prueba','prueba','Texto',NULL,0,0,0,'1','No',NULL,NULL,NULL,NULL,NULL,40,1,NULL,0,1)
INSERT INTO WebPaginaParam (Pagina,Parametro,Nombre,TipoDatos,Tamano,EsContrasena,EsMayusculas,EsRequerido,ValorPorOmision,TipoAyuda,AyudaTabla,AyudaValor,AyudaNombre,AyudaCondicion,AyudaOrden,Orden,EspacioPrevio,Grupo,EsSoloLectura,EsOculto) Values
(@Pagina,'refVenta','Referencia Intelisis:','Texto',NULL,0,0,0,'','No',NULL,NULL,NULL,NULL,NULL,2,1,NULL,1,0)
INSERT INTO WebPaginaParam (Pagina,Parametro,Nombre,TipoDatos,Tamano,EsContrasena,EsMayusculas,EsRequerido,ValorPorOmision,TipoAyuda,AyudaTabla,AyudaValor,AyudaNombre,AyudaCondicion,AyudaOrden,Orden,EspacioPrevio,Grupo,EsSoloLectura,EsOculto) Values
(@Pagina,'url_confirmacion','url_confirmacion','Texto',NULL,0,0,0,'http://desarrollo.intelisis.com','No',NULL,NULL,NULL,NULL,NULL,30,1,NULL,0,1)
INSERT INTO WebPaginaParam (Pagina,Parametro,Nombre,TipoDatos,Tamano,EsContrasena,EsMayusculas,EsRequerido,ValorPorOmision,TipoAyuda,AyudaTabla,AyudaValor,AyudaNombre,AyudaCondicion,AyudaOrden,Orden,EspacioPrevio,Grupo,EsSoloLectura,EsOculto) Values
(@Pagina,'url_respuesta','url_respuesta','Texto',NULL,0,0,0,'http://davidongay/Iporta2/Pago.aspx','No',NULL,NULL,NULL,NULL,NULL,20,1,NULL,0,1)
INSERT INTO WebPaginaParam (Pagina,Parametro,Nombre,TipoDatos,Tamano,EsContrasena,EsMayusculas,EsRequerido,ValorPorOmision,TipoAyuda,AyudaTabla,AyudaValor,AyudaNombre,AyudaCondicion,AyudaOrden,Orden,EspacioPrevio,Grupo,EsSoloLectura,EsOculto) Values
(@Pagina,'usuarioId','Usuario Sistema PagosOnline:','Texto',NULL,0,0,0,'2','No',NULL,NULL,NULL,NULL,NULL,1,1,NULL,0,1) 		END
RETURN
END

