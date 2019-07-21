SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spValidaAux (
@Empresa	varchar(5),
@Usuario	varchar(10),
@Sucursal	int,
@Articulo	varchar(20) = NULL,
@Almacen	varchar(100) = NULL,
@SerieLote	varchar(50) = NULL,
@Detalle	bit = 0,				
@SolicitarExistenciaMES bit = 1		
)

AS
BEGIN
SET NOCOUNT ON
IF @SolicitarExistenciaMES = 1
EXEC spSolicitarExistenciaMES @Empresa, @Usuario, @Sucursal
IF (SELECT CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ArtExistenciaIntMES' AND COLUMN_NAME = 'SerieLote') < 50
ALTER TABLE ArtExistenciaIntMES ALTER COLUMN SerieLote VARCHAR(50)
TRUNCATE TABLE dbo.IntelisisResultadoAux
BEGIN
DECLARE @ToleranciaAjuste	float,
@RedondeoMonetarios	int,
@Articulo_C			varchar(20),
@SerieLote_C		varchar(50),
@Almacen_C			varchar(100),
@ExistenciaInte_C	float,
@ExistenciaMES_C	float,
@Direferncia_C		float,
@Fecha_i1			datetime,
@Cantidad_i1		float,
@Articulo_i1		varchar(20),
@Almacen_i1			varchar(100),
@SerieLote_i1		varchar(50)
DECLARE @IntelisisAux AS TABLE(
IDRef			int identity,
ID				int,
Empresa			char(5),
Articulo		char(20),
Descripcion1	varchar(100),
Tipo			varchar(20),
EsFactory		bit,
Almacen			char(100),
Modulo			char(5),
ModuloID		int,
Mov				char(20),
MovID			varchar(20),
Renglon_AU		float,
Fecha			datetime,
Renglon			float,
RenglonID		int,
Cantidad		float,
AlmOrigen		char(10),
AlmDestino		char(10),
CargoU			float,
AbonoU			float,
SerieLote		varchar(50),
Cantidad_S		float,
EsCancelacion	bit,
numProcesado	tinyint)
DECLARE @FactoryAux AS TABLE(
IDRef				int identity,
tipoubicacion		varchar(3),
codigoubicacion		nvarchar(40),
cantnota			real,
id					int,
codnota				nvarchar(6),
letnota				nvarchar(2),
sucnota				smallint,
numnota				int,
linnota				smallint,
fecha				datetime,
concepto			nvarchar(6),
numeroot			int,
almacen				nvarchar(16),
seccion				nvarchar(20),
proveedor			nvarchar(40),
cliente				nvarchar(40),
item				nvarchar(40),
version				nvarchar(10),
variante			nvarchar(10),
identificacion		nvarchar(100),
cantidad			real,
stockantes			real,
stockdespues		real,
umedida				nvarchar(6),
condicion			nvarchar(4),
precio				money,
codrel				nvarchar(6),
sucrel				smallint,
numrel				int,
letrel				nvarchar(20),
linrel				smallint,
codrechazo			nvarchar(30),
preciocalantes		money,
preciocaldespues	money,
importenencia		real,
genera				nvarchar(30),
fechasys			datetime,
consolidado			bit,
docproveedorsuc		smallint,
docproveedornum		nvarchar(40),
ordservicio			nvarchar(16),
programa			varchar(20),
numProcesado		tinyint)
DECLARE @IntelisisRes AS TABLE(
IDRef			int,
ID				int,
Empresa			char(5),
Articulo		char(20),
Descripcion1	varchar(100),
Tipo			varchar(20),
EsFactory		bit,
Almacen			char(100),
Modulo			char(5),
ModuloID		int,
Mov				char(20),
MovID			varchar(20),
Renglon_AU		float,
Fecha			datetime,
Renglon			float,
RenglonID		int,
Cantidad		float,
AlmOrigen		char(10),
AlmDestino		char(10),
CargoU			float,
AbonoU			float,
SerieLote		varchar(50),
Cantidad_S		float,
EsCancelacion	bit,
numProcesado	tinyint)
DECLARE @FactoryRes AS TABLE(
IDRef				int,
tipoubicacion		varchar(3),
codigoubicacion		nvarchar(40),
cantnota			real,
id					int,
codnota				nvarchar(6),
letnota				nvarchar(2),
sucnota				smallint,
numnota				int,
linnota				smallint,
fecha				datetime,
concepto			nvarchar(6),
numeroot			int,
almacen				nvarchar(16),
seccion				nvarchar(20),
proveedor			nvarchar(40),
cliente				nvarchar(40),
item				nvarchar(40),
version				nvarchar(10),
variante			nvarchar(10),
identificacion		nvarchar(100),
cantidad			real,
stockantes			real,
stockdespues		real,
umedida				nvarchar(6),
condicion			nvarchar(4),
precio				money,
codrel				nvarchar(6),
sucrel				smallint,
numrel				int,
letrel				nvarchar(20),
linrel				smallint,
codrechazo			nvarchar(30),
preciocalantes		money,
preciocaldespues	money,
importenencia		real,
genera				nvarchar(30),
fechasys			datetime,
consolidado			bit,
docproveedorsuc		smallint,
docproveedornum		nvarchar(40),
ordservicio			nvarchar(16),
programa			varchar(20),
numProcesado		tinyint)
END
SELECT @ToleranciaAjuste = ToleranciaAjuste FROM EmpresaCfg
SELECT @RedondeoMonetarios = dbo.fnRedondeoMonetarios()
DECLARE ArtAux_Cursor_1 CURSOR FOR
SELECT Articulo, SerieLote, Almacen, ExistenciaInte, ExistenciaMES, ABS(ROUND(ExistenciaInte, @RedondeoMonetarios) - ROUND(ExistenciaMES, @RedondeoMonetarios)) Direferncia
FROM ArtExistenciaIntMES
WHERE ROUND(ExistenciaInte, @RedondeoMonetarios) <> ROUND(ExistenciaMES, @RedondeoMonetarios)
AND ABS(ROUND(ExistenciaInte, @RedondeoMonetarios) - ROUND(ExistenciaMES, @RedondeoMonetarios)) >= @ToleranciaAjuste
AND	Articulo = ISNULL(@Articulo, Articulo) AND Almacen = ISNULL(@Almacen, Almacen) AND SerieLote = ISNULL(@SerieLote, SerieLote)
ORDER BY Direferncia DESC
OPEN ArtAux_Cursor_1
FETCH NEXT FROM ArtAux_Cursor_1
INTO @Articulo_C, @SerieLote_C, @Almacen_C, @ExistenciaInte_C, @ExistenciaMES_C, @Direferncia_C
WHILE @@FETCH_STATUS = 0
BEGIN
BEGIN 
INSERT	@IntelisisAux
SELECT	au.ID, au.Empresa, au.Cuenta, a.Descripcion1, a.Tipo, a.EsFactory, au.Grupo, au.Modulo, au.ModuloID, au.Mov, au.MovID, au.Renglon, au.Fecha,
'Renglon'= CASE
WHEN au.Modulo = 'VTAS' THEN v.Renglon
WHEN au.Modulo = 'COMS' THEN c.Renglon
WHEN au.Modulo = 'INV'  THEN i.Renglon
WHEN au.Modulo = 'PROD' THEN p.Renglon END,
'RenglonID'= CASE
WHEN au.Modulo = 'VTAS' THEN v.RenglonID
WHEN au.Modulo = 'COMS' THEN c.RenglonID
WHEN au.Modulo = 'INV'  THEN i.RenglonID
WHEN au.Modulo = 'PROD' THEN p.RenglonID END,
'Cantidad'= CASE
WHEN au.Modulo = 'VTAS' THEN v.Cantidad
WHEN au.Modulo = 'COMS' THEN c.Cantidad
WHEN au.Modulo = 'INV'  THEN i.Cantidad
WHEN au.Modulo = 'PROD' THEN p.Cantidad END,
'AlmOrigen'=CASE
WHEN au.Modulo = 'INV'  THEN (SELECT Almacen FROM Inv WHERE ID =i. ID) END,
'AlmDestino'=CASE
WHEN au .Modulo = 'INV' THEN (SELECT AlmacenDestino FROM Inv WHERE ID= i .ID) END,
au.CargoU, au.AbonoU, s.SerieLote, s.Cantidad, au.EsCancelacion, 1
FROM	AuxiliarU au		WITH(NoLock, INDEX(Cuenta))
JOIN	Art a				WITH(NoLock, INDEX(priArt))  ON au.Cuenta = a.Articulo
LEFT	JOIN Alm al			WITH(NoLock, INDEX(priAlm))  ON au.Grupo  = al.Almacen
LEFT	JOIN VentaD v		WITH(NoLock, INDEX(Detalle))		 ON au.Modulo = 'VTAS' AND au.ModuloID = v.ID AND au.Renglon = v.Renglon AND au.Cuenta = v.Articulo
LEFT	JOIN CompraD c		WITH(NoLock, INDEX(MatarPendiente))  ON au.Modulo = 'COMS' AND au.ModuloID = c.ID AND au.Renglon = c.Renglon AND au.Cuenta = c.Articulo
LEFT	JOIN InvD i			WITH(NoLock, INDEX(MatarPendiente))  ON au.Modulo = 'INV'  AND au.ModuloID = i.ID AND au.Renglon = i.Renglon AND au.Cuenta = i.Articulo
LEFT	JOIN ProdD p		WITH(NoLock, INDEX(MatarPendiente))  ON au.Modulo = 'PROD' AND au.ModuloID = p.ID AND au.Renglon = p.Renglon AND au.Cuenta = p.Articulo
LEFT	JOIN SerieLoteMov s	WITH(NOLOCK, INDEX(priSerieLoteMov)) ON au.ModuloID = s.ID AND s.Modulo = au.Modulo AND s.RenglonID = (
CASE
WHEN au.Modulo = 'VTAS' THEN v.RenglonID
WHEN au.Modulo = 'COMS' THEN c.RenglonID
WHEN au.Modulo = 'INV'  THEN i.RenglonID
WHEN au.Modulo = 'PROD' THEN p.RenglonID
END)
WHERE	au.Rama = 'INV' AND a.Tipo IN ('Serie', 'Lote') AND a.EsFactory = 1 AND al.EsFactory = 1 AND a.Articulo = @Articulo_C AND al.Almacen = @Almacen_C AND s.SerieLote = @SerieLote_C
ORDER	BY au.ID DESC
INSERT	@IntelisisAux
SELECT	ID, Empresa, Articulo, Descripcion1, Tipo, EsFactory, Almacen, Modulo, ModuloID, Mov, MovID, Renglon_AU, Fecha, Renglon, RenglonID, Cantidad, AlmOrigen, AlmDestino, CargoU, AbonoU, SerieLote, Cantidad_S, EsCancelacion, 2
FROM	@IntelisisAux
WHERE	numProcesado = 1
INSERT	@FactoryAux
SELECT	*, 1
FROM	qpfactorynv.dbo.logstock WHERE item = @Articulo_C AND version = '0' AND tipoubicacion = 'ALM' AND codigoubicacion = cast(@Almacen_C as char(5)) AND identificacion = REPLACE (@SerieLote_C, ')','''')
ORDER	BY id DESC
INSERT	@FactoryAux
SELECT	*, 2
FROM	qpfactorynv.dbo.logstock WHERE item = @Articulo_C AND version = '0' AND tipoubicacion = 'ALM' AND codigoubicacion = cast(@Almacen_C as char(5)) AND identificacion = REPLACE (@SerieLote_C, ')','''')
ORDER	BY id DESC
END 
BEGIN 
DECLARE IntelisisAux_Cursor_1 CURSOR FOR
SELECT	Fecha, Cantidad, Articulo, Almacen, SerieLote
FROM	@IntelisisAux
WHERE	numProcesado = 1
ORDER	BY IDRef
OPEN IntelisisAux_Cursor_1
FETCH NEXT FROM IntelisisAux_Cursor_1
INTO @Fecha_i1, @Cantidad_i1, @Articulo_i1, @Almacen_i1, @SerieLote_i1
WHILE @@FETCH_STATUS = 0
BEGIN
SET ROWCOUNT 1
DELETE
FROM	@FactoryAux
WHERE	numProcesado = 2 AND fecha = @Fecha_i1 AND cantnota = @Cantidad_i1 AND item = @Articulo_i1 AND codigoubicacion = cast(@Almacen_i1 as char(5)) AND identificacion = REPLACE (@SerieLote_i1, ')','''')
SET ROWCOUNT 0
FETCH NEXT FROM IntelisisAux_Cursor_1
INTO @Fecha_i1, @Cantidad_i1, @Articulo_i1, @Almacen_i1, @SerieLote_i1
END
CLOSE IntelisisAux_Cursor_1
DEALLOCATE IntelisisAux_Cursor_1
END 
SELECT @Fecha_i1 = NULL, @Cantidad_i1 = NULL, @Articulo_i1 = NULL, @Almacen_i1 = NULL, @SerieLote_i1 = NULL
BEGIN 
DECLARE FactoryAux_Cursor_1 CURSOR FOR
SELECT	fecha, cantnota, item, codigoubicacion, identificacion
FROM	@FactoryAux
WHERE	numProcesado = 1
ORDER	BY IDRef
BEGIN 
OPEN FactoryAux_Cursor_1
FETCH NEXT FROM FactoryAux_Cursor_1
INTO @Fecha_i1, @Cantidad_i1, @Articulo_i1, @Almacen_i1, @SerieLote_i1
WHILE @@FETCH_STATUS = 0
BEGIN
SET ROWCOUNT 1
DELETE
FROM	@IntelisisAux
WHERE	numProcesado = 2 AND Fecha = @Fecha_i1 AND Cantidad = @Cantidad_i1 AND Articulo = @Articulo_i1 AND cast(Almacen as char(5)) = @Almacen_i1 AND REPLACE (SerieLote, ')','''') = @SerieLote_i1
SET ROWCOUNT 0
FETCH NEXT FROM FactoryAux_Cursor_1
INTO @Fecha_i1, @Cantidad_i1, @Articulo_i1, @Almacen_i1, @SerieLote_i1
END
CLOSE FactoryAux_Cursor_1
DEALLOCATE FactoryAux_Cursor_1
END 
INSERT	dbo.IntelisisResultadoAux
SELECT	IDRef, 'Intelisis',	Fecha,	Almacen,			Articulo,	SerieLote,		Cantidad,	ModuloID,	Mov,		MovID
FROM	@IntelisisAux
WHERE	numProcesado = 2
INSERT	dbo.IntelisisResultadoAux
SELECT	IDRef, 'Infor',		fecha,	codigoubicacion,	item,		identificacion,	cantnota,	id,			Concepto,	cast(numnota as varchar(20))
FROM	@FactoryAux
WHERE	numProcesado = 2
FETCH NEXT FROM ArtAux_Cursor_1
INTO @Articulo_C, @SerieLote_C, @Almacen_C, @ExistenciaInte_C, @ExistenciaMES_C, @Direferncia_C
INSERT	@IntelisisRes
SELECT	*
FROM	@IntelisisAux
WHERE	numProcesado = 2
INSERT	@FactoryRes
SELECT	*
FROM	@FactoryAux
WHERE	numProcesado = 2
DELETE	@IntelisisAux
DELETE	@FactoryAux
END 
END
CLOSE ArtAux_Cursor_1
DEALLOCATE ArtAux_Cursor_1
SELECT 'ArtExistenciaIntMES' Sistema, Articulo, SerieLote, Almacen, ExistenciaInte, ExistenciaMES, ABS(ROUND(ExistenciaInte, @RedondeoMonetarios) - ROUND(ExistenciaMES, @RedondeoMonetarios)) Direferncia
FROM ArtExistenciaIntMES
WHERE ROUND(ExistenciaInte, @RedondeoMonetarios) <> ROUND(ExistenciaMES, @RedondeoMonetarios)
AND ABS(ROUND(ExistenciaInte, @RedondeoMonetarios) - ROUND(ExistenciaMES, @RedondeoMonetarios)) >= @ToleranciaAjuste
AND	Articulo = ISNULL(@Articulo, Articulo) AND Almacen = ISNULL(@Almacen, Almacen) AND SerieLote = ISNULL(@SerieLote, SerieLote)
SELECT	'IntelisisResultadoAux' Sistema, *
FROM	dbo.IntelisisResultadoAux
WHERE	Articulo = ISNULL(@Articulo, Articulo) AND Almacen = ISNULL(@Almacen, Almacen) AND SerieLote = ISNULL(@SerieLote, SerieLote)
IF @Detalle = 1
BEGIN
SELECT	'Intelisis' Sistema, *
FROM	@IntelisisRes
SELECT	'Infor' Sistema, *
FROM	@FactoryRes
END
SET NOCOUNT OFF
END

