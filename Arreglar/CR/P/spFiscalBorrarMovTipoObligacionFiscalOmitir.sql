SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFiscalBorrarMovTipoObligacionFiscalOmitir
@Modulo		varchar(5),
@Mov		varchar(20)

AS BEGIN
DELETE FROM MovTipoObligacionFiscalOmitir WHERE Modulo = @Modulo AND Mov = @Mov
END

