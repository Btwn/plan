SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spPNetEstadoCtaCte
@Cliente  varchar(10)
AS BEGIN
DECLARE
@Empresa  varchar(5),
@Fecha    datetime,
@Estacion int
SELECT TOP 1 @Empresa = Empresa FROM CXC WHERE Cliente = @Cliente
SELECT @Fecha = dbo.fnFechaSinHora(GETDATE())
SELECT @Estacion = @@SPID
EXEC spGenerarEstadoCuenta @Estacion, @Empresa, 'CXC', @Fecha, @Cliente, -1, NULL
SELECT EstadoCuenta.ID,
EstadoCuenta.Moneda,
'$' + CONVERT(varchar,CAST(EstadoCuenta.Efectivo as money),1) Efectivo,
'$' + CONVERT(varchar,CAST(EstadoCuenta.Consumos as money),1) Consumos,
'$' + CONVERT(varchar,CAST(EstadoCuenta.Vales as money),1) Vales,
'$' + CONVERT(varchar,CAST(EstadoCuenta.Redondeo as money),1) Redondeo,
Auxiliar.ID,
CONVERT(VARCHAR(11), Auxiliar.Fecha,106) Fecha,
LTRIM(RTRIM(Auxiliar.Mov)) + ' ' + LTRIM(RTRIM(Auxiliar.MovID)) Movimiento,
'$' + CONVERT(varchar,CAST(Auxiliar.Cargo as money),1) Cargo,
'$' + CONVERT(varchar,CAST(Auxiliar.Abono as money),1) Abono,
'$' + CONVERT(varchar,CAST(ISNULL(Auxiliar.Cargo,0) - ISNULL(Auxiliar.Abono,0) as money),1) Saldo,
LTRIM(RTRIM(Auxiliar.Aplica)) + ' ' + LTRIM(RTRIM(Auxiliar.AplicaID)) Aplica,
Cte.Cliente,
Cte.Nombre
FROM EstadoCuenta
LEFT OUTER JOIN Auxiliar ON EstadoCuenta.AuxiliarID=Auxiliar.ID
JOIN Cte ON EstadoCuenta.Cuenta=Cte.Cliente
WHERE EstadoCuenta.Estacion=@Estacion AND EstadoCuenta.Modulo='CXC'
ORDER BY EstadoCuenta.Moneda, Cte.Cliente, Auxiliar.Fecha, Auxiliar.Aplica, Auxiliar.AplicaID, EstadoCuenta.ID
RETURN
END

