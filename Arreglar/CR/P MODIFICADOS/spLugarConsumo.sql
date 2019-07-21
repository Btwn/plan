SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLugarConsumo
@Articulo			varchar(20)

AS BEGIN
SELECT '(Sol. Pendiente)' AS Clave, 'Solicitud Pendiente' AS Descripcion
UNION ALL
SELECT '(Sol. Concluida)' AS Clave, 'Solicitud Concluida' AS Descripcion
UNION ALL
SELECT s.Servicio AS Clave, s.Descripcion AS Descripcion
FROM SAUXArtServicio a WITH (NOLOCK)
JOIN SAUXServicio s  WITH (NOLOCK) ON a.Servicio=s.Servicio
WHERE a.Articulo = @Articulo
RETURN
END

