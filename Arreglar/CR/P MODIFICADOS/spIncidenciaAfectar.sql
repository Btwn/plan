SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spIncidenciaAfectar
@ID                int,
@Accion			      char(20),
@Empresa	      		char(5),
@Modulo	      		char(5),
@Mov	  	      		char(20),
@MovID             varchar(20)	OUTPUT,
@MovTipo     		  char(20),
@MovMoneda			    char(10),
@MovTipoCambio		  float,
@FechaEmision      datetime,
@FechaAfectacion   datetime,
@FechaConclusion		datetime,
@Proyecto	      	varchar(50),
@Usuario	      		char(10),
@Autorizacion      char(10),
@DocFuente	      	int,
@Observaciones     varchar(255),
@Concepto     		  varchar(50),
@Referencia			  varchar(50),
@Estatus           char(15),
@EstatusNuevo	    char(15),
@FechaRegistro     datetime,
@Ejercicio	      	int,
@Periodo	      		int,
@MovUsuario			  char(10),
@FechaAplicacion		datetime,
@Personal			    varchar(10),
@NominaConcepto		varchar(10),
@FechaD			      datetime,
@FechaA			      datetime,
@Cantidad			    float,
@Valor			        float,
@Porcentaje			  float,
@Acreedor			    varchar(10),
@Vencimiento			  datetime,
@Repetir			      bit,
@Prorratear			  bit,
@Frecuencia			  varchar(20),
@Veces			        float,
@Conexion			    bit,
@SincroFinal			  bit,
@Sucursal			    int,
@SucursalDestino		int,
@SucursalOrigen		int,
@CfgContX			    bit,
@CfgContXGenerar		char(20),
@GenerarPoliza		  bit,
@Generar			      bit,
@GenerarMov			  char(20),
@GenerarAfectado		bit,
@IDGenerar			    int	     	OUTPUT,
@GenerarMovID	  	varchar(20)	OUTPUT,
@Ok                int          OUTPUT,
@OkRef             varchar(255) OUTPUT

AS BEGIN
DECLARE
@Especial			      varchar(50),
@SubEspecial		    varchar(50),
@Fecha			        datetime,
@TieneSubConceptos	bit,
@NominaSubConcepto	varchar(10),
@FechaCancelacion		datetime,
@GenerarMovTipo		  char(20),
@GenerarPeriodo		  int,
@GenerarEjercicio		int,
@CantidadSUB		    float,
@ValorSUB			      float,
@PorcentajeSUB		  float,
@AcreedorSUB        varchar(10),
@VencimientoSUB		  varchar(10)
EXEC spMovConsecutivo @Sucursal, @SucursalOrigen, @SucursalDestino, @Empresa, @Usuario, @Modulo, @Ejercicio, @Periodo, @ID, @Mov, NULL, @Estatus, @Concepto, @Accion, @Conexion, @SincroFinal, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Estatus IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR') AND @Accion <> 'CANCELAR' AND @Ok IS NULL
EXEC spMovChecarConsecutivo	@Empresa, @Modulo, @Mov, @MovID, NULL, @Ejercicio, @Periodo, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion IN ('CONSECUTIVO', 'SINCRO') AND @Ok IS NULL
BEGIN
IF @Accion = 'SINCRO' EXEC spAsignarSucursalEstatus @ID, @Modulo, @SucursalDestino, @Accion
SELECT @Ok = 80060, @OkRef = @MovID
RETURN
END
IF @OK IS NOT NULL RETURN
IF @Accion = 'GENERAR' AND @Ok IS NULL
BEGIN
EXEC spMovGenerar @Sucursal, @Empresa, @Modulo, @Ejercicio, @Periodo, @Usuario, @FechaRegistro, 'SINAFECTAR',
NULL, NULL,
@Mov, @MovID, 0,
@GenerarMov, NULL, @GenerarMovID OUTPUT, @IDGenerar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC spMovTipo @Modulo, @GenerarMov, @FechaAfectacion, NULL, NULL, NULL, @GenerarMovTipo OUTPUT, @GenerarPeriodo OUTPUT, @GenerarEjercicio OUTPUT, @Ok OUTPUT
IF @Ok IS NULL SELECT @Ok = 80030
RETURN
END
IF @Conexion = 0
BEGIN TRANSACTION
EXEC spMovEstatus @Modulo, 'AFECTANDO', @ID, @Generar, @IDGenerar, @GenerarAfectado, @Ok OUTPUT
IF @Accion <> 'CANCELAR'
EXEC spRegistrarMovimiento @Sucursal, @Empresa, @Modulo, @Mov, @MovID, @ID, @Ejercicio, @Periodo, @FechaRegistro, @FechaEmision,
NULL, @Proyecto, @MovMoneda, @MovTipoCambio,
@Usuario, @Autorizacion, NULL, @DocFuente, @Observaciones,
@Generar, @GenerarMov, @GenerarMovID, @IDGenerar,
@Ok OUTPUT
IF @Accion IN ('AFECTAR', 'CANCELAR')
BEGIN
SELECT @Especial = Especial, @TieneSubConceptos = TieneSubConceptos
FROM NominaConcepto
WITH(NOLOCK) WHERE NominaConcepto = @NominaConcepto
IF @Accion = 'AFECTAR'
BEGIN
DELETE IncidenciaD WHERE ID = @ID
EXEC spIncidenciaGenerar @ID, @NominaConcepto, @Empresa, @Sucursal, @Usuario, @MovMoneda, @MovTipoCambio, @Personal, @FechaEmision, @FechaAplicacion, @Referencia, @FechaD, @FechaA, @Cantidad, @Valor, @Porcentaje, @Acreedor, @Vencimiento, @Repetir, @Prorratear, @Frecuencia, @Veces, @Especial, @Ok OUTPUT, @OkRef OUTPUT
IF @TieneSubConceptos = 1
BEGIN
DECLARE crNominaSubConcepto CURSOR LOCAL FOR
SELECT sub.NominaSubConcepto, nc.Especial
FROM NominaSubConcepto sub
 WITH(NOLOCK) JOIN NominaConcepto nc  WITH(NOLOCK) ON nc.NominaConcepto = sub.NominaSubConcepto
WHERE sub.NominaConcepto = @NominaConcepto
OPEN crNominaSubConcepto
FETCH NEXT FROM crNominaSubConcepto  INTO @NominaSubConcepto, @SubEspecial
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spIncidenciaBase @Empresa, @FechaEmision,	@FechaAplicacion	,		@Personal,
@NominaSubConcepto, 1,
@Cantidad,	@ValorSUB     OUTPUT,
@PorcentajeSUB		 OUTPUT,
@AcreedorSUB       OUTPUT,
@VencimientoSUB		 OUTPUT 
if @ValorSUB <> 0
EXEC spIncidenciaGenerar @ID, @NominaSubConcepto, @Empresa, @Sucursal, @Usuario, @MovMoneda, @MovTipoCambio, @Personal, @FechaEmision, @FechaAplicacion, @Referencia, @FechaD, @FechaA,
@Cantidad, @ValorSUB, @PorcentajeSUB, @AcreedorSUB, @VencimientoSUB, @Repetir, @Prorratear, @Frecuencia, @Veces, @SubEspecial, @Ok OUTPUT, @OkRef OUTPUT
END
FETCH NEXT FROM crNominaSubConcepto  INTO @NominaSubConcepto, @SubEspecial
END
CLOSE crNominaSubConcepto
DEALLOCATE crNominaSubConcepto
END
END
IF @Ok IN (NULL, 80030)
BEGIN
IF @EstatusNuevo = 'CANCELADO' SELECT @FechaCancelacion = @FechaRegistro ELSE SELECT @FechaCancelacion = NULL
IF @EstatusNuevo = 'CONCLUIDO' SELECT @FechaConclusion  = @FechaEmision  ELSE IF @EstatusNuevo <> 'CANCELADO' SELECT @FechaConclusion  = NULL
IF @CfgContX = 1 AND @CfgContXGenerar <> 'NO'
BEGIN
IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @EstatusNuevo <> 'CANCELADO' SELECT @GenerarPoliza = 1 ELSE
IF @Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR') AND @EstatusNuevo =  'CANCELADO' IF @GenerarPoliza = 1 SELECT @GenerarPoliza = 0 ELSE SELECT @GenerarPoliza = 1
END
EXEC spValidarTareas @Empresa, @Modulo, @ID, @EstatusNuevo, @Ok OUTPUT, @OkRef OUTPUT
UPDATE Incidencia
 WITH(ROWLOCK) SET FechaConclusion  = @FechaConclusion,
FechaCancelacion = @FechaCancelacion,
UltimoCambio     = CASE WHEN UltimoCambio IS NULL THEN @FechaRegistro ELSE UltimoCambio END,
Estatus          = @EstatusNuevo,
Situacion      	= CASE WHEN @Estatus<>@EstatusNuevo THEN NULL ELSE Situacion END,
GenerarPoliza    = @GenerarPoliza,
PersonalSucursal = CASE @Accion WHEN 'AFECTAR' THEN (SELECT SucursalTrabajo FROM Personal WITH(NOLOCK) WHERE Personal = @Personal) ELSE PersonalSucursal END
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Accion = 'AFECTAR'
BEGIN
/*          SELECT TOP 1 d.FechaAplicacion
FROM IncidenciaD d
 WITH(NOLOCK) JOIN NominaConcepto nc  WITH(NOLOCK) ON nc.NominaConcepto = d.NominaConcepto AND nc.Especial IN ('Faltas', 'Incapacidades')
JOIN Incidencia i  WITH(NOLOCK) ON i.ID = d.ID AND i.Empresa = @Empresa AND i.Personal = @Personal AND i.Estatus IN ('PENDIENTE', 'CONCLUIDO')
GROUP BY d.FechaAplicacion
ORDER BY d.FechaAplicacion*/
SELECT @Fecha = NULL
/*          SELECT TOP 1 @Fecha = d.FechaAplicacion
FROM IncidenciaD d
 WITH(NOLOCK) JOIN NominaConcepto nc  WITH(NOLOCK) ON nc.NominaConcepto = d.NominaConcepto AND nc.Especial IN ('Faltas', 'Incapacidades')
JOIN Incidencia i  WITH(NOLOCK) ON i.ID = d.ID AND i.Empresa = @Empresa AND i.Personal = @Personal AND i.Estatus IN ('PENDIENTE', 'CONCLUIDO') AND i.id <> @ID
GROUP BY d.FechaAplicacion
HAVING ABS(SUM(d.Cantidad)) > 1
ORDER BY d.FechaAplicacion
*/
IF @Fecha IS NOT NULL
SELECT @Ok = 30700, @OkRef = RTRIM(@Personal)+' - '+@NominaConcepto+' ('+CONVERT(varchar, @Fecha, 103)+')'
END
END
END
IF @Acreedor IS NOT NULL
BEGIN
IF (SELECT TieneMovimientos FROM Prov WITH(NOLOCK) WHERE Proveedor = @Acreedor) = 0
UPDATE Prov  WITH(ROWLOCK) SET TieneMovimientos = 1 WHERE Proveedor = @Acreedor
END
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
EXEC spMovFinal @Empresa, @Sucursal, @Modulo, @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Accion = 'CANCELAR' AND @EstatusNuevo = 'CANCELADO' AND @Ok IS NULL
EXEC spCancelarFlujo @Empresa, @Modulo, @ID, @Ok OUTPUT
IF @Conexion = 0
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
RETURN
END

