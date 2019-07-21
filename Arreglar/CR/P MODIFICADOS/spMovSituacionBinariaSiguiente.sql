SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovSituacionBinariaSiguiente
@Estacion			int,
@Modulo				varchar(5),
@ID					int,
@Mov				varchar(20),
@Estatus 			varchar(15),
@Situacion			varchar(50),
@SituacionNueva		varchar(50)	= NULL OUTPUT,
@SituacionID		int			= NULL OUTPUT,
@SituacionUsuario	varchar(10)	= NULL,
@EnSilencio			bit			= 1,
@Retroceder			bit			= 0

AS BEGIN
DECLARE @Condicional			bit,
@CondicionUsuario		varchar(max),
@SituacionVerdadero	varchar(50),
@SituacionFalso		varchar(50),
@ValidaCondicion		bit,
@ValidaCondUsuario	bit,
@Operador				varchar(10),
@SituacionFecha		datetime,
@PermiteRetroceder	bit,
@Rama					varchar(50),
@EsPadre				bit,
@Cajero				varchar(10),
@Causa				varchar(50),
@Clase				varchar(50),
@Concepto				varchar(50),
@Condicion			varchar(50),
@Contacto				varchar(10),
@CtaDinero			varchar(10),
@Ejercicio			int,
@Empresa				varchar(5),
@EnviarA				int,
@FechaCancelacion		datetime,
@FechaEmision			datetime,
@FechaRegistro		datetime,
@FormaEnvio			varchar(50),
@Importe				money,
@Impuestos			money,
@Moneda				varchar(10),
@MovID				varchar(20),
@Observaciones		varchar(100),
@Origen				varchar(20),
@OrigenID				varchar(20),
@OrigenTipo			varchar(10),
@Periodo				int,
@Proyecto				varchar(50),
@RamaID				int,
@Referencia			varchar(50),
@Retenciones			money,
@SubClase				varchar(50),
@Sucursal				int,
@TipoCambio			float,
@Total				money,
@UEN					int,
@Usuario				varchar(10),
@Vencimiento			datetime,
@ZonaImpuesto			varchar(30)
CREATE TABLE #Situaciones(
Situacion	varchar(50)	NULL,
Rama		bit			NULL
)
SELECT @SituacionFecha = GETDATE()
DELETE MovSituacionBinariaSiguiente WHERE Estacion = @Estacion
IF ISNULL(@Situacion, '') IN('.', '')
SELECT @Situacion = RTRIM(@Mov)+' '+RTRIM(Nombre) FROM Estatus WITH(NOLOCK) WHERE Estatus = @Estatus
SELECT @Condicional = ISNULL(Condicional, 0), @CondicionUsuario = CondicionUsuario, @SituacionVerdadero = SituacionVerdadero,
@SituacionID = ID, @Operador = Operador, @PermiteRetroceder = ISNULL(PermiteRetroceder, 0), @Rama = Rama, @EsPadre = ISNULL(EsPadre, 0)
FROM MovSituacion WITH(NOLOCK)
WHERE Modulo    = @Modulo
AND Mov	   = @Mov
AND Estatus   = @Estatus
AND Situacion = @Situacion
SELECT @SituacionFalso = Situacion
FROM MovSituacion WITH(NOLOCK)
WHERE Modulo	= @Modulo
AND Mov		= @Mov
AND Estatus	= @Estatus
AND Rama		= @Situacion
AND Situacion <> @SituacionVerdadero
IF ISNULL(@PermiteRetroceder, 0) = 1 AND @EsPadre = 0
INSERT INTO #Situaciones(Situacion, Rama) VALUES(@Rama, 1)
INSERT INTO #Situaciones(Situacion) VALUES(@SituacionFalso)
IF @Condicional = 0
BEGIN
SELECT @SituacionNueva = @SituacionVerdadero
INSERT INTO #Situaciones(Situacion) VALUES(@SituacionNueva)
IF @EnSilencio = 1
INSERT INTO MovSituacionBinariaSiguiente(Estacion, Modulo, ID, Mov, Estatus, Situacion, SituacionFecha, SituacionUsuario) VALUES(@Estacion, @Modulo, @ID, @Mov, @Estatus, @SituacionNueva, @SituacionFecha, @SituacionUsuario)
END
ELSE
BEGIN
EXEC spMovInfo @ID, @Modulo, @Cajero = @Cajero OUTPUT, @Causa = @Causa OUTPUT, @Clase = @Clase OUTPUT, @Concepto = @Concepto OUTPUT, @Condicion = @Condicion OUTPUT, @Contacto = @Contacto OUTPUT,
@CtaDinero = @CtaDinero OUTPUT, @Ejercicio = @Ejercicio OUTPUT, @Empresa = @Empresa OUTPUT, @EnviarA = @EnviarA OUTPUT, @FechaCancelacion = @FechaCancelacion OUTPUT,
@FechaEmision = @FechaEmision OUTPUT, @FechaRegistro = @FechaRegistro OUTPUT, @FormaEnvio = @FormaEnvio OUTPUT, @Importe = @Importe OUTPUT, @Impuestos = @Impuestos OUTPUT,
@Moneda = @Moneda OUTPUT, @MovID = @MovID OUTPUT, @Observaciones = @Observaciones OUTPUT, @Origen = @Origen OUTPUT, @OrigenID = @OrigenID OUTPUT, @OrigenTipo = @OrigenTipo OUTPUT,
@Periodo = @Periodo OUTPUT, @Proyecto = @Proyecto OUTPUT, @RamaID = @RamaID OUTPUT, @Referencia = @Referencia OUTPUT, @Retenciones = @Retenciones OUTPUT, @SubClase = @SubClase OUTPUT,
@Sucursal = @Sucursal OUTPUT, @TipoCambio = @TipoCambio OUTPUT, @Total = @Total OUTPUT, @UEN = @UEN OUTPUT, @Usuario = @Usuario OUTPUT, @Vencimiento = @Vencimiento OUTPUT,
@ZonaImpuesto = @ZonaImpuesto OUTPUT
EXEC spMovSituacionBinariaValidarCondicion @Modulo, @ID, @Mov, @Estatus, @Situacion, @SituacionID, @Operador, @Cajero, @Causa, @Clase, @Concepto, @Condicion, @Contacto,
@CtaDinero, @Ejercicio, @Empresa, @EnviarA, @FechaCancelacion, @FechaEmision, @FechaRegistro, @FormaEnvio, @Importe,
@Impuestos, @Moneda, @MovID, @Observaciones, @Origen, @OrigenID, @OrigenTipo, @Periodo, @Proyecto, @RamaID, @Referencia,
@Retenciones, @SubClase, @Sucursal, @TipoCambio, @Total, @UEN, @Usuario, @Vencimiento, @ZonaImpuesto,
@ValidaCondicion = @ValidaCondicion OUTPUT
EXEC spMovSituacionBinariaValidarCondUsuario @Modulo, @ID, @Mov, @Estatus, @Situacion, @SituacionID, @CondicionUsuario, @Cajero, @Causa, @Clase, @Concepto, @Condicion, @Contacto,
@CtaDinero, @Ejercicio, @Empresa, @EnviarA, @FechaCancelacion, @FechaEmision, @FechaRegistro, @FormaEnvio, @Importe,
@Impuestos, @Moneda, @MovID, @Observaciones, @Origen, @OrigenID, @OrigenTipo, @Periodo, @Proyecto, @RamaID, @Referencia,
@Retenciones, @SubClase, @Sucursal, @TipoCambio, @Total, @UEN, @Usuario, @Vencimiento, @ZonaImpuesto, @ValidaCondUsuario OUTPUT
IF @ValidaCondicion = 1 AND @ValidaCondUsuario = 1
BEGIN
SELECT @SituacionNueva = @SituacionVerdadero
INSERT INTO #Situaciones(Situacion) VALUES(@SituacionNueva)
IF @EnSilencio = 1
INSERT INTO MovSituacionBinariaSiguiente(Estacion, Modulo, ID, Mov, Estatus, Situacion, SituacionFecha, SituacionUsuario) VALUES(@Estacion, @Modulo, @ID, @Mov, @Estatus, @SituacionNueva, @SituacionFecha, @SituacionUsuario)
END
ELSE
BEGIN
SELECT @SituacionNueva = @SituacionFalso
IF @EnSilencio = 1
INSERT INTO MovSituacionBinariaSiguiente(Estacion, Modulo, ID, Mov, Estatus, Situacion, SituacionFecha, SituacionUsuario) VALUES(@Estacion, @Modulo, @ID, @Mov, @Estatus, @SituacionFalso, @SituacionFecha, @SituacionUsuario)
END
END
IF @EnSilencio = 0
IF @Retroceder = 1
SELECT Situacion FROM #Situaciones WHERE Situacion IS NOT NULL AND Rama = 1
ELSE
SELECT Situacion FROM #Situaciones WHERE Situacion IS NOT NULL
END

