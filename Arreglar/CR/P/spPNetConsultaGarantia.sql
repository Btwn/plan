SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC dbo.spPNetConsultaGarantia
@Usuario   varchar(10)
AS BEGIN
DECLARE
@DefAgente varchar(10)
SELECT @DefAgente = DefAgente FROM Usuario WHERE Usuario = @Usuario
SELECT v.ID, c.Nombre, LTRIM(RTRIM(ISNULL(v.Mov,'')))+ ' '+LTRIM(RTRIM(ISNULL(v.MovID,''))) as 'Movimiento',
CONVERT(VARCHAR(10),v.FechaEmision,110) as 'FechaEmision', a.Descripcion1 Articulo, v.ServicioSerie, v.ServicioTipo,
CONVERT(VARCHAR(10),v.VigenciaDesde,110) as 'VigenciaDesde', CONVERT(VARCHAR(10),v.VigenciaHasta,110) as 'VigenciaHasta', v.Situacion, v.SituacionNota, CONVERT(VARCHAR(10),v.ServicioFecha,110) as 'ServicioFecha'
FROM Venta v JOIN Cte c ON v.Cliente = c.Cliente
JOIN MovTipo mt ON 'VTAS' = mt.Modulo AND v.Mov = mt.Mov
JOIN Art a ON a.Articulo = v.ServicioArticulo
WHERE v.Estatus <> 'CANCELADO'
AND mt.Clave = 'VTAS.S' AND v.Agente = @DefAgente
RETURN
END

