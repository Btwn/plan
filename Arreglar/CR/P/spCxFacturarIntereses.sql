SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCxFacturarIntereses
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
@Sucursal			int,
@Ok 			int		OUTPUT,
@OkRef 			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@InteresesOrdinarios	money,
@InteresesOrdinariosIVA float, 
@QuitasOrdinarios		money,
@QuitasOrdinariosIVA    float, 
@InteresesMoratorios	money,
@InteresesMoratoriosIVA	float, 
@QuitasMoratorios		money,
@QuitasMoratoriosIVA    float, 
@FacturarInteresesAlCobro	bit,
@InteresesMov		varchar(20),
@InteresesConcepto		varchar(20),
@MoratoriosMov		varchar(20),
@MoratoriosConcepto		varchar(20),
@BonificarQuitasAlCobro	bit,
@QuitasMov			varchar(20),
@QuitasConcepto		varchar(20),
@QuitasMoraMov		varchar(20),
@QuitasMoraConcepto		varchar(20),
@FacturaID			int,
@FacturaMov			varchar(20),
@FacturaMovID		varchar(20),
@FacturaConcepto		varchar(50),
@FacturaImporte		money,
@FacturaImpuestos	float 
IF @Accion = 'CANCELAR'
BEGIN
IF @Modulo = 'CXC'
DECLARE crCancelarFacturarIntereses CURSOR LOCAL FOR
SELECT ID
FROM Cxc
WHERE Empresa = @Empresa AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus IN ('CONCLUIDO', 'PENDIENTE')
OPEN crCancelarFacturarIntereses
FETCH NEXT FROM crCancelarFacturarIntereses INTO @FacturaID
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spAfectar @Modulo, @FacturaID, @Accion, @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @Modulo, @FacturaID, @FacturaMov, @FacturaMovID, @Ok OUTPUT
END
FETCH NEXT FROM crCancelarFacturarIntereses INTO @FacturaID
END
CLOSE crCancelarFacturarIntereses
DEALLOCATE crCancelarFacturarIntereses
END ELSE
IF @Modulo = 'CXC'
BEGIN
SELECT @FacturarInteresesAlCobro = ACFacturarInteresesAlCobro,
@InteresesMov = ACFacturarInteresesMov,
@InteresesConcepto = ACFacturarInteresesConcepto,
@MoratoriosMov = ACFacturarMoratoriosMov,
@MoratoriosConcepto = ACFacturarMoratoriosConcepto,
@BonificarQuitasAlCobro = ACBonificarQuitasAlCobro,
@QuitasMov = ACBonificarQuitasMov,
@QuitasConcepto = ACBonificarQuitasConcepto,
@QuitasMoraMov = ACBonificarQuitasMoraMov,
@QuitasMoraConcepto = ACBonificarQuitasMoraConcepto
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @InteresesOrdinarios = SUM(InteresesOrdinarios), @InteresesOrdinariosIVA = SUM(ISNULL(InteresesOrdinariosIVA,0.0)), @QuitasOrdinarios = SUM(InteresesOrdinarios*InteresesOrdinariosQuita/100), @QuitasOrdinariosIVA = SUM(ISNULL(InteresesOrdinariosIVA,0.0)*ISNULL(InteresesOrdinariosQuita,0.0)/100), 
@InteresesMoratorios = SUM(InteresesMoratorios), @InteresesMoratoriosIVA = SUM(ISNULL(InteresesMoratoriosIVA,0.0)), @QuitasMoratorios = SUM(InteresesMoratorios*InteresesMoratoriosQuita/100), @QuitasMoratoriosIVA = SUM(ISNULL(InteresesMoratoriosIVA,0.0)*ISNULL(InteresesMoratoriosQuita,0.0)/100)  
FROM CxcD
WHERE ID = @ID
IF (NULLIF(@InteresesOrdinarios, 0.0) IS NOT NULL OR NULLIF(@InteresesOrdinariosIVA, 0.0) IS NOT NULL) AND NULLIF(RTRIM(@InteresesMov), '') IS NOT NULL AND @FacturarInteresesAlCobro = 1 
BEGIN
SELECT @FacturaMov = @InteresesMov, @FacturaConcepto = @InteresesConcepto, @FacturaImporte = @InteresesOrdinarios, @FacturaImpuestos = @InteresesOrdinariosIVA 
INSERT Cxc (
Mov,         Concepto,         Importe,         Impuestos,         Estatus,      OrigenTipo, Origen, OrigenID, Sucursal, Empresa, FechaEmision, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio) 
SELECT @FacturaMov, @FacturaConcepto, @FacturaImporte, @FacturaImpuestos, 'SINAFECTAR', @Modulo,    @Mov,   @MovID,   Sucursal, Empresa, FechaEmision, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio  
FROM Cxc
WHERE ID = @ID
SELECT @FacturaID = SCOPE_IDENTITY()
EXEC spAfectar @Modulo, @FacturaID, @Accion, @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @FacturaMovID = MovID FROM Cxc WHERE ID = @FacturaID
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @Modulo, @FacturaID, @FacturaMov, @FacturaMovID, @Ok OUTPUT
END
END
IF (NULLIF(@InteresesMoratorios, 0.0) IS NOT NULL OR NULLIF(@InteresesMoratoriosIVA, 0.0) IS NOT NULL) AND NULLIF(RTRIM(@MoratoriosMov), '') IS NOT NULL AND @FacturarInteresesAlCobro = 1 
BEGIN
SELECT @FacturaMov = @MoratoriosMov, @FacturaConcepto = @MoratoriosConcepto, @FacturaImporte = @InteresesMoratorios, @FacturaImpuestos = @InteresesMoratoriosIVA 
INSERT Cxc (
Mov,         Concepto,         Importe,         Impuestos,         Estatus,     OrigenTipo, Origen, OrigenID, Sucursal, Empresa, FechaEmision, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio) 
SELECT @FacturaMov, @FacturaConcepto, @FacturaImporte, @FacturaImpuestos, 'SINAFECTAR', @Modulo,    @Mov,   @MovID,   Sucursal, Empresa, FechaEmision, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio 
FROM Cxc
WHERE ID = @ID
SELECT @FacturaID = SCOPE_IDENTITY()
EXEC spAfectar @Modulo, @FacturaID, @Accion, @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @FacturaMovID = MovID FROM Cxc WHERE ID = @FacturaID
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @Modulo, @FacturaID, @FacturaMov, @FacturaMovID, @Ok OUTPUT
END
END
IF (NULLIF(@QuitasOrdinarios, 0.0) IS NOT NULL OR NULLIF(@QuitasOrdinariosIVA, 0.0) IS NOT NULL) AND NULLIF(RTRIM(@QuitasMov), '') IS NOT NULL AND @BonificarQuitasAlCobro = 1 
BEGIN
SELECT @FacturaMov = @QuitasMov, @FacturaConcepto = @QuitasConcepto, @FacturaImporte = -@QuitasOrdinarios, @FacturaImpuestos = -@QuitasOrdinariosIVA 
INSERT Cxc (
Mov,         Concepto,         Importe,         Impuestos,         Estatus,     OrigenTipo, Origen, OrigenID, Sucursal, Empresa, FechaEmision, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio) 
SELECT @FacturaMov, @FacturaConcepto, @FacturaImporte, @FacturaImpuestos, 'SINAFECTAR', @Modulo,    @Mov,   @MovID,   Sucursal, Empresa, FechaEmision, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio 
FROM Cxc
WHERE ID = @ID
SELECT @FacturaID = SCOPE_IDENTITY()
EXEC spAfectar @Modulo, @FacturaID, @Accion, @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @FacturaMovID = MovID FROM Cxc WHERE ID = @FacturaID
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @Modulo, @FacturaID, @FacturaMov, @FacturaMovID, @Ok OUTPUT
END
END
IF (NULLIF(@QuitasMoratorios, 0.0) IS NOT NULL OR NULLIF(@QuitasMoratoriosIVA,0.0) IS NOT NULL) AND NULLIF(RTRIM(@QuitasMoraMov), '') IS NOT NULL AND @BonificarQuitasAlCobro = 1 
BEGIN
SELECT @FacturaMov = @QuitasMoraMov, @FacturaConcepto = @QuitasMoraConcepto, @FacturaImporte = -@QuitasMoratorios, @FacturaImpuestos = -@QuitasMoratoriosIVA 
INSERT Cxc (
Mov,         Concepto,         Importe,         Impuestos,         Estatus,     OrigenTipo, Origen, OrigenID, Sucursal, Empresa, FechaEmision, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio) 
SELECT @FacturaMov, @FacturaConcepto, @FacturaImporte, @FacturaImpuestos, 'SINAFECTAR', @Modulo,    @Mov,   @MovID,   Sucursal, Empresa, FechaEmision, Proyecto, Moneda, TipoCambio, Usuario, Referencia, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio 
FROM Cxc
WHERE ID = @ID
SELECT @FacturaID = SCOPE_IDENTITY()
EXEC spAfectar @Modulo, @FacturaID, @Accion, @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
SELECT @FacturaMovID = MovID FROM Cxc WHERE ID = @FacturaID
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @Modulo, @FacturaID, @FacturaMov, @FacturaMovID, @Ok OUTPUT
END
END
END
RETURN
END

