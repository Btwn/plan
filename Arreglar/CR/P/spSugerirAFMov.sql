SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSugerirAFMov
@Empresa	char(5),
@Sucursal	int,
@Usuario	char(10),
@FechaEmision	datetime,
@Mov		char(20)

AS BEGIN
DECLARE
@ID			int,
@Moneda		char(10),
@TipoCambio		float,
@Ok			int,
@OkRef		varchar(255),
@Mensaje		varchar(255)
SELECT @Ok = NULL, @OkRef = NULL
BEGIN TRANSACTION
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg, Mon m
WHERE cfg.Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
INSERT ActivoFijo (Empresa,  Mov,  FechaEmision,  Usuario,  Moneda,  TipoCambio,  Estatus,      Todo, Revaluar)
VALUES (@Empresa, @Mov, @FechaEmision, @Usuario, @Moneda, @TipoCambio, 'SINAFECTAR', 1,    0)
SELECT @ID = SCOPE_IDENTITY()
EXEC spAfectar 'AF', @ID, @Usuario = @Usuario, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
SELECT @Mensaje = RTRIM(@Mov)+' Generado con Exito.'
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT @Mensaje = Descripcion+' '+RTRIM(ISNULL(@OkRef, '')) FROM MensajeLista WHERE Mensaje = @Ok
END
SELECT @Mensaje
RETURN
END

