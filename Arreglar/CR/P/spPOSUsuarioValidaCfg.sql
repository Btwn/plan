SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSUsuarioValidaCfg
@Usuario	varchar(10)

AS
BEGIN
DECLARE @UsuarioBis		varchar(10),
@DefCajero		varchar(10),
@DefCtaDinero	varchar(10),
@QueEs			varchar(255)
SELECT @QueEs = NULL
SELECT @DefCajero = NULLIF(DefCajero,''), @DefCtaDinero = NULLIF(DefCtaDinero,'') FROM Usuario WHERE Usuario = @Usuario
IF @DefCajero IS NOT NULL
IF EXISTS (SELECT * FROM Usuario WITH (NOLOCK) WHERE DefCajero = @DefCajero AND Usuario <> @Usuario AND Estatus = 'ALTA')
SELECT TOP 1 @QueEs = 'Cajero', @UsuarioBis = Usuario FROM Usuario WITH (NOLOCK) WHERE DefCajero = @DefCajero AND Usuario <> @Usuario
IF @DefCtaDinero IS NOT NULL AND @QueEs IS NULL
IF EXISTS (SELECT * FROM Usuario WITH (NOLOCK) WHERE DefCtaDinero = @DefCtaDinero AND Usuario <> @Usuario AND Estatus = 'ALTA')
SELECT TOP 1 @QueEs = 'CtaDinero', @UsuarioBis = Usuario FROM Usuario WITH (NOLOCK) WHERE DefCtaDinero = @DefCtaDinero AND Usuario <> @Usuario
IF @QueEs = 'Cajero'
SET @QueEs = 'ESTA CONFIGURACI±N NO ES APROPIADA PARA OPERAR EL POS, EL USUARIO '+ @UsuarioBis + 'TIENE EL MISMO CAJERO, SE SUGIERE QUE SEA MODIFICADO'
IF @QueEs = 'CtaDinero'
SET @QueEs = 'ESTA CONFIGURACI±N NO ES APROPIADA PARA OPERAR EL POS, EL USUARIO '+ @UsuarioBis + 'TIENE LA MISMA CTADINERO, SE SUGIERE QUE SEA MODIFICADA'
SELECT @QueEs
END

