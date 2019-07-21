SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgUsuarioABC ON Usuario

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@Ok				int,
@TieneMovimientosN		bit,
@TieneMovimientosA		bit,
@UsuarioI			char(10),
@UsuarioD			char(10),
@ConfiguracionI		char(10),
@ConfiguracionD		char(10),
@AccesoI			char(10),
@AccesoD			char(10),
@ContrasenaI		varchar(32),
@ContrasenaD		varchar(32),
@ConfirmacionI		varchar(32),
@ConfirmacionD		varchar(32),
@Mensaje			varchar(255),
@TamanoMinimo		int,
@RequiereAlfa		bit,
@RequiereNumeros	bit,
@UsuarioConfig		char(10)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Ok = NULL
SELECT @TamanoMinimo    = ISNULL(ContrasenaTamanoMinimo, 0),
@RequiereAlfa    = ISNULL(ContrasenaRequiereAlfa, 0),
@RequiereNumeros = ISNULL(ContrasenaRequiereNumeros, 0)
FROM Version
SELECT @UsuarioI = Usuario, @TieneMovimientosN = TieneMovimientos, @ConfiguracionI = NULLIF(RTRIM(Configuracion), ''), @AccesoI = NULLIF(RTRIM(Acceso), ''), @ContrasenaI = Contrasena, @ConfirmacionI = ContrasenaConfirmacion FROM Inserted
SELECT @UsuarioD = Usuario, @TieneMovimientosA = TieneMovimientos, @ConfiguracionD = NULLIF(RTRIM(Configuracion), ''), @AccesoD = NULLIF(RTRIM(Acceso), ''), @ContrasenaD = Contrasena, @ConfirmacionD = ContrasenaConfirmacion FROM Deleted
IF (NULLIF(@ConfiguracionI,'') IS NOT NULL AND @ConfiguracionI = @UsuarioI) OR (NULLIF(@AccesoI,'') IS NOT NULL AND @AccesoI = @UsuarioI)
BEGIN
RAISERROR ('No Puede Copiar Configuración o Accesos del Mismo Usuario',16,-1)
RETURN
END
SELECT  @UsuarioConfig=Configuracion from Usuario where Usuario =@UsuarioI
IF UPDATE (Configuracion)
EXEC spCopiarUsuarioMaestroCfg @UsuarioConfig
IF @UsuarioI <> @UsuarioD
BEGIN
EXEC spCopiarUsuarioMaestroCfg @UsuarioConfig
IF @UsuarioD IS NULL
BEGIN
DELETE UsuarioCfg2   WHERE Usuario = @UsuarioI
DELETE UsuarioAcceso WHERE Usuario = @UsuarioI
INSERT INTO UsuarioCfg2   (Usuario) VALUES (@UsuarioI)
INSERT INTO UsuarioAcceso (Usuario) VALUES (@UsuarioI)
END ELSE
BEGIN
IF (@UsuarioI IS NULL AND @TieneMovimientosA = 1) OR  (@UsuarioI IS NOT NULL AND @TieneMovimientosN = 1)
BEGIN
SELECT @Mensaje = '"'+LTRIM(RTRIM(@UsuarioD))+ '" ' + Descripcion FROM MensajeLista WHERE Mensaje = 30150
RAISERROR (@Mensaje,16,-1)
END
IF @UsuarioI IS NULL
BEGIN
DELETE UsuarioD      	       WHERE Usuario = @UsuarioD
DELETE UsuarioAcceso 	       WHERE Usuario = @UsuarioD
DELETE UsuarioAccesoForma      WHERE Usuario = @UsuarioD
DELETE UsuarioCfg2   	       WHERE Usuario = @UsuarioD
DELETE UsuarioMovImporteMaximo WHERE Usuario = @UsuarioD
DELETE UsuarioImpresora        WHERE Usuario = @UsuarioD
DELETE Prop          	       WHERE Cuenta  = @UsuarioD AND Rama='USR'
DELETE NotaCta       	       WHERE Cuenta  = @UsuarioD AND Rama='USR'
END ELSE
IF @UsuarioI <> @UsuarioD
BEGIN
UPDATE UsuarioD                SET Usuario = @UsuarioI WHERE Usuario = @UsuarioD
UPDATE UsuarioAcceso           SET Usuario = @UsuarioI WHERE Usuario = @UsuarioD
UPDATE UsuarioAccesoForma      SET Usuario = @UsuarioI WHERE Usuario = @UsuarioD
UPDATE UsuarioCfg2             SET Usuario = @UsuarioI WHERE Usuario = @UsuarioD
UPDATE UsuarioMovImporteMaximo SET Usuario = @UsuarioI WHERE Usuario = @UsuarioD
UPDATE UsuarioImpresora        SET Usuario = @UsuarioI WHERE Usuario = @UsuarioD
UPDATE Prop                    SET Cuenta  = @UsuarioI WHERE Cuenta  = @UsuarioD AND Rama='USR'
UPDATE NotaCta                 SET Cuenta  = @UsuarioI WHERE Cuenta  = @UsuarioD AND Rama='USR'
END
END
END
IF @UsuarioI IS NOT NULL AND @ContrasenaD <> @ContrasenaI
BEGIN
IF @ContrasenaI <> @ConfirmacionI    SELECT @Ok = 60230/* ELSE
IF LEN(@ContrasenaI) < @TamanoMinimo SELECT @Ok = 60231 ELSE
IF @RequiereNumeros = 1 AND (SELECT dbo.fnTieneNumero(@ContrasenaI)) = 0 SELECT @Ok = 60232 ELSE
IF @RequiereAlfa    = 1 AND (SELECT dbo.fnTieneAlfa(@ContrasenaI))   = 0 SELECT @Ok = 60233*/
END
IF @Ok IS NOT NULL
BEGIN
SELECT @Mensaje = RTRIM(@UsuarioI)+' '+Descripcion FROM MensajeLista WHERE Mensaje = @Ok
RAISERROR (@Mensaje,16,-1)
END
IF @ContrasenaI <> @ContrasenaD
UPDATE Usuario SET ContrasenaFecha = GETDATE() WHERE Usuario = @UsuarioI
IF @UsuarioI IS NOT NULL
BEGIN
IF @ConfiguracionI IS NULL
EXEC spCopiarTablaLista 'Usuario', @UsuarioI
ELSE BEGIN
IF @ConfiguracionI <> @ConfiguracionD
EXEC spCopiarTabla 'Usuario', @ConfiguracionI, @UsuarioI
END
IF @AccesoI IS NULL
EXEC spCopiarTablaLista 'UsuarioAcceso', @UsuarioI
ELSE BEGIN
IF @AccesoI <> @AccesoD
EXEC spCopiarTabla 'UsuarioAcceso', @ConfiguracionI, @UsuarioI
END
END
END

