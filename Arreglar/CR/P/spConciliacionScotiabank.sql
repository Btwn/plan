SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConciliacionScotiabank
@Institucion			varchar(20),
@NumeroCta			varchar(100),
@Estacion			Int

AS
BEGIN
DECLARE	@RegClave	varchar(255),
@Concepto	    varchar(50),
@Observaciones	varchar(100),
@Cuenta			varchar(100),
@Fecha		    datetime,
@Cargo		    money,
@Abono		    money,
@Clave			varchar(10),
@Referencia	    varchar(100),
@Descripcion    varchar(100),
@Tipo			varchar(20)
DECLARE crListaSt CURSOR FOR
SELECT RTRIM(LTRIM(Clave)) FROM ListaSt WHERE Estacion = @Estacion AND SUBSTRING(Clave, 9, 10) = @NumeroCta
OPEN crListaSt
FETCH NEXT FROM crListaSt INTO @RegClave
WHILE @@FETCH_STATUS = 0 AND SUBSTRING(@RegClave, 1, 1)=1
BEGIN
SELECT @Cuenta = SUBSTRING(@RegClave, 9, 10)
SELECT @Fecha = SUBSTRING(@RegClave, 19, 8)
SELECT @Clave = SUBSTRING(@RegClave, 27, 3)
SELECT @Concepto = Descripcion, @Tipo = NaturalezaMovimiento FROM MensajeInstitucion WHERE Mensaje = @Clave AND institucion = @Institucion
SELECT @Abono = CASE @Tipo WHEN 'ABONO' THEN CONVERT(money,SUBSTRING(@RegClave, 40, 13)) ELSE 0 END
SELECT @Cargo = CASE @Tipo WHEN 'CARGO' THEN CONVERT(money,SUBSTRING(@RegClave, 40, 13)) ELSE 0 END
SELECT @Referencia = SUBSTRING(@RegClave, 30, 10)
SELECT @Observaciones = CONVERT(varchar, dbo.fnQuitarCerosIzq(SUBSTRING(@RegClave, 30, 10)))
INSERT INTO #ConciliacionBanco Values(@Fecha, @Concepto, @Referencia, @Cargo, @Abono, @Observaciones)
FETCH NEXT FROM crListaSt INTO @RegClave
END
CLOSE crListaSt
DEALLOCATE crListaSt
END

