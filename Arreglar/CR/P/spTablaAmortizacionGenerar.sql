SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTablaAmortizacionGenerar
@Empresa		char(5),
@Sucursal		int,
@Usuario		char(10),
@Modulo			char(5),
@ID			int,
@Mov			char(20),
@MovID			varchar(20),
@FechaEmision		datetime,
@FechaRegistro		datetime,
@TipoTasa		varchar(20),
@TasaDiaria		float,
@TieneTasaEsp		bit,
@TasaEsp		float,
@TipoAmortizacion 	varchar(20),
@Amortizaciones		int,
@LineaCredito		varchar(20),
@Ok             	int          = NULL OUTPUT,
@OkRef          	varchar(255) = NULL OUTPUT,
@Migracion		bit	     = 0

AS BEGIN
IF @Modulo NOT IN ('CXC', 'CXP') RETURN
DECLARE
@AmortizacionID		int,
@AmortizacionMov		varchar(20),
@AmortizacionMovID		varchar(20),
@AjusteID			int,
@AjusteMov			varchar(20),
@AjusteMovID		varchar(20),
@Referencia			varchar(50),
@Amortizacion		int,
@FechaD			datetime,
@FechaA			datetime,
@Capital			money,
@Intereses			money,
@IVAInteres					float,
@IVAInteresPorcentaje		float,
@Retencion					money,
@InteresesFijos				money,
@InteresesFijosRetencion		money,
@InteresesOrdinarios			money,
@InteresesOrdinariosIVA			float,
@InteresesMoratorios			money,
@InteresesMoratoriosIVA			float,
@SaldoInteresesOrdinarios		money,
@SaldoInteresesOrdinariosIVA	float,
@CobroIntereses		varchar(20),
@Pendiente			bit,
@FechaCobro			datetime,
@DesglosarImpuestos 	bit,
@CarteraVencidaCBNV		bit,
@GenerarCxpTotal		bit,
@FechaOriginal		datetime,
@DisposicionCxpMov		varchar(20),
@OrigenTipo			varchar(10),
@Origen			varchar(20),
@OrigenID			varchar(20),
@CxpID			int,
@CxpMov			varchar(20),
@CxpMovID			varchar(20),
@CxpImporte			money,
@InteresesMov		varchar(20), 
@InteresesMovID		varchar(20), 
@InteresesID		int, 
@Renglon			float 
SELECT @GenerarCxpTotal = 0
SELECT @CarteraVencidaCBNV = ISNULL(CarteraVencidaCBNV, 0),
@CobroIntereses = UPPER(CobroIntereses)
FROM LC
WHERE LineaCredito = @LineaCredito
SELECT @DesglosarImpuestos = 0
IF @Modulo = 'CXC'
BEGIN
SELECT @DesglosarImpuestos = ISNULL(CxcCobroImpuestos, 0) FROM EmpresaCfg2 WHERE Empresa = @Empresa
SELECT @GenerarCxpTotal    = ACAcreedorEnDisposiciones    FROM EmpresaCfg  WHERE Empresa = @Empresa
END
SELECT @AmortizacionMov   = CASE WHEN @Modulo = 'CXC' THEN CxcAmortizacion  ELSE CxpAmortizacion END,
@AjusteMov         = CASE WHEN @Modulo = 'CXC' THEN CxcAjuste        ELSE CxpAjuste       END,
@DisposicionCxpMov = CASE WHEN @Modulo = 'CXC' THEN ACDisposicionCxp ELSE NULL            END,
@InteresesMov      = CASE WHEN @Modulo = 'CXC' THEN CxcIntereses     ELSE CxpIntereses    END 
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
IF @CobroIntereses = 'FIJOS' 
BEGIN
IF @Modulo = 'CXC'
BEGIN
INSERT Cxc (OrigenTipo, Origen, OrigenID, Sucursal,  Empresa,  Mov,           FechaEmision,  Moneda,  TipoCambio,  Usuario,  Estatus,      Cliente,   ClienteMoneda, ClienteTipoCambio, EsInteresFijo)
SELECT  @Modulo,    @Mov,   @MovID,   @Sucursal, @Empresa, @InteresesMov, @FechaEmision, Moneda,  TipoCambio,  @Usuario, 'SINAFECTAR', Cliente,   ClienteMoneda, ClienteTipoCambio, 1
FROM Cxc
WHERE ID = @ID
SELECT @InteresesID = SCOPE_IDENTITY()
END ELSE
BEGIN
INSERT Cxp (OrigenTipo, Origen, OrigenID, Sucursal,  Empresa,  Mov,           FechaEmision,  Moneda,  TipoCambio,  Usuario,  Estatus,      Proveedor,   ProveedorMoneda, ProveedorTipoCambio, EsInteresFijo)
SELECT  @Modulo,    @Mov,   @MovID,   @Sucursal, @Empresa, @InteresesMov, @FechaEmision, Moneda,  TipoCambio,  @Usuario, 'SINAFECTAR', Proveedor,   ProveedorMoneda, ProveedorTipoCambio, 0
FROM Cxp
WHERE ID = @ID
SELECT @InteresesID = SCOPE_IDENTITY()
END
END
IF EXISTS(SELECT * FROM EmpresaCfgMovAmortizacion WHERE Empresa = @Empresa AND Modulo = @Modulo AND Mov = @Mov)
SELECT @AmortizacionMov = Amortizacion FROM EmpresaCfgMovAmortizacion WHERE Empresa = @Empresa AND Modulo = @Modulo AND Mov = @Mov
IF @Ok IS NULL
BEGIN
SET @Renglon = 2048.0 
DECLARE crCapital CURSOR LOCAL FOR
SELECT Amortizacion, ISNULL(Capital, 0.0), ISNULL(Intereses, 0.0), ISNULL(IVAInteres,0.0), ISNULL(IVAInteresPorcentaje,0.0), ISNULL(Retencion, 0.0), FechaD, FechaA 
FROM TablaAmortizacion
WHERE Modulo = @Modulo AND ID = @ID
OPEN crCapital
FETCH NEXT FROM crCapital INTO @Amortizacion, @Capital, @Intereses, @IVAInteres, @IVAInteresPorcentaje, @Retencion, @FechaD, @FechaA 
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @AmortizacionID              = NULL,
@InteresesFijos              = NULL,
@InteresesFijosRetencion     = NULL,
@InteresesOrdinarios         = NULL,
@InteresesOrdinariosIVA      = NULL, 
@InteresesMoratorios         = NULL,
@InteresesMoratoriosIVA      = NULL, 
@SaldoInteresesOrdinarios    = NULL,
@SaldoInteresesOrdinariosIVA = NULL, 
@Referencia = RTRIM(@Mov) + ' ' + RTRIM(@MovID) + ' ('+CONVERT(varchar, @Amortizacion)+'/'+CONVERT(varchar, @Amortizaciones)+')'
IF @Migracion = 1
SELECT @InteresesOrdinarios = InteresesOrdinarios,
@InteresesOrdinariosIVA = InteresesOrdinariosIVA, 
@InteresesMoratorios = InteresesMoratorios,
@InteresesMoratoriosIVA = InteresesMoratoriosIVA, 
@TasaDiaria          = TasaDiaria,
@Pendiente	      = ISNULL(Pendiente, 0),
@FechaCobro	      = FechaCobro
FROM TablaAmortizacionMigracion
WHERE Modulo = @Modulo AND ID = @ID AND Amortizacion = @Amortizacion
SELECT @InteresesFijos = @Intereses, @InteresesFijosRetencion = @Retencion
IF @CobroIntereses = 'FIJOS' SELECT @SaldoInteresesOrdinarios = @InteresesFijos, @SaldoInteresesOrdinariosIVA = @IVAInteres 
IF @Modulo = 'CXC'
BEGIN
INSERT Cxc
(OrigenTipo, Origen, OrigenID, RamaID, Sucursal,  Empresa,  Mov,              FechaEmision, Condicion, Vencimiento, Referencia,  Importe,  Moneda, TipoCambio, Usuario,   Estatus,     UltimoCambio,   Cliente, ClienteMoneda, ClienteTipoCambio, AplicaManual, Concepto,  Proyecto,  UEN, TasaDiaria,  LineaCredito,  TipoAmortizacion,  TipoTasa, TieneTasaEsp,  TasaEsp,   InteresesFijos,  InteresesOrdinarios,  InteresesMoratorios,  SaldoInteresesOrdinarios,  SaldoInteresesOrdinariosIVA,  IVAInteresPorcentaje) 
SELECT  @Modulo,    @Mov,   @MovID,   @ID,    @Sucursal, @Empresa, @AmortizacionMov, @FechaD,      '(Fecha)', @FechaA,     @Referencia, @Capital, Moneda, TipoCambio, @Usuario, 'SINAFECTAR', @FechaRegistro, Cliente, ClienteMoneda, ClienteTipoCambio, 1,            Concepto,  Proyecto,  UEN, @TasaDiaria, @LineaCredito, @TipoAmortizacion, @TipoTasa, @TieneTasaEsp, @TasaEsp, @InteresesFijos, @InteresesOrdinarios, @InteresesMoratorios, 0.0,                       0.0,                          @IVAInteresPorcentaje 
FROM Cxc
WHERE ID = @ID
SELECT @AmortizacionID = SCOPE_IDENTITY()
INSERT CxcD (
Sucursal,  ID,              Renglon, Aplica, AplicaID, Importe)
VALUES (@Sucursal, @AmortizacionID, 2048.0,  @Mov,   @MovID,   @Capital)
/*          IF @DesglosarImpuestos = 1
SELECT @Impuestos = NULLIF(SUM(d.Importe*c.IVAFiscal*ISNULL(c.IEPSFiscal, 1)), 0)
FROM CxcD d, Cxc c
WHERE d.ID = @AmortizacionID AND c.Empresa = @Empresa AND c.Mov = d.Aplica AND c.MovID = d.AplicaID AND c.Estatus = 'PENDIENTE'
UPDATE Cxc SET Importe = @Capital - ISNULL(@Impuestos, 0.0), Impuestos = @Impuestos WHERE ID = @AmortizacionID
*/
UPDATE TablaAmortizacion SET CxcID = @AmortizacionID WHERE CURRENT OF crCapital
END ELSE
BEGIN
INSERT Cxp
(OrigenTipo, Origen, OrigenID, RamaID, Sucursal,  Empresa,  Mov,              FechaEmision, Condicion, Vencimiento, Referencia,  Importe,  Moneda, TipoCambio, Usuario,   Estatus,     UltimoCambio,   Proveedor, ProveedorMoneda, ProveedorTipoCambio, AplicaManual, Concepto,  Proyecto,  UEN, TasaDiaria,  LineaCredito,  TipoAmortizacion,  TipoTasa,  TieneTasaEsp,  TasaEsp,  InteresesFijos,  InteresesFijosRetencion,  InteresesOrdinarios,  InteresesMoratorios,  SaldoInteresesOrdinarios,  SaldoInteresesOrdinariosIVA,  IVAInteresPorcentaje) 
SELECT  @Modulo,    @Mov,   @MovID,   @ID,    @Sucursal, @Empresa, @AmortizacionMov, @FechaD,      '(Fecha)', @FechaA,     @Referencia, @Capital, Moneda, TipoCambio, @Usuario, 'SINAFECTAR', @FechaRegistro, Proveedor, ProveedorMoneda, ProveedorTipoCambio, 1,            Concepto,  Proyecto,  UEN, @TasaDiaria, @LineaCredito, @TipoAmortizacion, @TipoTasa, @TieneTasaEsp, @TasaEsp, @InteresesFijos, @InteresesFijosRetencion, @InteresesOrdinarios, @InteresesMoratorios, 0.0,                       0.0,                          @IVAInteresPorcentaje 
FROM Cxp
WHERE ID = @ID
SELECT @AmortizacionID = SCOPE_IDENTITY()
INSERT CxpD (
Sucursal,  ID,              Renglon, Aplica, AplicaID, Importe)
VALUES (@Sucursal, @AmortizacionID, 2048.0,  @Mov,   @MovID,   @Capital)
UPDATE TablaAmortizacion SET CxpID = @AmortizacionID WHERE CURRENT OF crCapital
END
IF @AmortizacionID IS NOT NULL AND @Ok IS NULL
BEGIN
EXEC spCx @AmortizacionID, @Modulo, 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @AmortizacionMov OUTPUT, @AmortizacionMovID OUTPUT, NULL, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @ID, @Mov, @MovID, @Modulo, @AmortizacionID, @AmortizacionMov, @AmortizacionMovID, @Ok OUTPUT
IF @Migracion = 1 AND @Pendiente = 0 AND @Ok IS NULL
BEGIN
IF @Capital = 0.0
UPDATE Cxc SET Estatus = 'CONCLUIDO' WHERE ID = @AmortizacionID
ELSE BEGIN
EXEC spCx @AmortizacionID, @Modulo, 'GENERAR', 'TODO', @FechaRegistro, @AjusteMov, @Usuario, 1, 0, @AmortizacionMov,  @AmortizacionMovID,  @AjusteID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
UPDATE Cxc
SET AplicaManual = 1, FechaEmision = ISNULL(@FechaCobro, FechaEmision)
WHERE ID = @AjusteID
DELETE CxcD WHERE ID = @AjusteID
INSERT CxcD (
Sucursal,  ID,        Renglon, Aplica, AplicaID, Importe)
SELECT @Sucursal, @AjusteID, 2048.0,  Mov,    MovID,    Importe
FROM Cxc
WHERE ID = @AmortizacionID
EXEC spCx @AjusteID,       @Modulo, 'AFECTAR', 'TODO', @FechaRegistro, NULL,       @Usuario, 1, 0, @AjusteMov OUTPUT, @AjusteMovID OUTPUT, NULL,             @Ok OUTPUT, @OkRef OUTPUT
END
END
END
IF @CobroIntereses = 'FIJOS' AND @Ok IS NULL AND @InteresesID IS NOT NULL 
BEGIN
IF @Modulo = 'CXC'
BEGIN
INSERT CxcD (ID,           Sucursal,  Renglon,  Aplica,             AplicaID,           InteresesOrdinarios,       InteresesOrdinariosIVA)
VALUES (@InteresesID, @Sucursal, @Renglon, @AmortizacionMov,   @AmortizacionMovID, @SaldoInteresesOrdinarios, @SaldoInteresesOrdinariosIVA) 
END ELSE
BEGIN
INSERT CxpD (ID,           Sucursal,  Renglon,  Aplica,             AplicaID,           InteresesOrdinarios,       InteresesOrdinariosIVA)
VALUES (@InteresesID, @Sucursal, @Renglon, @AmortizacionMov,   @AmortizacionMovID, @SaldoInteresesOrdinarios, @SaldoInteresesOrdinariosIVA) 
END
SET @Renglon = @Renglon + 2048.0
END
END
FETCH NEXT FROM crCapital INTO @Amortizacion, @Capital, @Intereses, @IVAInteres, @IVAInteresPorcentaje, @Retencion, @FechaD, @FechaA 
END
CLOSE crCapital
DEALLOCATE crCapital
IF @InteresesID IS NOT NULL AND @Ok IS NULL AND @CobroIntereses = 'FIJOS' 
BEGIN
EXEC spCx @InteresesID, @Modulo, 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @InteresesMov OUTPUT, @InteresesMovID OUTPUT, NULL, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @ID, @Mov, @MovID, @Modulo, @InteresesID, @InteresesMov, @InteresesMovID, @Ok OUTPUT
END
IF @GenerarCxpTotal = 1 AND @DisposicionCxpMov IS NOT NULL
BEGIN
SELECT @FechaOriginal = @FechaEmision
SELECT @CxpImporte = Importe, @OrigenTipo = OrigenTipo, @Origen = Origen, @OrigenID = OrigenID FROM Cxc WHERE ID = @ID
IF @OrigenTipo = 'VTAS'
SELECT @FechaOriginal = MIN(FechaOriginal) FROM Venta WHERE Empresa = @Empresa AND Mov = @Origen AND MovID = @OrigenID AND Estatus IN ('CONCLUIDO', 'PENDIENTE')
INSERT Cxp
(OrigenTipo, Origen, OrigenID, RamaID, Sucursal,  Empresa,  Mov,                FechaEmision,  Condicion, Vencimiento,                      Importe,     Moneda,   TipoCambio,   Usuario,   Estatus,     UltimoCambio,   Proveedor,   ProveedorSucursal,   ProveedorMoneda, ProveedorTipoCambio, Concepto,   Proyecto,    UEN)
SELECT  @Modulo,    @Mov,   @MovID,   @ID,    @Sucursal, @Empresa, @DisposicionCxpMov, @FechaEmision, '(Fecha)', DATEADD(day, 30, @FechaOriginal), @CxpImporte, c.Moneda, c.TipoCambio, @Usuario, 'SINAFECTAR', @FechaRegistro, lc.Acreedor, lc.AcreedorSucursal, c.Moneda,        c.TipoCambio,        c.Concepto, c.Proyecto,  c.UEN
FROM Cxc c
JOIN LC ON lc.LineaCredito = c.LineaCredito
WHERE ID = @ID
SELECT @CxpID = SCOPE_IDENTITY()
EXEC spCx @CxpID, 'CXP', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @CxpMov OUTPUT, @CxpMovID OUTPUT, NULL, @Ok OUTPUT, @OkRef OUTPUT
END
IF @CarteraVencidaCBNV = 1 AND @Modulo = 'CXC' AND @Ok IS NULL
BEGIN
UPDATE Cxc SET CarteraVencidaCNBV = 1 WHERE ID     = @ID AND CarteraVencidaCNBV = 0
UPDATE Cxc SET CarteraVencidaCNBV = 1 WHERE RamaID = @ID AND CarteraVencidaCNBV = 0
END
END
RETURN
END

