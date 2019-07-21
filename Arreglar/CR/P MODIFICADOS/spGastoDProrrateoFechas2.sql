SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoDProrrateoFechas2
@Empresa		char(5),
@Sucursal		int,
@ID			int,
@Renglon		float,
@RenglonSub		int,
@Concepto		varchar(50),
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
@RedondeoMonetarios int,
@ImporteTotal	money
DECLARE
@GastoDProrrateo TABLE (SucursalProrrateo int NULL, ContUso varchar(20) NULL, ContUso2 varchar(20) NULL, ContUso3 varchar(20) NULL, Proyecto varchar(50) NULL, UEN int NULL, VIN varchar(20) NULL, Actividad varchar(100) NULL, AFArticulo varchar(20) NULL, AFSerie varchar(20) NULL, Fecha datetime NULL, Porcentaje float NULL, ImporteDia money NULL, Saldo money NULL, Importe money NULL)
SELECT @RedondeoMonetarios = dbo.fnRedondeoMonetarios()
SELECT @Meses = DATEDIFF(month, @FechaD, @FechaA) + 1,
@Dias  = DATEDIFF(day,   @FechaD, @FechaA) + 1
INSERT @GastoDProrrateo (
SucursalProrrateo, ContUso, ContUso2, ContUso3, Proyecto, UEN, VIN, Actividad, AFArticulo, AFSerie, Fecha, Porcentaje, Saldo,   ImporteDia,    Importe)
SELECT SucursalProrrateo, ContUso, ContUso2, ContUso3, Proyecto, UEN, VIN, Actividad, AFArticulo, AFSerie, Fecha, Porcentaje, Importe, Importe/@Dias, ROUND(Importe/NULLIF(@Meses, 0), @RedondeoMonetarios)
FROM GastoDProrrateo WITH(NOLOCK)
WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub AND Concepto = @Concepto
SELECT @ImporteTotal = SUM(Saldo) FROM @GastoDProrrateo
DELETE GastoDProrrateo
WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub AND Concepto = @Concepto
SELECT @Fecha = @FechaD, @a = 1
WHILE @a <= @Meses
BEGIN
IF UPPER(@MetodoProrrateo) = 'PROPORCIONAL POR DIA'
BEGIN
SELECT @Dia = DATEPART(day, @Fecha), @Mes = DATEPART(month, @Fecha), @Ano = DATEPART(year, @Fecha)
EXEC spDiasMes @Mes, @Ano, @DiasMes OUTPUT
IF @a = 1
UPDATE @GastoDProrrateo SET Importe = (@DiasMes - @Dia + 1) * ImporteDia
ELSE
UPDATE @GastoDProrrateo SET Importe = @DiasMes * ImporteDia
END
IF @a = @Meses UPDATE @GastoDProrrateo SET Importe = Saldo
INSERT GastoDProrrateo (
SucursalProrrateo, ContUso, ContUso2, ContUso3, Proyecto, UEN, VIN, Actividad, AFArticulo, AFSerie, Sucursal,  ID,  Renglon,  RenglonSub,  Concepto,  Fecha,  Importe, Porcentaje)
SELECT SucursalProrrateo, ContUso, ContUso2, ContUso3, Proyecto, UEN, VIN, Actividad, AFArticulo, AFSerie, @Sucursal, @ID, @Renglon, @RenglonSub, @Concepto, @Fecha, Importe, (Importe/CONVERT(float, @ImporteTotal))*100.0
FROM @GastoDProrrateo
UPDATE @GastoDProrrateo
SET Saldo = Saldo - Importe
SELECT @a = @a + 1
SELECT @Fecha = DATEADD(month, 1, @Fecha)
EXEC spPrimerDiaMes @Fecha OUTPUT
END
RETURN
END

