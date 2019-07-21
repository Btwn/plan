SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSSugerirMonedero
@Estacion   int,
@Empresa    varchar(5),
@Sucursal   int

AS
BEGIN
DECLARE
@Tipo                 varchar(20),
@Consecutivo          varchar(20)
SELECT @Tipo = ConsecutivoMonedero
FROM POSCfg
WHERE Empresa = @Empresa
EXEC spConsecutivo @Tipo, @Sucursal, @Consecutivo OUTPUT
SELECT @Consecutivo
END

