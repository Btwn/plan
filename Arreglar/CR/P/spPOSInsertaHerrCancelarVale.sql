SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertaHerrCancelarVale
@Estacion   int,
@Tipo       varchar(50),
@FechaA     datetime

AS
BEGIN
DELETE POSHerrCancelacionVale WHERE Estacion = @Estacion
INSERT POSHerrCancelacionVale(
Estacion, Cliente, Monedero,FechaVigencia)
SELECT
@Estacion,ISNULL(Cliente,''), Serie, FechaTermino
FROM ValeSerie
WHERE Tipo = ISNULL(NULLIF(@Tipo,''),Tipo)
AND Estatus NOT IN('CANCELADO')
AND dbo.fnVerSaldoVale(Serie) >0.0
END

