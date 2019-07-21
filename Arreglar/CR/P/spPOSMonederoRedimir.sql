SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSMonederoRedimir
@Empresa		varchar(5),
@Monedero		varchar(20),
@Importe		money,
@Usuario		varchar(10),
@Estacion		int,
@Sucursal		int,
@ID				varchar(36)
AS BEGIN
DECLARE	@Ok				int,
@OkRef			varchar(255),
@Mensaje		varchar(255),
@Moneda			varchar(10),
@TipoCambio		float,
@Saldo			money,
@Referencia		varchar(20)
SET @Ok			= NULL
SET @OkRef		= NULL
SET @Mensaje	= NULL
SET @Referencia = NULL
SET @Saldo		= 0.00
SELECT @Moneda		= Moneda,
@TipoCambio	= TipoCambio
FROM POSL
WHERE ID = @ID
DELETE FROM POSSerieTarjetaMovMTemp WHERE Estacion = @Estacion
DELETE FROM POSTarjetaMonedero WHERE Estacion = @Estacion
DELETE FROM POSSaldoPMon WHERE Estacion = @Estacion
EXEC spPOSWSSolTarjetaMonedero @Empresa, @Monedero ,@Usuario, @Estacion, @Sucursal, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
IF NOT EXISTS (SELECT * FROM POSTarjetaMonedero WHERE Empresa = @Empresa AND Serie = @Monedero)
SELECT @Ok = 1, @OkRef = 'LA TARJETA NO EXISTE'
END
IF @Ok IS NULL
BEGIN
EXEC spPOSWSSolicitudMonederoInfo @Empresa, @Monedero ,@Usuario, @Estacion, @Sucursal, @Ok OUTPUT, @OkRef OUTPUT
SELECT @Saldo = ISNULL(Saldo,0.00) FROM POSSaldoPMon WHERE Empresa = @Empresa AND Cuenta = @Monedero AND Moneda = @Moneda
IF ISNULL(@Saldo,0.00) >= @Importe
EXEC spPOSWSSolMonederoRedimir @Empresa, @Monedero, @Importe, @Usuario, @Estacion, @Sucursal, @ID, @Ok OUTPUT, @OkRef OUTPUT
ELSE
SELECT @Ok = 1, @OkRef = 'SALDO INSUFICIENTE'
END
IF @Ok IS NULL
BEGIN
SELECT @Referencia = NULLIF(Referencia,'')
FROM POSSerieTarjetaMovMTemp
WHERE Estacion = @Estacion
IF @Referencia <> 'APROBADA'
SELECT @Ok = 1, @OkRef = 'LA OPERACION FUE RECHAZADA'
END
IF @Ok IS NOT NULL
SET @Mensaje = UPPER(NULLIF(@OkRef,''))
SELECT @Mensaje
END

