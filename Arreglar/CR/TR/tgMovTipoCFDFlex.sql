SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgMovTipoCFDFlex ON MovTipoCFDFlex
FOR DELETE
AS
BEGIN
DECLARE @Modulo	varchar(5),
@Mov		varchar(20) ,
@Contacto varchar(10)
SELECT @Modulo = Modulo, @Mov = Mov, @Contacto = Contacto FROM deleted
DELETE FROM MovTipoCFDFlexEstatus WHERE Modulo = @Modulo AND Mov = @Mov AND Contacto = @Contacto
RETURN
END

