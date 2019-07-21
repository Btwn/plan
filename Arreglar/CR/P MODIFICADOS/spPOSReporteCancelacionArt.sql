SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSReporteCancelacionArt
@Sucursal  int,
@Cajero    varchar(10),
@FechaD    datetime,
@FechaA    datetime

AS
BEGIN
SELECT @FechaD = dbo.fnFechaSinHora(@FechaD), @FechaA = dbo.fnFechaSinHora(@FechaA)
SELECT @Cajero = NULLIF(@Cajero,'NULL')
SELECT p.Cajero,g.Nombre, p.Articulo, a.Descripcion1, p.Sucursal Sucursal1, s.Nombre SucursalNombres, ABS(SUM(p.Cantidad))Cantidad, ISNULL(p.Precio,0.0)Precio
FROM POSCancelacionArticulos p WITH (NOLOCK) JOIN Art a WITH (NOLOCK) ON p.Articulo = a.Articulo
JOIN Agente g WITH (NOLOCK) ON p.Cajero = g.Agente
JOIN Sucursal s WITH (NOLOCK) ON p.Sucursal = s.Sucursal
WHERE p.Sucursal = ISNULL(@Sucursal,p.Sucursal) AND p.Cajero = ISNULL(@Cajero,p.Cajero)
AND dbo.fnFechaSinHora(Fecha) Between ISNULL(@FechaD,dbo.fnFechaSinHora(Fecha)) AND ISNULL(@FechaA,dbo.fnFechaSinHora(Fecha))
GROUP BY p.Cajero, p.Articulo, p.Sucursal, p.Precio,g.Nombre, a.Descripcion1,s.Nombre
ORDER By p.Sucursal,p.Cajero
END

