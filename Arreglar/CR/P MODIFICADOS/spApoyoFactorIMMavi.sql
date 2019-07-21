SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spApoyoFactorIMMavi
@ID			int

AS BEGIN
DECLARE @FechaOriginal	datetime,
@FechaEmision	datetime
SELECT @FechaOriginal = FechaOriginal, @FechaEmision = FechaEmision FROM CXC WITH(NOLOCK) where Id = @ID
IF @FechaOriginal IS NULL
UPDATE Cxc WITH(ROWLOCK) SET FechaOriginal = @FechaEmision where Id = @ID
RETURN
END

