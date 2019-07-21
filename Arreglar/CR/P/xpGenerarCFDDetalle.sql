SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpGenerarCFDDetalle
@Estacion				int,
@Modulo					char(5),
@ID						int,
@Layout					varchar(20),
@Version				varchar(10),
@Renglon				float,
@RenglonSub				int,
@Cantidad 				float			OUTPUT,
@Codigo 				varchar(30)		OUTPUT,
@Unidad 				varchar(50)		OUTPUT,
@UnidadClave 			varchar(50)		OUTPUT,
@UnidadFactor 			float			OUTPUT,
@Articulo 				varchar(20)		OUTPUT,
@SubCuenta 				varchar(50)		OUTPUT,
@ArtDescripcion1 		varchar(255)	OUTPUT,
@ArtDescripcion2 		varchar(255)	OUTPUT,
@ArtTipoEmpaque 		varchar(50)		OUTPUT,
@TipoEmpaqueClave 		varchar(20)		OUTPUT,
@TipoEmpaqueTipo 		varchar(20)		OUTPUT,
@Paquetes 				int				OUTPUT,
@CantidadEmpaque		float			OUTPUT,
@EAN13 					varchar(20)		OUTPUT,
@DUN14 					varchar(20)		OUTPUT,
@SKUCliente				varchar(20)		OUTPUT,
@SKUEmpresa				varchar(20)		OUTPUT,
@noIdentificacion 		varchar(50)		OUTPUT,
@AgruparDetalle			bit			= 0,
@Cliente				varchar(20) = NULL,
@OrdenCompra			varchar(50) = NULL OUTPUT,
@CuentaPredial			varchar(100) = NULL OUTPUT
AS BEGIN
RETURN
END

