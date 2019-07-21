SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spInforArticuloSaldoInicial
@Articulo varchar(20),
@Usuario  varchar(10),
@Empresa  varchar(5),
@Sucursal int

AS
BEGIN
DECLARE
@AccesoID					int,
@Ok							int,
@OkRef						varchar(255),
@Contrasena					varchar(32),
@Resultado					varchar(max),
@Resultado2					varchar(max),
@Id							int,
@Version					float,
@SubReferencia              varchar(255) ,
@Datos						varchar (max),
@ReferenciaIntelisisService	varchar(50),
@ArtTipo					varchar(20)
DECLARE
@Tabla table(
Articulo      varchar(20),
SubCuenta     varchar(50),
SerieLote     varchar(20),
Almacen       varchar(10),
EntradaSalida varchar(1),
Existencia    float
)
SELECT @ReferenciaIntelisisService = Referencia
FROM MapeoPlantaIntelisisMes
WITH(NOLOCK) WHERE Empresa = @Empresa AND Sucursal = @Sucursal
SELECT @ArtTipo = Tipo FROM Art WITH(NOLOCK) WHERE Articulo = @Articulo
IF @ArtTipo IN ('Serie', 'Lote')
BEGIN
INSERT INTO @Tabla (Articulo,   SubCuenta,              SerieLote,   Almacen,   Existencia,   EntradaSalida)
SELECT              s.Articulo, ISNULL(s.SubCuenta,''), s.SerieLote, s.Almacen, ISNULL(s.Existencia,0), 'E'
FROM SerieLote s  WITH(NOLOCK) JOIN Alm m  WITH(NOLOCK) ON s.Almacen = m.Almacen
WHERE ISNULL(m.EsFactory,0) = 1
AND ISNULL(s.Existencia,0)<>0
AND s.Articulo = @Articulo
END
ELSE
BEGIN
INSERT INTO @Tabla (Articulo,   SubCuenta,              SerieLote,   Almacen,   Existencia,   EntradaSalida)
SELECT              s.Articulo, '', '', s.Almacen, ISNULL(s.Disponible,0)+ISNULL(s.Reservado,0), 'E'
FROM ArtDisponibleReservado s  WITH(NOLOCK) JOIN Alm m  WITH(NOLOCK) ON s.Almacen = m.Almacen
WHERE ISNULL(m.EsFactory,0) = 1
AND s.Articulo = @Articulo
END
SET @Resultado2 =ISNULL(CONVERT(varchar(max) ,(SELECT * FROM @Tabla InvExistencia FOR XML AUTO)),'')
SET @Datos = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Infor" Contenido="Solicitud" Referencia=' + CHAR(34) +'Intelisis.INV.Cuadrar.ExistenciaMES' + CHAR(34) + ' SubReferencia=' + CHAR(34) + ISNULL(@SubReferencia,'') + CHAR(34) + ' Version=' + CHAR(34) + ISNULL(CONVERT(varchar ,@Version),'') + CHAR(34) + '><Solicitud IntelisisServiceID=' + CHAR(34) + ISNULL(CONVERT(varchar,@ID),'')   + CHAR(34) + ' Ok=' + CHAR(34) + ISNULL(CONVERT(varchar,@Ok),'') + CHAR(34) + ' OkRef=' + CHAR(34) + ISNULL(@OkRef,'') + CHAR(34)+ ' ReferenciaIntelisisService=' + CHAR(34) + ISNULL(@ReferenciaIntelisisService,'') + CHAR(34)+ ' >' + @Resultado2 + '</Solicitud></Intelisis>'
SELECT @Contrasena = Contrasena
FROM Usuario
WITH(NOLOCK) WHERE Usuario = @Usuario
EXEC spIntelisisService  @Usuario,@Contrasena,@Datos,@Resultado,@Ok Output,@OkRef Output,0,0,@Id Output
END

