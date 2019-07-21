SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIncidenciaH
@Estacion	int,
@Sucursal	int,
@Empresa	char(5),
@Usuario	char(10)

AS BEGIN
DECLARE
@ID			int,
@IncidenciaID	int,
@IDGenerar		int,
@Mov		char(20),
@MovID		varchar(20),
@FechaEmision	datetime,
@FechaAplicacion	datetime,
@FechaRegistro	datetime,
@Personal		varchar(10),
@NominaConcepto	varchar(10),
@Referencia		varchar(50),
@Moneda		char(10),
@TipoCambio		float,
@Cantidad		float,
@CantidadBase	float,
@Valor		float,
@Importe		money,
@Porcentaje 	float,
@Acreedor 		varchar(10),
@Vencimiento	datetime,
@FechaD		datetime,
@FechaA		datetime,
@Horas		varchar(5),
@Ok			int,
@OkRef		varchar(255),
@Conteo		int,
@Mensaje		varchar(255),
@Proyecto		varchar(50),
@UEN		int
SELECT @FechaRegistro = GETDATE(), @Ok = NULL, @OkRef = NULL, @Conteo = 0
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg, Mon m
WITH(NOLOCK) WHERE cfg.Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
SELECT @Proyecto = DefProyecto, @UEN = UEN FROM Usuario WITH(NOLOCK) WHERE Usuario = @Usuario
BEGIN TRANSACTION
DECLARE crIncidenciaH CURSOR FOR
SELECT ID, Mov, FechaEmision, NULLIF(RTRIM(NominaConcepto), ''), NULLIF(RTRIM(Referencia), ''), NULLIF(RTRIM(Personal), ''), NULLIF(Cantidad, 0.0), NULLIF(Importe, 0.0), FechaD, FechaA, NULLIF(NULLIF(RTRIM(Horas), ''), '00'+CHAR(58)+'00')
FROM IncidenciaH WITH(NOLOCK)
 WHERE Usuario = @Usuario AND Empresa = @Empresa
OPEN crIncidenciaH
FETCH NEXT FROM crIncidenciaH  INTO @ID, @Mov, @FechaEmision, @NominaConcepto, @Referencia, @Personal, @Cantidad, @Importe, @FechaD, @FechaA, @Horas
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND (@Personal IS NOT NULL AND @NominaConcepto IS NOT NULL)
BEGIN
SELECT @FechaAplicacion = ISNULL(@FechaD, @FechaEmision)
EXEC spIncidenciaBase @Empresa, @FechaEmision, @FechaAplicacion, @Personal, @NominaConcepto,
@EnSilencio = 1, @Cantidad = @CantidadBase OUTPUT, @Valor = @Valor OUTPUT, @Porcentaje = @Porcentaje OUTPUT, @Acreedor = @Acreedor OUTPUT, @Vencimiento = @Vencimiento OUTPUT
IF @Horas IS NOT NULL EXEC spHorasToCantidad @Horas, @Cantidad OUTPUT
IF @Cantidad IS NULL SELECT @Cantidad = @CantidadBase
IF @Importe IS NOT NULL SELECT @Valor = (@Importe / @Cantidad) * ISNULL(NULLIF(@Porcentaje, 0.0), 100.0) / 100.0
INSERT Incidencia (
Sucursal,  SucursalOrigen, Empresa,  Mov,  FechaEmision,  FechaAplicacion,   Usuario,  Moneda,  TipoCambio,  Estatus,      Proyecto,  UEN,  NominaConcepto,  Personal,  Referencia,  Cantidad,  Valor,  Porcentaje,  Acreedor,  Vencimiento,  FechaD,  FechaA)
VALUES (@Sucursal, @Sucursal,      @Empresa, @Mov, @FechaEmision, @FechaAplicacion, @Usuario, @Moneda, @TipoCambio, 'SINAFECTAR', @Proyecto, @UEN, @NominaConcepto, @Personal, @Referencia, @Cantidad, @Valor, @Porcentaje, @Acreedor, @Vencimiento, @FechaD, @FechaA)
SELECT @IncidenciaID = SCOPE_IDENTITY()
EXEC xpIncidenciaH @ID, @IncidenciaID, @Ok OUTPUT, @OkRef OUTPUT
IF @ID IS NOT NULL
EXEC spIncidencia @IncidenciaID, 'INC', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @Mov, @MovID OUTPUT, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
DELETE IncidenciaH WHERE CURRENT OF crIncidenciaH
SELECT @Conteo = @Conteo + 1
END
END
FETCH NEXT FROM crIncidenciaH  INTO @ID, @Mov, @FechaEmision, @NominaConcepto, @Referencia, @Personal, @Cantidad, @Importe, @FechaD, @FechaA, @Horas
END  
CLOSE crIncidenciaH
DEALLOCATE crIncidenciaH
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
SELECT @Mensaje = CONVERT(varchar, @Conteo)+' Movimientos Generados.'
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT @Mensaje = RTRIM(Descripcion)+' '+@OkRef FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
END
SELECT @Mensaje
RETURN
END

