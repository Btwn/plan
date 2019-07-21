SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLDIVentaGenerarRecargaTel
@Empresa		char(5),
@Modulo			char(10),
@ID			int,
@Mov			char(20),
@MovID			varchar(20),
@MovTipo		char(20),
@Accion			char(20),
@FechaEmision		datetime,
@Ejercicio		int,
@Periodo		int,
@Usuario		char(10),
@Sucursal		int,
@MovMoneda		char(10),
@MovTipoCambio		float,
@Ok 			int 		OUTPUT,
@OkRef 			varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@Servicio           varchar(20),
@ServicioInverso    varchar(20),
@Articulo           varchar(20),
@Monedero           varchar(50),
@Importe            float,
@Telefono           varchar(10)
SELECT TOP 1 @Articulo = Articulo, @Importe = ISNULL(Precio,0.0), @Telefono = RecargaTelefono  FROM VentaD WHERE ID = @ID
SELECT @Servicio = LDIServicio  FROM Art WHERE Articulo = @Articulo
SELECT @Importe = ABS(@Importe)
IF NULLIF(@Servicio,'') IS NOT NULL  AND @Importe > 0.0
EXEC spLDI @Servicio, @ID, @Monedero, @Empresa, @Usuario, @Sucursal, NULL, @Importe, 1, @Telefono, @Ok OUTPUT, @OkRef OUTPUT, @Modulo, @Cuenta = NULL, @Referencia = NULL, @RIDCobro = NULL, @ADO = 0
RETURN
END

