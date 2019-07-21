SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spActualizarProgramaRecuperacionMAVI
@ID					int

AS BEGIN
DECLARE
@Mov                varchar(20),
@MovID              varchar(20),
@Estatus            varchar(15),
@CxcMov             varchar(20),
@CxcMovID           varchar(20),
@CxcImporte         money,
@TotalDoctos        int,
@Cont               int,
@Vencimiento        datetime,
@CxcID              int,
@FechaEmision       datetime,
@EjercicioTmp       int,
@PeriodoTmp         int,
@PorcentajeCapital    float,
@PorcentajeFinanciamiento float,
@CxcRenglon           float,
@Cobro                money,
@PagoFinanciamiento   money,
@Renglon              int,
@CxcOrigenMov         varchar(20),
@CxcOrigenMovID       varchar(20),
@CxcDescuentoRecargos    money,
@CxcOrigenMovTmp      varchar(20),
@CxcOrigenMovIDTmp    varchar(20),
@CxcOrigenMovTmp2      varchar(20),
@CxcOrigenMovIDTmp2    varchar(20),
@Condicion			   varchar(50), 
@MovAplica			   varchar(20), 
@MovAplicaID		   varchar(20),  
@OrigenTipo			   varchar(10),  
@EsCredilana		   bit, 
@Mayor12Meses           bit, 
@MovTipo			   varchar(20),
@NumMeses			   int,  
@EsNC                  bit,  
@Recuperacion		   money,
@Creditos			   money,
@EsPuente			   bit,
@MovPuente			   varchar(20),
@MovIDPuente		   varchar(20),
@IDPuente			   int
SET @Mov = NULL
SET @MovID = NULL
SET @Estatus = NULL
SET @CxcMov = NULL
SET @CxcMovID = NULL
SET @CxcImporte = 0.0
SET @TotalDoctos = 0
SET @Cont = 0
SET @Vencimiento = NULL
SET @CxcID = 0
SET @FechaEmision = NULL
SET @EjercicioTmp = 0
SET @PeriodoTmp = 0
SET @PorcentajeCapital = 0.0
SET @PorcentajeFinanciamiento = 0.0
SET @CxcRenglon = 0.0
SET @Cobro = 0.0
SET @PagoFinanciamiento = 0.0
SET @Renglon = 0
SET @CxcOrigenMov = NULL
SET @CxcOrigenMovID = NULL
SET @CxcDescuentoRecargos = 0.0
SET @CxcOrigenMovTmp = NULL
SET @CxcOrigenMovIDTmp = NULL
SET @CxcOrigenMovTmp2 = NULL
SET @CxcOrigenMovIDTmp2 = NULL
SET @Condicion = NULL
SET @MovAplica = NULL
SET @MovAplicaID = NULL
SET @EsCredilana = 0
SET @Mayor12Meses = 0
SET @MovTipo = NULL
SET @NumMeses = 0
SET @EsNC = 0
SET @Recuperacion = 0.0
SET @Creditos = 0.0
SELECT @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @FechaEmision = ISNULL(FechaEmision,0), @Vencimiento = ISNULL(Vencimiento,0), @Condicion = Condicion, @MovAplica = MovAplica, @MovAplicaID = MovAplicaID, @OrigenTipo = OrigenTipo FROM Cxc WHERE ID =  @ID /* Se agregaron las variables MovAPlica, MovAplicaID, COndicion, OrigenTipo para determinar el campo mayor12meses y escredilana (Arly Rubio Camacho) 02-10-08 */
/* Inicio llenar el campo Mayor12Meses y EsCredilanas en Movimientos Generados en Cxc */
SELECT @MovTipo = Clave FROM MovTipo WHERE Modulo = 'CXC' AND Mov = @Mov
IF @MovTipo IN('CXC.CA', 'CXC.D', 'CXC.DP', 'CXC.CD', 'CXC.CAP', 'CXC.FAC')
BEGIN
IF @OrigenTipo <> 'VTAS' AND @Estatus IN('Concluido', 'Pendiente')
BEGIN
IF @MovTipo = 'CXC.FAC'
BEGIN
SELECT @Mayor12Meses = Mayor12Meses, @EsCredilana = EsCredilana FROM Cxc WHERE Mov = @MovAplica AND MovID = @MovAplicaID AND Estatus IN('Pendiente', 'Concluido')
UPDATE Cxc SET Mayor12Meses = @Mayor12Meses, EsCredilana = @EsCredilana WHERE ID = @ID
END
ELSE
BEGIN
SELECT @Mayor12Meses = Mayor12Meses FROM Cxc WHERE ID = @ID
IF @Mayor12Meses IS NULL OR @Mayor12Meses = ''
BEGIN
IF @Condicion <> '(Fecha)'  
BEGIN
SELECT @NumMeses = dbo.fnMayor12MesesMAVI(@Condicion) 
/**** MODIFICACION DE MAYOR12MESES DE MAYOR A MAYOR O IGUAL  *****/
IF @NumMeses >= 12
BEGIN
SELECT @Mayor12Meses = 1
UPDATE Cxc SET Mayor12Meses = 1 WHERE ID = @ID
END
ELSE
BEGIN
SELECT @Mayor12Meses = 0
UPDATE Cxc SET Mayor12Meses = 0 WHERE ID = @ID
END
END
ELSE
BEGIN
SELECT @NumMeses = DateDiff(d,ISNULL(@FechaEmision, GETDATE()),ISNULL(@Vencimiento, GETDATE()))
SELECT @NumMeses = ISNULL(@NumMeses, 0)/30
/**** MODIFICACION DE MAYOR12MESES DE MAYOR A MAYOR O IGUAL  *****/
IF @NumMeses >= 12
BEGIN
SELECT @Mayor12Meses = 1
UPDATE Cxc SET Mayor12Meses = 1 WHERE ID = @ID
END
ELSE
BEGIN
SELECT @Mayor12Meses = 0
UPDATE Cxc SET Mayor12Meses = 0 WHERE ID = @ID
END
END  
END
IF @Estatus = 'Concluido'
BEGIN
UPDATE Cxc SET Mayor12Meses = @Mayor12Meses, EsCredilana = @EsCredilana WHERE Mov = 'Documento' AND OrigenTipo = 'CXC' AND Origen = @Mov AND OrigenID = @MovID AND Estatus IN('PENDIENTE','CONCLUIDO')
END
END
END
END
IF @Mov IN('Cobro','Cancela Prestamo','Cancela Credilana','Aplicacion','Nota Credito','Cobro Instituciones') AND @Estatus = 'Concluido'
BEGIN
IF @MovTipo = 'CXC.NC'
SELECT @EsNC = 1
ELSE
BEGIN
IF @MovTipo = 'CXC.ANC'
BEGIN
IF @MovAplica IN('Cancela Prestamo','Cancela Credilana','Nota Credito')
SELECT @EsNC = 1
ELSE
SELECT @EsNC = 0
END
ELSE
SELECT @EsNC = 0
END
SELECT @PeriodoTmp = ISNULL(MONTH(@FechaEmision), 0)  
SELECT @EjercicioTmp = ISNULL(YEAR(@FechaEmision), 0) 
SELECT @TotalDoctos = COUNT(*) FROM CxcD WHERE ID = @ID
IF @TotalDoctos > 0
BEGIN
DECLARE DoctosACobrar CURSOR FOR SELECT C.Renglon, C.Importe, C.Aplica, C.AplicaID, C.DescuentoRecargos FROM CxcD C WHERE ID = @ID
OPEN DoctosACobrar
SET @Cont = 0
WHILE @Cont < @TotalDoctos
BEGIN  
FETCH NEXT FROM DoctosACobrar
INTO @CxcRenglon, @CxcImporte, @CxcMov, @CxcMovID, @CxcDescuentoRecargos     
SET @EsPuente = 0
IF @CxcMov IN('Cta Incobrable NV', 'Contra Recibo Inst')
BEGIN 
IF @CxcMov = 'Cta Incobrable NV' AND @EsNC = 1
BEGIN 
SELECT @EsPuente = 1
SELECT @MovPuente = @CxcMov, @MovIDPuente = @CxcMovID
SELECT @IDPuente = ID FROM Cxc WHERE Mov = @CxcMov AND MovID = @CxcMovID AND Estatus IN('Pendiente', 'Concluido')
SELECT TOP 1 @CxcMov = Aplica, @CxcMovID = AplicaID FROM CxcD WHERE ID = @IDPuente
END 
ELSE
BEGIN 
IF @CxcMov = 'Contra Recibo Inst'
BEGIN
SELECT @EsPuente = 1
SELECT @MovPuente = @CxcMov, @MovIDPuente = @CxcMovID
SELECT @IDPuente = ID FROM Cxc WHERE Mov = @CxcMov AND MovID = @CxcMovID AND Estatus IN('Pendiente', 'Concluido')
SELECT TOP 1 @CxcMov = Aplica, @CxcMovID = AplicaID FROM CxcD WHERE ID = @IDPuente
END
END 
END 
IF @CxcMov IN('Credilana','Prestamo Personal') 
BEGIN
SELECT @CxcID = ID FROM Cxc WHERE Mov = @CxcMov AND MovID = @CxcMovID
IF EXISTS(SELECT ID FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID)
BEGIN 
IF EXISTS(SELECT ID FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp) 
BEGIN
SELECT @Creditos = ISNULL(Creditos, 0.0), @Cobro = ISNULL(Cobros, 0.0), @PorcentajeFinanciamiento = ISNULL(PorcentajeFinanciamiento, 0.0), @Renglon = ISNULL(Renglon, 0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
IF @EsNC = 1
SELECT @Creditos = (@Creditos + ISNULL(@CxcImporte, 0.0))
ELSE
SELECT @Cobro = (@Cobro + ISNULL(@CxcImporte, 0.0))
SELECT @Recuperacion = ISNULL(@Cobro, 0.0) 
SELECT @PagoFinanciamiento = @Recuperacion * @PorcentajeFinanciamiento
IF (@Recuperacion >= 0 AND @PagoFinanciamiento >= 0)
BEGIN
IF @EsNC = 1
BEGIN
UPDATE  RecuperacionCredilanasPPMAVI SET Creditos = @Creditos, PagoFinanciamiento = @PagoFinanciamiento WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC) VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), 0.0, @FechaEmision, @CxcImporte, @EsNC)
END
ELSE
BEGIN
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
UPDATE  RecuperacionCredilanasPPMAVI SET Cobros = @Cobro, PagoFinanciamiento = @PagoFinanciamiento WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC) VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), @CxcImporte, @FechaEmision, 0.0, @EsNC)
END
EXEC sp_ActualizaProgaramaFinanciamientoMAVI @CxcID
END
END  
ELSE
BEGIN 
SELECT @PorcentajeFinanciamiento = ISNULL(PorcentajeFinanciamiento, 0.0), @PorcentajeCapital = ISNULL(PorcentajeCapital, 0.0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID
SELECT @PagoFinanciamiento = (ISNULL(@CxcImporte, 0.0) * @PorcentajeFinanciamiento)
IF @EsNC = 1
BEGIN
SELECT @PagoFinanciamiento = 0.0
INSERT RecuperacionCredilanasPPMAVI (ID, Periodo, Ejercicio, FechaEmision, Vencimiento, Exigible, Cobros, Anterior, ExigiblePagado, Adelantado, PorcentajeCapital, PorcentajeFinanciamiento, PagoFinanciamiento, Ordinario, Arrastre, Cobertura, Creditos)
VALUES (@CxcID, @PeriodoTmp, @EjercicioTmp, @FechaEmision, @FechaEmision, 0.0, 0.0, 0.0, 0.0, 0.0, @PorcentajeCapital, @PorcentajeFinanciamiento, @PagoFinanciamiento, 0, 0.0, 0.0, @CxcImporte)
END
ELSE
BEGIN
INSERT RecuperacionCredilanasPPMAVI (ID, Periodo, Ejercicio, FechaEmision, Vencimiento, Exigible, Cobros, Anterior, ExigiblePagado, Adelantado, PorcentajeCapital, PorcentajeFinanciamiento, PagoFinanciamiento, Ordinario, Arrastre, Cobertura, Creditos)
VALUES (@CxcID, @PeriodoTmp, @EjercicioTmp, @FechaEmision, @FechaEmision, 0.0, @CxcImporte, 0.0, 0.0, 0.0, @PorcentajeCapital, @PorcentajeFinanciamiento, @PagoFinanciamiento, 0, 0.0, 0.0, 0.0)
END
SELECT @Renglon = ISNULL(Renglon, 0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
IF @EsNC = 1
BEGIN
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC)
VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), 0.0, @FechaEmision, @CxcImporte, @EsNC)
END
ELSE
BEGIN
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC)
VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), @CxcImporte, @FechaEmision, 0.0, @EsNC)
END
EXEC sp_ActualizaProgaramaFinanciamientoMAVI @CxcID
END  
END  
END  
ELSE
BEGIN 
IF @CxcMov IN('Documento')
BEGIN
SELECT @CxcOrigenMov = Origen, @CxcOrigenMovID = OrigenID FROM Cxc WHERE Mov = @CxcMov AND MovID = @CxcMovID 
IF @CxcOrigenMov IN('Credilana','Prestamo Personal')
BEGIN 
SELECT @CxcID = ID FROM Cxc WHERE Mov = @CxcOrigenMov AND MovID = @CxcOrigenMovID 
IF EXISTS(SELECT ID FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID)
BEGIN 
IF EXISTS(SELECT ID FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp) 
BEGIN
SELECT @Cobro = ISNULL(Cobros, 0.0), @Creditos = ISNULL(Creditos, 0.0), @PorcentajeFinanciamiento = ISNULL(PorcentajeFinanciamiento, 0.0), @Renglon = ISNULL(Renglon, 0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
IF @EsNC = 1
SELECT @Creditos = (@Creditos + ISNULL(@CxcImporte, 0.0))
ELSE
SELECT @Cobro = (@Cobro + ISNULL(@CxcImporte, 0.0))
SELECT @Recuperacion = ISNULL(@Cobro, 0.0) 
SELECT @PagoFinanciamiento = @Recuperacion * @PorcentajeFinanciamiento
IF (@Recuperacion >= 0 AND @PagoFinanciamiento >= 0)
BEGIN
IF @EsNC = 1
BEGIN
UPDATE  RecuperacionCredilanasPPMAVI SET Creditos = @Creditos, PagoFinanciamiento = @PagoFinanciamiento WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, EsNC, NCImporte) VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), 0.0, @FechaEmision, @EsNC, @CxcImporte)
END
ELSE
BEGIN
UPDATE  RecuperacionCredilanasPPMAVI SET Cobros = @Cobro, PagoFinanciamiento = @PagoFinanciamiento WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC) VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), @CxcImporte, @FechaEmision, 0.0, @EsNC)
END
EXEC sp_ActualizaProgaramaFinanciamientoMAVI @CxcID
END
END  
ELSE
BEGIN 
SELECT @PorcentajeFinanciamiento = ISNULL(PorcentajeFinanciamiento, 0.0), @PorcentajeCapital = ISNULL(PorcentajeCapital, 0.0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID
SELECT @PagoFinanciamiento = (ISNULL(@CxcImporte, 0.0) * @PorcentajeFinanciamiento)
IF @EsNC = 1
BEGIN
SELECT @PagoFinanciamiento = 0.0
INSERT RecuperacionCredilanasPPMAVI (ID, Periodo, Ejercicio, FechaEmision, Vencimiento, Exigible, Cobros, Anterior, ExigiblePagado, Adelantado, PorcentajeCapital, PorcentajeFinanciamiento, PagoFinanciamiento, Ordinario, Arrastre, Cobertura, Creditos)
VALUES (@CxcID, @PeriodoTmp, @EjercicioTmp, @FechaEmision, @FechaEmision, 0.0, 0.0, 0.0, 0.0, 0.0, @PorcentajeCapital, @PorcentajeFinanciamiento, @PagoFinanciamiento, 0, 0.0, 0.0, @CxcImporte)
END
ELSE
BEGIN
INSERT RecuperacionCredilanasPPMAVI (ID, Periodo, Ejercicio, FechaEmision, Vencimiento, Exigible, Cobros, Anterior, ExigiblePagado, Adelantado, PorcentajeCapital, PorcentajeFinanciamiento, PagoFinanciamiento, Ordinario, Arrastre, Cobertura, Creditos)
VALUES (@CxcID, @PeriodoTmp, @EjercicioTmp, @FechaEmision, @FechaEmision, 0.0, @CxcImporte, 0.0, 0.0, 0.0, @PorcentajeCapital, @PorcentajeFinanciamiento, @PagoFinanciamiento, 0, 0.0, 0.0, 0.0)
END
SELECT @Renglon = ISNULL(Renglon, 0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
IF @EsNC = 1
BEGIN
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC)
VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), 0.0, @FechaEmision, @CxcImporte, @EsNC)
END
ELSE
BEGIN
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC)
VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), @CxcImporte, @FechaEmision, 0.0, @EsNC)
END
EXEC sp_ActualizaProgaramaFinanciamientoMAVI @CxcID
END  
END  
END 
END
IF @CxcMov = 'Endoso'
BEGIN
SELECT @CxcOrigenMov = MovAplica, @CxcOrigenMovID = MovAplicaID FROM Cxc WHERE Mov = @CxcMov AND MovID = @CxcMovID AND Estatus IN('PENDIENTE', 'CONCLUIDO')
IF @CxcOrigenMov IN('Credilana','Prestamo Personal')  
BEGIN
SELECT @CxcID = ID FROM Cxc WHERE Mov = @CxcOrigenMov AND MovID = @CxcOrigenMovID AND Estatus IN('CONCLUIDO','PENDIENTE') 
IF EXISTS(SELECT ID FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID)
BEGIN 
IF EXISTS(SELECT ID FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp) 
BEGIN
SELECT @Cobro = ISNULL(Cobros, 0.0), @Creditos = ISNULL(Creditos, 0.0), @PorcentajeFinanciamiento = ISNULL(PorcentajeFinanciamiento, 0.0), @Renglon = ISNULL(Renglon, 0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
IF @EsNC = 1
SELECT @Creditos = (@Creditos + ISNULL(@CxcImporte, 0.0))
ELSE
SELECT @Cobro = (@Cobro + ISNULL(@CxcImporte, 0.0))
SELECT @Recuperacion = ISNULL(@Cobro, 0.0) 
SELECT @PagoFinanciamiento = @Recuperacion * @PorcentajeFinanciamiento
IF (@Recuperacion >= 0 AND @PagoFinanciamiento >= 0)
BEGIN
IF @EsNC = 1
BEGIN
UPDATE  RecuperacionCredilanasPPMAVI SET Creditos = @Creditos, PagoFinanciamiento = @PagoFinanciamiento WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC) VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), 0.0, @FechaEmision, @CxcImporte, @EsNC)
END
ELSE
BEGIN
UPDATE  RecuperacionCredilanasPPMAVI SET Cobros = @Cobro, PagoFinanciamiento = @PagoFinanciamiento WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC) VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), @CxcImporte, @FechaEmision, 0.0, @EsNC)
END
EXEC sp_ActualizaProgaramaFinanciamientoMAVI @CxcID
END
END  
ELSE
BEGIN 
SELECT @PorcentajeFinanciamiento = ISNULL(PorcentajeFinanciamiento, 0.0), @PorcentajeCapital = ISNULL(PorcentajeCapital, 0.0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID
SELECT @PagoFinanciamiento = (ISNULL(@CxcImporte, 0.0) * @PorcentajeFinanciamiento)
IF @EsNC = 1
BEGIN
SELECT @PagoFinanciamiento = 0.0
INSERT RecuperacionCredilanasPPMAVI (ID, Periodo, Ejercicio, FechaEmision, Vencimiento, Exigible, Cobros, Anterior, ExigiblePagado, Adelantado, PorcentajeCapital, PorcentajeFinanciamiento, PagoFinanciamiento, Ordinario, Arrastre, Cobertura, Creditos)
VALUES (@CxcID, @PeriodoTmp, @EjercicioTmp, @FechaEmision, @FechaEmision, 0.0, 0.0, 0.0, 0.0, 0.0, @PorcentajeCapital, @PorcentajeFinanciamiento, @PagoFinanciamiento, 0, 0.0, 0.0, @CxcImporte)
SELECT @Renglon = ISNULL(Renglon, 0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, EsNC, NCImporte)
VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), 0.0, @FechaEmision, @EsNC, @CxcImporte)
END
ELSE
BEGIN
INSERT RecuperacionCredilanasPPMAVI (ID, Periodo, Ejercicio, FechaEmision, Vencimiento, Exigible, Cobros, Anterior, ExigiblePagado, Adelantado, PorcentajeCapital, PorcentajeFinanciamiento, PagoFinanciamiento, Ordinario, Arrastre, Cobertura, Creditos)
VALUES (@CxcID, @PeriodoTmp, @EjercicioTmp, @FechaEmision, @FechaEmision, 0.0, @CxcImporte, 0.0, 0.0, 0.0, @PorcentajeCapital, @PorcentajeFinanciamiento, @PagoFinanciamiento, 0, 0.0, 0.0, 0.0)
SELECT @Renglon = ISNULL(Renglon, 0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, EsNC, NCImporte)
VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), @CxcImporte, @FechaEmision, @EsNC, 0.0)
END
EXEC sp_ActualizaProgaramaFinanciamientoMAVI @CxcID
END  
END  
END 
IF @CxcOrigenMov = 'Documento'  
BEGIN
SELECT @CxcOrigenMovTmp = Origen, @CxcOrigenMovIDTmp = OrigenID FROM Cxc WHERE Mov = @CxcOrigenMov AND MovID = @CxcOrigenMovID AND Estatus IN('CONCLUIDO','PENDIENTE') 
IF @CxcOrigenMovTmp IN('Credilana','Prestamo Personal')
BEGIN 
SELECT @CxcID = ID FROM Cxc WHERE Mov = @CxcOrigenMovTmp AND MovID = @CxcOrigenMovIDTmp AND Estatus IN('PENDIENTE','CONCLUIDO') 
IF EXISTS(SELECT ID FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID)
BEGIN 
IF EXISTS(SELECT ID FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp) 
BEGIN
SELECT @Cobro = ISNULL(Cobros, 0.0), @Creditos = ISNULL(Creditos, 0.0), @PorcentajeFinanciamiento = ISNULL(PorcentajeFinanciamiento, 0.0), @Renglon = ISNULL(Renglon, 0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
IF @EsNC = 1
SELECT @Creditos = (@Creditos + ISNULL(@CxcImporte, 0.0))
ELSE
SELECT @Cobro = (@Cobro + ISNULL(@CxcImporte, 0.0))
SELECT @Recuperacion = ISNULL(@Cobro, 0.0) 
SELECT @PagoFinanciamiento = @Recuperacion * @PorcentajeFinanciamiento
IF (@Recuperacion >= 0 AND @PagoFinanciamiento >= 0)
BEGIN
IF @EsNC = 1
BEGIN
UPDATE  RecuperacionCredilanasPPMAVI SET Creditos = @Creditos, PagoFinanciamiento = @PagoFinanciamiento WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC) VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), 0.0, @FechaEmision, @CxcImporte, @EsNC)
END
ELSE
BEGIN
UPDATE  RecuperacionCredilanasPPMAVI SET Cobros = @Cobro, PagoFinanciamiento = @PagoFinanciamiento WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC) VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), @CxcImporte, @FechaEmision, 0.0, @EsNC)
END
EXEC sp_ActualizaProgaramaFinanciamientoMAVI @CxcID
END
END  
ELSE
BEGIN 
SELECT @PorcentajeFinanciamiento = ISNULL(PorcentajeFinanciamiento, 0.0), @PorcentajeCapital = ISNULL(PorcentajeCapital, 0.0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID
SELECT @PagoFinanciamiento = (ISNULL(@CxcImporte, 0.0) * @PorcentajeFinanciamiento)
IF @EsNC = 1
BEGIN
SELECT @PagoFinanciamiento = 0.0
INSERT RecuperacionCredilanasPPMAVI (ID, Periodo, Ejercicio, FechaEmision, Vencimiento, Exigible, Cobros, Anterior, ExigiblePagado, Adelantado, PorcentajeCapital, PorcentajeFinanciamiento, PagoFinanciamiento, Ordinario, Arrastre, Cobertura, Creditos)
VALUES (@CxcID, @PeriodoTmp, @EjercicioTmp, @FechaEmision, @FechaEmision, 0.0, 0.0, 0.0, 0.0, 0.0, @PorcentajeCapital, @PorcentajeFinanciamiento, @PagoFinanciamiento, 0, 0.0, 0.0, @CxcImporte)
SELECT @Renglon = ISNULL(Renglon, 0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC)
VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), 0.0, @FechaEmision, @CxcImporte, @EsNC)
END
ELSE
BEGIN
INSERT RecuperacionCredilanasPPMAVI (ID, Periodo, Ejercicio, FechaEmision, Vencimiento, Exigible, Cobros, Anterior, ExigiblePagado, Adelantado, PorcentajeCapital, PorcentajeFinanciamiento, PagoFinanciamiento, Ordinario, Arrastre, Cobertura, Creditos)
VALUES (@CxcID, @PeriodoTmp, @EjercicioTmp, @FechaEmision, @FechaEmision, 0.0, @CxcImporte, 0.0, 0.0, 0.0, @PorcentajeCapital, @PorcentajeFinanciamiento, @PagoFinanciamiento, 0, 0.0, 0.0, 0.0)
SELECT @Renglon = ISNULL(Renglon, 0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC)
VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), @CxcImporte, @FechaEmision, 0.0, @EsNC)
END
EXEC sp_ActualizaProgaramaFinanciamientoMAVI @CxcID
END  
END  
END 
END 
IF @CxcOrigenMov = 'Endoso'  
BEGIN
SELECT @CxcOrigenMovTmp = MovAplica, @CxcOrigenMovIDTmp = MovAplicaID FROM Cxc WHERE Mov = @CxcOrigenMov AND MovID = @CxcOrigenMovID AND Estatus IN('CONCLUIDO','PENDIENTE') 
WHILE @CxcOrigenMovTmp = 'Endoso'  
BEGIN
SELECT @CxcOrigenMovTmp = MovAplica, @CxcOrigenMovIDTmp = MovAplicaID FROM Cxc WHERE Mov = @CxcOrigenMovTmp AND MovID = @CxcOrigenMovIDTmp AND Estatus IN('CONCLUIDO','PENDIENTE')
END
IF @CxcOrigenMovTmp IN('Credilana','Prestamo Personal')  
BEGIN
SELECT @CxcID = ID FROM Cxc WHERE Mov = @CxcOrigenMovTmp AND MovID = @CxcOrigenMovIDTmp AND Estatus IN('CONCLUIDO','PENDIENTE') 
IF EXISTS(SELECT ID FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID)
BEGIN 
IF EXISTS(SELECT ID FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp) 
BEGIN
SELECT @Cobro = ISNULL(Cobros, 0.0), @Creditos = ISNULL(Creditos, 0.0), @PorcentajeFinanciamiento = ISNULL(PorcentajeFinanciamiento, 0.0), @Renglon = ISNULL(Renglon, 0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
IF @EsNC = 1
SELECT @Creditos = (@Creditos + ISNULL(@CxcImporte, 0.0))
ELSE
SELECT @Cobro = (@Cobro + ISNULL(@CxcImporte, 0.0))
SELECT @Recuperacion = ISNULL(@Cobro, 0.0) 
SELECT @PagoFinanciamiento = @Recuperacion * @PorcentajeFinanciamiento
IF (@Recuperacion >= 0 AND @PagoFinanciamiento >= 0)
BEGIN
IF @EsNC = 1
BEGIN
UPDATE  RecuperacionCredilanasPPMAVI SET Creditos = @Creditos, PagoFinanciamiento = @PagoFinanciamiento WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC) VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), 0.0, @FechaEmision, @CxcImporte, @EsNC)
END
ELSE
BEGIN
UPDATE  RecuperacionCredilanasPPMAVI SET Cobros = @Cobro, PagoFinanciamiento = @PagoFinanciamiento WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC) VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), @CxcImporte, @FechaEmision, 0.0, @EsNC)
END
EXEC sp_ActualizaProgaramaFinanciamientoMAVI @CxcID
END
END  
ELSE
BEGIN 
SELECT @PorcentajeFinanciamiento = ISNULL(PorcentajeFinanciamiento, 0.0), @PorcentajeCapital = ISNULL(PorcentajeCapital, 0.0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID
SELECT @PagoFinanciamiento = (ISNULL(@CxcImporte, 0.0) * @PorcentajeFinanciamiento)
IF @EsNC = 1
BEGIN
SELECT @PagoFinanciamiento = 0.0
INSERT RecuperacionCredilanasPPMAVI (ID, Periodo, Ejercicio, FechaEmision, Vencimiento, Exigible, Cobros, Anterior, ExigiblePagado, Adelantado, PorcentajeCapital, PorcentajeFinanciamiento, PagoFinanciamiento, Ordinario, Arrastre, Cobertura, Creditos)
VALUES (@CxcID, @PeriodoTmp, @EjercicioTmp, @FechaEmision, @FechaEmision, 0.0, 0.0, 0.0, 0.0, 0.0, @PorcentajeCapital, @PorcentajeFinanciamiento, @PagoFinanciamiento, 0, 0.0, 0.0, @CxcImporte)
SELECT @Renglon = ISNULL(Renglon, 0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC)
VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), 0.0, @FechaEmision, @CxcImporte, @EsNC)
END
ELSE
BEGIN
INSERT RecuperacionCredilanasPPMAVI (ID, Periodo, Ejercicio, FechaEmision, Vencimiento, Exigible, Cobros, Anterior, ExigiblePagado, Adelantado, PorcentajeCapital, PorcentajeFinanciamiento, PagoFinanciamiento, Ordinario, Arrastre, Cobertura, Creditos)
VALUES (@CxcID, @PeriodoTmp, @EjercicioTmp, @FechaEmision, @FechaEmision, 0.0, @CxcImporte, 0.0, 0.0, 0.0, @PorcentajeCapital, @PorcentajeFinanciamiento, @PagoFinanciamiento, 0, 0.0, 0.0, 0.0)
SELECT @Renglon = ISNULL(Renglon, 0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC)
VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), @CxcImporte, @FechaEmision, 0.0, @EsNC)
END
EXEC sp_ActualizaProgaramaFinanciamientoMAVI @CxcID
END  
END  
END  
IF @CxcOrigenMovTmp = 'Documento'  
BEGIN
SELECT @CxcOrigenMovTmp2 = Origen, @CxcOrigenMovIDTmp2 = OrigenID FROM Cxc WHERE Mov = @CxcOrigenMovTmp AND MovID = @CxcOrigenMovIDTmp AND Estatus IN('CONCLUIDO','PENDIENTE') 
IF @CxcOrigenMovTmp2 IN('Credilana','Prestamo Personal')
BEGIN 
SELECT @CxcID = ID FROM Cxc WHERE Mov = @CxcOrigenMovTmp2 AND MovID = @CxcOrigenMovIDTmp2 AND Estatus IN('PENDIENTE','CONCLUIDO') 
IF EXISTS(SELECT ID FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID)
BEGIN 
IF EXISTS(SELECT ID FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp) 
BEGIN
SELECT @Cobro = ISNULL(Cobros, 0.0), @Creditos = ISNULL(Creditos, 0.0), @PorcentajeFinanciamiento = ISNULL(PorcentajeFinanciamiento, 0.0), @Renglon = ISNULL(Renglon, 0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
IF @EsNC = 1
SELECT @Creditos = (@Creditos + ISNULL(@CxcImporte, 0.0))
ELSE
SELECT @Cobro = (@Cobro + ISNULL(@CxcImporte, 0.0))
SELECT @Recuperacion = ISNULL(@Cobro, 0.0) 
SELECT @PagoFinanciamiento = @Recuperacion * @PorcentajeFinanciamiento
IF (@Recuperacion >= 0 AND @PagoFinanciamiento >= 0)
BEGIN
IF @EsNC = 1
BEGIN
UPDATE  RecuperacionCredilanasPPMAVI SET Creditos = @Creditos, PagoFinanciamiento = @PagoFinanciamiento WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC) VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), 0.0, @FechaEmision, @CxcImporte, @EsNC)
END
ELSE
BEGIN
UPDATE  RecuperacionCredilanasPPMAVI SET Cobros = @Cobro, PagoFinanciamiento = @PagoFinanciamiento WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC) VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), @CxcImporte, @FechaEmision, 0.0, @EsNC)
END
EXEC sp_ActualizaProgaramaFinanciamientoMAVI @CxcID
END
END  
ELSE
BEGIN 
SELECT @PorcentajeFinanciamiento = ISNULL(PorcentajeFinanciamiento, 0.0), @PorcentajeCapital = ISNULL(PorcentajeCapital, 0.0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID
SELECT @PagoFinanciamiento = (ISNULL(@CxcImporte, 0.0) * @PorcentajeFinanciamiento)
IF @EsNC = 1
BEGIN
SELECT @PagoFinanciamiento = 0.0
INSERT RecuperacionCredilanasPPMAVI (ID, Periodo, Ejercicio, FechaEmision, Vencimiento, Exigible, Cobros, Anterior, ExigiblePagado, Adelantado, PorcentajeCapital, PorcentajeFinanciamiento, PagoFinanciamiento, Ordinario, Arrastre, Cobertura, Creditos)
VALUES (@CxcID, @PeriodoTmp, @EjercicioTmp, @FechaEmision, @FechaEmision, 0.0, 0.0, 0.0, 0.0, 0.0, @PorcentajeCapital, @PorcentajeFinanciamiento, @PagoFinanciamiento, 0, 0.0, 0.0, @CxcImporte)
SELECT @Renglon = ISNULL(Renglon, 0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END)
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC)
VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), 0.0, @FechaEmision, @CxcImporte, @EsNC)
END
ELSE
BEGIN
INSERT RecuperacionCredilanasPPMAVI (ID, Periodo, Ejercicio, FechaEmision, Vencimiento, Exigible, Cobros, Anterior, ExigiblePagado, Adelantado, PorcentajeCapital, PorcentajeFinanciamiento, PagoFinanciamiento, Ordinario, Arrastre, Cobertura, Creditos)
VALUES (@CxcID, @PeriodoTmp, @EjercicioTmp, @FechaEmision, @FechaEmision, 0.0, @CxcImporte, 0.0, 0.0, 0.0, @PorcentajeCapital, @PorcentajeFinanciamiento, @PagoFinanciamiento, 0, 0.0, 0.0, 0.0)
SELECT @Renglon = ISNULL(Renglon, 0) FROM RecuperacionCredilanasPPMAVI WHERE ID = @CxcID AND Periodo = @PeriodoTmp AND Ejercicio = @EjercicioTmp
DELETE RecuperacionCredilanasPPMAVID WHERE ID = @CxcID AND CobroID = @ID AND Renglon = @Renglon AND CxcMov = (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END) AND CxcMovID = (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END) 
INSERT RecuperacionCredilanasPPMAVID (ID, CobroID, Renglon, CxcRenglon, CxcMov, CxcMovID, CxcImporte, CobroEmision, NCImporte, EsNC)
VALUES (@CxcID, @ID, @Renglon, @CxcRenglon, (CASE @EsPuente WHEN 1 THEN @MovPuente ELSE @CxcMov END), (CASE @EsPuente WHEN 1 THEN @MovIDPuente ELSE @CxcMovID END), @CxcImporte, @FechaEmision, 0.0, @EsNC)
END
EXEC sp_ActualizaProgaramaFinanciamientoMAVI @CxcID
END  
END  
END 
END 
END   
END 
END  
SET @Cont= @Cont + 1
END  
CLOSE DoctosACobrar
DEALLOCATE DoctosACobrar
END
END
RETURN
END

