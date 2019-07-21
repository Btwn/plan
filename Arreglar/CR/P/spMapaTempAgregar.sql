SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMapaTempAgregar
@Estacion	int,
@Referencia	varchar(50),
@Clave		varchar(20)

AS BEGIN
DECLARE
@p		int,
@Clave1	varchar(20),
@Clave2	varchar(20)
IF CHARINDEX('|', @Referencia) > 0
BEGIN
SELECT @p = CHARINDEX ('|', @Clave)
IF @p > 0
SELECT @Clave1 = SUBSTRING(@Clave, 1, @p-1),
@Clave2 = SUBSTRING(@Clave, @p+1, LEN(@Clave))
END
IF @Referencia = 'Cliente'
INSERT MapaTemp (
Estacion,  Clave,   Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion,   SituacionColorNumero, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Cliente, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, s.Situacion, c.Numero,             MapaLatitud, MapaLongitud, MapaPrecision
FROM Cte
LEFT OUTER JOIN CtaSituacion s ON s.Rama = 'CXC' AND s.Situacion = Cte.Situacion
LEFT OUTER JOIN Color c ON s.Color = c.Color
WHERE Cte.Cliente = @Clave
IF @Referencia = 'Cliente|EnviarA'
INSERT MapaTemp (
Estacion,  Clave,  Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, @Clave, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision
FROM CteEnviarA
WHERE Cliente = @Clave1 AND ID = CONVERT(int, @Clave2)
IF @Referencia = 'Proveedor'
INSERT MapaTemp (
Estacion,  Clave,     Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion,   SituacionColorNumero, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Proveedor, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, s.Situacion, c.Numero,             MapaLatitud, MapaLongitud, MapaPrecision
FROM Prov
LEFT OUTER JOIN CtaSituacion s ON s.Rama = 'CXP' AND s.Situacion = Prov.Situacion
LEFT OUTER JOIN Color c ON s.Color = c.Color
WHERE Prov.Proveedor = @Clave
IF @Referencia = 'Personal'
INSERT MapaTemp (
Estacion,  Clave,    Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion,   SituacionColorNumero, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Personal, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, s.Situacion, c.Numero,             MapaLatitud, MapaLongitud, MapaPrecision
FROM Personal
LEFT OUTER JOIN CtaSituacion s ON s.Rama = 'CXP' AND s.Situacion = Personal.Situacion
LEFT OUTER JOIN Color c ON s.Color = c.Color
WHERE Personal.Personal = @Clave
IF @Referencia = 'Agente'
INSERT MapaTemp (
Estacion,  Clave,  Nombre, Direccion, DireccionNumero, DireccionNumeroInt, /*EntreCalles, Observaciones, Delegacion, */Colonia, Poblacion, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Agente, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, /*EntreCalles, Observaciones, Delegacion, */Colonia, Poblacion, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision
FROM Agente
WHERE Agente.Agente = @Clave
IF @Referencia = 'Almacen'
INSERT MapaTemp (
Estacion,  Clave,   Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Almacen, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision
FROM Alm
WHERE Alm.Almacen = @Clave
IF @Referencia = 'Sucursal'
INSERT MapaTemp (
Estacion,  Clave,                          Nombre, Direccion, DireccionNumero, DireccionNumeroInt, /*EntreCalles, Observaciones, */Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, CONVERT(varchar(10), Sucursal), Nombre, Direccion, DireccionNumero, DireccionNumeroInt, /*EntreCalles, Observaciones, */Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision
FROM Sucursal
WHERE Sucursal.Sucursal = CONVERT(int, @Clave)
/*  IF @Referencia = 'Desarrollo'
INSERT MapaTemp (
Estacion,  Clave,   Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion,     MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Desarrollo, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Población, Estado, Pais, CodigoPostal, vic_Desarrollo.Situacion, MapaLatitud, MapaLongitud, MapaPrecision
FROM vic_Desarrollo
WHERE vic_Desarrollo.Desarrollo = @Clave
IF @Referencia = 'Inmueble'
INSERT MapaTemp (
Estacion,  Clave,   Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion,     MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Inmueble, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, vic_Inmueble.Situacion, MapaLatitud, MapaLongitud, MapaPrecision
FROM vic_Inmueble
WHERE vic_Inmueble.Inmueble = @Clave
IF @Referencia = 'Area'
INSERT MapaTemp (
Estacion,  Clave,   Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion,     MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Area, Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Población, Estado, Pais, CodigoPostal, vic_Area.Situacion, MapaLatitud, MapaLongitud, MapaPrecision
FROM vic_Area
WHERE vic_Area.Area = @Clave
IF @Referencia = 'Contrato'
INSERT MapaTemp (
Estacion,  Clave,   Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion,     MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Contrato.ID, Contrato.Mov+''+Contrato.MovID, vic_Contrato.Direccion, vic_Contrato.DireccionNumero, vic_Contrato.DireccionNumeroInt, vic_Contrato.EntreCalles, Contrato.Observaciones, vic_Contrato.Delegacion, vic_Contrato.Colonia, vic_Contrato.Población, vic_Contrato.Estado, vic_Contrato.Pais, vic_Contrato.CodigoPostal, Contrato.Situacion, vic_Contrato.MapaLatitud, vic_Contrato.MapaLongitud, vic_Contrato.MapaPrecision
FROM vic_Contrato
JOIN Contrato ON vic_Contrato.ID = Contrato.ID
WHERE vic_Contrato.ID = @Clave
IF @Referencia = 'Fiador'
INSERT MapaTemp (
Estacion,  Clave,   Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion,     MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, Contrato.ID, vic_Contrato.Fiador, vic_Contrato.DireccionFiador, vic_Contrato.DireccionNumeroFiador, vic_Contrato.DireccionNumeroIntFiador, vic_Contrato.EntreCallesFiador, Contrato.Observaciones, vic_Contrato.DelegacionFiador, vic_Contrato.ColoniaFiador, vic_Contrato.PoblaciónFiador, vic_Contrato.EstadoFiador, vic_Contrato.PaisFiador, vic_Contrato.CodigoPostalFiador, Contrato.Situacion, vic_Contrato.MapaLatitudFiador, vic_Contrato.MapaLongitudFiador, vic_Contrato.MapaPrecisionFiador
FROM vic_Contrato
JOIN Contrato ON vic_Contrato.ID = Contrato.ID
WHERE vic_Contrato.ID = @Clave*/
IF @Referencia = 'Proy'
INSERT MapaTemp (
Estacion,  Clave,   Nombre, Direccion, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion)
SELECT @Estacion, Proyecto, Descripcion, Direccion, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, Situacion
FROM Proy
WHERE Proyecto = @Clave
/*IF @Referencia = 'Notaria'
INSERT MapaTemp (
Estacion,  Clave,   Nombre, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision)
SELECT @Estacion, NumNotaria, NombreCorto, Direccion, DireccionNumero, DireccionNumeroInt, EntreCalles, Observaciones, Delegacion, Colonia, Población, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision
FROM vic_Notaria
WHERE Notaria  = @Clave*/
RETURN
END

