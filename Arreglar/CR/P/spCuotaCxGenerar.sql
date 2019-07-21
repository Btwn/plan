SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  spCuotaCxGenerar
(
@Empresa	varchar(5),
@Modulo	    varchar(5),
@Ejercicio	int,
@Periodo	int,
@Silencioso bit = 0
)

AS
BEGIN
DECLARE
@ID			int,
@ModuloID		int,
@Moneda		varchar(10),
@TipoCambio	float,
@Agente		varchar(10),
@Saldo		money,
@FechaInicio  datetime,
@FechaFinal	datetime,
@ImporteReal	money,
@FechaReal	datetime,
@SaldoCuota	money,
@Sql			nvarchar(1000)
SET @FechaInicio = CONVERT(datetime,CONVERT(varchar,@Ejercicio) + '-1-' + CONVERT(varchar,@Periodo))
SET @FechaFinal = DATEADD(MM,1,DATEADD(dd,-DAY(@FechaInicio),@FechaInicio))
IF NOT EXISTS(SELECT ID FROM CuotaCx WHERE Empresa = @Empresa AND Modulo = @Modulo AND Ejercicio = @Ejercicio AND Periodo = @Periodo)
BEGIN
INSERT INTO CuotaCx (Empresa, Modulo, Ejercicio, Periodo, Estatus)
VALUES (@Empresa, @Modulo, @Ejercicio, @Periodo, 'Abierto')
SET @ID = SCOPE_IDENTITY()
END ELSE
SELECT @ID = ID FROM CuotaCx WHERE Empresa = @Empresa AND Modulo = @Modulo AND Ejercicio = @Ejercicio AND Periodo = @Periodo
IF @Modulo = 'CXC'
BEGIN
DECLARE crCursor CURSOR FOR
SELECT ID, Saldo
FROM Cxc
JOIN MovTipo
ON Cxc.Mov = MovTipo.Mov
WHERE Cxc.Vencimiento BETWEEN @FechaInicio  AND @FechaFinal
AND Estatus = 'PENDIENTE'
AND MovTipo.Clave IN ('CXC.F','CXC.CA','CXC.CAP','CXC.CAD','CXC.D','CXC.DM')
END ELSE
BEGIN
DECLARE crCursor CURSOR FOR
SELECT ID, Saldo
FROM Cxp
JOIN MovTipo
ON Cxp.Mov = MovTipo.Mov
WHERE Cxp.Vencimiento BETWEEN @FechaInicio AND @FechaFinal
AND Estatus = 'PENDIENTE'
AND MovTipo.Clave IN ('CXP.F','CXP.CA','CXP.CAP','CXP.CAD','CXP.D','CXP.DM')
END
OPEN crCursor
FETCH NEXT FROM crCursor INTO @ModuloID, @Saldo
WHILE @@FETCH_STATUS <> -1
BEGIN
SELECT @SaldoCuota = Saldo FROM CuotaCxD WHERE ID = @ID AND Modulo = @Modulo AND ModuloID = @ModuloID
SET @FechaReal = NULL
SET @Sql = 'SELECT @FechaReal = MAX(FechaEmision) FROM ' + @Modulo + ' WHERE ORIGENID = @ModuloID AND ORIGENTIPO = ' + char(39) + @Modulo + char(39) + ' AND Estatus = ' + char(39) + 'CONCLUIDO' + char(39)
EXEC sp_executesql @Sql,N'@ModuloID varchar(20), @FechaReal datetime OUTPUT',@ModuloID = @ModuloID, @FechaReal = @FechaReal OUTPUT
SET @ImporteReal = @SaldoCuota - @Saldo
UPDATE CuotaCxD SET Saldo = @Saldo, ImporteReal = ImporteReal + @ImporteReal, FechaReal = CASE @ImporteReal WHEN 0.0 THEN FechaReal ELSE @FechaReal END
WHERE ID = @ID AND Modulo = @Modulo AND ModuloID = @ModuloID
IF @@ROWCOUNT = 0
BEGIN
INSERT INTO CuotaCxD (ID, Modulo, ModuloID, Saldo)
VALUES (@ID, @Modulo, @ModuloID, @Saldo)
END
FETCH NEXT FROM crCursor INTO @ModuloID, @Saldo
END
CLOSE crCursor
DEALLOCATE crCursor
IF @Silencioso = 0
SELECT 'Se han generado las cuotas de ' + @Modulo + ' para el periodo ' + CONVERT(varchar,@Periodo) + ' del ejercicio ' + CONVERT(varchar,@Ejercicio) + '.'
END

