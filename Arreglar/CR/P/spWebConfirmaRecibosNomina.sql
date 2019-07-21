SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spWebConfirmaRecibosNomina
@ID          int  = NULL,
@Personal	  varchar(10) = NULL,
@Empresa	  varchar(5)  = NULL,
@MovID	      varchar(20) = NULL,
@VioDetalle  bit         = NULL,
@Acuerdo     bit         = NULL
AS BEGIN
IF NOT EXISTS(SELECT 1 FROM NominaConsulta WHERE ID = @ID AND Personal = @Personal AND Empresa = @Empresa AND MovID = @MovID)
BEGIN
IF ISNULL(@VioDetalle,0) = 1
INSERT INTO NominaConsulta(ID, Personal, Empresa, MovID, VioDetalle, FechaDetalle)
SELECT @ID, @Personal, @Empresa, @MovID, @VioDetalle, GETDATE()
IF ISNULL(@Acuerdo,0) = 1
INSERT INTO NominaConsulta(ID, Personal, Empresa, MovID, Acuerdo, FechaAcuerdo)
SELECT @ID, @Personal, @Empresa, @MovID, @Acuerdo, GETDATE()
END
ELSE
BEGIN
IF ISNULL(@VioDetalle,0) = 1
UPDATE NominaConsulta SET VioDetalle = @VioDetalle, FechaDetalle = GETDATE() WHERE ID = @ID AND Personal = @Personal AND Empresa = @Empresa AND MovID = @MovID
IF ISNULL(@Acuerdo,0) = 1
UPDATE NominaConsulta SET Acuerdo = @Acuerdo, FechaAcuerdo = GETDATE() WHERE ID = @ID AND Personal = @Personal AND Empresa = @Empresa AND MovID = @MovID
END
SELECT 'Registro actualizado'
RETURN
END

