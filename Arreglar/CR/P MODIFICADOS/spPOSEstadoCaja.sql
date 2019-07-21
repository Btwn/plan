SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSEstadoCaja
@ID				varchar(36),
@Usuario		varchar(10)

AS
BEGIN
DECLARE
@EstatusCaja		int,
@Caja				varchar(10),
@Host				varchar(20),
@Cajero				varchar(10),
@Abierto			bit
SELECT @Caja = NULLIF(Caja,''), @Host = NULLIF(Host,''), @Cajero = NULLIF(Cajero,'')
FROM POSL WITH (NOLOCK)
WHERE ID = @ID AND Usuario = @Usuario
IF EXISTS (SELECT * FROM POSEstatusCaja WITH (NOLOCK) WHERE Usuario = @Usuario AND Caja = @Caja AND Host = @Host AND Cajero = @Cajero)
BEGIN
SELECT @Abierto = Abierto
FROM POSEstatusCaja WITH (NOLOCK)
WHERE Usuario = @Usuario
AND Caja = @Caja
AND Host = @Host
AND Cajero = @Cajero
IF @Abierto = 0
SELECT @EstatusCaja = 0
IF @Abierto = 1
SELECT @EstatusCaja = 1
END
ELSE
SELECT @EstatusCaja = 0
SELECT @EstatusCaja
END

