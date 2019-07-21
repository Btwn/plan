SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSPIDTemp
@Monetario	money		= NULL,
@Flotante	float		= NULL,
@Numerico	int		= NULL,
@Texto		varchar(255)	= NULL,
@Fecha		datetime	= NULL

AS BEGIN
UPDATE SPIDTemp
SET Monetario = @Monetario,
Flotante  = @Flotante,
Numerico  = @Numerico,
Texto	   = @Texto,
Fecha     = @Fecha
WHERE SPID = @@SPID
IF @@ROWCOUNT = 0
INSERT SPIDTemp (
SPID,   Monetario,  Flotante,  Numerico,  Texto,  Fecha)
VALUES (@@SPID, @Monetario, @Flotante, @Numerico, @Texto, @Fecha)
RETURN
END

