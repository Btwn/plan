SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertaCliente2
@Empresa		varchar(5),
@ID				varchar(50),
@Codigo			varchar(50),
@CtaDinero		varchar(10),
@Cliente		varchar(10),
@Estacion       int,
@Imagen			varchar(255)	OUTPUT,
@Ok				int				OUTPUT,
@OkRef			varchar(255)	OUTPUT,
@EsFactura		bit	= 0

AS
BEGIN
DECLARE
@Proyecto				varchar(50),
@Almacen				varchar(10),
@Agente					varchar(10),
@Cajero					varchar(10),
@FormaEnvio				varchar(50),
@Condicion				varchar(50),
@Vencimiento			varchar(50),
@Descuento				varchar(50),
@DescuentoGlobal		varchar(50),
@ListaPreciosEsp		varchar(20),
@ZonaImpuesto			varchar(50),
@ZonaImpuestoSucursal	varchar(50),
@ZonaImpuestoEnviarA	varchar(50),
@ImagenNombreAnexo		varchar(255),
@Usuario				varchar(10),
@Sucursal				int,
@Nombre					varchar(100),
@Direccion				varchar(100),
@DireccionNumero		varchar(20),
@DireccionNumeroInt		varchar(20),
@EntreCalles			varchar(100),
@Delegacion				varchar(100),
@Colonia				varchar(100),
@Poblacion				varchar(100),
@Estado					varchar(50),
@Pais					varchar(50),
@Zona					varchar(50),
@CodigoPostal			varchar(15),
@RFC					varchar(15),
@CURP					varchar(50),
@ListaPreciosSucursal	varchar(20),
@ListaPreciosUsuario	varchar(20),
@EnviarA				int,
@FechaNacimiento		datetime  ,
@EstadoCivil	        varchar(20),
@Conyuge				varchar(100),
@Sexo	                varchar(20),
@Fuma	                bit,
@Profesion				varchar(100),
@Puesto					varchar(100),
@NumeroHijos	        int,
@Religion				varchar(50),
@Categoria				varchar(50),
@Grupo					varchar(50),
@Familia				varchar(50)
SELECT @Sucursal = p.Sucursal, @Usuario = p.Usuario, @EnviarA = p.EnviarA
FROM POSL p
WHERE p.ID = @ID
SELECT @ListaPreciosSucursal = ListaPreciosEsp, @ZonaImpuestoSucursal = ZonaImpuesto
FROM Sucursal
WHERE Sucursal = @Sucursal
SELECT @ListaPreciosUsuario = DefListaPreciosEsp
FROM Usuario
WHERE Usuario = @Usuario
IF @EnviarA IS NOT NULL AND @Cliente IS NOT NULL
SELECT @ZonaImpuestoEnviarA = ZonaImpuesto
FROM CteEnviarA
WHERE Cliente = @Cliente AND ID = @EnviarA
IF @EnviarA IS NOT NULL AND @Cliente IS  NULL
SELECT @ZonaImpuestoEnviarA = ZonaImpuesto
FROM CB c
JOIN CteEnviarA ct ON ct.Cliente = c.Cuenta
WHERE c.Codigo = @Codigo AND ct.ID = @EnviarA
IF @Cliente IS NOT NULL
SELECT
@Proyecto = ct.Proyecto,
@Agente = ct.Agente,
@FormaEnvio = ct.FormaEnvio,
@Condicion = ct.Condicion,
@Descuento = ct.Descuento,
@DescuentoGlobal = d.Porcentaje,
@ListaPreciosEsp = ISNULL(ISNULL(ISNULL(NULLIF(ct.ListaPreciosEsp,''), NULLIF(@ListaPreciosUsuario,'')), NULLIF(@ListaPreciosSucursal,'')),'(Precio Lista)'),
@ZonaImpuesto = ISNULL(NULLIF(@ZonaImpuestoEnviarA,''),ISNULL(ISNULL(NULLIF(ct.ZonaImpuesto,''),NULLIF(u.DefZonaImpuesto,'')),
NULLIF(@ZonaImpuestoSucursal,''))),
@Nombre	= ct.Nombre,
@Direccion = ct.Direccion,
@DireccionNumero = ct.DireccionNumero,
@DireccionNumeroInt	= ct.DireccionNumeroInt,
@EntreCalles = ct.EntreCalles,
@Delegacion = ct.Delegacion,
@Colonia = ct.Colonia,
@Poblacion = ct.Poblacion,
@Estado = ct.Estado,
@Pais = ct.Pais,
@Zona = ct.Zona,
@CodigoPostal = ct.CodigoPostal,
@RFC = ct.RFC,
@CURP = ct.CURP,
@FechaNacimiento = ct.FechaNacimiento,
@EstadoCivil = ct.EstadoCivil,
@Conyuge = ct.Conyuge,
@Sexo = ct.Sexo ,
@Fuma = ct.Fuma  ,
@Profesion = ct.Profesion,
@Puesto	= ct.Puesto,
@NumeroHijos = ct.NumeroHijos,
@Religion = ct.Religion
FROM Cte ct
LEFT OUTER JOIN Descuento d ON ct.Descuento = d.Descuento
JOIN Usuario u ON 1=1
WHERE ct.Cliente = @Cliente
AND u.Usuario = @Usuario
IF @Cliente IS NULL
SELECT
@Cliente = c.Cuenta,
@Proyecto = ct.Proyecto,
@Almacen = ct.AlmacenDef,
@Agente = ct.Agente,
@FormaEnvio = ct.FormaEnvio,
@Condicion = ct.Condicion,
@Descuento = ct.Descuento,
@DescuentoGlobal = d.Porcentaje,
@ListaPreciosEsp =  ISNULL(ISNULL(ISNULL(NULLIF(@ListaPreciosEsp,''), NULLIF(@ListaPreciosUsuario,'')), NULLIF(@ListaPreciosSucursal,'')),'(Precio Lista)'),
@ZonaImpuesto = ISNULL(NULLIF(@ZonaImpuestoEnviarA,''),ISNULL(ISNULL(NULLIF(ct.ZonaImpuesto,''),NULLIF(u.DefZonaImpuesto,'')),
NULLIF(@ZonaImpuestoSucursal,''))),
@Nombre = ct.Nombre,
@Direccion = ct.Direccion,
@DireccionNumero = ct.DireccionNumero,
@DireccionNumeroInt	= ct.DireccionNumeroInt,
@EntreCalles = ct.EntreCalles,
@Delegacion = ct.Delegacion,
@Colonia = ct.Colonia,
@Poblacion = ct.Poblacion,
@Estado = ct.Estado,
@Pais = ct.Pais,
@Zona = ct.Zona,
@CodigoPostal = ct.CodigoPostal,
@RFC = ct.RFC,
@CURP = ct.CURP,
@FechaNacimiento = ct.FechaNacimiento,
@EstadoCivil = ct.EstadoCivil,
@Conyuge = ct.Conyuge,
@Sexo = ct.Sexo,
@Fuma = ct.Fuma,
@Profesion = ct.Profesion,
@Puesto = ct.Puesto,
@NumeroHijos = ct.NumeroHijos,
@Religion = ct.Religion
FROM CB c
INNER JOIN Cte ct ON ct.Cliente = c.Cuenta
LEFT OUTER JOIN Descuento d ON ct.Descuento = d.Descuento
JOIN Usuario u ON 1=1
WHERE c.Codigo = @Codigo
AND u.Usuario = @Usuario
IF @Cliente IS NULL
SELECT @Ok = 26060, @OkRef = @Codigo
IF @Ok IS NULL
EXEC xpPOSVentaInsertaClienteVerificar @Empresa, @ID, @Codigo, @Cliente, @CtaDinero, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
IF @EsFactura = 1
UPDATE POSL SET Cliente = @Cliente,
Nombre = @Nombre,
Direccion = @Direccion,
DireccionNumero	= @DireccionNumero,
DireccionNumeroInt = @DireccionNumeroInt,
EntreCalles	= @EntreCalles,
Delegacion = @Delegacion,
Colonia = @Colonia,
Poblacion = @Poblacion,
Estado = @Estado,
Pais = @Pais,
Zona = @Zona,
CodigoPostal = @CodigoPostal,
RFC = @RFC,
CURP = @CURP,
FechaNacimiento = @FechaNacimiento,
EstadoCivil	= @EstadoCivil,
Conyuge = @Conyuge,
Sexo = @Sexo,
Fuma = @Fuma,
Profesion = @Profesion,
Puesto = @Puesto,
NumeroHijos	= @NumeroHijos,
Religion = @Religion
WHERE ID = @ID
ELSE
UPDATE POSL SET Cliente = @Cliente,
Proyecto = @Proyecto,
Agente = ISNULL(NULLIF(@Agente,''),Agente),
FormaEnvio = @FormaEnvio,
Condicion = ISNULL(NULLIF(@Condicion,''),Condicion),
Descuento = ISNULL(NULLIF(@Descuento,''),Descuento),
DescuentoGlobal = ISNULL(NULLIF(@DescuentoGlobal,''),DescuentoGlobal),
ListaPreciosEsp = @ListaPreciosEsp,
ZonaImpuesto = NULLIF(@ZonaImpuesto,''),
Nombre = @Nombre,
Direccion = @Direccion,
DireccionNumero	= @DireccionNumero,
DireccionNumeroInt = @DireccionNumeroInt,
EntreCalles	= @EntreCalles,
Delegacion = @Delegacion,
Colonia = @Colonia,
Poblacion = @Poblacion,
Estado = @Estado,
Pais = @Pais,
Zona = @Zona,
CodigoPostal = @CodigoPostal,
RFC = @RFC,
CURP = @CURP,
FechaNacimiento = @FechaNacimiento,
EstadoCivil	= @EstadoCivil,
Conyuge = @Conyuge,
Sexo = @Sexo,
Fuma = @Fuma,
Profesion = @Profesion,
Puesto = @Puesto,
NumeroHijos	= @NumeroHijos,
Religion = @Religion
WHERE ID = @ID
SELECT @ImagenNombreAnexo = pc.ImagenNombreAnexo
FROM POSCfg pc
WHERE pc.Empresa = @Empresa
SELECT @Imagen = MAX(ac.Direccion)
FROM AnexoCta ac
WHERE ac.Nombre = @ImagenNombreAnexo
AND Rama = 'CXC'
AND ac.Cuenta = @Cliente
AND ac.Tipo = 'Imagen'
END
IF @Ok IS NULL AND @EsFactura = 0
EXEC spPOSArtPrecioRecalcular @ID, @Estacion
END

