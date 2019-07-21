SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spValeAplicarCobro
@Empresa	char(5),
@Modulo		char(5),
@ID		int,
@Importe	money,
@Accion 	char(20),
@Fecha		datetime,
@Ok		int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Serie		char(20),
@FechaCobro 	datetime,
@ModuloCobro 	char(5),
@IDCobro		int,
@EstatusA		char(15),
@EstatusN		char(15),
@Aplica		char(20),
@AplicaID		char(20),
@AplicaSucursal	int,
@MovTipo		char(10),
@Factor		int,
@FactorMov		int,
@EsCancelacion	bit,
@ImporteAplicar	money,
@Cargo		money,
@Abono		money,
@Ejercicio		int,
@Periodo		int
IF @Ok IS NOT NULL RETURN
DECLARE crValeMov CURSOR FOR
SELECT Serie
FROM ValeSerieMov
WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID
OPEN crValeMov
FETCH NEXT FROM crValeMov INTO @Serie
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Serie = NULLIF(UPPER(RTRIM(@Serie)), '')
IF @Accion = 'CANCELAR'
SELECT @EstatusA = 'COBRADO', @EstatusN = 'CIRCULACION', @FechaCobro = NULL,@ModuloCobro = NULL, @IDCobro = NULL
ELSE
SELECT @EstatusA = 'CIRCULACION', @EstatusN = 'COBRADO', @FechaCobro = @Fecha, @ModuloCobro = @Modulo, @IDCobro = @ID
UPDATE ValeSerie
SET Estatus = @EstatusN,
FechaCobro = @FechaCobro,
ModuloCobro = @ModuloCobro,
IDCobro = @IDCobro
WHERE Serie = @Serie AND Estatus = @EstatusA
IF @@ROWCOUNT = 0 SELECT @Ok = 36140, @OkRef = @Serie
END
FETCH NEXT FROM crValeMov INTO @Serie
END
CLOSE crValeMov
DEALLOCATE crValeMov
DECLARE crTarjetaMov CURSOR FOR
SELECT Serie, Importe
FROM TarjetaSerieMov
WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID
SELECT @Ejercicio = DATEPART(year, @Fecha), @Periodo = DATEPART(month, @Fecha)
SELECT @AplicaSucursal = Sucursal, @Aplica = Mov, @AplicaID = MovID FROM Mov WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID
IF @Modulo = 'CXC'
BEGIN
SELECT @MovTipo = Clave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Aplica
IF @MovTipo in('CXC.A', 'CXC.AR', 'CXC.AA', 'CXC.C') 
SELECT @FactorMov = 1
ELSE
SELECT @FactorMov = -1 
END
ELSE
SELECT @FactorMov = ISNULL(Factor,1) FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Aplica
OPEN crTarjetaMov
FETCH NEXT FROM crTarjetaMov INTO @Serie, @ImporteAplicar
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
SELECT @Serie = NULLIF(UPPER(RTRIM(@Serie)), '')
IF @Accion = 'CANCELAR'
BEGIN
SELECT @Factor = -1, @EsCancelacion = 1
IF @ImporteAplicar < 0
SELECT @Factor = 1
END
ELSE
BEGIN
SELECT @Factor = 1, @EsCancelacion = 0
IF @ImporteAplicar < 0
SELECT @Factor = -1
END
IF @FactorMov = -1 OR @ImporteAplicar < 0
SELECT @Cargo = @ImporteAplicar*@Factor, @Abono = NULL
ELSE
SELECT @Cargo = NULL, @Abono = @ImporteAplicar*@Factor
INSERT INTO AuxiliarValeSerie(Sucursal, Mov, MovID, Modulo, ModuloID, Serie, Ejercicio, Periodo, Fecha, Cargo, Abono, PorConciliar, EsCancelacion)
VALUES(@AplicaSucursal, @Aplica, @AplicaID, @Modulo, @ID, @Serie, @Ejercicio, @Periodo, @Fecha, @Cargo, @Abono, 0, @EsCancelacion)
END
FETCH NEXT FROM crTarjetaMov INTO @Serie, @ImporteAplicar
END
CLOSE crTarjetaMov
DEALLOCATE crTarjetaMov
END

