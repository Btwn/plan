SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIntelisisFueraLinea
@Datos	varchar(max)

AS BEGIN
DECLARE
@Modulo	varchar(5),
@ModuloID	int,
@GenerarID	int,
@GenerarIDSt	varchar(20),
@Contenido	varchar(100),
@iDatos	int,
@Resultado	varchar(max),
@MovID	varchar(20),
@Estatus	varchar(15),
@Ok		int,
@OkRef	varchar(255)
SET CONCAT_NULL_YIELDS_NULL ON
SELECT @ModuloID = NULL, @Ok = NULL, @OkRef = NULL, @Resultado = NULL
SELECT @Datos = NULLIF(RTRIM(@Datos),'')
IF @Datos IS NOT NULL
BEGIN
EXEC sp_xml_preparedocument @iDatos OUTPUT, @Datos
SELECT @Contenido = Contenido
FROM OPENXML (@iDatos, '/Intelisis',1)
WITH (Contenido varchar(255))
IF @Contenido = 'FueraLinea'
BEGIN
SELECT @Modulo = Modulo, @ModuloID = ModuloID, @MovID = MovID
FROM OPENXML (@iDatos, '/Intelisis/FueraLinea',1)
WITH (Modulo varchar(5), ModuloID int, MovID varchar(20))
IF @Modulo = 'COMS'
BEGIN
SELECT @Estatus = NULL
SELECT @Estatus = Estatus FROM Compra WITH(NOLOCK) WHERE OrigenTipo = 'FR' AND Origen = @Modulo AND OrigenID = @MovID
IF @Estatus IN ('BORRADOR', 'SINAFECTAR')
BEGIN
EXEC spEliminarMov @Modulo, @ModuloID
SELECT @Estatus = NULL
END
IF @Estatus IS NULL
BEGIN
EXEC spTablaInsertarDesdeXML 'Compra',		@iDatos, '/Intelisis/FueraLinea/Compra'			SELECT @GenerarID = SCOPE_IDENTITY() SELECT @GenerarIDSt = CONVERT(varchar(20), @GenerarID)
EXEC spTablaInsertarDesdeXML 'CompraD',		@iDatos, '/Intelisis/FueraLinea/CompraD',		'ID', @GenerarIDSt
EXEC spTablaInsertarDesdeXML 'CompraCB',		@iDatos, '/Intelisis/FueraLinea/CompraCB',		'ID', @GenerarIDSt
EXEC spTablaInsertarDesdeXML 'CompraGastoDiverso',	@iDatos, '/Intelisis/FueraLinea/CompraGastoDiverso',	'ID', @GenerarIDSt
EXEC spTablaInsertarDesdeXML 'CompraGastoDiversoD',	@iDatos, '/Intelisis/FueraLinea/CompraGastoDiversoD',	'ID', @GenerarIDSt
EXEC spTablaInsertarDesdeXML 'CompraDPresupuestoEsp',	@iDatos, '/Intelisis/FueraLinea/CompraDPresupuestoEsp',	'ID', @GenerarIDSt
EXEC spTablaInsertarDesdeXML 'CompraDProrrateo',	@iDatos, '/Intelisis/FueraLinea/CompraDProrrateo',	'ID', @GenerarIDSt
EXEC spTablaInsertarDesdeXML 'CompraImportacion',	@iDatos, '/Intelisis/FueraLinea/CompraImportacion',	'ID', @GenerarIDSt
EXEC spTablaInsertarDesdeXML 'SerieLoteMov',		@iDatos, '/Intelisis/FueraLinea/SerieLoteMov',		'ID', @GenerarIDSt
EXEC xpIntelisisFueraLineaRecibirOtros @Modulo, @GenerarIDSt, @iDatos, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
UPDATE Compra  WITH(ROWLOCK) SET OrigenTipo = 'FR', Origen = @Modulo, OrigenID = @MovID, MovID = NULL, Estatus = 'BORRADOR' WHERE ID = @GenerarID
EXEC spAfectar @Modulo, @GenerarID, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
END
END
IF @Modulo = 'INV'
BEGIN
SELECT @Estatus = NULL
SELECT @Estatus = Estatus FROM Inv WITH(NOLOCK) WHERE OrigenTipo = 'FR' AND Origen = @Modulo AND OrigenID = @MovID
IF @Estatus IN ('BORRADOR', 'SINAFECTAR')
BEGIN
EXEC spEliminarMov @Modulo, @ModuloID
SELECT @Estatus = NULL
END
IF @Estatus IS NULL
BEGIN
EXEC spTablaInsertarDesdeXML 'Inv',			@iDatos, '/Intelisis/FueraLinea/Inv'			SELECT @GenerarID = SCOPE_IDENTITY() SELECT @GenerarIDSt = CONVERT(varchar(20), @GenerarID)
EXEC spTablaInsertarDesdeXML 'InvD',			@iDatos, '/Intelisis/FueraLinea/InvD',			'ID', @GenerarIDSt
EXEC spTablaInsertarDesdeXML 'InvGastoDiverso',	@iDatos, '/Intelisis/FueraLinea/InvGastoDiverso',	'ID', @GenerarIDSt
EXEC spTablaInsertarDesdeXML 'InvGastoDiversoD',	@iDatos, '/Intelisis/FueraLinea/InvGastoDiversoD',	'ID', @GenerarIDSt
EXEC spTablaInsertarDesdeXML 'SerieLoteMov',		@iDatos, '/Intelisis/FueraLinea/SerieLoteMov',		'ID', @GenerarIDSt
EXEC xpIntelisisFueraLineaRecibirOtros @Modulo, @GenerarIDSt, @iDatos, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
UPDATE Inv  WITH(ROWLOCK) SET OrigenTipo = 'FR', Origen = @Modulo, OrigenID = @MovID, MovID = NULL, Estatus = 'BORRADOR' WHERE ID = @GenerarID
EXEC spAfectar @Modulo, @GenerarID, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
END
END
IF @Modulo = 'VTAS'
BEGIN
SELECT @Estatus = NULL
SELECT @Estatus = Estatus FROM Venta WITH(NOLOCK) WHERE OrigenTipo = 'FR' AND Origen = @Modulo AND OrigenID = @MovID
IF @Estatus IN ('BORRADOR', 'SINAFECTAR')
BEGIN
EXEC spEliminarMov @Modulo, @ModuloID
SELECT @Estatus = NULL
END
IF @Estatus IS NULL
BEGIN
EXEC spTablaInsertarDesdeXML 'Venta',			@iDatos, '/Intelisis/FueraLinea/Venta'			SELECT @GenerarID = SCOPE_IDENTITY() SELECT @GenerarIDSt = CONVERT(varchar(20), @GenerarID)
EXEC spTablaInsertarDesdeXML 'VentaD',		@iDatos, '/Intelisis/FueraLinea/VentaD',		'ID', @GenerarIDSt
EXEC spTablaInsertarDesdeXML 'VentaDAgente',		@iDatos, '/Intelisis/FueraLinea/VentaDAgente',		'ID', @GenerarIDSt
EXEC spTablaInsertarDesdeXML 'VentaCobro',		@iDatos, '/Intelisis/FueraLinea/VentaCobro',		'ID', @GenerarIDSt
EXEC spTablaInsertarDesdeXML 'VentaCobroD',		@iDatos, '/Intelisis/FueraLinea/VentaCobroD',		'ID', @GenerarIDSt
EXEC spTablaInsertarDesdeXML 'VentaEntrega',		@iDatos, '/Intelisis/FueraLinea/VentaEntrega',		'ID', @GenerarIDSt
EXEC spTablaInsertarDesdeXML 'VentaFacturaAnticipo',	@iDatos, '/Intelisis/FueraLinea/VentaFacturaAnticipo',  'ID', @GenerarIDSt
EXEC spTablaInsertarDesdeXML 'VentaOtros',		@iDatos, '/Intelisis/FueraLinea/VentaOtros',		'ID', @GenerarIDSt
EXEC spTablaInsertarDesdeXML 'SerieLoteMov',		@iDatos, '/Intelisis/FueraLinea/SerieLoteMov',		'ID', @GenerarIDSt
EXEC spTablaInsertarDesdeXML 'Cte',			@iDatos, '/Intelisis/FueraLinea/Cte',			'FueraLinea', '0'
EXEC spTablaInsertarDesdeXML 'CteCto',		@iDatos, '/Intelisis/FueraLinea/CteCto',		'FueraLinea', '0'
EXEC spTablaInsertarDesdeXML 'CteEnviarA',		@iDatos, '/Intelisis/FueraLinea/CteEnviarA',		'FueraLinea', '0'
EXEC spTablaInsertarDesdeXML 'Agente',		@iDatos, '/Intelisis/FueraLinea/Agente',		'FueraLinea', '0'
EXEC spTablaInsertarDesdeXML 'AgenteCte',		@iDatos, '/Intelisis/FueraLinea/AgenteCte',		'FueraLinea', '0'
EXEC xpIntelisisFueraLineaRecibirOtros @Modulo, @GenerarIDSt, @iDatos, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
UPDATE Venta  WITH(ROWLOCK) SET OrigenTipo = 'FR', Origen = @Modulo, OrigenID = @MovID, MovID = NULL, Estatus = 'BORRADOR' WHERE ID = @GenerarID
EXEC spAfectar @Modulo, @GenerarID, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
END
END
IF @Modulo IS NOT NULL
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252" ?>'+
'<Intelisis'+
dbo.fnXML('Contenido', 'FueraLineaProcesado')+
'>'+
'<FueraLineaProcesado'+
dbo.fnXML('Modulo', @Modulo)+
dbo.fnXMLInt('ModuloID', @ModuloID)+
dbo.fnXMLInt('GenerarID', @GenerarID)+
dbo.fnXMLInt('Ok', @Ok)+
dbo.fnXML('OkRef', @OKRef)+
'></FueraLineaProcesado></Intelisis>'
END ELSE
IF @Contenido = 'FueraLineaProcesado'
BEGIN
SELECT @Modulo = Modulo, @ModuloID = ModuloID, @Ok = NULLIF(Ok, 0), @OkRef = OkRef
FROM OPENXML (@iDatos, '/Intelisis/FueraLineaProcesado',1)
WITH (Modulo varchar(5), ModuloID int, Ok int, OkRef varchar(255))
IF @Ok BETWEEN 80030 AND 81000 SELECT @Ok = NULL
IF @Modulo = 'VTAS'  UPDATE Venta WITH(ROWLOCK) SET Estatus = 'ENLINEA' WHERE ID = @ModuloID
IF @Modulo = 'COMS' UPDATE Compra  WITH(ROWLOCK) SET Estatus = 'ENLINEA' WHERE ID = @ModuloID
IF @Modulo = 'INV'   UPDATE Inv WITH(ROWLOCK) SET Estatus = 'ENLINEA' WHERE ID = @ModuloID
UPDATE Cte	 WITH(ROWLOCK) SET FueraLinea = 0 WHERE FueraLinea = 1
UPDATE CteCto	 WITH(ROWLOCK) SET FueraLinea = 0 WHERE FueraLinea = 1
UPDATE CteEnviarA	 WITH(ROWLOCK) SET FueraLinea = 0 WHERE FueraLinea = 1
UPDATE Agente	 WITH(ROWLOCK) SET FueraLinea = 0 WHERE FueraLinea = 1
UPDATE AgenteCte	 WITH(ROWLOCK) SET FueraLinea = 0 WHERE FueraLinea = 1
SELECT @Datos = NULL
END
EXEC sp_xml_removedocument @iDatos
END
IF @Datos IS NULL
BEGIN
UPDATE Version  WITH(ROWLOCK) SET FueraLinea = 0
SELECT @ModuloID = NULL, @Modulo = NULL
IF @ModuloID IS NULL
SELECT @ModuloID = MIN(ID) FROM Compra WITH (NOLOCK) WHERE Estatus = 'FUERALINEA'
IF @ModuloID IS NOT NULL AND @Modulo IS NULL
BEGIN
SELECT @Modulo = 'COMS'
SELECT @MovID = MovID
FROM Compra
WITH(NOLOCK) WHERE ID = @ModuloID
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?>'+
'<Intelisis'+
dbo.fnXML('Contenido', 'FueraLinea')+
'>'+
'<FueraLinea'+
dbo.fnXML('Modulo', @Modulo)+
dbo.fnXMLInt('ModuloID', @ModuloID)+
dbo.fnXML('MovID', @MovID)+
'>'
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM Compra              WITH (NOLOCK)  WHERE ID = @ModuloID FOR XML RAW('Compra')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM CompraD             WITH (NOLOCK)  WHERE ID = @ModuloID FOR XML RAW('CompraD')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM CompraCB		 WITH (NOLOCK)  WHERE ID = @ModuloID FOR XML RAW('CompraCB')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM CompraGastoDiverso   WITH (NOLOCK) WHERE ID = @ModuloID FOR XML RAW('CompraGastoDiverso')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM CompraGastoDiversoD  WITH (NOLOCK) WHERE ID = @ModuloID FOR XML RAW('CompraGastoDiversoD')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM CompraDPresupuestoEsp WITH (NOLOCK) WHERE ID = @ModuloID FOR XML RAW('CompraDPresupuestoEsp')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM CompraDProrrateo     WITH (NOLOCK) WHERE ID = @ModuloID FOR XML RAW('CompraDProrrateo')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM CompraImportacion    WITH (NOLOCK) WHERE ID = @ModuloID FOR XML RAW('CompraImportacion')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM SerieLoteMov         WITH (NOLOCK) WHERE Modulo = @Modulo AND ID = @ModuloID FOR XML RAW('SerieLoteMov')), '')
EXEC xpIntelisisFueraLineaEnviarOtros @Modulo, @ModuloID, @Resultado OUTPUT
SELECT @Resultado = @Resultado + '</FueraLinea></Intelisis>'
END
IF @ModuloID IS NULL
SELECT @ModuloID = MIN(ID) FROM Inv WITH (NOLOCK)
WHERE Estatus = 'FUERALINEA'
IF @ModuloID IS NOT NULL AND @Modulo IS NULL
BEGIN
SELECT @Modulo = 'INV'
SELECT @MovID = MovID
FROM Inv
WITH(NOLOCK) WHERE ID = @ModuloID
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?>'+
'<Intelisis'+
dbo.fnXML('Contenido', 'FueraLinea')+
'>'+
'<FueraLinea'+
dbo.fnXML('Modulo', @Modulo)+
dbo.fnXMLInt('ModuloID', @ModuloID)+
dbo.fnXML('MovID', @MovID)+
'>'
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM Inv		 WITH (NOLOCK)  WHERE ID = @ModuloID FOR XML RAW('Inv')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM InvD		 WITH (NOLOCK)  WHERE ID = @ModuloID FOR XML RAW('InvD')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM InvGastoDiverso     WITH (NOLOCK)  WHERE ID = @ModuloID FOR XML RAW('InvGastoDiverso')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM InvGastoDiversoD    WITH (NOLOCK)  WHERE ID = @ModuloID FOR XML RAW('InvGastoDiversoD')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM SerieLoteMov        WITH (NOLOCK)  WHERE Modulo = @Modulo AND ID = @ModuloID FOR XML RAW('SerieLoteMov')), '')
EXEC xpIntelisisFueraLineaEnviarOtros @Modulo, @ModuloID, @Resultado OUTPUT
SELECT @Resultado = @Resultado + '</FueraLinea></Intelisis>'
END
IF @ModuloID IS NULL
SELECT @ModuloID = MIN(ID) FROM Venta WITH (NOLOCK) WHERE Estatus = 'FUERALINEA'
IF @ModuloID IS NOT NULL AND @Modulo IS NULL
BEGIN
SELECT @Modulo = 'VTAS'
SELECT @MovID = MovID
FROM Venta
WITH(NOLOCK) WHERE ID = @ModuloID
SELECT @Resultado = '<?xml version="1.0" encoding="windows-1252"?>'+
'<Intelisis'+
dbo.fnXML('Contenido', 'FueraLinea')+
'>'+
'<FueraLinea'+
dbo.fnXML('Modulo', @Modulo)+
dbo.fnXMLInt('ModuloID', @ModuloID)+
dbo.fnXML('MovID', @MovID)+
'>'
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM Venta              WITH (NOLOCK)  WHERE ID = @ModuloID FOR XML RAW('Venta')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM VentaD             WITH (NOLOCK)  WHERE ID = @ModuloID FOR XML RAW('VentaD')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM VentaDAgente       WITH (NOLOCK)  WHERE ID = @ModuloID FOR XML RAW('VentaDAgente')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM VentaCobro         WITH (NOLOCK)  WHERE ID = @ModuloID FOR XML RAW('VentaCobro')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM VentaCobroD        WITH (NOLOCK)  WHERE ID = @ModuloID FOR XML RAW('VentaCobroD')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM VentaEntrega         WITH (NOLOCK) WHERE ID = @ModuloID FOR XML RAW('VentaEntrega')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM VentaFacturaAnticipo WITH (NOLOCK) WHERE ID = @ModuloID FOR XML RAW('VentaFacturaAnticipo')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM VentaOtros          WITH (NOLOCK) WHERE ID = @ModuloID FOR XML RAW('VentaOtros')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM SerieLoteMov        WITH (NOLOCK) WHERE Modulo = @Modulo AND ID = @ModuloID FOR XML RAW('SerieLoteMov')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM Cte	         WITH (NOLOCK) WHERE FueraLinea = 1 FOR XML RAW('Cte')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM CteCto	       WITH (NOLOCK)   WHERE FueraLinea = 1 FOR XML RAW('CteCto')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM CteEnviarA	        WITH (NOLOCK)  WHERE FueraLinea = 1 FOR XML RAW('CteEnviarA')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM Agente	         WITH (NOLOCK) WHERE FueraLinea = 1 FOR XML RAW('Agente')), '')
SELECT @Resultado = @Resultado + ISNULL((SELECT * FROM AgenteCte	         WITH (NOLOCK) WHERE FueraLinea = 1 FOR XML RAW('AgenteCte')), '')
EXEC xpIntelisisFueraLineaEnviarOtros @Modulo, @ModuloID, @Resultado OUTPUT
SELECT @Resultado = @Resultado + '</FueraLinea></Intelisis>'
END
END
SELECT 'Resultado' = @Resultado
SET CONCAT_NULL_YIELDS_NULL OFF
RETURN
END

