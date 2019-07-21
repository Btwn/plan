SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNetListaHorarios
AS BEGIN
/*Funcion Ciclo de Horas Amenidades*/
DECLARE @contador INT,
@NumHoras INT,
@datetime1 datetime2,
@datetime2 datetime2,
@datetime3 datetime2
SET @contador = 1
SET @NumHoras = (SELECT DISTINCT DATEDIFF( HH , EspaciosHoraD , EspaciosHoraA ) FROM Empresacfg)
SET @NumHoras = @NumHoras + 1
SET @datetime1 = (SELECT DISTINCT EspaciosHoraD FROM Empresacfg)
SET @datetime2 = (SELECT DISTINCT EspaciosHoraD FROM Empresacfg)
SET @datetime3 = (SELECT DISTINCT EspaciosHoraA FROM Empresacfg)
DECLARE @TablaListaHoras TABLE (Horas TIME)
WHILE (@contador < @NumHoras)
BEGIN
IF @datetime2 = @datetime1
BEGIN
SET @datetime2 = @datetime1
END
ELSE IF @datetime2 > @datetime1 AND @datetime2 < @datetime3
BEGIN
SET @datetime2 = @datetime2
END
INSERT INTO @TablaListaHoras
SELECT CONVERT(time,@datetime2) as HoraEvento
SET @contador = @contador + 1
SET @datetime2 = DATEADD(mi,60,@datetime2)
END
SELECT CONVERT(VARCHAR(8),Horas) as HoraEvento FROM @TablaListaHoras
END

