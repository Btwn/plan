SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRegHistTriggerPK
@Tabla			varchar(100),
@PK			varchar(1000)	OUTPUT

AS BEGIN
DECLARE
@Valor	varchar(255)
SELECT @PK = ''
DECLARE crTablaPK CURSOR LOCAL FOR
SELECT n.Valor
FROM dbo.fnTablaPK(@Tabla) e
JOIN #Nueva n ON n.Campo = e.Campo
ORDER BY e.Orden
OPEN crTablaPK
FETCH NEXT FROM crTablaPK INTO @Valor
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @PK <> '' SELECT @PK = @PK + '|'
SELECT @PK = @PK + ISNULL(@Valor, '')
END
FETCH NEXT FROM crTablaPK INTO @Valor
END  
CLOSE crTablaPK
DEALLOCATE crTablaPK
SELECT @PK = NULLIF(RTRIM(@PK), '')
RETURN
END

