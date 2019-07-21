SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC pNetActualizarProspectoCto
@Usuario           varchar(10)  = NULL,
@Empresa           varchar(5)   = NULL,
@Sucursal          int          = NULL,
@Prospecto         varchar(10)  = NULL,
@ID                int          = NULL,
@Nombre            varchar(100) = NULL,
@ApellidoPaterno   varchar(30) = NULL,
@ApellidoMaterno   varchar(30) = NULL,
@Atencion          varchar(50) = NULL,
@Tratamiento       varchar(20) = NULL,
@Cargo             varchar(50) = NULL,
@Grupo             varchar(50) = NULL,
@FechaNacimiento   datetime = NULL,
@Telefonos         varchar(100) = NULL,
@Extencion         varchar(20) = NULL,
@eMail             varchar(100) = NULL,
@Fax               varchar(50) = NULL,
@PedirTono         varchar(2)  = NULL,
@Tipo              varchar(20) = NULL,
@Sexo              varchar(20) = NULL
AS BEGIN
DECLARE
@PedirTonoCond	    bit
IF UPPER(ISNULL(@PedirTono,'')) <> 'SI'
SELECT @PedirTonoCond = 0
ELSE
SELECT @PedirTonoCond = 1
IF EXISTS(SELECT 1 FROM ProspectoCto WHERE Prospecto = ISNULL(@Prospecto,'') AND ID = @ID)
UPDATE ProspectoCto SET
Nombre          = @Nombre,
ApellidoPaterno = @ApellidoPaterno,
ApellidoMaterno = @ApellidoMaterno,
Atencion        = @Atencion,
Tratamiento     = @Tratamiento,
Cargo           = @Cargo,
Grupo           = @Grupo,
FechaNacimiento = @FechaNacimiento,
Telefonos       = @Telefonos,
Extencion       = @Extencion,
eMail           = @eMail,
Fax             = @Fax,
Tipo            = @Tipo,
Sexo            = @Sexo,
PedirTono	   = @PedirTonoCond
WHERE Prospecto = @Prospecto AND ID = @ID
ELSE IF ISNULL(@Prospecto,'') <> ''
INSERT INTO ProspectoCto(Prospecto, Nombre, ApellidoPaterno, ApellidoMaterno, Atencion, Tratamiento, Cargo, Grupo, FechaNacimiento,
Telefonos, Extencion, eMail, Fax, PedirTono, Tipo, Sexo)
SELECT @Prospecto, @Nombre, @ApellidoPaterno, @ApellidoMaterno, @Atencion, @Tratamiento, @Cargo, @Grupo, @FechaNacimiento,
@Telefonos, @Extencion, @eMail, @Fax, @PedirTonoCond, @Tipo, @Sexo
SELECT 'El registro de actualizó'
RETURN
END

