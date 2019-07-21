SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spIncidenciaD
@ID			int,
@Numero			int,
@NominaConcepto		varchar(10),
@Empresa		char(5),
@Sucursal		int,
@Usuario		char(10),
@Moneda			char(10),
@TipoCambio		float,
@Personal		char(10),
@FechaEmision		datetime,
@FechaAplicacion	datetime,
@Referencia		varchar(50),
@Cantidad		float,
@Importe		money,
@Acreedor		varchar(10),
@Vencimiento		datetime

AS BEGIN
DECLARE
@RedondeoMonetarios int,
@Tope   float
SELECT @RedondeoMonetarios = RedondeoMonetarios FROM Version
SELECT  @Tope = ImporteTopeDef  FROM NominaConcepto  WHERE  NominaConcepto = @NominaConcepto
IF @Tope  IS NOT  NULL
BEGIN
IF @Importe < 0  AND @Tope < 0
SELECT @Importe = dbo.fnMayor(@Tope,@Importe)
ELSE
SELECT @Importe = dbo.fnMenor(@Tope,@Importe)
END
INSERT IncidenciaD (
Numero,  ID,  Sucursal,  FechaAplicacion,  NominaConcepto,  Cantidad,            CantidadPendiente,   Importe,                              Saldo)
VALUES (@Numero, @ID, @Sucursal, @FechaAplicacion, @NominaConcepto, ROUND(@Cantidad, 4), ROUND(@Cantidad, 4), ROUND(@Importe, @RedondeoMonetarios), ROUND(@Importe, @RedondeoMonetarios))
RETURN
END

