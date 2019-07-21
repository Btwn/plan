USE [IntelisisTmp]
GO

/****** Object:  View [dbo].[Cxcpendiente]    Script Date: 03/06/2019 05:51:42 p. m. ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO



ALTER VIEW [dbo].[Cxcpendiente]
AS
SELECT     Cxc.ID, Cxc.Empresa, Cxc.Mov, Cxc.MovID, Cxc.Cliente, Cxc.ClienteEnviarA, Cxc.ClienteMoneda AS Moneda, Cxc.ClienteTipoCambio AS TipoCambio, Cxc.FechaEmision, Cxc.Vencimiento, DATEDIFF(day, Cxc.FechaEmision, Cxc.Vencimiento) 
                      AS DiasCredito, Cxc.Importe, Cxc.Impuestos, ISNULL(Cxc.Importe, 0.0) + ISNULL(Cxc.Impuestos, 0.0) - ISNULL(Cxc.Retencion, 0.0) 
                      AS ImporteTotal, Cxc.Saldo, Cxc.Referencia, Cxc.Concepto, Cxc.Estatus, DATEDIFF(day, Cxc.Vencimiento, GETDATE()) AS DiasMoratorios,  
					  Cxc.FechaProntoPago, Cxc.DescuentoProntoPago, NULL AS ProntoPago,Cxc.IVAFiscal, Cxc.IEPSFiscal, Cxc.Retencion, Cxc.Situacion, 
					  Cxc.SituacionFecha, Cxc.SituacionUsuario, Cxc.SituacionNota, Cxc.Sucursal, Cxc.OrigenTipo, Cxc.Origen, Cxc.OrigenID, Cxc.Proyecto, Cxc.UEN,
					  Cxc.LineaCredito, Cxc.TipoAmortizacion, Cxc.TipoTasa, Cxc.TasaDiaria, Cxc.Amortizaciones, Cxc.InteresesOrdinarios, Cxc.InteresesFijos, Cxc.InteresesMoratorios, 
                      Cxc.Moneda AS MovMoneda, Cxc.TipoCambio AS MovTipoCambio, dbo.Cxc.RamaID 
            ,Cxc.PadreMAVI, Cxc.PadreIDMAVI, CteFinal              
FROM     Cxc WITH(NOLOCK)
WHERE     (UPPER(Estatus) = 'PENDIENTE')



GO


