SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSISImportarVenta
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok			int          = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Cliente     	        varchar(10),
@Datos		        varchar(max),
@Empresa                varchar(5),
@ReferenciaIS           varchar(50),
@SubReferenciaIS        varchar(50),
@LenDatos               int,
@ReferenciaOrigen       varchar(50),
@IDPOS                  varchar(50)
SELECT @ReferenciaIS = Referencia , @SubReferenciaIS = SubReferencia
FROM IntelisisService
WHERE ID = @ID
SELECT @IDPOS = NULL
SELECT @ReferenciaOrigen = ReferenciaOrigen, @Empresa = Empresa
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Venta')
WITH (ReferenciaOrigen varchar(50), Empresa varchar(5))
IF EXISTS(SELECT * FROM Venta pl INNER JOIN MovTipo mt ON pl.Mov = mt.Mov AND mt.Modulo = 'VTAS' AND mt.Clave IN ('VTAS.F', 'VTAS.N','VTA.FM') WHERE LTRIM(RTRIM(pl.Mov)) + ' ' + LTRIM(RTRIM(pl.MovId)) = @ReferenciaOrigen AND pl.Importe >= 0)
SELECT @IDPOS = ReferenciaOrdenCompra FROM Venta pl INNER JOIN MovTipo mt ON pl.Mov = mt.Mov AND mt.Modulo = 'VTAS' AND mt.Clave IN ('VTAS.F', 'VTAS.N','VTA.FM') WHERE LTRIM(RTRIM(pl.Mov)) + ' ' + LTRIM(RTRIM(pl.MovId)) = @ReferenciaOrigen AND pl.Importe >= 0
IF EXISTS(SELECT * FROM POSLCB cb JOIN POSL pl ON cb.ID = pl.ID WHERE cb.IDCB = @ReferenciaOrigen AND pl.Importe >= 0) AND @IDPOS IS NULL
SELECT @IDPOS = cb.ID FROM  POSLCB cb JOIN POSL pl ON cb.ID = pl.ID WHERE cb.IDCB = @ReferenciaOrigen AND pl.Importe >= 0
IF @IDPOS IS NOT NULL
SELECT @Datos =(SELECT  Venta.*,VentaD.*,ISNULL(Oferta.Forma,'')Forma,ISNULL(OfertaTipo.AceptaDevolucion,1) AceptaDevolucion ,SerieLoteMov.*
FROM Venta Venta JOIN VentaD VentaD ON Venta.ID = VentaD.ID
JOIN MovTipo mt ON Venta.Mov = mt.Mov AND mt.Modulo = 'VTAS'
LEFT JOIN SerieLoteMov SerieLoteMov ON SerieLoteMov.ID = Venta.ID AND SerieLoteMov.Empresa = Venta.Empresa AND SerieLoteMov.Modulo = 'VTAS' AND  ISNULL(SerieLoteMov.SubCuenta, '') = ISNULL(VentaD.Subcuenta, '') AND SerieLoteMov.Articulo = VentaD.Articulo
LEFT JOIN Oferta Oferta ON VentaD.OfertaID = Oferta.ID
LEFT JOIN OfertaTipo OfertaTipo ON OfertaTipo.Tipo = Oferta.Tipo
WHERE Venta.Estatus IN ('PENDIENTE','CONCLUIDO','PROCESAR')
AND mt.Clave IN( 'VTAS.N','VTAS.F','VTAS.FM')
AND Venta.Empresa = @Empresa
AND Venta.ReferenciaOrdenCompra = @IDPOS
FOR XML AUTO)
IF NULLIF(@Datos,'') IS NULL
SELECT @OK = 20915 ,@OkRef= 'No Hay Concidencias Con la Referencia ('+@ReferenciaOrigen+')'
SELECT @Datos = ISNULL(@Datos,'')
SELECT @LenDatos = LEN(@Datos)
SELECT @Datos = @Datos+ '<Relleno '+  +'A="'+REPLICATE('X',8000-@LenDatos)+'" />'
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34)
+ ' SubReferencia='+ CHAR(34) + ISNULL(@SubReferenciaIS,'') + CHAR(34)
+' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+' >' +ISNULL(@Datos,'')+'</Resultado></Intelisis>'
END

