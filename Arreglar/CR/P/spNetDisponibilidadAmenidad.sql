SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNetDisponibilidadAmenidad
@Cliente			VARCHAR(20),
@DiaCompletoHora	VARCHAR(20),
@Espacio			VARCHAR(20),
@FechaDesde			VARCHAR(20),
@FechaHasta			VARCHAR(20),
@HorasEvento		VARCHAR(MAX),
@IDSol				INT,
@Ok					INT OUTPUT,
@OkRef				VARCHAR(255) OUTPUT
AS BEGIN
DECLARE @Disponibilidad TABLE
(
Espacio		VARCHAR(255),
Total			INT
)
IF @IDSol IS NULL
BEGIN
INSERT INTO @Disponibilidad
SELECT DISTINCT E.Espacio as Espacio,  COUNT(*) as Total 
FROM Art A
JOIN ArtEspacio AE ON A.Articulo = AE.Articulo AND A.Estatus = 'Alta'
JOIN Espacio E ON AE.Espacio = E.Espacio AND E.Estatus = 'Alta'
JOIN VentaD VD ON VD.Articulo = A.Articulo AND VD.Espacio = E.Espacio
JOIN Venta V ON V.ID = VD.ID
WHERE
E.Espacio = @Espacio AND
CONVERT(DATE,VD.FechaRequerida)  BETWEEN CONVERT(DATE,@FechaDesde) AND CONVERT(DATE,@FechaHasta)
AND CONVERT(TIME,VD.FechaRequerida) IN (SELECT * FROM dbo.splitstring(@HorasEvento))
AND  V.Estatus IN ('CONCLUIDO')
GROUP BY E.Espacio
END
ELSE
BEGIN
INSERT INTO @Disponibilidad
SELECT DISTINCT E.Espacio as Espacio,  COUNT(*) as Total
FROM Art A
JOIN ArtEspacio AE ON A.Articulo = AE.Articulo AND A.Estatus = 'Alta'
JOIN Espacio E ON AE.Espacio = E.Espacio AND E.Estatus = 'Alta'
JOIN VentaD VD ON VD.Articulo = A.Articulo AND VD.Espacio = E.Espacio
JOIN Venta V ON V.ID = VD.ID
WHERE
E.Espacio = @Espacio AND
CONVERT(DATE,VD.FechaRequerida)  BETWEEN CONVERT(DATE,@FechaDesde) AND CONVERT(DATE,@FechaHasta)
AND CONVERT(TIME,VD.FechaRequerida) IN (SELECT * FROM dbo.splitstring(@HorasEvento))
AND  V.Estatus IN ('CONCLUIDO')
GROUP BY E.Espacio
UNION
SELECT DISTINCT E.Espacio as Espacio,  COUNT(*) as Total
FROM Art A
JOIN ArtEspacio AE ON A.Articulo = AE.Articulo AND A.Estatus = 'Alta'
JOIN Espacio E ON AE.Espacio = E.Espacio AND E.Estatus = 'Alta'
JOIN VentaD VD ON VD.Articulo = A.Articulo AND VD.Espacio = E.Espacio
JOIN Venta V ON V.ID = VD.ID
WHERE
E.Espacio = @Espacio AND
CONVERT(DATE,VD.FechaRequerida)  BETWEEN CONVERT(DATE,@FechaDesde) AND CONVERT(DATE,@FechaHasta)
AND CONVERT(TIME,VD.FechaRequerida) IN (SELECT * FROM dbo.splitstring(@HorasEvento))
AND V.ID = @IDSol
GROUP BY E.Espacio;
END
SELECT @Ok = Total, @OkRef = 'No se pudo registrar la Solicitud '+Espacio FROM @Disponibilidad
END

