SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnPOSValidaSerieLote (
@ID   varchar(36)
)
RETURNS bit

AS
BEGIN
DECLARE
@Resultado            bit,
@MovClave             varchar(20),
@SubMovClave          varchar(20)
SELECT @MovClave = mt.Clave, @SubMovClave = mt.Subclave
FROM MovTipo mt JOIN POSL p ON mt.Mov = p.Mov AND mt.Modulo = 'POS'
WHERE p.ID = @ID
SELECT @Resultado    = 0
IF ((@MovClave <> 'POS.P')AND ( NULLIF(@SubMovClave,'') NOT IN ('POS.PEDCONT', 'POS.N')) OR
(@MovClave = 'POS.P' AND NULLIF(@SubMovClave,'') IN('POS.FACCRED','POS.DEVCRED')))
IF EXISTS(SELECT * FROM POSSerieLoteTemp WHERE ID = @ID AND ISNULL(Cantidad,0.0) <> ISNULL(SerieLote,0.0))
SELECT @Resultado = 1
IF EXISTS(SELECT * FROM POSLSerieLote WHERE ID = @ID)
SELECT @Resultado = 0
RETURN (@Resultado)
END

