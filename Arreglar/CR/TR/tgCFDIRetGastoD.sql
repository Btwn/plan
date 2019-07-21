SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCFDIRetGastoD ON GastoD
FOR INSERT, UPDATE
AS
BEGIN
DECLARE @ID							int,
@Renglon						float,
@RenglonSub					int,
@Importe						float,
@Impuestos					float,
@Empresa						varchar(5),
@Retencion1					float,
@Retencion2					float,
@Retencion3					float,
@Retencion1Total				float,
@Retencion2Total				float,
@Retencion3Total				float,
@Gasto3Retenciones			bit,
@GASRetencion3Independiente	bit,
@Retencion2BaseImpuesto1		bit
IF EXISTS(SELECT *
FROM Inserted i
JOIN Gasto g ON i.ID = g.ID
JOIN MovTipo mt ON g.Mov = mt.Mov AND mt.Modulo = 'GAS'
WHERE ISNULL(mt.SubClave, '') = 'GAS.ESTRETSAT'
AND g.Estatus IN('SINAFECTAR', 'BORRADOR', 'CONFIRMAR')
)
AND (UPDATE(Cantidad) OR UPDATE(Precio) OR UPDATE(Importe) OR UPDATE(Concepto))
BEGIN
SELECT @Empresa = Empresa, @ID = g.ID FROM Gasto g JOIN Inserted i ON g.ID = i.ID
SELECT @Gasto3Retenciones			= ISNULL(Gasto3Retenciones, 0),
@GASRetencion3Independiente	= ISNULL(GASRetencion3Independiente, 0)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @Retencion2BaseImpuesto1 = ISNULL(Retencion2BaseImpuesto1, 0) FROM Version
SELECT @Retencion1	= dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', Concepto, 'Retencion1'),
@Retencion2	= dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', Concepto, 'Retencion2'),
@Retencion3	= dbo.fnConceptoImpuestoTasa(@Empresa, 'GAS', Concepto, 'Retencion3'),
@Importe		= Importe,
@Renglon		= Renglon,
@RenglonSub	= RenglonSub
FROM Inserted
SELECT @Impuestos = Impuestos FROM GastoT WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @Gasto3Retenciones = 1
SELECT @Retencion3Total = @Importe*(@Retencion3/100.0)
ELSE
SELECT @Retencion3Total = 0
IF @GASRetencion3Independiente = 1
IF @Retencion2BaseImpuesto1 = 1
SELECT @Retencion2Total = @Impuestos*(@Retencion2/100.0)
ELSE
SELECT @Retencion2Total = @Importe*(@Retencion2/100.0)
ELSE
IF @Retencion2BaseImpuesto1 = 1
SELECT @Retencion2Total = @Impuestos*(@Retencion2/100.0)
ELSE
SELECT @Retencion2Total = (@Importe-ISNULL(@Retencion3Total, 0))*(@Retencion2/100.0)
IF @GASRetencion3Independiente = 1
SELECT @Retencion1Total = @Importe*(@Retencion1/100.0)
ELSE
SELECT @Retencion1Total = (@Importe-ISNULL(@Retencion3Total, 0))*(@Retencion1/100.0)
UPDATE GastoD
SET Retencion3 = @Retencion3Total,
Retencion2 = @Retencion2Total,
Retencion  = @Retencion1Total
FROM GastoD
WHERE ID = @ID
AND Renglon = @Renglon
AND RenglonSub = @RenglonSub
END
RETURN
END

