SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSPoliticaPrecios
@ID					varchar(36),
@Articulo			varchar(20),
@Subcuenta			varchar(50),
@Cantidad			float,
@UnidadVenta		varchar(50),
@Precio				float		OUTPUT,
@Descuento			float		OUTPUT,
@DescuentoMonto		float		OUTPUT

AS
BEGIN
DECLARE
@FechaEmision		DateTime,
@Cliente			varchar(10),
@Agente				varchar(10),
@Moneda				varchar(10),
@TipoCambio			float,
@Condicion			varchar(50),
@Almacen			varchar(10),
@Proyecto			varchar(50),
@FormaEnvio			varchar(50),
@Mov				varchar(20),
@ServicioTipo		varchar(50),
@ContratoTipo		varchar(50),
@Empresa			varchar(50),
@Region				varchar(50),
@Sucursal			int,
@ListaPreciosEsp	varchar(20),
@Politica			varchar(MAX)
SELECT
@FechaEmision = v.FechaEmision,
@Cliente = v.Cliente,
@Agente = v.Agente,
@Moneda = v.Moneda,
@TipoCambio = v.TipoCambio,
@Condicion = v.Condicion,
@Almacen = v.Almacen,
@Proyecto = v.Proyecto,
@FormaEnvio = v.FormaEnvio,
@Mov = v.Mov,
@Empresa = v.Empresa,
@Region = s.Region,
@Sucursal = v.Sucursal,
@ListaPreciosEsp = v.ListaPreciosEsp
FROM POSL v
INNER JOIN Sucursal s ON v.Sucursal = s.Sucursal
WHERE v.ID = @ID
EXEC spPOSPoliticaPreciosCalc @FechaEmision, @Agente, @Moneda, @TipoCambio, @Condicion, @Almacen, @Proyecto, @FormaEnvio, @Mov, @ServicioTipo,
@ContratoTipo, @Empresa, @Region, @Sucursal, @ListaPreciosEsp, @Cliente, @Articulo, @Subcuenta, @Cantidad, @UnidadVenta,
@Precio OUTPUT, @Descuento OUTPUT, @Politica OUTPUT, @DescuentoMonto OUTPUT
END

