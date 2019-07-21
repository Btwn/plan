SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spHistDineroMover
@ID     int,
@Ok     int          OUTPUT,
@OkRef  varchar(255) OUTPUT

AS BEGIN
INSERT hDinero
(ID, Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, DocFuente, Observaciones, Usuario, Autorizacion, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Directo, BeneficiarioNombre, LeyendaCheque, Beneficiario, CtaDinero, CtaDineroDestino, ConDesglose, Contacto, ContactoTipo, ContactoEnviarA, Importe, Comisiones, Impuestos, Saldo, FechaProgramada, FormaPago, Cajero, OrigenTipo, Origen, OrigenID, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Corte, CorteDestino, FechaEntrega, EmbarqueEstado, InstitucionMensaje, InstitucionSucursal, InstitucionReferencia1, InstitucionReferencia2, AutoConciliar, Sucursal, Mensaje, Liberar, IVAFiscal, IEPSFiscal, EstaImpreso, TipoCambioDestino, Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, Logico7, Logico8, Logico9, Conciliado, FechaConciliacion, ProveedorAutoEndoso, CargoBancario, CargoBancarioIVA, Prioridad, Comentarios, Nota, FechaOrigen, ValorOrigen, Vencimiento, InteresTipo, Titulo, TituloValor, Tasa, TasaDias, TasaRetencion, Retencion, ContUso, OperacionRelevante, Cliente, ClienteEnviarA, Proveedor, SucursalOrigen, SucursalDestino, CtaBeneficiario, NumeroCheque, Institucion, RFCReceptor, IdVenta, FolioFIADE, ContUso2, ContUso3, ChequeDevuelto, CorteImporte, EmidaRequestId, CFDRetencionTimbrado)
SELECT ID, Empresa, Mov, MovID, FechaEmision, UltimoCambio, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, DocFuente, Observaciones, Usuario, Autorizacion, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Directo, BeneficiarioNombre, LeyendaCheque, Beneficiario, CtaDinero, CtaDineroDestino, ConDesglose, Contacto, ContactoTipo, ContactoEnviarA, Importe, Comisiones, Impuestos, Saldo, FechaProgramada, FormaPago, Cajero, OrigenTipo, Origen, OrigenID, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Corte, CorteDestino, FechaEntrega, EmbarqueEstado, InstitucionMensaje, InstitucionSucursal, InstitucionReferencia1, InstitucionReferencia2, AutoConciliar, Sucursal, Mensaje, Liberar, IVAFiscal, IEPSFiscal, EstaImpreso, TipoCambioDestino, Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, Logico7, Logico8, Logico9, Conciliado, FechaConciliacion, ProveedorAutoEndoso, CargoBancario, CargoBancarioIVA, Prioridad, Comentarios, Nota, FechaOrigen, ValorOrigen, Vencimiento, InteresTipo, Titulo, TituloValor, Tasa, TasaDias, TasaRetencion, Retencion, ContUso, OperacionRelevante, Cliente, ClienteEnviarA, Proveedor, SucursalOrigen, SucursalDestino, CtaBeneficiario, NumeroCheque, Institucion, RFCReceptor, IdVenta, FolioFIADE, ContUso2, ContUso3, ChequeDevuelto, CorteImporte, EmidaRequestId, CFDRetencionTimbrado
FROM Dinero
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hDinero'
DELETE Dinero WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'Dinero'
INSERT hDineroD
(ID, Renglon, RenglonSub, Importe, FormaPago, Referencia, Aplica, AplicaID, Sucursal, ContUso, Institucion, SucursalOrigen, BeneficiarioNombre, CtaBeneficiario, NumeroCheque, RFCReceptor, ContUso2, ContUso3, CtaDinero, Moneda, CtaDineroDestino, TipoCambio)
SELECT ID, Renglon, RenglonSub, Importe, FormaPago, Referencia, Aplica, AplicaID, Sucursal, ContUso, Institucion, SucursalOrigen, BeneficiarioNombre, CtaBeneficiario, NumeroCheque, RFCReceptor, ContUso2, ContUso3, CtaDinero, Moneda, CtaDineroDestino, TipoCambio
FROM DineroD WITH(NOLOCK)
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hDineroD'
DELETE DineroD WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'DineroD'
INSERT hMovCorteDetalle
(IDcorte, ID, Mov, MovID, CorteImporte, Cancelado)
SELECT IDcorte, ID, Mov, MovID, CorteImporte, Cancelado
FROM MovCorteDetalle WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hMovCorteDetalle'
DELETE MovCorteDetalle WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'MovCorteDetalle'
RETURN
END
;

