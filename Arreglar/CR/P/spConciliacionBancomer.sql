SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConciliacionBancomer
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
/* AG 21/05/2007 se corrigio este select agregando el convert a @NumeroCta */
SELECT RTRIM(LTRIM(Clave)) FROM ListaSt WHERE Estacion = @Estacion AND CONVERT(varchar(20), CONVERT(bigint,Substring(Clave, 9, 10))) = CONVERT(varchar(20), CONVERT(bigint, @NumeroCta))
OPEN crListaSt
FETCH NEXT FROM crListaSt INTO @RegClave
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT 	@TipoMov	= SUBSTRING(@RegClave, 65, 1),
@Fecha 		= CONVERT(smalldatetime, SUBSTRING(@RegClave, 131, 10),102),
@Concepto 	= SUBSTRING(@RegClave, 35, 30),
@Referencia	= SUBSTRING(@RegClave, 29, 6),
@Observaciones	= SUBSTRING(@RegClave, 94, 30)
IF @TipoMov = '1'
SELECT @Cargo = CONVERT(money,CONVERT(decimal(10,2), SUBSTRING(@RegClave, 66, 16))), @Abono = 0.0
ELSE
SELECT @Abono = CONVERT(money,CONVERT(decimal(10,2), SUBSTRING(@RegClave, 66, 16))), @Cargo = 0.0
INSERT INTO #ConciliacionBanco Values(@Fecha, @Concepto, @Referencia, @Cargo, @Abono, @Observaciones)
FETCH NEXT FROM crListaSt INTO @RegClave
END
CLOSE crListaSt
DEALLOCATE crListaSt
END

