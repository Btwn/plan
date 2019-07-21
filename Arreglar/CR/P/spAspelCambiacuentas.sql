SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelCambiacuentas]

AS BEGIN
UPDATE AspelCargaprop SET
Valor =  LEFT(REPLACE(LTRIM(RTRIM(c.nueva)),'-','')+'00000000000000000000',20) + c.nivel
FROM AspelCargaprop A, AspelCambiaclaves C
WHERE LEFT(ltrim(rtrim(a.valor)),20) = LEFT(REPLACE(LTRIM(RTRIM(c.anterior)),'-','')+'00000000000000000000',20) And A.campo = 'cuenta'
UPDATE AspelCargaprop SET
Rama =  LEFT(REPLACE(LTRIM(RTRIM(c.nueva)),'-','')+'00000000000000000000',20) + c.nivel
FROM AspelCargaprop A, AspelCambiaclaves C
WHERE LEFT(ltrim(rtrim(a.rama)),20) = LEFT(REPLACE(LTRIM(RTRIM(c.anterior)),'-','')+'00000000000000000000',20) And A.campo = 'cuenta'
UPDATE AspelCargareg SET
Mayor =  LEFT(REPLACE(LTRIM(RTRIM(c.nueva)),'-',''),20)
FROM AspelCargareg A, AspelCambiaclaves C
WHERE LEFT(ltrim(rtrim(a.Mayor)),20) = LEFT(REPLACE(LTRIM(RTRIM(c.anterior)),'-','')+'00000000000000000000',20) And A.MODULO = 'CONT'
END

