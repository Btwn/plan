SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConciliacionHSBC2
@Institucion			varchar(20),
@NumeroCta			varchar(100),
@Estacion			Int

AS
BEGIN
DECLARE	@RegClave	varchar(255),
@RegClave2	    varchar(255),
@Concepto	    varchar(50),
@Observaciones	varchar(100),
@Tamaño         int,
@Contador       int,
@Cuenta			varchar(100),
@Fecha		    datetime,
@Hora		    varchar(50),
@Sucursal	    int,
@Cargo		    money,
@Abono		    money,
@Clave			varchar(10),
@Cheque			int,
@Referencia	    varchar(100),
@Operador	    int,
@Descripcion    varchar(100),
@Saldo		    money,
@Signo		    varchar(100),
@Contador1      int
SELECT  @Tamaño = 0,
@Contador = 0
DECLARE crListaSt CURSOR FOR
SELECT RTRIM(LTRIM(Clave)) FROM ListaSt WHERE Estacion = @Estacion AND dbo.fnQuitarCerosIzq((SUBSTRING(Clave, 0, CHARINDEX(CHAR(9), Clave)))) = @NumeroCta
OPEN crListaSt
FETCH NEXT FROM crListaSt INTO @RegClave
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Contador1 = CHARINDEX(CHAR(9), @RegClave)
SELECT @RegClave2 = @RegClave
SELECT @Tamaño = 0,
@Contador = 0
SELECT @Tamaño = LEN (@RegClave2)
IF @Contador = 0 AND @Contador < @Contador1
BEGIN
SELECT @Cuenta = NULL
SELECT @Cuenta = SUBSTRING(@RegClave2, 0, CHARINDEX(CHAR(9), @RegClave2))
SELECT @RegClave2 = RIGHT(@RegClave2, @Tamaño-(CHARINDEX(CHAR(9), @RegClave2)))
SELECT @Contador = @Contador+1
SELECT @Tamaño = LEN (@RegClave2)
END
IF @Contador = 1 AND @Contador <= @Contador1
BEGIN
SELECT @Fecha = NULL
SELECT @Fecha = CONVERT(smalldatetime, SUBSTRING(@RegClave2, 7, 4) + '-' + SUBSTRING(@RegClave2, 4, 2) + '-' + SUBSTRING(@RegClave2, 1, 2), 102)
SELECT @RegClave2 = RIGHT(@RegClave2, @Tamaño-(CHARINDEX(CHAR(9), @RegClave2)))
SELECT @Contador = @Contador+1
SELECT @Tamaño = LEN (@RegClave2)
END
IF @Contador = 2 AND @Contador <= @Contador1
BEGIN
SELECT @Hora = NULL
SELECT @Hora = SUBSTRING(@RegClave2, 0, CHARINDEX(CHAR(9), @RegClave2))
SELECT @RegClave2 = RIGHT(@RegClave2, @Tamaño-(CHARINDEX(CHAR(9), @RegClave2)))
SELECT @Contador = @Contador+1
SELECT @Tamaño = LEN (@RegClave2)
END
IF @Contador = 3 AND @Contador <= @Contador1
BEGIN
SELECT @Sucursal = NULL
SELECT @Sucursal = CONVERT(int,SUBSTRING(@RegClave2, 0, CHARINDEX(CHAR(9), @RegClave2)))
SELECT @RegClave2 = RIGHT(@RegClave2, @Tamaño-(CHARINDEX(CHAR(9), @RegClave2)))
SELECT @Contador = @Contador+1
SELECT @Tamaño = LEN (@RegClave2)
END
IF @Contador = 4 AND @Contador <= @Contador1
BEGIN
SELECT @Cargo = NULL
SELECT @Cargo = CONVERT(money,CONVERT(decimal(11,2),SUBSTRING(@RegClave2, 0, CHARINDEX(CHAR(9), @RegClave2))))
SELECT @RegClave2 = RIGHT(@RegClave2, @Tamaño-(CHARINDEX(CHAR(9), @RegClave2)))
SELECT @Contador = @Contador+1
SELECT @Tamaño = LEN (@RegClave2)
END
IF @Contador = 5 AND @Contador <= @Contador1
BEGIN
SELECT @Abono = NULL
SELECT @Abono = CONVERT(money,CONVERT(decimal(11,2),SUBSTRING(@RegClave2, 0, CHARINDEX(CHAR(9), @RegClave2))))
SELECT @RegClave2 = RIGHT(@RegClave2, @Tamaño-(CHARINDEX(CHAR(9), @RegClave2)))
SELECT @Contador = @Contador+1
SELECT @Tamaño = LEN (@RegClave2)
END
IF @Contador = 6 AND @Contador <= @Contador1
BEGIN
SELECT @Clave = NULL
SELECT @Clave = SUBSTRING(@RegClave2, 0, CHARINDEX(CHAR(9), @RegClave2))
SELECT @RegClave2 = RIGHT(@RegClave2, @Tamaño-(CHARINDEX(CHAR(9), @RegClave2)))
SELECT @Contador = @Contador+1
SELECT @Tamaño = LEN (@RegClave2)
SELECT @Concepto = Descripcion FROM MensajeInstitucion WHERE Mensaje = @Clave and institucion = @Institucion
END
IF @Contador = 7 AND @Contador <= @Contador1
BEGIN
SELECT @Cheque = NULL
SELECT @Cheque = CONVERT(int,SUBSTRING(@RegClave2, 0, CHARINDEX(CHAR(9), @RegClave2)))
SELECT @RegClave2 = RIGHT(@RegClave2, @Tamaño-(CHARINDEX(CHAR(9), @RegClave2)))
SELECT @Contador = @Contador+1
SELECT @Tamaño = LEN (@RegClave2)
END
IF @Contador = 8 AND @Contador <= @Contador1
BEGIN
SELECT @Referencia = NULL
SELECT @Referencia = SUBSTRING(SUBSTRING(@RegClave2, 0, CHARINDEX(CHAR(9), @RegClave2)), 1, 6)
SELECT @RegClave2 = RIGHT(@RegClave2, @Tamaño-(CHARINDEX(CHAR(9), @RegClave2)))
SELECT @Contador = @Contador+1
SELECT @Tamaño = LEN (@RegClave2)
END
SELECT @Contador = @Contador+1
/*
IF @Contador = 9 AND @Contador <= @Contador1
BEGIN
SELECT @Operador = NULL
SELECT @Operador = CONVERT(int,SUBSTRING(@RegClave2, 0, CHARINDEX(CHAR(9), @RegClave2)))
SELECT @RegClave2 = RIGHT(@RegClave2, @Tamaño-(CHARINDEX(CHAR(9), @RegClave2)))
SELECT @Contador = @Contador+1
SELECT @Tamaño = LEN (@RegClave2)
END
*/
IF @Contador = 10 AND @Contador <= @Contador1
BEGIN
SELECT @Descripcion = NULL
SELECT @Descripcion = SUBSTRING(@RegClave2, 0, CHARINDEX(CHAR(9), @RegClave2))
SELECT @RegClave2 = RIGHT(@RegClave2, @Tamaño-(CHARINDEX(CHAR(9), @RegClave2)))
SELECT @Contador = @Contador+1
SELECT @Tamaño = LEN (@RegClave2)
SELECT @Observaciones = @Descripcion
END
IF @Contador = 11 AND @Contador <= @Contador1
BEGIN
SELECT @Saldo = NULL
SELECT @Saldo = CONVERT(money,CONVERT(decimal(11,2),SUBSTRING(@RegClave2, 0, CHARINDEX(CHAR(9), @RegClave2))))
SELECT @RegClave2 = RIGHT(@RegClave2, @Tamaño-(CHARINDEX(CHAR(9), @RegClave2)))
SELECT @Contador = @Contador+1
SELECT @Tamaño = LEN (@RegClave2)
SELECT @Signo = @RegClave2
END
IF @Signo = 'DR'
SELECT @Cargo = @Cargo, @Abono = 0.0
ELSE
SELECT @Abono = @Abono, @Cargo = 0.0
INSERT INTO #ConciliacionBanco Values(@Fecha, @Concepto, @Referencia, @Cargo, @Abono, @Observaciones)
FETCH NEXT FROM crListaSt INTO @RegClave
END
CLOSE crListaSt
DEALLOCATE crListaSt
END

