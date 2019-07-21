SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovCopiarProyecto
@Empresa                varchar(5),
@Sucursal               int,
@ID                     int,
@IDGenerar              int

AS BEGIN
INSERT ProyectoRecurso (
ID,         Recurso, Estatus, TieneMovimientos, Rol, HorasDia, PrecioHora, CostoHora, Comienzo, ComienzoProgramado, Fin, FinProgramado, Sucursal,  SucursalOrigen, SucursalDestino)
SELECT @IDGenerar, Recurso, Estatus, TieneMovimientos, Rol, HorasDia, PrecioHora, CostoHora, Comienzo, ComienzoProgramado, Fin, FinProgramado, @Sucursal, @Sucursal,      @Sucursal
FROM ProyectoRecurso
WHERE ID = @ID
INSERT ProyectoDRecurso ( ID, Actividad, Recurso, Comienzo, Fin, Sucursal, SucursalOrigen, SucursalDestino)
SELECT @IDGenerar, Actividad, Recurso, Comienzo, Fin, @Sucursal, @Sucursal, @Sucursal
FROM ProyectoDRecurso
WHERE ID = @ID
INSERT ProyectoDia ( ID, Fecha, HorasDia, Concepto, Sucursal, SucursalOrigen, SucursalDestino)
SELECT @IDGenerar, Fecha, HorasDia, Concepto, @Sucursal, @Sucursal, @Sucursal
FROM ProyectoDia
WHERE ID = @ID
INSERT MovCto (
Modulo, ModuloID,   Nombre, ApellidoPaterno, ApellidoMaterno, Atencion, Tratamiento, Cargo, Grupo, FechaNacimiento, Telefonos, Extencion, eMail, Fax, PedirTono, Tipo, Sexo, Usuario)
SELECT Modulo, @IDGenerar, Nombre, ApellidoPaterno, ApellidoMaterno, Atencion, Tratamiento, Cargo, Grupo, FechaNacimiento, Telefonos, Extencion, eMail, Fax, PedirTono, Tipo, Sexo, Usuario
FROM MovCto
WHERE ModuloID = @ID
INSERT ProyectoDArtMaterial (
ID,         Actividad, Material, SubCuenta, Cantidad, Unidad, Almacen)
SELECT  @IDGenerar, Actividad, Material, SubCuenta, Cantidad, Unidad, Almacen
FROM ProyectoDArtMaterial WHERE ID = @ID
RETURN
END

