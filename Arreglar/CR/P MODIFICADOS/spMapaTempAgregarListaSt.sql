SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMapaTempAgregarListaSt
@Estacion	int,
@Referencia	varchar(50)

AS BEGIN
DELETE MapaTemp WHERE Estacion = @Estacion
IF @Referencia = 'Cliente'
INSERT MapaTemp (
Estacion,  Clave,   Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion,     SituacionColorNumero, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Cliente, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Cte.Situacion, Color.Numero,         MapaLatitud, MapaLongitud, MapaPrecision
FROM Cte WITH (NOLOCK)  
JOIN ListaSt l  WITH (NOLOCK)  ON l.Estacion = @Estacion AND l.Clave = Cte.Cliente
LEFT OUTER JOIN   CtaSituacion WITH (NOLOCK) ON CtaSituacion.Rama = 'CXC' AND CtaSituacion.Situacion = Cte.Situacion
LEFT OUTER JOIN    Color WITH (NOLOCK) ON Color.Color = CtaSituacion.Color
IF @Referencia = 'Proveedor'
INSERT MapaTemp (
Estacion,  Clave,     Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion,      SituacionColorNumero, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Proveedor, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Prov.Situacion, Color.Numero,         MapaLatitud, MapaLongitud, MapaPrecision
FROM Prov WITH (NOLOCK)  
JOIN ListaSt l  WITH (NOLOCK)  ON l.Estacion = @Estacion AND l.Clave = Prov.Proveedor
LEFT OUTER JOIN   CtaSituacion  WITH (NOLOCK) ON CtaSituacion.Rama = 'CXP' AND CtaSituacion.Situacion = Prov.Situacion
LEFT OUTER JOIN  Color WITH (NOLOCK)  ON Color.Color = CtaSituacion.Color
IF @Referencia = 'Personal'
INSERT MapaTemp (
Estacion,  Clave,    Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion,          SituacionColorNumero, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Personal, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Personal.Situacion, Color.Numero,         MapaLatitud, MapaLongitud, MapaPrecision
FROM Personal WITH (NOLOCK)  
JOIN ListaSt l WITH (NOLOCK)   ON l.Estacion = @Estacion AND l.Clave = Personal.Personal
LEFT OUTER JOIN CtaSituacion   WITH (NOLOCK)  ON CtaSituacion.Rama = 'RH' AND CtaSituacion.Situacion = Personal.Situacion
LEFT OUTER JOIN   Color  WITH (NOLOCK) ON Color.Color = CtaSituacion.Color
IF @Referencia = 'Agente'
INSERT MapaTemp (
Estacion,  Clave,  Nombre, Direccion, DireccionNumero, DireccionNumeroInt, /*EntreCalles, Observaciones, Delegacion, */Colonia, Poblacion, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Agente, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, /*EntreCalles, Observaciones, Delegacion, */Colonia, Poblacion, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision
FROM Agente WITH (NOLOCK)  
JOIN ListaSt l  WITH (NOLOCK)  ON l.Estacion = @Estacion AND l.Clave = Agente.Agente
IF @Referencia = 'Almacen'
INSERT MapaTemp (
Estacion,  Clave,   Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Almacen, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision
FROM Alm WITH (NOLOCK)  
JOIN ListaSt l  WITH (NOLOCK)  ON l.Estacion = @Estacion AND l.Clave = Alm.Almacen
IF @Referencia = 'Sucursal'
INSERT MapaTemp (
Estacion,  Clave,                          Nombre, Direccion, DireccionNumero, DireccionNumeroInt, /*EntreCalles, Observaciones, */Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, CONVERT(varchar(10), Sucursal), Nombre, Direccion, DireccionNumero, DireccionNumeroInt, /*EntreCalles, Observaciones, */Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision
FROM Sucursal WITH (NOLOCK)  
JOIN ListaSt l  WITH (NOLOCK)  ON l.Estacion = @Estacion AND l.Clave = CONVERT(varchar(10), Sucursal)
/*IF @Referencia = 'Desarrollo'
INSERT MapaTemp (
Estacion,  Clave,   Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion,     SituacionColorNumero, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Desarrollo, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Población, Estado, Pais, CodigoPostal, vic_Desarrollo.Situacion, Color.Numero, MapaLatitud, MapaLongitud, MapaPrecision
FROM vic_Desarrollo
JOIN ListaSt l ON l.Estacion = @Estacion AND l.Clave = vic_Desarrollo.Desarrollo
LEFT OUTER JOIN CtaSituacion ON CtaSituacion.Rama = 'CXC' AND CtaSituacion.Situacion = vic_Desarrollo.Situacion
LEFT OUTER JOIN Color ON Color.Color = CtaSituacion.Color
IF @Referencia = 'Area'
INSERT MapaTemp (
Estacion,  Clave,   Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion,     SituacionColorNumero, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Area, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Población, Estado, Pais, CodigoPostal, vic_Area.Situacion, Color.Numero, MapaLatitud, MapaLongitud, MapaPrecision
FROM vic_Area
JOIN ListaSt l ON l.Estacion = @Estacion AND l.Clave = vic_Area.Area
LEFT OUTER JOIN CtaSituacion ON CtaSituacion.Rama = 'CXC' AND CtaSituacion.Situacion = vic_Area.Situacion
LEFT OUTER JOIN Color ON Color.Color = CtaSituacion.Color
IF @Referencia = 'Contrato'
INSERT MapaTemp (
Estacion,  Clave,   Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion,     SituacionColorNumero, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Contrato, Mov+' '+MovID, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, vic_Contrato.Observaciones, Delegacion, Colonia, Población, Estado, Pais, CodigoPostal, Contrato.Situacion, Color.Numero, MapaLatitud, MapaLongitud, MapaPrecision
FROM vic_Contrato
JOIN ListaSt l ON l.Estacion = @Estacion AND l.Clave = vic_Contrato.ID
JOIN Contrato ON vic_Contrato.ID = Contrato.ID
LEFT OUTER JOIN CtaSituacion ON CtaSituacion.Rama = 'CXC' AND CtaSituacion.Situacion = Contrato.Situacion
LEFT OUTER JOIN Color ON Color.Color = CtaSituacion.Color
IF @Referencia = 'Inmueble'
INSERT MapaTemp (
Estacion,  Clave,   Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion,     SituacionColorNumero, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Inmueble, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, vic_Inmueble.Situacion, Color.Numero, MapaLatitud, MapaLongitud, MapaPrecision
FROM vic_Inmueble
JOIN ListaSt l ON l.Estacion = @Estacion AND l.Clave = vic_Inmueble.Inmueble
LEFT OUTER JOIN CtaSituacion ON CtaSituacion.Rama = 'CXC' AND CtaSituacion.Situacion = vic_Inmueble.Situacion
LEFT OUTER JOIN Color ON Color.Color = CtaSituacion.Color
IF @Referencia = 'Fiador'
INSERT MapaTemp (
Estacion,  Clave,   Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion,     SituacionColorNumero, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Contrato, Mov, DireccionFiador, DireccionNumeroFiador, DireccionNumeroIntFiador, EntreCallesFiador, vic_Contrato.ObservacionesFiador, DelegacionFiador, ColoniaFiador, PoblaciónFiador, EstadoFiador, PaisFiador, CodigoPostalFiador, Contrato.Situacion, Color.Numero, MapaLatitudFiador, MapaLongitudFiador, MapaPrecisionFiador
FROM vic_Contrato
JOIN ListaSt l ON l.Estacion = @Estacion AND l.Clave = vic_Contrato.ID
JOIN Contrato ON vic_Contrato.ID = Contrato.ID
LEFT OUTER JOIN CtaSituacion ON CtaSituacion.Rama = 'CXC' AND CtaSituacion.Situacion = Contrato.Situacion
LEFT OUTER JOIN Color ON Color.Color = CtaSituacion.Color*/
IF @Referencia = 'Proy'
INSERT MapaTemp (
Estacion,  Clave,   Nombre, Direccion, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion,  SituacionColorNumero)
SELECT @Estacion, Proyecto, Descripcion, Direccion, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Proy.Situacion, Color.Numero
FROM Proy WITH (NOLOCK)  
JOIN ListaSt l  WITH (NOLOCK)  ON l.Estacion = @Estacion AND l.Clave = Proy.Proyecto
LEFT OUTER JOIN   CtaSituacion WITH (NOLOCK)  ON CtaSituacion.Rama = 'CXC' AND CtaSituacion.Situacion = Proy.Situacion
LEFT OUTER JOIN   Color  WITH (NOLOCK) ON  Color.Color = CtaSituacion.Color
/*IF @Referencia = 'Notaria'
INSERT MapaTemp (
Estacion,  Clave,   Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion,     SituacionColorNumero, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, NumNotaria, NombreCorto, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Población, Estado, Pais, CodigoPostal, '', Color.Numero, MapaLatitud, MapaLongitud, MapaPrecision
FROM vic_Notaria
JOIN ListaSt l ON l.Estacion = @Estacion AND l.Clave = vic_Notaria.Notaria
LEFT OUTER JOIN CtaSituacion ON CtaSituacion.Rama = 'CXC'
LEFT OUTER JOIN Color ON Color.Color = CtaSituacion.Color*/
RETURN
END

