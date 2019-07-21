SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spHistCXPMover
@ID     int,
@Ok     int          OUTPUT,
@OkRef  varchar(255) OUTPUT

AS BEGIN
INSERT hCxp
(ID, Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Proveedor, ProveedorSucursal, ProveedorMoneda, ProveedorTipoCambio, CtaDinero, Condicion, Vencimiento, FormaPago, Importe, Impuestos, Retencion, Retencion2, Retencion3, AplicaManual, Beneficiario, MovAplica, MovAplicaID, Saldo, AutoAjuste, OrigenTipo, Origen, OrigenID, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, FechaProntoPago, DescuentoProntoPago, Indirecto, Conciliado, GenerarDinero, Dinero, DineroID, DineroCtaDinero, DineroConciliado, DineroFechaConciliacion, Sucursal, Mensaje, Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, EstaImpreso, Cajero, Aforo, IVAFiscal, IEPSFiscal, DiferenciaCambiaria, ProveedorAutoEndoso, FechaProgramada, Comentarios, Nota, Tasa, TasaDiaria, RamaID, LineaCredito, TipoAmortizacion, TipoTasa, Amortizaciones, InteresesAnticipados, InteresesFijos, InteresesOrdinarios, InteresesMoratorios, Comisiones, ComisionesIVA, VIN, RetencionAlPago, OperacionRelevante, ContUso, TieneTasaEsp, TasaEsp, SucursalOrigen, SucursalDestino, VencimientoProveedor, InteresesRetencion, InteresesFijosRetencion, SaldoInteresesOrdinarios, SaldoInteresesMoratorios, ContratoID, ContratoMov, ContratoMovID, ContUso2, ContUso3, ConsignacionFechaCorte, NoAutoAjustar, NoAutoAplicar, CFDFlexEstatus, InteresesOrdinariosIVA, InteresesMoratoriosIVA, SaldoInteresesOrdinariosIVA, SaldoInteresesMoratoriosIVA, IVAInteresPorcentaje, EsInteresFijo, EmidaCarrierID, EmidaRequestId, Actividad, CFDRetencionTimbrado)
SELECT ID, Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Proveedor, ProveedorSucursal, ProveedorMoneda, ProveedorTipoCambio, CtaDinero, Condicion, Vencimiento, FormaPago, Importe, Impuestos, Retencion, Retencion2, Retencion3, AplicaManual, Beneficiario, MovAplica, MovAplicaID, Saldo, AutoAjuste, OrigenTipo, Origen, OrigenID, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, FechaProntoPago, DescuentoProntoPago, Indirecto, Conciliado, GenerarDinero, Dinero, DineroID, DineroCtaDinero, DineroConciliado, DineroFechaConciliacion, Sucursal, Mensaje, Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, EstaImpreso, Cajero, Aforo, IVAFiscal, IEPSFiscal, DiferenciaCambiaria, ProveedorAutoEndoso, FechaProgramada, Comentarios, Nota, Tasa, TasaDiaria, RamaID, LineaCredito, TipoAmortizacion, TipoTasa, Amortizaciones, InteresesAnticipados, InteresesFijos, InteresesOrdinarios, InteresesMoratorios, Comisiones, ComisionesIVA, VIN, RetencionAlPago, OperacionRelevante, ContUso, TieneTasaEsp, TasaEsp, SucursalOrigen, SucursalDestino, VencimientoProveedor, InteresesRetencion, InteresesFijosRetencion, SaldoInteresesOrdinarios, SaldoInteresesMoratorios, ContratoID, ContratoMov, ContratoMovID, ContUso2, ContUso3, ConsignacionFechaCorte, NoAutoAjustar, NoAutoAplicar, CFDFlexEstatus, InteresesOrdinariosIVA, InteresesMoratoriosIVA, SaldoInteresesOrdinariosIVA, SaldoInteresesMoratoriosIVA, IVAInteresPorcentaje, EsInteresFijo, EmidaCarrierID, EmidaRequestId, Actividad, CFDRetencionTimbrado
FROM Cxp
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCxp'
DELETE Cxp WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'Cxp'
INSERT hCxpAplicaDif
(ID, OrdenID, Mov, Concepto, Importe, Impuestos, Referencia, Sucursal, SucursalOrigen)
SELECT ID, OrdenID, Mov, Concepto, Importe, Impuestos, Referencia, Sucursal, SucursalOrigen
FROM CxpAplicaDif
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCxpAplicaDif'
DELETE CxpAplicaDif WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CxpAplicaDif'
INSERT hCxpD
(ID, Renglon, RenglonSub, Importe, Aplica, AplicaID, Fecha, FechaAnterior, Ligado, Sucursal, LigadoDR, Logico1, DescuentoRecargos, InteresesOrdinarios, InteresesOrdinariosQuita, InteresesMoratorios, InteresesMoratoriosQuita, Retencion, SucursalOrigen, InteresesOrdinariosIVA, InteresesOrdinariosTasaDia, InteresesOrdinariosTasaRealDia, InteresesMoratoriosIVA, InteresesMoratoriosTasaDia, InteresesMoratoriosTasaRealDia, InteresesOrdinariosIVADescInfl)
SELECT ID, Renglon, RenglonSub, Importe, Aplica, AplicaID, Fecha, FechaAnterior, Ligado, Sucursal, LigadoDR, Logico1, DescuentoRecargos, InteresesOrdinarios, InteresesOrdinariosQuita, InteresesMoratorios, InteresesMoratoriosQuita, Retencion, SucursalOrigen, InteresesOrdinariosIVA, InteresesOrdinariosTasaDia, InteresesOrdinariosTasaRealDia, InteresesMoratoriosIVA, InteresesMoratoriosTasaDia, InteresesMoratoriosTasaRealDia, InteresesOrdinariosIVADescInfl
FROM CxpD
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCxpD'
DELETE CxpD WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CxpD'
RETURN
END
;

