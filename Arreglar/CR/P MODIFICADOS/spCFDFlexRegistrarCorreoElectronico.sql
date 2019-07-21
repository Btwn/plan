SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexRegistrarCorreoElectronico
@NombrePerfil			varchar(50),
@NombreCuenta			varchar(50),
@Descripcion			varchar(100),
@CorreoElectronico		varchar(100),
@Usuario				varchar(100),
@Contrasena				varchar(50),
@Servidor				varchar(100),
@Puerto					int,
@SSL					bit

AS BEGIN
IF EXISTS(SELECT * FROM msdb.dbo.sysmail_account WHERE name = @NombreCuenta)
EXECUTE msdb.dbo.sysmail_delete_account_sp @account_name = @NombreCuenta
IF EXISTS(SELECT * FROM msdb.dbo.sysmail_profile WHERE name = @NombrePerfil)
EXECUTE msdb.dbo.sysmail_delete_profile_sp @profile_name = @NombrePerfil
EXECUTE msdb.dbo.sysmail_add_account_sp
@account_name = @NombreCuenta,
@description = @Descripcion,
@email_address = @CorreoElectronico,
@display_name = @NombreCuenta,
@username=@Usuario,
@password=@Contrasena,
@mailserver_name = @Servidor,
@port = @Puerto,
@enable_ssl = @SSL
EXECUTE msdb.dbo.sysmail_add_profile_sp
@profile_name = @NombrePerfil,
@description = @Descripcion
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
@profile_name = @NombrePerfil,
@account_name = @NombreCuenta,
@sequence_number = 1
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
@profile_name = @NombrePerfil,
@principal_name = 'public',
@is_default = 0
END

