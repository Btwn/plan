SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSValidarFechaDepuracion (
@Empresa        varchar(5)
)
RETURNS datetime

AS
BEGIN
DECLARE
@Dias		int,
@Fecha		datetime
SELECT @Dias = DiasDepuracion
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @Fecha = dbo.fnFechaSinHora(DATEADD (day , -ISNULL(@Dias,1), GETDATE()))
SELECT @Fecha = dbo.fnFechaSinHora(@Fecha)
RETURN (@Fecha)
END

