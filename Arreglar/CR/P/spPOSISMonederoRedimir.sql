SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSISMonederoRedimir
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int          = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Serie				varchar(20),
@Datos				varchar(max),
@Datos2				varchar(max),
@Datos3				varchar(max),
@Datos4				varchar(max),
@Empresa			varchar(5),
@ReferenciaIS		varchar(50),
@SubReferenciaIS	varchar(50),
@LenDatos			int,
@SaldoMN			float,
@LimiteCredito		float,
@Usuario			varchar(10),
@Sucursal			int,
@Mov				varchar(20),
@MovID				varchar(20),
@Moneda				varchar(10),
@TipoCambio			float,
@Posicion			int,
@IDPos				varchar(36),
@Importe			money
DECLARE @POSSerieTarjetaMovM table (Empresa varchar( 5), Modulo varchar(5), ID varchar(36), Serie varchar(20), Importe money, Sucursal int, Posicion int, Mov varchar(20), MovID varchar(20), Referencia varchar(50), Moneda varchar(10), TipoCambio float, FechaEmision datetime, Usuario varchar(10))
SELECT @ReferenciaIS = Referencia , @SubReferenciaIS = SubReferencia
FROM IntelisisService
WHERE ID = @ID
SELECT @Serie			= RTRIM(LTRIM(Serie)),
@Empresa		= Empresa,
@Sucursal		= Sucursal,
@Usuario		= Usuario,
@Mov			= Mov,
@MovID			= MovID,
@Moneda		= Moneda,
@TipoCambio	= TipoCambio,
@Posicion		= Posicion,
@IDPos			= ID,
@Importe		= Importe
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/MonederoRedimir')
WITH (Serie varchar(20), Empresa varchar(5), Sucursal int, Usuario varchar(10), Mov varchar(20), MovID varchar(20),
Moneda varchar(10), TipoCambio float, Posicion int, ID varchar(36), Importe money)
EXEC spPOSMonederoCBRefimir @Empresa, @Sucursal, @IDPos, @Serie, @Importe, @Posicion, @Moneda, @TipoCambio, @Usuario, @Mov, @MovID, @Ok OUTPUT, @OkRef OUTPUT
IF NOT EXISTS (SELECT * FROM POSSerieTarjetaMovM WHERE Mov = @Mov AND MovID = @MovID AND Posicion = @Posicion AND Empresa = @Empresa AND Serie = @Serie AND Sucursal = @Sucursal AND Referencia = 'APROBADA')
DELETE FROM POSSerieTarjetaMovM WHERE Mov = @Mov AND MovID = @MovID AND Posicion = @Posicion AND Empresa = @Empresa AND Serie = @Serie AND Sucursal = @Sucursal AND Referencia <> 'APROBADA'
IF @Ok IS NULL
INSERT @POSSerieTarjetaMovM (Empresa, Modulo, ID, Serie, Importe, Sucursal, Posicion, Mov, MovID, Referencia, Moneda, TipoCambio, FechaEmision, Usuario)
SELECT						  Empresa, Modulo, ID, Serie, Importe, Sucursal, Posicion, Mov, MovID, Referencia, Moneda, TipoCambio, FechaEmision, Usuario
FROM POSSerieTarjetaMovM
WHERE Mov = @Mov
AND MovID = @MovID
AND Posicion = @Posicion
AND Empresa = @Empresa
AND Serie = @Serie
AND Sucursal = @Sucursal
SELECT @Datos =(SELECT * FROM @POSSerieTarjetaMovM MonederoRedimir FOR XML AUTO)
SELECT @Datos = ISNULL(@Datos,'')
SELECT @LenDatos = LEN(ISNULL(@Datos,''))
SELECT @Datos = ISNULL(@Datos,'')+ '<Relleno '+  +'A="'+REPLICATE('X',8000-@LenDatos)+'" />'
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34)
+ ' SubReferencia='+ CHAR(34) + ISNULL(@SubReferenciaIS,'') + CHAR(34)
+' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+' >'
+ISNULL(@Datos,'')+'</Resultado></Intelisis>'
END

