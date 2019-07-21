SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPresupuesto
@Sucursal		int,
@Empresa		char(5),
@Moneda		char(10),
@Rama		char(5),
@Tipo		varchar(50),
@Cuenta		char(20),
@SubCuenta		varchar(50),
@SubCuenta2		varchar(50),
@SubCuenta3		varchar(50),
@UEN			int,
@Presupuesto		money,
@Reservado		money,
@Comprometido	money,
@Devengado		money,
@Ejercido		money,
@Ejercicio		int,
@Periodo		int,
@Accion		char(20),
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@PPTO	bit,
@Dif	money
IF (SELECT ISNULL(PresupuestoNivelUEN, 0) FROM Cta WHERE Cuenta = @Cuenta) = 0 SELECT @UEN = NULL
IF @Accion IN ('CANCELAR', 'DESAFECTAR') SELECT @Presupuesto = -@Presupuesto, @Reservado = -@Reservado, @Comprometido = -@Comprometido, @Devengado = -@Devengado, @Ejercido = -@Ejercido
UPDATE Presupuesto
SET Presupuesto       = ISNULL(Presupuesto, 0.0) + ISNULL(@Presupuesto, 0.0),
Reservado         = ISNULL(Reservado, 0.0) + ISNULL(@Reservado, 0.0),
Comprometido      = ISNULL(Comprometido, 0.0) + ISNULL(@Comprometido, 0.0),
Devengado         = ISNULL(Devengado, 0.0) + ISNULL(@Devengado, 0.0),
Ejercido          = ISNULL(Ejercido, 0.0) + ISNULL(@Ejercido, 0.0)
WHERE Empresa   = @Empresa
AND Rama      = @Rama
AND Moneda    = @Moneda
AND Cuenta    = @Cuenta
AND Ejercicio = @Ejercicio
AND Periodo   = @Periodo
AND ISNULL(Tipo, '')      = ISNULL(@Tipo, '')
AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
AND ISNULL(SubCuenta2, '') = ISNULL(@SubCuenta2, '')
AND ISNULL(SubCuenta3, '') = ISNULL(@SubCuenta3, '')
AND ISNULL(UEN, 0)        = ISNULL(@UEN, 0)
IF @@ROWCOUNT = 0
INSERT Presupuesto (Sucursal,  Empresa,  Rama,  Moneda,  Tipo,  Cuenta,  SubCuenta,  SubCuenta2,  SubCuenta3,   UEN,  Ejercicio,  Periodo,  Presupuesto,  Reservado,  Comprometido,  Devengado,  Ejercido)
VALUES (@Sucursal, @Empresa, @Rama, @Moneda, @Tipo, @Cuenta, @SubCuenta, @SubCuenta2, @SubCuenta3, @UEN, @Ejercicio, @Periodo, @Presupuesto, @Reservado, @Comprometido, @Devengado, @Ejercido)
SELECT @PPTO = PPTO FROM EmpresaGral WHERE Empresa = @Empresa
IF @PPTO = 1
BEGIN
SELECT @Presupuesto = ISNULL(SUM(Presupuesto), 0.0),
@Reservado   = ISNULL(SUM(Reservado), 0.0),
@Comprometido= ISNULL(SUM(Comprometido), 0.0),
@Devengado   = ISNULL(SUM(Devengado), 0.0),
@Ejercido    = ISNULL(SUM(Ejercido), 0.0)
FROM Presupuesto
WHERE Empresa   = @Empresa
AND Rama      = @Rama
AND Moneda    = @Moneda
AND Cuenta    = @Cuenta
AND Ejercicio = @Ejercicio
AND Periodo   = @Periodo
AND ISNULL(Tipo, '')      = ISNULL(@Tipo, '')
AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '')
AND ISNULL(SubCuenta2, '') = ISNULL(@SubCuenta2, '')
AND ISNULL(SubCuenta3, '') = ISNULL(@SubCuenta3, '')
AND ISNULL(UEN, 0)        = ISNULL(@UEN, 0)
IF @Presupuesto < 0.0 SELECT @Ok = 50130, @Dif = ABS(@Presupuesto)  ELSE
IF @Reservado   < 0.0 SELECT @Ok = 50140, @Dif = ABS(@Reservado)    ELSE
IF @Comprometido< 0.0 SELECT @Ok = 50142, @Dif = ABS(@Comprometido) ELSE
IF @Devengado   < 0.0 SELECT @Ok = 50144, @Dif = ABS(@Devengado)    ELSE
IF @Ejercido    < 0.0 SELECT @Ok = 50140, @Dif = ABS(@Ejercido)     ELSE
IF (@Presupuesto - @Reservado - @Comprometido - @Devengado - @Ejercido) < 0.0 SELECT @Ok = 50160, @Dif = ABS(@Presupuesto - @Reservado - @Ejercido)
IF @Ok IS NOT NULL SELECT @OkRef = 'Periodo '+CONVERT(varchar, @Periodo)+', Cuenta '+@Cuenta+', UEN '+CONVERT(varchar, @UEN)+', Diferencia '+CONVERT(varchar, @Dif)
END
RETURN
END

