SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDepositoAnticipado
@Sucursal		int,
@Accion		char(20),
@ID			int,
@Mov			char(20),
@MovID		varchar(20),
@Empresa		char(5),
@Modulo	      	char(5),
@CtaDinero		char(10),
@ImporteTotal	money,
@MovMoneda	      	char(10),
@RedondeoMonetarios	int,
@ConDesglose		bit,
@FormaPago		varchar(50),
@FormaPagoDA		varchar(50),
@Referencia		varchar(50),
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS BEGIN
DECLARE
@CfgDARef		bit,
@Importe1		money,
@Importe2		money,
@Importe3		money,
@Importe4		money,
@Importe5		money,
@FormaPago1		varchar(50),
@FormaPago2		varchar(50),
@FormaPago3		varchar(50),
@FormaPago4		varchar(50),
@FormaPago5		varchar(50),
@Referencia1	varchar(50),
@Referencia2	varchar(50),
@Referencia3	varchar(50),
@Referencia4	varchar(50),
@Referencia5	varchar(50)
IF @Modulo IN ('CXP', 'AGENT', 'GAS') SELECT @ConDesglose = 0
SELECT @CfgDARef = ISNULL(CxcDARef, 0) FROM EmpresaCfg WHERE Empresa = @Empresa
IF @ConDesglose = 0
EXEC spDepositoAnticipadoAfectar @Sucursal, @Accion, @ID, @Mov, @MovID, @Empresa, @Modulo, @CtaDinero, @ImporteTotal, @MovMoneda, @RedondeoMonetarios, @ConDesglose, @FormaPago, @FormaPagoDA, @Referencia, @CfgDARef, @Ok OUTPUT, @OkRef OUTPUT
ELSE BEGIN
SELECT @Importe1 = ISNULL(Importe1, 0.0), @Importe2 = ISNULL(Importe2, 0.0), @Importe3 = ISNULL(Importe3, 0.0), @Importe4 = ISNULL(Importe4, 0.0), @Importe5 = ISNULL(Importe5, 0.0),
@FormaPago1 = FormaCobro1, @FormaPago2 = FormaCobro2, @FormaPago3 = FormaCobro3, @FormaPago4 = FormaCobro4, @FormaPago5 = FormaCobro5,
@Referencia1 = Referencia1, @Referencia2 = Referencia2, @Referencia3 = Referencia3, @Referencia4 = Referencia4, @Referencia5 = Referencia5
FROM Cxc
WHERE ID = @ID
IF @Importe1 <> 0.0 EXEC spDepositoAnticipadoAfectar @Sucursal, @Accion, @ID, @Mov, @MovID, @Empresa, @Modulo, @CtaDinero, @Importe1, @MovMoneda, @RedondeoMonetarios, @ConDesglose, @FormaPago1, @FormaPagoDA, @Referencia1, @CfgDARef, @Ok OUTPUT, @OkRef OUTPUT
IF @Importe2 <> 0.0 EXEC spDepositoAnticipadoAfectar @Sucursal, @Accion, @ID, @Mov, @MovID, @Empresa, @Modulo, @CtaDinero, @Importe2, @MovMoneda, @RedondeoMonetarios, @ConDesglose, @FormaPago2, @FormaPagoDA, @Referencia2, @CfgDARef, @Ok OUTPUT, @OkRef OUTPUT
IF @Importe3 <> 0.0 EXEC spDepositoAnticipadoAfectar @Sucursal, @Accion, @ID, @Mov, @MovID, @Empresa, @Modulo, @CtaDinero, @Importe3, @MovMoneda, @RedondeoMonetarios, @ConDesglose, @FormaPago3, @FormaPagoDA, @Referencia3, @CfgDARef, @Ok OUTPUT, @OkRef OUTPUT
IF @Importe4 <> 0.0 EXEC spDepositoAnticipadoAfectar @Sucursal, @Accion, @ID, @Mov, @MovID, @Empresa, @Modulo, @CtaDinero, @Importe4, @MovMoneda, @RedondeoMonetarios, @ConDesglose, @FormaPago4, @FormaPagoDA, @Referencia4, @CfgDARef, @Ok OUTPUT, @OkRef OUTPUT
IF @Importe5 <> 0.0 EXEC spDepositoAnticipadoAfectar @Sucursal, @Accion, @ID, @Mov, @MovID, @Empresa, @Modulo, @CtaDinero, @Importe5, @MovMoneda, @RedondeoMonetarios, @ConDesglose, @FormaPago5, @FormaPagoDA, @Referencia5, @CfgDARef, @Ok OUTPUT, @OkRef OUTPUT
END
RETURN
END

