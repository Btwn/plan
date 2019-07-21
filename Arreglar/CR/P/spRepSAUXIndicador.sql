SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepSAUXIndicador
@Estaciontrabajo			int

AS BEGIN
DECLARE
@FechaD			datetime,
@FechaA			datetime,
@FechaReqD		datetime,
@FechaReqA		datetime,
@Estatus		varchar(15),
@Empresa		char(5),
@Servicio		varchar(50)
SELECT
@FechaD      =  InfoFechaD,
@FechaA      =  InfoFechaA,
@FechaReqD   = InfoFechaRequeridaD,
@FechaReqA   = InfoFechaRequeridaA,
@Estatus     = NULLIF(NULLIF(InfoEstatusEspecifico,'(Todos)'),''),
@Empresa     = InfoEmpresa,
@Servicio    = NULLIF(NULLIF(InfoServicio,'(Todos)'),'')
FROM RepParam
WHERE Estacion = @Estaciontrabajo
SELECT
s.ID,
s.Mov + ' ' + s.MovID Mov,
s.Estatus,
s.FechaEmision,
s.TipoContacto,
s.Contacto + ' ' + CASE s.TipoContacto
WHEN 'Cliente' THEN (SELECT Nombre FROM Cte WHERE Cliente = s.Contacto)
WHEN 'Proveedor' THEN (SELECT Nombre FROM Prov WHERE Proveedor = s.Contacto)
END Contacto,
s.Observaciones,
d.Producto + ' ' + a.Descripcion1 Producto,
d.Servicio + ' ' + ss.Descripcion Servicio,
d.FechaRequerida,
sdi.Indicador,
si.Descripcion,
sdi.Valor,
si.ParametroValido
FROM SAUX s
JOIN MovTipo mt ON s.Mov = mt.Mov AND mt.Modulo = 'SAUX'
JOIN SAUXD d ON s.ID = d.ID
JOIN Art a ON d.Producto = a.Articulo
JOIN SAUXServicio ss ON d.Servicio = ss.Servicio
JOIN SAUXDIndicador sdi ON d.ID = sdi.ID AND d.Renglon = sdi.Renglon AND d.Producto = sdi.Producto AND d.Servicio = sdi.Servicio
JOIN SAUXIndicador si ON sdi.Indicador = si.Indicador
WHERE mt.Clave IN('SAUX.S')
AND s.Estatus in('CONCLUIDO', 'CANCELADO')
AND s.FechaEmision BETWEEN @FechaD AND @FechaA
AND d.FechaRequerida BETWEEN @FechaReqD AND @FechaReqA
AND s.Estatus = ISNULL(@Estatus, s.Estatus)
AND s.Empresa = @Empresa
AND d.Servicio = ISNULL(@Servicio, d.Servicio)
RETURN
END

