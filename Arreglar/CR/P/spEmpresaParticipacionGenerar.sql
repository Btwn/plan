SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEmpresaParticipacionGenerar
@Empresa	char(5),
@Sucursal	int,
@Usuario	char(10),
@FechaTrabajo	datetime

AS BEGIN
DECLARE
@ID			int,
@Renglon		float,
@CuentaDebe		varchar(20),
@CuentaHaber	varchar(20),
@ContMoneda		char(10),
@Importe		money,
@TipoCambio		float,
@MovCont		char(20)
SELECT @MovCont = ContDiario FROM EmpresaCfgMov WHERE Empresa = @Empresa
SELECT @ContMoneda = mon.Moneda, @TipoCambio = mon.TipoCambio
FROM EmpresaCfg cfg, Mon
WHERE cfg.Empresa = @Empresa AND mon.Moneda = cfg.ContMoneda
EXEC spExtraerFecha @FechaTrabajo OUTPUT
INSERT Cont (Sucursal,  Empresa,  Mov,      FechaEmision,  FechaContable, Moneda,      TipoCambio,   Usuario,  Estatus)
VALUES (@Sucursal, @Empresa, @MovCont, @FechaTrabajo, @FechaTrabajo, @ContMoneda, @TipoCambio, @Usuario, 'CONFIRMAR')
SELECT @ID = SCOPE_IDENTITY()
SELECT @Renglon = 0
DECLARE crParticipacion CURSOR FOR
SELECT p.CuentaDebe, p.CuentaHaber, p.Resultado*(p.Porcentaje/100.0)*m.TipoCambio/@TipoCambio
FROM EmpresaParticipacion p, Mon m
WHERE p.Empresa = @Empresa AND p.Moneda = m.Moneda
OPEN crParticipacion
FETCH NEXT FROM crParticipacion INTO @CuentaDebe, @CuentaHaber, @Importe
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Renglon = @Renglon + 2048.0
INSERT ContD (ID, Renglon, Cuenta, Debe) VALUES (@ID, @Renglon, @CuentaDebe, @Importe)
SELECT @Renglon = @Renglon + 2048.0
INSERT ContD (ID, Renglon, Cuenta, Haber) VALUES (@ID, @Renglon, @CuentaHaber, @Importe)
END
FETCH NEXT FROM crParticipacion INTO @CuentaDebe, @CuentaHaber, @Importe
END 
CLOSE crParticipacion
DEALLOCATE crParticipacion
SELECT 'Se Generó 1 Póliza (por Confirmar)'
RETURN
END

