SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoVerificarDetalle
@ID               		int,
@Accion			char(20),
@Empresa          		char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              		char(20),
@MovID			varchar(20),
@MovTipo	      		char(20),
@MovMoneda			char(10),
@FechaEmision		datetime,
@Estatus			char(15),
@Acreedor			char(10),
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Renglon					float,
@RenglonSub				int,
@Concepto					varchar(20),
@CantidadNueva				int,
@Precio					money,
@Importe					money,
@Impuestos				money,
@ConceptoInventariable			bit,
@CantidadMinima				int,
@CantidadMax				int,
@Cantidad					int,
@EsInventariable				bit,
@Factor					int,
@Retencion		money,
@CfgImpuesto2Info		bit,
@CfgImpuesto3Info		bit,
@TipoRetencion1		varchar(10),
@TipoRetencion2		varchar(10),
@TipoRetencion3		varchar(10),
@ImporteRet		money
SELECT @ConceptoInventariable = GastoConceptosInventariables
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT @CfgImpuesto2Info = ISNULL(Impuesto2Info, 0),
@CfgImpuesto3Info = ISNULL(Impuesto2Info, 0)
FROM Version
SELECT @Factor = Factor FROM MovTipo WHERE Mov = @Mov AND Clave = @MovTipo AND Modulo = @Modulo
DECLARE crVerificar CURSOR  FOR
SELECT g.Renglon , g.RenglonSub,  g.Concepto, g.Cantidad, g.Precio, ISNULL(g.Importe,0),
ISNULL(g.Impuestos, 0)+ISNULL(CASE WHEN @CfgImpuesto2Info = 1 THEN 0.0 ELSE g.Impuestos2 END, 0)+ISNULL(CASE WHEN @CfgImpuesto3Info = 1 THEN 0.0 ELSE g.Impuestos3 END, 0),
ISNULL(c.EsInventariable,0), ISNULL(g.Retencion, 0)+ISNULL(g.Retencion2, 0)+ISNULL(g.Retencion3, 0)
FROM GastoD g JOIN Concepto c
ON g.Concepto = c.Concepto AND c.Modulo = 'GAS'
WHERE g.ID = @ID
OPEN crVerificar
FETCH NEXT FROM crVerificar INTO @Renglon, @RenglonSub , @Concepto, @CantidadNueva ,@Precio, @Importe, @Impuestos, @EsInventariable, @Retencion
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF @ConceptoInventariable = 1 AND @MovTipo = 'GAS.CI' AND @Factor = -1 AND @Accion = 'AFECTAR'
BEGIN
IF @EsInventariable = 1
BEGIN
SELECT @Cantidad = Disponible
FROM ConceptoGastoDisponible
WHERE Concepto = @Concepto
IF (@Cantidad - @CantidadNueva) < 0.0
SELECT @Ok = 20020, @OkRef = @Concepto
END
END
IF @MovTipo NOT IN ('GAS.DA','GAS.ASC','GAS.SR') AND @Ok IS NULL
BEGIN
SELECT @TipoRetencion1 = NULLIF(TipoRetencion1,''),@TipoRetencion2 = NULLIF(TipoRetencion2,''),@TipoRetencion3 = NULLIF(TipoRetencion3,'')
FROM Concepto WHERE Concepto = @Concepto AND Modulo = @Modulo
IF @TipoRetencion1 IS NOT NULL OR @TipoRetencion3 IS NOT NULL OR @TipoRetencion3 IS NOT NULL
BEGIN
SELECT @ImporteRet = - @Retencion + @Impuestos
IF ABS(@ImporteRet) > @Importe
SELECT @Ok = 51041, @OkRef = 'Concepto: ' + @Concepto
END
END
FETCH NEXT FROM crVerificar INTO @Renglon,@RenglonSub, @Concepto, @CantidadNueva ,@Precio, @Importe, @Impuestos, @EsInventariable, @Retencion
END
CLOSE crVerificar
DEALLOCATE crVerificar
END

