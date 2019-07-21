SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSCambiarFechaEmision
@ID				varchar(50),
@Empresa		varchar(5),
@Sucursal		int,
@Host			varchar(10),
@Caja			varchar(10),
@Ok				int OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@EsConcentradora		bit,
@Fecha                  datetime
SELECT @EsConcentradora = ISNULL(EsConcentradora,0)
FROM CtaDinero
WHERE CtaDinero = @Caja
IF @Ok IS NULL AND @EsConcentradora = 1
BEGIN
INSERT POSFechaCierre(
Sucursal,  Fecha)
SELECT
@Sucursal, dbo.fnPOSFechaCierre2(@Empresa,@Sucursal,@Fecha,@Caja)
IF @@ERROR <> 0
SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
IF NOT EXISTS (SELECT * FROM POSEstatusCajasCierre WHERE Sucursal = @Sucursal AND Caja = @Caja
AND Fecha = dbo.fnPOSFechaCierre2(@Empresa,@Sucursal,@Fecha,@Caja))
INSERT POSEstatusCajasCierre(
Sucursal,  Caja,  Fecha)
SELECT
@Sucursal, @Caja, dbo.fnPOSFechaCierre2(@Empresa,@Sucursal,@Fecha,@Caja)
IF @@ERROR <> 0
SET @Ok = 1
END
RETURN
END

