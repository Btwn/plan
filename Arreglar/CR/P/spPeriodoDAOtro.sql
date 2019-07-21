SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPeriodoDAOtro
@PeriodoTipo	varchar(50),
@Fecha		datetime,
@FechaD		datetime	OUTPUT,
@FechaA		datetime	OUTPUT,
@Empresa	varchar(5)	= NULL

AS BEGIN
DECLARE
@DiasPeriodo	float
IF (SELECT Pais FROM Empresa WHERE Empresa = @Empresa) = 'Venezuela'
BEGIN
SELECT @DiasPeriodo = DiasPeriodo FROM PeriodoTipo WHERE PeriodoTipo = @PeriodoTipo
SELECT @FechaD = @Fecha
SELECT @FechaA = DATEADD(DAY, @DiasPeriodo - 1, @Fecha)
END
EXEC xpPeriodoDAOtro @PeriodoTipo, @Fecha, @FechaD OUTPUT, @FechaA OUTPUT, @Empresa
RETURN
END

