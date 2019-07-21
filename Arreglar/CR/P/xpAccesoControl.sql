SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpAccesoControl
@Empresa  	char(5),
@Sucursal 	int,
@Usuario 	char(10),
@Codigo		varchar(255),
@FechaHora 	datetime
AS BEGIN
DECLARE
@Color 		    char(10),
@Mensaje  		varchar(255),
@Personal 		char(10),
@Vencimiento  	datetime,
@EstaPresente 	bit,
@HoraRegistro 	char(5),
@Jornada      	varchar(20),
@FechaEmision		datetime,
@Entrada		    datetime,
@MinEntrada		datetime,
@SalIDa		    datetime,
@MinutosComida 	int,
@DiferenciaMin 	int,
@Tolerancia       int,
@NumRetardo       int,
@ID               int,
@ApellidoPaterno  varchar(30),
@ApellidoMaterno  varchar (30),
@Nombre           varchar(30),
@Retardo          int,
@SalidaMax		datetime
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id('[dbo].[LogControlAcceso]'))
CREATE TABLE LogControlAcceso(Personal char(10), Fecha DateTime, Mensaje varchar(255), Color char(10))
SELECT @Color        = 'VERDE',
@Mensaje      = '',
@Personal     = NULL,
@Vencimiento  = NULL,
@estapresente = NULL,
@HoraRegistro = NULL,
@Entrada      = NULL,
@MinEntrada   = NULL,
@Salida       = NULL,
@MinutosComida = 60,
@NumRetardo	= NULL,
@Retardo 	= 0,
@SalidaMax      = NULL
SELECT @Personal        = Personal,
@EstaPresente    = EstaPresente,
@Vencimiento     = VencimientoContrato,
@Jornada         = Jornada ,
@ApellidoPaterno = ApellidoPaterno,
@ApellidoMaterno = ApellidoMaterno,
@Nombre          = Nombre
FROM Personal
WHERE Personal = @Codigo
IF NOT EXISTS( SELECT * FROM PersonalPropValor WHERE CUENTA = @Personal AND  Propiedad='CHEQUEO LIBRE' and Valor='1')
BEGIN
IF @SalidaMax IS NULL
SELECT  @SalidaMax = MAX(SALIDA)
FROM VerJornadaTiempo
WHERE CONVERT(DateTime, FLOOR( CONVERT( float, Salida)), 103) = CONVERT(DateTime, FLOOR(CONVERT(float, @FechaHora)), 103)
AND @Jornada = Jornada
GROUP BY salida
ORDER BY Salida
IF @Codigo       =  '0999'                                    SELECT @Color = 'ROJO', @Mensaje = '', @Retardo = 0 ELSE
IF @Personal     IS NULL                                      SELECT @Color = 'ROJO', @Mensaje = 'No existe esa clave de Personal'  ELSE
IF @Vencimiento  IS NOT  NULL AND @Vencimiento <= @FechaHora  SELECT @Color = 'ROJO', @Mensaje = 'Contrato Vencido'  ELSE
BEGIN
SELECT @Tolerancia = AsisteToleraEntrada FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @Entrada = Entrada, @Salida = Salida
FROM VerJornadaTiempo
WHERE Jornada = @Jornada
AND @FechaHora  BETWEEN  Entrada AND Salida
IF NOT EXISTS (SELECT TOP 1  HoraRegistro,  FechaEmision
FROM AsisteD d, Asiste a
WHERE a.ID           = d.ID
AND FechaEmision   = CONVERT(DateTime, FLOOR( CONVERT( float, @FechaHora)), 103) 
AND Personal       = @Personal
AND UPPER(REGISTRO)= 'ENTRADA'
AND UPPER(Mov)     = 'REGISTRO'
ORDER BY a.fechaemision,d.horaregistro DESC)
IF @Entrada IS NULL
SELECT TOP 1 @Entrada = MIN(Entrada)
FROM VerJornadaTiempo
WHERE CONVERT(DateTime, FLOOR( CONVERT( float, Entrada)), 103) = CONVERT(DateTime, FLOOR(CONVERT(float, @FechaHora)), 103)
AND @Jornada = Jornada
GROUP BY Entrada
ORDER BY Entrada
IF @Entrada IS NULL
SELECT @Entrada = MIN(Entrada)
FROM VerJornadaTiempo
WHERE CONVERT(DateTime, FLOOR( CONVERT( float, Entrada)), 103) = CONVERT(DateTime, FLOOR(CONVERT(float, @FechaHora)), 103)
AND @FechaHora < Entrada
AND @Jornada = Jornada
GROUP BY Entrada
ORDER BY Entrada
SELECT @Entrada = ISNULL(@Entrada, @FechaHora)
IF DATEDIFF(MI,@Entrada,@FechaHora) > @Tolerancia
BEGIN
SELECT TOP 1 @HoraRegistro = HoraRegistro, @FechaEmision = FechaEmision
FROM AsisteD d, Asiste a
WHERE a.ID           = d.ID
AND FechaEmision   = CONVERT(DateTime, FLOOR( CONVERT( float, @FechaHora)), 103) 
AND Personal       = @Personal
AND UPPER(REGISTRO)= 'SALIDA'
AND UPPER(Mov)     = 'REGISTRO'
ORDER BY a.fechaemision,d.horaregistro DESC
IF @HoraRegistro IS NOT NULL 
BEGIN
SELECT @DiferenciaMin = abs((60 * DATEPART(HOUR, @FechaHora - CONVERT(datetime,  LEFT( CONVERT(varchar, @FechaEmision, 126), 10) + 'T' + @HoraRegistro + ':00', 126) ))+ DATEPART(MI, @FechaHora - CONVERT(datetime, LEFT( CONVERT(varchar, @FechaEmision, 126), 10) + 'T' + @HoraRegistro + ':00', 126) ))
IF @DiferenciaMin > (@MinutosComida + @Tolerancia)
SELECT @Color = 'AMARILLO', @Mensaje = 'Este es un Retardo de comida', @Retardo = 2
END ELSE 
BEGIN
SELECT @Color = 'AMARILLO', @Mensaje = 'Este es un Retardo'  , @Retardo = 1
IF DATEDIFF(MI,@Entrada,@FechaHora) > 20
SELECT @Color = 'AMARILLO', @Mensaje = 'LLegaste muy tarde.'  , @Retardo = 1
END
END
END /*ELSE
IF  NOT (EXISTS( SELECT *  FROM VerJornadaTiempo  WHERE Jornada = @Jornada AND @FechaHora  < = Entrada
AND CONVERT(datetime, CONVERT(int, Entrada), 103) = CONVERT(datetime, CONVERT(int,Salida),103)
AND CONVERT(datetime, CONVERT(int, @FechaHora),103) = CONVERT(datetime,CONVERT(int,Entrada),103))
AND EXISTS (SELECT *,convert(datetime,convert(int,entrada),103) , convert(datetime,convert(int,Salida),103)
FROM VerJornadaTiempo
WHERE Jornada = @Jornada
AND @FechaHora  >= Salida
AND CONVERT(datetime, floor(CONVERT(float,Entrada)),103) = CONVERT(datetime,floor(CONVERT(float,Salida)),103)
AND CONVERT(datetime, floor(CONVERT(float,@FechaHora)),103)  = CONVERT(datetime,floor(CONVERT(float,Salida)),103))
)
IF (NOT EXISTS( SELECT * FROM PersonalPropValor WHERE CUENTA = @Personal AND  Propiedad='Salida Abierta' and Valor='1'))
and @Fechahora  < @SalidaMax
BEGIN
SELECT @Color = 'ROJO', @Mensaje = 'No tienes permitido salir a esta hora'
INSERT LogControlAcceso (Personal,fecha,mensaje,color) values (@Personal,@FechaHora,@mensaje,@color)
END */
IF @Retardo = 1
BEGIN
SELECT @NumRetardo = COUNT(*)
FROM AsisteD d, Asiste a
WHERE a.ID      = d.ID
AND Retardo = 1
AND FechaEmision BETWEEN CONVERT(datetime, RIGHT('0'+RTRIM(LTRIM(CAST(MONTH(@FechaHora) AS varchar))),2) + '/01/' + LTRIM(RTRIM(CAST(YEAR(@FechaHora) AS varchar))), 101) AND @FechaHora
AND Personal = @Personal
SELECT @NumRetardo = ISNULL(@NumRetardo,0) + 1
IF @Numretardo < 3 AND @Color <> 'ROJO'
BEGIN
IF @Numretardo = 1
SELECT @Color = 'AMARILLO', @Mensaje = 'Este es el retardo numero: ' + CAST(@NumRetardo AS varchar), @Retardo=1
IF @Numretardo = 2
SELECT @Color = 'AMARILLO', @Mensaje = 'Este es el retardo numero: ' + CAST(@NumRetardo AS varchar)+' Al siguiente retardo no podras Entrar', @Retardo=1
END
ELSE
IF NOT EXISTS (SELECT *
FROM Asiste a, Asisted d
WHERE d.ID           = a.ID
AND a.Mov          = 'Permiso Acceso'
AND Personal       = @Personal
AND ESTATUS        = 'CONCLUIDO'
AND FechaEmision   = CONVERT(DateTime, FLOOR( CONVERT( float, @FechaHora)), 103)
AND @FechaHora    <= CONVERT(datetime, LEFT(CONVERT(varchar, FechaEmision, 126), 10)
+ 'T' + HoraRegistro + ':00', 126))
SELECT @Color = 'AMARILLO', @Mensaje = 'Este es tu retardo numero: ' + CAST(@NumRetardo AS varchar) + '. Se reportara a tu jefe', @Retardo = 1
ELSE
SELECT @Color = 'AMARILLO', @Mensaje = 'Este es tu retardo numero: ' + CAST(@NumRetardo AS varchar), @Retardo = 1
IF EXISTS(select * FROM Personal WHERE Departamento = 'HELP DESK' AND Personal = @Personal)
IF DATEDIFF(MI,@Entrada,@FechaHora) > @Tolerancia
SELECT @Color = 'Rojo', @Mensaje = 'No puedes entrar Este es tu retardo numero : ' + CAST(@NumRetardo AS varchar), @Retardo = 1
END
IF  EXISTS (SELECT *
FROM Asiste a, Asisted d
WHERE d.ID           = a.ID
AND a.Mov          = 'Permiso HORAS'
AND Personal       = @Personal
AND ESTATUS        in( 'CONCLUIDO','PROCESAR')
AND a.TIPO            ='AUSENCIA'
AND FechaEmision   = CONVERT(DateTime, FLOOR( CONVERT( float, @FechaHora)), 103)
AND @FechaHora    BETWEEN   CONVERT(datetime, LEFT(CONVERT(varchar, FechaEmision, 126), 10) + 'T' + HoraD + ':00', 126) AND
CONVERT(datetime, LEFT(CONVERT(varchar, FechaEmision, 126), 10) + 'T' + HoraA + ':00', 126))
SELECT @COLOR='VERDE', @Retardo = 0,@Mensaje = 'Puedes entrar'
/*  IF @Color = 'ROJO' AND @Codigo <> '0999'
BEGIN
INSERT INTO Asiste  (Empresa,   Mov,             FechaEmision,                                                  UltimoCambio,  Usuario,  Estatus,      Referencia,                                                Observaciones                                             )
VALUES  (@Empresa, 'Permiso Acceso', CONVERT(DateTime, FLOOR( CONVERT( float, @FechaHora)), 103)  , @FechaHora,    @Usuario, 'SINAFECTAR', @Nombre + ' ' + @ApellidoPaterno + ' ' + @ApellidoMaterno, @Nombre + ' ' + @ApellidoPaterno + ' ' + @ApellidoMaterno )
SELECT @ID = @@IDENTITY
INSERT INTO AsisteD (ID, Renglon, Personal,  Registro, HoraRegistro,                                                                                                          FechaD,                                                     FechaA                                                     )
VALUES  (@ID, 2048.0, @Personal, 'Entrada', RIGHT('00'+Convert(varchar,DATEPART(hh,@FechaHora)),2)+':'+RIGHT('00'+Convert(varchar,DATEPART(mi,@FechaHora)+ 5),2), CONVERT(DateTime, FLOOR( CONVERT( float, @FechaHora)), 103),CONVERT(DateTime, FLOOR( CONVERT( float, @FechaHora)), 103))
END*/
END
IF EXISTS (SELECT *
FROM ASISTED, Asiste
WHERE ASISTED.ID = Asiste.ID
AND Personal   = @Personal
AND SUBSTRING(CONVERT(VARCHAR,@FechaHora,108),1,5) = Horaregistro
AND  CONVERT(VARCHAR,@FechaHora,103) = CONVERT(VARCHAR,FechaEmision,103))
SELECT @Color='Rojo', @Mensaje = 'Tienes que esperar al menos un minuto. Checado Duplicado, intenta de nuevo'
SELECT "Color" = @Color, "Mensaje" = @Mensaje, "Retardo" = @Retardo
END

