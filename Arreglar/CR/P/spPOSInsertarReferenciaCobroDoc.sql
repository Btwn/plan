SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertarReferenciaCobroDoc
@Empresa        varchar(5),
@Sucursal       int,
@Usuario        varchar(10),
@Estacion		int,
@ID             int,
@IDPOS          varchar(36)

AS
BEGIN
DECLARE
@Aplica                 varchar(20),
@AplicaID               varchar(20),
@Host                   varchar(20),
@Caja                   varchar(10),
@Orden                  int,
@CXCSaldoTotal          float,
@Moratorios				float,
@TasaMoratorios			float,
@Renglon				float,
@DiasMoratorios			int,
@ImporteReal			money,
@ImporteAPagar			money,
@ImporteMoratorio		money,
@MoratorioAPagar		money,
@Origen					varchar(20),
@OrigenID				varchar(20)
SELECT @TasaMoratorios = ISNULL(CxcMoratoriosTasa,0)/100
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @Host = Host , @Caja = Caja
FROM POSL
WHERE ID = @IDPOS
IF EXISTS (SELECT * FROM POSLVenta WHERE ID = @IDPOS)
DELETE POSLVenta WHERE ID = @IDPOS
DECLARE crFormaPago CURSOR LOCAL FOR
SELECT Mov, MovID, ImporteAPagar, MoratorioAPagar, ImporteReal, ImporteAPagar, ImporteMoratorio, MoratorioAPagar, Origen, OrigenID
FROM NegociaMoratoriosMAVI
WHERE IDCobro = @ID
SET @Renglon = 2048.0
OPEN crFormaPago
FETCH NEXT FROM crFormaPago INTO @Aplica, @AplicaID, @CXCSaldoTotal, @Moratorios, @ImporteReal, @ImporteAPagar, @ImporteMoratorio, @MoratorioAPagar, @Origen, @OrigenID
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
INSERT POSLVenta(
ID, Renglon, RenglonID, RenglonTipo, Articulo, Cantidad, Aplica, AplicaID, Precio, PrecioImpuestoInc, ImporteReal, ImporteAPagar,
ImporteMoratorio, MoratorioAPagar, Origen, OrigenID)
SELECT
@IDPOS, @Renglon, 1, 'K', 'COBRO', 1, @Aplica, @AplicaID, @CXCSaldoTotal, @CXCSaldoTotal, @ImporteReal, @ImporteAPagar,
@ImporteMoratorio, @MoratorioAPagar, @Origen, @OrigenID
SET @Renglon = @Renglon + 2048.0
IF @Moratorios > 0
BEGIN
INSERT POSLVenta(
ID, Renglon, RenglonID, RenglonTipo, Articulo, Cantidad, Aplica, AplicaID, Precio, PrecioImpuestoInc, DiasMoratorios, TasaMoratorios,
ImporteReal, ImporteAPagar, ImporteMoratorio, MoratorioAPagar, Origen, OrigenID)
SELECT
@IDPOS, @Renglon, 1, 'K', 'MORATORIO', 1, @Aplica, @AplicaID, @Moratorios, @Moratorios, @DiasMoratorios, @TasaMoratorios,
@ImporteReal, @ImporteAPagar, @ImporteMoratorio, @MoratorioAPagar, @Origen, @OrigenID
END
SET @Renglon = @Renglon + 2048.0
END
FETCH NEXT FROM crFormaPago INTO @Aplica, @AplicaID, @CXCSaldoTotal, @Moratorios, @ImporteReal, @ImporteAPagar, @ImporteMoratorio, @MoratorioAPagar,
@Origen, @OrigenID
END
CLOSE crFormaPago
DEALLOCATE crFormaPago
UPDATE POSL SET CXCSaldoTotal = (SELECT SUM(d.Importe+d.Importe*c.DiasMoratorios*@TasaMoratorios)
FROM POSCxcAnticipoTemp c JOIN POSCxcAnticipoTempD d on c.Estacion = d.Estacion AND c.Mov = d.Aplica AND c.MovID = d.AplicaID)
WHERE ID = @IDPOS
INSERT POSLAccion (
Host,  Caja, Accion)
VALUES (
@Host, @Caja,'IMPORTE ANTICIPO')
END

