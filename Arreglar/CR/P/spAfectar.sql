SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAfectar
@Modulo			char(5),
@ID              int,
@Accion			char(20) 	= NULL,  
@Base			char(20) 	= NULL,  
@GenerarMov		char(20) 	= NULL,  
@Usuario			char(10) 	= NULL,  
@SincroFinal		bit	 		= 0,
@EnSilencio	    bit      	= 0,
@Ok              int	 		= NULL OUTPUT,
@OkRef           varchar(255)	= NULL OUTPUT,
@FechaRegistro	datetime	= NULL,
@Conexion		bit			= 0,
@Estacion		int			= NULL,
@FueraLinea		bit			= 0

AS BEGIN
SET nocount ON
DECLARE
@Mov		char(20),	
@MovID		varchar(20),	
@IDGenerar		int,		
@ContID		int,		
@OkDesc           	varchar(255),	
@OkTipo           	varchar(50),    
@VolverAfectar	int,		
@Empresa		char(5),
@Sucursal		int,
@OID		int,
@OMov		char(20),
@OMovID		varchar(20),
@Notificacion			bit, 
@SPID				int,
@ContabilidadParalela	bit,
@CONTP					bit,
@CPCentralizadora		bit
SELECT @ContabilidadParalela = ISNULL(ContabilidadParalela, 0) FROM Version
SELECT @SPID = @@SPID
EXEC spAfectacionUsuario @SPID, @Usuario
SELECT @Modulo	= NULLIF(RTRIM(UPPER(@Modulo)), ''),
@Accion	= NULLIF(RTRIM(UPPER(@Accion)), ''),
@Base		= NULLIF(RTRIM(UPPER(@Base)), ''),
@GenerarMov	= NULLIF(RTRIM(@GenerarMov), ''),
@Mov		= NULL,
@MovID		= NULL,
@IDGenerar	= NULL,
@Ok     	= NULL,
@OkRef  	= NULL,
@OkDesc 	= NULL,
@OkTipo 	= NULL,
@VolverAfectar = 0
SELECT @Empresa = Empresa, @Sucursal = Sucursal FROM Inv WHERE ID = @ID
IF @Accion IS NULL SELECT @Accion = 'AFECTAR'
IF @Accion NOT IN ('AFECTAR', 'GENERAR', 'VERIFICAR', 'CANCELAR', 'RESERVAR', 'RESERVARPARCIAL', 'DESRESERVAR', 'ASIGNAR', 'DESASIGNAR', 'DESAFECTAR', 'CONSECUTIVO', 'AUTORIZAR', 'REFACTURAR')
SELECT @Ok = 60030, @OkRef = 'Acciones Validas (Afectar, Generar, Verificar, Cancelar, Reservar, DesReservar, Asignar, DesAsignar, DesAfectar, Consecutivo, Autorizar, Refacturar)'
IF @Base IS NULL SELECT @Base = 'TODO'
IF @Base NOT IN ('TODO', 'PENDIENTE', 'SELECCION', 'RESERVADO', 'ORDENADO', 'CONCLUIDO', 'DISPONIBLE'/*, 'ENPROCESO', 'SIGUIENTEPASO'*/)
SELECT @Ok = 60030, @OkRef = 'Base (Todo, Pendiente, Seleccion, Reservado, Ordenado, Concluido, Disponible)'
IF @Accion NOT IN ('AFECTAR','VERIFICAR','GENERAR','AUTORIZAR') OR @GenerarMov = '0' SELECT @GenerarMov = NULL
IF @FechaRegistro IS NULL 
BEGIN
SELECT @FechaRegistro = Fecha FROM CFD WHERE Modulo = @Modulo AND ModuloID = @ID
IF @FechaRegistro IS NOT NULL
EXEC spFechaRegistroCFD @Modulo, @ID, @Accion, @FechaRegistro OUTPUT
ELSE
SELECT @FechaRegistro = GETDATE()
END
IF @Accion = 'GENERAR'
IF NOT EXISTS(SELECT * FROM MovTipo WHERE Modulo = @Modulo AND Mov = @GenerarMov)
SELECT @Ok = 70130, @OkRef = @GenerarMov
IF @Ok IS NULL
EXEC xpAntesAfectar @Modulo, @ID, @Accion, @Base, @GenerarMov, @Usuario, @SincroFinal, @EnSilencio, @Ok OUTPUT, @OkRef OUTPUT, @FechaRegistro
IF @Ok IS NULL AND (SELECT IntelMESInterfase FROM EmpresaCfg WHERE Empresa = @Empresa) = 1
EXEC xpMESAntesAfectar @Modulo, @ID, @Accion, @Base, @GenerarMov, @Usuario, @SincroFinal, @EnSilencio, @Ok OUTPUT, @OkRef OUTPUT, @FechaRegistro
IF @Ok IS NULL
EXEC xpInterfacesAntesAfectar @Modulo, @ID, @Accion, @Base, @GenerarMov, @Usuario, @SincroFinal, @EnSilencio, @Ok OUTPUT, @OkRef OUTPUT, @FechaRegistro
IF @Ok IS NULL AND @Accion IN ('AFECTAR', 'VERIFICAR')
EXEC xpMovValidar @Modulo, @ID, @Accion, @Base, @GenerarMov, @Usuario, @SincroFinal, @EnSilencio, @Ok OUTPUT, @OkRef OUTPUT, @FechaRegistro
IF @Accion IN ('AFECTAR', 'CANCELAR') AND @Ok IS NULL AND @FueraLinea = 1
BEGIN
EXEC spValidarFueraLinea @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spAfectarFueraLinea @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
END ELSE
IF @Accion = 'REFACTURAR' AND @Ok IS NULL
BEGIN
EXEC spInvRefacturar @ID, @Usuario, @FechaRegistro, @Ok OUTPUT, @OkRef OUTPUT, @IDGenerar OUTPUT
IF @Ok IS NULL SELECT @Ok = 80030
END ELSE
IF @Modulo = 'CONT' AND @Ok IS NULL
EXEC spCont @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo IN ('VTAS', 'PROD', 'COMS', 'INV') AND @Ok IS NULL
BEGIN
EXEC spInv @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal, NULL,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT, @ContID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @VolverAfectar OUTPUT, @Estacion = @Estacion 
IF @VolverAfectar = 1
EXEC spInv @ID, @Modulo, 'AFECTAR', 'TODO', @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal, NULL,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT, @ContID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @VolverAfectar OUTPUT, @Estacion = @Estacion 
ELSE IF @VolverAfectar = 2
EXEC spInv @ID, @Modulo, 'ASIGNAR', 'PENDIENTE', @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal, NULL,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT, @ContID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @VolverAfectar OUTPUT, @Estacion = @Estacion 
ELSE IF @VolverAfectar = 3 AND @Modulo = 'INV'
BEGIN
SELECT @OID = @ID, @OMov = @Mov, @OMovID = @MovID, @Ok = NULL, @OkRef = NULL
EXEC spInv @IDGenerar, @Modulo, @Accion, 'TODO', @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal, 'TRANSITO',
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT, @ContID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @VolverAfectar OUTPUT, @Estacion = @Estacion 
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @OID, @OMov, @OMovID, @Modulo, @IDGenerar, @Mov, @MovID, @Ok OUTPUT
END ELSE
IF @VolverAfectar = 4 AND @Modulo = 'VTAS'
EXEC spCancelarFacturaReservarPedido @ID, @Usuario, @FechaRegistro, @Ok OUTPUT, @OkRef OUTPUT
ELSE IF @VolverAfectar = 5
EXEC spInv @ID, @Modulo, 'RESERVAR', 'PENDIENTE', @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal, NULL,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT, @ContID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @VolverAfectar OUTPUT, @Estacion = @Estacion 
END ELSE
IF @Modulo IN ('CXC', 'CXP', 'AGENT') AND @Ok IS NULL
EXEC spCx @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @EstacionTrabajo = @Estacion 
ELSE
IF @Modulo = 'DIN' AND @Ok IS NULL
EXEC spDinero @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @EstacionTrabajo = @Estacion 
ELSE
IF @Modulo = 'GAS' AND @Ok IS NULL
EXEC spGasto @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'EMB' AND @Ok IS NULL
EXEC spEmbarque @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'NOM' AND @Ok IS NULL
EXEC spNomina @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'RH' AND @Ok IS NULL
EXEC spRH @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'ASIS' AND @Ok IS NULL
EXEC spAsiste @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'AF' AND @Ok IS NULL
EXEC spActivoFijo @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'ST' AND @Ok IS NULL
EXEC spSoporte @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'PC' AND @Ok IS NULL
EXEC spPC @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'OFER' AND @Ok IS NULL
EXEC spOferta @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'VALE' AND @Ok IS NULL
EXEC spVale @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'CR' AND @Ok IS NULL
EXEC spCR @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'CAM' AND @Ok IS NULL
EXEC spCambio @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'CAP' AND @Ok IS NULL
EXEC spCapital @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'INC' AND @Ok IS NULL
EXEC spIncidencia @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'CONC' AND @Ok IS NULL
EXEC spConciliacion @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'PPTO' AND @Ok IS NULL
EXEC spPresup @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'CREDI' AND @Ok IS NULL
EXEC spCredito @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'TMA' AND @Ok IS NULL 
EXEC spTMA @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'RSS' AND @Ok IS NULL
EXEC spRSS @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'CMP' AND @Ok IS NULL
EXEC spCampana @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'FIS' AND @Ok IS NULL
EXEC spFiscal @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'OPORT' AND @Ok IS NULL
EXEC spOportunidad @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal, @Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'CORTE' AND @Ok IS NULL
EXEC spCorte @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal, @Estacion,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'FRM' AND @Ok IS NULL
EXEC spFormaExtra @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'CAPT' AND @Ok IS NULL
EXEC spCaptura @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'GES' AND @Ok IS NULL
EXEC spGestion @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'CP' AND @Ok IS NULL
EXEC spCP @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'PCP' AND @Ok IS NULL
EXEC spPCP @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'PROY' AND @Ok IS NULL
EXEC spProyecto @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @Estacion = @Estacion
/*ELSE
IF @Modulo = 'ACT' AND @Ok IS NULL
EXEC spAct @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT*/
/*ELSE
IF @Modulo = 'MEX01' AND @Ok IS NULL
EXEC spModuloExtra01 @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT*/
/*ELSE
IF @Modulo = 'MEX02' AND @Ok IS NULL
EXEC spModuloExtra02 @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT*/
/*ELSE
IF @Modulo = 'MEX03' AND @Ok IS NULL
EXEC spModuloExtra03 @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT*/
/*ELSE
IF @Modulo = 'MEX04' AND @Ok IS NULL
EXEC spModuloExtra04 @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT*/
/*ELSE
IF @Modulo = 'MEX05' AND @Ok IS NULL
EXEC spModuloExtra05 @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT*/
/*ELSE
IF @Modulo = 'MEX06' AND @Ok IS NULL
EXEC spModuloExtra06 @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT*/
/*ELSE
IF @Modulo = 'MEX07' AND @Ok IS NULL
EXEC spModuloExtra07 @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT*/
/*ELSE
IF @Modulo = 'MEX08' AND @Ok IS NULL
EXEC spModuloExtra08 @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT*/
/*ELSE
IF @Modulo = 'MEX09' AND @Ok IS NULL
EXEC spModuloExtra09 @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT*/
ELSE
IF @Modulo = 'PREV' AND @Ok IS NULL
EXEC spPrevencionLD @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'ORG' AND @Ok IS NULL
EXEC spOrganiza @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'RE' AND @Ok IS NULL
EXEC spRecluta @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'ISL' AND @Ok IS NULL
EXEC spISL @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'PACTO' AND @Ok IS NULL
EXEC spContrato @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT, @Estacion,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Modulo = 'SAUX' AND @Ok IS NULL
EXEC spSAUX @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @Ok IS NULL
EXEC xpAfectarOtrosModulos @ID, @Modulo, @Accion, @Base, @FechaRegistro, @GenerarMov, @Usuario, @Conexion, @SincroFinal,
@Mov OUTPUT, @MovID OUTPUT, @IDGenerar OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT, @Estacion = @Estacion
IF @Ok <> 80030 SELECT @IDGenerar = NULL
INSERT AfectarBitacora (Modulo,  ModuloID, Accion,  Base,  GenerarMov,  Usuario,  FechaRegistro,  Ok, OkRef)
VALUES (@Modulo, @ID,      @Accion, @Base, @GenerarMov, @Usuario, @FechaRegistro, @Ok, @OkRef)
/*IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC vic_spDespuesAfectar @Modulo, @ID, @Accion, @Base, @GenerarMov, @Usuario, @SincroFinal, @EnSilencio, @Ok OUTPUT, @OkRef OUTPUT, @FechaRegistro*/
IF ((NULLIF(@Ok,0) IS NULL) OR (@Ok BETWEEN 80030 AND 81000)) AND @Accion NOT IN ('GENERAR')
BEGIN
SELECT @Empresa = Empresa FROM Mov WHERE Modulo = @Modulo AND ID = @ID
SELECT @Notificacion = ISNULL(Notificacion,0) FROM EmpresaGral WHERE Empresa = @Empresa
IF @Notificacion = 1
BEGIN
EXEC spNotificacion @ID, @Modulo, @Ok OUTPUT, @OkRef OUTPUT
END
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC xpDespuesAfectar @Modulo, @ID, @Accion, @Base, @GenerarMov, @Usuario, @SincroFinal, @EnSilencio, @Ok OUTPUT, @OkRef OUTPUT, @FechaRegistro
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC xpInterfacesDespuesAfectar @Modulo, @ID, @Accion, @Base, @GenerarMov, @Usuario, @SincroFinal, @EnSilencio, @Ok OUTPUT, @OkRef OUTPUT, @FechaRegistro
IF @EnSilencio = 0
BEGIN
IF @Ok IS NULL
SELECT @OkRef = NULL
ELSE
SELECT @OkDesc = Descripcion,
@OkTipo = Tipo
FROM MensajeLista
WHERE Mensaje = @Ok
SELECT @Ok, @OkDesc, @OkTipo, @OkRef, @IDGenerar
END
RETURN ISNULL(@IDGenerar, 0)
END

