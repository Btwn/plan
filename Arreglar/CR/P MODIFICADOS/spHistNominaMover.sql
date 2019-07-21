SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spHistNominaMover
@ID     int,
@Ok     int          OUTPUT,
@OkRef  varchar(255) OUTPUT

AS BEGIN
INSERT hDimCfg
(ID, Empresa, Columna, Titulo, Descripcion, Tipo, Obligatorio, Campo)
SELECT ID, Empresa, Columna, Titulo, Descripcion, Tipo, Obligatorio, Campo
FROM DimCfg WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hDimCfg'
DELETE DimCfg WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'DimCfg'
INSERT hDimListaConcepto
(ID, NominaConcepto, Concepto, Empresa)
SELECT ID, NominaConcepto, Concepto, Empresa
FROM DimListaConcepto WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hDimListaConcepto'
DELETE DimListaConcepto WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'DimListaConcepto'
INSERT hDimPaso
(id, Estacion, Personal, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, Dim9, Dim10, Dim11, Dim12, Dim13, Dim14, Dim15, Dim16, Dim17, Dim18, Dim19, Dim20, Dim21, Dim22, Dim23, Dim24, Dim25, Dim26, Dim27, Dim28, Dim29, Dim30, Dim31, Dim32, Dim33, Dim34, Dim35, Dim36, Dim37, Dim38, Dim39, Dim40, Dim41, Dim42, Dim43, Dim44, Dim45, Dim46, Dim47, Dim48, Dim49, Dim50, Dim51, Dim52, Dim53, Dim54, Dim55, Dim56, Dim57, Dim58, Dim59, Dim60, Dim61, Dim62, Dim63, Dim64, Dim65, Dim66, Dim67, Dim68, Dim69, Dim70, Dim71, Dim72, Dim73, Dim74, Dim75, Dim76, Dim77, Dim78, Dim79, Dim80, Dim81, Dim82, Dim83, Dim84, Dim85, Dim86, Dim87, Dim88, Dim89, Dim90, Dim91, Dim92, Dim93, Dim94, Dim95, Dim96, Dim97, Dim98, Dim99, Dim100, Dim101, Dim102, Dim103, Dim104, Dim105, Dim106, Dim107, Dim108, Dim109, Dim110, Dim111, Dim112, Dim113, Dim114, Dim115, Dim116, Dim117, Dim118, Dim119, Dim120, Dim121, Dim122, Dim123, Dim124, Dim125, Dim126, Dim127, Dim128, Dim129, Dim130, Dim131, Dim132, Dim133, Dim134, Dim135, Dim136, Dim137, Dim138, Dim139, Dim140)
SELECT id, Estacion, Personal, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, Dim9, Dim10, Dim11, Dim12, Dim13, Dim14, Dim15, Dim16, Dim17, Dim18, Dim19, Dim20, Dim21, Dim22, Dim23, Dim24, Dim25, Dim26, Dim27, Dim28, Dim29, Dim30, Dim31, Dim32, Dim33, Dim34, Dim35, Dim36, Dim37, Dim38, Dim39, Dim40, Dim41, Dim42, Dim43, Dim44, Dim45, Dim46, Dim47, Dim48, Dim49, Dim50, Dim51, Dim52, Dim53, Dim54, Dim55, Dim56, Dim57, Dim58, Dim59, Dim60, Dim61, Dim62, Dim63, Dim64, Dim65, Dim66, Dim67, Dim68, Dim69, Dim70, Dim71, Dim72, Dim73, Dim74, Dim75, Dim76, Dim77, Dim78, Dim79, Dim80, Dim81, Dim82, Dim83, Dim84, Dim85, Dim86, Dim87, Dim88, Dim89, Dim90, Dim91, Dim92, Dim93, Dim94, Dim95, Dim96, Dim97, Dim98, Dim99, Dim100, Dim101, Dim102, Dim103, Dim104, Dim105, Dim106, Dim107, Dim108, Dim109, Dim110, Dim111, Dim112, Dim113, Dim114, Dim115, Dim116, Dim117, Dim118, Dim119, Dim120, Dim121, Dim122, Dim123, Dim124, Dim125, Dim126, Dim127, Dim128, Dim129, Dim130, Dim131, Dim132, Dim133, Dim134, Dim135, Dim136, Dim137, Dim138, Dim139, Dim140
FROM DimPaso
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hDimPaso'
DELETE DimPaso WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'DimPaso'
INSERT hImpuestoEstatalGastoOperacion
(ID, sucursal, GastoOperacion)
SELECT ID, sucursal, GastoOperacion
FROM ImpuestoEstatalGastoOperacion WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hImpuestoEstatalGastoOperacion'
DELETE ImpuestoEstatalGastoOperacion WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'ImpuestoEstatalGastoOperacion'
INSERT hNomina
(ID, Empresa, Mov, MovID, FechaEmision, UltimoCambio, Proyecto, UEN, Concepto, Moneda, TipoCambio, Usuario, Autorizacion, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, OrigenTipo, Origen, OrigenID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Condicion, PeriodoTipo, FechaD, FechaA, Poliza, PolizaID, GenerarPoliza, ContID, Sucursal, Percepciones, Deducciones, Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, Logico7, Logico8, Logico9, FechaOrigen, FechaRegistroNomXD, FechaRegistroNomXA, RamaID, SucursalOrigen, SucursalDestino, NOI, CFDTimbrado)
SELECT ID, Empresa, Mov, MovID, FechaEmision, UltimoCambio, Proyecto, UEN, Concepto, Moneda, TipoCambio, Usuario, Autorizacion, DocFuente, Observaciones, Estatus, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, OrigenTipo, Origen, OrigenID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Condicion, PeriodoTipo, FechaD, FechaA, Poliza, PolizaID, GenerarPoliza, ContID, Sucursal, Percepciones, Deducciones, Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, Logico7, Logico8, Logico9, FechaOrigen, FechaRegistroNomXD, FechaRegistroNomXA, RamaID, SucursalOrigen, SucursalDestino, NOI, CFDTimbrado
FROM Nomina
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hNomina'
DELETE Nomina WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'Nomina'
INSERT hNominaD
(ID, Renglon, Modulo, Plaza, Personal, Cuenta, Importe, Horas, Cantidad, Concepto, Referencia, Beneficiario, FormaPago, Porcentaje, Monto, FechaD, FechaA, Movimiento, ContUso, CuentaContable, UEN, NominaConcepto, IncidenciaID, ObligacionFiscal, Saldo, CantidadPendiente, Activo, Sucursal, Logico1, Logico2, Logico3, Logico4, Logico5, SucursalOrigen, CuentaContable2, ClavePresupuestal)
SELECT ID, Renglon, Modulo, Plaza, Personal, Cuenta, Importe, Horas, Cantidad, Concepto, Referencia, Beneficiario, FormaPago, Porcentaje, Monto, FechaD, FechaA, Movimiento, ContUso, CuentaContable, UEN, NominaConcepto, IncidenciaID, ObligacionFiscal, Saldo, CantidadPendiente, Activo, Sucursal, Logico1, Logico2, Logico3, Logico4, Logico5, SucursalOrigen, CuentaContable2, ClavePresupuestal
FROM NominaD
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hNominaD'
DELETE NominaD WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'NominaD'
INSERT hNominaPersonal
(ID, Personal, SucursalTrabajo, CentroCostos, Actividad, UEN, Sucursal, Puesto, FormaPago, Proyecto, UltimoPago, SucursalOrigen, SucursalDestino, SueldoDiario, SDIEstaNomina, Departamento, Categoria, Grupo, Jornada, TipoContrato, TipoSueldo, RegistroPatronal, ZonaEconomica, FechaAntiguedad, Estado)
SELECT ID, Personal, SucursalTrabajo, CentroCostos, Actividad, UEN, Sucursal, Puesto, FormaPago, Proyecto, UltimoPago, SucursalOrigen, SucursalDestino, SueldoDiario, SDIEstaNomina, Departamento, Categoria, Grupo, Jornada, TipoContrato, TipoSueldo, RegistroPatronal, ZonaEconomica, FechaAntiguedad, Estado
FROM NominaPersonal WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hNominaPersonal'
DELETE NominaPersonal WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'NominaPersonal'
INSERT hNominaPersonalFecha
(ID, Personal, FechaD, FechaA, Sucursal, SucursalOrigen, SucursalDestino)
SELECT ID, Personal, FechaD, FechaA, Sucursal, SucursalOrigen, SucursalDestino
FROM NominaPersonalFecha WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hNominaPersonalFecha'
DELETE NominaPersonalFecha WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'NominaPersonalFecha'
INSERT hNominaPersonalProy
(ID, Personal, Proyecto, Sucursal, SucursalOrigen, SucursalDestino)
SELECT ID, Personal, Proyecto, Sucursal, SucursalOrigen, SucursalDestino
FROM NominaPersonalProy WITH(NOLOCK)
WHERE  ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hNominaPersonalProy'
DELETE NominaPersonalProy WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'NominaPersonalProy'
RETURN
END
;

