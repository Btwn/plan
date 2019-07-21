SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertarReferenciaCobro
@Empresa           varchar(5),
@Sucursal          int,
@Usuario           varchar(10),
@Estacion          int,
@ID                int,
@IDPOS             varchar(36)

AS
BEGIN
DECLARE
@Aplica             varchar(20),
@AplicaID           varchar(20),
@Host               varchar(20),
@Caja               varchar(10),
@Orden              int,
@CXCSaldoTotal      float,
@Moratorios			float,
@TasaMoratorios		float,
@Renglon			float,
@DiasMoratorios		int
SELECT @TasaMoratorios = ISNULL(CxcMoratoriosTasa,0)/100
FROM EmpresaCfg WITH(NOLOCK)
WHERE Empresa = @Empresa
SELECT @Host = Host , @Caja = Caja
FROM POSL WITH(NOLOCK)
WHERE ID = @IDPOS
IF EXISTS (SELECT * FROM POSLVenta WITH(NOLOCK) WHERE ID = @IDPOS)
DELETE POSLVenta WHERE ID = @IDPOS
DECLARE crFormaPago CURSOR LOCAL FOR
SELECT c.Mov , c.MovID, d.Importe, ROUND(ABS(ISNULL(c.SaldoInteresesMoratorios,0)- (d.InteresesMoratorios)),4), c.DiasMoratorios
FROM POSCxcAnticipoTemp c WITH(NOLOCK) JOIN POSCxcAnticipoTempD d WITH(NOLOCK) on c.Estacion = d.Estacion AND c.Mov = d.Aplica AND c.MovID = d.AplicaID
SET @Renglon = 2048.0
OPEN crFormaPago
FETCH NEXT FROM crFormaPago INTO @Aplica, @AplicaID, @CXCSaldoTotal, @Moratorios, @DiasMoratorios
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
INSERT POSLVenta(
ID, Renglon, RenglonID, RenglonTipo, Articulo, Cantidad, Aplica, AplicaID, Precio)
SELECT
@IDPOS, @Renglon, 1, 'K', 'COBRO', 1, @Aplica, @AplicaID, @CXCSaldoTotal
SET @Renglon = @Renglon + 2048.0
IF @Moratorios > 0
BEGIN
INSERT POSLVenta(
ID, Renglon, RenglonID, RenglonTipo, Articulo, Cantidad, Aplica, AplicaID, Precio, DiasMoratorios, TasaMoratorios)
SELECT
@IDPOS, @Renglon, 1, 'K', 'MORATORIO', 1, @Aplica, @AplicaID, @Moratorios, @DiasMoratorios, @TasaMoratorios
END
SET @Renglon = @Renglon + 2048.0
END
FETCH NEXT FROM crFormaPago INTO @Aplica, @AplicaID, @CXCSaldoTotal, @Moratorios, @DiasMoratorios
END
CLOSE crFormaPago
DEALLOCATE crFormaPago
UPDATE POSL WITH(ROWLOCK) SET CXCSaldoTotal = (SELECT SUM(d.Importe+d.Importe*c.DiasMoratorios*@TasaMoratorios)
FROM POSCxcAnticipoTemp c WITH(NOLOCK) JOIN POSCxcAnticipoTempD d WITH(NOLOCK) on c.Estacion = d.Estacion AND c.Mov = d.Aplica AND c.MovID = d.AplicaID)
WHERE ID = @IDPOS
INSERT POSLAccion (
Host,  Caja, Accion)
VALUES (
@Host, @Caja,'IMPORTE ANTICIPO')
END

