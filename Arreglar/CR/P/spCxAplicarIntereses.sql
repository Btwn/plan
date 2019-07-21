SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCxAplicarIntereses
@ID		  		int,
@Accion			char(20),
@Empresa			char(5),
@Usuario			char(10),
@Modulo			char(5),
@Mov			char(20),
@MovID			varchar(20),
@MovTipo   			char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision		datetime,
@Ok 			int		OUTPUT,
@OkRef 			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@TipoCambioLog		float,
@Renglon			float,
@RenglonSub			int,
@AplicaID			int,
@AplicaMov			char(20),
@AplicaMovID		varchar(20),
@AplicaTipoCambio		float,
@AplicaOrdinarios		money,
@AplicaMoratorios		money,
@AplicaRetencion		money,
@AplicaLineaCredito		varchar(20),
@AplicaCobroIntereses	varchar(20),
@Ordinarios 			money,
@Moratorios				money,
@Retencion				money,
@AplicaOrdinariosIVA	float, 
@AplicaMoratoriosIVA	float, 
@OrdinariosIVA 			float, 
@MoratoriosIVA			float,  
@EsInteresFijo			bit, 
@Sucursal				int,  
@Rama					varchar(5), 
@SubMovTipo				varchar(20), 
@AplicaMoneda			varchar(10), 
@AplicaContacto			varchar(10), 
@InteresImporte			float, 
@IVAInteresImporte		float, 
@EsCargo				bit,   
@Ejercicio				int,   
@Periodo				int    
SELECT @SubMovTipo = SubClave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov 
IF @Movtipo = 'CXC.INT' AND @SubMovTipo = 'CXC.INM' 
SET @Rama = 'CIM' 
ELSE IF @Movtipo = 'CXC.INT' AND @SubMovTipo <> 'CXC.INM' 
SET @Rama = 'CIO' 
ELSE IF @Movtipo = 'CXP.INT' AND @SubMovTipo = 'CXP.INM' 
SET @Rama = 'PIM' 
ELSE IF @Movtipo = 'CXP.INT' AND @SubMovTipo <> 'CXP.INM' 
SET @Rama = 'PIO' 
ELSE 
SET @Rama = @Modulo 
IF @Modulo = 'CXC' SELECT @Ejercicio = Ejercicio, @Periodo = Periodo, @Sucursal = Sucursal, @EsInteresFijo = ISNULL(EsInteresFijo,0) FROM Cxc WHERE ID = @ID ELSE 
IF @Modulo = 'CXP' SELECT @Ejercicio = Ejercicio, @Periodo = Periodo, @Sucursal = Sucursal, @EsInteresFijo = ISNULL(EsInteresFijo,0) FROM Cxp WHERE ID = @ID      
IF @Modulo = 'CXC' DECLARE crCxDetalle CURSOR LOCAL FOR SELECT Renglon, RenglonSub, Aplica, AplicaID, InteresesOrdinarios*@MovTipoCambio, InteresesMoratorios*@MovTipoCambio, CONVERT(money, NULL),     InteresesOrdinariosIVA*@MovTipoCambio, InteresesMoratoriosIVA*@MovTipoCambio FROM CxcD WHERE ID = @ID ELSE 
IF @Modulo = 'CXP' DECLARE crCxDetalle CURSOR LOCAL FOR SELECT Renglon, RenglonSub, Aplica, AplicaID, InteresesOrdinarios*@MovTipoCambio, InteresesMoratorios*@MovTipoCambio, Retencion*@MovTipoCambio, InteresesOrdinariosIVA*@MovTipoCambio, InteresesMoratoriosIVA*@MovTipoCambio FROM CxpD WHERE ID = @ID 
OPEN crCxDetalle
FETCH NEXT FROM crCxDetalle INTO @Renglon, @RenglonSub, @AplicaMov, @AplicaMovID, @AplicaOrdinarios, @AplicaMoratorios, @AplicaRetencion, @AplicaOrdinariosIVA, @AplicaMoratoriosIVA 
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @AplicaID = NULL
IF @Modulo = 'CXC' SELECT @AplicaContacto = Cliente,   @AplicaID = ID, @AplicaMoneda = Moneda, @AplicaTipoCambio = TipoCambio, @AplicaLineaCredito = LineaCredito FROM Cxc WHERE Empresa = @Empresa AND Mov = @AplicaMov AND MovID = @AplicaMovID AND Estatus IN ('CONCLUIDO', 'PENDIENTE') ELSE
IF @Modulo = 'CXP' SELECT @AplicaContacto = Proveedor, @AplicaID = ID, @AplicaMoneda = Moneda, @AplicaTipoCambio = TipoCambio, @AplicaLineaCredito = LineaCredito FROM Cxp WHERE Empresa = @Empresa AND Mov = @AplicaMov AND MovID = @AplicaMovID AND Estatus IN ('CONCLUIDO', 'PENDIENTE')
IF @AplicaID IS NOT NULL
BEGIN
SELECT @Ordinarios  = ISNULL(@AplicaOrdinarios / @AplicaTipoCambio, 0.0),
@Moratorios = ISNULL(@AplicaMoratorios / @AplicaTipoCambio, 0.0),
@Retencion = ISNULL(@AplicaRetencion / @AplicaTipoCambio, 0.0),
@OrdinariosIVA = ISNULL(@AplicaOrdinariosIVA / @AplicaTipoCambio, 0.0), 
@MoratoriosIVA = ISNULL(@AplicaMoratoriosIVA / @AplicaTipoCambio, 0.0) 
SELECT @AplicaCobroIntereses = NULL
SELECT @AplicaCobroIntereses = UPPER(CobroIntereses)
FROM LC
WHERE LineaCredito = @AplicaLineaCredito
SET @EsCargo = 1
IF @Accion = 'CANCELAR' SELECT @EsCargo = ~@EsCargo
SET @InteresImporte = ISNULL(@Ordinarios,0.0) + ISNULL(@Moratorios,0.0)
SET @IVAInteresImporte = ISNULL(@OrdinariosIVA,0.0) + ISNULL(@MoratoriosIVA,0.0)
EXEC spSaldo @Sucursal, @Accion, @Empresa, @Usuario, @Rama, @AplicaMoneda, @AplicaTipoCambio, @AplicaContacto, NULL, NULL, NULL, 
@Modulo, @ID, @Mov, @MovID, @EsCargo, @InteresImporte, NULL, NULL,
@FechaEmision, @Ejercicio, @Periodo, @AplicaMov, @AplicaMovID, 0, 0, 0,
@Ok OUTPUT, @OkRef OUTPUT
EXEC spSaldo @Sucursal, @Accion, @Empresa, @Usuario, @Rama, @AplicaMoneda, @AplicaTipoCambio, @AplicaContacto, NULL, NULL, NULL, 
@Modulo, @ID, @Mov, @MovID, @EsCargo, @IVAInteresImporte, NULL, NULL,
@FechaEmision, @Ejercicio, @Periodo, @AplicaMov, @AplicaMovID, 0, 0, 0,
@Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'CANCELAR' SELECT @Ordinarios = -@Ordinarios, @Moratorios = -@Moratorios, @Retencion = -@Retencion, @OrdinariosIVA = -@OrdinariosIVA, @MoratoriosIVA = -@MoratoriosIVA 
IF @Ordinarios <> 0.0 OR @Moratorios <> 0.0 OR @OrdinariosIVA <> 0.0 OR @MoratoriosIVA <> 0.0 
BEGIN
IF @Modulo = 'CXC'
UPDATE Cxc
SET InteresesOrdinarios = NULLIF(ISNULL(InteresesOrdinarios, 0.0) + @Ordinarios, 0.0),
InteresesMoratorios = NULLIF(ISNULL(InteresesMoratorios, 0.0) + @Moratorios, 0.0),
InteresesOrdinariosIVA = NULLIF(ISNULL(InteresesOrdinariosIVA, 0.0) + @OrdinariosIVA, 0.0), 
InteresesMoratoriosIVA = NULLIF(ISNULL(InteresesMoratoriosIVA, 0.0) + @MoratoriosIVA, 0.0), 
SaldoInteresesOrdinarios = CASE WHEN @AplicaCobroIntereses = 'DEVENGADOS' OR @EsInteresFijo = 1 THEN NULLIF(ISNULL(SaldoInteresesOrdinarios, 0.0) + @Ordinarios, 0.0) ELSE SaldoInteresesOrdinarios END, 
SaldoInteresesMoratorios = NULLIF(ISNULL(SaldoInteresesMoratorios, 0.0) + @Moratorios, 0.0),
SaldoInteresesOrdinariosIVA = CASE WHEN @AplicaCobroIntereses = 'DEVENGADOS' OR @EsInteresFijo = 1 THEN NULLIF(ISNULL(SaldoInteresesOrdinariosIVA, 0.0) + @OrdinariosIVA, 0.0) ELSE SaldoInteresesOrdinariosIVA END, 
SaldoInteresesMoratoriosIVA = NULLIF(ISNULL(SaldoInteresesMoratoriosIVA, 0.0) + @MoratoriosIVA, 0.0) 
WHERE ID = @AplicaID
ELSE
IF @Modulo = 'CXP'
UPDATE Cxp
SET InteresesOrdinarios = NULLIF(ISNULL(InteresesOrdinarios, 0.0) + @Ordinarios, 0.0),
InteresesMoratorios = NULLIF(ISNULL(InteresesMoratorios, 0.0) + @Moratorios, 0.0),
InteresesOrdinariosIVA = NULLIF(ISNULL(InteresesOrdinariosIVA, 0.0) + @OrdinariosIVA, 0.0), 
InteresesMoratoriosIVA = NULLIF(ISNULL(InteresesMoratoriosIVA, 0.0) + @MoratoriosIVA, 0.0), 
InteresesRetencion  = NULLIF(ISNULL(InteresesRetencion, 0.0)  + @Retencion, 0.0),
SaldoInteresesOrdinarios = CASE WHEN @AplicaCobroIntereses = 'DEVENGADOS'  OR @EsInteresFijo = 1 THEN NULLIF(ISNULL(SaldoInteresesOrdinarios, 0.0) + @Ordinarios, 0.0) ELSE SaldoInteresesOrdinarios END, 
SaldoInteresesMoratorios = NULLIF(ISNULL(SaldoInteresesMoratorios, 0.0) + @Moratorios, 0.0),
SaldoInteresesOrdinariosIVA = CASE WHEN @AplicaCobroIntereses = 'DEVENGADOS'  OR @EsInteresFijo = 1 THEN NULLIF(ISNULL(SaldoInteresesOrdinariosIVA, 0.0) + @OrdinariosIVA, 0.0) ELSE SaldoInteresesOrdinariosIVA END, 
SaldoInteresesMoratoriosIVA = NULLIF(ISNULL(SaldoInteresesMoratoriosIVA, 0.0) + @MoratoriosIVA, 0.0) 
WHERE ID = @AplicaID
END
END
END
FETCH NEXT FROM crCxDetalle INTO @Renglon, @RenglonSub, @AplicaMov, @AplicaMovID, @AplicaOrdinarios, @AplicaMoratorios, @AplicaRetencion, @AplicaOrdinariosIVA, @AplicaMoratoriosIVA 
END 
CLOSE crCxDetalle
DEALLOCATE crCxDetalle
RETURN
END

