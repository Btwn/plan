SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpAgendaAbrir
@EstacionTrabajo	int
AS BEGIN
DECLARE
@Ok 	bit,
@OkRef	varchar(255),
@OkDesc	varchar(255),
@OkTipo	varchar(50)		
SELECT @Ok = NULL, @OkRef = NULL, @OkDesc = NULL, @OkTipo = NULL
SELECT "Ok" = @Ok, "OkRef" = @OkRef, "OkDesc" = @OkDesc, "OkTipo" = @OkTipo
RETURN
END

