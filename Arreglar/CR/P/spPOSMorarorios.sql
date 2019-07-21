SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSMorarorios
@Empresa            char(5),
@Sucursal           int,
@Modulo             char(5),
@ID                 int,
@Estatus            char(15),
@EstatusNuevo       char(15),
@Usuario   varchar(10),
@FechaEmision       datetime,
@FechaRegistro      datetime,
@Mov                char(20),
@MovID              varchar(20),
@MovTipo            char(20),
@IDGenerar          int,
@Ok                 int             OUTPUT,
@OkRef              varchar(255)    OUTPUT

AS
BEGIN
DECLARE
@Concepto  varchar(50),
@AFArticulo  varchar(20),
@AFSerie  varchar(20),
@Lectura  int,
@Control  int,
@AutorizarGasto int,
@Articulo       varchar(20),  
@Origen   char(20),
@OrigenID  char(20),
@IDOrigen  char(20),
@DMov           varchar(20),
@DmovID         varchar(20),
@OID   int,
@IDCxc   int,
@IDNCCxc int,
@IDCxcPend  int,
@IDCxcPendNC  int,
@IDDestino  int,
@Mensaje  varchar(255),
@MovSaldar  varchar(20),
@Cliente  varchar(10),
@Moneda   varchar(10),
@CteMoneda  varchar(10),
@TipoCambio  float,
@CteTipoCambio float,
@Renglon  float,
@RenglonSub  int,
@CondPago  varchar(50),
@IVA   money,
@UEN   int,
@CteEnviarA  INT,
@IDD      int,
@Clave     varchar(20),
@Aplica  varchar(20),
@AplicaID  varchar(20),
@Observaciones   varchar(100),
@FechaActual    datetime,
@Importe     money,
@ImporteInteres   money,
@InteresesMoratorios  money,
@CargoxMoratorioMavi   money,
@TotalInteresMoratorio money,
@MovMor     varchar(20),
@ValorCampoExtra   varchar(255),
@ImporteMoratorio   money,
@MoratorioAPagar   money,
@PendienteMoratorios  money,
@ImporteACondonar   money,
@FinMovMor    int,
@FinCadenaMovMor   int,
@IDMovMor     int,
@IDNCMor    int,
@MovMorId    varchar(20),
@IDDoc     int,
@UsuarioCondona   varchar(10),
@MontoMinimoMor   float,
@FechaOriginal   datetime,
@Remanente    money,
@IDNCBon    int,
@FechaOriginalAnt  datetime,
@InteresMoratorioAnt money,
@MasCobrosMor   int,
@FechaAnterior   datetime,
@RemananteAnt   money,
@IDMAx     int,
@CondxSist    int,
@TipoCondonacion  varchar(25),
@FechaOrigAnt   datetime,
@InteresesMoratoriosAnt money,
@IDFActCXC    int,
@Subclave    varchar(20),
@MovPadre    varchar(20),
@MovIDPadre    varchar(20),
@IDPadre    int,
@CxcID     int,
@FechaAplicacion  datetime,
@IDCobro int,
@HayNCA int,
@TipoCobro int,
@IdCargoMoratorio int,
@Padre  varchar(20),
@PadreID  varchar(20),
@IdCargoMoratorioEst int,
@IdCobroCargoMoratorioEstAnt int,
@IDCargoMoratorioEstAnt int,
@Vencimiento datetime,
@PorcMoratorioBonificar float,
@MoratorioXPagar money,
@RemanenteNvo money,
@DocMasAntiguo int,
@FechaAntigua datetime,
@IDDocPendiente int,
@MovDocV varchar(20),
@MovIDDocV varchar(20),
@Estadistico int,
@MovTipoCFDFlex   bit,
@CFDFlex    bit,
@eDoc     bit,
@XML     varchar(max),
@eDocOk     int,
@eDocOkRef    varchar(255),
@NoPadres INT,
@IDPadreMAVI INT,
@PadreMAVI varchar(20),
@PadreIDMAVI varchar(20),
@AplicaManual INT,
@NoParcialidad INT,
@Condicion varchar(20),
@dAplica varchar(20),
@dAplicaID varchar(20)
SET @FechaAplicacion = Getdate()
SET @FechaAplicacion = CONVERT(varchar(8),@FechaAplicacion,112)
SELECT @AutorizarGasto=AutorizarGasto FROM Usuario WHERE Usuario=@Usuario
IF @Modulo = 'CXC' AND @EstatusNuevo in ('PENDIENTE', 'CONCLUIDO')
BEGIN
SELECT @IdPadre = dbo.fnIDOrigenCXCMovMAVI (@ID)
SELECT @MovPadre = Mov, @MovIDPadre = MovID FROM CXC WHERE ID = @IDPadre
UPDATE CXC
SET PadreMAVI = @MovPadre,
PadreIDMAVI = @MovIDPadre
WHERE ID = @ID
END
IF @Modulo = 'CXC' AND @EstatusNuevo in ('CONCLUIDO','PENDIENTE')
BEGIN
SELECT @MovTipo=Clave FROM MovTipo WHERE Modulo = 'CXC' AND Mov = @Mov
IF @MovTipo = 'CXC.CA'
BEGIN
SELECT @Concepto = Concepto FROM Cxc WHERE ID = @ID
IF @Concepto like 'Canc%'
BEGIN
INSERT INTO CXCDNC (ID, Renglon, Aplica, AplicaID)
SELECT  ID, 1, PadreMAVI, PadreIDMAVI from CXC WHERE ID = @ID
END
ELSE
BEGIN
INSERT INTO CXCDNC (ID, Renglon, Aplica, AplicaID)
SELECT  ID, 1, Origen, OrigenID from NegociaMoratoriosMAVI WHERE NotaCargoMorID = @ID
END
END
SELECT @MovTipo=Clave FROM MovTipo WHERE Modulo = 'CXC' AND Mov = @Mov
IF @MovTipo = 'CXC.NC'
BEGIN
INSERT INTO CXCDNC (ID, Renglon, Aplica, AplicaID)
SELECT  ID, 1, Origen, OrigenID from NegociaMoratoriosMAVI WHERE NotaCredBonID = @ID
END
END
/***************************** INICIA COBRO **************************/
IF @Modulo = 'CXC' AND @MovTipo = 'CXC.C' AND @EstatusNuevo = 'CONCLUIDO'
BEGIN
IF NOT EXISTS (SELECT ISNULL(TipoCobro,0) FROM TipoCobroMAVI WHERE IDCobro = @ID )
BEGIN
SELECT @TipoCobro = 0
END ELSE
SELECT @TipoCobro = ISNULL(TipoCobro,0) FROM TipoCobroMAVI WHERE IDCobro = @ID
IF @TipoCobro = 1
BEGIN  
SELECT @PorcMoratorioBonificar = ISNULL(PorcMoratorioBonificar,0), @MoratorioXPagar = ISNULL(MoratorioXPagar,0) FROM CobroXPoliticaHistMAVI WHERE IdCobro = @ID
IF @MoratorioXPagar = 0 SELECT @RemanenteNvo = 0
ELSE
SELECT @RemanenteNvo = @MoratorioXPagar
SELECT @Padre = Origen, @PadreID = OrigenID FROM NegociaMoratoriosMAVI WHERE IDCobro = @ID
UPDATE CobroXPoliticaHistMAVI
SET EstatusCobro = 'CONCLUIDO'
WHERE IDCobro = @ID
DECLARE crCobroPol CURSOR FOR
SELECT Mov, MovID
FROM CXC WHERE PadreMAVI = @Padre AND PAdreIDMAVI = @PadreID AND Estatus = 'PENDIENTE' AND (Vencimiento <= @FechaAplicacion OR InteresesMoratoriosMAVI > 0)
UNION
SELECT Mov, MovID
FROM NegociaMoratoriosMAVI WHERE IDCobro = @ID
UNION
SELECT Mov, MovID FROM CondonaMorxSistMAVI WHERE IDCobro = @ID
GROUP BY Mov, MovID
OPEN crCobroPol
FETCH NEXT FROM crCobroPol INTO  @Mov, @MovID
WHILE @@FETCH_STATUS <> -1
BEGIN  
IF @@FETCH_STATUS <> -2 
BEGIN    
SELECT @IDMovMor = ID, @FechaAnterior = FechaOriginalAnt, @RemananteAnt = InteresMoratorioAnt, @Vencimiento = Vencimiento  FROM CXC WHERE Mov = @Mov AND MovID = @MovID
IF EXISTS(SELECT * FROM HistCobroMoratoriosMAVI WHERE IDCobro = @ID AND Mov = @Mov AND MovID = @MovID)
DELETE HistCobroMoratoriosMAVI WHERE IDCobro= @ID AND  Mov=@Mov AND  MovID=@MovID
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
SET
InteresesMoratoriosMAVI = 0
WHERE ID = @IDMovMor
END
FETCH NEXT FROM crCobroPol INTO  @Mov, @MovID
END
CLOSE crCobroPol
DEALLOCATE crCobroPol
IF  @MoratorioXPagar > 0
BEGIN
SELECT @Remanente = @MoratorioXPagar
SELECT @IDDocPendiente = NULL
SELECT  @IDDocPendiente = MIN(Id) FROM NegociaMoratoriosMAVI WHERE IDCobro = @ID  AND ROUND(ImporteAPagar,0) < ROUND(ImporteReal,0)
IF @IDDocPendiente IS NULL
SELECT @IDDocPendiente = MIN(ID) FROM CXC  WHERE PadreMAVI = @Padre AND PadreIDMAVI = @PadreID AND Estatus = 'PENDIENTE' AND MOVID NOT IN (SELECT MovID FROM NegociaMoratoriosMAVI WHERE IDCobro = @ID )
ELSE
BEGIN
SELECT @MovDocV = Mov, @MovIDDocV = MovID FROM NegociaMoratoriosMAVI WHERE IDCobro = @ID
SELECT @IDDocPendiente = MIN(ID) FROM CXC WHERE PadreMAVI = @Padre AND PadreIDMAVI = @PadreID AND Estatus = 'PENDIENTE' AND Mov = @MovDocV  AND MovID = @MovIDDocV
END
UPDATE CXC SET  InteresesMoratoriosMAVI = ROUND(@MoratorioXPagar, 2)
WHERE ID = @IDDocPendiente 
UPDATE CobroXPoliticaHistMAVI SET IdCxcMasViejo = @DocMasAntiguo WHERE IdCobro =  @ID
END
END  
IF EXISTS(SELECT * FROM CondonaMorxSistMAVI WHERE IDCobro = @ID AND Estatus = 'ALTA')
BEGIN
INSERT INTO CondonaMoratoriosMAVI(Usuario,  FechaAutorizacion, IDMov,   RenglonMov, Mov, MovID,  MontoOriginal,    MontoCondonado, TipoCondonacion, Estatus, IDCobro)
SELECT Usuario, FechaAutorizacion, IDMov, RenglonMov, Mov, MovID, MontoOriginal,    MontoCondonado, TipoCondonacion, Estatus, IDCobro
FROM CondonaMorxSistMAVI WHERE IDCobro = @ID AND Estatus = 'ALTA'
END
IF @TipoCobro = 0
BEGIN
IF (SELECT COUNT(*) FROM CondonaMorxSistMAVI where IdCobro = @ID) > 0
BEGIN
SET @FechaAplicacion = Getdate()
SET @FechaAplicacion = CONVERT(varchar(8),@FechaAplicacion,112)
DECLARE crCondxSist1 CURSOR FOR
SELECT  CondonaMorxSistMAVI.Mov, CondonaMorxSistMAVI.MovID, cxc.ID, cxc.fechaoriginalAnt, cxc.InteresMoratorioAnt  
FROM CondonaMorxSistMAVI
JOIN CXc on cxc.Mov = CondonaMorxSistMAVI.Mov and cxc.MovID = CondonaMorxSistMAVI.MovID
WHERE CondonaMorxSistMAVI.IdCobro = @ID
OPEN crCondxSist1
FETCH NEXT FROM crCondxSist1 INTO  @Mov, @MovID, @CxcID, @FechaOriginal, @ImporteMoratorio
WHILE @@FETCH_STATUS <> -1
BEGIN  
IF @@FETCH_STATUS <> -2
BEGIN    
UPDATE Cxc
SET FechaOriginalAnt = FechaOriginal,
FechaOriginal = @FechaAplicacion
WHERE ID = @CxcID
INSERT INTO HistCobroMoratoriosMAVI(IDCobro, Mov, MOvID, FEchaCobro, FechaOriginalAnt, InteresMoratoriosAnt)
VALUES(@ID, @Mov, @MovID, @FechaAplicacion, @FechaOriginal, @ImporteMoratorio)
END
FETCH NEXT FROM crCondxSist1 INTO @Mov, @MovID, @CxcID, @FechaOriginal, @ImporteMoratorio
END
CLOSE crCondxSist1
DEALLOCATE crCondxSist1
END
DECLARE crHist CURSOR FAST_FORWARD FOR
SELECT Mov, MovID, ImporteMoratorio, MoratorioAPagar, ImporteACondonar, UsuarioCondona
FROM NegociaMoratoriosMAVI
WHERE IDCobro = @ID AND ImporteACondonar = ImporteMoratorio AND ImporteACondonar > 0
OPEN crHist
FETCH NEXT FROM crHist INTO @MovMor, @MovMorID, @ImporteMoratorio, @MoratorioAPagar, @ImporteACondonar, @UsuarioCondona
WHILE @@Fetch_Status =0
BEGIN
INSERT INTO CondonaMoratoriosMAVI(Usuario,  FechaAutorizacion, IDMov,   RenglonMov, Mov, MovID,  MontoOriginal,    MontoCondonado, TipoCondonacion, Estatus, IDCobro)
VALUES(@UsuarioCondona, Getdate(),   @ID, 0,      @MovMor, @MovMorID, @ImporteMoratorio, @ImporteACondonar, 'Por Usuario', 'ALTA', @ID)
FETCH NEXT FROM crHist INTO @MovMor, @MovMorID, @ImporteMoratorio, @MoratorioAPagar, @ImporteACondonar, @UsuarioCondona
END
CLOSE crHist
DEALLOCATE crHist
EXEC spCalculaRemanenteMAVI  @ID, '2'
EXEC spCalculaRemanenteMAVI  @ID, '1'
END
SELECT @ImporteMoratorio = 0
SELECT @MoratorioAPagar = 0
SELECT @PendienteMoratorios = 0
SELECT @ImporteACondonar = 0
SELECT @ID = ID, @Estatus = Estatus, @Mov = Mov, @Usuario = Usuario, @Empresa = Empresa FROM CXC WHERE ID = @ID     
SET @FechaActual = GETDATE()
CREATE TABLE #DetalleCobro(ID  int IDENTITY(1,1) NOT NULL,
IDCobro  int  NULL,
Aplica  varchar(20) NULL,
AplicaID  varchar(20) NULL,
Importe  money NULL)
INSERT INTO #DetalleCobro(IDCobro, Aplica, AplicaID, Importe)
SELECT @ID, Aplica, AplicaID, Importe
FROM CxcD
WHERE ID = @ID
DECLARE C1 CURSOR FAST_FORWARD FOR
SELECT Aplica, AplicaID, Importe
FROM #DetalleCobro
WHERE IDCobro = @ID
OPEN C1
FETCH NEXT FROM C1 INTO @Aplica, @AplicaID, @Importe
WHILE @@Fetch_Status =0
BEGIN
SELECT @ImporteInteres = 0.0, @InteresesMoratorios = 0.0
IF @Aplica in ('Nota Cargo', 'Nota Cargo VIU', 'Nota Cargo Mayoreo')
BEGIN
SELECT @IDD = ID FROM Cxc WHERE Mov = @Aplica AND MovID = @AplicaID
DECLARE crFechaOriginal CURSOR FAST_FORWARD FOR
SELECT Mov, MovID, ImporteMoratorio, MoratorioAPagar, ImporteACondonar, UsuarioCondona
FROM NegociaMoratoriosMAVI
WHERE IDCobro = @ID AND NotaCargoMorId = @IDD AND MoratorioAPagar <> ImporteACondonar
OPEN crFechaOriginal
FETCH NEXT FROM crFechaOriginal INTO @MovMor, @MovMorID, @ImporteMoratorio, @MoratorioAPagar, @ImporteACondonar, @UsuarioCondona
WHILE @@Fetch_Status =0
BEGIN
SELECT @IDMovMor = ID, @FechaAnterior = FechaOriginalAnt, @RemananteAnt = InteresMoratorioAnt FROM CXC WHERE Mov =  @MovMor and MovId = @MovMorID
IF  @ImporteMoratorio <> @MoratorioAPagar  
BEGIN
SELECT @Remanente = ISNULL(Remanente,0)
FROM NegociaMoratoriosMAVI WHERE IDCobro = @ID AND Mov = @MovMor AND MovId = @MovMorID
END
IF @ImporteACondonar > 0 and @ImporteACondonar <> @ImporteMoratorio
BEGIN
IF EXISTS(SELECT * FROM CondonaMoratoriosMAVI WHERE IdCobro = @ID AND IDMov = @IDD
AND TipoCondonacion = 'Por Usuario' AND Estatus = 'ALTA')
BEGIN
UPDATE CondonaMoratoriosMAVI
SET MontoOriginal = @ImporteMoratorio, MontoCondonado = @ImporteACondonar, Usuario = @UsuarioCondona
WHERE IDCobro = @ID AND IDMov = @IDD
AND TipoCondonacion = 'Por Usuario' 
SELECT @Remanente = ISNULL(Remanente,0)
FROM NegociaMoratoriosMAVI WHERE IDCobro = @ID AND Mov = @MovMor AND MovId = @MovMorID
END
ELSE
INSERT INTO CondonaMoratoriosMAVI(Usuario,  FechaAutorizacion, IDMov, RenglonMov, Mov, MovID,  MontoOriginal,    MontoCondonado, TipoCondonacion, Estatus, IDCobro)
VALUES(@UsuarioCondona, Getdate(),   @ID, 0,      @MovMor, @MovMorID, @ImporteMoratorio, @ImporteACondonar, 'Por Usuario', 'ALTA', @ID)
END
FETCH NEXT FROM crFechaOriginal INTO @MovMor, @MovMorID, @ImporteMoratorio, @MoratorioAPagar, @ImporteACondonar, @UsuarioCondona
END
CLOSE crFechaOriginal
DEALLOCATE crFechaOriginal
END
FETCH NEXT FROM C1 INTO @Aplica, @AplicaID, @Importe
END
CLOSE C1
DEALLOCATE C1
DROP TABLE #DetalleCobro
SELECT TOP 1 @dAplica=aplica, @dAplicaID=aplicaid FROM cxcd WHERE id=@ID
SELECT @PadreMAVI=padremavi,@PadreIDMAVI= padreidmavi FROM cxc WHERE mov=@dAplica and movid=@dAplicaID
SELECT @IDPAdreMAVI = Id FROM cxc WHERE mov=@PadreMAVI and movid=@PadreIDMAVI
IF (@PadreMAVI) in ('Nota Cargo','Nota Cargo VIU','Nota Cargo Mayoreo')
BEGIN
SELECT @PadreMAVI = Origen, @PadreIDMAVI = OrigenID FROM NegociaMoratoriosMAVI WHERE NotaCargoMorId = @IDPadreMAVI
SELECT @IDPadreMAVI = ID FROM CXC WHERE Mov = @PadreMAVI AND MovID =  @PadreIDMAVI
END
SELECT @PadreMAVI = Mov FRom CXC WHERE ID = @IDPadreMAVI AND Concepto NOT like 'Canc%'
IF (@PadreMAVI) in ('Nota Cargo','Nota Cargo VIU','Nota Cargo Mayoreo')
BEGIN
SELECT @PadreMAVI = PadreMAVI, @PadreIDMAVI = PadreIDMAVI FROM CXC WHERE Id = @IDPadreMAVI
SELECT @IDPadreMAVI = ID FROM CXC WHERE Mov = @PadreMAVI AND MovID =  @PadreIDMAVI
END
IF (@PadreMAVI) in ('Nota Credito','Nota Credito VIU','Nota Credito Mayoreo')
BEGIN
SELECT @PadreMAVI = Origen, @PadreIDMAVI = OrigenID FROM NegociaMoratoriosMAVI WHERE NotaCredBonID = @IDPadreMAVI
SELECT @IDPadreMAVI = ID FROM CXC WHERE Mov = @PadreMAVI AND MovID =  @PadreIDMAVI
END
END
/***************************** TERMINA COBRO **************************/
/*************** INICIA CANCELACION COBRO ********************/
IF @Modulo = 'CXC' AND @MovTipo = 'CXC.C' AND @EstatusNuevo = 'CANCELADO'
BEGIN
SELECT @TipoCobro = ISNULL(TipoCobro,0) FROM TipoCobroMAVI WHERE IDCobro = @ID
IF @TipoCobro = 0
BEGIN
DECLARE crCancelCobroNor CURSOR FAST_FORWARD FOR
SELECT Mov, MovID FROM
HistCobroMoratoriosMAVI
WHERE IDCobro = @ID
OPEN crCancelCobroNor
FETCH NEXT FROM crCancelCobroNor INTO @MovMor, @MovMorID
WHILE @@Fetch_Status =0
BEGIN 
SELECT @FechaAnterior = NULL, @RemananteAnt = 0, @FechaOrigAnt = NULL,  @InteresesMoratoriosAnt = 0
SELECT @FechaAnterior = FechaOriginalAnt, @RemananteAnt  = InteresMoratoriosAnt
FROM HistCobroMoratoriosMAVI WHERE Mov = @MovMor AND MovID = @MovMorID AND IDCobro = @ID
SELECT @FechaOrigAnt = FechaOriginalAnt, @InteresesMoratoriosAnt = interesmoratorioant, @IDDoc = ID
FROM CXC WHERE Mov = @MovMor AND MovID = @MovMorID
UPDATE CXC
SET FechaOriginal = isnull(FechaOriginalAnt, NULL),
InteresesMoratoriosMAVI = Isnull(Interesmoratorioant,0)
WHERE ID = @IDDoc
UPDATE CXC
SET interesmoratorioant = isnull(@RemananteAnt, 0),
FechaOriginalAnt = Isnull(@FechaAnterior, NULL)
WHERE ID = @IDDoc
IF /*NOT EXISTS (SELECT * FROM CondonaMoratoriosMAVI WHERE Mov = @MovMor AND MovID = @MovMorID AND IDCobro = @ID) AND */@TipoCobro = 0
DELETE HistCobroMoratoriosMAVI WHERE Mov = @MovMor AND MovID = @MovMorID AND IDCobro = @ID
FETCH NEXT FROM crCancelCobroNor INTO @MovMor, @MovMorID
END  
CLOSE crCancelCobroNor
DEALLOCATE crCancelCobroNor
END
IF EXISTS(SELECT * FROM CondonaMoratoriosMAVI WHERE IDCobro = @ID AND Estatus = 'ALTA' AND TipoCondonacion = 'Por Sistema')
BEGIN
DECLARE crCancelCond CURSOR FAST_FORWARD FOR
SELECT Mov, MovID, TipoCondonacion  FROM CondonaMoratoriosMAVI WHERE IDCobro = @ID AND Estatus = 'ALTA' AND TipoCondonacion = 'Por Sistema'
OPEN crCancelCond
FETCH NEXT FROM crCancelCond INTO @MovMor, @MovMorID, @TipoCondonacion 
WHILE @@Fetch_Status =0
BEGIN
UPDATE CondonaMoratoriosMAVI
SET Estatus = 'CANCELADO'
WHERE IDCobro = @ID AND Estatus = 'ALTA' AND TipoCondonacion = 'Por Sistema' AND
Mov = @MovMor AND MovID = @MovMorID
FETCH NEXT FROM crCancelCond INTO @MovMor, @MovMorID, @TipoCondonacion
END
CLOSE crCancelCond
DEALLOCATE crCancelCond
END
/*Se modifico la validacion en el filtro del cursor y el update para que actualice el estatus en condonacion parcial y al 100% BVF 23072010*/
DECLARE crCondxUsua CURSOR FAST_FORWARD FOR
SELECT Mov, MovID, ImporteMoratorio, MoratorioAPagar, ImporteACondonar, UsuarioCondona
FROM NegociaMoratoriosMAVI
WHERE IDCobro = @ID AND ImporteACondonar > 0
OPEN crCondxUsua
FETCH NEXT FROM crCondxUsua INTO @MovMor, @MovMorID, @ImporteMoratorio, @MoratorioAPagar, @ImporteACondonar, @UsuarioCondona
WHILE @@Fetch_Status =0
BEGIN 
UPDATE CondonaMoratoriosMAVI
SET Estatus = 'CANCELADO'
WHERE IDCobro = @ID AND Estatus = 'ALTA' AND
Mov = @MovMor AND MovID = @MovMorID
SELECT @PendienteMoratorios =  ISNULL(@ImporteMoratorio,0) - ISNULL(@ImporteACondonar,0) - ISNULL(@MoratorioAPagar,0)
SELECT @IDMovMor = ID FROM CXC WHERE Mov = @MovMor AND MovID = @MovMorID
FETCH NEXT FROM crCondxUsua INTO @MovMor, @MovMorID, @ImporteMoratorio, @MoratorioAPagar, @ImporteACondonar, @UsuarioCondona
END  
CLOSE crCondxUsua
DEALLOCATE crCondxUsua
IF EXISTS( SELECT * FROM CXC WHERE IDCobroBonifMAVI = @ID ) 
BEGIN
DECLARE crCancBon CURSOR FAST_FORWARD FOR
SELECT ID FROM CXC
WHERE IDCobroBonifMAVI = @ID AND Estatus  in ('PENDIENTE','CONCLUIDO' )
OPEN crCancBon
FETCH NEXT FROM crCancBon INTO @IDNCBon
WHILE @@Fetch_Status =0
BEGIN 
EXEC spAfectar 'CXC', @IDNCBon, 'CANCELAR', 'Todo', NULL, @Usuario,  NULL, 1, @Ok OUTPUT, @OkRef OUTPUT,NULL, @Conexion = 1
FETCH NEXT FROM crCancBon INTO @IDNCBon
END
CLOSE crCancBon
DEALLOCATE crCancBon
END
IF @TipoCobro = 1
BEGIN 
IF EXISTS(SELECT * FROM CobroXPoliticaHistMAVI WHERE IdCobro = @ID )
BEGIN
UPDATE CobroXPoliticaHistMAVI
SET EstatusCobro = 'CANCELADO'
WHERE IDCobro = @ID
SELECT @Origen = Mov, @OrigenID = MovID From CobroXPoliticaHistMAVI WHERE IdCobro = @ID
SELECT @IdCobroCargoMoratorioEstAnt = MAX(IDcobro) FROM  CobroXPoliticaHistMAVI WHERE Mov = @Origen AND MovID = @OrigenID 
AND EstatusCobro = 'CONCLUIDO'
IF @IdCobroCargoMoratorioEstAnt >0
BEGIN
SET @Estadistico = 0
SELECT @Estadistico = IdCargoMoratorioEst FROM CobroXPoliticaHistMAVI WHERE IdCobro = @IdCobroCargoMoratorioEstAnt
IF @Estadistico > 0
BEGIN
UPDATE CobroXPoliticaHistMAVI SET EstatusCargoMorEst = 'CONCLUIDO' WHERE IDCobro = @IdCobroCargoMoratorioEstAnt
UPDATE Cxc SET Estatus = 'CONCLUIDO' WHERE ID= @Estadistico
END 
END
SELECT @IdCargoMoratorioEst = IdCargoMoratorioEst FROM CobroXPoliticaHistMAVI WHERE IdCobro = @ID
IF @IdCargoMoratorioEst > 0
BEGIN
UPDATE CobroXPoliticaHistMAVI
SET EstatusCargoMorEst = 'CANCELADO'
WHERE IdCobro = @ID
EXEC spAfectar 'CXC', @IdCargoMoratorioEst, 'CANCELAR', 'Todo', NULL, @Usuario,  NULL, 1, @Ok OUTPUT, @OkRef OUTPUT,NULL, @Conexion = 1
END  
END 
CREATE TABLE #HIST(ID int NULL)
INSERT INTO #HIST
SELECT c.id FROM
HistCobroMoratoriosMAVI h, cxc c
WHERE h.IDCobro = @ID  and c.mov=h.mov and c.movid=h.movid
DECLARE crCancelCobroPol CURSOR FAST_FORWARD FOR
SELECT Mov, MovID FROM
HistCobroMoratoriosMAVI
WHERE IDCobro = @ID
OPEN crCancelCobroPol
FETCH NEXT FROM crCancelCobroPol INTO @MovMor, @MovMorID
WHILE @@Fetch_Status =0
BEGIN 
SELECT @FechaAnterior = NULL, @RemananteAnt = 0, @FechaOrigAnt = NULL,  @InteresesMoratoriosAnt = 0
SELECT @IDMAx = MAX(IDCobro) FROM HistCobroMoratoriosMAVI
WHERE Mov = @MovMor AND MovID = @MovMorID
SELECT @FechaAnterior = FechaOriginalAnt,
@RemananteAnt  = InteresMoratoriosAnt
FROM HistCobroMoratoriosMAVI
WHERE Mov = @MovMor AND MovID = @MovMorID AND IDCobro = @IDMAx
SELECT @FechaOrigAnt = FechaOriginalAnt, @InteresesMoratoriosAnt = interesmoratorioant, @IDDoc = ID FROM CXC WHERE Mov = @MovMor AND MovID = @MovMorID
UPDATE CXC
SET FechaOriginal = @FechaOrigAnt,
InteresesMoratoriosMAVI = @InteresesMoratoriosAnt,
interesmoratorioant = @RemananteAnt,
FechaOriginalAnt = @FechaAnterior
WHERE ID = @IDDoc
DELETE HistCobroMoratoriosMAVI WHERE Mov = @MovMor AND MovID = @MovMorID AND IDCobro = @IDMAx
FETCH NEXT FROM crCancelCobroPol INTO @MovMor, @MovMorID
END  
CLOSE crCancelCobroPol
DEALLOCATE crCancelCobroPol
SET @FechaAplicacion = Getdate()
SET @FechaAplicacion = CONVERT(varchar(8),@FechaAplicacion,112)
set @IDDoc=NULL
SELECT @Padre = Origen, @PadreID = OrigenID FROM NegociaMoratoriosMAVI WHERE IDCobro = @ID
SELECT @IDDoc=MIN(ID)
FROM CXC WHERE PadreMAVI = @Padre AND PAdreIDMAVI = @PadreID AND Estatus = 'PENDIENTE' AND (Vencimiento <= @FechaAplicacion OR InteresesMoratoriosMAVI > 0)
AND ID NOT IN (SELECT ID FROM #HIST)
IF @IDDoc IS NOT NULL
BEGIN
SELECT @FechaAnterior = NULL, @RemananteAnt = 0, @FechaOrigAnt = NULL,  @InteresesMoratoriosAnt = 0
SELECT @FechaAnterior=vencimiento, @FechaOrigAnt = FechaOriginalAnt, @InteresesMoratoriosAnt = isnull(interesmoratorioant,0) FROM CXC WHERE ID=@IDDoc
UPDATE CXC
SET FechaOriginal = @FechaOrigAnt,
InteresesMoratoriosMAVI = @InteresesMoratoriosAnt,
interesmoratorioant = @RemananteAnt,
FechaOriginalAnt = @FechaAnterior
WHERE ID = @IDDoc
END
DROP TABLE #HIST
END     
END
IF @Modulo = 'CXC' AND @EstatusNuevo in ('CONCLUIDO','PENDIENTE')
BEGIN
DECLARE @SucursalV int, @OT varchar(10)
IF @MovTipo in ('CXC.F','CXC.CAP')
BEGIN
SELECT @OT = (SELECT OrigenTipo FROM CXC WHERE ID=@ID)
IF @OT='VTAS'
BEGIN
SELECT @SucursalV = (SELECT v.Sucursal FROM Venta v, CXC c WHERE C.ID=@ID AND v.Mov=c.Origen AND v.MovID=c.OrigenID)
UPDATE CXC SET Sucursal = @SucursalV WHERE ID=@ID
UPDATE CXC SET SucursalOrigen = @SucursalV WHERE ID=@ID
END
END
END
/* Integracion CFDFlex BVF 01062012 */
SELECT @CFDFlex = ISNULL(CFDFlex,0), @eDoc = ISNULL(eDoc,0)
FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @MovTipoCFDFlex = ISNULL(CFDFlex,0)
FROM MovTipo WHERE Mov = @Mov AND Modulo = @Modulo
IF @Modulo = 'CXC'
BEGIN
SELECT @MovTipo=MovTIpo.Clave, @Mov = cxc.Mov FROM CXC JOIN MovTipo  ON MovTipo.Mov = CXC.Mov
WHERE MovTipo.Modulo = 'CXC' AND CXC.ID = @ID
IF @MovTipo = 'CXC.CA'
BEGIN
SELECT @IDPadreMAVI = c.ID FROM CXC c JOIN NegociaMoratoriosMAVI d ON c.Mov = d.Mov AND c.MovID = d.MovID WHERE d.IDCobro=@ID
SELECT @MovTipo=MovTIpo.Clave FROM CXC JOIN MovTipo  ON MovTipo.Mov = CXC.Mov
WHERE MovTipo.Modulo = 'CXC' AND CXC.ID = @IDPadreMAVI
IF @MovTipo = 'CXC.CA'
BEGIN
SELECT @Concepto = Concepto, @MovIDPadre = MovID FROM Cxc WHERE ID = @IDPadreMAVI
IF @Concepto LIKE '%SALDO%' OR @MovIDPadre Like 'Z%'
BEGIN
SELECT @MovTipoCFDFlex = 0, @eDoc = 0
Print 'Nota Cargo Saldo Inicial o Recaptura: '+ @MovIDPAdre
END
END
END
IF @Mov in ('Cobro', 'Cobro Instituciones', 'Cobro Credito')
BEGIN
SELECT TOP 1 @IDPadreMAVI = p.ID
FROM Cxc c JOIN CxcD d ON c.Mov = d.Aplica AND c.MovID = d.AplicaID
JOIN CXC p  ON c.PadreMAVI = p.Mov AND c.PadreIDMAVI = p.MovID
WHERE d.ID = @ID
GROUP BY p.ID
IF @IDPadreMAVI IS NULL
SELECT @IDPadreMAVI = c.ID FROM CXC c JOIN NegociaMoratoriosMAVI d ON c.Mov = d.Origen AND c.MovID = d.OrigenID WHERE d.IDCobro=@ID
Print 'CXCDetalle: '+ Convert(Varchar(20),isnull(@IDPadreMAVI,999999))
SELECT @MovTipo=MovTIpo.Clave FROM CXC JOIN MovTipo  ON MovTipo.Mov = CXC.Mov
WHERE MovTipo.Modulo = 'CXC' AND CXC.ID = @IDPadreMAVI
IF @MovTipo = 'CXC.CA'
BEGIN
SELECT @Concepto = Concepto, @MovIDPadre = MovID FROM Cxc WHERE ID = @IDPadreMAVI
IF @Concepto LIKE '%SALDO%' OR @MovIDPadre Like 'Z%'
BEGIN
SELECT @MovTipoCFDFlex = 0, @eDoc = 0
Print 'Nota Cargo Saldo Inicial o Recaptura: '+ @MovIDPAdre
END
ELSE
BEGIN
IF @Concepto like 'Canc%'
BEGIN
SELECT  @PadreMAVI = PadreMAVI, @PadreIDMAVI = PadreIDMAVI from CXC WHERE ID = @IDPadreMAVI
END
ELSE
BEGIN
SELECT  @PadreMAVI=Origen, @PadreIDMAVI=OrigenID from NegociaMoratoriosMAVI WHERE NotaCargoMorID = @ID         
END
SELECT @IDPAdreMAVI = ID FROM CXC WHERE Mov= @PadreMAVI AND MovID = @PadreIDMAVI
END
END
IF @MovTipo = 'CXC.NC'
BEGIN
SELECT  @PadreMAVI=Origen, @PadreIDMAVI=OrigenID from NegociaMoratoriosMAVI WHERE NotaCredBonID = @ID
SELECT @IDPAdreMAVI = ID FROM CXC WHERE Mov= @PadreMAVI AND MovID = @PadreIDMAVI
END
SELECT @PadreMAVI = Mov, @Condicion = Condicion FROM CXC WHERE ID = @IDPadreMAVI
IF (SELECT ConsecutivoFiscal  from movtipo where mov = @PadreMAVI AND Modulo = 'CXC') = 0
SELECT @MovTipoCFDFlex = 0, @eDoc = 0
IF (SELECT Concepto FROM CXC WHERE ID = @IDPadreMAVI ) like '%Canc%'
SELECT @MovTipoCFDFlex = 0, @eDoc = 0
SELECT @Condicion = CFD_metodoDePago FROM Condicion WHERE Condicion = @Condicion
IF @Condicion = 'CONTADO'
SELECT @MovTipoCFDFlex = 0, @eDoc = 0
END
END
RETURN
END

