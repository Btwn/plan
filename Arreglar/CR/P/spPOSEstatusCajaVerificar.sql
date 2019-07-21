SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSEstatusCajaVerificar
@ID			varchar(36),
@Caja			varchar(10),
@Cajero		varchar(10),
@Accion        varchar(20),
@Abierto		bit	OUTPUT

AS
BEGIN
SELECT
@Caja = CtaDinero,
@Cajero = Cajero
FROM POSL
WHERE ID = @ID
IF @Accion = 'Abierto'
SELECT @Abierto = pec.Abierto
FROM POSEstatusCaja pec
WHERE pec.Caja = @Caja
AND pec.Cajero = @Cajero
IF @Accion = 'Bloqueado'
SELECT @Abierto = pec.Bloqueado
FROM POSEstatusCaja pec
WHERE pec.Caja = @Caja
AND pec.Cajero = @Cajero
SELECT @Abierto = ISNULL(@Abierto,0)
END

