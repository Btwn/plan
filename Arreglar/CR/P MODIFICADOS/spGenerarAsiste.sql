SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarAsiste
@Empresa		char(5),
@Personal		char(10),
@FechaInicial	datetime,
@FechaFinal		datetime,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Mov		char(20),
@MovID		varchar(20),
@MovTipo		char(20),
@FechaEmision	datetime,
@Concepto		varchar(50),
@Localidad		varchar(50),
@UltEntrada		datetime,
@UltSalida		datetime,
@UltLocalidad	varchar(50),
@Registro		char(10),   
@HoraRegistro	char(5),
@HoraD		char(5),
@HoraA		char(5),
@FechaD		datetime,
@FechaA		datetime,
@Entrada		datetime,
@Salida		datetime,
@FechaRegistro	datetime,
@Fecha		datetime,
@FechaUltEntrada varchar(25),
@HoraUltEntrada varchar(5),
@FechaUltSalida varchar(25),
@HoraUltSalida varchar(5)
SELECT @UltEntrada = NULL, @UltSalida = NULL, @UltLocalidad = NULL
SELECT @UltEntrada = MAX(Entrada)
FROM PersonalAsiste
WITH(NOLOCK) WHERE Empresa = @Empresa AND Personal = @Personal AND Fecha < @FechaInicial
IF @UltEntrada IS NOT NULL
SELECT @UltSalida = Salida, @UltLocalidad = Localidad
FROM PersonalAsiste
WITH(NOLOCK) WHERE Empresa = @Empresa AND Personal = @Personal AND Fecha < @FechaInicial AND Entrada = @UltEntrada
DECLARE crProcesar CURSOR
FOR SELECT NULLIF(RTRIM(a.Mov), ''), a.MovID, mt.Clave, a.FechaEmision, NULLIF(RTRIM(d.Concepto), ''), NULLIF(RTRIM(a.Localidad), ''),
NULLIF(UPPER(RTRIM(d.Registro)), ''), NULLIF(RTRIM(d.HoraRegistro), ''), NULLIF(RTRIM(d.HoraD), ''), NULLIF(RTRIM(d.HoraA), ''), d.FechaD, d.FechaA
FROM Asiste a, AsisteD d, MovTipo mt
WITH(NOLOCK) WHERE a.Mov = mt.Mov
AND mt.Modulo = 'ASIS'
AND mt.Clave IN ('ASIS.A', 'ASIS.R')
AND a.ID = d.ID
AND a.Estatus = 'PROCESAR'
AND a.Empresa = @Empresa
AND ISNULL(a.FechaAplicacion, a.FechaEmision) >= @FechaInicial
AND ISNULL(a.FechaAplicacion, a.FechaEmision) < DATEADD(day, 1, @FechaFinal)
AND d.Personal = @Personal
ORDER BY a.FechaEmision, d.HoraRegistro, d.HoraD, d.FechaD
OPEN crProcesar
FETCH NEXT FROM crProcesar  INTO @Mov, @MovID, @MovTipo, @FechaEmision, @Concepto, @Localidad, @Registro, @HoraRegistro, @HoraD, @HoraA, @FechaD, @FechaA
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC spExtraerFecha @FechaEmision OUTPUT
IF @MovTipo = 'ASIS.R'
BEGIN
SELECT @FechaRegistro = @FechaEmision
EXEC spAgregarHora @HoraRegistro, @FechaRegistro OUTPUT
IF @Registro = 'ENTRADA'
BEGIN
/* NES - Se aumenta el siguiente bloque para corregir cuando un personal tiene una Entrada ya procesada en otro corte y para que
mande el error 55200 Entrada Incorrecta cuando se trata de capturar un Registro de Entrada consecutivamente */
IF @UltSalida IS NULL
BEGIN
SELECT TOP 1 @FechaUltSalida = UPPER(d.Registro), @UltEntrada = a.FechaEmision
FROM Asiste a
 WITH(NOLOCK) JOIN AsisteD d  WITH(NOLOCK) ON a.ID = d.ID
JOIN MovTipo mt  WITH(NOLOCK) ON a.Mov = mt.Mov AND mt.Modulo = 'ASIS'
WHERE mt.Clave = 'ASIS.R'
AND a.Empresa = @Empresa
AND a.Estatus = 'CONCLUIDO'
AND d.Personal = @Personal
ORDER BY d.Fecha DESC, d.HoraRegistro DESC
IF @FechaUltSalida = 'SALIDA'
SELECT @UltEntrada = NULL, @UltSalida = NULL
ELSE
SELECT @UltSalida = NULL
END
IF @UltEntrada IS NULL OR (@UltSalida IS NOT NULL AND @UltSalida < @FechaRegistro)
BEGIN
INSERT PersonalAsiste (Empresa, Personal, Entrada, Localidad, Fecha)
VALUES (@Empresa, @Personal, @FechaRegistro, @Localidad, @FechaEmision)
SELECT @UltEntrada = @FechaRegistro, @UltLocalidad = @Localidad
END ELSE
SELECT @Ok = 55200
END ELSE
IF @Registro = 'SALIDA'
BEGIN
/* NES - Se aumenta este bloque para que busque si hay una entrada del personal que ya haya sido procesada en otro corte que es la ultima
entrada antes de este corte, para evitar que salga el error 55210 Salida Incorrecta cuando no es as� */
IF @UltEntrada IS NULL
BEGIN
SELECT TOP 1 @FechaUltEntrada = d.Fecha, @HoraUltEntrada = d.HoraRegistro
FROM Asiste a
 WITH(NOLOCK) JOIN AsisteD d  WITH(NOLOCK) ON a.ID = d.ID
JOIN MovTipo mt  WITH(NOLOCK) ON a.Mov = mt.Mov AND mt.Modulo = 'ASIS'
WHERE mt.Clave = 'ASIS.R'
AND a.Empresa = @Empresa
AND a.Estatus IN('CONCLUIDO','PROCESAR')
AND d.Personal = @Personal
AND UPPER(d.Registro) = 'ENTRADA'
ORDER BY d.Fecha DESC, d.HoraRegistro DESC
SELECT @UltEntrada = CONVERT(datetime, @FechaUltEntrada, 21)
SELECT @UltEntrada = DATEADD(hour, dbo.fnDividirHora(@HoraUltEntrada, 'H'), @UltEntrada)
SELECT @UltEntrada = DATEADD(minute, dbo.fnDividirHora(@HoraUltEntrada, 'M'), @UltEntrada)
IF EXISTS(SELECT HoraRegistro
FROM Asiste a WITH(NOLOCK)
WHERE WITH(NOLOCK) JOIN AsisteD d  WITH(NOLOCK) ON a.ID = d.ID
JOIN MovTipo mt  WITH(NOLOCK) ON a.Mov = mt.Mov AND mt.Modulo = 'ASIS'
WHERE mt.Clave = 'ASIS.R'
AND a.Empresa = @Empresa
AND a.Estatus = 'CONCLUIDO'
AND d.Personal = @Personal
AND UPPER(d.Registro) = 'SALIDA'
AND a.FechaEmision >= @UltEntrada AND a.FechaEmision < @FechaInicial)
SELECT @UltEntrada = NULL
ELSE
INSERT PersonalAsiste (Empresa, Personal, Entrada, Localidad, Fecha)
VALUES (@Empresa, @Personal, @UltEntrada, @Localidad, @FechaEmision)
END
IF @UltEntrada IS NOT NULL AND @Localidad = @UltLocalidad
BEGIN
UPDATE PersonalAsiste  WITH(ROWLOCK) SET Salida = @FechaRegistro WHERE Empresa = @Empresa AND Personal = @Personal AND Entrada = @UltEntrada
SELECT @UltSalida = @FechaRegistro, @UltLocalidad = @Localidad
END ELSE
SELECT @Ok = 55210
END
END ELSE
IF @MovTipo = 'ASIS.A'
BEGIN
SELECT @FechaD = @FechaEmision, @FechaA = @FechaEmision
EXEC spAgregarHora @HoraD, @FechaD OUTPUT
EXEC spAgregarHora @HoraA, @FechaA OUTPUT
IF @FechaA >= @FechaD AND @FechaD IS NOT NULL AND (@FechaD > @UltEntrada OR @UltEntrada IS NULL)
BEGIN
IF @FechaA IS NOT NULL AND (@FechaA > @UltSalida OR @UltSalida IS NULL)
BEGIN
SELECT @Fecha = @FechaD
EXEC spExtraerFecha @Fecha OUTPUT
INSERT PersonalAsiste (Empresa,  Personal,  Entrada, Salida,  Localidad,  Fecha)
VALUES (@Empresa, @Personal, @FechaD, @FechaA, @Localidad, @Fecha)
SELECT @UltEntrada = @FechaD, @UltSalida = @FechaA, @UltLocalidad = @Localidad
END ELSE
SELECT @Ok = 55210
END ELSE
SELECT @Ok = 55200
END
IF @Ok IS NOT NULL AND @OkRef IS NULL
SELECT @OkRef = 'Persona: '+RTRIM(@Personal)+'<BR>'+'Movimiento: '+RTRIM(@Mov)+' '+@MovID
END
FETCH NEXT FROM crProcesar  INTO @Mov, @MovID, @MovTipo, @FechaEmision, @Concepto, @Localidad, @Registro, @HoraRegistro, @HoraD, @HoraA, @FechaD, @FechaA
END  
CLOSE crProcesar
DEALLOCATE crProcesar
RETURN
END

