SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDROP_VIEW
@Vista 	varchar(100),
@Version	int	 = NULL

AS BEGIN
IF @Version IS NOT NULL
IF (select version from version)>@Version
RETURN
if exists (select * from sysobjects where id = object_id(@Vista) and sysstat & 0xf = 2)
EXEC('DROP VIEW '+@Vista)
END

