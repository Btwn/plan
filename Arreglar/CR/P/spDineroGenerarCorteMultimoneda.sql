SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDineroGenerarCorteMultimoneda
@Accion			varchar(20),
@Empresa          		varchar(5),
@Sucursal	      		int,
@Usuario			varchar(10),
@ID               		int,
@Mov			varchar(20),
@MovID			varchar(20),
@MovTipo                    varchar(20),
@SubClave                   varchar(20),
@Estatus                    varchar(15),
@EstatusNuevo               varchar(15),
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT

AS BEGIN
DECLARE
@Moneda               varchar(10),
@MonedaCont           varchar(10),
@DineroID             int,
@DineroMov            varchar(20),
@CorteMov             varchar(20),
@CtaDinero            varchar(10),
@CtaDineroDestino	  varchar(10),
@Importe              money,
@ImporteTotal         money,
@FormaPago            varchar(50),
@Referencia           varchar(50),
@Renglon              float,
@SucursalD            int,
@MovIDGenerar         varchar(20),
@TipoCambio           float,
@OModulo              varchar(20),
@OID                  int,
@FechaEmision         datetime,
@RID                  int,
@LID                  int
DECLARE @Tabla table
(
ID                   int IDENTITY(1,1),
Moneda               varchar(10),
CtaDinero            varchar(10),
CtaDineroDestino     varchar(10),
TipoCambio           float
)
SELECT @MonedaCont = ContMoneda
FROM EmpresaCfg
WHERE Empresa = @Empresa
INSERT @Tabla(Moneda,CtaDinero,CtaDineroDestino,TipoCambio)
SELECT d.Moneda,d.CtaDinero,d.CtaDineroDestino,d.TipoCambio
FROM DineroD d JOIN CtaDinero c ON d.CtaDinero = c.CtaDinero
WHERE d.ID = @ID
GROUP BY d.Moneda, d.CtaDinero, d.CtaDineroDestino, d.TipoCambio
SELECT @RID = MAX(ID) FROM @Tabla
SET @FechaEmision = dbo.fnFechaSinHora(GETDATE())
SELECT @DineroMov =  CajaCorteParc
FROM EmpresaCfgMovDinero WHERE Empresa = @Empresa
IF @Accion = 'AFECTAR'  AND @MovTipo = 'DIN.C'   AND @SubClave ='DIN.CMULTIMONEDA' AND @EstatusNuevo = 'CONCLUIDO'
BEGIN
DECLARE crMoneda CURSOR FOR
SELECT ID, Moneda,CtaDinero,CtaDineroDestino,TipoCambio
FROM @Tabla
ORDER BY ID ASC
OPEN crMoneda
FETCH NEXT FROM crMoneda INTO @LID, @Moneda, @CtaDinero, @CtaDineroDestino, @TipoCambio
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF @Moneda IS NULL
SELECT @Ok = 35040
IF @LID = @RID
SELECT @DineroMov = CajaCorteCaja
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
IF @Ok IS NULL
INSERT Dinero (Sucursal,  SucursalOrigen,  SucursalDestino,  Empresa, Mov,         FechaEmision,  Concepto,  Proyecto,  Moneda,  TipoCambio,  Usuario, Referencia, Observaciones, Estatus,      CtaDinero, CtaDineroDestino, Cajero,   ConDesglose, Prioridad)
SELECT         Sucursal,  SucursalOrigen,  SucursalDestino,  Empresa, @DineroMov,  @FechaEmision, Concepto,  Proyecto,  @Moneda, @TipoCambio, Usuario, Referencia, Observaciones, 'SINAFECTAR', @CtaDinero, @CtaDineroDestino,Cajero,   1,          Prioridad
FROM Dinero WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @DineroID = SCOPE_IDENTITY()
IF @Ok IS NULL  AND EXISTS(SELECT * FROM DineroD WHERE ID = @ID AND CtaDinero =@CtaDinero AND CtaDineroDestino = @CtaDineroDestino AND Moneda = @Moneda)
BEGIN
DECLARE crDetalle CURSOR FOR
SELECT d.Importe ,d.FormaPago,d.Referencia,d.Sucursal
FROM DineroD d JOIN CtaDinero c ON d.CtaDinero = c.CtaDinero
WHERE d.ID = @ID
AND  d.CtaDinero =@CtaDinero
AND d.CtaDineroDestino = @CtaDineroDestino
AND d.Moneda = @Moneda
SET @Renglon = 2048.0
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO @Importe, @FormaPago, @Referencia,@SucursalD
WHILE @@FETCH_STATUS = 0 
BEGIN
INSERT DineroD (Sucursal,   ID,         Renglon,  Importe,  FormaPago,  Referencia)
SELECT          @SucursalD, @DineroID,  @Renglon, @Importe, @FormaPago, @Referencia
IF @@ERROR <> 0 SELECT @Ok = 1
SET @Renglon = @Renglon + 2048.0
FETCH NEXT FROM crDetalle INTO  @Importe, @FormaPago, @Referencia,@SucursalD
END
CLOSE crDetalle
DEALLOCATE crDetalle
END
IF NOT EXISTS(SELECT * FROM DineroD WHERE ID = @ID AND CtaDinero =@CtaDinero AND CtaDineroDestino = @CtaDineroDestino AND Moneda = @Moneda)
BEGIN
INSERT DineroD (Sucursal,   ID,         Renglon,  Importe,  FormaPago,  Referencia)
SELECT          @Sucursal, @DineroID,  2048.0,   0.0,       NULL,      NULL
IF @@ERROR <> 0 SELECT @Ok = 1
END
IF @Ok IS NULL AND @DineroID IS NOT NULL
BEGIN
SELECT @ImporteTotal = SUM(Importe) FROM DineroD WHERE ID = @DineroID
UPDATE Dinero SET Importe = ISNULL(@ImporteTotal,0.0) WHERE ID = @DineroID
IF @@ERROR <> 0 SET @Ok = 1
EXEC spAfectar 'DIN', @DineroID, 'AFECTAR', 'Todo', NULL, @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @MovIDGenerar = MovID FROM Dinero WHERE ID = @DineroID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'DIN', @ID, @Mov, @MovID, 'DIN', @DineroID, @DineroMov, @MovIDGenerar, @Ok OUTPUT
END
FETCH NEXT FROM crMoneda INTO  @LID, @Moneda, @CtaDinero, @CtaDineroDestino, @TipoCambio
END
CLOSE crMoneda
DEALLOCATE crMoneda
END
END

