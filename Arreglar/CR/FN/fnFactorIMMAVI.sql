SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnFactorIMMAVI (@ID int)
RETURNS float
AS
BEGIN
DECLARE @FactorIM float
,@Origen char(20)
,@OrigenID char(20)
,@Vencimiento datetime
,@FechaActual datetime
,@FechaDocOrig datetime
,@FechaUltIntereses datetime
,@FechaUltInteresesPeer datetime
,@MontoVencido float
,@RestaDiasNatural float
,@IDCXCTemp int
,@Mov char(20)
,@MovID char(20)
,@FechaVencTemp datetime
,@FechaOriginalTemp datetime
,@PagosRealizados float
,@ProporcionPagos float
,@FechaLimiteProp datetime
,@DiasConProporcionIM float
,@CxcAnterior int
,@ImporteDocumento float
,@DiasMesOrigen int
,@DiasMesDestino int
,@FechaDiasTotal datetime
,@MesVencimiento int
,@MovTipo char(20)
,@Estatus varchar(15)
,@d_dias datetime
,@t_vmes int
,@t_vaño int
,@t_vdias int
,@t_ldias int
,@d_ldias datetime
SELECT   @FechaActual = GETDATE()
,@RestaDiasNatural = 0.00
,@MontoVencido = 0.00
,@PagosRealizados = 0
,@ImporteDocumento = 1
,@PagosRealizados = 0.00
,@ProporcionPagos = 0.00
SELECT   @Mov = C.Mov
,@MovID = C.MovID
,@Origen = C.Origen
,@OrigenID = C.OrigenID
,@Vencimiento = ISNULL(C.Vencimiento,C.FechaEmision)
,@MovTipo = mt.Clave
,@ImporteDocumento = ISNULL(C.Importe,1) + ISNULL(C.Impuestos,
0)
- ISNULL(C.Retencion,0)
,    
@FechaUltIntereses = ISNULL(C.FechaOriginal,C.Vencimiento)
,@FechaDocOrig = C.FechaEmision
,@Estatus = Estatus
FROM     CXC C WITH (NOLOCK)
JOIN MovTipo mt On mt.Mov=C.Mov
WHERE    ID=@ID
AND mt.Modulo='CXC'
SET @d_dias = dbo.fnFechaSinHora ( @Vencimiento )
SET @t_vdias = DATEDIFF(DD,@d_dias,
DATEADD(MM,1,@d_dias - DAY(@d_dias) + 1))
SET @t_vmes = MONTH(@Vencimiento)
SET @t_vaño = YEAR(@Vencimiento)
IF @Estatus='PENDIENTE'
BEGIN
SELECT   @RestaDiasNatural = DATEDIFF(dd,@FechaUltIntereses,
@FechaActual)
SELECT   @PagosRealizados = ISNULL(SUM(CxcD.Importe),0)
FROM     Cxcd WITH (NOLOCK)
JOIN CXC WITH (NOLOCK) On cxcd.id=cxc.id
WHERE    CXC.Estatus='Concluido'
AND Cxcd.Aplica=@Mov
AND Cxcd.AplicaID=@MovID
IF @FechaActual>=@FechaUltIntereses
SELECT   @MontoVencido = @ImporteDocumento
- @PagosRealizados
SELECT   @ProporcionPagos = ((@MontoVencido)
/ @ImporteDocumento) * 100
SELECT   @MesVencimiento = @t_vmes + 1
IF @MesVencimiento=13
SELECT   @MesVencimiento = 1
SET @d_ldias = DATEADD(m,1,dbo.fnFechaSinHora (@Vencimiento))
SET @t_ldias = DATEDIFF(DD,@d_ldias,
DATEADD(MM,1,
@d_ldias - DAY(@d_ldias) + 1))
SELECT   @DiasMesOrigen = @t_vdias
SELECT   @DiasMesDestino = @t_ldias
/*dbo.fnDiasMes(@MesVencimiento, YEAR(@Vencimiento))  */
SELECT   @FechaDiasTotal = @Vencimiento + @DiasMesOrigen
IF DAY(@Vencimiento)<>DAY(@FechaDiasTotal)
SELECT   @FechaDiasTotal = (@Vencimiento) + (@DiasMesDestino
+ (@DiasMesDestino
- @DiasMesOrigen))
SELECT   @FechaLimiteProp = @FechaDiasTotal
IF @FechaUltIntereses>@FechaLimiteProp
SELECT   @DiasConProporcionIM = 0
IF @FechaUltIntereses<=@FechaLimiteProp
SELECT   @DiasConProporcionIM = DATEDIFF(dd,
@FechaUltIntereses,
@FechaLimiteProp)
IF @RestaDiasNatural<=@DiasConProporcionIM
SELECT   @FactorIM = (@RestaDiasNatural * @ProporcionPagos
/ 100)
IF @RestaDiasNatural>@DiasConProporcionIM
SELECT   @FactorIM = ((@RestaDiasNatural
- @DiasConProporcionIM)
+ (@DiasConProporcionIM
* @ProporcionPagos) / 100)
IF @FactorIM IS NULL
SET @FactorIM = 0
END
RETURN (@FactorIM)
END

