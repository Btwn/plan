SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spWMSSurtidoProcesarTrabajo
@Empresa		varchar(5),
@Usuario		varchar(10)

AS
BEGIN
DECLARE @Modulo		varchar(5),
@ModuloAnt	varchar(5),
@ModuloID		int,
@ModuloIDAnt	int,
@Posicion		varchar(20),
@Estacion		int
SELECT @Estacion = @@SPID
SELECT @ModuloAnt = ''
WHILE(1=1)
BEGIN
SELECT @Modulo = MIN(Modulo)
FROM WMSSurtidoProcesarTrabajo
WHERE Modulo > @ModuloAnt
IF @Modulo IS NULL BREAK
SELECT @ModuloAnt = @Modulo
SELECT @ModuloIDAnt = 0
WHILE(1=1)
BEGIN
SELECT @ModuloID = MIN(ModuloID)
FROM WMSSurtidoProcesarTrabajo
WHERE Modulo = @Modulo
AND ModuloID > @ModuloIDAnt
IF @ModuloID IS NULL BREAK
SELECT @ModuloIDAnt = @ModuloID
DELETE ListaModuloID WHERE Estacion = @Estacion
DELETE ListaSt WHERE Estacion = @Estacion
INSERT INTO ListaModuloID(Estacion, Modulo, ID) SELECT @Estacion, @Modulo, @ModuloID
EXEC spPreparaSurtido @Estacion, @Empresa, @EnSilencio = 1
SELECT @Posicion = Posicion FROM WMSSurtidoPosicionTrabajo WHERE Modulo = @Modulo AND ModuloID = @ModuloID
INSERT INTO ListaSt(Estacion, Clave) SELECT @Estacion, Articulo FROM WMSSurtidoProcesarD WHERE Estacion = @Estacion AND Procesado = 0
EXEC spWMSAsignaPosicion @Posicion, @Estacion
EXEC spWMSGeneraSurtido @Estacion, @Usuario
END
END
END

