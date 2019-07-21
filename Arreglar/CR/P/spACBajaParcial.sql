SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spACBajaParcial
@Empresa			char(5),
@Sucursal			int,
@Usuario			char(10),
@Modulo			char(5),
@Mov			varchar(20),
@MovID			varchar(20),
@Hoy			datetime,
@PorcentajeBajaParcial	float

AS BEGIN
DECLARE
@CxcID			int,
@DocID			int,
@DocMov			varchar(20),
@DocMovID			varchar(20),
@NCargoID			int,
@NCargoMov			varchar(20),
@AjusteID			int,
@AjusteMov			varchar(20),
@RamaID			int,
@Importe			money,
@ImpuestoPct		float,
@ImportePendiente		money,
@ImporteConcluido		money,
@ValorUnitario		money,
@ValorUnitarioConIVA	money,
@ValorResidualPct		float,
@ImporteTotal		money,
@CapitalBase		money,
@Dif			money,
@Saldo			money,
@Ok				int,
@OkRef			varchar(255)
IF @Modulo <> 'CXC' RETURN
SELECT @NCargoID = NULL, @Ok = NULL, @OkRef = NULL
BEGIN TRANSACTION
SELECT @NCargoMov = CxcNCargo,
@DocMov = ACBajaParcial,
@AjusteMov = CxcAjuste
FROM EmpresaCfgMov WHERE Empresa = @Empresa
SELECT @RamaID = NULL
SELECT @RamaID = c.ID, @Importe = c.Importe, @ImpuestoPct = ISNULL(c.Impuestos, 0.0)/NULLIF(c.Importe, 0.0)*100.0,
@ValorResidualPct = lc.PorcentajeResidual
FROM Cxc c
JOIN LC on lc.LineaCredito = c.LineaCredito
WHERE c.Empresa = @Empresa AND c.Mov = @Mov AND c.MovID = @MovID AND c.Estatus = 'CONCLUIDO'
EXEC xpPorcentajeResidual @Modulo, @RamaID, @ValorResidualPct OUTPUT
IF @RamaID IS NULL OR NULLIF(@PorcentajeBajaParcial, 0) IS NULL RETURN
SELECT @ImportePendiente = SUM(Saldo) FROM Cxc WHERE RamaID = @RamaID
SELECT @ImporteConcluido = SUM(Importe) FROM Cxc WHERE RamaID = @RamaID AND Estatus = 'CONCLUIDO'
SELECT @CxcID = MIN(ID) FROM Cxc WHERE RamaID = @RamaID AND Estatus = 'PENDIENTE'
SELECT @ValorUnitario = (@Importe - @ImporteConcluido) * (@PorcentajeBajaParcial/100.0)
SELECT @ValorUnitarioConIVA = @ValorUnitario * (1.0+(@ImpuestoPct/100.0))
SELECT @CapitalBase = @ImportePendiente - @ValorUnitario + ((@Importe*(@ValorResidualPct/100.0))*@PorcentajeBajaParcial/100.0)
SELECT @ImporteTotal = ISNULL(ta.SaldoInicial, 0.0) - @ValorUnitarioConIVA
FROM TablaAmortizacion ta
WHERE ta.Modulo = @Modulo AND ta.ID = @RamaID AND CxcID = @CxcID
SELECT @Dif = @ImporteTotal - @ImportePendiente
IF ISNULL(@Dif, 0.0) > 0.0
BEGIN
INSERT Cxc
(Sucursal,  Empresa, Mov,        FechaEmision, Referencia, Importe, Moneda,   TipoCambio,   Usuario,   Estatus,     Cliente, ClienteMoneda, ClienteTipoCambio, Concepto,  Proyecto,  UEN)
SELECT  @Sucursal, Empresa, @NCargoMov, @Hoy,         Referencia, @Dif,    m.Moneda, m.TipoCambio, @Usuario, 'SINAFECTAR', Cliente, m.Moneda,      m.TipoCambio,      Concepto,  Proyecto,  UEN
FROM Cxc c
JOIN Mon m ON m.Moneda = c.Moneda
WHERE ID = @RamaID
SELECT @NCargoID = SCOPE_IDENTITY()
EXEC spAfectar @Modulo, @NCargoID, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF @Ok IS NULL
BEGIN
SELECT @Importe = @ImporteTotal/(1+(@ImpuestoPct/100.0))
INSERT Cxc
(Sucursal,  Empresa, Mov,     FechaEmision, Condicion, Vencimiento, Referencia, Importe,  Impuestos,                     Moneda,   TipoCambio,   Usuario,   Estatus,     Cliente, ClienteMoneda, ClienteTipoCambio, AplicaManual, Concepto,  Proyecto,  UEN, TasaDiaria, LineaCredito, TipoAmortizacion, TipoTasa, TieneTasaEsp, TasaEsp, InteresesFijos, Referencia5)
SELECT  @Sucursal, Empresa, @DocMov, @Hoy,        '(Fecha)',  Vencimiento, Referencia, @Importe, @Importe*(@ImpuestoPct/100.0), m.Moneda, m.TipoCambio, @Usuario, 'SINAFECTAR', Cliente, m.Moneda,      m.TipoCambio,      1,            Concepto,  Proyecto,  UEN, TasaDiaria, LineaCredito, TipoAmortizacion, TipoTasa, TieneTasaEsp, TasaEsp, InteresesFijos, CONVERT(varchar, @CapitalBase)
FROM Cxc c
JOIN Mon m ON m.Moneda = c.Moneda
WHERE ID = @RamaID
SELECT @DocID = SCOPE_IDENTITY()
INSERT CxcD (
Sucursal,  ID,     Renglon,    Aplica, AplicaID, Importe)
SELECT @Sucursal, @DocID, ID-@RamaID, Mov,    MovID,    Saldo
FROM Cxc
WHERE RamaID = @RamaID AND Estatus = 'PENDIENTE'
INSERT CxcD (
Sucursal,  ID,     Renglon,    Aplica, AplicaID, Importe)
SELECT @Sucursal, @DocID, ID-@RamaID, Mov,    MovID,    Saldo
FROM Cxc
WHERE ID = @NCargoID AND Estatus = 'PENDIENTE'
EXEC spAfectar @Modulo, @DocID, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @DocMovID = MovID FROM Cxc WHERE ID = @DocID
END
SELECT @Saldo = 0.0
SELECT @Saldo = Saldo FROM Cxc WHERE ID = @DocID AND Estatus = 'PENDIENTE'
IF @Ok IS NULL AND ISNULL(@Saldo, 0.0) > 0.0
BEGIN
EXEC @AjusteID = spAfectar @Modulo, @DocID, 'GENERAR', 'PENDIENTE', @AjusteMov, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
UPDATE Cxc SET Importe = @Saldo, Impuestos = NULL WHERE ID = @AjusteID
DELETE CxcD WHERE ID = @AjusteID
INSERT CxcD (Sucursal,  ID,        Renglon,    Aplica,  AplicaID,  Importe)
VALUES      (@Sucursal, @AjusteID, 2048,       @DocMov, @DocMovID, @Saldo)
EXEC spAfectar @Modulo, @AjusteID, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
SELECT 'Se Genero con Exito '+RTRIM(@DocMov)+' '+RTRIM(@DocMovID)
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT Descripcion+' '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
END
RETURN
END

