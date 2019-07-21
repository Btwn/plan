SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCxcVoucherAfectar
@ID		int

AS BEGIN
DECLARE
@Empresa		char(5),
@Usuario		char(10),
@Cliente		char(10),
@Mov		varchar(20),
@CxcMov		varchar(20),
@CxcMovID		varchar(20),
@FechaEmision	datetime,
@IDAplica		int,
@Aplica		varchar(20),
@AplicaID		varchar(20),
@AplicaImporte	money,
@AplicaImpuestos	money,
@Referencia		varchar(50),
@Concepto		varchar(50),
@Cargo		money,
@Abono		money,
@ImporteTotal	money,
@Importe		money,
@Renglon		float,
@Impuesto		float,
@EnviarA		int,
@Nuevo		bit,
@Aceptar		bit,
@Ok			int,
@OkRef		varchar(255),
@Mensaje		varchar(255),
@MovNCredito	varchar(20),
@MovNCargo		varchar(20),
@EsReferencia	bit,
@EsCredito		bit,
@FechaRegistro	datetime
SELECT @Ok = NULL, @OkRef = NULL, @FechaRegistro = GETDATE()
SELECT @FechaEmision = FechaEmision, @Empresa = Empresa, @Usuario = Usuario, @ImporteTotal = ISNULL(Importe, 0.0) + ISNULL(Impuestos, 0.0),
@CxcMov = Mov, @CxcMovID = MovID
FROM Cxc
WHERE ID = @ID
SELECT @MovNCredito = CxcNCreditoVoucher,
@MovNCargo   = CxcNCargoVoucher
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
BEGIN TRANSACTION
EXEC xpCxcVoucherAfectar @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @CxcMovID IS NULL AND @Ok IS NULL
BEGIN
EXEC spCx @ID, 'CXC', 'CONSECUTIVO', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@CxcMov OUTPUT, @CxcMovID OUTPUT, NULL,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok = 80060 SELECT @Ok = NULL, @OkRef = NULL
END
UPDATE Cxc SET AplicaManual = 1 WHERE ID = @ID
DELETE CxcD WHERE ID = @ID
SELECT @Renglon = 0.0
DECLARE crCxcVoucher CURSOR FOR
SELECT Mov, NULLIF(RTRIM(Referencia), ''), NULLIF(RTRIM(Concepto), ''), NULLIF(EnviarA, 0), ISNULL(Cargo, 0.0), ISNULL(Abono, 0.0), ISNULL(Nuevo, 0), ISNULL(Aceptar, 0)
FROM CxcVoucher
WHERE ID = @ID
OPEN crCxcVoucher
FETCH NEXT FROM crCxcVoucher INTO @Mov, @Referencia, @Concepto, @EnviarA, @Cargo, @Abono, @Nuevo, @Aceptar
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Importe = @Cargo - @Abono,
@EsReferencia = 0,
@EsCredito = 0
IF @Importe <> 0.0
BEGIN
IF @Nuevo = 1
BEGIN
EXEC spCteImpuesto @Empresa, @Cliente, @EnviarA, @Impuesto OUTPUT
IF @Importe < 0.0 SELECT @EsCredito = 1
IF @Aceptar = 1
SELECT @Aplica = @Mov
ELSE BEGIN
SELECT @EsCredito = ~@EsCredito
SELECT @Aplica = NULL
SELECT @Aplica = NULLIF(RTRIM(MovGenerar), '') FROM EmpresaCfgCxcVoucher WHERE Empresa = @Empresa AND Mov = @Mov
IF @Aplica IS NULL
IF @EsCredito = 1 SELECT @Aplica = @MovNCredito ELSE SELECT @Aplica = @MovNCargo
END
SELECT @AplicaImporte = ABS(@Importe) / (1+(@Impuesto/100.0))
SELECT @AplicaImpuestos = ABS(@Importe) - @AplicaImporte
INSERT Cxc (
Sucursal, Empresa, Mov,     FechaEmision, Proyecto, Moneda,         TipoCambio,       Usuario, Referencia,  Estatus,      Concepto,  Cliente, ClienteEnviarA,                   ClienteMoneda, ClienteTipoCambio,  Condicion, Vencimiento,  Importe,        Impuestos,        AplicaManual, OrigenTipo, Origen, OrigenID)
SELECT Sucursal, Empresa, @Aplica, FechaEmision, Proyecto, ClienteMoneda, ClienteTipoCambio, Usuario, @Referencia, 'SINAFECTAR', @Concepto, Cliente, ISNULL(@EnviarA, ClienteEnviarA), ClienteMoneda, ClienteTipoCambio, '(Fecha)',  FechaEmision, @AplicaImporte, @AplicaImpuestos, 0,            'CXC',      Mov,    MovID
FROM Cxc
WHERE ID = @ID
SELECT @IDAplica = SCOPE_IDENTITY()
UPDATE CxcVoucher SET IDAplica = @IDAplica WHERE CURRENT OF crCxcVoucher
EXEC spCx @IDAplica, 'CXC', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@Aplica OUTPUT, @AplicaID OUTPUT, NULL,
@Ok OUTPUT, @OkRef OUTPUT
IF @Aceptar = 0 SELECT @EsReferencia = 1
END ELSE
SELECT @Aplica = @Mov, @AplicaID = @Referencia
SELECT @Renglon = @Renglon + 2048.0
INSERT CxcD
(ID,  Renglon,  Aplica,  AplicaID,  Importe,  EsReferencia)
VALUES (@ID, @Renglon, @Aplica, @AplicaID, @Importe, @EsReferencia)
END
END
FETCH NEXT FROM crCxcVoucher INTO @Mov, @Referencia, @Concepto, @EnviarA, @Cargo, @Abono, @Nuevo, @Aceptar
END
CLOSE crCxcVoucher
DEALLOCATE crCxcVoucher
IF @Ok IS NULL
BEGIN
EXEC spCx @ID, 'CXC', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@CxcMov OUTPUT, @CxcMovID OUTPUT, NULL,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
END
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
IF @Ok IS NULL
SELECT @Mensaje = 'Voucher Afectado con Exito.'
ELSE
SELECT @Mensaje = Descripcion+' '+RTRIM(ISNULL(@OkRef, '')) FROM MensajeLista WHERE Mensaje = @Ok
SELECT @Mensaje
RETURN
END

