SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSISClienteInfo
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
@Datos2		        varchar(max),
@Datos3		        varchar(max),
@Datos4  	        varchar(max),
@Empresa                varchar(5),
@ReferenciaIS           varchar(50),
@SubReferenciaIS        varchar(50),
@LenDatos               int,
@SaldoMN                float,
@LimiteCredito          float
SELECT @ReferenciaIS = Referencia , @SubReferenciaIS = SubReferencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Cliente = RTRIM(LTRIM(Cliente)), @Empresa = Empresa
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/CteInfo')
WITH (Cliente varchar(10), Empresa varchar(5))
SET ANSI_WARNINGS OFF
SELECT @SaldoMN = SUM(s.Saldo*m.TipoCambio) FROM CxcSaldo s, Mon m WHERE s.Moneda = m.Moneda AND Empresa=@Empresa AND Cliente=@Cliente
EXEC spPOSVerLimiteCreditoMN @Cliente, @Empresa, @LimiteCredito OUTPUT
SELECT @Datos4 = '<Saldo SaldoMN=' + CHAR(34) + ISNULL(CONVERT(varchar ,ISNULL(@SaldoMN,0.0)),'') + CHAR(34) + '  LimiteCreditoMN=' + CHAR(34) + ISNULL(CONVERT(varchar ,ISNULL(@LimiteCredito,0.0)),'') + CHAR(34) + '/>'
SELECT @Datos3 =(SELECT CteCredito.* FROM Cte  c LEFT OUTER JOIN CteCredito ON @empresa=CteCredito.Empresa AND c.Credito=CteCredito.Credito  WHERE c.Cliente = @Cliente FOR XML AUTO)
SELECT @Datos2 =(SELECT * FROM dbo.fnCxcInfo(@Empresa, @Cliente, @Cliente)fnCxcInfo FOR XML AUTO)
SELECT @Datos =(SELECT * FROM Venta WHERE Cliente = @Cliente AND Estatus IN('PENDIENTE','PROCESAR','CONFIRMAR', 'VIGENTE') FOR XML AUTO)
SELECT @Datos =   ISNULL(@Datos2,'')+  ISNULL(@Datos3,'')+ISNULL(@Datos,'')+ISNULL(@Datos4,'')
SELECT @LenDatos = LEN(ISNULL(@Datos,''))
SELECT @Datos = ISNULL(@Datos,'')+ '<Relleno '+  +'A="'+REPLICATE('X',8000-@LenDatos)+'" />'
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34)
+ ' SubReferencia='+ CHAR(34) + ISNULL(@SubReferenciaIS,'') + CHAR(34)
+' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+' >' +ISNULL(@Datos,'')+'</Resultado></Intelisis>'
END

