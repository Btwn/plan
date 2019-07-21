SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaH
@Estacion	int,
@Sucursal	int,
@Empresa	char(5),
@Usuario	char(10)

AS BEGIN
DECLARE
@ID			int,
@IDGenerar		int,
@Mov		char(20),
@MovID		varchar(20),
@FechaEmision	datetime,
@FechaRegistro	datetime,
@Concepto		varchar(50),
@Moneda		char(10),
@TipoCambio		float,
@Ok			int,
@OkRef		varchar(255),
@Conteo		int,
@Mensaje		varchar(255),
@Proyecto		varchar(50),
@UEN		int
SELECT @FechaRegistro = GETDATE(), @Ok = NULL, @OkRef = NULL, @Conteo = 0
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg, Mon m
WHERE cfg.Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
SELECT @Proyecto = DefProyecto, @UEN = UEN FROM Usuario WHERE Usuario = @Usuario
BEGIN TRANSACTION
DECLARE crNominaH CURSOR FOR
SELECT Mov, FechaEmision, NULLIF(RTRIM(Concepto), '')
FROM NominaH
WHERE Estacion = @Estacion AND Empresa = @Empresa
GROUP BY Mov, FechaEmision, NULLIF(RTRIM(Concepto), '')
ORDER BY Mov, FechaEmision, NULLIF(RTRIM(Concepto), '')
OPEN crNominaH
FETCH NEXT FROM crNominaH INTO @Mov, @FechaEmision, @Concepto
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
INSERT Nomina (Sucursal,  SucursalOrigen, Empresa,  Mov,  FechaEmision,  FechaOrigen,   Usuario,  Moneda,  TipoCambio,  Estatus,     Proyecto,  UEN,  Concepto)
VALUES (@Sucursal, @Sucursal,      @Empresa, @Mov, @FechaEmision, @FechaEmision, @Usuario, @Moneda, @TipoCambio, 'CONFIRMAR', @Proyecto, @UEN, @Concepto)
SELECT @ID = SCOPE_IDENTITY()
EXEC spNominaHD @Estacion, @Empresa, @ID, @Mov, @FechaEmision, @Concepto
EXEC xpNominaH @Estacion, @ID, @Ok OUTPUT, @OkRef OUTPUT
IF @ID IS NOT NULL
EXEC spNomina @ID, 'NOM', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @Mov, @MovID OUTPUT, @IDGenerar, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
DELETE NominaH WHERE Estacion = @Estacion AND Empresa = @Empresa AND Mov = @Mov AND FechaEmision = @FechaEmision AND ISNULL(Concepto, '') = ISNULL(@Concepto, '')
SELECT @Conteo = @Conteo + 1
END
END
FETCH NEXT FROM crNominaH INTO @Mov, @FechaEmision, @Concepto
END  
CLOSE crNominaH
DEALLOCATE crNominaH
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
SELECT @Mensaje = CONVERT(varchar, @Conteo)+' Movimientos Generados.'
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT @Mensaje = RTRIM(Descripcion)+' '+@OkRef FROM MensajeLista WHERE Mensaje = @Ok
END
SELECT @Mensaje
RETURN
END

