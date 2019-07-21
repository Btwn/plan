SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spTCModoOperacion
@Empresa		varchar(5),
@Sucursal		int

AS
BEGIN
IF dbo.fnTCProcesadorTransCfg(@Empresa, @Sucursal) = 'BANORTE'
SELECT 'Prueba Aprobada'
UNION
SELECT 'Prueba Declinada'
UNION
SELECT 'Prueba Aleatoria'
UNION
SELECT 'Produccion'
END

