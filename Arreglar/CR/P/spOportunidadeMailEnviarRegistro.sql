SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spOportunidadeMailEnviarRegistro
@ID					int,
@Usuario			varchar(10),
@EstacionTrabajo	int,
@RID				int,
@PlantillaeMail		varchar(20),
@Ok					int			 = NULL OUTPUT,
@OkRef				varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE @Cliente					varchar(10),
@eMail					varchar(100),
@Empresa					varchar(5),
@Sucursal					int,
@UEN						int,
@Mov						varchar(20),
@MovID					varchar(20),
@Estatus					varchar(15),
@Situacion				varchar(50),
@Proyecto					varchar(50),
@ContactoTipo				varchar(20),
@Contacto					varchar(10),
@Importe					float,
@FechaEmision				datetime,
@Asunto					varchar(255),
@Mensaje					varchar(max),
@Ruta						varchar(max),
@Anexo					varchar(max),
@EmpresaNombre			varchar(100),
@SucursalNombre			varchar(100),
@UENNombre				varchar(100),
@UsuarioNombre			varchar(100),
@ContactoNombre			varchar(100),
@Vencimiento				datetime,
@FechaRegistro			datetime,
@Movimiento				varchar(50),
@Anexos					varchar(8000)
EXEC spMovInfo @ID, 'OPORT', @Empresa = @Empresa OUTPUT, @Sucursal = @Sucursal OUTPUT, @UEN = @UEN OUTPUT, @Mov = @Mov OUTPUT, @MovID = @MovID OUTPUT, @Estatus = @Estatus OUTPUT, @Situacion = @Situacion OUTPUT, @Proyecto = @Proyecto OUTPUT, @CtoTipo = @ContactoTipo OUTPUT, @Contacto = @Contacto OUTPUT, @Importe = @Importe OUTPUT, @FechaEmision = @FechaEmision OUTPUT, @Vencimiento = @Vencimiento OUTPUT, @FechaRegistro = @FechaRegistro OUTPUT
SELECT @Asunto = Asunto,
@Mensaje = Mensaje
FROM OportunidadPlantillaeMail
JOIN OportunidadPlantillaeMailMensaje ON OportunidadPlantillaeMail.ID = OportunidadPlantillaeMailMensaje.ID
WHERE OportunidadPlantillaeMail.Plantilla = @PlantillaeMail
SELECT @Contacto =  OportunidadeMailEnviar.Cliente,
@ContactoTipo = OportunidadeMailEnviar.ContactoTipo,
@eMail = CteCto.eMail
FROM OportunidadeMailEnviar
JOIN Cte ON OportunidadeMailEnviar.Cliente = Cte.Cliente
JOIN CteCto ON Cte.Cliente = CteCto.Cliente AND CteCto.ID = OportunidadeMailEnviar.ID AND CteCto.Cliente = OportunidadeMailEnviar.Cliente
WHERE RID = @RID
SET @Empresa      = ISNULL(@Empresa,'')
SET @Sucursal     = ISNULL(@Sucursal,-1)
SET @UEN          = ISNULL(@UEN,-1)
SET @Usuario      = ISNULL(@Usuario,'')
SET @Mov          = LTRIM(RTRIM(ISNULL(@Mov,'')))
SET @MovID        = LTRIM(RTRIM(ISNULL(@MovID,'')))
SET @Estatus      = ISNULL(@Estatus,'')
SET @Situacion    = ISNULL(@Situacion,'')
SET @Proyecto     = ISNULL(@Proyecto,'')
SET @ContactoTipo = ISNULL(@ContactoTipo,'')
SET @Contacto     = ISNULL(@Contacto,'')
SET @Importe      = ISNULL(@Importe,0.0)
SET @Vencimiento  = ISNULL(@Vencimiento,@FechaEmision)
IF @FechaRegistro IS NULL
SELECT @FechaRegistro = GETDATE()
SET @Movimiento = @Mov + ' ' + @MovID
SELECT @EmpresaNombre  = ISNULL(Nombre,'') FROM Empresa WHERE Empresa = @Empresa
SELECT @SucursalNombre = ISNULL(Nombre,'') FROM Sucursal WHERE Sucursal = @Sucursal
SELECT @UENNombre      = ISNULL(Nombre,'') FROM UEN WHERE UEN = @UEN
SELECT @UsuarioNombre  = ISNULL(Nombre,'') FROM Usuario WHERE Usuario = @Usuario
SELECT @ContactoNombre = ISNULL(Nombre,'') FROM Cte WHERE Cliente = @Contacto
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
EXEC spOportunidadParsearMensaje @EstacionTrabajo, @PlantillaeMail, @ID, @Empresa, @Sucursal, @UEN, @Usuario, @Movimiento, @Estatus, @Situacion, @Proyecto, @ContactoTipo, @Contacto, @Importe, @EmpresaNombre, @SucursalNombre, @UENNombre, @UsuarioNombre, @ContactoNombre, @FechaEmision, @Asunto OUTPUT, @Mensaje OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
EXEC spOportunidadAnexo @EstacionTrabajo, @PlantillaeMail, @ID, @Empresa, @Sucursal, @UEN, @Usuario, @Mov, @MovID, @Movimiento, @Estatus, @Situacion, @Proyecto, @ContactoTipo, @Contacto, @Importe, @EmpresaNombre, @SucursalNombre, @UENNombre, @UsuarioNombre, @ContactoNombre, @FechaEmision, @Ok OUTPUT, @OkRef OUTPUT, @Anexos OUTPUT
IF @Ok IS NULL
EXEC spOportunidadInsertarIS @Empresa, @Usuario, @ContactoTipo, @Contacto, @ID, @FechaRegistro, @eMail, @Asunto, @Mensaje, @Anexos, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

