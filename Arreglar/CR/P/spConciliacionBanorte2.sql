SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConciliacionBanorte2
@Institucion	varchar(20),
@NumeroCta	varchar(100),
@Estacion	Int

AS
BEGIN
DECLARE	@RegClave	    varchar(255),
@RegClave2	    varchar(255),
@TipoMov	    varchar(2),
@Fecha		    datetime,
@Concepto	    varchar(50),
@Referencia     varchar(50),
@Cargo		    money,
@Abono		    money,
@Observaciones	varchar(100),
@Tamaño         int,
@Contador       int
SELECT  @Tamaño = 0,
@Contador = 0
DECLARE crListaSt CURSOR FOR
SELECT RTRIM(LTRIM(Clave)) FROM ListaSt WHERE Estacion = @Estacion
OPEN crListaSt
FETCH NEXT FROM crListaSt INTO @RegClave
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @RegClave2=@RegClave
SELECT  @Tamaño = 0,
@Contador = 0
SELECT  @Tamaño = LEN (@RegClave2)
SELECT  @Fecha = SUBSTRING(@RegClave2, 12, 10),
@Referencia	= SUBSTRING(@RegClave2, 23, 10)
WHILE @Contador < 3
BEGIN
SELECT @RegClave2 = RIGHT(@RegClave2, @Tamaño-(CHARINDEX('|', @RegClave2)))
SELECT @Contador=@Contador+1
SELECT @Tamaño = LEN (@RegClave2)
END
SELECT @Concepto=SUBSTRING(@RegClave2, 0, CHARINDEX('|', @RegClave2))
SELECT @Contador=0
WHILE @Contador < 3
BEGIN
SELECT @RegClave2 = RIGHT(@RegClave2, @Tamaño-(CHARINDEX('|', @RegClave2)))
SELECT @Contador=@Contador+1
SELECT @Tamaño = LEN (@RegClave2)
END
SELECT @Cargo= CONVERT (MONEY, SUBSTRING(@RegClave2, 0, CHARINDEX('|', @RegClave2)) )
SELECT @Contador=0
WHILE @Contador < 1
BEGIN
SELECT @RegClave2 = RIGHT(@RegClave2, @Tamaño-(CHARINDEX('|', @RegClave2)))
SELECT @Contador=@Contador+1
SELECT @Tamaño = LEN (@RegClave2)
END
SELECT @Abono= CONVERT (MONEY, SUBSTRING(@RegClave2, 0, CHARINDEX('|', @RegClave2)) )
SELECT @Contador=0
WHILE @Contador < 2
BEGIN
SELECT @RegClave2 = RIGHT(@RegClave2, @Tamaño-(CHARINDEX('|', @RegClave2)))
SELECT @Contador=@Contador+1
SELECT @Tamaño = LEN (@RegClave2)
END
SELECT @Observaciones= SUBSTRING(@RegClave2, 0, @Tamaño+1)
INSERT INTO #ConciliacionBanco Values(@Fecha, @Concepto, @Referencia, @Cargo, @Abono, @Observaciones)
FETCH NEXT FROM crListaSt INTO @RegClave
END
CLOSE crListaSt
DEALLOCATE crListaSt
END

