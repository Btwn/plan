SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[xpVentaRetencionCalcular]
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
,@Renglon FLOAT
,@RenglonSub INT
,@Articulo CHAR(20)
,@Cantidad FLOAT
,@Importe MONEY
,@ImporteNeto MONEY
,@Impuestos MONEY
,@ImpuestosNetos MONEY
,@Retencion MONEY OUTPUT
,@BorrarRetencionCx BIT OUTPUT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
AS
BEGIN
	DECLARE
		@p CHAR(1)
	   ,@RFC VARCHAR(20)
	   ,@PorcRetencion FLOAT
	SELECT @PorcRetencion = (Retencion2 / 100)
	FROM Art WITH(NOLOCK)
	WHERE Articulo = @Articulo
	SELECT @Retencion = @ImporteNeto * @PorcRetencion
		  ,@BorrarRetencionCx = 0
	RETURN
END
GO