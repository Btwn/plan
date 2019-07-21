SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spHistCXCMover
@ID     int,
@Ok     int          OUTPUT,
@OkRef  varchar(255) OUTPUT

AS BEGIN
INSERT hCxc
(ID, Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Codigo, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio, CtaDinero, Cobrador, Condicion, Vencimiento, FormaCobro, Importe, Impuestos, Retencion, AplicaManual, ConDesglose, FormaCobro1, FormaCobro2, FormaCobro3, FormaCobro4, FormaCobro5, Importe1, Importe2, Importe3, Importe4, Importe5, Referencia1, Referencia2, Referencia3, Referencia4, Referencia5, Cambio, DelEfectivo, Agente, ComisionTotal, ComisionPendiente, ComisionGenerada, ComisionCorte, MovAplica, MovAplicaID, Saldo, AutoAjuste, OrigenTipo, Origen, OrigenID, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, FechaProntoPago, DescuentoProntoPago, Indirecto, GenerarDinero, Dinero, DineroID, DineroCtaDinero, DineroConciliado, DineroFechaConciliacion, VIN, FechaEntrega, EmbarqueEstado, Sucursal, Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, ConTramites, Cajero, IVAFiscal, IEPSFiscal, DiferenciaCambiaria, EstaImpreso, AnticipoAplicar, AnticipoAplicaModulo, AnticipoAplicaID, AnticipoSaldo, PersonalCobrador, FechaOriginal, Comentarios, Nota, RamaID, Tasa, TasaDiaria, LineaCredito, TipoTasa, TieneTasaEsp, TasaEsp, TipoAmortizacion, Amortizaciones, InteresesAnticipados, InteresesFijos, InteresesOrdinarios, InteresesMoratorios, Comisiones, ComisionesIVA, CarteraVencidaCNBV, FechaRevision, OperacionRelevante, ContUso, SucursalOrigen, SucursalDestino, Financiamiento, EsCredilana, Mayor12Meses, Depositado, MaxDiasVencidosMAVI, MaxDiasInactivosMAVI, CalificacionMAVI, MOPMAVI, PonderacionCalifMAVI, MOPAnteriorMAVI, SeEnviaBuroCreditoMavi, SaldoDevueltoMAVI, SaldoAplicadoMAVI, RefAnticipoMAVI, CondRef, CoincideMavi, FechaOriginalAnt, InteresMoratorioAnt, InteresesMoratoriosMAVI, EjercicioInst, PeriodoInst, HerramientaInst, Existe, IDCobroBonifMAVI, ReferenciaMAVI, FacDesgloseIVA, PadreMAVI, PadreIDMAVI, ValorAfectar, MaviImpresionCobro, InteresXPolitica, IDPadreMAVI, NoCtaPago, NoParcialidad, CteFinal, CobroTicket, IDBonifCC, BonifCC, IDBonifPP, BonifPP, BonifPPExt, IDBonifAP, CobroCteFinal, ImpApoyoDIMA, SaldoApoyoDIMA, FechaApoyo, Intervencion, SaldoInteresesOrdinarios, SaldoInteresesMoratorios, SubModulo, ContratoID, ContratoMov, ContratoMovID, NoAutoAjustar, NoAutoAplicar, Retencion2, Retencion3, ContUso2, ContUso3, CFDFlexEstatus, CFDTimbrado, TasaRealDiaria, InteresesOrdinariosIVA, InteresesMoratoriosIVA, SaldoInteresesOrdinariosIVA, SaldoInteresesMoratoriosIVA, IVAInteresPorcentaje, EsInteresFijo, TarjetaBancariaAutorizacion, PedidoReferencia, PedidoReferenciaID, POSGUID, Actividad)
SELECT ID, Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario, Autorizacion, Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Codigo, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio, CtaDinero, Cobrador, Condicion, Vencimiento, FormaCobro, Importe, Impuestos, Retencion, AplicaManual, ConDesglose, FormaCobro1, FormaCobro2, FormaCobro3, FormaCobro4, FormaCobro5, Importe1, Importe2, Importe3, Importe4, Importe5, Referencia1, Referencia2, Referencia3, Referencia4, Referencia5, Cambio, DelEfectivo, Agente, ComisionTotal, ComisionPendiente, ComisionGenerada, ComisionCorte, MovAplica, MovAplicaID, Saldo, AutoAjuste, OrigenTipo, Origen, OrigenID, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, FechaProntoPago, DescuentoProntoPago, Indirecto, GenerarDinero, Dinero, DineroID, DineroCtaDinero, DineroConciliado, DineroFechaConciliacion, VIN, FechaEntrega, EmbarqueEstado, Sucursal, Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, ConTramites, Cajero, IVAFiscal, IEPSFiscal, DiferenciaCambiaria, EstaImpreso, AnticipoAplicar, AnticipoAplicaModulo, AnticipoAplicaID, AnticipoSaldo, PersonalCobrador, FechaOriginal, Comentarios, Nota, RamaID, Tasa, TasaDiaria, LineaCredito, TipoTasa, TieneTasaEsp, TasaEsp, TipoAmortizacion, Amortizaciones, InteresesAnticipados, InteresesFijos, InteresesOrdinarios, InteresesMoratorios, Comisiones, ComisionesIVA, CarteraVencidaCNBV, FechaRevision, OperacionRelevante, ContUso, SucursalOrigen, SucursalDestino, Financiamiento, EsCredilana, Mayor12Meses, Depositado, MaxDiasVencidosMAVI, MaxDiasInactivosMAVI, CalificacionMAVI, MOPMAVI, PonderacionCalifMAVI, MOPAnteriorMAVI, SeEnviaBuroCreditoMavi, SaldoDevueltoMAVI, SaldoAplicadoMAVI, RefAnticipoMAVI, CondRef, CoincideMavi, FechaOriginalAnt, InteresMoratorioAnt, InteresesMoratoriosMAVI, EjercicioInst, PeriodoInst, HerramientaInst, Existe, IDCobroBonifMAVI, ReferenciaMAVI, FacDesgloseIVA, PadreMAVI, PadreIDMAVI, ValorAfectar, MaviImpresionCobro, InteresXPolitica, IDPadreMAVI, NoCtaPago, NoParcialidad, CteFinal, CobroTicket, IDBonifCC, BonifCC, IDBonifPP, BonifPP, BonifPPExt, IDBonifAP, CobroCteFinal, ImpApoyoDIMA, SaldoApoyoDIMA, FechaApoyo, Intervencion, SaldoInteresesOrdinarios, SaldoInteresesMoratorios, SubModulo, ContratoID, ContratoMov, ContratoMovID, NoAutoAjustar, NoAutoAplicar, Retencion2, Retencion3, ContUso2, ContUso3, CFDFlexEstatus, CFDTimbrado, TasaRealDiaria, InteresesOrdinariosIVA, InteresesMoratoriosIVA, SaldoInteresesOrdinariosIVA, SaldoInteresesMoratoriosIVA, IVAInteresPorcentaje, EsInteresFijo, TarjetaBancariaAutorizacion, PedidoReferencia, PedidoReferenciaID, POSGUID, Actividad
FROM Cxc
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCxc'
DELETE Cxc WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'Cxc'
INSERT hCxcAplicaDif
(ID, OrdenID, Mov, Concepto, Importe, Impuestos, Cliente, ClienteEnviarA, Referencia, Sucursal, SucursalOrigen)
SELECT ID, OrdenID, Mov, Concepto, Importe, Impuestos, Cliente, ClienteEnviarA, Referencia, Sucursal, SucursalOrigen
FROM CxcAplicaDif
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCxcAplicaDif'
DELETE CxcAplicaDif WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CxcAplicaDif'
INSERT hCxcD
(ID, Renglon, RenglonSub, Importe, Aplica, AplicaID, Fecha, FechaAnterior, Comision, InteresesOrdinarios, InteresesOrdinariosQuita, InteresesMoratorios, InteresesMoratoriosQuita, ImpuestoAdicional, OtrosCargos, Retencion, Ligado, Sucursal, LigadoDR, EsReferencia, Logico1, DescuentoRecargos, SucursalOrigen, Retencion2, Retencion3, InteresesOrdinariosIVA, InteresesOrdinariosTasaDia, InteresesOrdinariosTasaRealDia, InteresesMoratoriosIVA, InteresesMoratoriosTasaDia, InteresesMoratoriosTasaRealDia, InteresesOrdinariosIVADescInfl)
SELECT ID, Renglon, RenglonSub, Importe, Aplica, AplicaID, Fecha, FechaAnterior, Comision, InteresesOrdinarios, InteresesOrdinariosQuita, InteresesMoratorios, InteresesMoratoriosQuita, ImpuestoAdicional, OtrosCargos, Retencion, Ligado, Sucursal, LigadoDR, EsReferencia, Logico1, DescuentoRecargos, SucursalOrigen, Retencion2, Retencion3, InteresesOrdinariosIVA, InteresesOrdinariosTasaDia, InteresesOrdinariosTasaRealDia, InteresesMoratoriosIVA, InteresesMoratoriosTasaDia, InteresesMoratoriosTasaRealDia, InteresesOrdinariosIVADescInfl
FROM CxcD
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCxcD'
DELETE CxcD WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CxcD'
INSERT hCxcFacturaAnticipo
(ID, CxcID, Importe, Sucursal, SucursalOrigen)
SELECT ID, CxcID, Importe, Sucursal, SucursalOrigen
FROM CxcFacturaAnticipo
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCxcFacturaAnticipo'
DELETE CxcFacturaAnticipo WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CxcFacturaAnticipo'
INSERT hCxcVoucher
(ID, RID, Sucursal, Mov, Referencia, Concepto, EnviarA, Cargo, Abono, Nuevo, Aceptar, IDAplica, SucursalOrigen)
SELECT ID, RID, Sucursal, Mov, Referencia, Concepto, EnviarA, Cargo, Abono, Nuevo, Aceptar, IDAplica, SucursalOrigen
FROM CxcVoucher
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hCxcVoucher'
DELETE CxcVoucher WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'CxcVoucher'
RETURN
END
;

