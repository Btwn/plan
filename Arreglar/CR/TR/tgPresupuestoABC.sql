SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgPresupuestoABC ON Presupuesto

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@SucursalPrincipal	int,
@Empresa   		varchar(5),
@Rama	        varchar(5),
@Tipo      		varchar(50),
@Cuenta    		varchar(20),
@CtaRama 		varchar(20),
@Moneda		varchar(10),
@SubCuenta 		varchar(50),
@SubCuenta2		varchar(50),
@SubCuenta3		varchar(50),
@UEN		int,
@Presupuesto	money,
@Reservado		money,
@Comprometido	money,
@Devengado		money,
@Ejercido		money,
@Ejercicio 		int,
@Periodo   		int,
@Ok			int,
@OkRef		varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
IF (SELECT Sincronizando FROM Version) = 1 RETURN
SELECT @SucursalPrincipal = Sucursal FROM Version
SELECT @Rama = NULL, @SubCuenta = NULL, @UEN = NULL
SELECT @Empresa      = NULLIF(RTRIM(Empresa), ''),
@Rama         = NULLIF(RTRIM(Rama), ''),
@Tipo         = NULLIF(RTRIM(Tipo), ''),
@Cuenta       = NULLIF(RTRIM(Cuenta), ''),
@SubCuenta    = NULLIF(RTRIM(SubCuenta), ''),
@SubCuenta2   = NULLIF(RTRIM(SubCuenta2), ''),
@SubCuenta3   = NULLIF(RTRIM(SubCuenta3), ''),
@UEN	       = NULLIF(UEN, 0),
@Moneda       = Moneda,
@Ejercicio    = Ejercicio,
@Periodo      = Periodo,
@Presupuesto  = -Presupuesto,
@Reservado    = -Reservado,
@Comprometido = -Comprometido,
@Devengado    = -Devengado,
@Ejercido     = -Ejercido
FROM Deleted
WHERE Presupuesto IS NOT NULL
IF @Rama = 'CONT'
BEGIN
SELECT @CtaRama = NULLIF(RTRIM(Rama), '') FROM Cta WHERE Cuenta = @Cuenta
WHILE @CtaRama IS NOT NULL AND @@Error = 0
BEGIN
EXEC spPresupuesto @SucursalPrincipal, @Empresa, @Moneda, @Rama, @Tipo, @CtaRama, @SubCuenta, @SubCuenta2, @SubCuenta3, @UEN, @Presupuesto, @Reservado, @Comprometido, @Devengado, @Ejercido, @Ejercicio, @Periodo, 'AFECTAR', @Ok OUTPUT, @OkRef OUTPUT
SELECT @CtaRama = NULLIF(RTRIM(Rama), '') FROM Cta WHERE Cuenta = @CtaRama
END
END ELSE
IF @Rama = 'CC'
BEGIN
SELECT @CtaRama = NULLIF(RTRIM(Rama), '') FROM CentroCostos WHERE CentroCostos = @Cuenta
WHILE @CtaRama IS NOT NULL AND @@Error = 0
BEGIN
EXEC spPresupuesto @SucursalPrincipal, @Empresa, @Moneda, @Rama, @Tipo, @CtaRama, @SubCuenta, @SubCuenta2, @SubCuenta3, @UEN, @Presupuesto, @Reservado, @Comprometido, @Devengado, @Ejercido, @Ejercicio, @Periodo, 'AFECTAR', @Ok OUTPUT, @OkRef OUTPUT
SELECT @CtaRama = NULLIF(RTRIM(Rama), '') FROM CentroCostos WHERE CentroCostos = @CtaRama
END
END
SELECT @Rama = NULL, @SubCuenta = NULL, @UEN = NULL
SELECT @Empresa      = NULLIF(RTRIM(Empresa), ''),
@Rama         = NULLIF(RTRIM(Rama), ''),
@Tipo         = NULLIF(RTRIM(Tipo), ''),
@Cuenta       = NULLIF(RTRIM(Cuenta), ''),
@SubCuenta    = NULLIF(RTRIM(SubCuenta), ''),
@SubCuenta2   = NULLIF(RTRIM(SubCuenta2), ''),
@SubCuenta3   = NULLIF(RTRIM(SubCuenta3), ''),
@UEN	       = NULLIF(UEN, 0),
@Moneda       = Moneda,
@Ejercicio    = Ejercicio,
@Periodo      = Periodo,
@Presupuesto  = Presupuesto,
@Reservado    = Reservado,
@Comprometido = Comprometido,
@Devengado    = Devengado,
@Ejercido     = Ejercido
FROM Inserted
WHERE Presupuesto IS NOT NULL
IF @Rama = 'CONT'
BEGIN
SELECT @CtaRama = NULLIF(RTRIM(Rama), '') FROM Cta WHERE Cuenta = @Cuenta
WHILE @CtaRama IS NOT NULL AND @@Error = 0
BEGIN
EXEC spPresupuesto @SucursalPrincipal, @Empresa, @Moneda, @Rama, @Tipo, @CtaRama, @SubCuenta, @SubCuenta2, @SubCuenta3, @UEN, @Presupuesto, @Reservado, @Comprometido, @Devengado, @Ejercido, @Ejercicio, @Periodo, 'AFECTAR', @Ok OUTPUT, @OkRef OUTPUT
SELECT @CtaRama = NULLIF(RTRIM(Rama), '') FROM Cta WHERE Cuenta = @CtaRama
END
END ELSE
IF @Rama = 'CC'
BEGIN
SELECT @CtaRama = NULLIF(RTRIM(Rama), '') FROM CentroCostos WHERE CentroCostos = @Cuenta
WHILE @CtaRama IS NOT NULL AND @@Error = 0
BEGIN
EXEC spPresupuesto @SucursalPrincipal, @Empresa, @Moneda, @Rama, @Tipo, @CtaRama, @SubCuenta, @SubCuenta2, @SubCuenta3, @UEN, @Presupuesto, @Reservado, @Comprometido, @Devengado, @Ejercido, @Ejercicio, @Periodo, 'AFECTAR', @Ok OUTPUT, @OkRef OUTPUT
SELECT @CtaRama = NULLIF(RTRIM(Rama), '') FROM CentroCostos WHERE CentroCostos = @CtaRama
END
END
END

