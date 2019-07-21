SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spActualizaTiemposMAVI]
@Modulo		char(5),
@ID         int,
@Accion		char(20),
@Usuario	char(10)

AS  BEGIN
DECLARE
@Origen	char(20),
@OrigenID	char(20),
@IDOrigen	int
IF @Accion = 'CANCELAR'
UPDATE MovTiempo WITH(ROWLOCK) Set Usuario = @Usuario WHERE Modulo = @Modulo AND ID = @ID AND Estatus = 'CANCELADO'
IF @Accion = 'AFECTAR' AND @Modulo = 'VTAS'
BEGIN
Select @Origen = Venta.Origen , @OrigenID = Venta.OrigenID  From Venta WITH(NOLOCK) Where Venta.ID=@ID
Select @IDOrigen = v.ID From Venta v WITH(NOLOCK) Where v.Mov = @Origen AND v.MovID = @OrigenID
UPDATE MovTiempo WITH(ROWLOCK) Set Usuario = @Usuario WHERE Modulo = @Modulo AND ID = @IDOrigen AND Estatus = 'CONCLUIDO'
END
END

