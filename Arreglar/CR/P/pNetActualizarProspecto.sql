SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC pNetActualizarProspecto
@Usuario             varchar(10)  = NULL,
@Empresa             varchar(5)   = NULL,
@Sucursal            int          = NULL,
@IncluyeCatalogo     bit          = NULL, 
@IncluyeMov		  bit          = NULL, 
@ID                  int          = NULL, 
@Prospecto           varchar(10)  = NULL,
@Nombre              varchar(100) = NULL,
@Direccion           varchar(100) = NULL,
@DireccionNumero     varchar(20)  = NULL,
@DireccionNumeroInt  varchar(20)  = NULL,
@EntreCalles         varchar(100) = NULL,
@Plano               varchar(15)  = NULL,
@Observaciones       varchar(100) = NULL,
@Delegacion          varchar(100) = NULL,
@Colonia             varchar(100) = NULL,
@Poblacion           varchar(100) = NULL,
@Estado              varchar(30)  = NULL,
@Pais                varchar(30)  = NULL,
@Zona                varchar(30)  = NULL,
@CodigoPostal        varchar(15)  = NULL,
@RFC                 varchar(15)  = NULL,
@CURP                varchar(30)  = NULL,
@Telefonos           varchar(100) = NULL,
@TelefonosLada       varchar(6)   = NULL,
@Fax                 varchar(50)  = NULL,
@PedirTono           varchar(2)   = NULL,
@PaginaWeb			  varchar(100) = NULL,
@eMail               varchar(50)  = NULL,
@Comentarios		  varchar(max) = NULL,
@Categoria           varchar(50)  = NULL,
@Grupo               varchar(50)  = NULL,
@Familia             varchar(50)  = NULL,
@Tipo                varchar(15)  = NULL,
@Estatus             varchar(15)  = NULL,
@Origen              varchar(50)  = NULL,
@Agente              varchar(10)  = NULL,
@NombreComercial     varchar(100) = NULL,
@ReferidoNombre      varchar(100) = NULL,
@ReferidoMail        varchar(50)  = NULL,
@ReferidoTelefono    varchar(100) = NULL,
@ReferidoRFC         varchar(10)  = NULL,
@RelacionReferencia  varchar(40)  = NULL
AS BEGIN
DECLARE
@UltimoCambio        datetime,
@Alta                datetime,
@PedirTonoCond  	  bit
SELECT @UltimoCambio = GETDATE(), @Alta = dbo.fnFechaSinHora(GETDATE())
IF UPPER(ISNULL(@PedirTono,'')) <> 'SI'
SELECT @PedirTonoCond = 0
ELSE
SELECT @PedirTonoCond = 1
IF (ISNULL(@IncluyeCatalogo,0) = 1)
BEGIN
IF EXISTS(SELECT 1 FROM Prospecto WHERE Prospecto = ISNULL(@Prospecto,''))
UPDATE Prospecto SET
Nombre              = @Nombre,
Direccion           = @Direccion,
DireccionNumero     = @DireccionNumero,
DireccionNumeroInt  = @DireccionNumeroInt,
EntreCalles         = @EntreCalles,
Plano               = @Plano,
Observaciones       = @Observaciones,
Delegacion          = @Delegacion,
Colonia             = @Colonia,
Poblacion			  = @Poblacion,
Estado              = @Estado,
Pais                = @Pais,
Zona                = @Zona,
CodigoPostal        = @CodigoPostal,
RFC                 = @RFC,
CURP                = @CURP,
Telefonos           = @Telefonos,
TelefonosLada       = @TelefonosLada,
Fax                 = @Fax,
PedirTono           = @PedirTonoCond,
PaginaWeb			= @PaginaWeb,
Comentarios			= @Comentarios,
Categoria           = @Categoria,
Grupo               = @Grupo,
Familia             = @Familia,
Tipo                = @Tipo,
Estatus             = @Estatus,
UltimoCambio        = @UltimoCambio,
Origen              = @Origen,
Agente              = @Agente,
eMail               = @eMail,
NombreComercial     = @NombreComercial,
ReferidoNombre      = @ReferidoNombre,
ReferidoMail        = @ReferidoMail,
ReferidoTelefono    = @ReferidoTelefono,
ReferidoRFC         = @ReferidoRFC,
RelacionReferencia  = @RelacionReferencia
WHERE Prospecto = @Prospecto
ELSE
BEGIN
IF ISNULL(@Prospecto,'') = ''
EXEC spConsecutivo 'Prospecto', @Sucursal, @Prospecto OUTPUT, @AutoGenerar = 1
IF ISNULL(@Prospecto, '') <> ''
INSERT INTO Prospecto(Prospecto, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Plano, Observaciones,
Delegacion, Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, Telefonos, TelefonosLada, Fax,
PedirTono, PaginaWeb, Comentarios, Categoria, Grupo, Familia, Tipo, Estatus, UltimoCambio, Agente,
eMail, NombreComercial, ReferidoNombre, ReferidoMail, ReferidoTelefono, ReferidoRFC, RelacionReferencia, Origen, Alta)
SELECT @Prospecto, @Nombre, @Direccion, @DireccionNumero, @DireccionNumeroInt, @EntreCalles, @Plano, @Observaciones,
@Delegacion, @Colonia, @Poblacion, @Estado, @Pais, @Zona, @CodigoPostal, @RFC, @CURP, @Telefonos, @TelefonosLada, @Fax,
@PedirTonoCond, @PaginaWeb, @Comentarios, @Categoria, @Grupo, @Familia, @Tipo, @Estatus, @UltimoCambio, @Agente,
@eMail, @NombreComercial, @ReferidoNombre, @ReferidoMail, @ReferidoTelefono, @ReferidoRFC, @RelacionReferencia, @Origen, @Alta
END
END
IF (ISNULL(@IncluyeMov,0) = 1)
BEGIN
IF @ID IS NOT NULL AND EXISTS(SELECT 1 FROM Campana WHERE ID = @ID AND Estatus IN ('SINAFECTAR', 'PENDIENTE'))
BEGIN
IF NOT EXISTS(SELECT 1 FROM CampanaD WHERE ID = @ID AND ContactoTipo = 'Prospecto' AND Contacto = @Prospecto)
INSERT INTO CampanaD(ID, Contacto, ContactoTipo, Usuario, Sucursal, SucursalOrigen)
SELECT @ID, @Prospecto, 'Prospecto', @Usuario, @Sucursal, @Sucursal
END
END
SELECT 'Se agregó el Prospecto'
RETURN
END

