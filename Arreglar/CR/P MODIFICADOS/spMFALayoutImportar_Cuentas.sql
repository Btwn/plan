SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMFALayoutImportar_Cuentas
@Usuario			varchar(20),
@Empresa			varchar(5),
@Ejercicio		int,
@Periodo			int,
@EnSilencio		bit			= 0

AS BEGIN
DECLARE
@cmd					varchar(8000),
@with					varchar(255),
@moneda					varchar(10),
@PeriodoInicial			int,
@EjercicioInicial		int,
@log_id					int,
@ExportarSIA			bit,
@SIABaseIndependiente	bit,
@SIABaseDatos			varchar(255)
SELECT @usuario = UPPER(@usuario)
SELECT @PeriodoInicial = PeriodoInicial, @EjercicioInicial = EjercicioInicial, @ExportarSIA = ISNULL(ExportarSIA, 0), @SIABaseDatos = SIABaseDatos FROM EmpresaMFA WITH (NOLOCK)  WHERE Empresa = @Empresa
SELECT @moneda = ContMoneda FROM EmpresaCfg WITH (NOLOCK)  WHERE Empresa = @Empresa
TRUNCATE TABLE layout_polizas
INSERT layout_polizas(empresa, ejercicio, periodo, cuenta_contable, cargos, abonos)
SELECT empresa, ejercicio, periodo, cuenta_contable, cargos, abonos
FROM MFAPoliza WITH (NOLOCK) 
WHERE ejercicio = @ejercicio
AND periodo   = @periodo
EXEC spMFACuentasContablesSaldo @empresa, @ejercicio, @periodo, @moneda
EXEC spMFACuentasComplementarias @Usuario, @Empresa, @Ejercicio, @Periodo
EXEC sp_layout_importar_cuentas @usuario
EXEC sp_layout_importar_polizas @usuario
EXEC @log_id = sp_layout_procesar @Usuario, @Empresa, @Ejercicio, @Periodo, 'contabilidad'
IF @EnSilencio = 0
BEGIN
SELECT * FROM layout_log WITH (NOLOCK)  WHERE log_id = @log_id
SELECT * FROM layout_logd WITH (NOLOCK)  WHERE log_id = @log_id
END
IF @ExportarSIA = 1
EXEC spMFASIALayoutImportar_Cuentas @Usuario, @Empresa, @Ejercicio, @Periodo, @SIABaseIndependiente, @SIABaseDatos
EXEC spMFALayoutImportar_CostoVentas @Usuario, @Empresa, @Ejercicio, @Periodo
RETURN
END

