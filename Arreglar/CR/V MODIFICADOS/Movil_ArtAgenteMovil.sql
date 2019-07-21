SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.Movil_ArtAgenteMovil
AS
SELECT
ISNULL(Ag.Agente,				' ') AgtAgente,
ISNULL(Ag.Nombre,				' ') AgtNombre,
ISNULL(Ct.Cliente,				' ') Cte_Cliente,
ISNULL(Ct.Nombre,				' ') Cte_Nombre,
ISNULL(Ct.Rama,					' ') Cte_CteRama,
ISNULL(Ct.Direccion,			' ') Cte_Direccion,
ISNULL(Ct.DireccionNumero,		' ') Cte_DireccionNumero,
ISNULL(Ct.DireccionNumeroInt,	' ') Cte_DireccionNumeroInt,
ISNULL(Ct.Delegacion,			' ') Cte_Delegacion,
ISNULL(Ct.Colonia,				' ') Cte_Colonia,
ISNULL(Ct.Poblacion,			' ') Cte_Poblacion,
ISNULL(Ct.Estado,				' ') Cte_Estado,
ISNULL(Ct.Pais,					' ') Cte_Pais,
ISNULL(Ct.CodigoPostal,			' ') Cte_CodigoPostal,
ISNULL(Ct.RFC,					' ') Cte_RFC,
ISNULL(Ct.Telefonos,			' ') Cte_Telefonos,
ISNULL(Ct.Extencion1,		    ' ') Cte_Extencion1,
ISNULL(Ct.eMail1,				' ') Cte_eMail1,
ISNULL(Ct.AlmacenDef,			' ') AlmacenDef,
ISNULL(Ct.ListaPrecios,			' ') Cte_ListaPrecios,
ISNULL(Ct.ListaPreciosEsp,		' ') Cte_ListaPreciosEsp,
ISNULL(Ct.Estatus,				' ') Cte_Estatus,
ISNULL(Ct.Descuento,			' ') Cte_Descuento,
ISNULL(Ct.ZonaImpuesto,			' ') Cte_ZonaImpuesto,
ISNULL(Ct.CreditoLimite,		' ') Cte_CreditoLimite,
ISNULL(Ct.Contacto1,			' ') Cte_Contacto1,
ISNULL(Ct.Contacto2,			' ') Cte_Contacto2,
ISNULL(Ct.MapaLatitud,			' ') Cte_MapaLatitud,
ISNULL(Ct.MapaLongitud,			' ') Cte_MapaLongitud,
ISNULL(Ct.MapaPrecision,		' ') Cte_MapaPrecision,
ISNULL(Ct.EntreCalles,			' ') Cte_EntreCalles,
ISNULL(Ct.Condicion,			' ') Cte_Condicion,
ISNULL(Ct.Observaciones,		' ') Cte_Observaciones,
ISNULL(Ct.DefMoneda,			' ') Cte_DefMoneda,
ISNULL(Ar.Articulo ,			' ') Art_Articulo,
ISNULL(Ar.Descripcion1,			' ') Art_Descripcion1,
ISNULL(Ar.Descripcion2,			' ') Art_Descripcion2,
ISNULL(Ar.Categoria,			' ') Art_Categoria,
ISNULL(Ar.Unidad,				' ') Art_Unidad,
ISNULL(Ar.Tipo,					' ') Art_Tipo,
ISNULL(Ar.Grupo,				' ') Art_Almacen,
ISNULL(Ar.MonedaPrecio,			' ') Art_MonedaPrecio,
ISNULL(SU.SaldoU,				' ') Art_Disponible,
ISNULL(Ar.Grupo,				' ') Art_Grupo,
ISNULL(Ar.Linea,				' ') Art_Linea,
ISNULL(Ar.Familia,				' ') Art_Familia,
ISNULL(Ar.PrecioLista,			' ') Art_PrecioLista,
ISNULL(Ar.Estatus,				' ') Art_Estatus,
ISNULL(SU.Saldo,				' ') Art_Existencia,
ISNULL(LP.Lista,				' ') Lista,
ISNULL(LP.Moneda,				' ') Moneda,
ISNULL(LP.Articulo,				' ') Articulo,
ISNULL(LP.Precio,				' ') Precio
FROM	Agente Ag WITH(NOLOCK)
JOIN	Cte Ct WITH(NOLOCK) ON Ag.Agente = Ct.Agente
JOIN	ListaPreciosD LP WITH(NOLOCK) ON Ct.Cliente = LP.CodigoCliente
JOIN	Art Ar WITH(NOLOCK) ON LP.Articulo = Ar.Articulo
JOIN	SaldoU SU WITH(NOLOCK) ON Ar.Articulo = SU.Cuenta

