SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepSAUXDescargaInv
@Estaciontrabajo			int

AS BEGIN
DECLARE
@FechaD			datetime,
@FechaA			datetime,
@Estatus		varchar(15),
@Empresa		char(5),
@Servicio		varchar(50)
SELECT
@FechaD   = InfoFechaD,
@FechaA   = InfoFechaA,
@Estatus  = NULLIF(NULLIF(InfoEstatusEspecifico,'(Todos)'),''),
@Empresa  = InfoEmpresa,
@Servicio = NULLIF(NULLIF(InfoServicio,'(Todos)'),'')
FROM RepParam
WHERE Estacion = @Estaciontrabajo
SELECT
s.ID,
s.Mov + ' ' + s.MovID MovOrigen,
s.Estatus EstatusOrigen,
s.FechaEmision FechaEmisionOrigen,
i.Mov + ' ' + i.MovID Mov,
i.FechaEmision,
d.Servicio,
d.Producto + ' ' + ISNULL(Art.Descripcion1,'') Producto,
di.Articulo,
m.Descripcion1,
di.Cantidad,
i.Estatus
FROM SAUX s
JOIN MovTipo mt ON s.Mov = mt.Mov AND mt.Modulo = 'SAUX'
JOIN Inv i ON s.Mov = i.Origen AND s.MovID = i.OrigenID AND i.OrigenTipo = 'SAUX'
JOIN MovTipo mti ON i.Mov = mti.Mov AND mti.Modulo = 'INV'
JOIN InvD di ON i.ID = di.ID
JOIN SAUXD d ON s.ID = d.ID
JOIN SAUXServicio ss ON d.Servicio = ss.Servicio
JOIN Art ON d.Producto = Art.Articulo
JOIN Art m ON di.Articulo = m.Articulo
WHERE mt.Clave IN('SAUX.SS', 'SAUX.S')
AND s.Estatus in('PENDIENTE', 'CONCLUIDO')
AND mti.Clave in('INV.SM', 'INV.CM')
AND i.Estatus in('PENDIENTE', 'CONCLUIDO')
AND s.FechaEmision BETWEEN @FechaD AND @FechaA
AND s.Estatus = ISNULL(@Estatus, s.Estatus)
AND s.Empresa = @Empresa
AND d.Servicio = ISNULL(@Servicio, d.Servicio)
RETURN
END

