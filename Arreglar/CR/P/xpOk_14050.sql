SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpOk_14050
@Empresa	char(5),
@Usuario	char(10),
@Accion		char(20),
@Modulo		char(5),
@MovTipo    char(20),
@Mov	  	char(20),
@Estatus	char(15),
@Actividad	varchar(50),
@Ok         int				OUTPUT,
@OkRef      varchar(255)	OUTPUT
AS BEGIN
RETURN
END

