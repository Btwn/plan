SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGestionCancelarHijos
@ID                  	int,
@Modulo	      		char(5),
@Accion			char(20),
@Base			char(20),
@FechaRegistro		datetime,
@GenerarMov			char(20),
@Usuario			char(10),
@Conexion			bit,
@SincroFinal			bit,
@Mov	      			char(20)	OUTPUT,
@MovID            		varchar(20)	OUTPUT,
@IDGenerar			int		OUTPUT,
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@CancelarID	int
BEGIN TRANSACTION
DECLARE crGestionCancelar CURSOR FOR
SELECT g.ID
FROM Gestion g
 WITH(NOLOCK) JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = @Modulo AND mt.Mov = g.Mov
WHERE g.IDOrigen = @ID AND g.Estatus IN ('PENDIENTE', 'ALTAPRIORIDAD', 'PRIORIDADBAJA', 'CONCLUIDO')
OPEN crGestionCancelar
FETCH NEXT FROM crGestionCancelar  INTO @CancelarID
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
EXEC spAfectar @Modulo, @CancelarID, 'CANCELAR', @Usuario = @Usuario, @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
FETCH NEXT FROM crGestionCancelar  INTO @CancelarID
END
CLOSE crGestionCancelar
DEALLOCATE crGestionCancelar
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
RETURN
END

