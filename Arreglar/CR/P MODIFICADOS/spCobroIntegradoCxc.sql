SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCobroIntegradoCxc
@Sucursal			int,
@SucursalOrigen		int,
@SucursalDestino		int,
@Accion			char(20),
@Modulo			char(5),
@Empresa	      		char(5),
@Usuario                     char(10),
@ID				int,
@Mov				char(20),
@MovID             		varchar(20),
@MovTipo     		char(20),
@MovMoneda                   char(10),
@MovTipoCambio               float,
@FechaRegistro               datetime,
@DineroImporte               money,
@CobroDelEfectivo            money,
@CobroCambio                 money,
@FormaCobro1                 varchar(50),
@FormaCobro2                 varchar(50),
@FormaCobro3                 varchar(50),
@FormaCobro4                 varchar(50),
@FormaCobro5                 varchar(50),
@Importe1                    money,
@Importe2                    money,
@Importe3                    money,
@Importe4                    money,
@Importe5                    money,
@Referencia1                 varchar(50),
@Referencia2                 varchar(50),
@Referencia3                 varchar(50),
@Referencia4                 varchar(50),
@Referencia5                 varchar(50),
@CtaDinero                   char(10),
@Cajero                      char(10),
@CxID                        int,
@FormaCambio					varchar(50),
@Ok							int		OUTPUT,
@OkRef						varchar(255)	OUTPUT,
@InterfazTC					bit,	
@TCDelEfectivo				float,	
@TCProcesado1				bit,	
@TCProcesado2				bit,	
@TCProcesado3				bit,	
@TCProcesado4				bit,	
@TCProcesado5				bit		

AS BEGIN
CREATE TABLE #Moneda(
Moneda				varchar(10)	COLLATE Database_Default NULL
)
DECLARE
@CobroID					int,
@CobroMov					varchar(20),
@CobroMovID					varchar(20),
@ImporteTotal				money,
@Impuestos					money,
@CobroSumaEfectivo			money,
@PorcentajeRetencion		float,
@PorcentajeRetencion1		float,
@PorcentajeRetencion2		float,
@PorcentajeRetencion3		float,
@OrigenImporte				float,
@FormaMoneda1 				varchar(10),
@FormaTipoCambio1			float,
@FormaMoneda2 				varchar(10),
@FormaTipoCambio2			float,
@FormaMoneda3 				varchar(10),
@FormaTipoCambio3			float,
@FormaMoneda4 				varchar(10),
@FormaTipoCambio4			float,
@FormaMoneda5 				varchar(10),
@FormaTipoCambio5			float,
@FormaMonedaCambio 			varchar(10),
@FormaTipoCambioCambio		float,
@Retencion1					float,
@Retencion2					float,
@Retencion3					float,
@CfgCobroImpuestos			bit,
@Moneda						varchar(10),
@MonedaAnt					varchar(10),
@TipoCambio					float
SELECT @CfgCobroImpuestos = ISNULL(CxcCobroImpuestos,0) FROM EmpresaCfg2 WITH (NOLOCK) WHERE Empresa = @Empresa	 
IF @InterfazTC = 1 
BEGIN
IF @TCProcesado1 = 1 SELECT @FormaCobro1 = NULL, @Importe1 = 0, @Referencia1 = NULL
IF @TCProcesado2 = 1 SELECT @FormaCobro2 = NULL, @Importe2 = 0, @Referencia2 = NULL
IF @TCProcesado3 = 1 SELECT @FormaCobro3 = NULL, @Importe3 = 0, @Referencia3 = NULL
IF @TCProcesado4 = 1 SELECT @FormaCobro4 = NULL, @Importe4 = 0, @Referencia4 = NULL
IF @TCProcesado5 = 1 SELECT @FormaCobro5 = NULL, @Importe5 = 0, @Referencia5 = NULL
END
SELECT @CobroSumaEfectivo = 0.0
IF @Importe1 <> 0.0 EXEC spFormaPagoMonTC @FormaCobro1, @Referencia1, @MovMoneda, @MovTipoCambio, @Importe1, @CobroSumaEfectivo OUTPUT, @FormaMoneda1 OUTPUT, @FormaTipoCambio1 OUTPUT, @Ok OUTPUT
IF @Importe2 <> 0.0 EXEC spFormaPagoMonTC @FormaCobro2, @Referencia2, @MovMoneda, @MovTipoCambio, @Importe2, @CobroSumaEfectivo OUTPUT, @FormaMoneda2 OUTPUT, @FormaTipoCambio2 OUTPUT, @Ok OUTPUT
IF @Importe3 <> 0.0 EXEC spFormaPagoMonTC @FormaCobro3, @Referencia3, @MovMoneda, @MovTipoCambio, @Importe3, @CobroSumaEfectivo OUTPUT, @FormaMoneda3 OUTPUT, @FormaTipoCambio3 OUTPUT, @Ok OUTPUT
IF @Importe4 <> 0.0 EXEC spFormaPagoMonTC @FormaCobro4, @Referencia4, @MovMoneda, @MovTipoCambio, @Importe4, @CobroSumaEfectivo OUTPUT, @FormaMoneda4 OUTPUT, @FormaTipoCambio4 OUTPUT, @Ok OUTPUT
IF @Importe5 <> 0.0 EXEC spFormaPagoMonTC @FormaCobro5, @Referencia5, @MovMoneda, @MovTipoCambio, @Importe5, @CobroSumaEfectivo OUTPUT, @FormaMoneda5 OUTPUT, @FormaTipoCambio5 OUTPUT, @Ok OUTPUT
IF ISNULL(@CobroCambio,0.0) > 0.0 EXEC spFormaPagoMonTC @FormaCambio, NULL, @MovMoneda, @MovTipoCambio, @CobroCambio, @CobroSumaEfectivo OUTPUT, @FormaMonedaCambio OUTPUT, @FormaTipoCambioCambio OUTPUT, @Ok OUTPUT
INSERT INTO #Moneda(
Moneda)
SELECT @FormaMoneda1
UNION ALL
SELECT @FormaMoneda2
UNION ALL
SELECT @FormaMoneda3
UNION ALL
SELECT @FormaMoneda4
UNION ALL
SELECT @FormaMoneda5
UNION ALL
SELECT @FormaMonedaCambio
IF ROUND(@CobroCambio, 2) <> 0.0
IF ABS(ROUND(@CobroSumaEfectivo, 2)) < ABS(ROUND(@CobroCambio, 2)) SELECT @Ok = 30590
IF @MovTipo = 'VTAS.D'
SELECT @CobroMov = CxcDevolucion
FROM EmpresaCfgMov WITH (NOLOCK)
WHERE Empresa = @Empresa
ELSE
SELECT @CobroMov = CxcCobro
FROM EmpresaCfgMov WITH (NOLOCK)
WHERE Empresa = @Empresa
SELECT @MonedaAnt = ''
WHILE(1=1)
BEGIN
SELECT @Moneda = MIN(Moneda)
FROM #Moneda
WHERE Moneda > @MonedaAnt
IF @Moneda IS NULL BREAK
SELECT @MonedaAnt = @Moneda
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL, @CobroID = NULL
SELECT @TipoCambio = TipoCambio FROM Mon WITH (NOLOCK) WHERE Moneda = @Moneda
EXEC spCx @CxID, 'CXC', 'GENERAR', 'TODO', @FechaRegistro, @CobroMov, @Usuario, 1, 0,
@CobroMov OUTPUT, @CobroMovID OUTPUT, @CobroID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
IF ROUND(@CobroCambio, 0) < 0 SELECT @CobroCambio = 0.0
IF @CobroID IS NOT NULL
BEGIN
UPDATE Cxc WITH (ROWLOCK)
SET OrigenTipo = @Modulo, Origen = @Mov, OrigenID = @MovID,
ConDesglose = 1, CtaDinero = @CtaDinero, Cajero = @Cajero, Moneda = @Moneda,
TipoCambio = @TipoCambio
WHERE ID = @CobroID
IF @FormaMoneda1 = @Moneda
UPDATE Cxc WITH (ROWLOCK) SET FormaCobro1 = @FormaCobro1, Importe1 = NULLIF(@Importe1, 0), Referencia1 = @Referencia1 WHERE ID = @CobroID
IF @FormaMoneda2 = @Moneda
UPDATE Cxc WITH (ROWLOCK) SET FormaCobro2 = @FormaCobro2, Importe2 = NULLIF(@Importe2, 0), Referencia2 = @Referencia2 WHERE ID = @CobroID
IF @FormaMoneda3 = @Moneda
UPDATE Cxc WITH (ROWLOCK) SET FormaCobro3 = @FormaCobro3, Importe3 = NULLIF(@Importe3, 0), Referencia3 = @Referencia3 WHERE ID = @CobroID
IF @FormaMoneda4 = @Moneda
UPDATE Cxc WITH (ROWLOCK) SET FormaCobro4 = @FormaCobro4, Importe4 = NULLIF(@Importe4, 0), Referencia4 = @Referencia4 WHERE ID = @CobroID
IF @FormaMoneda5 = @Moneda
UPDATE Cxc WITH (ROWLOCK) SET FormaCobro5 = @FormaCobro5, Importe5 = NULLIF(@Importe5, 0), Referencia5 = @Referencia5 WHERE ID = @CobroID
IF @FormaMonedaCambio = @Moneda
UPDATE Cxc WITH (ROWLOCK) SET Cambio = NULLIF(@CobroCambio, 0.0)/@FormaTipoCambioCambio, DelEfectivo = NULLIF(@CobroDelEfectivo, 0.0)/@FormaTipoCambioCambio WHERE ID = @CobroID
INSERT TarjetaSerieMov (Empresa, Modulo, ID, Serie, Importe, Sucursal)
SELECT @Empresa, 'CXC' , @CobroID, Serie, Importe, Sucursal
FROM TarjetaSerieMov WITH (NOLOCK)
WHERE Empresa = @Empresa AND Modulo = 'VTAS' AND ID = @ID
INSERT ValeSerieMov (Empresa, Modulo, ID, Serie, Sucursal)
SELECT @Empresa, 'CXC' , @CobroID, Serie, Sucursal
FROM ValeSerieMov WITH (NOLOCK)
WHERE Empresa = @Empresa AND Modulo = 'VTAS' AND ID = @ID
SELECT @ImporteTotal = ISNULL(Importe1, 0) + ISNULL(Importe2, 0) + ISNULL(Importe3, 0) + ISNULL(Importe4, 0) + ISNULL(Importe5, 0) + ISNULL(DelEfectivo, 0) - ISNULL(Cambio, 0)
FROM Cxc WITH (NOLOCK)
WHERE ID = @CobroID 
UPDATE CxcD WITH (ROWLOCK) SET Importe = @ImporteTotal WHERE ID = @CobroID
SELECT @Impuestos =  SUM(d.Importe*a.IVAFiscal) FROM CxcD d WITH (NOLOCK), CxcAplica a WITH (NOLOCK) WHERE d.Aplica = a.Mov AND d.AplicaID = a.MovID AND a.Empresa = @Empresa AND d.ID = @CobroID
SELECT @Retencion1 = SUM(CONVERT(float,d.Importe)*ISNULL(a.Retencion,0.0)/ISNULL(a.ImporteTotal,0.0)) FROM CxcD d WITH (NOLOCK), CxcAplica a WHERE d.Aplica = a.Mov AND d.AplicaID = a.MovID AND a.Empresa = @Empresa AND d.ID = @CobroID
SELECT @Retencion2 = SUM(CONVERT(float,d.Importe)*ISNULL(a.Retencion2,0.0)/ISNULL(a.ImporteTotal,0.0)) FROM CxcD d WITH (NOLOCK), CxcAplica a WHERE d.Aplica = a.Mov AND d.AplicaID = a.MovID AND a.Empresa = @Empresa AND d.ID = @CobroID
SELECT @Retencion3 = SUM(CONVERT(float,d.Importe)*ISNULL(a.Retencion3,0.0)/ISNULL(a.ImporteTotal,0.0)) FROM CxcD d WITH (NOLOCK), CxcAplica a WHERE d.Aplica = a.Mov AND d.AplicaID = a.MovID AND a.Empresa = @Empresa AND d.ID = @CobroID
IF @MovTipo = 'VTAS.D'
UPDATE Cxc WITH (ROWLOCK) SET Importe = @ImporteTotal, Impuestos = NULL WHERE ID = @CobroID
ELSE
IF @CfgCobroImpuestos = 1 
BEGIN 
UPDATE Cxc WITH (ROWLOCK) SET Importe = @ImporteTotal - ISNULL(@Impuestos, 0) + ISNULL(@Retencion1,0.0) + ISNULL(@Retencion2,0.0) + ISNULL(@Retencion3,0.0) , Impuestos = @Impuestos, Retencion = @Retencion1, Retencion2 = @Retencion2, Retencion3 = @Retencion3 WHERE ID = @CobroID
END 
ELSE 
BEGIN 
UPDATE Cxc WITH (ROWLOCK) SET Importe = @ImporteTotal, Impuestos = NULL WHERE ID = @CobroID 
END 
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
EXEC spCx @CobroID, 'CXC', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@CobroMov OUTPUT, @CobroMovID OUTPUT, NULL,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
END
UPDATE VentaCobro WITH (ROWLOCK) SET Actualizado = 1 WHERE ID = @ID
END
RETURN
END

