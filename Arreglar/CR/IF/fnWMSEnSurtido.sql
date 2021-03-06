SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWMSEnSurtido (@Tarima varchar(20), @Articulo varchar(20))
RETURNS TABLE
AS
RETURN (
SELECT * FROM dbo.fnWMSOrdenSurtidoPendiente(@Tarima, @Articulo)
UNION ALL
SELECT * FROM dbo.fnWMSSurtidoTransitoProcesar(@Tarima, @Articulo)
UNION ALL
SELECT * FROM dbo.fnWMSSurtidoConcluido(@Tarima, @Articulo)
)

