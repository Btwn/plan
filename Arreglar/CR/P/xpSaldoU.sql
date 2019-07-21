SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpSaldoU
@Sucursal		int,
@Accion		char(20),
@Empresa		char(5),
@Usuario		char(10),
@Rama		char(5),
@Moneda		char(10),
@Cuenta		char(20),
@SubCuenta		varchar(50),
@Grupo		char(10),
@Modulo		char(5),
@ID			int,
@Mov			char(20),
@MovID		varchar(20),
@Cargo		money,
@Abono		money,
@CargoU		float,
@AbonoU		float,
@Fecha		datetime,
@EjercicioAfectacion int,
@PeriodoAfectacion   int,
@AcumulaSinDetalles	bit,
@AcumulaEnLinea	bit,
@GeneraAuxiliar	bit,
@GeneraSaldo	        bit,
@Conciliar		bit,
@Aplica		char(20),
@AplicaID		varchar(20),
@EsTransferencia     bit,
@EsResultados	bit,
@EsTipoSerie		bit,
@InvNegativoU   	float,
@ConsignacionU	float,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT,
@Renglon		float		= NULL,
@RenglonSub		int		= NULL,
@RenglonID		int		= NULL,
@SubGrupo		varchar(20)	= NULL
AS BEGIN
DECLARE
@eCommerce       bit
SELECT @eCommerce = ISNULL(eCommerce,0) FROM EmpresaGral WHERE Empresa = @Empresa
IF @eCommerce = 1
BEGIN
IF NOT EXISTS(SELECT * FROM eCommerceSaldoU WHERE Articulo = @Cuenta AND SubCuenta = @SubCuenta)
INSERT eCommerceSaldoU(Articulo, SubCuenta)
SELECT                 @Cuenta, @SubCuenta
END
RETURN
END

