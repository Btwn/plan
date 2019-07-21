SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSFechaCierre (
@Empresa        varchar(5),
@Sucursal       int,
@Fecha          varchar(25),
@Caja           varchar(10)
)
RETURNS datetime

AS
BEGIN
DECLARE
@Resultado		datetime,
@FechaActual    datetime
SELECT @FechaActual = GETDATE()
SELECT @Resultado = Fecha
FROM POSEstatusCajasCierre
WHERE Sucursal = @Sucursal AND Caja = @Caja
IF @Resultado IS NULL
SELECT @Resultado = dbo.fnFechaSinHora(@FechaActual)
SELECT @Resultado = dbo.fnFechaSinHora(@Resultado)
RETURN (@Resultado)
END

