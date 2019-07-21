SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarXmlAlmExistenciaPos
@Estacion       int

AS BEGIN
DECLARE
@Empresa varchar(5),
@Almacen varchar(10),
@Xml1    varchar(max),
@Xml2    varchar(max),
@Xml     varchar(max)
DECLARE @Tabla table(
Empresa         varchar(5),
Almacen         varchar(10),
Articulo        varchar(20),
Descripcion     varchar(100),
SerieLote       varchar(50),
SubCuenta       varchar(50),
Unidad          varchar(50),
Existencia      float,
Posicion        varchar(10),
Pasillo         int,
Fila            int,
Nivel           int,
Zona            varchar(50),
Capacidad       int,
Alto            float,
Largo           float,
Volumen         float,
Tipo            varchar(20))
SELECT @Empresa = Empresa ,@Almacen = Almacen
FROM PlugInAlmacenTemp
WHERE Estacion = @Estacion
INSERT @Tabla(Empresa,               Almacen,             Articulo,  Unidad,            SerieLote,              SubCuenta,              Existencia,             Posicion,              Pasillo,             Fila,             Nivel,             Zona,              Capacidad,             Alto,             Largo,              Volumen,             Tipo, Descripcion)
SELECT        ISNULL(e.Empresa,''), ISNULL(e.Almacen,''), ISNULL(e.Articulo,''), ISNULL(e.Unidad,''), ISNULL(e.SerieLote,''), ISNULL(e.SubCuenta,''), ISNULL(e.Existencia,0), ISNULL(e.Posicion,''), ISNULL(a.Pasillo,0), ISNULL(a.Fila,0), ISNULL(a.Nivel,0), ISNULL(a.Zona,''), ISNULL(a.Capacidad,0), ISNULL(a.Alto,0), ISNULL(a.Largo,0),  ISNULL(a.Volumen,0), ISNULL(a.Tipo,''), ISNULL(ar.Descripcion1,'')
FROM    ExistenciaAlternaPosicionSerieLote e JOIN AlmPos a ON e.Almacen = a.Almacen AND e.Posicion = a.Posicion
JOIN Art ar ON e.Articulo = ar.Articulo
WHERE e.Almacen = @Almacen
AND e.Empresa = @Empresa
AND e.Existencia <> 0.0
SELECT @Xml1 = (SELECT * FROM AlmPos  AlmacenPosicion WHERE AlmacenPosicion.Almacen = @Almacen FOR XML AUTO)
SELECT @Xml2 = (SELECT * FROM @Tabla  ExistenciaPosicion FOR XML AUTO)
SELECT @Xml = '<?xml version="1.0" encoding="windows-1252"?><ExistenciaPosicionAlmacen>'+ISNULL(@Xml1,'')+ISNULL(@Xml2,'')+'</ExistenciaPosicionAlmacen>'
SELECT 'Resultado' = CONVERT(xml,@Xml)
RETURN
END

