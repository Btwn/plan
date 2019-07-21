SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaDividirCantidad
@Empresa			char(5),
@ID				int,
@FechaEmision	datetime,
@MovTipo			char(20)

AS BEGIN
DECLARE
@DiasHabiles		char(20),
@Renglon			float,
@Sucursal			int,
@SucursalOrigen		int,
@Personal			char(10),
@Cantidad			money,
@FechaD				datetime,
@Referencia			varchar(50),
@PeriodoTipo		varchar(50),
@Jornada			varchar(20),
@Inicio				datetime,
@Fin				datetime,
@Dias				int,
@DiasNetos			int,
@DiasNoHabiles		int,
@DividirCatorcenas	bit, 
@FechaDHabil		datetime,
@DiasNoHabilFechaD	int
SELECT @DiasHabiles = UPPER(DiasHabiles)
FROM EmpresaGral
WHERE Empresa = @Empresa
SELECT @DividirCatorcenas = DividirCatorcenas
FROM MovTipo
WHERE Modulo = 'NOM' AND Clave = @MovTipo
CREATE TABLE #NominaD (Renglon float NULL, Personal char(10) COLLATE Database_Default NULL, Cantidad float NULL, FechaD datetime NULL, Referencia varchar(50) COLLATE Database_Default NULL, Sucursal int NULL, SucursalOrigen int NULL)
SELECT @Renglon = 0.0
DECLARE crNominaD CURSOR
FOR SELECT d.Sucursal, d.SucursalOrigen, d.Personal, d.Cantidad, ISNULL(d.FechaD, @FechaEmision), d.Referencia, p.PeriodoTipo, p.Jornada
FROM NominaD d, Personal p
WHERE ID = @ID
AND d.Personal = p.Personal
OPEN crNominaD
FETCH NEXT FROM crNominaD INTO @Sucursal, @SucursalOrigen, @Personal, @Cantidad, @FechaD, @Referencia, @PeriodoTipo, @Jornada
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
WHILE @Cantidad > 0
BEGIN
EXEC spExtraerFecha @FechaD OUTPUT
IF @DividirCatorcenas = 1 AND (SELECT PeriodoTipo FROM Personal WHERE Personal = @Personal) LIKE 'CATORCENAL%'
EXEC spPeriodoDACatorcena @FechaD, @Fin OUTPUT
ELSE
EXEC spPeriodoDA @PeriodoTipo, @FechaD, @Inicio OUTPUT, @Fin OUTPUT, @Empresa = @Empresa
SELECT @Dias = DATEDIFF(day, @FechaD, @Fin)
IF @PeriodoTipo LIKE 'QUINCENAL%' OR @PeriodoTipo LIKE 'DECENAL' OR @PeriodoTipo LIKE 'CATORCENAL%' SELECT @Dias = @Dias + 1
IF @MovTipo IN ('NOM.CDH', 'NOM.VT')
BEGIN
SELECT @FechaDHabil = @FechaD
EXEC spRecorrerDiaHabilJornada @Empresa, @FechaDHabil OUTPUT, @Jornada
SELECT @DiasNoHabilFechaD = DATEDIFF(day, @FechaD, @FechaDHabil)
SELECT @FechaD = @FechaDHabil
EXEC spDiasNoHabiles @FechaD, @Fin, @DiasHabiles, 0, @Jornada, @DiasNoHabiles OUTPUT
SELECT @DiasNetos = @Dias - @DiasNoHabiles - @DiasNoHabilFechaD
END ELSE
SELECT @DiasNetos = @Dias
IF @DiasNetos > @Cantidad
SELECT @DiasNetos = @Cantidad, @Cantidad = 0
ELSE SELECT @Cantidad = @Cantidad - @DiasNetos
SELECT @Renglon = @Renglon + 2048.0
INSERT #NominaD (Renglon,  Personal,  Cantidad,   FechaD,  Referencia,  Sucursal,  SucursalOrigen)
VALUES (@Renglon, @Personal, @DiasNetos, @FechaD, @Referencia, @Sucursal, @SucursalOrigen)
IF @PeriodoTipo LIKE 'QUINCENAL%' OR @PeriodoTipo LIKE 'CATORCENAL%'
SELECT @FechaD = DATEADD(day, 1, @Fin)
ELSE
SELECT @FechaD = DATEADD(day, @Dias, @FechaD)
END
END
FETCH NEXT FROM crNominaD INTO @Sucursal, @SucursalOrigen, @Personal, @Cantidad, @FechaD, @Referencia, @PeriodoTipo, @Jornada
END  
CLOSE crNominaD
DEALLOCATE crNominaD
DELETE NominaD WHERE ID = @ID
INSERT NominaD (ID, Renglon,  Personal,  Cantidad, FechaD,  Referencia,  Sucursal,  SucursalOrigen)
SELECT @ID, Renglon,  Personal,  Cantidad, FechaD,  Referencia,  Sucursal,  SucursalOrigen
FROM #NominaD
WHERE Cantidad > 0
RETURN
END

