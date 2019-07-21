SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spEjecutaAsistenciasLaboradas]
@rID        int,
@Empresa	varchar(5),
@Sucursal   int,
@Estacion   int,
@Usuario	varchar(10)

AS BEGIN
DECLARE
@cPersonal                  varchar(10),
@cDia                       datetime,
@Jornada                    varchar(20),
@MinutosJor                 float,
@MinutosAs                  float,
@MinutosLab                 float,
@Fecha                      datetime,
@Moneda                     varchar(20),
@TipoCambio                 float,
@Modulo                     varchar(20),
@Mov                        varchar(20),
@MovID                      varchar(20),
@IDNomina                   int,
@IDIdentity                 int,
@Renglon                    float,
@DiaSemanaAsist             int,
@Domingo                    bit,
@Sabado                     bit,
@Lunes                      bit,
@Martes                     bit,
@Miercoles                  bit,
@Jueves                     bit,
@Viernes                    bit,
@Horas                      varchar(5),
@Cantidad                   money,
@TipoMov                    varchar(20),
@RegEncabezado              int,
@crPersonal                 varchar(10),
@crID                       int,
@crFecha                    datetime,
@crTipo                     varchar(20),
@crCantidad                 money,
@crHoras                    varchar(5),
@Estatus                    varchar(15),
@AsistDescansolaborado      bit,
@AsistDiaFestivolaborado    bit,
@AsistDomingoLaborado       bit
DECLARE @TABLE TABLE
(
Id          Int,
IdMov       Int,
Personal	Varchar(10),
Fecha       Datetime,
Tipo        varchar(20),
Cantidad    money,
Horas       varchar(5)
)
SELECT @Estatus = 'CONFIRMAR'
SELECT @AsistDescansolaborado   = ISNULL(AsistDescansolaborado,0),
@AsistDiaFestivolaborado = ISNULL(AsistDiaFestivolaborado,0),
@AsistDomingoLaborado    = ISNULL(AsistDomingoLaborado,0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
DECLARE cPersonal CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Personal ASC) ID, B.Personal, B.Fecha
FROM Asiste A
JOIN AsisteD B
ON A.ID = B.ID
JOIN MovTipo C
ON A.Mov = C.Mov
WHERE C.Clave = 'ASIS.C'
AND A.Empresa = @Empresa
AND A.Id = @rID
AND A.Estatus <> 'CANCELADO'
GROUP BY A.ID, B.Personal, B.Fecha
ORDER BY A.ID, B.Personal ASC
OPEN cPersonal
FETCH NEXT FROM cPersonal INTO @IDIdentity, @cPersonal, @cDia
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Cantidad = 0, @Horas = 0, @MinutosAs = 0, @MinutosLab = 0
SELECT @Jornada = Jornada FROM Personal WHERE Personal = @cPersonal
SELECT @Domingo   = Domingo   FROM Jornada WHERE Jornada = @Jornada
SELECT @Sabado    = Sabado    FROM Jornada WHERE Jornada = @Jornada
SELECT @Lunes     = Lunes     FROM Jornada WHERE Jornada = @Jornada
SELECT @Martes    = Martes    FROM Jornada WHERE Jornada = @Jornada
SELECT @Miercoles = Miercoles FROM Jornada WHERE Jornada = @Jornada
SELECT @Jueves    = Jueves    FROM Jornada WHERE Jornada = @Jornada
SELECT @Viernes   = Viernes   FROM Jornada WHERE Jornada = @Jornada
SELECT @MinutosJor = ISNULL(SUM(DATEDIFF(mi,Entrada,Salida)),0)
FROM VerJornadaTiempo
WHERE Jornada = @Jornada
AND DATEPART(YEAR,@cDia) = Ano
AND DATEPART(MONTH,@cDia) = Mes
AND DATEPART(DAY,@cDia) = Dia
GROUP BY Ano, Mes, Dia
SELECT @Fecha = Fecha FROM ASISTED WHERE ID = @rID AND Personal = @cPersonal AND Fecha = @cDia
SELECT @MinutosAs = ISNULL(Cantidad,0) FROM ASISTED WHERE ID = @rID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = 'Minutos Asistencia'
SELECT @DiaSemanaAsist =  DATEPART (DW, @Fecha)
IF CONVERT(VARCHAR(10), @Fecha, 105) NOT IN ( SELECT CONVERT(VARCHAR(10), Entrada, 105) FROM VerJornadaTiempo WHERE Jornada = @Jornada )
BEGIN
IF @@DATEFIRST = 7
BEGIN
IF ((@Fecha IN (SELECT Fecha FROM DiaFestivo)) OR (@Fecha IN (SELECT Fecha FROM JornadaDiaFestivo WHERE Jornada = @Jornada))) AND @AsistDiaFestivolaborado = 1
BEGIN
SELECT @Cantidad = ISNULL(Cantidad,0) FROM ASISTED WHERE ID = @rID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = 'Minutos Asistencia'
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Cantidad),'00:00'))
SELECT @TipoMov = 'Día Festivo laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
IF(@DiaSemanaAsist = 1) AND @AsistDomingoLaborado = 1
BEGIN
SELECT @TipoMov = 'Domingo Laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
END
END
IF @DiaSemanaAsist = 1 AND @AsistDomingoLaborado = 1
BEGIN
SELECT @Cantidad = ISNULL(Cantidad,0) FROM ASISTED WHERE ID = @rID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = 'Minutos Asistencia'
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Cantidad),'00:00'))
IF @MinutosJor >= @MinutosLab
SELECT @TipoMov = 'Domingo Laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
IF (@Domingo = 1 AND @DiaSemanaAsist = 1) AND @AsistDescansolaborado = 1
BEGIN
IF @MinutosJor >= @MinutosLab
SELECT @TipoMov = 'Descanso laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
END
END
IF (@Sabado = 1 AND @DiaSemanaAsist = 7) AND @AsistDescansolaborado = 1
BEGIN
SELECT @Cantidad = ISNULL(Cantidad,0) FROM ASISTED WHERE ID = @rID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = 'Minutos Asistencia'
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Cantidad),'00:00'))
IF @MinutosJor >= @MinutosLab
SELECT @TipoMov = 'Descanso laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
END
IF (@Lunes = 1 AND @DiaSemanaAsist = 2) AND @AsistDescansolaborado = 1
BEGIN
SELECT @Cantidad = ISNULL(Cantidad,0) FROM ASISTED WHERE ID = @rID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = 'Minutos Asistencia'
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Cantidad),'00:00'))
IF @MinutosJor >= @MinutosLab
SELECT @TipoMov = 'Descanso laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
END
IF (@Martes = 1 AND @DiaSemanaAsist = 3) AND @AsistDescansolaborado = 1
BEGIN
SELECT @Cantidad = ISNULL(Cantidad,0) FROM ASISTED WHERE ID = @rID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = 'Minutos Asistencia'
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Cantidad),'00:00'))
IF @MinutosJor >= @MinutosLab
SELECT @TipoMov = 'Descanso laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
END
IF (@Miercoles = 1 AND @DiaSemanaAsist = 4) AND @AsistDescansolaborado = 1
BEGIN
SELECT @Cantidad = ISNULL(Cantidad,0) FROM ASISTED WHERE ID = @rID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = 'Minutos Asistencia'
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Cantidad),'00:00'))
IF @MinutosJor >= @MinutosLab
SELECT @TipoMov = 'Descanso laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
END
IF (@Jueves = 1 AND @DiaSemanaAsist = 5) AND @AsistDescansolaborado = 1
BEGIN
SELECT @Cantidad = ISNULL(Cantidad,0) FROM ASISTED WHERE ID = @rID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = 'Minutos Asistencia'
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Cantidad),'00:00'))
IF @MinutosJor >= @MinutosLab
SELECT @TipoMov = 'Descanso laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
END
IF (@Viernes = 1 AND @DiaSemanaAsist = 6) AND @AsistDescansolaborado = 1
BEGIN
SELECT @Cantidad = ISNULL(Cantidad,0) FROM ASISTED WHERE ID = @rID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = 'Minutos Asistencia'
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Cantidad),'00:00'))
IF @MinutosJor >= @MinutosLab
SELECT @TipoMov = 'Descanso laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
END
END
IF @@DATEFIRST = 1
BEGIN
IF ((@Fecha IN (SELECT Fecha FROM DiaFestivo)) OR (@Fecha IN (SELECT Fecha FROM JornadaDiaFestivo WHERE Jornada = @Jornada))) AND @AsistDiaFestivolaborado = 1
BEGIN
SELECT @Cantidad = ISNULL(Cantidad,0) FROM ASISTED WHERE ID = @rID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = 'Minutos Asistencia'
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Cantidad),'00:00'))
SELECT @TipoMov = 'Día Festivo laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
IF(@DiaSemanaAsist = 7) AND @AsistDomingoLaborado = 1
BEGIN
SELECT @TipoMov = 'Domingo Laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
END
END
IF @DiaSemanaAsist = 7 AND @AsistDomingoLaborado = 1
BEGIN
SELECT @Cantidad = ISNULL(Cantidad,0) FROM ASISTED WHERE ID = @rID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = 'Minutos Asistencia'
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Cantidad),'00:00'))
IF @MinutosJor >= @MinutosLab
SELECT @TipoMov = 'Domingo Laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
IF (@Domingo = 1 AND @DiaSemanaAsist = 7) AND @AsistDescansolaborado = 1
BEGIN
IF @MinutosJor >= @MinutosLab
SELECT @TipoMov = 'Descanso laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
END
END
IF (@Sabado = 1 AND @DiaSemanaAsist = 6) AND @AsistDescansolaborado = 1
BEGIN
SELECT @Cantidad = ISNULL(Cantidad,0) FROM ASISTED WHERE ID = @rID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = 'Minutos Asistencia'
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Cantidad),'00:00'))
IF @MinutosJor >= @MinutosLab
SELECT @TipoMov = 'Descanso laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
END
IF (@Lunes = 1 AND @DiaSemanaAsist = 1) AND @AsistDescansolaborado = 1
BEGIN
SELECT @Cantidad = ISNULL(Cantidad,0) FROM ASISTED WHERE ID = @rID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = 'Minutos Asistencia'
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Cantidad),'00:00'))
IF @MinutosJor >= @MinutosLab
SELECT @TipoMov = 'Descanso laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
END
IF (@Martes = 1 AND @DiaSemanaAsist = 2) AND @AsistDescansolaborado = 1
BEGIN
SELECT @Cantidad = ISNULL(Cantidad,0) FROM ASISTED WHERE ID = @rID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = 'Minutos Asistencia'
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Cantidad),'00:00'))
IF @MinutosJor >= @MinutosLab
SELECT @TipoMov = 'Descanso laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
END
IF (@Miercoles = 1 AND @DiaSemanaAsist = 3) AND @AsistDescansolaborado = 1
BEGIN
SELECT @Cantidad = ISNULL(Cantidad,0) FROM ASISTED WHERE ID = @rID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = 'Minutos Asistencia'
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Cantidad),'00:00'))
IF @MinutosJor >= @MinutosLab
SELECT @TipoMov = 'Descanso laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
END
IF (@Jueves = 1 AND @DiaSemanaAsist = 4) AND @AsistDescansolaborado = 1
BEGIN
SELECT @Cantidad = ISNULL(Cantidad,0) FROM ASISTED WHERE ID = @rID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = 'Minutos Asistencia'
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Cantidad),'00:00'))
IF @MinutosJor >= @MinutosLab
SELECT @TipoMov = 'Descanso laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
END
IF (@Viernes = 1 AND @DiaSemanaAsist = 5) AND @AsistDescansolaborado = 1
BEGIN
SELECT @Cantidad = ISNULL(Cantidad,0) FROM ASISTED WHERE ID = @rID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = 'Minutos Asistencia'
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Cantidad),'00:00'))
IF @MinutosJor >= @MinutosLab
SELECT @TipoMov = 'Descanso laborado'
INSERT @TABLE (Id,          IdMov, Personal,   Fecha, Tipo,  Cantidad,  Horas)
SELECT @IDIdentity, @rID,  @cPersonal, @cDia, @TipoMov, @Cantidad, @Horas
END
END
END
ELSE
BEGIN
SELECT @TipoMov = Tipo FROM Asisted WHERE Id = @rID AND Personal = @cPersonal AND Fecha = @cDia
IF (@TipoMov <> 'Dias Ausencia')
BEGIN
SELECT @Cantidad = ISNULL(Cantidad,0) FROM ASISTED WHERE ID = @rID AND Personal = @cPersonal AND Fecha = @cDia AND Tipo = @TipoMov
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Cantidad),'00:00'))
END
ELSE
BEGIN
SELECT @Cantidad =  @MinutosJor
SELECT @Horas = CONVERT(TIME,DATEADD(MI,CONVERT(INT,@Cantidad),'00:00'))
END
END
FETCH NEXT FROM cPersonal INTO @IDIdentity, @cPersonal, @cDia
END
CLOSE cPersonal
DEALLOCATE cPersonal
DECLARE crAsisteTab CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Personal ASC) Id,
Personal,
Fecha,
Tipo,
Cantidad,
Horas
FROM @TABLE
WHERE Tipo = 'Día Festivo laborado'
OPEN crAsisteTab
FETCH NEXT FROM crAsisteTab INTO @crID, @crPersonal, @crFecha, @crTipo, @crCantidad, @crHoras
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @RegEncabezado = ISNULL(@RegEncabezado,0) + 1
SELECT @Mov    = ISNULL(A.Mov,''),
@MovID  = ISNULL(A.MovID,''),
@Modulo = ISNULL(MT.Modulo,'')
FROM Asiste A
LEFT JOIN MovTipo MT ON MT.Mov = A.Mov
WHERE A.ID = @rID
AND A.Empresa = @Empresa
AND RTRIM(LTRIM(A.Estatus)) = 'CONCLUIDO'
AND MT.Clave = 'ASIS.C'
AND MT.Modulo = 'ASIS'
SELECT @crTipo = 'Festivo laborado'
SELECT @Moneda = Moneda
FROM Personal
WHERE personal = @crPersonal
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE moneda = @Moneda
SELECT @TipoCambio = ISNULL(@TipoCambio,TipoCambio) ,
@Moneda     = ISNULL(@Moneda,Moneda)
FROM Mon
WHERE Orden = 1
SELECT @Renglon = 2048.0 * CONVERT(float, @crID)
IF @Cantidad <> 0.00 AND @Horas <> '00:00'
BEGIN
IF @RegEncabezado = 1
BEGIN
INSERT INTO Nomina (Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Autorizacion, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, OrigenTipo, Origen, OrigenID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Condicion, PeriodoTipo, FechaD, FechaA, Poliza, PolizaID, Sucursal, SucursalOrigen, UEN, FechaOrigen, NOI)
SELECT @Empresa, @crTipo, NULL, GETDATE(), GETDATE(), '', NULL, @Moneda, @TipoCambio, @Usuario, NULL, NULL, NULL, @Estatus, NULL, NULL, NULL, NULL, @Modulo, @Mov, @MovID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, GETDATE(), 0
SET @IDNomina = @@IDENTITY
END
INSERT INTO NominaD (ID, Renglon, Modulo, Plaza, Personal, Importe, Cuenta, FormaPago, Horas, Cantidad, Porcentaje, Monto, FechaD, FechaA, Movimiento, Saldo, Concepto, Referencia, CantidadPendiente, Activo, Sucursal, SucursalOrigen, Beneficiario, ContUso, CuentaContable, UEN, ObligacionFiscal, ClavePresupuestal)
SELECT @IDNomina, @Renglon, 'NOM', NULL, @crPersonal, NULL, NULL, NULL, @crHoras, 1, NULL, NULL, @crFecha, @crFecha, NULL, NULL, NULL, NULL, NULL, 1, @Sucursal, @Sucursal, NULL, NULL, NULL, NULL, NULL, NULL
END
FETCH NEXT FROM crAsisteTab INTO @crID, @crPersonal, @crFecha, @crTipo, @crCantidad, @crHoras
END
CLOSE crAsisteTab
DEALLOCATE crAsisteTab
SELECT @RegEncabezado = 0
DECLARE crAsisteTab CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Personal ASC) Id,
Personal,
Fecha,
Tipo,
Cantidad,
Horas
FROM @TABLE
WHERE Tipo = 'Descanso laborado'
OPEN crAsisteTab
FETCH NEXT FROM crAsisteTab INTO @crID, @crPersonal, @crFecha, @crTipo, @crCantidad, @crHoras
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @RegEncabezado = ISNULL(@RegEncabezado,0) + 1
SELECT @Mov    = ISNULL(A.Mov,''),
@MovID  = ISNULL(A.MovID,''),
@Modulo = ISNULL(MT.Modulo,'')
FROM Asiste A
LEFT JOIN MovTipo MT ON MT.Mov = A.Mov
WHERE A.ID = @rID
AND A.Empresa = @Empresa
AND RTRIM(LTRIM(A.Estatus)) = 'CONCLUIDO'
AND MT.Clave = 'ASIS.C'
AND MT.Modulo = 'ASIS'
SELECT @Moneda = Moneda
FROM Personal
WHERE personal = @crPersonal
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE moneda = @Moneda
SELECT @TipoCambio = ISNULL(@TipoCambio,TipoCambio) ,
@Moneda     = ISNULL(@Moneda,Moneda)
FROM Mon
WHERE Orden = 1
SELECT @Renglon = 2048.0 * CONVERT(float, @crID)
IF @Cantidad <> 0.00 AND @Horas <> '00:00'
BEGIN
IF @RegEncabezado = 1
BEGIN
INSERT INTO Nomina (Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Autorizacion, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, OrigenTipo, Origen, OrigenID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Condicion, PeriodoTipo, FechaD, FechaA, Poliza, PolizaID, Sucursal, SucursalOrigen, UEN, FechaOrigen, NOI)
SELECT @Empresa, @crTipo, NULL, GETDATE(), GETDATE(), '', NULL, @Moneda, @TipoCambio, @Usuario, NULL, NULL, NULL, @Estatus, NULL, NULL, NULL, NULL, @Modulo, @Mov, @MovID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, GETDATE(), 0
SET @IDNomina = @@IDENTITY
END
INSERT INTO NominaD (ID, Renglon, Modulo, Plaza, Personal, Importe, Cuenta, FormaPago, Horas, Cantidad, Porcentaje, Monto, FechaD, FechaA, Movimiento, Saldo, Concepto, Referencia, CantidadPendiente, Activo, Sucursal, SucursalOrigen, Beneficiario, ContUso, CuentaContable, UEN, ObligacionFiscal, ClavePresupuestal)
SELECT @IDNomina, @Renglon, 'NOM', NULL, @crPersonal, NULL, NULL, NULL, @crHoras, 1, NULL, NULL, @crFecha, @crFecha, NULL, NULL, NULL, NULL, NULL, 1, @Sucursal, @Sucursal, NULL, NULL, NULL, NULL, NULL, NULL
END
FETCH NEXT FROM crAsisteTab INTO @crID, @crPersonal, @crFecha, @crTipo, @crCantidad, @crHoras
END
CLOSE crAsisteTab
DEALLOCATE crAsisteTab
SELECT @RegEncabezado = 0
DECLARE crAsisteTab CURSOR FOR
SELECT ROW_NUMBER() OVER(ORDER BY Personal ASC) Id,
Personal,
Fecha,
Tipo,
Cantidad,
Horas
FROM @TABLE
WHERE Tipo = 'Domingo Laborado'
OPEN crAsisteTab
FETCH NEXT FROM crAsisteTab INTO @crID, @crPersonal, @crFecha, @crTipo, @crCantidad, @crHoras
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @RegEncabezado = ISNULL(@RegEncabezado,0) + 1
SELECT @Mov    = ISNULL(A.Mov,''),
@MovID  = ISNULL(A.MovID,''),
@Modulo = ISNULL(MT.Modulo,'')
FROM Asiste A
LEFT JOIN MovTipo MT ON MT.Mov = A.Mov
WHERE A.ID = @rID
AND A.Empresa = @Empresa
AND RTRIM(LTRIM(A.Estatus)) = 'CONCLUIDO'
AND MT.Clave = 'ASIS.C'
AND MT.Modulo = 'ASIS'
SELECT @Moneda = Moneda
FROM Personal
WHERE personal = @crPersonal
SELECT @TipoCambio = TipoCambio
FROM Mon
WHERE moneda = @Moneda
SELECT @TipoCambio = ISNULL(@TipoCambio,TipoCambio) ,
@Moneda     = ISNULL(@Moneda,Moneda)
FROM Mon
WHERE Orden = 1
SELECT @Renglon = 2048.0 * CONVERT(float, @crID)
IF @Cantidad <> 0.00 AND @Horas <> '00:00'
BEGIN
IF @RegEncabezado = 1
BEGIN
INSERT INTO Nomina (Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, Moneda, TipoCambio, Usuario, Autorizacion, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, OrigenTipo, Origen, OrigenID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Condicion, PeriodoTipo, FechaD, FechaA, Poliza, PolizaID, Sucursal, SucursalOrigen, UEN, FechaOrigen, NOI)
SELECT @Empresa, @crTipo, NULL, GETDATE(), GETDATE(), '', NULL, @Moneda, @TipoCambio, @Usuario, NULL, NULL, NULL, @Estatus, NULL, NULL, NULL, NULL, @Modulo, @Mov, @MovID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, GETDATE(), 0
SET @IDNomina = @@IDENTITY
END
INSERT INTO NominaD (ID, Renglon, Modulo, Plaza, Personal, Importe, Cuenta, FormaPago, Horas, Cantidad, Porcentaje, Monto, FechaD, FechaA, Movimiento, Saldo, Concepto, Referencia, CantidadPendiente, Activo, Sucursal, SucursalOrigen, Beneficiario, ContUso, CuentaContable, UEN, ObligacionFiscal, ClavePresupuestal)
SELECT @IDNomina, @Renglon, 'NOM', NULL, @crPersonal, NULL, NULL, NULL, @crHoras, 1, NULL, NULL, @crFecha, @crFecha, NULL, NULL, NULL, NULL, NULL, 1, @Sucursal, @Sucursal, NULL, NULL, NULL, NULL, NULL, NULL
END
FETCH NEXT FROM crAsisteTab INTO @crID, @crPersonal, @crFecha, @crTipo, @crCantidad, @crHoras
END
CLOSE crAsisteTab
DEALLOCATE crAsisteTab
END

