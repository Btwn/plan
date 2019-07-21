SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sppNetFlujoViaticos
@ID			int,
@showCONT	bit

AS BEGIN
SET NOCOUNT ON
CREATE TABLE #preMovFlujo(
Indx		 int identity,
Sucursal	 int,
Empresa		 varchar(5),
OModulo		 varchar(5),
OID			 int,
OMov		 varchar(20),
OMovID		 varchar(20),
DModulo		 char(5),
DID			 int,
DMov		 varchar(20),
DMovID		 varchar(20),
Cancelado	 bit,
dateInsert	 datetime,
statusInsert int)
IF EXISTS (SELECT * FROM MovFlujo WHERE OID = @ID AND OModulo = 'GAS' AND Cancelado = 0)
BEGIN
INSERT INTO #preMovFlujo
SELECT Sucursal, Empresa, 'GAS' OModulo, 0 OID, '' OMov, '' OMovID, OModulo DModulo, OID DID, OMov DMov, OMovID DMovID, 0 Cancelado, DATEADD(SS, -1, GETDATE()) dateInsert, 0 statusInsert
FROM MovFlujo
WHERE OID = @ID AND OModulo = 'GAS'
INSERT INTO #preMovFlujo
SELECT *, GETDATE() dateInsert, 1 statusInsert
FROM MovFlujo
WHERE OID = @ID AND OModulo = 'GAS'
END
DECLARE @OID int, @OMov varchar(20), @OMovID varchar(20)
DECLARE @DID int, @DMov varchar(20), @DMovID varchar(20)
WHILE EXISTS (SELECT * FROM #preMovFlujo WHERE statusInsert = 1)
BEGIN
DECLARE flujo_cursor CURSOR FOR
SELECT OID, OMov, OMovID, DID, DMov, DMovID FROM #preMovFlujo WHERE statusInsert = 1
OPEN flujo_cursor
FETCH NEXT FROM flujo_cursor INTO @OID, @OMov, @OMovID, @DID, @DMov, @DMovID
WHILE @@FETCH_STATUS = 0
BEGIN
UPDATE #preMovFlujo SET statusInsert = 0
WHERE OID = @OID AND OMov = @OMov AND OMovID = @OMovID AND DID = @DID AND DMov = @DMov AND DMovID = @DMovID
INSERT INTO #preMovFlujo
SELECT *, GETDATE() dateInsert, 1 statusInsert
FROM MovFlujo
WHERE OID = @DID AND OMov = @DMov AND OMovID = @DMovID
FETCH NEXT FROM flujo_cursor INTO @OID, @OMov, @OMovID, @DID, @DMov, @DMovID
END
CLOSE flujo_cursor
DEALLOCATE flujo_cursor
END
CREATE TABLE #HeaderV (
Indx		 int identity,
Modulo		 char(5),
ID			 int,
Movimiento	 varchar(50),
ConceptoGral varchar(255),
FechaEmision datetime,
Importe		 money,
Estatus		varchar(15),
xmlFiles	int,
nFiles		int)
CREATE TABLE #DetailGasto (
Modulo		 char(5),
ID			 int,
Renglon		 float,
Acreedor	 varchar(255),
Concepto	 varchar(255),
Importe		 money,
Referencia	 varchar(50),
Comprobante	 bit)
IF (@showCONT = 1)
BEGIN
CREATE TABLE #DetailCont (
Modulo		 char(5),
ID			 int,
Renglon		 float,
Cuenta		 varchar(20),
Descripcion	 varchar(100),
Concepto	 varchar(50),
Debe		 money,
Haber		 money)
END
CREATE TABLE #DetailDinero (
Modulo		 char(5),
ID			 int,
Renglon		 float,
Aplica		 varchar(50),
FormaPago	 varchar(50),
Importe		 money,
Referencia	 varchar(50))
DECLARE @FModulo char(5), @FID int, @FMov varchar(20), @FMovID varchar(20)
DECLARE dflujo_cursor CURSOR FOR
SELECT DModulo, DID, DMov, DMovID FROM #preMovFlujo ORDER BY Indx, dateInsert
OPEN dflujo_cursor
FETCH NEXT FROM dflujo_cursor INTO @FModulo, @FID, @FMov, @FMovID
WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE @hasFiles int, @hasXMLFiles int
IF (RTRIM(@FModulo) = 'GAS')
BEGIN
SELECT @hasXMLFiles =	SUM(CAST(CAST(ISNULL(LEN(Direccion), 0)  as bit) as int)) FROM AnexoMov WHERE Rama = @FModulo AND ID = @FID AND RIGHT(Direccion, 4)  = '.xml'
SELECT @hasFiles =		SUM(CAST(CAST(ISNULL(LEN(Direccion), 0)  as bit) as int)) FROM AnexoMov WHERE Rama = @FModulo AND ID = @FID AND RIGHT(Direccion, 4) <> '.xml'
INSERT INTO #HeaderV
SELECT @FModulo Modulo, Gasto.ID, Gasto.Mov + ISNULL(' ' + Gasto.MovID, '') Movimiento, Prov.Tipo + ISNULL(' : ' + Prov.Proveedor, '') + ISNULL(' - ' + Prov.Nombre, '') ConceptoGral,
Gasto.FechaEmision, Gasto.Importe - Gasto.Retencion + Gasto.Impuestos Importe, Gasto.Estatus, ISNULL(@hasXMLFiles, 0) xmlFiles, ISNULL(@hasFiles, 0) nFiles
FROM Gasto JOIN Prov ON Gasto.Acreedor=Prov.Proveedor
WHERE Gasto.ID = @FID
INSERT INTO #DetailGasto
SELECT @FModulo Modulo, GastoD.ID, GastoD.Renglon, ISNULL(Acreedor.Proveedor + ISNULL(' - ' + Acreedor.Nombre, ''), '') Acreedor, GastoD.Concepto, 
GastoD.Importe + GastoD.Impuestos + GastoD.Impuestos2 + GastoD.Impuestos3 - GastoD.Retencion - GastoD.Retencion2 - GastoD.Retencion3 Importe,
ISNULL(GastoD.Referencia, '') Referencia, GastoD.Comprobante
FROM GastoD LEFT OUTER JOIN Prov Acreedor ON GastoD.AcreedorRef=Acreedor.Proveedor
WHERE GastoD.ID = @FID ORDER BY GastoD.Renglon, GastoD.RenglonSub
END
IF (@showCONT = 1)
BEGIN
IF (RTRIM(@FModulo) = 'CONT')
BEGIN
SELECT @hasXMLFiles =	SUM(CAST(CAST(ISNULL(LEN(Direccion), 0)  as bit) as int)) FROM AnexoMov WHERE Rama = @FModulo AND ID = @FID AND RIGHT(Direccion, 4)  = '.xml'
SELECT @hasFiles =		SUM(CAST(CAST(ISNULL(LEN(Direccion), 0)  as bit) as int)) FROM AnexoMov WHERE Rama = @FModulo AND ID = @FID AND RIGHT(Direccion, 4) <> '.xml'
INSERT INTO #HeaderV
SELECT @FModulo Modulo, Cont.ID, Cont.Mov + ISNULL(' ' + Cont.MovID, '') Movimiento, ISNULL(Cont.Concepto, Cont.Referencia) ConceptoGral, Cont.FechaEmision,
Cont.Importe, Cont.Estatus, ISNULL(@hasXMLFiles, 0) xmlFiles, ISNULL(@hasFiles, 0) nFiles 
FROM Cont
WHERE Cont.ID = @FID
INSERT INTO #DetailCont
SELECT @FModulo Modulo, ContD.ID, ContD.Renglon, ContD.Cuenta, Cta.Descripcion, ISNULL(ContD.Concepto, '') Concepto, ContD.Debe, ContD.Haber
FROM ContD
LEFT OUTER JOIN Cta ON ContD.Cuenta=Cta.Cuenta
WHERE ContD.ID = @FID AND ISNULL(ContD.Presupuesto, 0)=0 ORDER BY ContD.Renglon, ContD.RenglonSub
END
END
IF (RTRIM(@FModulo) = 'DIN')
BEGIN
SELECT @hasXMLFiles =	SUM(CAST(CAST(ISNULL(LEN(Direccion), 0)  as bit) as int)) FROM AnexoMov WHERE Rama = @FModulo AND ID = @FID AND RIGHT(Direccion, 4)  = '.xml'
SELECT @hasFiles =		SUM(CAST(CAST(ISNULL(LEN(Direccion), 0)  as bit) as int)) FROM AnexoMov WHERE Rama = @FModulo AND ID = @FID AND RIGHT(Direccion, 4) <> '.xml'
INSERT INTO #HeaderV
SELECT @FModulo Modulo, Dinero.ID, Dinero.Mov + ISNULL(' ' + Dinero.MovID, '') Movimiento,
Dinero.ContactoTipo + ISNULL(' : ' + Dinero.Contacto + ISNULL(' - ' + Dinero.BeneficiarioNombre, ''), '') ConceptoGral,
Dinero.FechaEmision, Dinero.Importe + Dinero.Impuestos Importe, Dinero.Estatus, ISNULL(@hasXMLFiles, 0) xmlFiles, ISNULL(@hasFiles, 0) nFiles
FROM Dinero
WHERE Dinero.ID = @FID
INSERT INTO #DetailDinero
SELECT @FModulo Modulo, DineroD.ID, DineroD.Renglon, ISNULL(DineroD.Aplica + ISNULL(' ' + DineroD.AplicaID, ''), '') Aplica,
ISNULL(DineroD.FormaPago, '') FormaPago, DineroD.Importe, ISNULL(DineroD.Referencia, '') Referencia
FROM DineroD
WHERE DineroD.ID = @FID ORDER BY DineroD.Renglon, DineroD.RenglonSub
END
FETCH NEXT FROM dflujo_cursor INTO @FModulo, @FID, @FMov, @FMovID
END
CLOSE dflujo_cursor
DEALLOCATE dflujo_cursor
SELECT Indx, Modulo, ID, Movimiento, ConceptoGral, CONVERT(VARCHAR(10), FechaEmision, 105) FechaEmision, Importe, Estatus FROM #HeaderV ORDER BY Indx
SELECT * FROM #DetailGasto	ORDER BY ID, Renglon
SELECT * FROM #DetailDinero	ORDER BY ID, Renglon
IF (@showCONT = 1)
BEGIN
SELECT * FROM #DetailCont	ORDER BY ID, Renglon
DROP TABLE #DetailCont
END
DROP TABLE #DetailDinero
DROP TABLE #DetailGasto
DROP TABLE #HeaderV
DROP TABLE #preMovFlujo
SET NOCOUNT OFF
RETURN
END

