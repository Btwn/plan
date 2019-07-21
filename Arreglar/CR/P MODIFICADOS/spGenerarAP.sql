SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarAP
@Sucursal		int,
@Accion		char(20),
@Empresa		char(5),
@Modulo	      	char(5),
@ID			int,
@MovTipo		char(20),
@FechaRegistro	datetime,
@Mov	      		char(20),
@MovID            	varchar(20),
@Moneda		char(10),
@TipoCambio		float,
@Proyecto		varchar(50),
@Cuenta		char(10),
@Referencia		varchar(50),
@Condicion		varchar(50),
@PrimerVencimiento	datetime,
@ImporteTotal	money,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Rama		char(5),
@a			int,
@EsQuince		bit,
@ControlAnticipos	char(20),
@Numero		int,
@Periodo		char(15),
@ReferenciaBase	varchar(50),
@Vencimiento	datetime,
@FechaRequerida	datetime,
@EsCargo		bit,
@Pendiente		money,
@Saldo		money,
@Importe		money,
@Suma		money,
@Enganche		money,
@RedondeoMonetarios	int
SELECT @RedondeoMonetarios = dbo.fnRedondeoMonetarios()
IF @Accion = 'CANCELAR'
BEGIN
UPDATE Anticipo  WITH(ROWLOCK) SET Cancelado = 1 WHERE Modulo = @Modulo AND ModuloID = @ID
RETURN
END
SELECT @Suma = 0.0, @Enganche = 0.0
IF @Modulo = 'VTAS' SELECT @Rama = 'CXC' ELSE
IF @Modulo = 'COMS' SELECT @Rama = 'CXP'
ELSE SELECT @Rama = @Modulo
IF @MovTipo IN ('VTAS.P', 'VTAS.S', 'COMS.O')
SELECT @EsCargo = 1
ELSE
SELECT @EsCargo = 0
IF @EsCargo = 0
BEGIN
SELECT @Saldo = 0.0
SELECT @Saldo = ISNULL(Saldo, 0.0)
FROM AnticipoPendiente WITH(NOLOCK)
WHERE Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Cuenta = @Cuenta AND Referencia = @Referencia
IF @ImporteTotal <= @Saldo
INSERT Anticipo (Sucursal,  Rama,  Modulo,  ModuloID, Empresa,  Cuenta,  Moneda,  TipoCambio,  Mov,  MovID,  Proyecto,  Referencia,  Abono,         Fecha,             FechaRegistro)
VALUES (@Sucursal, @Rama, @Modulo, @ID,      @Empresa, @Cuenta, @Moneda, @TipoCambio, @Mov, @MovID, @Proyecto, @Referencia, @ImporteTotal, @PrimerVencimiento, @FechaRegistro)
ELSE BEGIN
SELECT @Pendiente = @ImporteTotal
SELECT @a = CHARINDEX('-', @Referencia)
IF @a > 0
SELECT @ReferenciaBase = SUBSTRING(@Referencia, 1, @a-1)
ELSE SELECT @ReferenciaBase = @Referencia
IF NULLIF(RTRIM(@ReferenciaBase), '') IS NOT NULL
BEGIN
DECLARE crAnticipoPendiente CURSOR FOR
SELECT Referencia, Saldo
FROM AnticipoPendiente WITH(NOLOCK)
WHERE  Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Cuenta = @Cuenta AND Referencia LIKE RTRIM(@ReferenciaBase)+'%'
ORDER BY Fecha
OPEN crAnticipoPendiente
FETCH NEXT FROM crAnticipoPendiente INTO @Referencia, @Saldo
WHILE @@FETCH_STATUS <> -1 AND @Pendiente > 0.0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Saldo <= @Pendiente SELECT @Importe = @Saldo ELSE SELECT @Importe = @Pendiente
INSERT Anticipo (Sucursal,  Rama,  Modulo,  ModuloID, Empresa,  Cuenta,  Moneda,  TipoCambio,  Mov,  MovID,  Proyecto,  Referencia,  Abono,    Fecha,              FechaRegistro)
VALUES (@Sucursal, @Rama, @Modulo, @ID,      @Empresa, @Cuenta, @Moneda, @TipoCambio, @Mov, @MovID, @Proyecto, @Referencia, @Importe, @PrimerVencimiento, @FechaRegistro)
SELECT @Pendiente = @Pendiente - @Importe
END
FETCH NEXT FROM crAnticipoPendiente  INTO @Referencia, @Saldo
END
CLOSE crAnticipoPendiente
DEALLOCATE crAnticipoPendiente
END
IF @Pendiente > 0.0
INSERT Anticipo (Sucursal,  Rama,  Modulo,  ModuloID, Empresa,  Cuenta,  Moneda,  TipoCambio,  Mov,  MovID,  Proyecto,  Referencia,  Abono,      Fecha,              FechaRegistro)
VALUES (@Sucursal, @Rama, @Modulo, @ID,      @Empresa, @Cuenta, @Moneda, @TipoCambio, @Mov, @MovID, @Proyecto, @Referencia, @Pendiente, @PrimerVencimiento, @FechaRegistro)
END
END ELSE
BEGIN
SELECT @ControlAnticipos = UPPER(ControlAnticipos), @Numero = NULLIF(AnticipadoNumero, 0), @Periodo = AnticipadoPeriodo
FROM Condicion
WITH(NOLOCK) WHERE Condicion = @Condicion
IF @ControlAnticipos = 'FECHA REQUERIDA' AND @Modulo IN ('VTAS', 'COMS')
BEGIN
IF @Modulo = 'VTAS' DECLARE crFechaRequerida CURSOR FOR SELECT FechaRequerida, SUM(ImporteTotal) FROM VentaTCalc WITH(NOLOCK) WHERE ID = @ID GROUP BY FechaRequerida ELSE
IF @Modulo = 'COMS' DECLARE crFechaRequerida CURSOR FOR SELECT FechaRequerida, SUM(ImporteTotal) FROM CompraTCalc WITH(NOLOCK) WHERE ID = @ID GROUP BY FechaRequerida
SELECT @a = 1
OPEN crFechaRequerida
FETCH NEXT FROM crFechaRequerida  INTO @FechaRequerida, @Importe
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Referencia = RTRIM(@Mov)+' '+RTRIM(@MovID)+ '-' +LTRIM(CONVERT(char, @a))
SELECT @a = @a + 1
INSERT Anticipo (Sucursal,  Rama,  Modulo,  ModuloID, Empresa,  Cuenta,  Moneda,  TipoCambio,  Mov,  MovID,  Proyecto,  Referencia,  Cargo,    Fecha,           FechaRegistro)
VALUES (@Sucursal, @Rama, @Modulo, @ID,      @Empresa, @Cuenta, @Moneda, @TipoCambio, @Mov, @MovID, @Proyecto, @Referencia, @Importe, @FechaRequerida, @FechaRegistro)
END
FETCH NEXT FROM crFechaRequerida  INTO @FechaRequerida, @Importe
END
CLOSE crFechaRequerida
DEALLOCATE crFechaRequerida
END ELSE
BEGIN
IF @ControlAnticipos = 'PLAZOS'
BEGIN
SELECT @Numero = ISNULL(@Numero, 1)
IF @Modulo = 'VTAS' SELECT @Enganche = ISNULL(Enganche, 0.0) FROM Venta with(nolock) WHERE ID = @ID
END ELSE
SELECT @Numero = 1
SELECT @a = 1,
@Vencimiento = @PrimerVencimiento,
@Importe = ROUND(@ImporteTotal / @Numero, @RedondeoMonetarios)
IF @Periodo = 'QUINCENAL'
IF DATEPART(dd, @Vencimiento) <= 15 SELECT @EsQuince = 1 ELSE SELECT @EsQuince = 0
WHILE (@a <= @Numero) AND @Ok IS NULL
BEGIN
IF @Enganche > 0.0
IF @a = 1
SELECT @Importe = @Enganche
ELSE
SELECT @Importe = ROUND((@ImporteTotal - @Enganche) / (@Numero-1), @RedondeoMonetarios)
IF @Importe < 0.0 SELECT @Ok = 30100
SELECT @Suma = @Suma + @Importe
SELECT @Referencia = RTRIM(@Mov)+' '+RTRIM(@MovID)
IF @Numero > 1 SELECT @Referencia = @Referencia + '-' +LTRIM(CONVERT(char, @a))
IF @a > 1
BEGIN
IF dbo.fnEsNumerico(@Periodo) = 1 SELECT @Vencimiento = DATEADD(day,   CONVERT(int, @Periodo)*@a, @PrimerVencimiento) ELSE
IF @Periodo = 'SEMANAL'    SELECT @Vencimiento = DATEADD(wk, @a-1,      @PrimerVencimiento) ELSE
IF @Periodo = 'MENSUAL'    SELECT @Vencimiento = DATEADD(mm, @a-1,      @PrimerVencimiento) ELSE
IF @Periodo = 'BIMESTRAL'  SELECT @Vencimiento = DATEADD(mm, (@a-1)*2,  @PrimerVencimiento) ELSE
IF @Periodo = 'TRIMESTRAL' SELECT @Vencimiento = DATEADD(mm, (@a-1)*3,  @PrimerVencimiento) ELSE
IF @Periodo = 'SEMESTRAL'  SELECT @Vencimiento = DATEADD(mm, (@a-1)*6,  @PrimerVencimiento) ELSE
IF @Periodo = 'ANUAL'      SELECT @Vencimiento = DATEADD(yy, (@a-1),    @PrimerVencimiento) ELSE
IF @Periodo = 'QUINCENAL'
BEGIN
IF @EsQuince = 1
SELECT @EsQuince = 0, @Vencimiento = DATEADD(dd, -15, DATEADD(mm, 1, @Vencimiento))
ELSE
SELECT @EsQuince = 1, @Vencimiento = DATEADD(dd, 15, @Vencimiento)
END
END
IF @a = @Numero AND @Suma <> @ImporteTotal SELECT @Importe = @Importe - (@Suma - @ImporteTotal)
INSERT Anticipo (Sucursal,  Rama,  Modulo,  ModuloID, Empresa,  Cuenta,  Moneda,  TipoCambio,  Mov,  MovID,  Proyecto,  Referencia,  Cargo,    Fecha,        FechaRegistro)
VALUES (@Sucursal, @Rama, @Modulo, @ID,      @Empresa, @Cuenta, @Moneda, @TipoCambio, @Mov, @MovID, @Proyecto, @Referencia, @Importe, @Vencimiento, @FechaRegistro)
SELECT @a = @a + 1
END
END
END
RETURN
END

