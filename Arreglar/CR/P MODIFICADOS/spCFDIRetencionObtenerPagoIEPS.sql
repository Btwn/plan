SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionObtenerPagoIEPS
@Empresa		varchar(5),
@FechaD			datetime,
@FechaA			datetime,
@Proveedor      varchar(10)

AS
BEGIN
DECLARE @MovRetencion			varchar(20),
@MovGastoDiverso  varchar(20),
@ID					      int,
@IDAnt				    int,
@Aplica				    varchar(20),
@AplicaAnt			  varchar(20),
@AplicaID				  varchar(20),
@AplicaIDAnt			varchar(20),
@IDAplica				  int,
@OrigenModulo			varchar(5),
@OrigenModuloID		int,
@OMov					    varchar(20),
@OMovID				    varchar(20),
@MovTipo				  varchar(20),
@Mov					    varchar(20),
@MovID				    varchar(20),
@Directo          bit
SELECT @MovRetencion = CxpRetencion, @MovGastoDiverso = CxpGastoDiverso FROM EmpresaCfgMov WITH (NOLOCK) WHERE Empresa = @Empresa
CREATE TABLE #Cheques(
ID			int,
Empresa	varchar(5)  COLLATE DATABASE_DEFAULT,
Mov			varchar(20) COLLATE DATABASE_DEFAULT,
MovID		varchar(20) COLLATE DATABASE_DEFAULT,
MovTipo	varchar(20) COLLATE DATABASE_DEFAULT,
Directo bit NULL
)
CREATE TABLE #Aplica(
ID				    int,
OID				    int,
AplicaModulo  varchar(20) COLLATE DATABASE_DEFAULT NULL,
Aplica			  varchar(20) COLLATE DATABASE_DEFAULT NULL,
AplicaID		  varchar(20) COLLATE DATABASE_DEFAULT NULL,
OMov			    varchar(20) COLLATE DATABASE_DEFAULT,
OMovID			  varchar(20) COLLATE DATABASE_DEFAULT,
)
INSERT INTO #Cheques(ID,   Empresa,   Mov,   MovID,    MovTipo, Directo) 
SELECT d.ID, d.Empresa, d.Mov, d.MovID, mt.Clave, d.Directo 
FROM Dinero d WITH (NOLOCK)
JOIN MovTipo mt WITH (NOLOCK) ON mt.Modulo = 'DIN' AND mt.Mov = d.Mov
WHERE d.Empresa =  @Empresa
AND d.Estatus IN('CONCLUIDO', 'CONCILIADO')
AND mt.Clave IN('DIN.CH', 'DIN.CHE', 'DIN.E')
AND d.FechaEmision BETWEEN @FechaD AND @FechaA
AND d.Contacto = @Proveedor AND d.ContactoTipo = 'Proveedor'
AND ISNULL(d.CFDRetencionTimbrado, 0) = 0
SELECT @IDAnt = 0
WHILE(1=1)
BEGIN
SELECT @ID = MIN(ID)
FROM #Cheques
WHERE ID > @IDAnt
IF @ID IS NULL BREAK
SELECT @IDAnt = @ID
SELECT @MovTipo = NULL, @Mov = NULL, @MovID = NULL, @Directo=NULL 
SELECT @MovTipo = MovTipo, @Mov = Mov, @MovID = MovID, @Directo=Directo FROM #Cheques WHERE ID = @IDAnt
IF @Directo=0
BEGIN
SELECT @AplicaAnt = ''
WHILE(1=1)
BEGIN
SELECT @Aplica = MIN(Aplica)
FROM DineroD WITH (NOLOCK)
WHERE ID = @ID
AND Aplica > @AplicaAnt
IF @Aplica IS NULL BREAK
SELECT @AplicaAnt = @Aplica
SELECT @AplicaIDAnt = ''
WHILE(1=1)
BEGIN
SELECT @AplicaID = MIN(AplicaID)
FROM DineroD WITH (NOLOCK)
WHERE ID = @ID
AND Aplica = @Aplica
AND AplicaID > @AplicaIDAnt
IF @AplicaID IS NULL BREAK
SELECT @AplicaIDAnt = @AplicaID
SELECT @IDAplica = NULL
SELECT @IDAplica = OID FROM MovFlujo WITH (NOLOCK) WHERE OModulo = 'DIN' AND DModulo = 'DIN' AND DID = @ID AND OMov = @Aplica AND OMovID = @AplicaID
EXEC spMovPos @@SPID, 'DIN', @IDAplica
IF NOT EXISTS(SELECT DMov FROM MovPos WITH (NOLOCK) WHERE Estacion = @@SPID AND Tipo = 'ORIGEN' AND DModulo = 'CXP' AND DMov IN(@MovRetencion, @MovGastoDiverso))
BEGIN
SELECT @OrigenModulo = NULL, @OrigenModuloID = NULL
SELECT @OrigenModulo = OrigenModulo, @OrigenModuloID = OrigenModuloID FROM MovImpuesto WITH (NOLOCK) WHERE Modulo = 'DIN' AND ModuloID = @IDAplica
IF @OrigenModulo IN('COMS', 'GAS')
BEGIN
IF @OrigenModulo = 'COMS'
BEGIN
IF EXISTS(
SELECT d.Impuesto2Total
FROM CompraTCalc d WITH (NOLOCK)
JOIN Art WITH (NOLOCK) ON d.Articulo = Art.Articulo
WHERE d.ID = @OrigenModuloID
AND Art.CFDIRetIEPSImpuesto = 'Impuesto 2'
AND NULLIF(Impuesto2Total, 0) IS NOT NULL
UNION ALL
SELECT d.Impuesto3Total
FROM CompraTCalc d WITH (NOLOCK)
JOIN Art WITH (NOLOCK) ON d.Articulo = Art.Articulo
WHERE d.ID = @OrigenModuloID
AND Art.CFDIRetIEPSImpuesto = 'Impuesto 3'
AND NULLIF(Impuesto3Total, 0) IS NOT NULL
)
BEGIN
SELECT @OMov = NULL, @OMovID = NULL
SELECT @OMov = Mov, @OMovID = MovID FROM Compra WITH (NOLOCK) WHERE ID = @OrigenModuloID
INSERT INTO #Aplica(
ID,  OID,             OMov,  OMovID,  AplicaModulo,  Aplica,  AplicaID)
SELECT @ID, @OrigenModuloID, @OMov, @OMovID, @OrigenModulo, @Aplica, @AplicaID
END
ELSE
DELETE #Cheques WHERE ID = @ID
END
IF @OrigenModulo = 'GAS'
BEGIN
IF EXISTS(
SELECT d.Impuestos2
FROM GastoD d WITH (NOLOCK)
WHERE d.ID = @OrigenModuloID
AND NULLIF(Impuestos2, 0) IS NOT NULL
)
BEGIN
SELECT @OMov = NULL, @OMovID = NULL
SELECT @OMov = Mov, @OMovID = MovID FROM Gasto WITH (NOLOCK) WHERE ID = @OrigenModuloID
INSERT INTO #Aplica(
ID,  OID,             OMov,  OMovID,  AplicaModulo,  Aplica,  AplicaID)
SELECT @ID, @OrigenModuloID, @OMov, @OMovID, @OrigenModulo, @Aplica, @AplicaID
END
ELSE
DELETE #Cheques WHERE ID = @ID
END
END
END
END
END
END
ELSE
BEGIN
EXEC spMovPos @@SPID, 'DIN', @ID
IF NOT EXISTS(SELECT DMov FROM MovPos WITH (NOLOCK) WHERE Estacion = @@SPID AND Tipo = 'ORIGEN' AND DModulo = 'CXP' AND DMov IN(@MovRetencion, @MovGastoDiverso))
BEGIN
SELECT @OrigenModulo = NULL, @OrigenModuloID = NULL
SELECT @OrigenModulo = OrigenModulo, @OrigenModuloID = OrigenModuloID FROM MovImpuesto WITH (NOLOCK) WHERE Modulo = 'DIN' AND ModuloID = @ID
IF @OrigenModulo IN('COMS', 'GAS')
BEGIN
IF @OrigenModulo = 'COMS'
BEGIN
IF EXISTS(
SELECT d.Impuesto2Total
FROM CompraTCalc d WITH (NOLOCK)
JOIN Art WITH (NOLOCK) ON d.Articulo = Art.Articulo
WHERE d.ID = @OrigenModuloID
AND Art.CFDIRetIEPSImpuesto = 'Impuesto 2'
AND NULLIF(Impuesto2Total, 0) IS NOT NULL
UNION ALL
SELECT d.Impuesto3Total
FROM CompraTCalc d WITH (NOLOCK)
JOIN Art WITH (NOLOCK) ON d.Articulo = Art.Articulo
WHERE d.ID = @OrigenModuloID
AND Art.CFDIRetIEPSImpuesto = 'Impuesto 3'
AND NULLIF(Impuesto3Total, 0) IS NOT NULL
)
BEGIN
SELECT @OMov = NULL, @OMovID = NULL
SELECT @OMov = Mov, @OMovID = MovID FROM Compra WITH (NOLOCK) WHERE ID = @OrigenModuloID
INSERT INTO #Aplica(
ID,  OID,             OMov,  OMovID,  AplicaModulo,  Aplica,  AplicaID)
SELECT @ID, @OrigenModuloID, @OMov, @OMovID, @OrigenModulo, @Mov,    @MovID
END
ELSE
DELETE #Cheques WHERE ID = @ID
END
IF @OrigenModulo = 'GAS'
BEGIN
IF EXISTS(
SELECT d.Impuestos2
FROM GastoD d WITH (NOLOCK)
WHERE d.ID = @OrigenModuloID
AND NULLIF(Impuestos2, 0) IS NOT NULL
)
BEGIN
SELECT @OMov = NULL, @OMovID = NULL
SELECT @OMov = Mov, @OMovID = MovID FROM Gasto WITH (NOLOCK) WHERE ID = @OrigenModuloID
INSERT INTO #Aplica(
ID,  OID,             OMov,  OMovID,  AplicaModulo,  Aplica,  AplicaID)
SELECT @ID, @OrigenModuloID, @OMov, @OMovID, @OrigenModulo, @Mov,    @MovID
END
ELSE
DELETE #Cheques WHERE ID = @ID
END
END
END
END
END
INSERT INTO #Pagos(
Modulo,  ID,   Empresa,   Mov,   MovID,   Ejercicio,   Periodo,   FechaEmision,    AplicaModulo,    AplicaModuloID,   Aplica,   AplicaID,     Importe,                TipoCambio,   Dinero,   DineroID,   FechaConciliacion,   DineroMov,   DineroMovID, EsIEPS)
SELECT 'DIN',  d.ID, d.Empresa, d.Mov, d.MovID, d.Ejercicio, d.Periodo, d.FechaEmision, dd.AplicaModulo, dd.OID,           dd.OMov,  dd.OMovID,   did.Importe*d.TipoCambio, d.TipoCambio, d.Mov,    d.MovID,    d.FechaConciliacion, d.Mov,       d.MovID,       1
FROM Dinero d WITH (NOLOCK)
JOIN DineroD did WITH (NOLOCK) ON d.ID = did.ID
JOIN #Cheques c ON d.ID = c.ID
JOIN #Aplica dd ON d.ID = dd.id 
JOIN MovTipo mt WITH (NOLOCK) ON mt.Modulo = 'DIN' AND mt.Mov = d.Mov
WHERE d.Empresa =  @Empresa
AND d.Estatus IN('CONCLUIDO', 'CONCILIADO')
AND ISNULL(did.Aplica,'1') = (CASE WHEN c.Directo=1 then '1' ELSE dd.Aplica END) 
AND ISNULL(did.AplicaID,'1') = (CASE WHEN c.Directo=1 then '1' ELSE dd.AplicaID END) 
AND d.FechaEmision BETWEEN @FechaD AND @FechaA
RETURN
END

