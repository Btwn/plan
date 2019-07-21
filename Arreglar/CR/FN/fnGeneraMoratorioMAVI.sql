SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnGeneraMoratorioMAVI (
@ID		int
)
RETURNS char(1)
AS
BEGIN
DECLARE
@Mov						varchar(20),
@MovID						varchar(20),
@CanalVentas				int,
@GeneraMovMor				bit,
@Cliente					varchar(10),
@Concepto					varchar(50),
@GeneraClienteMor			bit,
@GeneraMoratorio			char(1),
@GeneraCanalMor				bit,
@Excepcion					char(1),
@SeccionCobranza			varchar(50),
@Vencimiento				datetime,
@FechaActual				datetime,
@MovPadre					varchar(20),
@CategoriaCanal				varchar(50),
@CalculoMoratorioMAVI		bit,
@MovPadre1					varchar(20),
@MovIDPadre					varchar(20),
@InteresMoratoriosMAVI		money
SELECT @GeneraMoratorio = '0'
SELECT @FechaActual = GetDate()
SELECT
@Cliente = Cliente,
@Mov   = Mov,
@MovID = MovID,
@CanalVentas = ClienteEnviarA,
@Concepto = Concepto,
@Vencimiento = Vencimiento ,
@InteresMoratoriosMAVI = InteresesMoratoriosMAVI
FROM CXC
WHERE ID = @ID
SELECT @CalculoMoratorioMAVI = ISNULL(CalculoMoratorioMAVI,0)
FROM Cte
WHERE Cliente = @Cliente
SELECT @MovPadre = ISNULL(Origen,@Mov)
FROM Cxc
WHERE ID = @ID
SELECT
@GeneraCanalMor = ISNULL(GeneraCargoxMoratorio,0),
@CategoriaCanal = Categoria
FROM VentasCanalMAVI
WHERE ID = @CanalVentas
IF @Mov = 'ENDOSO'
SELECT  @MovPadre = 'ENDOSO'  
IF @Mov in ('Contra Recibo','Contra Recibo Inst')
BEGIN
SELECT @MovPadre1 = Origen, @MovIDPadre = OrigenID
FROM CXC
WHERE ID = @ID
SELECT @MovPadre = Origen
FROM CXC
WHERE Mov = @MovPadre1 AND MovID = @MovIDPadre
END
IF @FechaActual <= @Vencimiento  
BEGIN
IF @InteresMoratoriosMAVI > 0
SELECT @GeneraMoratorio = '1'
ELSE
SELECT @GeneraMoratorio = '0'
END
ELSE
BEGIN
SELECT @GeneraMovMor = ISNULL(CalculoMoratorioMAVI,0)
FROM MovTipo
WHERE Modulo ='CXC' AND Mov = @MovPadre
IF @GeneraMovMor = 1
BEGIN
SELECT @GeneraMoratorio = '1'
IF EXISTS(SELECT * FROM CalculoMoratoriosExMAVI WHERE Mov = @Mov AND Concepto = @Concepto )
SELECT @GeneraMoratorio = '0'
ELSE
BEGIN
SELECT @GeneraMoratorio = '1' 
IF @GeneraCanalMor = 0
BEGIN
SELECT @SeccionCobranza = SeccionCobranzaMAVI
FROM CteEnviarA
WHERE Cliente = @Cliente AND ID = @CanalVentas
IF @SeccionCobranza = 'CREDITO MENUDEO' AND @CategoriaCanal = 'INSTITUCIONES' 
SELECT @GeneraMoratorio = '1'
ELSE
SELECT @GeneraMoratorio = '0'
END
ELSE
SELECT @GeneraMoratorio = '1'
END
END
END
RETURN (@GeneraMoratorio)
END

