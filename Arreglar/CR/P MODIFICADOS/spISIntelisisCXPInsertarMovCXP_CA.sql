SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spISIntelisisCXPInsertarMovCXP_CA
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Empresa				varchar(5),
@Mov					varchar(20),
@MovID					varchar(20),
@FechaEmision			datetime,
@Concepto				varchar(50),
@Proyecto				varchar(50),
@UEN					int,
@Moneda					varchar(10),
@TipoCambio				float,
@Usuario				varchar(10),
@Referencia				varchar(50),
@Observaciones			varchar(100),
@Estatus				varchar(15),
@EstatusNuevo			varchar(15),
@Proveedor				varchar(10),
@ProveedorMoneda		varchar(10),
@ProveedorTipoCambio	float,
@Condicion				varchar(50),
@Vencimiento			datetime,
@FormaPago				varchar(50),
@Importe				money,
@Impuestos				money,
@Retencion				money,
@Retencion2				money,
@Retencion3				money,
@Saldo					money,
@OrigenTipo				varchar(10),
@Origen					varchar(20),
@OrigenID				varchar(20),
@GenerarPoliza			bit,
@FechaRegistro			datetime,
@DescuentoProntoPago	float,
@Sucursal				int,
@IDGenerar				int,
@MovTipo				varchar(20),
@ReferenciaIS			varchar(100),
@SubReferencia			varchar(100),
@Renglon				float,
@RenglonSub				float,
@DImporte				money,
@Aplica					varchar(20),
@AplicaID				varchar(20),
@Suma					money,
@AplicaManual           bit
DECLARE @Temp     	    table
(
Renglon			float,
RenglonSub		float,
Importe			money,
Aplica			varchar(20),
AplicaID			varchar(20),
Sucursal   		int
)
BEGIN TRANSACTION
IF @Ok IS NULL
BEGIN
SELECT @Mov =  NULLIF(Mov,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (Mov varchar(255))
IF @@ERROR <> 0 SET @Ok = 1
END
IF @Ok IS NULL
SELECT @MovTipo = Clave
FROM MovTipo WITH(NOLOCK)
WHERE Modulo = 'CXP' AND Mov = @Mov
IF @MovTipo <> 'CXP.CA' SELECT @Ok = 35005, @OkRef = @Mov
IF @Ok IS NULL
BEGIN
SELECT @Empresa = NULLIF(Empresa,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (Empresa varchar(255))
SELECT @MovID =  NULLIF(MovID,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (MovID varchar(255))
SELECT @FechaEmision = CONVERT(datetime,FechaEmision) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (FechaEmision varchar(255))
SELECT @Concepto =  NULLIF(Concepto,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (Concepto varchar(255))
SELECT @Proyecto =  NULLIF(Proyecto,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (Proyecto varchar(255))
SELECT @UEN = CONVERT(int,UEN) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (UEN varchar(255))
SELECT @Moneda =  NULLIF(Moneda,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (Moneda varchar(255))
SELECT @TipoCambio = CONVERT(float,TipoCambio) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (TipoCambio varchar(255))
SELECT @Usuario =  NULLIF(Usuario,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (Usuario varchar(255))
SELECT @Referencia =  NULLIF(Referencia,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (Referencia varchar(255))
SELECT @Observaciones =  NULLIF(Observaciones,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (Observaciones varchar(255))
SELECT @EstatusNuevo =  NULLIF(EstatusNuevo,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (EstatusNuevo varchar(255))
SELECT @Proveedor =  NULLIF(Proveedor,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (Proveedor varchar(255))
SELECT @ProveedorMoneda =  NULLIF(ProveedorMoneda,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (ProveedorMoneda varchar(255))
SELECT @Condicion =  NULLIF(Condicion,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (Condicion varchar(255))
SELECT @Vencimiento = CONVERT(datetime,Vencimiento) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (Vencimiento varchar(255))
SELECT @FormaPago =  NULLIF(FormaPago,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (FormaPago varchar(255))
SELECT @Importe = CONVERT(money,Importe) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (Importe varchar(255))
SELECT @Impuestos = CONVERT(money,Impuestos) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (Impuestos varchar(255))
SELECT @Retencion = CONVERT(money,Retencion) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (Retencion varchar(255))
SELECT @Retencion2 = CONVERT(money,Retencion2) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (Retencion2 varchar(255))
SELECT @Retencion3 = CONVERT(money,Retencion3) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (Retencion3 varchar(255))
SELECT @Saldo = CONVERT(money,Saldo) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (Saldo varchar(255))
SELECT @OrigenTipo =  NULLIF(OrigenTipo,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (OrigenTipo varchar(255))
SELECT @Origen =  NULLIF(Origen,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (Origen varchar(255))
SELECT @OrigenID =  NULLIF(OrigenID,'') FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (OrigenID varchar(255))
SELECT @GenerarPoliza = CONVERT(bit,GenerarPoliza) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (GenerarPoliza varchar(255))
SELECT @FechaRegistro = CONVERT(datetime,FechaRegistro) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (FechaRegistro varchar(255))
SELECT @DescuentoProntoPago = CONVERT(float,DescuentoProntoPago) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (DescuentoProntoPago varchar(255))
SELECT @Sucursal = CONVERT(int,Sucursal) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (Sucursal varchar(255))
SELECT @AplicaManual = CONVERT(bit,AplicaManual) FROM openxml (@iSolicitud,'/Intelisis/Solicitud/Cxp')
WITH (AplicaManual varchar(255))
END
IF @Ok IS NULL
BEGIN
SET @Estatus = 'SINAFECTAR'
IF @EstatusNuevo = 'BORRADOR' SET @Estatus = 'BORRADOR'
IF NOT EXISTS(SELECT * FROM Prov WITH(NOLOCK) WHERE Proveedor = @Proveedor ) SELECT @Ok = 26050
IF NOT EXISTS(SELECT * FROM Proy WITH(NOLOCK) WHERE Proyecto = @Proyecto ) AND NULLIF(@Proyecto,'') IS NOT NULL SELECT @Ok = 15010
IF NOT EXISTS(SELECT * FROM UEN WITH(NOLOCK) WHERE UEN = @UEN ) AND NULLIF(@UEN,'') IS NOT NULL SELECT @Ok = 10070
IF NOT EXISTS(SELECT * FROM Concepto WITH(NOLOCK) WHERE Concepto = @Concepto AND Modulo = 'CXP') AND NULLIF(@Concepto,'') IS NOT NULL SELECT @Ok = 20485
SELECT
@ProveedorMoneda = ISNULL(@ProveedorMoneda,DefMoneda),
@Condicion = ISNULL(@Condicion,Condicion)
FROM Prov WITH(NOLOCK)
WHERE Proveedor = @Proveedor
IF NOT EXISTS(SELECT * FROM WITH(NOLOCK) Condicion WHERE Condicion = @Condicion ) AND NULLIF(@Condicion,'') IS NOT NULL SELECT @Ok = 30030
IF NOT EXISTS(SELECT * FROM WITH(NOLOCK) Mon WHERE Moneda = @ProveedorMoneda ) AND NULLIF(@ProveedorMoneda,'') IS NOT NULL SELECT @Ok = 20196
IF NOT EXISTS(SELECT * FROM WITH(NOLOCK) Mon WHERE Moneda = @Moneda ) AND NULLIF(@Moneda,'') IS NOT NULL SELECT @Ok = 20196
SELECT
@ProveedorTipoCambio = TipoCambio
FROM Mon WITH(NOLOCK)
WHERE Moneda = @ProveedorMoneda
SELECT
@Condicion = ISNULL(@Condicion,Condicion)
FROM Prov WITH(NOLOCK)
WHERE Proveedor = @Proveedor
SELECT
@FormaPago = ISNULL(@FormaPago,FormaPago)
FROM Prov WITH(NOLOCK)
WHERE Proveedor = @Proveedor
END
IF @Ok IS NULL
BEGIN
INSERT INTO Cxp (Empresa,  Mov,  MovID,  FechaEmision,  Concepto,  Proyecto,  UEN,  Moneda,  TipoCambio,  Usuario,  Referencia,  Observaciones,  Estatus,  Proveedor,  ProveedorMoneda,  ProveedorTipoCambio,  Condicion,  Vencimiento,  FormaPago,  Importe,  Impuestos,  Retencion,  Retencion2,  Retencion3,  Saldo,  OrigenTipo,  Origen,  OrigenID,  GenerarPoliza,  FechaRegistro,  DescuentoProntoPago,  Sucursal)
VALUES (@Empresa, @Mov, @MovID, @FechaEmision, @Concepto, @Proyecto, @UEN, @Moneda, @TipoCambio, @Usuario, @Referencia, @Observaciones, @Estatus, @Proveedor, @ProveedorMoneda, @ProveedorTipoCambio, @Condicion, @Vencimiento, @FormaPago, @Importe, @Impuestos, @Retencion, @Retencion2, @Retencion3, @Saldo, @OrigenTipo, @Origen, @OrigenID, @GenerarPoliza, @FechaRegistro, @DescuentoProntoPago, @Sucursal)
IF @@ERROR <> 0 SET @Ok = 1
SET @IDGenerar = SCOPE_IDENTITY()
END
SELECT @RenglonSub = 0
INSERT @Temp (Importe, Aplica, AplicaID)
SELECT Importe, Aplica, AplicaID
FROM OPENXML (@iSolicitud, '/Intelisis/Solicitud/Cxp/DetalleCxp',1)
WITH (Importe varchar(100), Aplica varchar(100), AplicaID varchar(100))
SELECT @Suma = SUM(Importe) FROM @Temp
IF @Suma <> (@Importe + @Impuestos) AND @AplicaManual = 1 SET @Ok = 30230
IF @AplicaManual = 1
BEGIN
DECLARE crDetalle CURSOR FOR
SELECT Importe, Aplica, AplicaID
FROM @Temp
SET @Renglon = 0.0
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO @DImporte,@Aplica,@AplicaID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SET @Renglon = @Renglon + 2048.0
INSERT CxpD ( ID,   Renglon,  RenglonSub,  Importe,  Aplica,  AplicaID,  Sucursal)
VALUES (@IDGenerar, @Renglon, @RenglonSub, @DImporte,@Aplica, @AplicaID, @Sucursal)
IF @@ERROR <> 0 SET @Ok = 1
FETCH NEXT FROM crDetalle INTO @DImporte,@Aplica,@AplicaID
END
CLOSE crDetalle
DEALLOCATE crDetalle
END
IF @Ok IS NULL AND @Estatus = 'SINAFECTAR'
EXEC spAfectar 'CXP', @IDGenerar, 'AFECTAR', 'Todo', NULL, @Usuario, NULL, 1, @Ok OUTPUT, @OkRef OUTPUT, NULL, 1, @@SPID
SELECT @ReferenciaIS = Referencia
FROM IntelisisService WITH(NOLOCK)
WHERE ID = @ID
SET @Resultado = '<Intelisis Sistema="Intelisis" Contenido="Resultado" Referencia=' + CHAR(34) + ISNULL(@ReferenciaIS,'') + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Resultado IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'') + CHAR(34) + ' Modulo="CXP" ModuloID =' + CHAR(34) + ISNULL(CONVERT(varchar,@IDGenerar),'') + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34) + '/></Intelisis>'
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
END ELSE
BEGIN
ROLLBACK TRANSACTION
END
END

