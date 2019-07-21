SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRevisarVencimiento
@Modulo		    char(5),
@ID				int,
@Vencimiento	datetime	OUTPUT

AS BEGIN
DECLARE
@FechaEmision	datetime,
@Condicion		varchar(50),
@Periodo		varchar(15),
@DiaVencimiento	int,
@Dia			int,
@Mes			int,
@Anio			int,
@DocAuto		bit
IF @Modulo = 'CXC'
SELECT @FechaEmision = FechaEmision, @Condicion = Condicion FROM CXC WHERE ID = @ID
IF @Modulo = 'CXP'
SELECT @FechaEmision = FechaEmision, @Condicion = Condicion FROM CXP WHERE ID = @ID
SELECT @Dia = DAY(@FechaEmision)
SELECT @DocAuto = ISNULL(DA, 0), @Periodo = DAPeriodo, @DiaVencimiento = ISNULL(DADiaEspecifico, '') FROM Condicion WHERE Condicion = @Condicion
IF @DiaVencimiento = ''
SELECT @DiaVencimiento = @Dia
IF @DocAuto = 1
IF @Periodo IN ('Bimestral') BEGIN
IF @Periodo = 'Bimestral' BEGIN
SELECT @Vencimiento = DATEADD(month, 2, @FechaEmision)
SELECT @Mes = MONTH(@Vencimiento), @Anio = YEAR(@Vencimiento)
EXEC spIntToDateTime @DiaVencimiento, @Mes, @Anio, @Vencimiento OUTPUT
END
END
RETURN
END

