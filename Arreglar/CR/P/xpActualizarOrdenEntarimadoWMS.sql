SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpActualizarOrdenEntarimadoWMS
@OrdenID    int,
@ID         int,
@Accion 	varchar(20),
@Modulo		varchar(5),
@Posicion	varchar(10),
@PosicionD  varchar(10)
AS BEGIN
RETURN
END

