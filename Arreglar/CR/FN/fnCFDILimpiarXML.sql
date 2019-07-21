SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnCFDILimpiarXML
(
@XML				varchar(max),
@TagSostener		varchar(max)
)
RETURNS varchar(max)

AS BEGIN
DECLARE
@Seguir				bit,
@AtributoVacio		varchar(255),
@Posicion			bigint,
@Caracter			char(1),
@Contador			int,
@Atributo			varchar(255)
SELECT @Seguir = 1, @AtributoVacio = '=""', @Posicion = 0
WHILE @Seguir = 1
BEGIN
SET @Posicion = ISNULL(PATINDEX('%=""%',@XML),0)
IF @Posicion > 0
BEGIN
SET @Contador = @Posicion - 1
SET @Caracter = SUBSTRING(@XML,@Contador,1)
SET @AtributoVacio = '=""'
WHILE @Caracter <> CHAR(32)
BEGIN
SET @AtributoVacio = @Caracter + @AtributoVacio
SET @Contador = @Contador - 1
SET @Caracter = SUBSTRING(@XML,@Contador,1)
END
SET @AtributoVacio = CHAR(32) + @AtributoVacio
SELECT @Atributo = RTRIM(REPLACE(@AtributoVacio,'=""',''))
IF ISNULL(PATINDEX('%' + @Atributo + '%',@TagSostener),0) = 0
SET @XML = REPLACE(@XML,@AtributoVacio,'')
ELSE
SET @XML = REPLACE(@XML,@AtributoVacio,@Atributo + '="' + '_TAGRESPETAR_' + '"')
END
ELSE IF @Posicion = 0
SET @Seguir = 0
END
SET @Seguir = 1
WHILE @Seguir = 1
BEGIN
SET @Posicion = ISNULL(PATINDEX('%="_TAGRESPETAR_"%',@XML),0)
IF @Posicion > 0
BEGIN
SET @XML = REPLACE(@XML,'="_TAGRESPETAR_"','=""')
END
ELSE IF @Posicion = 0
SET @Seguir = 0
END
RETURN @XML
END

