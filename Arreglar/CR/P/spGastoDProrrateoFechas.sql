SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoDProrrateoFechas
@Empresa		char(5),
@Sucursal		int,
@ID			int,
@Renglon		float,
@RenglonSub		int,
@Concepto		varchar(50),
@ImporteTotal	money,
@FechaD		datetime,
@FechaA		datetime,
@MetodoProrrateo	varchar(20)

AS BEGIN
DECLARE
@Mes		int,
@Ano		int,
@Dia		int,
@Dias		int,
@DiasMes		int,
@a			int,
@Saldo		money,
@Fecha		datetime,
@Porcentaje		float,
@Importe		float,
@ImporteDia		float,
@Meses		float,
@RedondeoMonetarios int
SELECT @RedondeoMonetarios = dbo.fnRedondeoMonetarios()
SELECT @Meses = DATEDIFF(month, @FechaD, @FechaA) + 1,
@Dias  = DATEDIFF(day,   @FechaD, @FechaA) + 1
DELETE GastoDProrrateo
WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub AND Concepto = @Concepto
SELECT @ImporteDia = @ImporteTotal/@Dias, @Saldo = @ImporteTotal, @Fecha = @FechaD, @a = 1
SELECT @Importe = ROUND(@ImporteTotal/NULLIF(@Meses, 0), @RedondeoMonetarios)
WHILE @a <= @Meses
BEGIN
IF UPPER(@MetodoProrrateo) = 'PROPORCIONAL POR DIA'
BEGIN
SELECT @Dia = DATEPART(day, @Fecha), @Mes = DATEPART(month, @Fecha), @Ano = DATEPART(year, @Fecha)
EXEC spDiasMes @Mes, @Ano, @DiasMes OUTPUT
IF @a = 1
SELECT @Importe = (@DiasMes - @Dia + 1) * @ImporteDia
ELSE
SELECT @Importe = @DiasMes * @ImporteDia
END
IF @a = @Meses SELECT @Importe = @Saldo
INSERT GastoDProrrateo
(Sucursal, ID,  Renglon,  RenglonSub,  Concepto,  Fecha,  Importe,  Porcentaje)
SELECT @Sucursal, @ID, @Renglon, @RenglonSub, @Concepto, @Fecha, @Importe, (@Importe/CONVERT(float, @ImporteTotal))*100.0
SELECT @Saldo = @Saldo - @Importe, @a = @a + 1
SELECT @Fecha = DATEADD(month, 1, @Fecha)
EXEC spPrimerDiaMes @Fecha OUTPUT
END
RETURN
END

