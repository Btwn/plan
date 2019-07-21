SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSISAuxiliarPMon
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
DECLARE @AuxiliarPMon table (ID int, Empresa varchar( 5), Rama varchar( 5), Mov varchar(20), MovID varchar(20), Modulo varchar(5), ModuloID int, Moneda varchar(10), TipoCambio float, Grupo varchar(10), Cuenta varchar(20), SubCuenta varchar(50), Ejercicio int, Periodo int, Fecha datetime, Cargo money, Abono money, Aplica varchar(20), AplicaID varchar(20), Acumulado bit, Conciliado bit, EsCancelacion bit, FechaConciliacion datetime, Sucursal int, Renglon float, RenglonSub int )
SELECT @ReferenciaIS = Referencia , @SubReferenciaIS = SubReferencia
FROM IntelisisService WITH (NOLOCK)
WHERE ID = @ID
SELECT @Cuenta = RTRIM(LTRIM(Cuenta)), @Empresa = Empresa
FROM openxml (@iSolicitud,'/Intelisis/Solicitud/AuxiliarPMon')
WITH (Cuenta varchar(20), Empresa varchar(5))
INSERT @AuxiliarPMon (ID, Empresa, Rama, Mov, MovID, Modulo, ModuloID, Moneda, TipoCambio, Grupo, Cuenta, SubCuenta, Ejercicio, Periodo, Fecha, Cargo, Abono, Aplica, AplicaID, Acumulado, Conciliado, EsCancelacion, FechaConciliacion, Sucursal, Renglon, RenglonSub)
SELECT			 ID, Empresa, Rama, Mov, MovID, Modulo, ModuloID, Moneda, TipoCambio, Grupo, Cuenta, SubCuenta, Ejercicio, Periodo, Fecha, Cargo, Abono, Aplica, AplicaID, Acumulado, Conciliado, EsCancelacion, FechaConciliacion, Sucursal, Renglon, RenglonSub
FROM AuxiliarPMon WITH (NOLOCK)
WHERE Empresa = @Empresa
AND Cuenta = @Cuenta
SELECT @Datos =(SELECT * FROM @AuxiliarPMon AuxiliarPMon FOR XML AUTO)
SELECT @Datos = ISNULL(@Datos,'')
SELECT @LenDatos = LEN(ISNULL(@Datos,''))
SELECT @Datos = ISNULL(@Datos,'')+ '<Relleno '+  +'A="'+REPLICATE('X',8000-@LenDatos)+'" />'
SELECT @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34)
+ ' SubReferencia='+ CHAR(34) + ISNULL(@SubReferenciaIS,'') + CHAR(34)
+' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')  + CHAR(34)  + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+' >'
+ISNULL(@Datos,'')+'</Resultado></Intelisis>'
END

