SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFiscalSugerirCorte
@Empresa		char(5),
@Sucursal		int,
@Usuario		char(10),
@FechaD		datetime,
@FechaA		datetime

AS BEGIN
DECLARE
@DeclaracionMov	varchar(20),
@ComplementariaMov	varchar(20),
@Ok			int,
@OkRef		varchar(255),
@Conteo		int,
@Desde		datetime,
@Hasta		datetime
SELECT @Ok = NULL, @OkRef = NULL, @Conteo = 0
BEGIN TRANSACTION
SELECT @DeclaracionMov = FiscalDeclaracion,
@ComplementariaMov = FiscalComplementaria
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
IF EXISTS (SELECT * FROM Fiscal WHERE Mov IN (@DeclaracionMov, @ComplementariaMov) AND Estatus = 'CONFIRMAR')
SELECT @OK = 60440
IF EXISTS (SELECT * FROM Fiscal WHERE Mov = @DeclaracionMov AND Estatus = 'CONCLUIDO' AND FechaEmision BETWEEN @FechaD AND @FechaA )
SELECT @Ok = 60450
IF @OK IS NULL
BEGIN
SELECT @Desde = 0, @Hasta = DATEADD(day, -1, @FechaD)
EXEC spFiscalSugerirCorteHasta @Empresa, @Sucursal, @Usuario, @Desde, @Hasta, @ComplementariaMov, @Conteo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
SELECT @Desde = @FechaD, @Hasta = @FechaA
EXEC spFiscalSugerirCorteHasta @Empresa, @Sucursal, @Usuario, @Desde, @Hasta, @DeclaracionMov, @Conteo OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IN (NULL, 80300)
BEGIN
COMMIT TRANSACTION
SELECT 'Se Generaron '+LTRIM(CONVERT(char, @Conteo))+ ' Movimientos (por Confirmar)'
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT Descripcion+' '+ISNULL(RTRIM(@OkRef), '') FROM MensajeLista WHERE Mensaje = @Ok
END
RETURN
END

