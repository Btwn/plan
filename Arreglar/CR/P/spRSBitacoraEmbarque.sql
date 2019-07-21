SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRSBitacoraEmbarque
@Empresa		varchar(10),
@Sucursal	    int,
@ClienteD   	varchar(10),
@Vehiculo		varchar(10),
@FechaD        datetime,
@FechaA        datetime

AS BEGIN
DECLARE
@EstacionTrabajo		    int
SELECT  @Empresa     = CASE WHEN @Empresa IN( '(Todas)', '') THEN NULL ELSE @Empresa END ,
@ClienteD    = CASE WHEN @ClienteD IN( '(Todos)', '') THEN NULL ELSE @ClienteD END,
@Vehiculo    = CASE WHEN @Vehiculo IN( '(Todos)', '') THEN NULL ELSE @Vehiculo END
SELECT @EstacionTrabajo=@@SPID
SELECT
e.Agente,
e.MovId as eMovID,
RTRIM(ISNULL(e.Mov,''))+' '+ISNULL(e.MovId,'') as eMovMovID,
e.Referencia,
e.Observaciones,
em.MovObservaciones,
e.Vehiculo,
ISNULL(Vehiculo.Descripcion,'')+'. Placas:'+ISNULL(Vehiculo.Placas,'')+'. Cap.Peso (Kgs):'+CONVERT(VARCHAR, ISNULL(Vehiculo.Peso,0)) as InfoVehiculo,
em.MovEstatus,
em.Ruta,
ed.Estado,
ed.FechaHora,
em.Cliente,
c.Nombre,
em.Telefonos,
em.Paquetes,
em.Importe,
em.FechaEmision,
CASE WHEN em.Modulo='VTAS' THEN RTRIM(ISNULL(em.Mov,''))+' '+ISNULL(em.MovID,'') ELSE '' END as emMovMovID,
ed.Forma FormaPagoTipo 
FROM Embarque e
JOIN EmbarqueD ed ON e.ID=ed.ID
JOIN EmbarqueMov em ON ed.EmbarqueMov=em.ID
JOIN Cte c ON em.Cliente=c.Cliente
LEFT OUTER JOIN Venta v ON em.ModuloID=v.ID
LEFT OUTER JOIN Vehiculo ON e.Vehiculo=Vehiculo.Vehiculo
WHERE e.Empresa = ISNULL(@Empresa,e.Empresa) AND e.Sucursal=ISNULL(@Sucursal,e.Sucursal)
AND e.Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
AND e.FechaEmision BETWEEN @FechaD AND @FechaA
AND em.Cliente = ISNULL(@ClienteD,em.Cliente)
AND e.Vehiculo =  ISNULL(@Vehiculo,e.Vehiculo)
ORDER BY e.FechaEmision, e.Agente
END

