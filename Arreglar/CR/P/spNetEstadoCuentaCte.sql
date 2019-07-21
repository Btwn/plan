SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spNetEstadoCuentaCte
@Empresa	varchar(5)	= NULL,
@Cliente	varchar(10)	= NULL,
@FechaD	datetime	= NULL,
@FechaA	datetime	= NULL,
@Moneda	varchar(10)	= NULL,
@SinMovAplicacion varchar(2) = NULL
AS BEGIN
DECLARE
@SinMov  bit,
@Estacion int
IF ISNULL(@SinMovAplicacion,'') = 'Si'
SELECT @SinMov = 1
ELSE
SELECT @SinMov = 0
SELECT @FechaD = dbo.fnFechaSinHora(@FechaD)
SELECT @FechaA = dbo.fnFechaSinHora(@FechaA)
SELECT @Estacion = @@SPID
EXEC spEspEstadoCuenta @Estacion, @Empresa, @Cliente, @Cliente, @FechaD, @FechaA, @Moneda, @SinMov
SELECT
espCxcEstadoCuenta.ID,
espCxcEstadoCuenta.Cliente,
espCxcEstadoCuenta.Moneda,
espCxcEstadoCuenta.IDMov,
espCxcEstadoCuenta.Mov,
espCxcEstadoCuenta.MovID,
espCxcEstadoCuenta.FechaEmision,
espCxcEstadoCuenta.Cargo,
espCxcEstadoCuenta.Abono,
espCxcEstadoCuenta.SaldoInicial,
espCxcEstadoCuenta.SaldoFinal,
espCxcEstadoCuenta.AlCorriente,
espCxcEstadoCuenta.Rango1,
espCxcEstadoCuenta.Rango2,
espCxcEstadoCuenta.Rango3,
espCxcEstadoCuenta.Rango4,
espCxcEstadoCuenta.RangoMayor,
espCxcEstadoCuenta.CargoA,
espCxcEstadoCuenta.AbonosA,
espCxcEstadoCuenta.SaldoMovil,
Cte.Nombre,                                                                                                                                                                                                           CxcAplica.Referencia FROM
espCxcEstadoCuenta
JOIN Cte ON espCxcEstadoCuenta.Cliente=Cte.Cliente
LEFT OUTER JOIN Cxc ON espCxcEstadoCuenta.IDMov=Cxc.ID
LEFT OUTER JOIN CxcAplica ON espCxcEstadoCuenta.IDAplica=CxcAplica.ID
LEFT OUTER JOIN CteEnviarA ON espCxcEstadoCuenta.Cliente=CteEnviarA.Cliente AND espCxcEstadoCuenta.EnviarA=CteEnviarA.ID
WHERE espCxcEstadoCuenta.Estacion = @Estacion
AND Cte.Condicion NOT IN ('Contado')
ORDER BY espCxcEstadoCuenta.Cliente, espCxcEstadoCuenta.Moneda, espCxcEstadoCuenta.FechaEmision, espCxcEstadoCuenta.IDMov
RETURN
END

