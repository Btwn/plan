SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spACReinversionAutomatica
@Empresa		char(5),
@Usuario		char(10),
@Modulo		char(5),
@Hoy			datetime,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT,
@Conexion		bit = 0

AS BEGIN
DECLARE
@RamaID             int,
@ID             	int,
@LineaCredito	varchar(20),
@TipoAmortizacion	varchar(20),
@TipoTasa		varchar(20),
@TieneTasaEsp	bit,
@TasaEsp		float,
@Condicion		varchar(50),
@Comisiones		money,
@ComisionesIVA	money,
@ReinversionID	int,
@ReinversionMov	char(20)
SELECT @ReinversionMov = CASE @Modulo WHEN 'CXC' THEN ACReinversionCxc WHEN 'CXP' THEN ACReinversionCxp END FROM EmpresaCfgMov WHERE Empresa = @Empresa
IF @Conexion = 0
BEGIN TRANSACTION
IF @Modulo = 'CXC'
DECLARE crReinversionAutomatica CURSOR FOR
SELECT c.RamaID, c.ID, c.LineaCredito, c.TipoAmortizacion, c.TipoTasa, c.TieneTasaEsp, c.TasaEsp, c.Condicion, c.Comisiones, c.ComisionesIVA
FROM Cxc c
JOIN TipoAmortizacion ta ON ta.TipoAmortizacion = c.TipoAmortizacion AND ta.ReinversionAutomatica = 1
WHERE c.Empresa = @Empresa AND c.Estatus = 'PENDIENTE' AND ISNULL(c.Saldo, 0.0) > 0.0
AND c.Vencimiento = @Hoy
ELSE
IF @Modulo = 'CXP'
DECLARE crReinversionAutomatica CURSOR FOR
SELECT c.RamaID, c.ID, c.LineaCredito, c.TipoAmortizacion, c.TipoTasa, c.TieneTasaEsp, c.TasaEsp, c.Condicion, c.Comisiones, c.ComisionesIVA
FROM Cxp c
JOIN TipoAmortizacion ta ON ta.TipoAmortizacion = c.TipoAmortizacion AND ta.ReinversionAutomatica = 1
WHERE c.Empresa = @Empresa AND c.Estatus = 'PENDIENTE' AND ISNULL(c.Saldo, 0.0) > 0.0
AND c.Vencimiento = @Hoy
OPEN crReinversionAutomatica
FETCH NEXT FROM crReinversionAutomatica INTO @RamaID, @ID, @LineaCredito, @TipoAmortizacion, @TipoTasa, @TieneTasaEsp, @TasaEsp, @Condicion, @Comisiones, @ComisionesIVA
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
EXEC @ReinversionID = spAfectar @Modulo, @ID, 'GENERAR','TODO', @ReinversionMov, @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @ReinversionID IS NOT NULL AND @Ok IS NULL
BEGIN
IF @Modulo = 'CXC'
BEGIN
SELECT @Condicion = Condicion FROM Cxc WHERE ID = @RamaID
UPDATE Cxc SET FechaEmision = @Hoy, LineaCredito = @LineaCredito, TipoAmortizacion = @TipoAmortizacion, TipoTasa = @TipoTasa, TieneTasaEsp = @TieneTasaEsp, TasaEsp = @TasaEsp, Condicion = @Condicion, Comisiones = @Comisiones, ComisionesIVA = @ComisionesIVA WHERE ID = @ReinversionID
END ELSE
IF @Modulo = 'CXP'
BEGIN
SELECT @Condicion = Condicion FROM Cxp WHERE ID = @RamaID
UPDATE Cxp SET FechaEmision = @Hoy, LineaCredito = @LineaCredito, TipoAmortizacion = @TipoAmortizacion, TipoTasa = @TipoTasa, TieneTasaEsp = @TieneTasaEsp, TasaEsp = @TasaEsp, Condicion = @Condicion, Comisiones = @Comisiones, ComisionesIVA = @ComisionesIVA WHERE ID = @ReinversionID
END
EXEC xpACReinversionAutomatica @Modulo, @ReinversionID, @Ok OUTPUT, @OkRef OUTPUT
EXEC spAfectar @Modulo, @ReinversionID, 'AFECTAR','TODO', NULL, @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT, @Conexion = 1
END
END
FETCH NEXT FROM crReinversionAutomatica INTO @RamaID, @ID, @LineaCredito, @TipoAmortizacion, @TipoTasa, @TieneTasaEsp, @TasaEsp, @Condicion, @Comisiones, @ComisionesIVA
END  
CLOSE crReinversionAutomatica
DEALLOCATE crReinversionAutomatica
IF @Conexion = 0
BEGIN
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
END
RETURN
END

