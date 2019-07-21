SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSMovNavega
@ID				varchar(36) OUTPUT,
@Usuario        varchar(10),
@EnSilencio		bit = 0

AS
BEGIN
DECLARE
@IDSiguiente	varchar(36),
@Host			varchar(20),
@Cluster		varchar(20),
@Caja			varchar(10),
@MovClave		varchar(20)
SELECT @Caja = CtaDinero
FROM POSL WITH (NOLOCK)
WHERE ID = @ID
EXEC spPOSHost @Host OUTPUT, @Cluster OUTPUT
SELECT TOP 1 @IDSiguiente = posl.ID
FROM POSL posl WITH (NOLOCK)
INNER JOIN MovTipo mt WITH (NOLOCK) ON posl.Mov = mt.Mov
AND mt.Modulo = 'POS'
WHERE posl.Host = @Host
AND posl.Usuario = @Usuario
AND (posl.Ctadinero = @Caja OR posl.CtaDineroDestino = @Caja)
AND posl.ID > @ID
AND ISNULL(posl.Estatus, 'SINAFECTAR') = 'SINAFECTAR'
ORDER BY posl.ID ASC
IF @IDSiguiente IS NULL
SELECT @IDSiguiente = MIN(posl.ID)
FROM POSL posl WITH (NOLOCK)
INNER JOIN MovTipo mt WITH (NOLOCK) ON posl.Mov = mt.Mov
AND mt.Modulo = 'POS'
WHERE posl.Host = @Host
AND posl.Usuario = @Usuario
AND (posl.Ctadinero = @Caja OR posl.CtaDineroDestino = @Caja)
AND ISNULL(posl.Estatus, 'SINAFECTAR') = 'SINAFECTAR'
IF @EnSilencio = 0
SELECT @IDSiguiente
END

