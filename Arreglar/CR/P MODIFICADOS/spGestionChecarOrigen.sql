SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGestionChecarOrigen
@ID		int,
@FechaA	datetime,
@Ok		int          OUTPUT,
@OkRef	varchar(255) OUTPUT

AS BEGIN
DECLARE
@IDOrigen		int,
@OrigenFechaA	datetime,
@OrigenMov		varchar(20),
@OrigenMovID	varchar(20),
@OrigenMovTipo	varchar(20)/*,
@MovTipo		varchar(20)*/
IF @ID IS NULL RETURN
SELECT @IDOrigen = g.IDOrigen, @OrigenMov = g.Mov, @OrigenMovID = g.MovID, @OrigenFechaA = g.FechaA, @OrigenMovTipo = mt.Clave
FROM Gestion g
 WITH(NOLOCK) JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = 'GES' AND mt.Mov = g.Mov
WHERE g.ID = @ID
IF @OrigenMovTipo IN (/*'GES.REU',*/ 'GES.STAR', 'GES.OTAR', 'GES.TAR') AND @OrigenFechaA IS NOT NULL AND @FechaA > @OrigenFechaA
SELECT @Ok = 46140, @OkRef = @OrigenMov+' '+@OrigenMovID
IF @IDOrigen IS NOT NULL AND @Ok IS NULL
EXEC spGestionChecarOrigen @IDOrigen, @FechaA, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

