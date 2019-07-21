SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.vwArtAgenteMovil
AS
SELECT	ISNULL(Ag.Agente,			' ')	Agente,
ISNULL(Ag.Nombre,			' ')	NombreAgt,
ISNULL(Ct.Cliente,			' ')	Cliente,
ISNULL(Ct.Rama,				' ')	Rama,
ISNULL(Ct.Nombre,			' ')	NombreCte,
ISNULL(Ct.ListaPrecios,		' ')	ListaPrecios,
ISNULL(Ct.ListaPreciosEsp,	' ')	ListaPreciosEsp,
ISNULL(Ct.MapaLatitud,		' ')	MapaLatitud,
ISNULL(Ct.MapaLongitud,		' ')	MapaLongitud,
ISNULL(Ct.MapaPrecision,	' ')	MapaPrecision,
ISNULL(Ct.AlmacenDef,		' ')	AlmacenDef,
ISNULL(LP.Lista,			' ')	Lista,
ISNULL(LP.Moneda,			' ')	Moneda,
ISNULL(LP.Articulo,			' ')	Articulo,
ISNULL(LP.Precio,			' ')	Precio
FROM	Agente Ag
JOIN	Cte Ct ON Ag.Agente = Ct.Agente
LEFT	JOIN ListaPreciosD LP ON Ct.ListaPreciosEsp = LP.Lista

