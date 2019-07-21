SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexEliminarCorreoElectronico
@NombrePerfil			varchar(50),
@NombreCuenta			varchar(50)

AS BEGIN
IF EXISTS(SELECT * FROM msdb.dbo.sysmail_profile WHERE name = @NombrePerfil)
EXECUTE msdb.dbo.sysmail_delete_profile_sp @profile_name = @NombrePerfil
IF EXISTS(SELECT * FROM msdb.dbo.sysmail_account WHERE name = @NombreCuenta)
EXECUTE msdb.dbo.sysmail_delete_account_sp @account_name = @NombreCuenta
END

