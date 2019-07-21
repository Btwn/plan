SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPlaneacionMaxMin(
@Empresa     char(5),
@Usuario     varchar(10),
@Estacion    int,
@Categoria   varchar(50),
@Grupo       varchar(50),
@Familia     varchar(50),
@Fabricante  varchar(50),
@Linea       varchar(50),
@Almacen     varchar(10),
@Proveedor   varchar(10)
)

AS BEGIN
DECLARE
@Ok					int,
@OkRef				varchar(256),
@cID				int,
@cArticulo			varchar(20),
@cSubcuenta			varchar(20),
@cAlmacen			varchar(10),
@MovTraspaso		varchar(20),
@MovTraspaso1		varchar(20),
@MovTraspaso2		varchar(20),
@MovCompra			varchar(20),
@Existencia			float,
@EnCompra			float,
@PorRecibir			float,
@PorEntregar		float,
@cOrigenID			int,
@cOrigenArticulo	varchar(20),
@cOrigenSubcuenta	varchar(20),
@cOrigenAlmacen		varchar(10),
@cOrigenMaximo		float,
@cOrigenMinimo		float,
@cOrigenExistencia	float,
@cOrigenSolicitar	float,
@cDestinoID			int,
@cDestinoArticulo	varchar(20),
@cDestinoSubcuenta	varchar(20),
@cDestinoAlmacen	varchar(10),
@cDestinoMaximo		float,
@cDestinoMinimo		float,
@cDestinoExistencia	float,
@cDestinoSolicitar	float,
@cArtEnCompra		float,
@cArtPorRecibir		float,
@cArtPorEntregar	float
SET @Ok = NULL
SET @OkRef = NULL
DELETE PlanArtMaxMin WHERE Empresa = @Empresa AND Usuario = @Usuario
SELECT @MovTraspaso1 = MovInv,
@MovTraspaso2 = MovInv2,
@MovCompra = MovComs
FROM PlanArtMaxMinCfg WHERE Empresa = @Empresa
IF ISNULL(@Categoria, '') = '' OR @Categoria = '' OR @Categoria = '(Todos)' OR @Categoria = '0'
SET @Categoria = NULL
IF ISNULL(@Grupo, '') = '' OR @Grupo = '' OR @Grupo = '(Todos)' OR @Grupo = '0'
SET @Grupo = NULL
IF ISNULL(@Familia, '') = '' OR @Familia = '' OR @Familia = '(Todos)' OR @Familia = '0'
SET @Familia = NULL
IF ISNULL(@Fabricante, '') = '' OR @Fabricante = '' OR @Fabricante = '(Todos)' OR @Fabricante = '0'
SET @Fabricante = NULL
IF ISNULL(@Linea, '') = '' OR @Linea = '' OR @Linea = '(Todos)' OR @Linea = '0'
SET @Linea = NULL
IF ISNULL(@Almacen, '') = '' OR @Almacen = '' OR @Almacen = '(Todos)' OR @Almacen = '0'
SET @Almacen = NULL
IF ISNULL(@Proveedor, '') = '' OR @Proveedor = '' OR @Proveedor = '(Todos)' OR @Proveedor = '0'
SET @Proveedor = NULL
DECLARE @Articulos TABLE(ID					int identity(1,1),
Sucursal			int				NOT NULL,
Articulo			varchar(20)		NOT NULL,
SubCuenta			varchar(20)		NOT NULL,
Descripcion1		varchar(100)	NULL,
Descripcion2		varchar(255)	NULL,
NombreCorto		varchar(20)		NULL,
Proveedor			varchar(10)		NOT NULL,
Nombre				varchar(100)	NOT NULL,
Almacen			varchar(10)		NOT NULL,
AlmacenNombre		varchar(100)	NOT NULL,
Grupo				varchar(50)		NOT NULL,
Categoria			varchar(50)		NOT NULL,
Familia			varchar(50)		NOT NULL,
Linea				varchar(50)		NULL,
Fabricante			varchar(50)		NULL,
ABC				varchar(1)		NULL,
UnidadCompra		varchar(50)		NULL,
UnidadTraspaso		varchar(50)		NULL,
VentaPromedio		float			NULL,
Maximo				float			NULL,
Minimo				float			NULL,
Existencia			float			NULL,
EnCompra			float			NULL,
PorRecibir			float			NULL,
PorEntregar		float			NULL,
Solicitar			float			NULL,
CompraDirecta		bit				NULL,
CEDIS				bit				NULL,
ExisCEDIS			float			NULL
)
DECLARE @AlmacenOrigen TABLE(ID				int,
Articulo		varchar(20),
Subcuenta		varchar(20),
Almacen		varchar(10),
Maximo			float,
Minimo			float,
Existencia		float,
Solicitar		float
)
DECLARE @AlmOrigenCursor TABLE(ID			int,
Articulo		varchar(20),
Subcuenta		varchar(20),
Almacen		varchar(10),
Maximo		float,
Minimo		float,
Existencia	float,
Solicitar		float
)
DECLARE @AlmacenDestino TABLE(ID			int,
Articulo		varchar(20),
Subcuenta		varchar(20),
Almacen		varchar(10),
Maximo		float,
Minimo		float,
Existencia	float,
Solicitar		float
)
DECLARE @AlmDestinoCursor TABLE(ID			int,
Articulo	varchar(20),
Subcuenta	varchar(20),
Almacen		varchar(10),
Maximo		float,
Minimo		float,
Existencia	float,
Solicitar	float
)
CREATE TABLE #PlanArtMaxMin (ID              int identity(1, 1)	NOT NULL,
Empresa         char(5)			NOT NULL,
Sucursal        int				NOT NULL,
Usuario         varchar(10)		NOT NULL,
Estacion        int				NOT NULL,
Grupo           varchar(50)		NULL,
Categoria       varchar(50)		NULL,
Familia         varchar(50)		NULL,
Linea           varchar(50)		NULL,
Fabricante      varchar(50)		NULL,
Proveedor       varchar(10)		NULL,
Nombre          varchar(100)		NULL,
Almacen         varchar(10)		NOT NULL,
AlmacenNombre   varchar(100)		NULL,
Articulo        varchar(20)		NOT NULL,
SubCuenta       varchar(20)		NOT NULL DEFAULT '',
Descripcion1    varchar(100)		NULL,
Descripcion2    varchar(255)		NULL,
NombreCorto     varchar(20)		NULL,
Unidad          varchar(50)		NULL,
ABC             varchar(50)		NULL,
Maximo          float				NULL,
Minimo          float				NULL,
VentaPromedio   float				NULL,
Precio          float				NULL,
ImporteTotal    float				NULL,
Existencia      float				NULL,
EnCompra        float				NULL,
PorRecibir      float				NULL,
PorEntregar     float				NULL,
Disponible      float				NULL,
DiasInvInicio   float				NULL,
AlmacenD        varchar(10)		NOT NULL,
AlmacenNombreD  varchar(100)		NULL,
MaximoD         float				NULL,
MinimoD         float				NULL,
VentaPromedioD  float				NULL,
ExistenciaD     float				NULL,
EnCompraD       float				NULL,
PorRecibirD     float				NULL,
PorEntregarD    float				NULL,
DisponibleD     float				NULL,
DiasInvD        float				NULL,
Solicitar       float				NULL,
Cantidad        float				NULL,
CantidadA       float				NULL,
DiasInvFin      float				NULL,
Tipo            varchar(20)		NULL,
Movimiento      varchar(20)		NULL,
Aplicar         bit				NULL
CONSTRAINT priPlanArtMaxMin PRIMARY KEY CLUSTERED(ID)
)
CREATE NONCLUSTERED INDEX tmpMaxMin ON #PlanArtMaxMin(Articulo, SubCuenta, Almacen, AlmacenD, Sucursal, Empresa)
BEGIN TRY
INSERT INTO @Articulos(Sucursal, Articulo, SubCuenta, Proveedor, Nombre, Almacen, AlmacenNombre,
Grupo, Categoria, Familia, Linea, Fabricante, ABC,
UnidadCompra, UnidadTraspaso, VentaPromedio, Maximo, Minimo, CompraDirecta, CEDIS,
Descripcion1, Descripcion2, NombreCorto)
SELECT E.Sucursal, A.Articulo, ISNULL(C.Subcuenta,'') Subcuenta, A.Proveedor, B.Nombre, D.Almacen, D.Nombre,
ISNULL(A.Grupo,'') Grupo, ISNULL(A.Categoria,'') Categoria, ISNULL(A.Familia,'') Familia, ISNULL(A.Linea,'') Linea, ISNULL(A.Fabricante, '') Fabricante, ISNULL(C.ABC,'') ABC,
ISNULL(A.UnidadCompra, '') UnidadCompra, ISNULL(A.UnidadTraspaso, '') UnidadTraspaso, ISNULL(ROUND(C.VentaPromedio,2),0) VentaPromedio, ISNULL(dbo.fnRedondeaMaxMin(C.Maximo), 0.00) Maximo, ISNULL(dbo.fnRedondeaMaxMin(C.Minimo), 0.00) Minimo, ISNULL(D.CompraDirecta, 0) CompraDirecta, ISNULL(D.CEDIS,0) CEDIS,
A.Descripcion1, A.Descripcion2, A.NombreCorto
FROM Art A
JOIN Prov B ON A.Proveedor = B.Proveedor
JOIN ArtAlm C ON A.Articulo = C.Articulo
JOIN Alm D ON C.Almacen = D.Almacen
JOIN Sucursal E ON D.Sucursal = E.Sucursal
WHERE C.Empresa = @Empresa
AND A.Estatus = 'Alta'
AND (D.Cedis = 1 OR C.Maximo > 0.00)
AND ISNULL(A.Categoria,'') = ISNULL(@Categoria, ISNULL(A.Categoria,''))
AND ISNULL(A.Grupo,'') = ISNULL(@Grupo, ISNULL(A.Grupo,''))
AND ISNULL(A.Familia,'') = ISNULL(@Familia, ISNULL(A.Familia,''))
AND ISNULL(A.Fabricante,'') = ISNULL(@Fabricante, ISNULL(A.Fabricante,''))
AND ISNULL(A.Linea,'') = ISNULL(@Linea, ISNULL(A.Linea,''))
AND ISNULL(C.Almacen,'') = ISNULL(@Almacen, ISNULL(C.Almacen,''))
AND ISNULL(A.Proveedor,'') = ISNULL(@Proveedor, ISNULL(A.Proveedor,''))
DECLARE cArticulo CURSOR FOR
SELECT ID, Articulo, SubCuenta, Almacen
FROM @Articulos
OPEN cArticulo
FETCH NEXT FROM cArticulo INTO @cID, @cArticulo, @cSubcuenta, @cAlmacen
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Existencia  = 0.00
SET @EnCompra    = 0.00
SET @PorRecibir  = 0.00
SET @PorEntregar = 0.00
/*
SELECT @Existencia = SUM(ISNULL(dbo.fnRedondeaMaxMin(SaldoU), 0.00))
FROM SaldoU
WHERE Cuenta = @cArticulo
AND ISNULL(Subcuenta,'') = ISNULL(@cSubcuenta,ISNULL(Subcuenta,''))
AND Grupo = @cAlmacen
AND Rama <> 'RESV'
*/
SELECT @Existencia = Sum(s.SaldoU*r.Factor)
FROM SaldoU s
JOIN Rama r ON s.Rama=r.Rama
WHERE r.Mayor='INV'
AND s.Cuenta = @cArticulo
AND ISNULL(s.Subcuenta,'') = ISNULL(@cSubcuenta,ISNULL(Subcuenta,''))
AND s.Grupo = @cAlmacen
GROUP BY s.Empresa, s.Cuenta, s.Grupo
SELECT @EnCompra = ISNULL(SUM(ROUND(d.CantidadPendiente, 0, -1)), 0.00)
FROM Compra c
JOIN CompraD d ON c.ID = d.ID
JOIN MovTipo t ON c.Mov = t.Mov AND t.Modulo = 'COMS'
JOIN Art a ON d.Articulo = a.Articulo
WHERE c.Empresa = @Empresa
AND c.Estatus IN ('PENDIENTE', 'SINAFECTAR')
AND t.Clave IN ('COMS.O', 'COMS.R')
AND d.CantidadPendiente > 0
AND ISNULL(a.Categoria, '') = ISNULL(@Categoria, ISNULL(a.Categoria, ''))
AND ISNULL(a.Proveedor, '') = ISNULL(@Proveedor, ISNULL(a.Proveedor, ''))
AND d.Articulo = @cArticulo
AND ISNULL(d.Subcuenta,'') = ISNULL(@cSubcuenta,ISNULL(d.Subcuenta,''))
AND d.Almacen = @cAlmacen
GROUP BY d.Almacen, d.Articulo, d.Subcuenta
SELECT @PorRecibir = ISNULL(SUM(ROUND(d.CantidadPendiente, 0, -1)), 0.00)
FROM Inv c
JOIN InvD d ON c.ID = d.ID
JOIN MovTipo t ON c.Mov = t.Mov AND t.Modulo = 'INV'
JOIN Art a ON d.Articulo = a.Articulo
WHERE c.Empresa = @Empresa
AND c.Estatus = 'PENDIENTE'
AND t.Clave IN ('INV.TI', 'INV.OI', 'INV.OT')
AND d.CantidadPendiente > 0
AND ISNULL(a.Categoria, '') = ISNULL(@Categoria, ISNULL(a.Categoria, ''))
AND ISNULL(a.Proveedor, '') = ISNULL(@Proveedor, ISNULL(a.Proveedor, ''))
AND ISNULL(c.AlmacenDestino, '') <> ''
AND d.Articulo = @cArticulo
AND ISNULL(d.Subcuenta,'') = ISNULL(@cSubcuenta,ISNULL(d.Subcuenta,''))
AND c.AlmacenDestino = @cAlmacen
GROUP BY c.AlmacenDestino, d.Articulo, d.Subcuenta
SELECT @PorEntregar = ISNULL(SUM(ROUND(d.CantidadPendiente, 0, -1)), 0.00)
FROM Inv c
JOIN InvD d ON c.ID = d.ID
JOIN MovTipo t ON c.Mov = t.Mov AND t.Modulo = 'INV'
JOIN Art a ON d.Articulo = a.Articulo
WHERE c.Empresa = @Empresa
AND c.Estatus = 'PENDIENTE'
AND t.Clave IN ('INV.TI', 'INV.OI', 'INV.OT')
AND d.CantidadPendiente > 0
AND ISNULL(a.Categoria, '') = ISNULL(@Categoria, ISNULL(a.Categoria, ''))
AND ISNULL(a.Proveedor, '') = ISNULL(@Proveedor, ISNULL(a.Proveedor, ''))
AND ISNULL(c.AlmacenDestino, '') <> ''
AND d.Articulo = @cArticulo
AND ISNULL(d.Subcuenta,'') = ISNULL(@cSubcuenta,ISNULL(d.Subcuenta,''))
AND c.Almacen = @cAlmacen
GROUP BY c.Almacen, d.Articulo, d.Subcuenta
UPDATE @Articulos SET Existencia = @Existencia,
EnCompra = @EnCompra,
PorRecibir = @PorRecibir,
PorEntregar = @PorEntregar,
ExisCEDIS = CASE WHEN CEDIS = 1 THEN @Existencia ELSE 0.00 END
WHERE ID = @cID
UPDATE @Articulos SET Solicitar = CASE WHEN Maximo > 0
THEN CASE WHEN Maximo-(Existencia+EnCompra+PorRecibir-PorEntregar) <= 0
THEN 0
ELSE Maximo-(Existencia+EnCompra+PorRecibir-PorEntregar)
END
ELSE 0
END
WHERE ID = @cID
INSERT @AlmacenOrigen(ID, Articulo, Subcuenta, Almacen, Maximo, Minimo, Existencia, Solicitar)
SELECT A.ID, A.Articulo, A.Subcuenta, A.Almacen, A.Maximo, A.Minimo, (A.Existencia+A.PorEntregar)+A.EnCompra+A.PorRecibir-A.PorEntregar, A.Solicitar
FROM @Articulos A
JOIN RutaDistribucionMaxMin B ON A.Almacen = B.AlmacenOrigen
WHERE A.ID = @cID
AND A.Existencia > 0
AND isnull(A.CompraDirecta,0) = 0
UNION
SELECT A.ID, A.Articulo, A.Subcuenta, A.Almacen, A.Maximo, A.Minimo, (A.Existencia+A.PorEntregar)+A.EnCompra+A.PorRecibir-A.PorEntregar, A.Solicitar
FROM @Articulos A
WHERE A.ID = @cID
AND isnull(A.CompraDirecta,0) = 1
EXCEPT
SELECT ID, Articulo, Subcuenta, Almacen, Maximo, Minimo, Existencia, Solicitar
FROM @AlmacenOrigen
WHERE Articulo = @cArticulo
AND Subcuenta = @cSubcuenta
AND Almacen = @cAlmacen
INSERT @AlmacenDestino(ID, Articulo, Subcuenta, Almacen, Maximo, Minimo, Existencia, Solicitar)
SELECT A.ID, A.Articulo, A.Subcuenta, A.Almacen, A.Maximo, A.Minimo, (A.Existencia+A.PorEntregar)+A.EnCompra+A.PorRecibir-A.PorEntregar, A.Solicitar
FROM @Articulos A
JOIN RutaDistribucionMaxMin B ON A.Almacen = B.AlmacenDestino
WHERE A.ID = @cID
AND A.Solicitar > 0
EXCEPT
SELECT ID, Articulo, Subcuenta, Almacen, Maximo, Minimo, Existencia, Solicitar
FROM @AlmacenDestino
WHERE Articulo = @cArticulo
AND Subcuenta = @cSubcuenta
AND Almacen = @cAlmacen
FETCH NEXT FROM cArticulo INTO @cID, @cArticulo, @cSubcuenta, @cAlmacen
END
CLOSE cArticulo
DEALLOCATE cArticulo
DECLARE cDistribucion CURSOR FOR
SELECT A.ID, A.Articulo, A.Subcuenta, A.Almacen,
B.ID, B.Articulo, B.Subcuenta, B.Almacen,
D.EnCompra, D.PorRecibir, D.PorEntregar
FROM @AlmacenDestino A
JOIN RutaDistribucionMaxMin C ON A.Almacen = C.AlmacenDestino
JOIN @AlmacenOrigen B ON B.Almacen = C.AlmacenOrigen
AND A.Articulo = B.Articulo
AND ISNULL(A.Subcuenta,'') = ISNULL(B.Subcuenta,'')
JOIN @Articulos D ON A.ID = D.ID
WHERE A.Solicitar > 0
AND B.Existencia > 0
ORDER BY C.Orden
INSERT @AlmOrigenCursor(ID, Articulo, Subcuenta, Almacen, Maximo, Minimo, Existencia, Solicitar)
SELECT A.ID, A.Articulo, A.Subcuenta, A.Almacen, A.Maximo, A.Minimo, A.Existencia, A.Solicitar
FROM @AlmacenOrigen A
INSERT @AlmDestinoCursor(ID, Articulo, Subcuenta, Almacen, Maximo, Minimo, Existencia, Solicitar)
SELECT A.ID, A.Articulo, A.Subcuenta, A.Almacen, A.Maximo, A.Minimo, A.Existencia, A.Solicitar
FROM @AlmacenDestino A
OPEN cDistribucion
FETCH NEXT FROM cDistribucion INTO @cDestinoID, @cDestinoArticulo, @cDestinoSubcuenta, @cDestinoAlmacen,
@cOrigenID,	@cOrigenArticulo, @cOrigenSubcuenta, @cOrigenAlmacen,
@cArtEnCompra, @cArtPorRecibir, @cArtPorEntregar
WHILE @@FETCH_STATUS = 0
BEGIN
IF EXISTS(SELECT * FROM Alm A JOIN Alm B ON A.Sucursal = B.Sucursal WHERE A.Almacen = @cDestinoAlmacen AND B.Almacen = @cOrigenAlmacen)
SET @MovTraspaso = ISNULL(@MovTraspaso2,@MovTraspaso1)
IF NOT EXISTS(SELECT * FROM Alm A JOIN Alm B ON A.Sucursal = B.Sucursal WHERE A.Almacen = @cDestinoAlmacen AND B.Almacen = @cOrigenAlmacen)
SET @MovTraspaso = @MovTraspaso1
SELECT @cDestinoSolicitar = 0
SELECT @cOrigenExistencia = 0
SELECT @cDestinoSolicitar = Solicitar FROM @AlmDestinoCursor WHERE ID = @cDestinoID
SELECT @cOrigenExistencia = Existencia FROM @AlmOrigenCursor WHERE ID = @cOrigenID
IF @cDestinoSolicitar <= @cOrigenExistencia AND @cDestinoSolicitar > 0
BEGIN
INSERT #PlanArtMaxMin(Empresa, Sucursal, Usuario, Estacion, Grupo, Categoria, Familia, Linea,
Fabricante, Proveedor, Nombre, Almacen, AlmacenNombre, Articulo, SubCuenta, Descripcion1,
Descripcion2, NombreCorto, Unidad, ABC, Maximo, Minimo, VentaPromedio, Precio,
ImporteTotal, Existencia, EnCompra, PorRecibir, PorEntregar, Disponible, DiasInvInicio, AlmacenD,
AlmacenNombreD, MaximoD, MinimoD, VentaPromedioD, ExistenciaD, EnCompraD, PorRecibirD, PorEntregarD,
DisponibleD, DiasInvD, Solicitar, Cantidad, CantidadA, DiasInvFin, Tipo, Movimiento)
SELECT @Empresa, A.Sucursal, @Usuario, @Estacion, A.Grupo, A.Categoria, A.Familia, A.Linea,
A.Fabricante, A.Proveedor, A.Nombre, A.Almacen, A.AlmacenNombre, A.Articulo, ISNULL(A.SubCuenta,''), A.Descripcion1,
A.Descripcion2, A.NombreCorto, A.UnidadTraspaso, A.ABC, A.Maximo, A.Minimo, A.VentaPromedio, 0.00,
0.00, (A.Existencia+A.PorEntregar), A.EnCompra, A.PorRecibir, A.PorEntregar, ((A.Existencia+A.PorEntregar)+A.EnCompra+A.PorRecibir-A.PorEntregar),
CASE WHEN ISNULL(A.VentaPromedio,0.00) > 0 THEN ((A.Existencia+A.PorEntregar)+A.EnCompra+A.PorRecibir-A.PorEntregar) / ISNULL(A.VentaPromedio,0.00) ELSE 0.00 END, C.Almacen,
C.AlmacenNombre, C.Maximo, C.Minimo, C.VentaPromedio, C.Existencia, C.EnCompra, C.PorRecibir, C.PorEntregar,
((C.Existencia+C.PorEntregar)+C.EnCompra+C.PorRecibir-C.PorEntregar),
CASE WHEN ((C.Existencia+C.PorEntregar)+C.EnCompra+C.PorRecibir-C.PorEntregar) > 0 AND C.VentaPromedio > 0 THEN ISNULL(((C.Existencia+C.PorEntregar)+C.EnCompra+C.PorRecibir-C.PorEntregar),0.00)/ISNULL(C.VentaPromedio,0.00) ELSE 0 END,
@cDestinoSolicitar, C.Solicitar, @cDestinoSolicitar,
CASE WHEN C.VentaPromedio > 0 THEN (ISNULL(C.Existencia,0.00)+ISNULL(@cDestinoSolicitar,0.00))/ISNULL(C.VentaPromedio,0.00) ELSE 0 END, 'Distribuir', @MovTraspaso
FROM @Articulos A
JOIN @AlmacenOrigen B ON A.ID = B.ID
JOIN @Articulos C ON A.Articulo = C.Articulo AND ISNULL(A.Subcuenta,'') = ISNULL(C.Subcuenta,'')
JOIN @AlmacenDestino D ON C.ID = D.ID
WHERE A.ID = @cOrigenID
AND C.ID = @cDestinoID
UPDATE @AlmOrigenCursor SET Existencia = Existencia - @cDestinoSolicitar WHERE ID = @cOrigenID
UPDATE @AlmacenOrigen SET Existencia = Existencia - @cDestinoSolicitar WHERE ID = @cOrigenID
UPDATE @AlmDestinoCursor SET Solicitar = Solicitar - @cDestinoSolicitar WHERE ID = @cDestinoID
UPDATE @AlmacenDestino SET Solicitar = Solicitar - @cDestinoSolicitar WHERE ID = @cDestinoID
FETCH NEXT FROM cDistribucion INTO @cDestinoID, @cDestinoArticulo, @cDestinoSubcuenta, @cDestinoAlmacen,
@cOrigenID,	@cOrigenArticulo, @cOrigenSubcuenta, @cOrigenAlmacen,
@cArtEnCompra, @cArtPorRecibir, @cArtPorEntregar
END
IF @cDestinoSolicitar > @cOrigenExistencia AND @cDestinoSolicitar > 0
BEGIN
INSERT #PlanArtMaxMin(Empresa, Sucursal, Usuario, Estacion, Grupo, Categoria, Familia, Linea,
Fabricante, Proveedor, Nombre, Almacen, AlmacenNombre, Articulo, SubCuenta, Descripcion1,
Descripcion2, NombreCorto, Unidad, ABC, Maximo, Minimo, VentaPromedio, Precio,
ImporteTotal, Existencia, EnCompra, PorRecibir, PorEntregar, Disponible, DiasInvInicio, AlmacenD,
AlmacenNombreD, MaximoD, MinimoD, VentaPromedioD, ExistenciaD, EnCompraD, PorRecibirD, PorEntregarD,
DisponibleD, DiasInvD, Solicitar, Cantidad, CantidadA, DiasInvFin, Tipo, Movimiento)
SELECT @Empresa, A.Sucursal, @Usuario, @Estacion, A.Grupo, A.Categoria, A.Familia, A.Linea,
A.Fabricante, A.Proveedor, A.Nombre, A.Almacen, A.AlmacenNombre, A.Articulo, ISNULL(A.SubCuenta,''), A.Descripcion1,
A.Descripcion2, A.NombreCorto, A.UnidadTraspaso, A.ABC, A.Maximo, A.Minimo, A.VentaPromedio, 0.00,
0.00, (A.Existencia+A.PorEntregar), A.EnCompra, A.PorRecibir, A.PorEntregar, CASE WHEN ((A.Existencia+A.PorEntregar)+A.EnCompra+A.PorRecibir-A.PorEntregar) < 0 THEN 0 ELSE ((A.Existencia+A.PorEntregar)+A.EnCompra+A.PorRecibir-A.PorEntregar) END,
CASE WHEN ISNULL(A.VentaPromedio,0.00) > 0 THEN ((A.Existencia+A.PorEntregar)+A.EnCompra+A.PorRecibir-A.PorEntregar) / ISNULL(A.VentaPromedio,0.00) ELSE 0.00 END, C.Almacen,
C.AlmacenNombre, C.Maximo, C.Minimo, C.VentaPromedio, C.Existencia, C.EnCompra, C.PorRecibir, C.PorEntregar,
((C.Existencia+C.PorEntregar)+C.EnCompra+C.PorRecibir-C.PorEntregar),
CASE WHEN ((C.Existencia+C.PorEntregar)+C.EnCompra+C.PorRecibir-C.PorEntregar) > 0 AND C.VentaPromedio > 0 THEN ISNULL(((C.Existencia+C.PorEntregar)+C.EnCompra+C.PorRecibir-C.PorEntregar),0.00)/ISNULL(C.VentaPromedio,0.00) ELSE 0 END,
@cOrigenExistencia, C.Solicitar, @cOrigenExistencia,
CASE WHEN C.VentaPromedio > 0 THEN (((C.Existencia+C.PorEntregar)+C.EnCompra+C.PorRecibir-C.PorEntregar)+ISNULL(@cOrigenExistencia,0.00))/ISNULL(C.VentaPromedio,0.00) ELSE 0 END,
'Distribuir', @MovTraspaso
FROM @Articulos A
JOIN @AlmacenOrigen B ON A.ID = B.ID
JOIN @Articulos C ON A.Articulo = C.Articulo AND ISNULL(A.Subcuenta,'') = ISNULL(C.Subcuenta,'')
JOIN @AlmacenDestino D ON C.ID = D.ID
WHERE A.ID = @cOrigenID
AND C.ID = @cDestinoID
UPDATE @AlmOrigenCursor SET Existencia = Existencia - @cOrigenExistencia WHERE ID = @cOrigenID
UPDATE @AlmacenOrigen SET Existencia = Existencia - @cOrigenExistencia WHERE ID = @cOrigenID
UPDATE @AlmDestinoCursor SET Solicitar = Solicitar - @cOrigenExistencia WHERE ID = @cDestinoID
UPDATE @AlmacenDestino SET Solicitar = Solicitar - @cOrigenExistencia WHERE ID = @cDestinoID
FETCH NEXT FROM cDistribucion INTO @cDestinoID, @cDestinoArticulo, @cDestinoSubcuenta, @cDestinoAlmacen,
@cOrigenID,	@cOrigenArticulo, @cOrigenSubcuenta, @cOrigenAlmacen,
@cArtEnCompra, @cArtPorRecibir, @cArtPorEntregar
END
END
CLOSE cDistribucion
DEALLOCATE cDistribucion
DECLARE cDistribucion CURSOR FOR
SELECT A.ID, A.Articulo, A.Subcuenta, A.Almacen,
B.ID, B.Articulo, B.Subcuenta, B.Almacen,
D.EnCompra, D.PorRecibir, D.PorEntregar
FROM @AlmacenDestino A
JOIN RutaDistribucionMaxMin C ON A.Almacen = C.AlmacenDestino
JOIN @AlmacenOrigen B ON B.Almacen = C.AlmacenOrigen
AND A.Articulo = B.Articulo
AND ISNULL(A.Subcuenta,'') = ISNULL(B.Subcuenta,'')
JOIN @Articulos D ON B.ID = D.ID
WHERE A.Solicitar > 0
AND B.Existencia <= 0
AND ISNULL(D.CompraDirecta,0) = 1
ORDER BY C.Orden
DELETE FROM @AlmOrigenCursor
INSERT @AlmOrigenCursor(ID, Articulo, Subcuenta, Almacen, Maximo, Minimo, Existencia, Solicitar)
SELECT A.ID, A.Articulo, A.Subcuenta, A.Almacen, A.Maximo, A.Minimo, A.Existencia, A.Solicitar
FROM @AlmacenOrigen A
DELETE FROM @AlmOrigenCursor
INSERT @AlmDestinoCursor(ID, Articulo, Subcuenta, Almacen, Maximo, Minimo, Existencia, Solicitar)
SELECT A.ID, A.Articulo, A.Subcuenta, A.Almacen, A.Maximo, A.Minimo, A.Existencia, A.Solicitar
FROM @AlmacenDestino A
OPEN cDistribucion
FETCH NEXT FROM cDistribucion INTO @cDestinoID, @cDestinoArticulo, @cDestinoSubcuenta, @cDestinoAlmacen,
@cOrigenID,	@cOrigenArticulo, @cOrigenSubcuenta, @cOrigenAlmacen,
@cArtEnCompra, @cArtPorRecibir, @cArtPorEntregar
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @cDestinoSolicitar = 0
SELECT @cOrigenExistencia = 0
SELECT @cDestinoSolicitar = Solicitar FROM @AlmDestinoCursor WHERE ID = @cDestinoID
SELECT @cOrigenExistencia = Existencia FROM @AlmOrigenCursor WHERE ID = @cOrigenID
BEGIN
INSERT #PlanArtMaxMin(Empresa, Sucursal, Usuario, Estacion, Grupo, Categoria, Familia, Linea,
Fabricante, Proveedor, Nombre, Almacen, AlmacenNombre, Articulo, SubCuenta, Descripcion1,
Descripcion2, NombreCorto, Unidad, ABC, Maximo, Minimo, VentaPromedio, Precio,
ImporteTotal, Existencia, EnCompra, PorRecibir, PorEntregar, Disponible, DiasInvInicio, AlmacenD,
AlmacenNombreD, MaximoD, MinimoD, VentaPromedioD, ExistenciaD, EnCompraD, PorRecibirD, PorEntregarD,
DisponibleD, DiasInvD, Solicitar, Cantidad, CantidadA, DiasInvFin, Tipo, Movimiento)
SELECT @Empresa, A.Sucursal, @Usuario, @Estacion, A.Grupo, A.Categoria, A.Familia, A.Linea,
A.Fabricante, A.Proveedor, A.Nombre, A.Almacen, A.AlmacenNombre, A.Articulo, ISNULL(A.SubCuenta,''), A.Descripcion1,
A.Descripcion2, A.NombreCorto, A.UnidadTraspaso, A.ABC, A.Maximo, A.Minimo, A.VentaPromedio, 0.00,
0.00, (A.Existencia+A.PorEntregar), A.EnCompra, A.PorRecibir, A.PorEntregar, ((A.Existencia+A.PorEntregar)+A.EnCompra+A.PorRecibir-A.PorEntregar),
CASE WHEN ISNULL(A.VentaPromedio,0.00) > 0 THEN ((A.Existencia+A.PorEntregar)+A.EnCompra+A.PorRecibir-A.PorEntregar) / ISNULL(A.VentaPromedio,0.00) ELSE 0.00 END, C.Almacen,
C.AlmacenNombre, C.Maximo, C.Minimo, C.VentaPromedio, C.Existencia, C.EnCompra, C.PorRecibir, C.PorEntregar,
((C.Existencia+C.PorEntregar)+C.EnCompra+C.PorRecibir-C.PorEntregar),
CASE WHEN ((C.Existencia+C.PorEntregar)+C.EnCompra+C.PorRecibir-C.PorEntregar) > 0 AND C.VentaPromedio > 0 THEN ISNULL(((C.Existencia+C.PorEntregar)+C.EnCompra+C.PorRecibir-C.PorEntregar),0.00)/ISNULL(C.VentaPromedio,0.00) ELSE 0 END,
@cDestinoSolicitar, C.Solicitar, @cDestinoSolicitar,
CASE WHEN C.VentaPromedio > 0 THEN (((C.Existencia+C.PorEntregar)+C.EnCompra+C.PorRecibir-C.PorEntregar)+ISNULL(@cDestinoSolicitar,0.00))/ISNULL(C.VentaPromedio,0.00) ELSE 0 END,
'Comprar', @MovCompra
FROM @Articulos A
JOIN @AlmacenOrigen B ON A.ID = B.ID
JOIN @Articulos C ON A.Articulo = C.Articulo AND ISNULL(A.Subcuenta,'') = ISNULL(C.Subcuenta,'')
JOIN @AlmacenDestino D ON C.ID = D.ID
WHERE A.ID = @cOrigenID
AND C.ID = @cDestinoID
UPDATE @AlmOrigenCursor SET Existencia = Existencia - @cDestinoSolicitar WHERE ID = @cOrigenID
UPDATE @AlmDestinoCursor SET Solicitar = Solicitar - @cDestinoSolicitar WHERE ID = @cOrigenID
FETCH NEXT FROM cDistribucion INTO @cDestinoID, @cDestinoArticulo, @cDestinoSubcuenta, @cDestinoAlmacen,
@cOrigenID,	@cOrigenArticulo, @cOrigenSubcuenta, @cOrigenAlmacen,
@cArtEnCompra, @cArtPorRecibir, @cArtPorEntregar
END
END
CLOSE cDistribucion
DEALLOCATE cDistribucion
INSERT INTO PlanArtMaxMin (Empresa, Sucursal, Usuario, Estacion, Grupo, Categoria, Familia, Linea,
Fabricante, Proveedor, Nombre, Almacen, AlmacenNombre, Articulo, SubCuenta, Descripcion1,
Descripcion2, NombreCorto, Unidad, ABC, Maximo, Minimo, VentaPromedio, Precio, ImporteTotal, Existencia,
EnCompra, PorRecibir, PorEntregar, Disponible, DiasInvInicio, AlmacenD, AlmacenNombreD, MaximoD, MinimoD,
VentaPromedioD, ExistenciaD, EnCompraD, PorRecibirD, PorEntregarD, DisponibleD,
DiasInvD, Solicitar, Cantidad, CantidadA, DiasInvFin, Tipo, Movimiento, Aplicar)
SELECT Empresa, Sucursal, Usuario, Estacion, Grupo, Categoria, Familia, Linea,
Fabricante, Proveedor, Nombre, Almacen, AlmacenNombre, Articulo, SubCuenta, Descripcion1,
Descripcion2, NombreCorto, Unidad, ABC, Maximo, Minimo, VentaPromedio, Precio, ImporteTotal, Existencia,
EnCompra, PorRecibir, PorEntregar, Disponible, DiasInvInicio, AlmacenD, AlmacenNombreD, MaximoD, MinimoD,
VentaPromedioD, ExistenciaD, EnCompraD, PorRecibirD, PorEntregarD, DisponibleD,
DiasInvD, Solicitar, Cantidad, CantidadA, DiasInvFin, Tipo, Movimiento, 0
FROM #PlanArtMaxMin
SELECT @OkRef = 'Proceso Completado'
END TRY
BEGIN CATCH
SET @OkRef = ERROR_MESSAGE()
END CATCH
SELECT @OkRef
END

