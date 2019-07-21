SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexInsertarAddendaCFDI
@CFDISinAddenda				varchar(max),
@Addenda					varchar(max),
@CFDI						varchar(max) OUTPUT

AS BEGIN
SET @Addenda = REPLACE(@Addenda,'xmlns:cfdi="http' + CHAR(58) + '//www.sat.gob.mx/cfd/3"','')
SET @Addenda = @Addenda + '</cfdi' + CHAR(58) + 'Comprobante>'
SET @CFDI = REPLACE(@CFDISinAddenda,'</cfdi' + CHAR(58) + 'Comprobante>',@Addenda)
END

