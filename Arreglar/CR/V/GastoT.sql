SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW [dbo].[GastoT]
AS
SELECT g.ID
	  ,g.Empresa
	  ,g.Mov
	  ,g.MovID
	  ,g.FechaEmision
	  ,g.UltimoCambio
	  ,d.Proyecto
	  ,d.UEN
	  ,g.Acreedor
	  ,g.Moneda
	  ,g.TipoCambio
	  ,g.Usuario
	  ,g.Autorizacion
	  ,g.DocFuente
	  ,g.Observaciones
	  ,g.Clase
	  ,g.SubClase
	  ,g.Estatus
	  ,g.Situacion
	  ,g.SituacionFecha
	  ,g.SituacionUsuario
	  ,g.SituacionNota
	  ,g.Periodicidad
	  ,g.TieneRetencion
	  ,g.Condicion
	  ,g.Vencimiento
	  ,g.FormaPago
	  ,g.CtaDinero
	  ,g.Importe
	  ,g.Retencion
	  ,g.Impuestos
	  ,g.Saldo
	  ,g.Anticipo
	  ,g.MovAplica
	  ,g.MovAplicaID
	  ,g.Multiple
	  ,g.OrigenTipo
	  ,g.Origen
	  ,g.OrigenID
	  ,g.Poliza
	  ,g.PolizaID
	  ,g.GenerarPoliza
	  ,g.ContID
	  ,g.Ejercicio
	  ,g.Periodo
	  ,g.FechaRegistro
	  ,g.FechaConclusion
	  ,g.FechaCancelacion
	  ,g.FechaRequerida
	  ,g.CXP
	  ,g.GenerarDinero
	  ,g.Dinero
	  ,g.DineroID
	  ,g.DineroCtaDinero
	  ,g.DineroConciliado
	  ,g.DineroFechaConciliacion
	  ,g.Sucursal
	  ,g.EstaImpreso
	  ,g.ConVigencia
	  ,g.VigenciaDesde
	  ,g.VigenciaHasta
	  ,g.Prioridad
	  ,d.Renglon
	  ,d.RenglonSub
	  ,d.Concepto
	  ,'ConceptoClase' = g.Clase
	  ,'ConceptoSubClase' = g.SubClase
	  ,d.Fecha
	  ,d.Referencia
	  ,d.Cantidad
	  ,d.Precio
	  ,"Retencion1" = d.Retencion
	  ,"Retencion2" = d.Retencion2
	  ,"Retencion3" = d.Retencion3
	  ,d.ContUso
	  ,d.ContUso2
	  ,d.ContUso3
	  ,d.ClavePresupuestal
	  ,d.Espacio
	  ,d.VIN
	  ,d.Actividad
	  ,d.DescripcionExtra
	  ,"ImporteLinea" =
	   CASE
		   WHEN mt.Clave = 'GAS.G'
			   AND mt.SubClave = 'GAS.GE/GT' THEN ISNULL(d.Importe, 0.0) - ISNULL(d.Retencion3, 0.0)
		   ELSE ISNULL(d.Importe, 0.0)
	   END
	  ,d.Provision
	  ,"ImpuestosLinea" = ISNULL(d.Impuestos, 0.0) +
	   CASE
		   WHEN v.Impuesto2Info = 1 THEN 0.0
		   ELSE ISNULL(d.Impuestos2, 0.0)
	   END +
	   CASE
		   WHEN v.Impuesto3Info = 1 THEN 0.0
		   ELSE ISNULL(d.Impuestos3, 0.0)
	   END + ISNULL(d.Impuestos5, 0.0)
	  ,"RetencionLinea" = ISNULL(d.Retencion, 0.0) + ISNULL(d.Retencion2, 0.0)
	  ,"TotalLinea" = ISNULL(d.Importe, 0.0) - ISNULL(d.Retencion, 0.0) - ISNULL(d.Retencion2, 0.0) - ISNULL(d.Retencion3, 0.0) + ISNULL(d.Impuestos, 0.0) +
	   CASE
		   WHEN v.Impuesto2Info = 1 THEN 0.0
		   ELSE ISNULL(d.Impuestos2, 0.0)
	   END +
	   CASE
		   WHEN v.Impuesto3Info = 1 THEN 0.0
		   ELSE ISNULL(d.Impuestos3, 0.0)
	   END + ISNULL(d.Impuestos5, 0.0)
	  ,"EsDeducible" = c.EsDeducible
	  ,"PorcentajeDeducible" = c.PorcentajeDeducible
	  ,"Tipo" = c.Tipo
	  ,d.AcreedorRef
	  ,d.EndosarA
	  ,"AFArticulo" = ISNULL(d.AFArticulo, g.AFArticulo)
	  ,"AFSerie" = ISNULL(d.AFSerie, g.AFSerie)
	  ,g.ClienteRef
	  ,g.ArticuloRef
	  ,d.Lectura
	  ,d.LecturaAnterior
	  ,d.Personal
	  ,d.DepartamentoDetallista
	  ,d.PresupuestoEsp
	  ,c.Impuesto1Excento
	  ,c.Excento2
	  ,c.Excento3
	  ,d.TipoImpuesto1
	  ,d.TipoImpuesto2
	  ,d.TipoImpuesto3
	  ,d.TipoImpuesto5
	  ,d.TipoRetencion1
	  ,d.TipoRetencion2
	  ,d.TipoRetencion3
	  ,d.Impuesto1
	  ,d.Impuesto2
	  ,d.Impuesto3
	  ,d.Impuesto5
FROM Gasto g
JOIN MovTipo mt
	ON g.Mov = mt.Mov
	AND mt.Modulo = 'GAS'
JOIN Version v
	ON 1 = 1
LEFT OUTER JOIN GastoD d
	ON g.ID = d.ID
LEFT OUTER JOIN Concepto c
	ON c.Modulo = 'GAS'
	AND c.Concepto = d.Concepto

