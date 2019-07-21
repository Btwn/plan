SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovAlActualizar
@Modulo		char(5),
@ID			int,
@Mov			varchar(20),
@EstatusNuevo	varchar(15),
@EstatusAnterior	varchar(15),
@SituacionNueva	varchar(50),
@SituacionAnterior	varchar(50)

AS BEGIN
DECLARE
@SMS		varchar(20),
@CtoTipo 		varchar(20),
@Contacto 		char(10),
@ContactoSMS	bit,
@Telefono		varchar(50),
@Mensaje		varchar(255),
@MovID		varchar(20),
@Importe		money,
@Moneda		varchar(10),
@EstatusNombre	varchar(100),
@Referencia		varchar(50),
@Usuario		varchar(10),
@DefUsuario		varchar(10),
@Sucursal		int
SELECT @DefUsuario = NULL
SELECT @DefUsuario = NULLIF(RTRIM(DefUsuario), '')
FROM MovTipo  WITH (NOLOCK) 
WHERE Modulo = @Modulo AND Mov = @Mov
IF @DefUsuario IS NOT NULL
EXEC spMovPutInfo @ID, @Modulo, @Usuario = @DefUsuario
EXEC spMovReg @Modulo, @ID, @UnicamenteActualizar = 1
IF @EstatusNuevo IN ('PENDIENTE', 'CONCLUIDO', 'CONCILIADO', 'CANCELADO') AND (@EstatusNuevo<>@EstatusAnterior OR @SituacionNueva<>@SituacionAnterior)
EXEC spMailAuto @Modulo, @ID, @Mov
IF ISNULL(@SituacionNueva, '') <> ISNULL(@SituacionAnterior, '')
BEGIN
SELECT @SMS = NULL
SELECT @SMS = NULLIF(UPPER(NULLIF(RTRIM(SMS), '')), 'No') FROM MovSituacion  WITH (NOLOCK)  WHERE Modulo = @Modulo AND Mov = @Mov AND Estatus = @EstatusNuevo AND Situacion = @SituacionNueva
IF @SMS IN ('INFORMAR', 'AVANZAR')
BEGIN
SELECT @Sucursal = Sucursal, @CtoTipo = UPPER(CtoTipo), @Contacto = Contacto, @MovID = MovID, @Importe = Importe, @Moneda = Moneda, @Usuario = Usuario
FROM dbo.fnMovReg(@Modulo, @ID)
IF @CtoTipo = 'CLIENTE'
BEGIN
SELECT @ContactoSMS = 0, @Referencia = NULL
SELECT @Telefono = NULLIF(RTRIM(PersonalTelefonoMovil), ''), @ContactoSMS = ISNULL(PersonalSMS, 0)
FROM Cte  WITH (NOLOCK) 
WHERE Cliente = @Contacto
SELECT @EstatusNombre = Nombre FROM Estatus  WITH (NOLOCK)  WHERE Estatus = @EstatusNuevo
SELECT @Mensaje = RTRIM(@Mov)+' '+@MovID+' ('+CONVERT(varchar, @Importe, 1)+' '+RTRIM(@Moneda)+') - '+@EstatusNombre+' '+@SituacionNueva
IF @SMS = 'AVANZAR' SELECT @Mensaje = @Mensaje + ', para avanzar responda con el folio', @Referencia = @MovID
SELECT @Mensaje = @Mensaje + '.'
IF @ContactoSMS = 1 AND @Telefono IS NOT NULL
BEGIN
INSERT SMS (Telefono, Tipo, EnvioMensaje, Modulo, ModuloID, Referencia) VALUES (@Telefono, 'Lote', @Mensaje, @Modulo, @ID, @Referencia)
IF @SMS = 'INFORMAR'
INSERT MovBitacora (Modulo, ID, Fecha, Evento, Sucursal, Usuario, Tipo) VALUES (@Modulo, @ID, GETDATE(), @Telefono, @Sucursal, @Usuario, 'Informe SMS')
END
END
END
END
RETURN
END

