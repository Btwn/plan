SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMapaEnrutarEmbarque
@Estacion	int,
@ID		int

AS BEGIN
DECLARE
@Ruta	varchar(50),
@SucursalD	int,
@SucursalA	int
SELECT @Ruta = Ruta FROM Embarque WITH (NOLOCK)  WHERE ID = @ID
SELECT @SucursalD = SucursalD,
@SucursalA = SucursalA
FROM Ruta WITH (NOLOCK) 
WHERE Ruta = @Ruta
DELETE MapaTemp WHERE Estacion = @Estacion
INSERT MapaTemp (
Estacion,  Clave,                          Nombre, Direccion, DireccionNumero, DireccionNumeroInt, /*EntreCalles, Observaciones, */Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision, MapaRuta)
SELECT @Estacion, CONVERT(varchar(10), Sucursal), Nombre, Direccion, DireccionNumero, DireccionNumeroInt, /*EntreCalles, Observaciones, */Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision, 'INICIO'
FROM Sucursal WITH (NOLOCK) 
WHERE Sucursal = @SucursalD
INSERT MapaTemp (
Estacion,  Clave,                          Nombre, Direccion, DireccionNumero, DireccionNumeroInt, /*EntreCalles, Observaciones, */Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision, MapaRuta)
SELECT @Estacion, CONVERT(varchar(10), Sucursal), Nombre, Direccion, DireccionNumero, DireccionNumeroInt, /*EntreCalles, Observaciones, */Delegacion, Colonia, Poblacion, Estado, Pais, CodigoPostal, MapaLatitud, MapaLongitud, MapaPrecision, 'FINAL'
FROM Sucursal WITH (NOLOCK) 
WHERE Sucursal = ISNULL(@SucursalA, @SucursalD)
INSERT MapaTemp (
Estacion,  Clave,                       Nombre,    Direccion,    DireccionNumero,    DireccionNumeroInt,    EntreCalles,    Observaciones,    Delegacion,    Colonia,    Poblacion,    Estado,    Pais,    CodigoPostal,    MapaOrden, MapaLatitud,    MapaLongitud,    MapaPrecision, EmbarqueMov)
SELECT @Estacion, CONVERT(varchar(10), ed.ID), em.Nombre, em.Direccion, em.DireccionNumero, em.DireccionNumeroInt, em.EntreCalles, em.Observaciones, em.Delegacion, em.Colonia, em.Poblacion, em.Estado, em.Pais, em.CodigoPostal, ed.Orden,  em.MapaLatitud, em.MapaLongitud, em.MapaPrecision, ed.EmbarqueMov
FROM EmbarqueD ed WITH (NOLOCK) 
JOIN EmbarqueMov em  WITH (NOLOCK) ON em.ID = ed.EmbarqueMov
WHERE ed.ID = @ID
RETURN
END

