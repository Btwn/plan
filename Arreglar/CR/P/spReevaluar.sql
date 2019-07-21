SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spReevaluar
@Estacion		int,
@Sucursal		int,
@Empresa		char(5),
@Usuario		char(10),
@Modulo		char(5),
@FechaEmision	datetime

AS BEGIN
DECLARE
@CfgMov			char(20),
@CfgMovCredito		char(20),
@Conteo			int,
@ID				int,
@Renglon			float,
@FechaRegistro		datetime,
@CtaDinero			char(10),
@Contacto			char(10),
@UltContacto		char(10),
@Saldo			money,
@SaldoMN			money,
@AjusteMN			money,
@AjusteAnteriorMN		money,
@Importe			money,
@SumaImporte		money,
@ContMoneda			char(10),
@UltMoneda			char(10),
@Moneda			char(10),
@TipoCambio			float,
@MovTipoCambio		float,
@Mov			char(20),
@MovID			varchar(20),
@MovGenerar			char(20),
@MovIDGenerar		varchar(20),
@IDGenerar			int,
@Ok				int,
@OkRef			varchar(255),
@OkDesc           		varchar(255),
@OkTipo           		varchar(50)
EXEC spExtraerFecha @FechaEmision OUTPUT
SELECT @FechaRegistro = GETDATE()
SELECT @ID = NULL, @Conteo = 0, @Ok = NULL, @OkRef = NULL, @UltContacto = NULL, @UltMoneda = NULL
SELECT @ContMoneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @CfgMov = CASE @Modulo
WHEN 'CXC' THEN NULLIF(RTRIM(CxcReevaluacion), '')
WHEN 'CXP' THEN NULLIF(RTRIM(CxpReevaluacion), '')
WHEN 'DIN' THEN NULLIF(RTRIM(DineroReevaluacion), '')
END,
@CfgMovCredito = CASE @Modulo
WHEN 'CXC' THEN NULLIF(RTRIM(CxcReevaluacionCredito), '')
WHEN 'CXP' THEN NULLIF(RTRIM(CxpReevaluacionCredito), '')
END
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
IF @Modulo = 'DIN'
BEGIN
DECLARE crCtaDinero CURSOR FOR
SELECT m.Moneda, m.TipoCambio, c.CtaDinero
FROM CtaDinero c, Reevaluacion m
WHERE c.Tipo <> 'Caja'
AND m.Moneda = c.Moneda AND m.Estacion = @Estacion AND ISNULL(m.TipoCambio, 0) > 0 AND m.Moneda <> @ContMoneda
OPEN crCtaDinero
FETCH NEXT FROM crCtaDinero INTO @Moneda, @TipoCambio, @CtaDinero
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Saldo = ISNULL(SUM(Cargo), 0)-ISNULL(SUM(Abono), 0),
@SaldoMN = ISNULL(SUM(Cargo*TipoCambio), 0)-ISNULL(SUM(Abono*TipoCambio), 0)
FROM Auxiliar
WHERE Empresa = @Empresa AND Rama = @Modulo AND Cuenta = @CtaDinero AND Fecha <= @FechaEmision
SELECT @AjusteMN = (@Saldo*@TipoCambio)-@SaldoMN
SELECT @AjusteAnteriorMN = SUM(Importe)
FROM Dinero d, MovTipo mt
WHERE mt.Modulo = @Modulo AND mt.Mov = d.Mov AND mt.Clave = 'DIN.RE'
AND d.Empresa = @Empresa AND d.CtaDinero = @CtaDinero AND d.Moneda = @ContMoneda AND d.FechaEmision <= @FechaEmision
AND d.Estatus = 'CONCLUIDO'
SELECT @Importe = ISNULL(@AjusteMN, 0) - ISNULL(@AjusteAnteriorMN, 0)
IF @Importe <> 0.0
BEGIN
INSERT Dinero (OrigenTipo, Sucursal,  Empresa,  Mov,     FechaEmision,  Moneda,      TipoCambio,  Usuario,   Estatus,     UltimoCambio,   CtaDinero,  Importe)
VALUES ('AUTO/RE',  @Sucursal, @Empresa, @CfgMov, @FechaEmision, @ContMoneda, 1.0,         @Usuario, 'SINAFECTAR', @FechaRegistro, @CtaDinero, @Importe)
SELECT @ID = SCOPE_IDENTITY()
SELECT @Conteo = @Conteo + 1
EXEC spDinero @ID, @Modulo, 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 0, 0, @Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
END
FETCH NEXT FROM crCtaDinero INTO @Moneda, @TipoCambio, @CtaDinero
END
CLOSE crCtaDinero
DEALLOCATE crCtaDinero
END ELSE
BEGIN
IF @Modulo = 'CXC'
DECLARE crReevaluacion CURSOR FOR
SELECT m.Moneda, m.TipoCambio, c.TipoCambio, c.Cliente, c.Mov, c.MovID, ISNULL(c.Saldo*ISNULL(mt.Factor, 1), 0)
FROM Cxc c, Reevaluacion m, MovTipo mt
WHERE c.Empresa = @Empresa
AND m.Moneda = c.Moneda AND m.TipoCambio <> c.TipoCambio AND m.Estacion = @Estacion AND ISNULL(m.TipoCambio, 0) > 0 AND m.Moneda <> @ContMoneda
AND c.Estatus = 'PENDIENTE'
AND mt.Modulo = @Modulo AND mt.Mov = c.Mov AND mt.Clave IN ('CXC.F', 'CXC.FA', 'CXC.FAC', 'CXC.CA', 'CXC.CAD', 'CXC.D', 'CXC.DAC', 'CXC.CAP')
AND ISNULL(c.Saldo, 0) > 0.0
AND c.FechaEmision <= @FechaEmision
ORDER BY c.Moneda, c.Cliente
ELSE
IF @Modulo = 'CXP'
DECLARE crReevaluacion CURSOR FOR
SELECT m.Moneda, m.TipoCambio, c.TipoCambio, c.Proveedor, c.Mov, c.MovID, ISNULL(c.Saldo*ISNULL(mt.Factor, 1), 0)
FROM Cxp c, Reevaluacion m, MovTipo mt
WHERE c.Empresa = @Empresa
AND m.Moneda = c.Moneda AND m.TipoCambio <> c.TipoCambio AND m.Estacion = @Estacion AND ISNULL(m.TipoCambio, 0) > 0 AND m.Moneda <> @ContMoneda
AND c.Estatus = 'PENDIENTE'
AND mt.Modulo = @Modulo AND mt.Mov = c.Mov AND mt.Clave IN ('CXP.F', 'CXP.FAC', 'CXP.CA', 'CXP.CAD', 'CXP.D', 'CXP.DAC', 'CXP.CAP')
AND ISNULL(c.Saldo, 0) > 0.0
AND c.FechaEmision <= @FechaEmision
ORDER BY c.Moneda, c.Proveedor
OPEN crReevaluacion
FETCH NEXT FROM crReevaluacion INTO @Moneda, @TipoCambio, @MovTipoCambio, @Contacto, @Mov, @MovID, @Saldo
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Importe = (@Saldo*@TipoCambio) - (@Saldo*@MovTipoCambio)
IF @ID IS NULL OR @UltMoneda <> @Moneda OR @UltContacto <> @Contacto
BEGIN
SELECT @UltMoneda = @Moneda, @UltContacto = @Contacto
IF @ID IS NOT NULL AND @Ok IS NULL
BEGIN
IF @Modulo = 'CXC'
UPDATE Cxc SET Importe = @SumaImporte WHERE ID = @ID
ELSE
IF @Modulo = 'CXP'
UPDATE Cxp SET Importe = @SumaImporte WHERE ID = @ID
EXEC spCx @ID, @Modulo, 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 0, 0, @MovGenerar OUTPUT, @MovIDGenerar OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL
BEGIN
IF @Modulo = 'CXC'
INSERT Cxc (OrigenTipo, Sucursal,  Empresa,  Mov,     FechaEmision,  Moneda,      TipoCambio,  Usuario,   Estatus,     UltimoCambio,   Cliente,   ClienteMoneda, ClienteTipoCambio, AplicaManual)
VALUES ('AUTO/RE',  @Sucursal, @Empresa, @CfgMov, @FechaEmision, @ContMoneda, 1.0,         @Usuario, 'SINAFECTAR', @FechaRegistro, @Contacto, @Moneda,       @TipoCambio, 	1)
ELSE
IF @Modulo = 'CXP'
INSERT Cxp (OrigenTipo, Sucursal,  Empresa,  Mov,     FechaEmision,  Moneda,      TipoCambio,  Usuario,  Estatus,      UltimoCambio,   Proveedor, ProveedorMoneda, ProveedorTipoCambio, AplicaManual)
VALUES ('AUTO/RE',  @Sucursal, @Empresa, @CfgMov, @FechaEmision, @ContMoneda, 1.0,         @Usuario, 'SINAFECTAR', @FechaRegistro, @Contacto, @Moneda,         @TipoCambio, 	    1)
SELECT @ID = SCOPE_IDENTITY()
SELECT @Conteo = @Conteo + 1, @Renglon = 0.0, @SumaImporte = 0
END
END
SELECT @Renglon = @Renglon + 2048.0, @SumaImporte = @SumaImporte + @Importe
IF @Modulo = 'CXC'
INSERT CxcD (ID, Renglon, Aplica, AplicaID, Importe) VALUES (@ID, @Renglon, @Mov, @MovID, @Importe)
ELSE
IF @Modulo = 'CXP'
INSERT CxpD (ID, Renglon, Aplica, AplicaID, Importe) VALUES (@ID, @Renglon, @Mov, @MovID, @Importe)
END
FETCH NEXT FROM crReevaluacion INTO @Moneda, @TipoCambio, @MovTipoCambio, @Contacto, @Mov, @MovID, @Saldo
END
CLOSE crReevaluacion
DEALLOCATE crReevaluacion
IF @ID IS NOT NULL AND @Ok IS NULL
BEGIN
IF @Modulo = 'CXC'
UPDATE Cxc SET Importe = @SumaImporte WHERE ID = @ID
ELSE
IF @Modulo = 'CXP'
UPDATE Cxp SET Importe = @SumaImporte WHERE ID = @ID
EXEC spCx @ID, @Modulo, 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 0, 0, @Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
SELECT @ID = NULL
IF @Modulo = 'CXC'
DECLARE crReevaluacion CURSOR FOR
SELECT m.Moneda, m.TipoCambio, c.TipoCambio, c.Cliente, c.Mov, c.MovID, ISNULL(c.Saldo*ISNULL(mt.Factor, 1), 0)
FROM Cxc c, Reevaluacion m, MovTipo mt
WHERE c.Empresa = @Empresa
AND m.Moneda = c.Moneda AND m.TipoCambio <> c.TipoCambio AND m.Estacion = @Estacion AND ISNULL(m.TipoCambio, 0) > 0 AND m.Moneda <> @ContMoneda
AND c.Estatus = 'PENDIENTE'
AND mt.Modulo = @Modulo AND mt.Mov = c.Mov AND mt.Clave IN ('CXC.A', 'CXC.AR', 'CXC.DA', 'CXC.NC', 'CXC.NCD', 'CXC.NCF', 'CXC.DV')
AND ISNULL(c.Saldo, 0) > 0.0
AND c.FechaEmision <= @FechaEmision
ORDER BY c.Moneda, c.Cliente
ELSE
IF @Modulo = 'CXP'
DECLARE crReevaluacion CURSOR FOR
SELECT m.Moneda, m.TipoCambio, c.TipoCambio, c.Proveedor, c.Mov, c.MovID, ISNULL(c.Saldo*ISNULL(mt.Factor, 1), 0)
FROM Cxp c, Reevaluacion m, MovTipo mt
WHERE c.Empresa = @Empresa
AND m.Moneda = c.Moneda AND m.TipoCambio <> c.TipoCambio AND m.Estacion = @Estacion AND ISNULL(m.TipoCambio, 0) > 0 AND m.Moneda <> @ContMoneda
AND c.Estatus = 'PENDIENTE'
AND mt.Modulo = @Modulo AND mt.Mov = c.Mov AND mt.Clave IN ('CXP.A', 'CXP.DA', 'CXP.NC', 'CXP.NCD', 'CXP.NCF')
AND ISNULL(c.Saldo, 0) > 0.0
AND c.FechaEmision <= @FechaEmision
ORDER BY c.Moneda, c.Proveedor
OPEN crReevaluacion
FETCH NEXT FROM crReevaluacion INTO @Moneda, @TipoCambio, @MovTipoCambio, @Contacto, @Mov, @MovID, @Saldo
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Importe = (@Saldo*@TipoCambio) - (@Saldo*@MovTipoCambio)
IF @ID IS NULL OR @UltMoneda <> @Moneda OR @UltContacto <> @Contacto
BEGIN
SELECT @UltMoneda = @Moneda, @UltContacto = @Contacto
IF @ID IS NOT NULL AND @Ok IS NULL
BEGIN
IF @Modulo = 'CXC'
UPDATE Cxc SET Importe = @SumaImporte WHERE ID = @ID
ELSE
IF @Modulo = 'CXP'
UPDATE Cxp SET Importe = @SumaImporte WHERE ID = @ID
EXEC spCx @ID, @Modulo, 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 0, 0, @MovGenerar OUTPUT, @MovIDGenerar OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL
BEGIN
IF @Modulo = 'CXC'
INSERT Cxc (OrigenTipo, Sucursal,  Empresa,  Mov,            FechaEmision,  Moneda,      TipoCambio,  Usuario,   Estatus,     UltimoCambio,   Cliente,   ClienteMoneda, ClienteTipoCambio, AplicaManual)
VALUES ('AUTO/RE',  @Sucursal, @Empresa, @CfgMovCredito, @FechaEmision, @ContMoneda, 1.0,         @Usuario, 'SINAFECTAR', @FechaRegistro, @Contacto, @Moneda,       @TipoCambio, 	1)
ELSE
IF @Modulo = 'CXP'
INSERT Cxp (OrigenTipo, Sucursal,  Empresa,  Mov,            FechaEmision,  Moneda,      TipoCambio,  Usuario,  Estatus,      UltimoCambio,   Proveedor, ProveedorMoneda, ProveedorTipoCambio, AplicaManual)
VALUES ('AUTO/RE',  @Sucursal, @Empresa, @CfgMovCredito, @FechaEmision, @ContMoneda, 1.0,         @Usuario, 'SINAFECTAR', @FechaRegistro, @Contacto, @Moneda,         @TipoCambio, 	    1)
SELECT @ID = SCOPE_IDENTITY()
SELECT @Conteo = @Conteo + 1, @Renglon = 0.0, @SumaImporte = 0
END
END
SELECT @Renglon = @Renglon + 2048.0, @SumaImporte = @SumaImporte + @Importe
IF @Modulo = 'CXC'
INSERT CxcD (ID, Renglon, Aplica, AplicaID, Importe) VALUES (@ID, @Renglon, @Mov, @MovID, @Importe)
ELSE
IF @Modulo = 'CXP'
INSERT CxpD (ID, Renglon, Aplica, AplicaID, Importe) VALUES (@ID, @Renglon, @Mov, @MovID, @Importe)
END
FETCH NEXT FROM crReevaluacion INTO @Moneda, @TipoCambio, @MovTipoCambio, @Contacto, @Mov, @MovID, @Saldo
END
CLOSE crReevaluacion
DEALLOCATE crReevaluacion
IF @ID IS NOT NULL AND @Ok IS NULL
BEGIN
IF @Modulo = 'CXC'
UPDATE Cxc SET Importe = @SumaImporte WHERE ID = @ID
ELSE
IF @Modulo = 'CXP'
UPDATE Cxp SET Importe = @SumaImporte WHERE ID = @ID
EXEC spCx @ID, @Modulo, 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 0, 0, @Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
END
END
IF @Ok IS NULL
SELECT @Ok = 80000, @OkRef = LTRIM(Convert(char, @Conteo))+' Movimientos(s) generados.', @OkTipo = 'INFO', @OkDesc = 'Proceso Concluido'
ELSE
SELECT @OkDesc = Descripcion,
@OkTipo = Tipo
FROM MensajeLista
WHERE Mensaje = @Ok
SELECT @Ok, @OkDesc, @OkTipo, @OkRef, NULL
RETURN
END

