SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpValidarCamposCFDFlex
@Modulo      varchar(5),
@ID          int,
@Ok          int             OUTPUT,
@OkRef       varchar(255)    OUTPUT
AS BEGIN
RETURN
END

