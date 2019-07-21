SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNominaCalculaDiasMes
(
@FechaD         datetime,
@FechaA         datetime,
@CalculaDiasMes int  output
)

AS
BEGIN
SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET DATEFORMAT dmy
DECLARE @TipoPeriodo    varchar(20),    @MesF int,
@Diaa INT, @Mesa int, @Anoa int, @Diad INT, @Mesd int, @Anod int, @DiasPeriodoMes INT,
@Fhi  dateTIME, @FechaI datetime, @Fhf DATETIME, @FechaF datetime, @Diaensemana int, @FhInsert datetime
DECLARE @loop_dia INT, @item_dia INT, @cuenta int, @semana int
DECLARE @item_Agenda  TABLE (Id INT IDENTITY(1,1) NOT NULL, NbFecha varchar(1), Fecha Datetime)
DELETE @item_Agenda
SET @FechaD = CONVERT(datetime, @FechaD,103)
SET @FechaA = CONVERT(datetime, @FechaA,103)
SELECT @Diad = Datepart(weekday, @FechaD)
SELECT @Fhi = DATEADD(DAY, -7, @FechaD)
Set @Mesd = Datepart(month, @FechaD)
SELECT @Fhi = CONVERT(DATETIME,  '01/'+CONVERT(VARCHAR(2),Datepart(month, @FechaA)) + '/' +CONVERT(VARCHAR(4),Datepart(YEAR, @FechaA)),103)
SET @FhInsert  = @Fhi
SELECT @FechaI = @FechaA
SET @cuenta    = 0
DECLARE @loop_counter INT, @item_semana INT
SET @item_semana = 1
SET @loop_counter=7
SET @Fhf = @FechaA
WHILE @loop_counter >= @item_semana
BEGIN
set @cuenta=0
SET @FechaI=DATEADD(week,-1,@FechaI)
Set @semana=Datepart(weekday,@FechaI)
SET @FhInsert =@FechaI
SET @item_dia = 7
SET @loop_dia=1
WHILE @loop_dia <= @item_dia
BEGIN
INSERT INTO @item_Agenda values('D',@FhInsert)
set @FhInsert = DATEADD(day,1,@FhInsert)
IF @FhInsert=@Fhi
Begin
Select @cuenta=100
End
set  @loop_dia = @loop_dia + 1
END
IF  isnull(@cuenta,0) > 0
Begin
SET  @loop_counter = 0
End
SET  @loop_counter = @loop_counter - 1
END
Select top 1 @FechaI =fecha from  @item_Agenda order by fecha
Delete  @item_Agenda
SELECT @MesA = Datepart(month,@FechaA)
SET @item_semana = 7
SET @loop_counter=1
SET @Fhf = @FechaA
WHILE @loop_counter <= @item_semana
BEGIN
set @FechaF = DATEADD(week,1,@Fhf)
set @MesF  = DATEPART(month,@FechaF)
IF @MesA=@MesF
Begin
SET @Fhf = @FechaF
End  Else
SET @loop_counter=100
SET  @loop_counter = @loop_counter + 1
END
SELECT @CalculaDiasMes = DATEDIFF(day,@FechaI,@Fhf)
RETURN
END

