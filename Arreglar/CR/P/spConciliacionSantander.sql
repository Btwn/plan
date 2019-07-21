SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConciliacionSantander
@Institucion	varchar(20),
@NumeroCta	varchar(100),
@Estacion	Int

AS
BEGIN
DECLARE	@RegClave	varchar(255),
@TipoMov	varchar(2),
@Fecha		datetime,
@Concepto	varchar(50),
@Referencia 	varchar(50),
@Cargo		money,
@Abono		money,
@Observaciones	varchar(100)
DECLARE crListaSt CURSOR FOR
SELECT RTRIM(LTRIM(Clave)) FROM ListaSt WHERE Estacion = @Estacion AND RTRIM(Substring(Clave, 1, 16)) = @NumeroCta
OPEN crListaSt
FETCH NEXT FROM crListaSt INTO @RegClave
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT 	@TipoMov	= SUBSTRING(@RegClave, 73, 1),
@Fecha 		= CONVERT(smalldatetime, SUBSTRING(@RegClave, 21, 4) + '-' + SUBSTRING(@RegClave, 19, 2) + '-' + SUBSTRING(@RegClave, 17, 2), 102),
@Concepto 	= SUBSTRING(@RegClave, 33, 40),
@Referencia	= SUBSTRING(@RegClave, 102, 8),
@Observaciones	= SUBSTRING(@RegClave, 110, 40)
IF dbo.fnEsNumerico(@Referencia) = 1 SELECT @Referencia = CONVERT(varchar, CONVERT(int, @Referencia))
IF @TipoMov = '-'
SELECT @Cargo = CONVERT(money,CONVERT(decimal(12,2), SUBSTRING(@RegClave, 74, 14)))/100, @Abono = 0.0
ELSE
SELECT @Abono = CONVERT(money,CONVERT(decimal(12,2), SUBSTRING(@RegClave, 74, 14)))/100, @Cargo = 0.0
INSERT INTO #ConciliacionBanco Values(@Fecha, @Concepto, @Referencia, @Cargo, @Abono, @Observaciones)
FETCH NEXT FROM crListaSt INTO @RegClave
END
CLOSE crListaSt
DEALLOCATE crListaSt
END

