SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnConceptoImpuestoTasa (@Empresa varchar(5), @Modulo char(5), @Concepto varchar(50), @Tipo varchar(10))
RETURNS float

AS BEGIN
DECLARE @CfgTipoImpuesto	bit
DECLARE @Tasa				float,
@Impuestos 		float,
@Retencion1		float,
@Retencion2		float,
@Retencion3		float,
@TipoImpuesto		varchar(10),
@TipoImpuesto1	varchar(10),
@TipoImpuesto2	varchar(10),
@TipoImpuesto3	varchar(10),
@TipoImpuesto4	varchar(10),
@TipoImpuesto5	varchar(10),
@TipoRetencion1	varchar(10),
@TipoRetencion2	varchar(10),
@TipoRetencion3	varchar(10)
SELECT @CfgTipoImpuesto=0
SELECT @Tasa=0
SELECT @CfgTipoImpuesto=ISNULL(TipoImpuesto,0) FROM EmpresaGral WHERE Empresa=@Empresa
SELECT
@Impuestos=Impuestos,
@Retencion1=Retencion,
@Retencion2=Retencion2,
@Retencion3=Retencion3,
@TipoImpuesto1 = TipoImpuesto1,
@TipoImpuesto2 = TipoImpuesto2,
@TipoImpuesto3 = TipoImpuesto3,
@TipoImpuesto4 = TipoImpuesto4,
@TipoImpuesto5 = TipoImpuesto5,
@TipoRetencion1 = TipoRetencion1,
@TipoRetencion2 = TipoRetencion2,
@TipoRetencion3 = TipoRetencion3
FROM Concepto
WHERE Modulo = @Modulo
AND Concepto = @Concepto
IF @CfgTipoImpuesto = 0
BEGIN
IF @Tipo = 'Impuesto1'
SELECT @Tasa = @Impuestos
ELSE IF @Tipo = 'Retencion1'
SELECT @Tasa = @Retencion1
ELSE IF @Tipo = 'Retencion2'
SELECT @Tasa = @Retencion2
ELSE IF @Tipo = 'Retencion3'
SELECT @Tasa = @Retencion3
END
ELSE IF @CfgTipoImpuesto = 1
BEGIN
IF @Tipo = 'Impuesto1'
SELECT @Tasa = dbo.fnTipoImpuestoTasa(@TipoImpuesto1)
IF @Tipo = 'Impuesto2'
SELECT @Tasa = dbo.fnTipoImpuestoTasa(@TipoImpuesto2)
IF @Tipo = 'Impuesto3'
SELECT @Tasa = dbo.fnTipoImpuestoTasa(@TipoImpuesto3)
IF @Tipo = 'Impuesto4'
SELECT @Tasa = dbo.fnTipoImpuestoTasa(@TipoImpuesto4)
IF @Tipo = 'Impuesto5'
SELECT @Tasa = dbo.fnTipoImpuestoTasa(@TipoImpuesto5)
IF @Tipo = 'Retencion1'
SELECT @Tasa = dbo.fnTipoImpuestoTasa(@TipoRetencion1)
IF @Tipo = 'Retencion2'
SELECT @Tasa = dbo.fnTipoImpuestoTasa(@TipoRetencion2)
IF @Tipo = 'Retencion3'
SELECT @Tasa = dbo.fnTipoImpuestoTasa(@TipoRetencion3)
END
RETURN @Tasa
END

