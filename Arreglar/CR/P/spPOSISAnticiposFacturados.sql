SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSISAnticiposFacturados
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
@LenDatos               int
SELECT @ReferenciaIS = Referencia , @SubReferenciaIS = SubReferencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Cliente = Cliente, @Empresa = Empresa
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Anticipo')
WITH (Cliente varchar(255), Empresa varchar(5))
SELECT @Datos =(SELECT ID, Mov, MovID, Cliente, FechaEmision, Referencia, Concepto, AnticipoSaldo, Moneda, TipoCambio, Importe, Impuestos, Retencion, AnticipoAplicar, PedidoReferencia, PedidoReferenciaID
FROM Cxc
WHERE Empresa = @Empresa
AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
AND AnticipoSaldo>0
AND Cliente = @Cliente
FOR XML AUTO)
SELECT @LenDatos = LEN(ISNULL(@Datos,''))
IF @LenDatos BETWEEN 0 AND 3999
SELECT @Datos = ISNULL(@Datos,'')+ '<Relleno '+  +'A="'+REPLICATE('X',4000-@LenDatos)+'" />'
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34)
+ ' SubReferencia='+ CHAR(34) + ISNULL(@SubReferenciaIS,'') + CHAR(34)
+' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+' >' +ISNULL(@Datos,'')+'</Resultado></Intelisis>'
END

