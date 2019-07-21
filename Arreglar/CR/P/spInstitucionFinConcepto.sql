SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInstitucionFinConcepto
@Institucion			varchar(20),
@Concepto			varchar(50),
@TipoMovimiento			varchar(20)	= NULL OUTPUT,
@ConceptoGasto			varchar(50)	= NULL OUTPUT,
@Acreedor			varchar(10)	= NULL OUTPUT,
@ObligacionFiscal		varchar(50)	= NULL OUTPUT,
@ObligacionFiscal2		varchar(50)	= NULL OUTPUT,
@Tasa				float		= NULL OUTPUT,
@TipoImporte			varchar(20)	= NULL OUTPUT,
@PermiteAbonoNoIdentificado	bit		= NULL OUTPUT,
@ReferenciaBancaria		varchar(50)	= NULL OUTPUT,
@PermiteCargoNoIdentificado bit		= NULL OUTPUT

AS BEGIN
DECLARE
@ConceptoBanco	varchar(50),
@p			int
SELECT @TipoMovimiento = TipoMovimiento,
@ConceptoGasto = ConceptoGasto,
@Acreedor = NULLIF(RTRIM(Acreedor), ''),
@ObligacionFiscal = NULLIF(RTRIM(ObligacionFiscal), ''),
@ObligacionFiscal2 = NULLIF(RTRIM(ObligacionFiscal2), ''),
@Tasa = Tasa,
@TipoImporte = TipoImporte,
@PermiteAbonoNoIdentificado = ISNULL(PermiteAbonoNoIdentificado, 0),
@PermiteCargoNoIdentificado = ISNULL(PermiteCargoNoIdentificado, 0)
FROM InstitucionFinConcepto
WHERE Institucion = @Institucion AND ConceptoBanco = @Concepto
IF @@ROWCOUNT = 0
BEGIN
EXEC spInstitucionFinBuscarConceptoBanco @Institucion, @Concepto, @ConceptoBanco OUTPUT
IF @ConceptoBanco IS NOT NULL
BEGIN
SELECT @TipoMovimiento = TipoMovimiento,
@ConceptoGasto = ConceptoGasto,
@Acreedor = NULLIF(RTRIM(Acreedor), ''),
@ObligacionFiscal = NULLIF(RTRIM(ObligacionFiscal), ''),
@ObligacionFiscal2 = NULLIF(RTRIM(ObligacionFiscal2), ''),
@Tasa = Tasa,
@TipoImporte = TipoImporte,
@PermiteAbonoNoIdentificado = ISNULL(PermiteAbonoNoIdentificado, 0),
@PermiteCargoNoIdentificado = ISNULL(PermiteCargoNoIdentificado, 0)
FROM InstitucionFinConcepto
WHERE Institucion = @Institucion AND ConceptoBanco = @ConceptoBanco
SELECT @p = CHARINDEX('<RB>', @ConceptoBanco)
IF @p > 0
SELECT @ReferenciaBancaria = SUBSTRING(@Concepto, @p, LEN(@Concepto))
END
END
RETURN
END

