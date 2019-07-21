SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSISMonederoInfo
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int          = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Cuenta				varchar(20),
@Datos				varchar(max),
@Datos2				varchar(max),
@Datos3				varchar(max),
@Datos4				varchar(max),
@Empresa			varchar(5),
@ReferenciaIS		varchar(50),
@SubReferenciaIS	varchar(50),
@LenDatos			int,
@SaldoMN			float,
@LimiteCredito		float
DECLARE @SaldoPMon table (Empresa varchar(5), Moneda varchar(5), Grupo varchar(10), Cuenta varchar(20), SubCuenta varchar(50), Saldo float)
SELECT @ReferenciaIS = Referencia , @SubReferenciaIS = SubReferencia
FROM IntelisisService WITH (NOLOCK)
WHERE ID = @ID
SELECT @Cuenta = RTRIM(LTRIM(Cuenta)), @Empresa = Empresa
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/MonederoInfo')
WITH (Cuenta varchar(20), Empresa varchar(5))
INSERT @SaldoPMon (Empresa, Moneda, Grupo, Cuenta,   SubCuenta,      Saldo)
SELECT			 Empresa, Moneda, Grupo, Cuenta,   SubCuenta,      Saldo
FROM SaldoPMon WITH (NOLOCK)
WHERE Empresa = @Empresa
AND Cuenta = @Cuenta
SELECT @Datos =(SELECT * FROM @SaldoPMon SaldoPMon FOR XML AUTO)
SELECT @Datos = ISNULL(@Datos,'')
SELECT @LenDatos = LEN(ISNULL(@Datos,''))
SELECT @Datos = ISNULL(@Datos,'')+ '<Relleno '+  +'A="'+REPLICATE('X',8000-@LenDatos)+'" />'
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34)
+ ' SubReferencia='+ CHAR(34) + ISNULL(@SubReferenciaIS,'') + CHAR(34)
+' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+' >'
+ISNULL(@Datos,'')+'</Resultado></Intelisis>'
END

