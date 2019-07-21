SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInXMLNSOmisionValido
@XML		varchar(max),
@NameSpace      varchar(max),
@Omision        bit  = 0  OUTPUT,
@Ok             int = NULL OUTPUT,
@OkRef          varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Resultado			varchar(max),
@Longitud			bigint,
@Contador			bigint,
@Caracter			char(1),
@Estado				int,
@EstadoAnterior		int,
@Prefijo			varchar(max),
@Nombre				varchar(max)
DECLARE @xmlns TABLE
(
Prefijo					varchar(max) COLLATE DATABASE_DEFAULT NULL,
Nombre					varchar(max) COLLATE DATABASE_DEFAULT NULL
)
IF NULLIF(@OK,0) IS NULL AND NULLIF(CONVERT(varchar,@XML),'') IS NULL SELECT @Ok = 72340 ELSE
IF NULLIF(@OK,0) IS NULL AND NULLIF(CONVERT(varchar,@NameSpace),'') IS NULL SELECT @Ok = 72350
SET @Longitud = LEN(@XML)
SET @Contador = 1
SET @Estado = 0
SET @Prefijo = ''
SET @Nombre  = ''
SET @Omision = 0
WHILE @Contador <= @Longitud AND @Ok IS NULL
BEGIN
SET @EstadoAnterior = @Estado
SET @Caracter = SUBSTRING(@XML,@Contador,1)
IF @Estado = 0 AND @Caracter = 'X'		  SET @Estado = 1 ELSE
IF @Estado = 1 AND @Caracter NOT IN ('M')	  SET @Estado = 0 ELSE
IF @Estado = 1 AND @Caracter = 'M'		  SET @Estado = 2 ELSE
IF @Estado = 2 AND @Caracter NOT IN ('L')	  SET @Estado = 0 ELSE
IF @Estado = 2 AND @Caracter = 'L'		  SET @Estado = 3 ELSE
IF @Estado = 3 AND @Caracter NOT IN ('N')	  SET @Estado = 0 ELSE
IF @Estado = 3 AND @Caracter = 'N'		  SET @Estado = 4 ELSE
IF @Estado = 4 AND @Caracter NOT IN ('S')	  SET @Estado = 0 ELSE
IF @Estado = 4 AND @Caracter = 'S'		  SET @Estado = 5 ELSE
IF @Estado = 5 AND @Caracter NOT IN (CHAR(58),'=') SET @Estado = 0 ELSE
IF @Estado = 5 AND @Caracter = CHAR(58)		  SET @Estado = 6 ELSE
IF @Estado = 5 AND @Caracter = '='		  SET @Estado = 7 ELSE
IF @Estado = 6 AND @Caracter = '='     	  SET @Estado = 7 ELSE
IF @Estado = 7 AND @Caracter NOT IN ('"')	  SET @Estado = 0 ELSE
IF @Estado = 7 AND @Caracter = '"'     	  SET @Estado = 8 ELSE
IF @Estado = 8 AND @Caracter = '"'     	  SET @Estado = 9
IF @Estado = 6 AND @EstadoAnterior = 6
BEGIN
SET @Prefijo = @Prefijo + @Caracter
END ELSE IF @Estado = 8 AND @EstadoAnterior = 8
BEGIN
SET @Nombre = @Nombre + @Caracter
END ELSE IF @Estado = 9
BEGIN
IF NULLIF(@Nombre,'') IS NOT NULL
BEGIN
INSERT @xmlns (Prefijo, Nombre) VALUES (NULLIF(@Prefijo,''), NULLIF(@Nombre,''))
END
SET @Prefijo = ''
SET @Nombre = ''
SET @Estado = 0
END
SET @Contador = @Contador + 1
END
IF EXISTS(SELECT Nombre FROM @xmlns WHERE Nombre = @NameSpace AND Prefijo IS  NULL)
SET @Omision = 1
ELSE
SET @Omision = 0
END

