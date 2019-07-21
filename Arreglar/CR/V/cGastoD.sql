SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW [dbo].[cGastoD]
AS
SELECT ID
	  ,Renglon
	  ,RenglonSub
	  ,Concepto
	  ,Fecha
	  ,Referencia
	  ,Cantidad
	  ,Precio
	  ,ImporteConImpuesto
	  ,Importe
	  ,Provision
	  ,Retencion
	  ,Retencion2
	  ,Retencion3
	  ,Impuestos
	  ,Impuestos2
	  ,Impuestos3
	  ,Impuestos5
	  ,Impuesto1
	  ,Impuesto2
	  ,Impuesto3
	  ,Impuesto5
	  ,ContUso
	  ,ContUso2
	  ,ContUso3
	  ,ClavePresupuestal
	  ,Espacio
	  ,Sucursal
	  ,SucursalOrigen
	  ,Actividad
	  ,Proyecto
	  ,UEN
	  ,VIN
	  ,DescripcionExtra
	  ,AcreedorRef
	  ,EndosarA
	  ,AFArticulo
	  ,AFSerie
	  ,Lectura
	  ,PorcentajeDeducible
	  ,Personal
	  ,PresupuestoEsp
	  ,ABC
	  ,TipoImpuesto1
	  ,TipoImpuesto2
	  ,TipoImpuesto3
	  ,TipoImpuesto4
	  ,TipoImpuesto5
	  ,TipoRetencion1
	  ,TipoRetencion2
	  ,TipoRetencion3
		,AreaMotora
FROM GastoD

