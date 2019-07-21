SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spPOSMonederoCBRefimir
@Empresa              char( 5),
@Sucursal             int,
@IDPOS				varchar(36),
@MonederoCBSerie		varchar(20),
@MonederoCBImporte	money,
@Posicion				int,
@Moneda				varchar(10),
@TipoCambio			float,
@Usuario				varchar(10),
@Mov					varchar(20),
@MovID				varchar(20),
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT
AS
BEGIN
DECLARE
@Accion               varchar(20),
@UEN                  int,
@Puntos               money,
@SaldoPMonuntos       money,
@DiferenciaPuntos     money,
@Rama                 varchar( 5),
@Cuenta               varchar(50),
@SubCuenta            varchar(50),
@Grupo                varchar(10),
@EjercicioAfectacion  int,
@PeriodoAfectacion    int,
@AcumulaSinDetalles   bit,
@AcumulaEnLinea       bit,
@GeneraAuxiliar       bit,
@GeneraSaldo	        bit,
@Conciliar            bit,
@EsResultados         bit,
@Renglon              float,
@RenglonSub           int,
@RenglonID            int,
@Bandera				int,
@Estatus              varchar(15),
@MovTipo              varchar(20),
@EstatusNuevo         varchar(15),
@FechaRegistro        datetime,
@Mensaje				varchar(max),
@ID                   int,
@MovDev				varchar(20),
@Modulo               varchar( 5),
@FechaEmision			datetime
SELECT @Rama					= 'MONEL',
@SubCuenta				= '',
@Grupo					= 'ME',
@AcumulaSinDetalles		= 1,
@AcumulaEnLinea			= 1,
@GeneraAuxiliar			= 1,
@GeneraSaldo				= 1,
@Conciliar				= 0,
@EsResultados			= 0,
@FechaRegistro			= GETDATE(),
@FechaEmision			= dbo.fnFechaSinHora(@FechaRegistro),
@EjercicioAfectacion		= CONVERT(int,DATEPART(YEAR,@FechaEmision)),
@PeriodoAfectacion		= CONVERT(int,DATEPART(MONTH,@FechaEmision)),
@Estatus					= 'SINAFECTAR',
@Modulo					= 'VTAS',
@ID						= NULL
SELECT @MovTipo = Clave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
SELECT @MovDev = POSDefMovDev FROM POSCfg WHERE Empresa = @Empresa
BEGIN TRAN
IF @Modulo = 'VTAS'
BEGIN
INSERT INTO POSSerieTarjetaMovM (Empresa,	Modulo,		ID,		Serie,				Importe,			Sucursal,  Posicion,
Mov,	MovID,	Moneda,		TipoCambio,		FechaEmision,	Usuario)
VALUES						 (@Empresa, @Modulo,	@IDPOS, @MonederoCBSerie,	@MonederoCBImporte, @Sucursal, @Posicion,
@Mov,	@MovID, @Moneda,	@TipoCambio,	@FechaEmision,	@Usuario)
IF @Estatus = 'SINAFECTAR' AND @MovTipo = 'VTAS.N'
SET @EstatusNuevo = 'PROCESAR'
IF @Estatus = 'SINAFECTAR' AND @MovTipo = 'VTAS.F'
SET @EstatusNuevo = 'CONCLUIDO'
IF @MovTipo IN ('VTAS.N', 'VTAS.F')
BEGIN
IF @EstatusNuevo IN ('PROCESAR', 'CONCLUIDO')
BEGIN
SELECT @Accion =  'AFECTAR'
IF EXISTS(SELECT * FROM POSSerieTarjetaMovM WHERE Modulo = @Modulo AND ID = @IDPOS) 
BEGIN
SELECT @Cuenta = NULLIF(Serie,''),
@Puntos = ABS(ISNULL(Importe,0.0) )
FROM POSSerieTarjetaMovM
WHERE Modulo = @Modulo
AND ID = @IDPOS
AND Posicion = @Posicion
IF @Cuenta IS NOT NULL AND ISNULL(@Puntos,0.0) > 0.0
BEGIN
IF EXISTS(SELECT *
FROM TarjetaMonedero T
WHERE T.Serie = @Cuenta AND T.Estatus IN ('ACTIVA'))
BEGIN
SELECT @SaldoPMonuntos = SUM(ISNULL(Saldo,0.0))
FROM SaldoPMon
WHERE Empresa = @Empresa AND Rama = @Rama AND Moneda = @Moneda AND Grupo = @Grupo AND Cuenta = @Cuenta 
IF @Mov <> @MovDev
EXEC spSaldoPMon @Sucursal, @Accion, @Empresa, @Rama, @Moneda, @TipoCambio, @Cuenta, @SubCuenta, @Grupo, @Modulo, @ID, @Mov, @MovID, @Puntos, NULL, @FechaEmision,
@EjercicioAfectacion, @PeriodoAfectacion,@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Mov, @MovID,
@EsResultados, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @UEN = @UEN
ELSE
EXEC spSaldoPMon @Sucursal, @Accion, @Empresa, @Rama, @Moneda, @TipoCambio, @Cuenta, @SubCuenta, @Grupo, @Modulo, @ID, @Mov, @MovID, NULL, @Puntos, @FechaEmision,
@EjercicioAfectacion, @PeriodoAfectacion,@AcumulaSinDetalles, @AcumulaEnLinea, @GeneraAuxiliar, @GeneraSaldo, @Conciliar, @Mov, @MovID,
@EsResultados, @Ok OUTPUT, @OkRef OUTPUT, @Renglon = @Renglon, @RenglonSub = @RenglonSub, @RenglonID = @RenglonID, @UEN = @UEN
IF @OK IS NULL
BEGIN
UPDATE POSSerieTarjetaMovM
SET Referencia = 'APROBADA'
WHERE Mov = @Mov
AND MovID = @MovID
AND Posicion = @Posicion
AND Empresa = @Empresa
AND Serie = @MonederoCBSerie
AND Sucursal = @Sucursal
END
END
ELSE
SELECT @OK = 99005, @OKRef = 'La Cuenta ' + @Cuenta + 'no Existe o no está Activa'
END
END
END
END
END
IF @OK IS NULL
COMMIT TRAN
ELSE
BEGIN
ROLLBACK TRAN
IF @OkRef IS NULL
SELECT @OkRef = 'DENEGADA'
END
END

