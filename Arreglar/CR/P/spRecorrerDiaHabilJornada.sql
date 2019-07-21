SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRecorrerDiaHabilJornada
@Empresa 	char(5),
@Fecha	datetime	OUTPUT,
@Jornada varchar(20) = NULL

AS BEGIN
DECLARE
@DiasHabiles char(10)
SELECT @DiasHabiles = DiasHabiles FROM EmpresaGral WHERE Empresa = @Empresa
SELECT @Fecha = DATEADD(day, -1, @Fecha)
EXEC spCalcularDiasHabiles @Fecha, 1, @DiasHabiles, 0, @Fecha OUTPUT, NULL, @Jornada
RETURN
END

