SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW WMSInfoPosicion

AS
SELECT Tarima.Tarima                         AS 'Tarima',
Tarima.Estatus                        AS 'Estatus',
Alm.Almacen                           AS 'Almacen',
Alm.Nombre                            AS 'Nombre_Almacen',
AlmPos.Tipo                           AS 'Tipo_Posicion',
AlmPos.Descripcion                    AS 'Descripcion',
AlmPos.Zona                           AS 'Zona',
AlmPos.Pasillo                        AS 'Pasillo',
AlmPos.Fila                           AS 'Fila',
AlmPos.Nivel                          AS 'Nivel',
AlmPos.Alto                           AS 'Alto',
AlmPos.Largo                          AS 'Largo',
AlmPos.Ancho                          AS 'Ancho',
AlmPos.Volumen                        AS 'Volumen',
AlmPos.PesoMaximo                     AS 'Peso',
ArtDisponibleTarima.Disponible		  AS 'Disponible',
ArtDisponibleTarima.Apartado		  AS 'Apartado',
ArtDisponibleTarima.Articulo		  AS 'Articulo',
Art.Descripcion1                      AS 'Nombre',
Art.Tipo                              AS 'Tipo',
Art.Unidad                            AS 'Articulo_Unidad',
AlmPos.Posicion                       AS 'Posicion'
FROM  Tarima
JOIN  AlmPos ON Tarima.Almacen = AlmPos.Almacen AND ISNULL(Tarima.Posicion, AlmPos.Posicion) = AlmPos.Posicion
LEFT JOIN  ArtDisponibleTarima ON Tarima.Tarima = ArtDisponibleTarima.Tarima AND ArtDisponibleTarima.Disponible > 0
JOIN  Art ON ArtDisponibleTarima.Articulo = Art.Articulo
JOIN  Empresa ON ArtDisponibleTarima.Empresa = Empresa.Empresa
JOIN  Alm ON ArtDisponibleTarima.Almacen = Alm.Almacen

