SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNetAmenidadesFacCte
@Cliente		varchar(10)
AS BEGIN
DECLARE @TablaAmenidades TABLE (
ID				INT IDENTITY(1, 1) ,
IDMovDet		INT,
Mov				VARCHAR(20),
MovID			INT,
Espacio			VARCHAR(10),
DiaCompletoHora VARCHAR(20),
Cliente			VARCHAR(10),
NombreCliente	VARCHAR(100),
Nombre			VARCHAR(100),
FechaDesde		VARCHAR(24),
FechaHasta		VARCHAR(24),
NumPersonas		INT,
Vivienda		VARCHAR(20),
Telefono		VARCHAR(100),
eMail			VARCHAR(255),
Observaciones	VARCHAR(255),
Estatus			VARCHAR(15)
)
IF @Cliente = '' OR @Cliente IS NULL
BEGIN
INSERT INTO @TablaAmenidades
SELECT
V.ID as IDMovDet,
V.Mov AS Mov,
V.MovID AS MovID,
A.Espacio AS Espacio,
A.DiaCompletoHora,
V.Cliente,
C.Nombre as NombreCliente,
e.Nombre AS Nombre,
CONVERT(VARCHAR(24),A.FechaDesde,121) as FechaDesde,
CONVERT(VARCHAR(24),A.FechaHasta,121) as FechaHasta,
A.NumPersonas as NumPersonas,
A.Vivienda as Vivienda,
A.Telefono as Telefono,
A.eMail as eMail,
A.Observaciones as Observaciones,
CASE WHEN v.Estatus IS NULL OR v.Estatus = 'SINAFECTAR' THEN 'SOLICITUD' WHEN v.Estatus = 'CONCLUIDO' THEN v.Estatus END AS Estatus
FROM Amenidades A
JOIN Venta V ON A.IDMovDet = V.ID
JOIN Cte as C ON C.Cliente = A.Cliente
JOIN Espacio e ON A.Espacio = e.Espacio AND e.Tipo IN ('Amenidades')
WHERE
V.Estatus IN ('SINAFECTAR','CONCLUIDO')
END
ELSE
BEGIN
INSERT INTO @TablaAmenidades
SELECT
V.ID as IDMovDet,
V.Mov AS Mov,
V.MovID AS MovID,
A.Espacio AS Espacio,
A.DiaCompletoHora,
V.Cliente,
C.Nombre as NombreCliente,
e.Nombre AS Nombre,
CONVERT(VARCHAR(24),A.FechaDesde,121) as FechaDesde,
CONVERT(VARCHAR(24),A.FechaHasta,121) as FechaHasta,
A.NumPersonas as NumPersonas,
A.Vivienda as Vivienda,
A.Telefono as Telefono,
A.eMail as eMail,
A.Observaciones as Observaciones,
CASE WHEN v.Estatus IS NULL OR v.Estatus = 'SINAFECTAR' THEN 'SOLICITUD' WHEN v.Estatus = 'CONCLUIDO' THEN v.Estatus END AS Estatus
FROM Amenidades A
JOIN Venta V ON A.IDMovDet = V.ID
JOIN Cte as C ON C.Cliente = A.Cliente
JOIN Espacio e ON A.Espacio = e.Espacio AND e.Tipo IN ('Amenidades')
WHERE
V.Estatus IN ('SINAFECTAR','CONCLUIDO')
AND A.Cliente = @Cliente
END
SELECT * FROM @TablaAmenidades ORDER BY ID DESC
END

