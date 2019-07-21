SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spChecarConsignacion
@Empresa		char(5),
@Sucursal		int,
@Usuario		char(10),
@Modulo			char(5),
@Mov			varchar(20),
@MovID			varchar(20),
@Fecha			datetime,
@EjercicioAfectacion	int,
@PeriodoAfectacion	int,
@Moneda			char(10),
@Grupo			char(10),
@SubGrupo		varchar(20),
@Cuenta			varchar(20),
@SubCuenta		varchar(50),
@Cantidad		float,
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Existencia		float,
@Faltante		float,
@EnConsignacion	float,
@MovTipo		varchar(20)
SELECT @MovTipo = Clave FROM MovTipo WITH (NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov
IF @MovTipo IN('VTAS.N') RETURN
SELECT @Existencia = 0.0, @Faltante = 0.0, @EnConsignacion = 0.0, @SubGrupo = ISNULL(@SubGrupo, ''), @SubCuenta = ISNULL(@SubCuenta, '')
SELECT @Existencia = ISNULL(SUM(SaldoU), 0.0)
FROM SaldoU WITH (NOLOCK)
WHERE /*Sucursal = @Sucursal AND */Empresa = @Empresa AND Rama = 'INV' AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND ISNULL(SubGrupo, '') = ISNULL(@SubGrupo, '')
IF @Cantidad > @Existencia SELECT @Faltante = @Cantidad - @Existencia
IF @Faltante > 0.0
BEGIN
SELECT @EnConsignacion = ISNULL(SUM(SaldoU), 0.0)
FROM SaldoU WITH (NOLOCK)
WHERE Rama='CSG' AND Sucursal = @Sucursal AND Empresa = @Empresa AND Grupo = @Grupo AND Cuenta = @Cuenta AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND ISNULL(SubGrupo, '') = ISNULL(@SubGrupo, '')
IF @EnConsignacion >= @Faltante
BEGIN
EXEC spComprarConsignacion @Sucursal, @Empresa, @Usuario, @Cuenta, @SubCuenta, @Grupo, @SubGrupo, @Faltante, @Modulo, @Mov, @MovID,
@Fecha, @EjercicioAfectacion, @PeriodoAfectacion,
@Ok OUTPUT, @OkRef OUTPUT
END
END
RETURN
END

