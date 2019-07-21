SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spHistEmbarqueMover
@ID     int,
@Ok     int          OUTPUT,
@OkRef  varchar(255) OUTPUT

AS BEGIN
INSERT hEmbarque
(ID, Empresa, Mov, MovID, Moneda, TipoCambio, FechaEmision, UltimoCambio, Proyecto, UEN, Usuario, Autorizacion, Concepto, Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Vehiculo, Ruta, Agente, Gastos, Proveedor, Importe, Impuestos, Condicion, Vencimiento, CxpReferencia, PersonalCobrador, Volumen, Peso, Paquetes, OrigenTipo, Origen, OrigenID, CtaDinero, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, FechaSalida, FechaRetorno, KmsSalida, KmsRetorno, TermoInicio, TermoFin, DiaRetorno, Sucursal, Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, Logico7, Logico8, Logico9, ImporteEmbarque, SucursalOrigen, SucursalDestino, LicenciaAgente, Agente2, LicenciaAgente2, EjercicioMavi, QuincenaMavi, HerramientaRecMavi, FleteMagisterio, Consecutivo, ConsPeriodo, ConsEjercicio, ProgramadoPara, UsrConcluyeEmb, FechaConcluyeEmb, TempInicio, TempFin)
SELECT ID, Empresa, Mov, MovID, Moneda, TipoCambio, FechaEmision, UltimoCambio, Proyecto, UEN, Usuario, Autorizacion, Concepto, Referencia, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Vehiculo, Ruta, Agente, Gastos, Proveedor, Importe, Impuestos, Condicion, Vencimiento, CxpReferencia, PersonalCobrador, Volumen, Peso, Paquetes, OrigenTipo, Origen, OrigenID, CtaDinero, Poliza, PolizaID, GenerarPoliza, ContID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, FechaSalida, FechaRetorno, KmsSalida, KmsRetorno, TermoInicio, TermoFin, DiaRetorno, Sucursal, Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, Logico7, Logico8, Logico9, ImporteEmbarque, SucursalOrigen, SucursalDestino, LicenciaAgente, Agente2, LicenciaAgente2, EjercicioMavi, QuincenaMavi, HerramientaRecMavi, FleteMagisterio, Consecutivo, ConsPeriodo, ConsEjercicio, ProgramadoPara, UsrConcluyeEmb, FechaConcluyeEmb, TempInicio, TempFin
FROM Embarque
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hEmbarque'
DELETE Embarque WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'Embarque'
INSERT hEmbarqueD
(ID, Orden, EmbarqueMov, Paquetes, Estado, FechaHora, Persona, PersonaID, Forma, Importe, Referencia, Observaciones, Causa, Sucursal, Logico1, Logico2, Logico3, Logico4, Logico5, MovPorcentaje, DesembarqueParcial, SucursalOrigen, ParaComisionChoferMAVI)
SELECT ID, Orden, EmbarqueMov, Paquetes, Estado, FechaHora, Persona, PersonaID, Forma, Importe, Referencia, Observaciones, Causa, Sucursal, Logico1, Logico2, Logico3, Logico4, Logico5, MovPorcentaje, DesembarqueParcial, SucursalOrigen, ParaComisionChoferMAVI
FROM EmbarqueD
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hEmbarqueD'
DELETE EmbarqueD WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'EmbarqueD'
INSERT hEmbarqueDArt
(ID, EmbarqueMov, Modulo, ModuloID, Renglon, RenglonSub, ImporteTotal, CantidadTotal, Cantidad, Sucursal, SucursalOrigen, Tarima)
SELECT ID, EmbarqueMov, Modulo, ModuloID, Renglon, RenglonSub, ImporteTotal, CantidadTotal, Cantidad, Sucursal, SucursalOrigen, Tarima
FROM EmbarqueDArt
WHERE ModuloID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hEmbarqueDArt'
DELETE EmbarqueDArt WHERE ModuloID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'EmbarqueDArt'
RETURN
END
;

