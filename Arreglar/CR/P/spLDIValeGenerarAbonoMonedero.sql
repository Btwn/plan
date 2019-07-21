SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLDIValeGenerarAbonoMonedero
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
@ServicioInversoInverso    varchar(20),
@Articulo           varchar(20),
@Monedero           varchar(50),
@Importe            float
SELECT @Articulo = Articulo FROM Vale WHERE ID = @ID
SELECT TOP 1 @Monedero = Serie, @Importe = Importe FROM ValeD WHERE ID = @ID
SELECT @Servicio = 'MON ABONO'
SELECT @ServicioInverso = ServicioInverso FROM LDIServicio WHERE Servicio = @Servicio
SELECT @ServicioInversoInverso = ServicioInverso FROM LDIServicio WHERE Servicio = @ServicioInverso
IF @Importe <0.0
SELECT @Servicio = @ServicioInverso
IF @Accion = 'CANCELAR'
SELECT @Servicio = @ServicioInverso
IF @Accion = 'CANCELAR'  AND  @Importe <0.0
SELECT @Servicio = @ServicioInversoInverso
SELECT @Importe = ABS(@Importe)
IF NULLIF(@Servicio,'') IS NOT NULL AND NULLIF(@Monedero,'') IS NOT NULL  AND @Importe > 0.0 AND @Accion <> 'CANCELAR'
EXEC spLDI @Servicio, @ID, @Monedero, @Empresa, @Usuario, @Sucursal, NULL, @Importe, 1, NULL, @Ok OUTPUT, @OkRef OUTPUT, @Modulo, @Cuenta = NULL, @Referencia = NULL, @RIDCobro = NULL, @ADO = 0
RETURN
END

