SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.vwPNETComunicados
AS
SELECT
c.IDComunicado AS ID,
c.Titulo AS Titulo,
c.DirigidoA AS Dirigido,
(CONVERT(VARCHAR(24),c.FechaPublicado,113)) AS Publicado,
(CONVERT(VARCHAR(24),c.FechaVigencia,113)) AS Vigencia,
c.FechaPublicado AS FechaPublicadoDate,
c.FechaVigencia AS FechaVigenciaDate,
c.Descripcion AS Descripcion,
c.Prioridad AS Prioridad,
a.Descripcion AS Tipo,
c.Estatus As Estatus
FROM pNetComunicado AS c
INNER JOIN pNetCatComunicado AS a ON c.Tipo = a.IDCatCom

