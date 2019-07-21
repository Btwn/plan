SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW AppEmbarqueUbicacion AS
SELECT e.ID,
e.Empresa,
e.Mov   as 'MovEmbarque',
e.MovID as 'MoIDEmbarque',
e.Moneda,
e.TipoCambio,
e.FechaEmision,
e.Proyecto,
e.UEN,
e.Usuario,
e.Estatus,
e.Vehiculo,
e.Agente,
e.Proveedor,
e.Importe,
e.Impuestos,
ed.EmbarqueMov,
ed.Orden,
ed.Paquetes,
ed.Estado,
ed.FechaHora,
ed.Persona,
ed.PersonaID,
ed.Forma,
ed.Referencia,
ed.Observaciones,
ed.Causa,
ed.MovPorcentaje,
em.Accion,
em.Zona,
em.Ruta,
em.ZonaTipo,
em.OrdenEmbarque,
em.Modulo,
em.ModuloID,
em.Mov,
em.MovID,
em.MovEstatus,
em.Almacen,
em.Cliente,
c.Nombre,
em.Delegacion,
em.Colonia,
em.Poblacion,
em.Estado as 'EstadoEmbarque',
em.Pais,
em.CodigoPostal,
em.MapaLatitud,
em.MapaLongitud,
em.Ubicacion
FROM Embarque e
JOIN EmbarqueD ed ON ed.ID = e.ID
JOIN EmbarqueMov em ON em.ID = ed.EmbarqueMov
JOIN Cte c ON c.Cliente = em.Cliente
WHERE e.Estatus = 'PENDIENTE'

