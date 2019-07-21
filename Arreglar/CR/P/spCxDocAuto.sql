SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCxDocAuto
@Modulo	      	char(5),
@ID			int,
@Usuario		char(10),
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS BEGIN
DECLARE
@Sucursal		int,
@Empresa	      	char(5),
@Mov	  	      	char(20),
@MovID             	varchar(20),
@MovMoneda	      	char(10),
@Contacto		char(10),
@FechaEmision      	datetime,
@Condicion		varchar(50),
@Vencimiento      	datetime,
@Concepto	      	varchar(50),
@Observaciones     	varchar(255),
@MovNCargo		char(20),
@MovDocumento		char(20),
@DAID			int,
@DANumeroDocumentos	int,
@DADiaEspecifico	int,
@DAInteres		float,
@DATipoInteres	varchar(20),
@DAInteresImpuesto	float,
@DAInteresConcepto	varchar(50),
@DAPeriodo		char(15),
@DAImpPrimerDoc	bit,
@ImporteDocumentar	money,
@Intereses		money,
@InteresesImpuestos	money,
@ImporteDocumento	money,
@Interes		float
SELECT @Interes = NULL
IF @Modulo = 'CXC' SELECT @Sucursal = Sucursal, @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @MovMoneda = Moneda, @Contacto = Cliente,   @FechaEmision = FechaEmision, @Condicion = Condicion, @Vencimiento = Vencimiento, @Concepto = Concepto, @Observaciones = Observaciones, @ImporteDocumentar  = NULLIF(Saldo, 0) FROM Cxc WHERE ID = @ID ELSE
IF @Modulo = 'CXP' SELECT @Sucursal = Sucursal, @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @MovMoneda = Moneda, @Contacto = Proveedor, @FechaEmision = FechaEmision, @Condicion = Condicion, @Vencimiento = Vencimiento, @Concepto = Concepto, @Observaciones = Observaciones, @ImporteDocumentar  = NULLIF(Saldo, 0) FROM Cxp WHERE ID = @ID
IF @ImporteDocumentar IS NULL RETURN
SELECT @MovNCargo    = CASE WHEN @Modulo = 'CXC' THEN NULLIF(RTRIM(CxcNCargo), '')    ELSE NULLIF(RTRIM(CxpCargoProveedor), '')    END,
@MovDocumento = CASE WHEN @Modulo = 'CXC' THEN NULLIF(RTRIM(CxcDocumento), '') ELSE NULLIF(RTRIM(CxpDocumento), '') END
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT @DANumeroDocumentos = ISNULL(DANumeroDocumentos, 0), @DATipoInteres = DATipoInteres, @DAInteres = DAInteres, @DAInteresImpuesto = DAInteresImpuesto, @DAInteresConcepto = DAInteresConcepto, @DAPeriodo = NULLIF(RTRIM(DAPeriodo), ''), @DAImpPrimerDoc = ISNULL(DAImpPrimerDoc, 0), @DADiaEspecifico = NULLIF(DADiaEspecifico, 0)
FROM Condicion
WHERE Condicion = @Condicion
IF @DATipoInteres = 'Saldos Insolutos'
BEGIN
SELECT @ImporteDocumento = (@ImporteDocumentar * (@DAInteres/100.0)) / (1-(POWER(1+(@DAInteres/100.0), -@DANumeroDocumentos)))
SELECT @Intereses = ROUND((@ImporteDocumento * @DANumeroDocumentos) - @ImporteDocumentar, 2)
SELECT @Interes = @DAInteres * (1+(ISNULL(@DAInteresImpuesto, 0)/100.0))
END ELSE
SELECT @Intereses = @ImporteDocumentar * (@DAInteres/100.0)
SELECT @InteresesImpuestos = @Intereses * (@DAInteresImpuesto/100.0)
IF @DANumeroDocumentos = 0 OR @DAPeriodo IS NULL SELECT @Ok = 20700
IF @DADiaEspecifico IS NOT NULL
EXEC spVencimientoDiaEspecifico @FechaEmision, @DADiaEspecifico, @Vencimiento OUTPUT
IF @Ok IS NULL
IF @Modulo IN ('CXC', 'CXP')
EXEC spRevisarVencimiento @Modulo, @ID, @Vencimiento OUTPUT
IF @Ok IS NULL
BEGIN
INSERT DocAuto (Sucursal, Empresa,  Modulo,  Cuenta,    Moneda,     Mov,  MovID,  ImporteDocumentar,  Intereses,  InteresesImpuestos,  InteresesConcepto,  NumeroDocumentos,    PrimerVencimiento, Periodo,    Concepto,  Observaciones,  Estatus,      Usuario,  FechaEmision,  ImpPrimerDoc, Condicion, Interes)
VALUES (@Sucursal, @Empresa, @Modulo, @Contacto, @MovMoneda, @Mov, @MovID, @ImporteDocumentar, @Intereses, @InteresesImpuestos, @DAInteresConcepto, @DANumeroDocumentos, @Vencimiento,      @DAPeriodo, @Concepto, @Observaciones, 'SINAFECTAR', @Usuario, @FechaEmision, @DAImpPrimerDoc, @Condicion, @Interes)
SELECT @DAID = SCOPE_IDENTITY()
EXEC spDocAuto @DAID, @MovNCargo, @MovDocumento, @Usuario, 1, 0, @Ok OUTPUT, @OkRef OUTPUT
END
RETURN
END

