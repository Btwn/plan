SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaMatarCorresponde
@Sucursal		int,
@Accion			char(20),
@Modulo			char(5),
@Empresa		char(5),
@ID			int,
@Mov			char(20),
@MovID			varchar(20),
@MovTipo		char(20),
@Personal		char(10),
@PersonalFechaD		datetime,
@PersonalFechaA		datetime,
@GenerarBaja		bit,
@ProcesarIncidencias	bit,
@Ok             	int          OUTPUT,
@OkRef			varchar(255) OUTPUT

AS BEGIN
DECLARE
@Suma 				money,
@Condicion			varchar(50),
@Importe			money,
@Cantidad			money,
@Porcentaje			money,
@Monto				money,
@FechaD				datetime,
@FechaA				datetime,
@CantidadPendiente	money,
@Saldo				money,
@Activo				bit,
@SaldoAnterior		money,
@CantidadAnterior	money,
@DID				int,
@DRenglon			float,
@DMov				char(20),
@DMovID				varchar(20),
@Procesar			bit,
@DEstatus			char(15),
@Origen				char(20),
@OrigenID			varchar(20),
@DMovTipo			varchar(20),
@ConsecutivoPorPeriodo		bit,
@ConsecutivoPorEjercicio	bit,
@ConsecutivoPorEmpresa		char(20),
@ConsecutivoSucursalEsp		bit,
@Ejercicio					int,
@Periodo					int
SELECT @ConsecutivoPorPeriodo   = ConsecutivoPorPeriodo,
@ConsecutivoPorEjercicio = ConsecutivoPorEjercicio,
@ConsecutivoPorEmpresa   = ISNULL(UPPER(ConsecutivoPorEmpresa), 'SI'),
@ConsecutivoSucursalEsp  = ISNULL(ConsecutivoSucursalEsp, 0)
FROM MovTipo
WHERE Modulo = 'NOM'
AND Mov    = @Mov
IF @Accion = 'CANCELAR' OR (@MovTipo = 'NOM.NC' AND @Accion <> 'CANCELAR')
BEGIN
IF @MovTipo = 'NOM.NC'
BEGIN
SELECT @Origen = Origen, @OrigenID = OrigenID, @Periodo = Periodo, @Ejercicio = Ejercicio FROM Nomina WHERE ID = @ID
SELECT @ID = NULL
SELECT @ID = ID FROM Nomina WHERE Empresa = @Empresa AND Mov = @Origen AND MovID = @OrigenID AND Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND Periodo   = CASE WHEN @ConsecutivoPorPeriodo   = 1    THEN @Periodo   ELSE Periodo   END
AND Ejercicio = CASE WHEN @ConsecutivoPorEjercicio = 1    THEN @Ejercicio ELSE Ejercicio END
AND Empresa   = CASE WHEN @ConsecutivoPorEmpresa   = 'SI' THEN @Empresa   ELSE Empresa  END
AND Sucursal  = CASE WHEN @ConsecutivoSucursalEsp  = 1    THEN @Sucursal  ELSE Sucursal END
END
DECLARE crLog CURSOR FOR
SELECT l.DID, l.DRenglon, l.Importe, l.Cantidad, l.Procesar, n.Mov, n.MovID
FROM NominaLog l, Nomina n
WHERE n.ID = l.ID
AND l.ID = @ID
AND l.Personal = @Personal
AND l.Referencia = 0
OPEN crLog
FETCH NEXT FROM crLog INTO @DID, @DRenglon, @Importe, @Cantidad, @Procesar, @DMov, @DMovID
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @Procesar = 1
BEGIN
UPDATE NominaD SET Activo = 1, CantidadPendiente = @Cantidad WHERE ID = @DID AND Renglon = @DRenglon
EXEC spValidarTareas @Empresa, @Modulo, @DID, 'PROCESAR', @Ok OUTPUT, @OkRef OUTPUT
UPDATE Nomina SET @DEstatus = Estatus = 'PROCESAR' WHERE ID = @DID
IF @DEstatus NOT IN ('CONCLUIDO', 'PROCESAR') SELECT @Ok = 60060
END ELSE
BEGIN
UPDATE NominaD
SET Saldo = ISNULL(Saldo, 0.0) + @Importe,
CantidadPendiente = ISNULL(CantidadPendiente, 0.0) + @Cantidad,
Activo = 1
WHERE ID = @DID AND Renglon = @DRenglon
END
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @DID, @DMov, @DMovID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END
FETCH NEXT FROM crLog INTO @DID, @DRenglon, @Importe, @Cantidad, @Procesar, @DMov, @DMovID
END
CLOSE crLog
DEALLOCATE crLog
END ELSE
BEGIN
DECLARE crVigente CURSOR FOR
SELECT NULLIF(RTRIM(UPPER(n.Condicion)), ''), ISNULL(d.Importe, 0.0), ISNULL(d.Cantidad, 0.0), ISNULL(d.Porcentaje, 0.0), ISNULL(d.Monto, 0.0), d.FechaD, d.FechaA, ISNULL(d.CantidadPendiente, 0.0), ISNULL(d.Saldo, 0.0), d.Activo, n.ID, n.Mov, n.MovID, d.Renglon
FROM Nomina n, NominaD d
WHERE n.ID = d.ID
AND n.Estatus = 'VIGENTE'
AND n.Empresa = @Empresa
AND (d.FechaD <= dbo.fnNominaFechaDesfasada(@Empresa, n.Mov, @PersonalFechaA) OR @GenerarBaja = 1)
AND n.Condicion NOT IN ('REPETIR SIEMPRE', '% SUELDO')
AND d.Personal = @Personal
AND d.Activo = 1
AND (@ProcesarIncidencias = 1 OR n.Mov IN (SELECT Incidencia FROM MovTipoIncidencias WHERE Modulo = @Modulo AND Mov = @Mov AND Concepto IN ('(Todos)', n.Concepto)))
AND n.ID IN (SELECT ID FROM NominaCorrespondeLote WHERE IDNomina = @ID AND Personal = @Personal AND Utilizado = 1)
OPEN crVigente
FETCH NEXT FROM crVigente INTO @Condicion, @Importe, @Cantidad, @Porcentaje, @Monto, @FechaD, @FechaA, @CantidadPendiente, @Saldo, @Activo, @DID, @DMov, @DMovID, @DRenglon
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @DMovTipo = Clave FROM MovTipo WHERE Mov = @DMov AND Modulo = 'NOM'
SELECT @SaldoAnterior = @Saldo, @CantidadAnterior = @CantidadPendiente
IF @Condicion = 'REPETIR FECHAS' AND (@PersonalFechaA >= @FechaA OR @GenerarBaja = 1) SELECT @Activo = 0 ELSE
IF @Condicion IN ('REPETIR', 'PRORRATEAR')
BEGIN
IF @CantidadPendiente > 0.0 AND @Saldo > 0.0 AND @GenerarBaja = 0
BEGIN
IF @Condicion = 'REPETIR'    SELECT @Saldo = @Saldo - @Importe ELSE
IF @Condicion = 'PRORRATEAR'
BEGIN
IF @MovTipo = 'NOM.NE' AND @DMovTipo IN ('NOM.P', 'NOM.D', 'NOM.PD', 'NOM.PI')
BEGIN
SELECT @Monto = @Saldo
SELECT @Saldo = @Saldo - @Monto
END ELSE
SELECT @Saldo = @Saldo - (@Importe / @Cantidad)
END
SELECT @CantidadPendiente = @CantidadPendiente - 1
END ELSE SELECT @Activo = 0
END
ELSE
IF @Condicion IN ('PRORRATEAR %', 'PRORRATEAR $', 'CON ENGANCHE')
BEGIN
IF @MovTipo = 'NOM.NE' AND @DMovTipo IN ('NOM.P', 'NOM.D', 'NOM.PD', 'NOM.PI')
BEGIN
SELECT @Monto = @Saldo
SELECT @Saldo = @Saldo - @Monto
END ELSE
IF @Saldo > 0.0 AND @GenerarBaja = 0
BEGIN
IF @Condicion = 'PRORRATEAR %' SELECT @Saldo = @Saldo - (@Importe * (@Porcentaje / 100)) ELSE
IF @Condicion = 'PRORRATEAR $' EXEC xpRecalcularSaldoMovVigentes @Modulo,@ID,@DRenglon,@DMov,@DMovID,@Personal,@Monto,@Saldo OUTPUT, @DID 
IF @Condicion = 'CON ENGANCHE'
BEGIN
IF @Saldo = @Importe
SELECT @Saldo = @Saldo - @Cantidad
ELSE
SELECT @Saldo = @Saldo - @Monto
END
END ELSE SELECT @Activo = 0
END
IF @Activo = 0
SELECT @Saldo = 0.0, @CantidadPendiente = 0.0
ELSE BEGIN
IF ROUND(@Saldo, 0) <= 0.0 SELECT @Saldo = 0.0
IF ROUND(@CantidadPendiente, 0) <= 0.0 SELECT @CantidadPendiente = 0.0
END
IF @Saldo = 0.0 AND @CantidadPendiente = 0.0
SELECT @Activo = 0
UPDATE NominaD
SET Saldo = NULLIF(@Saldo, 0.0), CantidadPendiente = NULLIF(@CantidadPendiente, 0.0), Activo = @Activo
WHERE CURRENT OF crVigente
/* Hay un trigger que cambia el Estatus del Encabezado a 'CONCLUIDO' cuando no tiene detalles activos */
INSERT NominaLog (Sucursal, Personal, ID, DID, DRenglon, Importe, Cantidad)
VALUES (@Sucursal, @Personal, @ID, @DID, @DRenglon, (@SaldoAnterior-@Saldo), (@CantidadAnterior-@CantidadPendiente))
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @DID, @DMov, @DMovID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END
FETCH NEXT FROM crVigente INTO @Condicion, @Importe, @Cantidad, @Porcentaje, @Monto, @FechaD, @FechaA, @CantidadPendiente, @Saldo, @Activo, @DID, @DMov, @DMovID, @DRenglon
END
CLOSE crVigente
DEALLOCATE crVigente
INSERT NominaLog (Sucursal, Personal, ID, DID, DRenglon, Cantidad, Procesar)
SELECT @Sucursal, @Personal, @ID, d.ID, d.Renglon, d.CantidadPendiente, d.Activo
FROM Nomina n, NominaD d, MovTipo mt
WHERE n.ID = d.ID
AND n.Estatus = 'PROCESAR'
AND n.Empresa = @Empresa
AND d.Personal = @Personal
AND d.Activo = 1
AND mt.Modulo = 'NOM' AND mt.Mov = n.Mov
AND (d.FechaD <= dbo.fnNominaFechaDesfasada(@Empresa, n.Mov, @PersonalFechaA) OR @GenerarBaja = 1)
AND (@ProcesarIncidencias = 1 OR n.Mov IN (SELECT Incidencia FROM MovTipoIncidencias WHERE Modulo = @Modulo AND Mov = @Mov AND Concepto IN ('(Todos)', n.Concepto)))
AND n.ID IN (SELECT ID FROM NominaCorrespondeLote WHERE IDNomina = @ID AND Personal = @Personal AND Utilizado = 1)
DECLARE crProcesar CURSOR FOR
SELECT d.Personal, d.Activo, n.ID, n.Mov, n.MovID
FROM Nomina n, NominaD d, MovTipo mt
WHERE n.ID = d.ID
AND n.Estatus = 'PROCESAR'
AND n.Empresa = @Empresa
AND d.Personal = @Personal
AND d.Activo = 1
AND mt.Modulo = 'NOM' AND mt.Mov = n.Mov
AND (d.FechaD <= dbo.fnNominaFechaDesfasada(@Empresa, n.Mov, @PersonalFechaA) OR @GenerarBaja = 1)
AND (@ProcesarIncidencias = 1 OR n.Mov IN (SELECT Incidencia FROM MovTipoIncidencias WHERE Modulo = @Modulo AND Mov = @Mov AND Concepto IN ('(Todos)', n.Concepto)))
AND n.ID IN (SELECT ID FROM NominaCorrespondeLote WHERE IDNomina = @ID AND Personal = @Personal AND Utilizado = 1)
OPEN crProcesar
FETCH NEXT FROM crProcesar INTO @Personal, @Activo, @DID, @DMov, @DMovID
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
UPDATE NominaD SET Activo = 0, CantidadPendiente = NULL WHERE CURRENT OF crProcesar
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @DID, @DMov, @DMovID, @Modulo, @ID, @Mov, @MovID, @Ok OUTPUT
END
FETCH NEXT FROM crProcesar INTO @Personal, @Activo, @DID, @DMov, @DMovID
END
CLOSE crProcesar
DEALLOCATE crProcesar
END
RETURN
END

