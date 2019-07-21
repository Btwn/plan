SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelCambiaarticulos]

AS BEGIN
UPDATE AspelCargaprop SET
Valor =  C.Nueva
FROM AspelCargaprop A, AspelCambiaclaves C
WHERE ltrim(rtrim(A.Valor)) = ltrim(rtrim(C.Anterior)) And A.CAMPO = 'Articulo'
UPDATE AspelCargareg SET
Articulo =  C.Nueva
FROM AspelCargaReg A, AspelCambiaclaves C
WHERE ltrim(rtrim(A.Articulo)) = ltrim(rtrim(C.Anterior)) And A.Modulo in ('VTAS','COMS','INV')
END

