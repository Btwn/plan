SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.vwPNETAmenidades
AS
SELECT
A.ID as ID,
A.Espacio as Espacio,
A.DiaCompletoHora as DiaCompletoHora,
E.Nombre as Nombre,
CONVERT(VARCHAR(24),A.FechaDesde,121) as FechaDesde,
CONVERT(VARCHAR(24),A.FechaHasta,121) as FechaHasta,
A.NumPersonas as NumPersonas,
A.Vivienda as Vivienda,
A.Telefono as Telefono,
A.eMail as eMail,
A.Observaciones as Observaciones,
A.Cliente as Cliente,
C.Nombre as NombreCliente
from Amenidades as A
INNER JOIN Espacio as E ON A.Espacio = E.Espacio
INNER JOIN Cte as C ON C.Cliente = A.Cliente

