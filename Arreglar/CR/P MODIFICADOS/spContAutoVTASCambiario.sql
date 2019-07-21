SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContAutoVTASCambiario
@Empresa				varchar(5),
@Sucursal				int,
@Modulo					varchar(5),
@ID						int,
@Mov					varchar(20),
@MovID					varchar(20),
@MovTipo				varchar(20),
@Orden					int,
@Debe					varchar(20),
@Haber					varchar(20),
@Cta					varchar(20),
@ContUso				varchar(20),
@ContUso2				varchar(20),
@ContUso3				varchar(20),
@Concepto				varchar(50),
@ContactoSubTipo		varchar(20),
@ContAutoContactoEsp	varchar(50),
@Contacto				varchar(10),
@ContactoAplica			varchar(10),
@CtaDinero				varchar(10),
@CtaDineroDestino		varchar(10),
@Ok						int				OUTPUT,
@OkRef					varchar(255)	OUTPUT,
@ContactoTipo			varchar(20) 

AS BEGIN
DECLARE @ImporteTotalMN			float,
@TipoCambio				float,
@ContactoTipoCambio		float,
@IVAMN					float,
@IEPSMN					float,
@ImporteAplicaMN			float,
@IVAAplicaMN				float,
@IEPSAplicaMN				float,
@Diferencia				float,
@DiferenciaIVA			float,
@DiferenciaIEPS			float,
@CxID						int,
@ContactoEspecifico		varchar(10),
@Agente					varchar(10),
@Personal					varchar(10)
CREATE TABLE #Anticipo(
ID				int			NULL,
Mov				varchar(20)	NULL,
MovID			varchar(20)	NULL,
Importe			float		NULL,
TipoCambio		float		NULL,
IVAFiscal		float		NULL,
IEPSFiscal		float		NULL
)
SELECT @ContactoEspecifico = dbo.fnContactoEspecifico(@ContAutoContactoEsp, @Contacto, @ContactoAplica, NULL, @Agente, @Personal, @CtaDinero, @CtaDineroDestino, NULL, NULL, NULL)
INSERT INTO #Anticipo(
ID,   Mov,   MovID,   Importe,   TipoCambio, IVAFiscal,              IEPSFiscal)
SELECT c.ID, c.Mov, c.MovID, v.Importe, c.TipoCambio, ISNULL(c.IVAFiscal, 0), ISNULL(c.IEPSFiscal , 0)
FROM VentaFacturaAnticipo v WITH (NOLOCK)
JOIN Cxc c WITH (NOLOCK) ON v.CxcID = c.ID
WHERE v.ID = @ID
SELECT @CxID = ID, @Agente = Agente, @Personal = PersonalCobrador FROM Cxc WITH (NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID
SELECT @TipoCambio = TipoCambio FROM Venta WITH (NOLOCK) WHERE ID = @ID
SELECT @ImporteTotalMN = SUM(Importe*TipoCambio) FROM #Anticipo
SELECT @ContactoTipoCambio = ClienteTipoCambio FROM Cxc WITH (NOLOCK) WHERE ID = @CxID
IF @TipoCambio <> 1.0 OR @ContactoTipoCambio <> 1.0
BEGIN
SELECT @IVAMN = SUM(Importe*TipoCambio*IVAFiscal), @IEPSMN = SUM(Importe*TipoCambio*IEPSFiscal) FROM #Anticipo
SELECT @ImporteAplicaMN = AnticiposFacturados*TipoCambio,
@IVAAplicaMN = AnticiposFacturados*IVAFiscal/@ContactoTipoCambio*TipoCambio,
@IEPSAplicaMN = AnticiposFacturados*IEPSFiscal/@ContactoTipoCambio*TipoCambio
FROM Venta WITH (NOLOCK)
WHERE ID = @ID
SELECT @Diferencia = @ImporteTotalMN - @ImporteAplicaMN
SELECT @DiferenciaIVA = @IVAMN - @IVAAplicaMN,
@DiferenciaIEPS = @IEPSMN - @IEPSAplicaMN
IF ISNULL(@Diferencia, 0) <> 0
BEGIN
IF @Debe   = 'ANT FACT. DIFEREN C' INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe)  VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, ABS(@Diferencia)) ELSE
IF @Haber  = 'ANT FACT. DIFEREN C' INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Haber) VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, ABS(@Diferencia)) ELSE
IF @Debe   = 'ANT FACT. UTILIDAD C'   AND @Diferencia > 0 INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe)   VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, @Diferencia) ELSE
IF @Haber  = 'ANT FACT. UTILIDAD C'   AND @Diferencia > 0 INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Haber)  VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, @Diferencia) ELSE
IF @Debe   = 'ANT FACT. PERDIDA C'    AND @Diferencia < 0 INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe)   VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, -@Diferencia) ELSE
IF @Haber  = 'ANT FACT. PERDIDA C'    AND @Diferencia < 0 INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Haber)  VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, -@Diferencia) 
/*IF @Debe   = 'IVA DIF. CAMBIARIA'  INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe)  VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, @DiferenciaIVA)  ELSE
IF @Haber  = 'IVA DIF. CAMBIARIA'  INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Haber) VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, @DiferenciaIVA)  ELSE
IF @Debe   = 'IVA UTI. CAMBIARIA'  AND @DiferenciaIVA > 0 INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe)  VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, @DiferenciaIVA) ELSE
IF @Haber  = 'IVA UTI. CAMBIARIA'  AND @DiferenciaIVA > 0 INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Haber) VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, @DiferenciaIVA) ELSE
IF @Debe   = 'IVA PER. CAMBIARIA'  AND @DiferenciaIVA < 0 INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe)  VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, -@DiferenciaIVA) ELSE
IF @Haber  = 'IVA PER. CAMBIARIA'  AND @DiferenciaIVA < 0 INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Haber) VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, -@DiferenciaIVA) ELSE
IF @Debe   = 'IEPS DIF. CAMBIARIA' INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe)  VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, @DiferenciaIEPS) ELSE
IF @Haber  = 'IEPS DIF. CAMBIARIA' INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Haber) VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, @DiferenciaIEPS) ELSE
IF @Debe   = 'IEPS UTI. CAMBIARIA' AND @DiferenciaIEPS > 0 INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe)  VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, @DiferenciaIEPS)  ELSE
IF @Haber  = 'IEPS UTI. CAMBIARIA' AND @DiferenciaIEPS > 0 INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Haber) VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, @DiferenciaIEPS)  ELSE
IF @Debe   = 'IEPS PER. CAMBIARIA' AND @DiferenciaIEPS < 0 INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Debe)  VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, -@DiferenciaIEPS) ELSE
IF @Haber  = 'IEPS PER. CAMBIARIA' AND @DiferenciaIEPS < 0 INSERT #Poliza (Orden, Cuenta, SubCuenta, SubCuenta2, SubCuenta3, Concepto, ContactoEspecifico, Haber) VALUES (@Orden, @Cta, @ContUso, @ContUso2, @ContUso3, @Concepto, @ContactoEspecifico, -@DiferenciaIEPS)  */
END
END
RETURN
END

