SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMapaAceptar
@Estacion	int,
@Referencia	varchar(50),
@Accion		varchar(50),	
@ID		int

AS BEGIN
DECLARE
@Clave	varchar(20),
@MapaOrden	int
SELECT @Accion = UPPER(@Accion)
IF @Accion NOT IN ('POSICIONAR', 'ENRUTAR') RETURN
IF @Referencia = 'Cliente'
UPDATE Cte WITH (ROWLOCK) 
SET MapaLatitud = m.MapaLatitud,
MapaLongitud = m.MapaLongitud,
MapaPrecision = m.MapaPrecision
FROM Cte c  
JOIN MapaTemp m  WITH (NOLOCK) 
 ON m.Estacion = @Estacion AND m.Clave = c.Cliente
IF @Referencia = 'Cliente|EnviarA'
UPDATE CteEnviarA WITH (ROWLOCK) 
SET MapaLatitud = m.MapaLatitud,
MapaLongitud = m.MapaLongitud,
MapaPrecision = m.MapaPrecision
FROM CteEnviarA cea  
JOIN MapaTemp m  WITH (NOLOCK) 
 ON m.Estacion = @Estacion AND m.Clave = cea.Cliente+'|'+CONVERT(varchar(10), cea.ID)
IF @Referencia = 'Proveedor'
UPDATE Prov WITH (ROWLOCK) 
SET MapaLatitud = m.MapaLatitud,
MapaLongitud = m.MapaLongitud,
MapaPrecision = m.MapaPrecision
FROM Prov p  
JOIN MapaTemp m  WITH (NOLOCK) 
 ON m.Estacion = @Estacion AND m.Clave = p.Proveedor
IF @Referencia = 'Personal'
UPDATE Personal WITH (ROWLOCK) 
SET MapaLatitud = m.MapaLatitud,
MapaLongitud = m.MapaLongitud,
MapaPrecision = m.MapaPrecision
FROM Personal p  
JOIN MapaTemp m WITH (NOLOCK) 
  ON m.Estacion = @Estacion AND m.Clave = p.Personal
IF @Referencia = 'Agente'
UPDATE Agente WITH (ROWLOCK) 
SET MapaLatitud = m.MapaLatitud,
MapaLongitud = m.MapaLongitud,
MapaPrecision = m.MapaPrecision
FROM Agente a  
JOIN MapaTemp m  WITH (NOLOCK) 
 ON m.Estacion = @Estacion AND m.Clave = a.Agente
IF @Referencia = 'Almacen'
UPDATE Alm WITH (ROWLOCK) 
SET MapaLatitud = m.MapaLatitud,
MapaLongitud = m.MapaLongitud,
MapaPrecision = m.MapaPrecision
FROM Alm a  
JOIN MapaTemp m  WITH (NOLOCK) 
 ON m.Estacion = @Estacion AND m.Clave = a.Almacen
IF @Referencia = 'Sucursal'
UPDATE Sucursal WITH (ROWLOCK) 
SET MapaLatitud = m.MapaLatitud,
MapaLongitud = m.MapaLongitud,
MapaPrecision = m.MapaPrecision
FROM Sucursal s  
JOIN MapaTemp m  WITH (NOLOCK) 
 ON m.Estacion = @Estacion AND m.Clave = CONVERT(varchar(10), s.Sucursal)
IF @Referencia = 'Embarque'
BEGIN
IF @ID IS NOT NULL
BEGIN
DELETE EmbarqueD WHERE ID = @ID
INSERT EmbarqueD (ID, Orden, EmbarqueMov)
SELECT @ID, m.MapaOrden, m.EmbarqueMov
FROM MapaTemp m WITH (NOLOCK) 
WHERE m.Estacion = @Estacion AND m.MapaRuta NOT IN ('INICIO', 'FINAL')
END
END
/*IF @Referencia = 'Desarrollo'
UPDATE vic_Desarrollo
SET MapaLatitud = m.MapaLatitud,
MapaLongitud = m.MapaLongitud,
MapaPrecision = m.MapaPrecision
FROM vic_Desarrollo vd
JOIN MapaTemp m ON m.Estacion = @Estacion AND m.Clave = vd.Desarrollo
IF @Referencia = 'Area'
UPDATE vic_Area
SET MapaLatitud = m.MapaLatitud,
MapaLongitud = m.MapaLongitud,
MapaPrecision = m.MapaPrecision
FROM vic_Area va
JOIN MapaTemp m ON m.Estacion = @Estacion AND m.Clave = va.Area
IF @Referencia = 'Contrato'
UPDATE vic_Contrato
SET MapaLatitud = m.MapaLatitud,
MapaLongitud = m.MapaLongitud,
MapaPrecision = m.MapaPrecision
FROM vic_Contrato vc
JOIN MapaTemp m ON m.Estacion = @Estacion AND m.Clave = vc.ID
IF @Referencia = 'Inmueble'
UPDATE vic_Inmueble
SET MapaLatitud = m.MapaLatitud,
MapaLongitud = m.MapaLongitud,
MapaPrecision = m.MapaPrecision
FROM vic_Inmueble vi
JOIN MapaTemp m ON m.Estacion = @Estacion AND m.Clave = vi.Inmueble
IF @Referencia = 'Fiador'
UPDATE vic_Contrato
SET MapaLatitudFiador = m.MapaLatitud,
MapaLongitudFiador = m.MapaLongitud,
MapaPrecisionFiador = m.MapaPrecision
FROM vic_Contrato vc
JOIN MapaTemp m ON m.Estacion = @Estacion AND m.Clave = vc.ID
IF @Referencia = 'Notaria'
UPDATE vic_Notaria
SET MapaLatitud = m.MapaLatitud,
MapaLongitud = m.MapaLongitud,
MapaPrecision = m.MapaPrecision
FROM vic_Notaria op
JOIN MapaTemp m ON m.Estacion = @Estacion AND m.Clave = op.Notaria*/
RETURN
END

