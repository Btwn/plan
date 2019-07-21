SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocBorrarSiOpcional
(
@CampoXML		varchar(MAX),
@Atributo		bit
)

AS
BEGIN
DECLARE @BorrarSiOpcional varchar(MAX)
SET @Atributo = ISNULL(@Atributo,0)
SET @BorrarSiOpcional = RTRIM(REPLACE(REPLACE(@CampoXML,']',''),'[',''))
IF @Atributo = 0
SET @BorrarSiOpcional = '<' + @BorrarSiOpcional + '></' + @BorrarSiOpcional + '>'
ELSE IF @Atributo = 1
SET @BorrarSiOpcional = @BorrarSiOpcional + '=""'
SELECT @BorrarSiOpcional
END

