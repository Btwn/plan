SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnPCPValidarReglas
(
@Proyecto				varchar(50),
@FechaEmision			datetime,
@ClavePresupuestal		varchar(50)
)
RETURNS bit

AS BEGIN
DECLARE
@Resultado					bit,
@Salir						bit,
@ReglaID					int
SELECT @Resultado = 1, @Salir = 0
DECLARE crRegla CURSOR FOR
SELECT RID
FROM ProyClavePresupuestalRegla
WHERE Proyecto = @Proyecto
OPEN crRegla
FETCH NEXT FROM crRegla INTO @ReglaID
WHILE @@FETCH_STATUS = 0
BEGIN
IF dbo.fnPCPValidarRegla(@ReglaID,@FechaEmision,@ClavePresupuestal) = 0 SELECT @Resultado = 0, @Salir = 1
FETCH NEXT FROM crRegla INTO @ReglaID
END
CLOSE crRegla
DEALLOCATE crRegla
RETURN (@Resultado)
END

