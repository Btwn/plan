SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSAsociarTarjetaRegalo
@ID             varchar(36),
@Monedero		varchar(20),
@Usuario        varchar(10),
@Estacion       int,
@Importe		money

AS
BEGIN
DECLARE
@Cliente					varchar(10),
@Proyecto					varchar(50),
@Almacen					varchar(10),
@Agente						varchar(10),
@Cajero						varchar(10),
@FormaEnvio					varchar(50),
@Condicion					varchar(50),
@Vencimiento				varchar(50),
@Descuento					varchar(50),
@DescuentoGlobal			varchar(50),
@ListaPreciosEsp			varchar(20),
@ZonaImpuesto				varchar(50),
@ZonaImpuestoSucursal		varchar(50),
@ImagenNombreAnexo			varchar(255),
@Sucursal					int,
@Nombre						varchar(100),
@Direccion					varchar(100),
@DireccionNumero			varchar(20),
@DireccionNumeroInt			varchar(20),
@EntreCalles				varchar(100),
@Delegacion					varchar(100),
@Colonia					varchar(100),
@Poblacion					varchar(100),
@Estado						varchar(50),
@Pais						varchar(50),
@Zona						varchar(50),
@CodigoPostal				varchar(15),
@RFC						varchar(15),
@CURP						varchar(50),
@ListaPreciosSucursal		varchar(20),
@ListaPreciosUsuario		varchar(20),
@Puntos						float,
@Empresa					varchar(5),
@Ok							int,
@OkRef						varchar(255),
@OKRefLDI					varchar(500),
@MonederoLDI				bit,
@FechaNacimiento			datetime,
@EstadoCivil				varchar(20),
@Conyuge					varchar(100),
@Sexo						varchar(20),
@Fuma						bit,
@Profesion					varchar(100),
@Puesto						varchar(100),
@NumeroHijos				int,
@Religion					varchar(50),
@ValorTarjeta				money
BEGIN TRANSACTION
SELECT @ValorTarjeta = Precio
FROM ValeSerie
WHERE Serie = @Monedero
IF @Importe < = @ValorTarjeta AND @Monedero IS NOT NULL
BEGIN
IF EXISTS(SELECT * FROM POSValeSerie WHERE Serie = @Monedero)
SELECT @Cliente = Cliente FROM POSValeSerie WHERE Serie = @Monedero
SELECT @Empresa = Empresa, @Sucursal = Sucursal
FROM POSL
WHERE ID = @ID
SELECT @ListaPreciosSucursal = ListaPreciosEsp, @ZonaImpuestoSucursal = ZonaImpuesto
FROM Sucursal
WHERE Sucursal = @Sucursal
UPDATE POSL SET Monedero = @Monedero WHERE ID = @ID
EXEC spPOSAltaMonedero @ID, @Usuario, @Empresa ,@Sucursal, @Cliente, @Monedero, @Ok OUTPUT
END
ELSE
SELECT @OkRef = 'Saldo no corresponde al Valor de la Tarjeta'
IF @Monedero IS NULL
SELECT @OkRef = NULL
ROLLBACK TRANSACTION
SELECT @OkRef
RETURN
END

