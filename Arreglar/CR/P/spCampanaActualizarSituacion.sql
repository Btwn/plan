SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCampanaActualizarSituacion
@ID		int,
@RID		int

AS BEGIN
DECLARE	@ContactoTipo		varchar(20),
@Contacto		varchar(10),
@Situacion		varchar(50),
@SituacionUsuario	varchar(10),
@SituacionFecha		datetime,
@Observaciones		varchar(100),
@CampanaMov		varchar(20),
@CampanaMovID		varchar(20),
@Empresa		varchar(5),
@Usuario		varchar(10)
SELECT @CampanaMov = Mov, @CampanaMovID = MovID, @Empresa = Empresa, @Usuario = Usuario FROM Campana WHERE ID = @ID
SELECT @ContactoTipo = ContactoTipo, @Contacto = Contacto, @Situacion = Situacion, @SituacionFecha = SituacionFecha, @SituacionUsuario = Usuario, @Observaciones = SUBSTRING(Observaciones,1,100) FROM CampanaD WHERE ID = @ID AND RID = @RID
IF RTRIM(UPPER(@ContactoTipo)) = 'CLIENTE'
BEGIN
IF EXISTS(SELECT * FROM CtaSituacion WHERE RAMA = 'CXC' AND Situacion = @Situacion AND CampanaMov = @CampanaMov AND CampanaMovID = @CampanaMovID)
EXEC spCambiarCtaSituacion 'CXC', @Contacto, @Situacion, @SituacionFecha, @SituacionUsuario, @Observaciones, @Empresa, @Usuario
END
IF RTRIM(UPPER(@ContactoTipo)) = 'PROSPECTO'
BEGIN
IF EXISTS(SELECT * FROM CtaSituacion WHERE RAMA = 'CMP' AND Situacion = @Situacion AND CampanaMov = @CampanaMov AND CampanaMovID = @CampanaMovID)
EXEC spCambiarCtaSituacion 'CMP', @Contacto, @Situacion, @SituacionFecha, @SituacionUsuario, @Observaciones, @Empresa, @Usuario
END
IF RTRIM(UPPER(@ContactoTipo)) = 'PROVEEDOR'
BEGIN
IF EXISTS(SELECT * FROM CtaSituacion WHERE RAMA = 'CXP' AND Situacion = @Situacion AND CampanaMov = @CampanaMov AND CampanaMovID = @CampanaMovID)
EXEC spCambiarCtaSituacion 'CXP', @Contacto, @Situacion, @SituacionFecha, @SituacionUsuario, @Observaciones, @Empresa, @Usuario
END
IF RTRIM(UPPER(@ContactoTipo)) = 'PERSONAL'
BEGIN
IF EXISTS(SELECT * FROM CtaSituacion WHERE RAMA = 'RH' AND Situacion = @Situacion AND CampanaMov = @CampanaMov AND CampanaMovID = @CampanaMovID)
EXEC spCambiarCtaSituacion 'RH', @Contacto, @Situacion, @SituacionFecha, @SituacionUsuario, @Observaciones, @Empresa, @Usuario
END
RETURN
END

