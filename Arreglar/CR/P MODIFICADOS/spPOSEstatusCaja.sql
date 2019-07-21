SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSEstatusCaja
@Caja			varchar(10),
@Host			varchar(20),
@Cajero			varchar(10),
@Usuario		varchar(20),
@Abrir			bit = NULL,
@Bloquear		bit = NULL,
@Ok				int				OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@Abierto	bit
IF @Abrir = 1
BEGIN
SELECT @Abierto = Abierto
FROM POSEstatusCaja WITH (NOLOCK)
WHERE Caja = @Caja
IF ISNULL(@Abierto,0) = 1 AND @Ok IS NULL
BEGIN
SELECT @Ok = 30435, @OkRef = @Caja
END
IF @Ok IS NULL AND ISNULL(@Abierto,0) = 0
BEGIN
IF NOT EXISTS(SELECT * FROM POSEstatusCaja WITH (NOLOCK) WHERE Caja = @Caja)
INSERT POSEstatusCaja (
Caja, Host, Cajero, Usuario, Abierto, Bloqueado)
VALUES (
@Caja, @Host, @Cajero, @Usuario, @Abrir, 0)
ELSE
UPDATE POSEstatusCaja WITH (ROWLOCK)
SET Host = @Host,
Cajero = @Cajero,
Usuario = @Usuario,
Abierto = @Abrir
WHERE Caja = @Caja
END
END
IF @Abrir = 0
BEGIN
IF NOT EXISTS(SELECT * FROM POSEstatusCaja WITH (NOLOCK) WHERE Caja = @Caja)
SELECT @Ok = 30440, @OkRef = @Caja
IF (SELECT Abierto FROM POSEstatusCaja WITH (NOLOCK) WHERE Caja = @Caja) = 0
SELECT @Ok =30440, @OkRef = @Caja
IF @Ok IS NULL
UPDATE POSEstatusCaja WITH (ROWLOCK)
SET Abierto = 0
WHERE Caja = @Caja
END
IF @Bloquear = 1
BEGIN
UPDATE POSEstatusCaja WITH (ROWLOCK)
SET Bloqueado = @Bloquear
WHERE Caja = @Caja  AND Host = @Host AND Cajero = @Cajero
END
IF @Bloquear = 0
BEGIN
UPDATE POSEstatusCaja
SET Bloqueado = @Bloquear
WHERE Caja = @Caja  AND Host = @Host AND Cajero = @Cajero
END
END

