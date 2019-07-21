SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgEmpresaCostoPisoAC ON EmpresaCostoPiso

FOR INSERT, UPDATE
AS BEGIN
DECLARE
@Empresa		varchar(5),
@Fecha		datetime,
@FechaA		datetime,
@FechaN		datetime,
@Plazo1Tasa		float,
@Plazo2Tasa		float,
@Plazo3Tasa		float
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Empresa = Empresa, @FechaN = Fecha FROM Inserted
SELECT @FechaA = MAX(Fecha) FROM EmpresaCostoPiso WHERE Empresa = @Empresa AND Fecha < @FechaN
IF @FechaA IS NOT NULL
BEGIN
SELECT @Plazo1Tasa = Plazo1Tasa, @Plazo2Tasa = Plazo2Tasa, @Plazo3Tasa = Plazo3Tasa FROM EmpresaCostoPiso WHERE Empresa = @Empresa AND Fecha = @FechaA
SELECT @Fecha = DATEADD(day, 1, @FechaA)
WHILE @Fecha < @FechaN
BEGIN
INSERT EmpresaCostoPiso (Empresa,  Fecha,  Plazo1Tasa,  Plazo2Tasa,  Plazo3Tasa)
VALUES (@Empresa, @Fecha, @Plazo1Tasa, @Plazo2Tasa, @Plazo3Tasa)
SELECT @Fecha = DATEADD(day, 1, @Fecha)
END
END
END

