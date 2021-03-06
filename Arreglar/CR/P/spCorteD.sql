SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteD
@ID                	int,
@Accion				char(20),
@Empresa	      	char(5),
@Modulo	      		char(5),
@Mov	  	      	char(20),
@MovID             	varchar(20),
@MovTipo     		char(20),
@SubMovTipo     	char(20),
@FechaEmision      	datetime,
@FechaAfectacion    datetime,
@FechaConclusion	datetime,
@Proyecto	      	varchar(50),
@Usuario	      	char(10),
@Autorizacion      	char(10),
@Observaciones     	varchar(255),
@Concepto     		varchar(50),
@Referencia			varchar(50),
@Estatus           	char(15),
@EstatusNuevo	    char(15),
@FechaRegistro     	datetime,
@Ejercicio	      	int,
@Periodo	      	int,
@MovUsuario			char(10),
@CorteFrecuencia	varchar(50),
@CorteGrupo			varchar(50),
@CorteTipo			varchar(50),
@CortePeriodo		int,
@CorteEjercicio		int,
@CorteOrigen		varchar(50),
@CorteCuentaTipo	varchar(20),
@CorteGrupoDe		varchar(10),
@CorteGrupoA		varchar(10),
@CorteSubGrupoDe	varchar(20),
@CorteSubGrupoA		varchar(20),
@CorteCuentaDe		varchar(10),
@CorteCuentaA		varchar(10),
@CorteSubCuentaDe	varchar(50),
@CorteSubCuenta2A	varchar(50),
@CorteSubCuenta2De	varchar(50),
@CorteSubCuenta3A	varchar(50),
@CorteSubCuenta3De	varchar(50),
@CorteSubCuentaA	varchar(50),
@CorteUENDe			int,
@CorteUENA			int,
@CorteProyectoDe	varchar(50),
@CorteProyectoA		varchar(50),
@CorteFechaD		datetime,
@CorteFechaA		datetime,
@Moneda				varchar(10),
@TipoCambio			float,
@CorteTitulo		varchar(100),
@CorteMensaje		varchar(100),
@CorteEstatus		varchar(15),
@CorteSucursalDe	int,
@CorteSucursalA		int,
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@SucursalDestino	int,
@SucursalOrigen		int,
@Estacion			int,
@CorteValuacion		varchar(50),
@CorteDesglosar		varchar(20),
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS
BEGIN
UPDATE #CorteD
SET RenglonSub = 0,
Renglon	= RID * 2048
INSERT INTO CorteD(
ID,						Renglon,					RenglonSub,					Cuenta,					Mov,					MovID,
Fecha,					Vencimiento,				Moneda,						Aplica,					AplicaID,				Referencia,
CtaCreditoDias,			CtaCondicion,				CtaLimiteCredito,			CtaLimiteCreditoMoneda,	Cargo,					Abono,
CargoU,					AbonoU,						SaldoU,						ValuacionNombre,		ValuacionValor,			ValuacionValorArtConCosto,
CostoPromedio,			UltimoCosto,				PrecioLista,				Precio2,				Precio3,				Precio4,
Precio5,				Precio6,					Precio7,					Precio8,				Precio9,				Precio10,
CostoEstandar,			CostoReposicion,			Grupo,						Sucursal,				SubCuenta,				CostoUnitario,
CostoUnitarioOtraMoneda,MonedaContable,				Modulo,						ModuloID,				Cantidad,				Importe,
RIDConsulta,			TipoCambio,					Saldo,						Empresa,				Periodo,				Ejercicio,
Estatus,				SaldoI,						EsCancelacion,				SaldoUI)
SELECT ID,						Renglon,					RenglonSub,					Cuenta,					Mov,					MovID,
Fecha,					Vencimiento,				Moneda,						Aplica,					AplicaID,				Referencia,
CtaCreditoDias,			CtaCondicion,				CtaLimiteCredito,			CtaLimiteCreditoMoneda,	Cargo,					Abono,
CargoU,					AbonoU,						SaldoU,						ValuacionNombre,		ValuacionValor,			ValuacionValorArtConCosto,
CostoPromedio,			UltimoCosto,				PrecioLista,				Precio2,				Precio3,				Precio4,
Precio5,				Precio6,					Precio7,					Precio8,				Precio9,				Precio10,
CostoEstandar,			CostoReposicion,			Grupo,						Sucursal,				SubCuenta,				CostoUnitario,
CostoUnitarioOtraMoneda,MonedaContable,				Modulo,						ModuloID,				Cantidad,				Importe,
RIDConsulta,			TipoCambio,					Saldo,						Empresa,				Periodo,				Ejercicio,
Estatus,				SaldoI,						EsCancelacion,				SaldoUI
FROM #CorteD
EXEC xpCorteD @ID, @Accion, @Empresa, @Modulo, @Mov, @MovID, @MovTipo, @SubMovTipo, @FechaEmision, @FechaAfectacion, @FechaConclusion,
@Proyecto, @Usuario, @Autorizacion, @Observaciones, @Concepto, @Referencia,
@Estatus, @EstatusNuevo, @FechaRegistro, @Ejercicio, @Periodo, @MovUsuario, @CorteFrecuencia, @CorteGrupo, @CorteTipo,
@CortePeriodo, @CorteEjercicio, @CorteOrigen, @CorteCuentaTipo, @CorteGrupoDe, @CorteGrupoA, @CorteSubGrupoDe, @CorteSubGrupoA,
@CorteCuentaDe, @CorteCuentaA, @CorteSubCuentaDe, @CorteSubCuenta2A, @CorteSubCuenta2De, @CorteSubCuenta3A, @CorteSubCuenta3De,
@CorteSubCuentaA, @CorteUENDe, @CorteUENA, @CorteProyectoDe, @CorteProyectoA, @CorteFechaD, @CorteFechaA, @Moneda, @TipoCambio,
@CorteTitulo, @CorteMensaje, @CorteEstatus, @CorteSucursalDe, @CorteSucursalA,
@Conexion, @SincroFinal, @Sucursal, @SucursalDestino, @SucursalOrigen, @Estacion, @CorteValuacion, @CorteDesglosar,
@Ok OUTPUT, @OkRef OUTPUT
RETURN
END

