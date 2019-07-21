SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[xpCxAfectar]
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
,@FechaEmision DATETIME
,@Condicion VARCHAR(50)
,@Vencimiento DATETIME
,@FormaPago VARCHAR(50)
,@ClienteProv CHAR(10)
,@CPMoneda CHAR(10)
,@CPFactor FLOAT
,@CPTipoCambio FLOAT
,@Importe MONEY
,@Impuestos MONEY
,@Saldo MONEY
,@CtaDinero CHAR(10)
,@AplicaManual BIT
,@ConDesglose BIT
,@Conexion BIT
,@SincroFinal BIT
,@Sucursal INT
,@EstatusNuevo CHAR(15)
,@MovAplica CHAR(20)
,@MovAplicaID VARCHAR(20)
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
,@Estatus VARCHAR(15) = NULL
AS
BEGIN
	DECLARE
		@CE_IDAplica INT
	   ,@CE_MovAplicaFactor FLOAT
	   ,@CE_MovAplicaImporteTotal MONEY
	   ,@CE_MovAplicaRetencion MONEY
	   ,@CE_MovAplicaRetencion2 MONEY
	   ,@CE_MovAplicaRetencion3 MONEY
	   ,@CE_MovAplicaTipoCambio FLOAT
	   ,@CE_MovAplicaMoneda VARCHAR(20)
	   ,@CE_MovAplicaImporteNeto MONEY
	   ,@CE_Retencion MONEY
	   ,@CE_Impuestos FLOAT
	   ,@CE_Importe MONEY
	   ,@CE_ImporteTotal MONEY

	IF @MovTipo IN ('CXC.ANC', 'CXC.ACA', 'CXP.ANC', 'CXP.ACA')
		AND @Accion <> 'CANCELAR'
	BEGIN

		IF @Modulo = 'CXC'
			SELECT @CE_IDAplica = ID
				  ,@CE_MovAplicaRetencion = ISNULL(Retencion, 0)
				  ,@CE_MovAplicaRetencion2 = NULL
				  ,@CE_MovAplicaRetencion3 = NULL
				  ,@CE_MovAplicaImporteTotal = ISNULL(Importe, 0.0) + ISNULL(Impuestos, 0.0)
				  ,@CE_MovAplicaTipoCambio = TipoCambio
				  ,@CE_MovAplicaMoneda = Moneda
				  ,@CE_Impuestos = ISNULL(Impuestos, 0.0)
				  ,@CE_Retencion = ISNULL(Retencion, 0)
				  ,@CE_Importe = ISNULL(Importe, 0.0)
			FROM Cxc
			WHERE Empresa = @Empresa
			AND Mov = @MovAplica
			AND MovID = @MovAplicaID
			AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO')
		ELSE

		IF @Modulo = 'CXP'
			SELECT @CE_IDAplica = ID
				  ,@CE_MovAplicaRetencion = ISNULL(Retencion, 0)
				  ,@CE_MovAplicaRetencion2 = ISNULL(Retencion2, 0)
				  ,@CE_MovAplicaRetencion3 = ISNULL(Retencion3, 0)
				  ,@CE_MovAplicaImporteTotal = ISNULL(Importe, 0.0) + ISNULL(Impuestos, 0.0)
				  ,@CE_MovAplicaTipoCambio = TipoCambio
				  ,@CE_MovAplicaMoneda = Moneda
				  ,@Impuestos = ISNULL(Impuestos, 0.0)
				  ,@CE_Retencion = ISNULL(Retencion, 0)
				  ,@CE_Importe = ISNULL(Importe, 0.0)
			FROM Cxp
			WHERE Empresa = @Empresa
			AND Mov = @MovAplica
			AND MovID = @MovAplicaID
			AND Estatus NOT IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR', 'CANCELADO')

		SELECT @CE_ImporteTotal = @CE_Importe + @CE_Impuestos - ISNULL(@CE_Retencion, 0) - ISNULL(@CE_MovAplicaRetencion2, 0) - ISNULL(@CE_MovAplicaRetencion3, 0)
		SELECT @CE_MovAplicaImporteNeto = ISNULL(@CE_MovAplicaImporteTotal, 0.0) - ISNULL(@CE_MovAplicaRetencion, 0.0) - ISNULL(@CE_MovAplicaRetencion2, 0.0) - ISNULL(@CE_MovAplicaRetencion3, 0.0)
		SELECT @CE_MovAplicaFactor = (@CE_ImporteTotal * @MovTipoCambio) / NULLIF(CONVERT(FLOAT, @CE_MovAplicaImporteNeto * @CE_MovAplicaTipoCambio), 0) * -1

		IF NOT EXISTS (SELECT ID FROM MovImpuesto WHERE Modulo = @Modulo AND ModuloID = @ID AND OrigenModuloID = @CE_IDAplica)
			INSERT MovImpuesto (Modulo, ModuloID, OrigenModulo, OrigenModuloID, OrigenConcepto, OrigenDeducible, OrigenFecha, LoteFijo, Retencion1, Retencion2, Retencion3, Excento1, Excento2, Excento3, Impuesto1, Impuesto2, Impuesto3, TipoImpuesto1, TipoImpuesto2, TipoImpuesto3, TipoRetencion1, TipoRetencion2, TipoRetencion3, Importe1, Importe2, Importe3, SubTotal, ContUso, ContUso2, ContUso3, ClavePresupuestal, ClavePresupuestalImpuesto1, DescuentoGlobal)
				SELECT @Modulo
					  ,@ID
					  ,OrigenModulo
					  ,OrigenModuloID
					  ,OrigenConcepto
					  ,ISNULL(OrigenDeducible, 100)
					  ,OrigenFecha
					  ,LoteFijo
					  ,Retencion1
					  ,Retencion2
					  ,Retencion3
					  ,Excento1
					  ,Excento2
					  ,Excento3
					  ,Impuesto1
					  ,Impuesto2
					  ,Impuesto3
					  ,TipoImpuesto1
					  ,TipoImpuesto2
					  ,TipoImpuesto3
					  ,TipoRetencion1
					  ,TipoRetencion2
					  ,TipoRetencion3
					  ,Importe1 * @CE_MovAplicaFactor
					  ,Importe2 * @CE_MovAplicaFactor
					  ,Importe3 * @CE_MovAplicaFactor
					  ,SubTotal * @CE_MovAplicaFactor
					  ,ContUso
					  ,ContUso2
					  ,ContUso3
					  ,ClavePresupuestal
					  ,ClavePresupuestalImpuesto1
					  ,DescuentoGlobal
				FROM MovImpuesto
				WHERE Modulo = @Modulo
				AND ModuloID = @CE_IDAplica

	END

	RETURN
END

