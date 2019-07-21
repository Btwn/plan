SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCtePerfil ON Cte

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@ClaveN		varchar(10),
@ClaveA		varchar(10),
@EsProveedor	bit,
@EsPersonal		bit,
@EsAgente		bit,
@EsAlmacen		bit,
@EsEspacio		bit,
@EsCentroCostos	bit,
@EsProyecto		bit,
@EsCentroTrabajo	bit,
@EsEstacionTrabajo	bit
IF dbo.fnEstaSincronizando() = 1 RETURN
IF UPDATE(Cliente) OR UPDATE(Nombre) OR UPDATE(Direccion) OR UPDATE(EntreCalles) OR UPDATE(Plano)
OR UPDATE(Delegacion) OR UPDATE(Colonia) OR UPDATE(Poblacion) OR UPDATE(Estado) OR UPDATE(Pais) OR UPDATE(Zona)
OR UPDATE(CodigoPostal) OR UPDATE(RFC) OR UPDATE(CURP) OR UPDATE(Telefonos) OR UPDATE(Fax)
OR UPDATE(EsProveedor) OR UPDATE(EsPersonal) OR UPDATE(EsAgente) OR UPDATE(EsAlmacen) OR UPDATE(EsEspacio)
OR UPDATE(EsCentroCostos) OR UPDATE(EsProyecto) OR UPDATE(EsCentroTrabajo) OR UPDATE(EsEstacionTrabajo)
OR UPDATE(PersonalNombres) OR UPDATE(PersonalApellidoPaterno) OR UPDATE(PersonalApellidoMaterno)
BEGIN
SELECT @ClaveN = Cliente, @EsProveedor = EsProveedor, @EsPersonal = EsPersonal, @EsAgente = EsAgente, @EsAlmacen = EsAlmacen, @EsEspacio = EsEspacio, @EsCentroCostos = EsCentroCostos, @EsProyecto = EsProyecto, @EsCentroTrabajo = EsCentroTrabajo, @EsEstacionTrabajo = EsEstacionTrabajo FROM Inserted
SELECT @ClaveA = Cliente FROM Deleted
IF @ClaveN IS NULL
BEGIN
SELECT @EsProveedor = EsProveedor, @EsPersonal = EsPersonal, @EsAgente = EsAgente, @EsAlmacen = EsAlmacen, @EsEspacio = EsEspacio, @EsCentroCostos = EsCentroCostos, @EsProyecto = EsProyecto, @EsCentroTrabajo = EsCentroTrabajo, @EsEstacionTrabajo = EsEstacionTrabajo FROM Deleted
IF @EsProveedor       = 1 DELETE Prov         WHERE Proveedor    = @ClaveA
IF @EsPersonal        = 1 DELETE Personal     WHERE Personal     = @ClaveA
IF @EsAgente          = 1 DELETE Agente       WHERE Agente       = @ClaveA
IF @EsAlmacen         = 1 DELETE Alm          WHERE Almacen      = @ClaveA
IF @EsEspacio         = 1 DELETE Espacio      WHERE Espacio      = @ClaveA
IF @EsCentroCostos    = 1 DELETE CentroCostos WHERE CentroCostos = @ClaveA
IF @EsProyecto        = 1 DELETE Proy         WHERE Proyecto     = @ClaveA
IF @EsCentroTrabajo   = 1 DELETE Centro       WHERE Centro       = @ClaveA
IF @EsEstacionTrabajo = 1 DELETE EstacionT    WHERE Estacion     = @ClaveA
END ELSE
BEGIN
IF @EsProveedor = 1
BEGIN
UPDATE Prov
SET Nombre = i.Nombre, Direccion = i.Direccion, EntreCalles = i.EntreCalles, Plano = i.Plano, Delegacion = i.Delegacion, Colonia = i.Colonia, Poblacion = i.Poblacion, Estado = i.Estado, Pais = i.Pais, Zona = i.Zona, CodigoPostal = i.CodigoPostal, RFC = i.RFC, CURP = i.CURP, Telefonos = i.Telefonos, Fax = i.Fax
FROM Prov p, Inserted i
WHERE p.Proveedor = @ClaveN
IF @@ROWCOUNT = 0
INSERT Prov (Proveedor, Nombre, BeneficiarioNombre, Direccion, EntreCalles, Plano, Delegacion, Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, Telefonos, Fax, DefMoneda, Tipo,         Estatus, Alta)
SELECT Cliente,   Nombre, Nombre,             Direccion, EntreCalles, Plano, Delegacion, Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, Telefonos, Fax, DefMoneda, 'Proveedor', 'ALTA',   GETDATE() FROM Inserted
END
IF @EsPersonal = 1
BEGIN
UPDATE Personal
SET Nombre = i.PersonalNombres, ApellidoPaterno = i.PersonalApellidoPaterno, ApellidoMaterno = i.PersonalApellidoMaterno,
Direccion = i.Direccion, Delegacion = i.Delegacion, Colonia = i.Colonia, Poblacion = i.Poblacion, Estado = i.Estado, Pais = i.Pais, CodigoPostal = i.CodigoPostal, Registro2 = i.RFC, Registro = i.CURP, Telefono = i.Telefonos
FROM Personal p, Inserted i
WHERE p.Personal = @ClaveN
IF @@ROWCOUNT = 0
INSERT Personal (Personal, Nombre,                          ApellidoPaterno,         ApellidoMaterno,         Direccion, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Registro2, Registro, Telefono,  Moneda,     Tipo,      Estatus,     FechaAlta)
SELECT Cliente,  ISNULL(PersonalNombres, Nombre), PersonalApellidoPaterno, PersonalApellidoMaterno, Direccion, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, RFC,       CURP,     Telefonos, DefMoneda, 'Empleado', 'ASPIRANTE', GETDATE() FROM Inserted
END
IF @EsAgente = 1
BEGIN
UPDATE Agente
SET Nombre = i.Nombre, Direccion = i.Direccion, Colonia = i.Colonia, Poblacion = i.Poblacion, Estado = i.Estado, Pais = i.Pais, Zona = i.Zona, CodigoPostal = i.CodigoPostal, RFC = i.RFC, CURP = i.CURP, Telefonos = i.Telefonos
FROM Agente a, Inserted i
WHERE a.Agente = @ClaveN
IF @@ROWCOUNT = 0
INSERT Agente (Agente,  Nombre, BeneficiarioNombre, Direccion, Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, Telefonos, Tipo,      Estatus, Alta)
SELECT Cliente, Nombre, Nombre,             Direccion, Colonia, Poblacion, Estado, Pais, Zona, CodigoPostal, RFC, CURP, Telefonos, 'Agente', 'ALTA',   GETDATE() FROM Inserted
END
IF @EsAlmacen = 1
BEGIN
UPDATE Alm
SET Nombre = i.Nombre, Direccion = i.Direccion, EntreCalles = i.EntreCalles, Plano = i.Plano, Delegacion = i.Delegacion, Colonia = i.Colonia, Poblacion = i.Poblacion, Estado = i.Estado, Pais = i.Pais, CodigoPostal = i.CodigoPostal, Telefonos = i.Telefonos
FROM Alm a, Inserted i
WHERE a.Almacen = @ClaveN
IF @@ROWCOUNT = 0
INSERT Alm (Almacen, Nombre, Direccion, EntreCalles, Plano, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Telefonos, Tipo,     Estatus, Alta,      Sucursal)
SELECT Cliente, Nombre, Direccion, EntreCalles, Plano, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Telefonos, 'Normal', 'ALTA',  GETDATE(), ISNULL(SucursalEmpresa, 0) FROM Inserted
END
IF @EsEspacio = 1
BEGIN
UPDATE Espacio
SET Nombre = i.Nombre
FROM Espacio e, Inserted i
WHERE e.Espacio = @ClaveN
IF @@ROWCOUNT = 0
INSERT Espacio (Espacio, Nombre, Estatus, Alta)
SELECT Cliente, Nombre, 'ALTA', GETDATE() FROM Inserted
END
IF @EsCentroCostos = 1
BEGIN
UPDATE CentroCostos
SET Descripcion = i.Nombre
FROM CentroCostos c, Inserted i
WHERE c.CentroCostos = @ClaveN
IF @@ROWCOUNT = 0
INSERT CentroCostos (CentroCostos, Descripcion)
SELECT Cliente,      Nombre       FROM Inserted
END
IF @EsProyecto = 1
BEGIN
UPDATE Proy
SET Descripcion = i.Nombre, Direccion = i.Direccion, EntreCalles = i.EntreCalles, Plano = i.Plano, Delegacion = i.Delegacion, Colonia = i.Colonia, Poblacion = i.Poblacion, Estado = i.Estado, Pais = i.Pais, CodigoPostal = i.CodigoPostal
FROM Proy p, Inserted i
WHERE p.Proyecto = @ClaveN
IF @@ROWCOUNT = 0
INSERT Proy (Proyecto, Descripcion, Direccion, EntreCalles, Plano, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Estatus)
SELECT Cliente,  Nombre,      Direccion, EntreCalles, Plano, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, 'ALTA' FROM Inserted
END
IF @EsCentroTrabajo = 1
BEGIN
UPDATE Centro
SET Descripcion = i.Nombre
FROM Centro c, Inserted i
WHERE c.Centro = @ClaveN
IF @@ROWCOUNT = 0
INSERT Centro (Centro,  Descripcion, Estatus, CostoMoneda)
SELECT Cliente, Nombre,      'ALTA',  DefMoneda  FROM Inserted
END
IF @EsEstacionTrabajo = 1
BEGIN
UPDATE EstacionT
SET Descripcion = i.Nombre
FROM EstacionT e, Inserted i
WHERE e.Estacion = @ClaveN
IF @@ROWCOUNT = 0
INSERT EstacionT (Estacion, Descripcion, Estatus)
SELECT Cliente,  Nombre,      'ALTA'  FROM Inserted
END
END
END
END

