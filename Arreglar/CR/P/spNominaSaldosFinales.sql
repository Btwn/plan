SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaSaldosFinales
@Empresa        char(5),
@Personal       char(10),
@Movimiento       varchar(50),
@Concepto       varchar(50)

AS BEGIN
SELECT @Movimiento = NULLIF(RTRIM(@Movimiento), '')
SELECT @Concepto = NULLIF(RTRIM(@Concepto), '')
SELECT SUM(Saldo)
FROM Nomina n
JOIN NominaD d ON n.id = d.id
WHERE n.Empresa  = @Empresa
AND d.Personal = @Personal
AND n.Estatus  in('Vigente','PROCESAR')
AND d.Activo   = 1
AND n.Mov = ISNULL(@Movimiento, n.Mov)
AND n.Concepto = ISNULL(@Concepto, n.Concepto)
END

