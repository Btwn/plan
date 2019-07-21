SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSDesAsociarMonedero
@ID                 varchar(36),
@Monedero           varchar(20),
@Usuario            varchar(10),
@Estacion           int

AS
BEGIN
DECLARE
@Cliente				varchar(10),
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
@ImagenNombreAnexo		varchar(255),
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
@Puntos					float,
@Importe				float,
@Empresa				varchar(5),
@Ok						int,
@OkRef					varchar(255),
@OKRefLDI				varchar(500),
@MonederoLDI			bit,
@FechaNacimiento		datetime,
@EstadoCivil	        varchar(20),
@Conyuge				varchar(100),
@Sexo	                varchar(20),
@Fuma	                bit,
@Profesion				varchar(100),
@Puesto					varchar(100),
@NumeroHijos	        int,
@Religion				varchar(50)
SELECT @Empresa = Empresa, @Sucursal = Sucursal
FROM POSL WHERE ID = @ID
SELECT @Cliente = DefCliente
FROM Usuario
WHERE Usuario = @Usuario
SELECT @ListaPreciosSucursal = ListaPreciosEsp, @ZonaImpuestoSucursal = ZonaImpuesto
FROM Sucursal
WHERE Sucursal = @Sucursal
SELECT @MonederoLDI = ISNULL(MonederoLDI,0)
FROM POSCfg
WHERE Empresa = @Empresa
IF @Cliente IS NOT NULL
BEGIN
SELECT
@Proyecto = ct.Proyecto,
@Agente = ct.Agente,
@FormaEnvio = ct.FormaEnvio,
@Condicion = ct.Condicion,
@Descuento = ct.Descuento,
@DescuentoGlobal = d.Porcentaje,
@ListaPreciosEsp = ISNULL(ISNULL(ISNULL(NULLIF(u.DefListaPreciosEsp,''), NULLIF(ct.ListaPreciosEsp,'')), NULLIF(@ListaPreciosSucursal,'')),'(Precio Lista)'),
@ZonaImpuesto = ISNULL(ISNULL(NULLIF(u.DefZonaImpuesto,''),NULLIF(ct.ZonaImpuesto,'')),NULLIF(@ZonaImpuestoSucursal,'')),
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
FROM Cte ct
LEFT OUTER JOIN Descuento d ON ct.Descuento = d.Descuento
JOIN Usuario u ON 1=1
WHERE ct.Cliente = @Cliente
AND u.Usuario = @Usuario
IF @Cliente IS NOT NULL
UPDATE POSL SET Cliente = @Cliente,
Proyecto = @Proyecto,
FormaEnvio = @FormaEnvio,
Condicion = @Condicion,
Descuento = @Descuento,
DescuentoGlobal = @DescuentoGlobal,
ListaPreciosEsp = @ListaPreciosEsp,
ZonaImpuesto = @ZonaImpuesto,
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
RFC	= @RFC,
CURP = @CURP,
Monedero = @Monedero,
FechaNacimiento = @FechaNacimiento,
EstadoCivil	= @EstadoCivil,
Conyuge	= @Conyuge,
Sexo = @Sexo,
Fuma = @Fuma,
Profesion = @Profesion ,
Puesto = @Puesto,
NumeroHijos	= @NumeroHijos,
Religion = @Religion
WHERE ID = @ID
END
ELSE
UPDATE POSL SET Monedero = @Monedero WHERE ID = @ID
EXEC spPOSOfertaAplicar	@ID
EXEC spPOSOfertaPuntosInsertarTemp @ID, NULL, 0, @Estacion
RETURN
END

