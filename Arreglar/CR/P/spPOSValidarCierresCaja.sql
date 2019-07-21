SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSValidarCierresCaja
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
@EsConcentradora            bit,
@Fecha                      datetime,
@ValidarCajasCerradas		bit
SELECT @ValidarCajasCerradas = ISNULL(ValidarCajasCerradas,0)
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @Fecha = dbo.fnFechaSinHora(Fecha)
FROM POSFechaCierre
WHERE Sucursal = @Sucursal
SELECT @EsConcentradora = ISNULL(EsConcentradora,0)
FROM CtaDinero
WHERE CtaDinero = @Caja
IF @EsConcentradora = 1 AND @ValidarCajasCerradas = 1
BEGIN
IF EXISTS(SELECT * FROM POSEstatusCajasCierre WHERE Sucursal = @Sucursal AND dbo.fnFechaSinHora(Fecha) = @Fecha AND Caja <> @Caja )
SELECT @Ok = 30448, @OkRef = '('+(SELECT TOP 1 Caja FROM POSEstatusCajasCierre WHERE Sucursal = @Sucursal AND dbo.fnFechaSinHora(Fecha) = @Fecha AND Caja <> @Caja)+')'
END
IF @Ok IS NULL AND @EsConcentradora = 1
BEGIN
DELETE POSFechaCierre WHERE Sucursal = @Sucursal
IF @@ERROR <> 0
SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
DELETE POSEstatusCajasCierre WHERE Sucursal = @Sucursal AND Caja  = @Caja
IF @@ERROR <> 0
SET @Ok = 1
END
RETURN
END

