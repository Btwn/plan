SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRSReporteTrasladoEmbarque
@Empresa		varchar(10),
@Sucursal	    int,
@ID            int

AS BEGIN
DECLARE
@EstacionTrabajo		    int
SELECT  @Empresa     = CASE WHEN @Empresa IN( '(Todas)', '') THEN NULL ELSE @Empresa END
SELECT @EstacionTrabajo=@@SPID
SELECT
'VTAS' as Modulo,
e.ID,
e.Agente,
e.MovId as eMovID,
RTRIM(e.Mov)+' '+e.MovId as eMovMovID,
e.OrigenTipo,
RTRIM(e.Origen)+' '+e.OrigenId as eOrigenMovMovID,
e.FechaSalida,
e.Referencia,
e.Observaciones,
e.Peso,
em.MovObservaciones,
ISNULL(e.Vehiculo, '')+' - '+ISNULL(Vehiculo.Descripcion,'')+'. Placas:'+ISNULL(Vehiculo.Placas,'')+'. Cap.Peso (Kgs):'+CONVERT(VARCHAR, ISNULL(Vehiculo.Peso,0)) as InfoVehiculo, 
e.Volumen as DispVolumen,
em.MovEstatus,
em.Ruta,
em.NombreEnvio,
ed.Persona,
ed.Estado,
ed.FechaHora,
em.Cliente,
c.Nombre,
em.Telefonos,
vd.Articulo+' - '+Art.Descripcion1 as Articulo,
vd.Unidad,
vd.Cantidad,
em.Paquetes,
em.Importe,
e.ImporteEmbarque,
em.FechaEmision,
RTRIM(em.Mov)+' '+em.MovID as emMovMovID,
ed.MovPorcentaje
FROM Embarque e
JOIN EmbarqueD ed ON e.ID=ed.ID
JOIN EmbarqueMov em ON ed.EmbarqueMov=em.ID
JOIN Venta v ON em.ModuloID=v.ID
JOIN Ventad vD ON vd.ID=v.ID
LEFT OUTER JOIN Cte c ON em.Cliente=c.Cliente
LEFT OUTER JOIN Vehiculo ON e.Vehiculo=Vehiculo.Vehiculo
LEFT OUTER JOIN Art ON Art.Articulo=vd.Articulo
WHERE e.Empresa = ISNULL(@Empresa,e.Empresa) AND e.Sucursal=ISNULL(@Sucursal,e.Sucursal)
AND e.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND e.ID=@ID
AND em.Modulo='VTAS'
UNION
SELECT
'INV' as Modulo,
e.ID,
e.Agente,
e.MovId as eMovID,
RTRIM(e.Mov)+' '+e.MovId as eMovMovID,
e.OrigenTipo,
RTRIM(e.Origen)+' '+e.OrigenId as eOrigenMovMovID,
e.FechaSalida,
e.Referencia,
e.Observaciones,
e.Peso,
em.MovObservaciones,
e.Vehiculo+' - '+Vehiculo.Descripcion+'. Placas:'+Vehiculo.Placas+'. Cap.Peso (Kgs):'+CONVERT(VARCHAR, Vehiculo.Peso) as InfoVehiculo,
e.Volumen as DispVolumen,
em.MovEstatus,
em.Ruta,
em.NombreEnvio,
ed.Persona,
ed.Estado,
ed.FechaHora,
em.Cliente,
c.Nombre,
em.Telefonos,
id.Articulo+' - '+Art.Descripcion1 as Articulo,
id.Unidad,
id.Cantidad,
em.Paquetes,
em.Importe,
e.ImporteEmbarque,
em.FechaEmision,
RTRIM(em.Mov)+' '+em.MovID as emMovMovID,
ed.MovPorcentaje
FROM Embarque e
JOIN EmbarqueD ed ON e.ID=ed.ID
JOIN EmbarqueMov em ON ed.EmbarqueMov=em.ID
JOIN Inv i ON em.ModuloID=i.ID
JOIN InvD id ON id.ID=i.ID
LEFT OUTER JOIN Cte c ON em.Cliente=c.Cliente
LEFT OUTER JOIN Vehiculo ON e.Vehiculo=Vehiculo.Vehiculo
LEFT OUTER JOIN Art ON Art.Articulo=id.Articulo
WHERE e.Empresa = ISNULL(@Empresa,e.Empresa) AND e.Sucursal=ISNULL(@Sucursal,e.Sucursal)
AND e.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND e.ID=@ID
AND em.Modulo='INV'
ORDER BY 1,e.FechaSalida, e.Agente
END

