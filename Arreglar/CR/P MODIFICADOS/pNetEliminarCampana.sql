SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC pNetEliminarCampana
@TipoCuenta    varchar(50),  
@ID            int         = NULL,
@RID           int         = NULL,
@EventoID      int         = NULL,
@Cuenta        varchar(50) = NULL,
@SubCuenta     varchar(50) = NULL
AS BEGIN
IF ISNULL(@TipoCuenta,'') = 'CampanaTipo'
BEGIN
DELETE FROM CampanaTipoSituacion WHERE CampanaTipo = @Cuenta
DELETE FROM CampanaTipo WHERE CampanaTipo = @Cuenta
END
ELSE IF ISNULL(@TipoCuenta,'') = 'CampanaTipoSituacion'
BEGIN
DELETE FROM CampanaTipoSituacion WHERE CampanaTipo = @Cuenta AND Situacion = @SubCuenta
END
ELSE IF ISNULL(@TipoCuenta,'') = 'Cargo'
BEGIN
DELETE FROM Cargo WHERE Cargo = @Cuenta
END
ELSE IF ISNULL(@TipoCuenta,'') = 'Campana'
BEGIN
DELETE FROM CampanaEvento WHERE ID = @ID
DELETE FROM CampanaD WHERE ID = @ID
DELETE FROM Campana WHERE ID = @ID
END
ELSE IF ISNULL(@TipoCuenta,'') = 'CampanaD'
BEGIN
DELETE FROM CampanaD WHERE ID = @ID AND RID = @RID
END
ELSE IF ISNULL(@TipoCuenta,'') = 'CampanaEvento'
BEGIN
DELETE FROM CampanaEvento WHERE ID = @ID AND RID = @RID AND EventoID = @EventoID
END
ELSE IF ISNULL(@TipoCuenta,'') = 'Prospecto'
BEGIN
DELETE FROM ProspectoCto WHERE Prospecto = @Cuenta
DELETE FROM Prospecto WHERE Prospecto = @Cuenta
DELETE e FROM CampanaEvento e INNER JOIN CampanaD d WITH(NOLOCK) ON e.ID = d.ID AND e.RID = d.RID WHERE d.ContactoTipo = @TipoCuenta AND d.Contacto = @Cuenta
DELETE FROM CampanaD WHERE ContactoTipo = @TipoCuenta AND Contacto = @Cuenta
END
ELSE IF ISNULL(@TipoCuenta,'') = 'ProspectoCto'
BEGIN
DELETE FROM ProspectoCto WHERE Prospecto = @Cuenta AND ID = @ID
END
ELSE IF ISNULL(@TipoCuenta,'') = 'CampanaProspecto'
BEGIN
DELETE FROM CampanaD WHERE ID = @ID AND RID = @RID AND ContactoTipo = 'Prospecto'
DELETE FROM CampanaEvento WHERE ID = @ID AND RID = @RID
END
SELECT 'Se eliminó el registro'
RETURN
END

