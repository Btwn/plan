SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spHistAsisteMover
@ID     int,
@Ok     int          OUTPUT,
@OkRef  varchar(255) OUTPUT

AS BEGIN
INSERT hAsiste
(ID, Empresa, Mov, MovID, FechaEmision, FechaAplicacion, UltimoCambio, Proyecto, UEN, Moneda, TipoCambio, Usuario, Autorizacion, DocFuente, Observaciones, Referencia, Estatus, Tipo, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Localidad, FechaD, FechaA, OrigenTipo, Origen, OrigenID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Poliza, PolizaID, GenerarPoliza, ContID, Sucursal, Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, Logico7, Logico8, Logico9, SucursalOrigen, SucursalDestino)
SELECT ID, Empresa, Mov, MovID, FechaEmision, FechaAplicacion, UltimoCambio, Proyecto, UEN, Moneda, TipoCambio, Usuario, Autorizacion, DocFuente, Observaciones, Referencia, Estatus, Tipo, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Localidad, FechaD, FechaA, OrigenTipo, Origen, OrigenID, Ejercicio, Periodo, FechaRegistro, FechaConclusion, FechaCancelacion, Poliza, PolizaID, GenerarPoliza, ContID, Sucursal, Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, Logico7, Logico8, Logico9, SucursalOrigen, SucursalDestino
FROM Asiste
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hAsiste'
DELETE Asiste WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'Asiste'
INSERT hAsisteD
(ID, Renglon, Recurso, Personal, Registro, HoraRegistro, HoraD, HoraA, FechaD, FechaA, Concepto, Cantidad, Tipo, Observaciones, Sucursal, Fecha, Proyecto, Actividad, Costo, Retardo, ActividadEstado, ActividadAvance, MovimientoRef, Logico1, Logico2, Logico3, Logico4, Logico5, SucursalOrigen, Extra, GestionRef, ActividadABCRef, MapaLatitud, MapaLongitud, MapaPrecision, MapaUbicacion)
SELECT ID, Renglon, Recurso, Personal, Registro, HoraRegistro, HoraD, HoraA, FechaD, FechaA, Concepto, Cantidad, Tipo, Observaciones, Sucursal, Fecha, Proyecto, Actividad, Costo, Retardo, ActividadEstado, ActividadAvance, MovimientoRef, Logico1, Logico2, Logico3, Logico4, Logico5, SucursalOrigen, Extra, GestionRef, ActividadABCRef, MapaLatitud, MapaLongitud, MapaPrecision, MapaUbicacion
FROM AsisteD
WITH(NOLOCK) WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61010, @OkRef = 'hAsisteD'
DELETE AsisteD WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 61020, @OkRef = 'AsisteD'
RETURN
END
;

