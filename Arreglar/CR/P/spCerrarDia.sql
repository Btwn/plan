SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCerrarDia
@Empresa	 char(5),
@Sucursal	 int,
@Fecha	 datetime     = NULL,
@Usuario	 char(10)     = NULL,
@Estacion	 int	      = NULL,
@EnSilencio	 bit	      = 0,
@Ok		 int	      = NULL OUTPUT,
@OkRef	 varchar(255) = NULL OUTPUT,
@Debug	 bit	      = 0

AS BEGIN
DECLARE
@AC							bit,
@PC							bit,
@OFER						bit,
@PPTO						bit,
@CMP						bit,
@PACTO						bit,
@PM							bit,
@FechaTrabajo 				datetime,
@DiasHabiles  				char(20),
@CerrarSucursalAuto				bit,
@CxcCaducidadTarjeta			bit,			
@CxcCaducidadTarjetaFecha			datetime,		
@Moneda					varchar(10),	
@TipoCambio					float,			
@Articulo					varchar(20),	
@Almacen					varchar(20),	
@UEN					int,
@EsEcuador					bit,
@TipoImpuesto				bit,
@Notificacion				bit, 
@Corte						bit
SELECT @EsEcuador = ISNULL(EsEcuador,0) FROM Empresa WHERE Empresa = @Empresa
SELECT @FechaTrabajo = NULL
IF @Fecha IS NULL SELECT @Fecha = GETDATE()
SELECT @AC = ISNULL(AC, 0),
@PC = ISNULL(PC, 0),
@OFER = ISNULL(OFER, 0),
@PPTO = ISNULL(PPTO, 0),
@CMP = ISNULL(CMP, 0),
@PACTO = ISNULL(PACTO, 0),
@PM = ISNULL(PM, 0),
@CerrarSucursalAuto = ISNULL(CerrarSucursalAuto, 0),
@DiasHabiles = UPPER(ISNULL(DiasHabiles, 'LUN-VIE')),
@TipoImpuesto = ISNULL(TipoImpuesto,0),
@Notificacion = ISNULL(Notificacion,0), 
@Corte	= ISNULL(Corte,0)
FROM EmpresaGral
WHERE Empresa = @Empresa
SELECT @CxcCaducidadTarjeta = CxcCaducidadTarjeta,
@CxcCaducidadTarjetaFecha = CxcCaducidadTarjetaFecha
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @CerrarSucursalAuto = 1
BEGIN
IF @Ok IS NULL EXEC spCerrarSucursalCajas  @Estacion, @Empresa, @Sucursal, @Usuario, @Fecha, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL EXEC spCerrarSucursalVentas @Estacion, @Empresa, @Sucursal, @Usuario, @Fecha, @Ok OUTPUT, @OkRef OUTPUT
END
IF EXISTS(SELECT * FROM CtaDinero c, CtaDineroCajero j WHERE c.CtaDinero = j.CtaDinero AND c.Sucursal = @Sucursal AND j.Cajero IS NOT NULL) AND @Ok IS NULL
SELECT @Ok = 22010
IF EXISTS(SELECT * FROM Venta WHERE Estatus = 'PROCESAR' AND Sucursal = @Sucursal) AND @Ok IS NULL
SELECT @Ok = 22020
IF @Ok IS NULL
EXEC xpCerrarDia @Empresa, @Fecha, @Ok OUTPUT
IF @Ok IS NULL
BEGIN
EXEC spExtraerFecha @Fecha OUTPUT
SELECT @FechaTrabajo = FechaTrabajo FROM FechaTrabajo WHERE Empresa = @Empresa AND Sucursal = @Sucursal
IF @FechaTrabajo IS NULL
SELECT @FechaTrabajo = @Fecha
ELSE
IF @FechaTrabajo = @Fecha EXEC spCalcularDiasHabiles @Fecha, 1, @DiasHabiles, 0, @Fecha OUTPUT
IF @Sucursal = 0
EXEC spCtaSituacionProg @Empresa, @Sucursal, @Fecha, @Ok OUTPUT, @OkRef OUTPUT
BEGIN TRANSACTION
IF @Ok IS NULL
EXEC spDineroGenerarIntereses @Sucursal, @Empresa, @Usuario, @FechaTrabajo, @Fecha, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @AC = 1
EXEC spACCerrarDia @Sucursal, @Empresa, @Usuario, @FechaTrabajo, @Fecha, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @PC = 1
EXEC spPCCerrarDia @Fecha, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @OFER = 1
EXEC spOfertaCerrarDia @Fecha, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @CMP = 1
EXEC spCampanaCerrarDia @Sucursal, @Empresa, @Usuario, @FechaTrabajo, @Fecha, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @PPTO = 1
EXEC spPresupuestoCerrarDia @Sucursal, @Empresa, @Usuario, @FechaTrabajo, @Fecha, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spGastoConcluirPresupuestos @Empresa
/*IF @Ok IS NULL
EXEC spGenerarIntereses @Sucursal, @Empresa, @Usuario, @FechaTrabajo, @Fecha, @Ok OUTPUT, @OkRef OUTPUT*/
IF @Ok IS NULL AND @PACTO = 1																	
EXEC spContratoCerrarDia @Fecha, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @PM = 1
EXEC spProyectoCerrarDia @Sucursal, @Empresa, @Usuario, @FechaTrabajo, @Fecha, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @Sucursal = 0 AND @CxcCaducidadTarjeta = 1 AND dbo.fnFechaSinHora(@Fecha) = dbo.fnFechaSinHora(@CxcCaducidadTarjetaFecha)
BEGIN
EXEC spValeCancelaSaldosTarjetas @Empresa, @Usuario, @Sucursal, @FechaTrabajo, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF @Ok IS NULL AND @EsEcuador = 1
BEGIN
EXEC spTipoComprobanteCerrarDia @Fecha, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spSustentoComprobanteCerrarDia @Fecha, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spTipoRegistroCerrarDia @Fecha, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL AND @TipoImpuesto = 1
EXEC spTipoImpuestoCerrarDia @Fecha, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @Notificacion = 1 
EXEC spNotificacionCerrarDia @Sucursal, @Empresa, @Usuario, @Fecha, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL AND @Corte = 1
EXEC spCorteCerrarDia @Sucursal, @Empresa, @Usuario, @Fecha, @Estacion, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
UPDATE FechaTrabajo
SET FechaTrabajo = @Fecha
WHERE Empresa = @Empresa AND Sucursal = @Sucursal
IF @@ROWCOUNT = 0
INSERT FechaTrabajo (Empresa, Sucursal, FechaTrabajo) VALUES (@Empresa, @Sucursal, @Fecha)
END
IF @Debug = 1
ROLLBACK TRANSACTION
ELSE
COMMIT TRANSACTION
END
IF @Ok IS NULL
EXEC xpCerrarDiaFinal @Empresa, @Fecha, @Ok OUTPUT
IF @EnSilencio = 0
BEGIN
IF @Ok IS NULL
BEGIN
SELECT @OkRef = 'Sucursal Cerrada.'
SELECT @OkRef
END ELSE
BEGIN
SELECT Descripcion+' '+RTRIM(@OkRef)
FROM MensajeLista
WHERE Mensaje = @Ok
END
END
RETURN
END

