SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnEsCaracterUTF8
(
@Caracter				varchar(20)
)
RETURNS bit

AS BEGIN
DECLARE
@EsCaracterUTF8	bit
IF @Caracter IN ('&lt;','&gt;','&amp;','&copy;','&reg;','&trade;','&curren;','&euro;','&yen;','&pound;','&cent;','&deg;','&acute;','&circ;','&uml;','&tilde;','&agrave;','&egrave;','&igrave;','&ograve;','&ugrave;','&Agrave;','&Egrave;','&Igrave;','&Ograve;','&Ugrave;','&aacute;','&eacute;','&iacute;','&oacute;','&uacute;','&yacute;','&Aacute;','&Eacute;','&Iacute;','&Oacute;','&Uacute;','&acirc;','&ecirc;','&icirc;','&ocirc;','&ucirc;','&Acirc;','&Ecirc;','&Icirc;','&Ocirc;','&Ucirc;','&auml;','&euml;','&iuml;','&ouml;','&uuml;','&yuml;','&Auml;','&Euml;','&Iuml;','&Ouml;','&Uuml;','&Yuml;','&atilde;','&otilde;','&ntilde;','&aring;','&oslash;','&scaron;','&Atilde;','&Otilde;','&Ntilde;','&Aring;','&Oslash;','&Scaron;','&ccedil;','&Ccedil;','&quot;')
OR (SUBSTRING(@Caracter,1,1) = '&' AND SUBSTRING(@Caracter,2,1) = '#' AND SUBSTRING(@Caracter,3,1) IN ('0','1','2','3','4','5','6','7','8','9') AND SUBSTRING(@Caracter,4,1) IN ('0','1','2','3','4','5','6','7','8','9') AND SUBSTRING(@Caracter,5,1) IN ('0','1','2','3','4','5','6','7','8','9') AND SUBSTRING(@Caracter,6,1) = ';')
SET @EsCaracterUTF8 = 1
ELSE
SET @EsCaracterUTF8 = 0
RETURN (@EsCaracterUTF8)
END

