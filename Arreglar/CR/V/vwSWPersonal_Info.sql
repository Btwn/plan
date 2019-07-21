SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW vwSWPersonal_Info
AS
SELECT
RTrim(a.Personal) Personal,
Nombre = (RTrim(a.Nombre) + ' ' + RTrim(a.ApellidoPaterno) + ' ' + RTrim(a.ApellidoMaterno)),
CURP = RTrim(a.Registro),
RFC = RTrim(a.Registro2),
Direccion = RTrim(a.Direccion),
Delegacion = RTrim(a.Delegacion),
Colonia = RTrim(a.Colonia),
CodigoPostal = RTrim(a.CodigoPostal),
Poblacion = RTrim(a.Poblacion),
Estado = RTrim(a.Estado),
Pais = RTrim(a.Pais),
Telefono = RTrim(a.Telefono),
Puesto = RTrim(a.Puesto),
Departamento = RTrim(a.Departamento),
TipoContrato = RTrim(a.TipoContrato),
VencimientoContrato = RTrim(a.VencimientoContrato),
PersonalCuenta = RTrim(a.PersonalCuenta),
PersonalSucursal = RTrim(a.PersonalSucursal),
RegImss = RTrim(a.Registro3),
a.SueldoDiario,
a.SDI,
a.CentroCostos,
a.Categoria,
a.Empresa,
Rol = ISNULL(b.Rol, '') ,
b.Usuario
FROM Personal a
LEFT JOIN Recurso b ON b.Personal = a.Personal

