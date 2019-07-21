SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spCalculaRemanenteMAVI
@ID    int,
@PorSist  char(1) 

AS BEGIN  
DECLARE
@Empresa   char(5),
@Sucursal  int,
@Hoy   datetime,
@Moneda   char(10),
@TipoCambio   float,
@Renglon   float,
@Aplica   varchar(20),
@AplicaID   varchar(20),
@AplicaMovTipo  varchar(20),
@Importe   money,
@SumaImporte  money,
@Impuestos   money,
@DesglosarImpuestos  bit,
@IDDetalle   int,
@IDCxc    int,
@ImporteReal   money,
@ImporteAPagar  money,
@ImporteMoratorio money,
@ImporteACondonar money,
@MovGenerar   varchar(20),
@UEN    int,
@ImporteTotal  money,
@Mov    varchar(20),
@MovID    varchar(20),
@MovPadre   varchar(20),
@Ok     int,
@OkRef    varchar(255),
@Cliente   varchar(10),
@CteMoneda   varchar(10),
@CteTipoCambio  float,
@FechaAplicacion datetime,
@ClienteEnviarA     int,
@TotalMov   money,
@CampoExtra   varchar(50),
@Consecutivo  varchar(20),
@ValorCampoExtra varchar(255),
@Concepto   varchar(50),
@MoratorioAPagar money,
@MovIDGen   varchar(20),
@MovCobro   varchar(20),
@GeneraNC   char(1),
@Origen    varchar(20),
@OrigenID   varchar(20),
@Impuesto   money,
@DefImpuesto  float,
@Precalculo   money,
@Remanente   money,
@AbonoRealM   money,
@IDMovMor   int,
@FechaAnterior datetime,
@RemananteAnt money,
@Vencimiento datetime
SET @FechaAplicacion = dbo.fnFechaSinHora(Getdate())
IF @PorSist = '1'
BEGIN
DECLARE crDetalle2 CURSOR FOR
SELECT Mov, MovID, ImporteReal, ImporteAPagar, ImporteMoratorio, ImporteACondonar, MoratorioAPagar
FROM NegociaMoratoriosMAVI
WHERE IDCobro = @ID  AND MoratorioAPagar > 0 AND Mov <> 'Cargo Moratorio'
OPEN crDetalle2
FETCH NEXT FROM crDetalle2 INTO  @Mov, @MovID, @ImporteReal, @ImporteAPagar, @ImporteMoratorio, @ImporteACondonar, @MoratorioAPagar
WHILE @@FETCH_STATUS <> -1
BEGIN  
IF @@FETCH_STATUS <> -2 AND @OK IS NULL
BEGIN    
SELECT @IDMovMor = ID, @FechaAnterior = FechaOriginalAnt, @RemananteAnt = InteresMoratorioAnt, @Vencimiento = Vencimiento FROM CXC WHERE Mov = @Mov AND MovID = @MovID
SELECT  @Precalculo =  ISNULL(@MoratorioAPagar,0) - ISNULL(@ImporteACondonar,0)
IF @Precalculo = 0 SELECT  @AbonoRealM = 0
ELSE
IF @MoratorioAPagar >= @Precalculo
SELECT  @AbonoRealM = ISNULL(@Precalculo,0)
ELSE
SELECT  @AbonoRealM = ISNULL(@Precalculo,0) - ISNULL(@MoratorioAPagar,0)
IF ( ISNULL(@ImporteMoratorio,0) - ISNULL(@ImporteACondonar,0) - ISNULL(@AbonoRealM,0)) < 0
SELECT @Remanente =  0
ELSE
SELECT @Remanente = (ISNULL(@ImporteMoratorio,0) - ISNULL(@ImporteACondonar,0) - ISNULL(@AbonoRealM,0))
UPDATE NegociaMoratoriosMAVI
SET AbonoRealM = ISNULL(@AbonoRealM,0),
Remanente  = @Remanente
WHERE IDCobro = @ID AND Mov = @Mov AND MovID = @MovID
IF NOT EXISTS (Select IDCobro From HistCobroMoratoriosMAVI where IDCobro = @ID AND Mov = @Mov AND MovID = @MovID)
INSERT INTO HistCobroMoratoriosMAVI(IDCobro, Mov, MovID, FechaCobro, FechaOriginalAnt, InteresMoratoriosAnt)
VALUES(@ID, @Mov, @MovID, @FechaAplicacion, @FechaAnterior, @RemananteAnt)
IF (@Vencimiento <= @FechaAplicacion)
BEGIN
UPDATE Cxc
SET FechaOriginalAnt = FechaOriginal,
FechaOriginal = @FechaAplicacion
WHERE ID = @IDMovMor
END
UPDATE Cxc
SET InteresMoratorioAnt = ISNULL(InteresesMoratoriosMAVI,0)
WHERE ID = @IDMovMor
UPDATE Cxc
SET InteresesMoratoriosMAVI = ROUND(@Remanente, 2)
WHERE ID = @IDMovMor
END 
FETCH NEXT FROM crDetalle2 INTO  @Mov, @MovID, @ImporteReal, @ImporteAPagar, @ImporteMoratorio, @ImporteACondonar, @MoratorioAPagar
END 
CLOSE crDetalle2
DEALLOCATE crDetalle2
END
IF @PorSist = '2'
BEGIN
DECLARE crCondSist CURSOR FOR
SELECT Mov, MovID, MontoOriginal, MontoCondonado, MontoCondonado
FROM CondonaMoratoriosMAVI WHERE IdCobro = @ID AND Estatus = 'ALTA' and TipoCondonacion = 'Por Sistema'
OPEN crCondSist
FETCH NEXT FROM crCondSist INTO  @Mov, @MovID, @ImporteMoratorio, @ImporteACondonar, @MoratorioAPagar
WHILE @@FETCH_STATUS <> -1
BEGIN  
IF @@FETCH_STATUS <> -2 AND @OK IS NULL
BEGIN    
SELECT @IDMovMor = ID FROM CXC WHERE Mov = @Mov AND MovID = @MovID
SELECT  @Precalculo =  ISNULL(@MoratorioAPagar,0) - ISNULL(@ImporteACondonar,0)
IF @Precalculo = 0 SELECT  @AbonoRealM = 0
ELSE
IF @MoratorioAPagar >= @Precalculo
SELECT  @AbonoRealM = ISNULL(@Precalculo,0)
ELSE
SELECT  @AbonoRealM = ISNULL(@Precalculo,0) - ISNULL(@MoratorioAPagar,0)
IF ( ISNULL(@ImporteMoratorio,0) - ISNULL(@ImporteACondonar,0) - ISNULL(@AbonoRealM,0)) < 0
SELECT @Remanente =  0
ELSE
SELECT @Remanente =   (ISNULL(@ImporteMoratorio,0) - ISNULL(@ImporteACondonar,0) - ISNULL(@AbonoRealM,0))
UPDATE CondonaMoratoriosMAVI
SET AbonoRealM = ISNULL(@AbonoRealM,0),
Remanente  = ISNULL(@Remanente,0)
WHERE IDCobro = @ID AND Mov = @Mov AND MovID = @MovID
IF NOT EXISTS (Select IDCobro From HistCobroMoratoriosMAVI where IDCobro = @ID AND Mov = @Mov AND MovID = @MovID)
INSERT INTO HistCobroMoratoriosMAVI(IDCobro, Mov, MovID, FechaCobro, FechaOriginalAnt, InteresMoratoriosAnt)
VALUES(@ID, @Mov, @MovID, @FechaAplicacion, @FechaAnterior, @RemananteAnt)
IF (@Vencimiento <= @FechaAplicacion)
BEGIN
UPDATE Cxc
SET FechaOriginalAnt = FechaOriginal,
FechaOriginal = @FechaAplicacion
WHERE ID = @IDMovMor
END
UPDATE Cxc
SET InteresMoratorioAnt = ISNULL(InteresesMoratoriosMAVI,0)
WHERE ID = @IDMovMor
UPDATE Cxc
SET InteresesMoratoriosMAVI = ROUND(ISNULL(@Remanente,0), 2)  WHERE ID = @IDMovMor
END 
FETCH NEXT FROM crCondSist INTO  @Mov, @MovID, @ImporteMoratorio, @ImporteACondonar, @MoratorioAPagar
END 
CLOSE crCondSist
DEALLOCATE crCondSist
END
RETURN
END  

