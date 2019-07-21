SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[xpVentaRetencionTotalCalcular]
 @ID INT
,@Accion CHAR(20)
,@Empresa CHAR(5)
,@Usuario CHAR(10)
,@Modulo CHAR(5)
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@MovTipo CHAR(20)
,@MovMoneda CHAR(10)
,@MovTipoCambio FLOAT
,@Cliente CHAR(10)
,@SumaImpuesto1Neto MONEY
,@SumaImpuesto2Neto MONEY
,@SumaImpuesto3Neto MONEY
,@SumaRetencion MONEY OUTPUT
,@SumaRetencion2 MONEY OUTPUT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
,@SumaRetencion3 MONEY = NULL OUTPUT
AS
BEGIN

	IF @MovTipo IN ('VTAS.F', 'VTAS.D', 'VTAS.DF', 'VTAS.B')
	BEGIN

		IF EXISTS (SELECT * FROM Cte WHERE Cliente = @Cliente AND NULLIF(RTRIM(PITEX), '') IS NOT NULL)
		BEGIN
			SELECT @SumaRetencion = @SumaImpuesto1Neto
		END

	END

	RETURN
END
GO