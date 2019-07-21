SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpInterfacesAntesAfectar
@Modulo          char(5),
@ID              int,
@Accion          char(20),
@Base            char(20),
@GenerarMov      char(20),
@Usuario         char(10),
@SincroFinal     bit,
@EnSilencio      bit,
@Ok              int             OUTPUT,
@OkRef           varchar(255)    OUTPUT,
@FechaRegistro   datetime
AS BEGIN
RETURN
END

