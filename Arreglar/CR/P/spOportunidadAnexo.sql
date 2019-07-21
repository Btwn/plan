SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spOportunidadAnexo
@EstacionTrabajo			int,
@PlantillaeMail				varchar(20),
@ID							int,
@Empresa					varchar(5),
@Sucursal					int,
@UEN						int,
@Usuario					varchar(10),
@Mov						varchar(50),
@MovID						varchar(50),
@Movimiento					varchar(50),
@Estatus					varchar(15),
@Situacion					varchar(50),
@Proyecto					varchar(50),
@ContactoTipo				varchar(20),
@Contacto					varchar(10),
@Importe					float,
@EmpresaNombre				varchar(100),
@SucursalNombre				varchar(100),
@UENNombre					varchar(100),
@UsuarioNombre				varchar(100),
@ContactoNombre				varchar(100),
@FechaEmision				datetime,
@Ok							int = NULL OUTPUT,
@OkRef						varchar(255) = NULL OUTPUT,
@Anexos						varchar(max) = NULL OUTPUT

AS BEGIN
DECLARE @RID					int,
@RIDAnt				int,
@Tipo					varchar(50),
@Ruta					varchar(255),
@Nombre				varchar(255),
@Existe				bit,
@Archivo				varchar(500),
@eDoc					varchar(max),
@ManejadorObjeto		int,
@IDArchivo			int,
@IDR					int,
@IDRAnt				int
SELECT @Anexos = ''
SELECT @RIDAnt = 0
WHILE(1=1)
BEGIN
SELECT @RID = MIN(RID)
FROM OportunidadAnexo
WHERE Plantilla = @PlantillaeMail
AND RID > @RIDAnt
SELECT @Ok = NULL
IF @RID IS NULL BREAK
SELECT @RIDAnt = @RID
SELECT @Tipo = Tipo, @Ruta = dbo.fnDirectorioEliminarDiagonalFinal(Ruta), @Nombre = Nombre FROM OportunidadAnexo WHERE Plantilla = @PlantillaeMail AND RID = @RID
EXEC spOportunidadParsearMensaje @EstacionTrabajo, @PlantillaeMail, @ID, @Empresa, @Sucursal, @UEN, @Usuario, @Movimiento, @Estatus, @Situacion, @Proyecto, @ContactoTipo, @Contacto, @Importe, @EmpresaNombre, @SucursalNombre, @UENNombre, @UsuarioNombre, @ContactoNombre, @FechaEmision, NULL, NULL, @Ok OUTPUT, @OkRef OUTPUT, @Ruta OUTPUT, @Nombre OUTPUT
IF @Tipo = 'Especifico'
BEGIN
SELECT @Archivo = ISNULL(@Ruta, '') + '\' + ISNULL(@Nombre, '')
EXEC spVerificarArchivo @Archivo, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Existe = 0 SELECT @Ok = 1
END
ELSE IF @Tipo = 'Anexo'
BEGIN
SELECT @Archivo = ''
EXEC spAnexoMovAdjuntarLista 'OPORT', @ID, @Nombre, @Archivo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL AND RTRIM(ISNULL(@Archivo, '')) <> '' 
SELECT @Anexos = @Anexos + @Archivo + ';'
END
IF RIGHT(@Anexos, 1) = ';'
SELECT @Anexos = SUBSTRING(@Anexos, 1, LEN(@Anexos) - 1)
END

