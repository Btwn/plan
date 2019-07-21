SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSArtPrecio
@Articulo					varchar(20),
@Cantidad					float,
@UnidadVenta				varchar(50),
@Precio						float				OUTPUT,
@Descuento					float				OUTPUT,
@VentaID					varchar(36) = NULL,
@SubCuenta					varchar(50) = NULL,
@FechaEmision				Datetime = NULL,
@Agente						varchar(10) = NULL,
@Moneda						varchar(10) = NULL,
@TipoCambio					float = NULL,
@Condicion					varchar(50) = NULL,
@Almacen					varchar(10) = NULL,
@Proyecto					varchar(50) = NULL,
@FormaEnvio					varchar(50) = NULL,
@Mov						varchar(20) = NULL,
@ServicioTipo				varchar(50) = NULL,
@ContratoTipo				varchar(50) = NULL,
@Empresa					varchar(50) = NULL,
@Region						varchar(50) = NULL,
@Sucursal					int = NULL,
@ListaPreciosEsp			varchar(20) = NULL,
@Cliente					varchar(10) = NULL,
@PrecioConDescuento			bit = 0,
@GetListaPreciosCliente		bit = 0

AS
BEGIN
DECLARE
@EnviarA					int,
@Politica					varchar(MAX),
@DescuentoMonto				float,
@DescuentoMontoPorcentaje	float,
@OFER                 		bit
SELECT @OFER = ISNULL(OFER,0)
FROM EmpresaGral
WHERE Empresa = @Empresa
IF @GetListaPreciosCliente = 1
BEGIN
SELECT @Cliente = Cliente
FROM POSL
WHERE ID = @VentaID
SELECT @ListaPreciosEsp = ISNULL(ISNULL(cea.ListaPreciosEsp, c.ListaPreciosEsp), '(Precio Lista)')
FROM Cte c
INNER JOIN CteEnviarA cea ON c.Cliente = cea.Cliente
AND cea.ID = @EnviarA
END
IF @OFER = 0
BEGIN
IF @VentaID IS NOT NULL
EXEC spPOSPoliticaPrecios @VentaID, @Articulo, @Subcuenta, @Cantidad, @UnidadVenta, @Precio OUTPUT, @Descuento OUTPUT, @DescuentoMonto OUTPUT
ELSE
EXEC spPOSPoliticaPreciosCalc @FechaEmision, @Agente, @Moneda, @TipoCambio, @Condicion, @Almacen, @Proyecto, @FormaEnvio, @Mov, @ServicioTipo,
@ContratoTipo, @Empresa, @Region, @Sucursal, @ListaPreciosEsp, @Cliente, @Articulo, @Subcuenta, @Cantidad, @UnidadVenta,
@Precio OUTPUT, @Descuento OUTPUT, @Politica OUTPUT, @DescuentoMonto OUTPUT
END
IF NULLIF(@Precio,0) IS NULL
EXEC spPCGet @Sucursal, @Empresa,@Articulo, @SubCuenta, @UnidadVenta, @Moneda, @TipoCambio, @ListaPreciosEsp, @Precio OUTPUT
IF ISNULL(@DescuentoMonto,0) > 0 AND ISNULL(@Precio,0) > 0
BEGIN
SELECT @DescuentoMontoPorcentaje = (@DescuentoMonto / (@Precio * @Cantidad)) * 100
SELECT @Descuento = ISNULL(@Descuento,0) + ISNULL(@DescuentoMontoPorcentaje,0)
END
IF ISNULL(@PrecioConDescuento, 0) = 1
BEGIN
SELECT @Precio = @Precio - (@Precio * (ISNULL(@Descuento,0)/100))
SELECT @Descuento = NULL
END
END

