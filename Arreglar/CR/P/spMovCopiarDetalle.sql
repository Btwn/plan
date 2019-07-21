SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovCopiarDetalle
@Sucursal	int,
@Modulo		char(5),
@OID        	int,
@DID		int,
@Usuario	char(10) = NULL,
@Base		varchar(20) = NULL,
@GenerarMov	varchar(20) = NULL,
@GenerarMovID	varchar(20) = NULL

AS BEGIN
DECLARE @GenerarMovTipo	varchar(20)
SELECT @GenerarMovTipo = Clave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @GenerarMov
IF @Modulo = 'CONT'
BEGIN
SELECT * INTO #ContD FROM cContD WHERE ID = @OID
UPDATE #ContD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cContD SELECT * FROM #ContD
END ELSE
IF @Modulo = 'CXC'
BEGIN
SELECT * INTO #CxcD FROM cCxcD WHERE ID = @OID AND LigadoDR = 0 AND UPPER(Aplica) NOT IN ('REDONDEO', 'SALDO A FAVOR', 'EFECTIVO A FAVOR')
UPDATE #CxcD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID, Ligado = 0
INSERT INTO cCxcD SELECT * FROM #CxcD
END ELSE
IF @Modulo = 'CXP'
BEGIN
SELECT * INTO #CxpD FROM cCxpD WHERE ID = @OID AND LigadoDR = 0 AND UPPER(Aplica) NOT IN ('REDONDEO', 'SALDO A FAVOR', 'EFECTIVO A FAVOR')
UPDATE #CxpD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID, Ligado = 0
INSERT INTO cCxpD SELECT * FROM #CxpD
END ELSE
IF @Modulo = 'AGENT'
BEGIN
SELECT * INTO #AgentD FROM cAgentD WHERE ID = @OID
UPDATE #AgentD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cAgentD SELECT * FROM #AgentD
END ELSE
IF @Modulo = 'GAS'
BEGIN
SELECT * INTO #GastoD FROM cGastoD WHERE ID = @OID
UPDATE #GastoD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cGastoD SELECT * FROM #GastoD
END ELSE
IF @Modulo = 'DIN'
BEGIN
SELECT * INTO #DineroD FROM cDineroD WHERE ID = @OID
UPDATE #DineroD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cDineroD SELECT * FROM #DineroD
END ELSE
IF @Modulo = 'EMB'
BEGIN
SELECT * INTO #EmbarqueD FROM cEmbarqueD WHERE ID = @OID
UPDATE #EmbarqueD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cEmbarqueD SELECT * FROM #EmbarqueD
END ELSE
IF @Modulo = 'NOM'
BEGIN
SELECT * INTO #NominaD FROM cNominaD WHERE ID = @OID
UPDATE #NominaD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cNominaD SELECT * FROM #NominaD
END ELSE
IF @Modulo = 'RH'
BEGIN
SELECT * INTO #RHD FROM cRHD WHERE ID = @OID
UPDATE #RHD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cRHD SELECT * FROM #RHD
END ELSE
IF @Modulo = 'ASIS'
BEGIN
SELECT * INTO #AsisteD FROM cAsisteD WHERE ID = @OID
UPDATE #AsisteD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cAsisteD SELECT * FROM #AsisteD
END ELSE
IF @Modulo = 'AF'
BEGIN
SELECT * INTO #ActivoFijoD FROM cActivoFijoD WHERE ID = @OID
UPDATE #ActivoFijoD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cActivoFijoD SELECT * FROM #ActivoFijoD
END ELSE
IF @Modulo = 'PC'
BEGIN
SELECT * INTO #PCD FROM cPCD WHERE ID = @OID
UPDATE #PCD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cPCD SELECT * FROM #PCD
END ELSE
IF @Modulo = 'OFER'
BEGIN
SELECT * INTO #OfertaD FROM cOfertaD WHERE ID = @OID
UPDATE #OfertaD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cOfertaD SELECT * FROM #OfertaD
INSERT OfertaDVol (
ID,   Articulo, Desde, Hasta, Cantidad, Porcentaje, Precio, Importe, Sucursal, ListaPrecios)
SELECT @DID, Articulo, Desde, Hasta, Cantidad, Porcentaje, Precio, Importe, Sucursal, ListaPrecios
FROM OfertaDVol
WHERE ID = @OID
END ELSE
IF @Modulo = 'VALE'
BEGIN
SELECT * INTO #ValeD FROM cValeD WHERE ID = @OID
UPDATE #ValeD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cValeD SELECT * FROM #ValeD
END ELSE
IF @Modulo = 'CR'
BEGIN
SELECT * INTO #CRVenta FROM cCRVenta WHERE ID = @OID
UPDATE #CRVenta SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cCRVenta SELECT * FROM #CRVenta
SELECT * INTO #CRAgente FROM cCRAgente WHERE ID = @OID
UPDATE #CRAgente SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cCRAgente SELECT * FROM #CRAgente
SELECT * INTO #CRCobro FROM cCRCobro WHERE ID = @OID
UPDATE #CRCobro SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cCRCobro SELECT * FROM #CRCobro
SELECT * INTO #CRCaja FROM cCRCaja WHERE ID = @OID
UPDATE #CRCaja SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cCRCaja SELECT * FROM #CRCaja
SELECT * INTO #CRSoporte FROM cCRSoporte WHERE ID = @OID
UPDATE #CRSoporte SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cCRSoporte SELECT * FROM #CRSoporte
SELECT * INTO #CRInvFisico FROM cCRInvFisico WHERE ID = @OID
UPDATE #CRInvFisico SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cCRInvFisico SELECT * FROM #CRInvFisico
SELECT * INTO #CRTrans FROM cCRTrans WHERE ID = @OID
UPDATE #CRTrans SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cCRTrans SELECT * FROM #CRTrans
END ELSE
IF @Modulo = 'CAP'
BEGIN
SELECT * INTO #CapitalD FROM cCapitalD WHERE ID = @OID
UPDATE #CapitalD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cCapitalD SELECT * FROM #CapitalD
END ELSE
/*  IF @Modulo = 'INC'
BEGIN
SELECT * INTO #IncidenciaD FROM cIncidenciaD WHERE ID = @OID
UPDATE #IncidenciaD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cIncidenciaD SELECT * FROM #IncidenciaD
END ELSE*/
IF @Modulo = 'CONC'
BEGIN
SELECT * INTO #ConciliacionD FROM cConciliacionD WHERE ID = @OID
UPDATE #ConciliacionD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cConciliacionD SELECT * FROM #ConciliacionD
END ELSE
IF @Modulo = 'PPTO'
BEGIN
SELECT * INTO #PresupD FROM cPresupD WHERE ID = @OID
UPDATE #PresupD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cPresupD SELECT * FROM #PresupD
END ELSE
/*IF @Modulo = 'CREDI'
BEGIN
SELECT * INTO #CreditoD FROM cCreditoD WHERE ID = @OID
UPDATE #CreditoD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cCreditoD SELECT * FROM #CreditoD
END ELSE*/
IF @Modulo = 'TMA'
BEGIN
SELECT * INTO #TMAD FROM cTMAD WHERE ID = @OID
UPDATE #TMAD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cTMAD SELECT * FROM #TMAD
END ELSE
/*IF @Modulo = 'RSS'
BEGIN
SELECT * INTO #RSSD FROM cRSSD WHERE ID = @OID
UPDATE #RSSD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cRSSD SELECT * FROM #RSSD
END ELSE*/
IF @Modulo = 'CMP'
BEGIN
SELECT * INTO #CampanaD FROM cCampanaD WHERE ID = @OID
UPDATE #CampanaD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cCampanaD SELECT * FROM #CampanaD
END ELSE
IF @Modulo = 'FIS'
BEGIN
SELECT * INTO #FiscalD FROM cFiscalD WHERE ID = @OID
UPDATE #FiscalD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cFiscalD SELECT * FROM #FiscalD
END ELSE
IF @Modulo = 'CONTP'
BEGIN
SELECT * INTO #ContParalelaD FROM cContParalelaD WHERE ID = @OID
UPDATE #ContParalelaD SET ID = @DID
INSERT INTO cContParalelaD SELECT * FROM #ContParalelaD
END ELSE
IF @Modulo = 'OPORT'
BEGIN
SELECT * INTO #OportunidadInteresadoEn FROM cOportunidadInteresadoEn WHERE ID = @OID
UPDATE #OportunidadInteresadoEn SET ID = @DID
INSERT INTO cOportunidadInteresadoEn SELECT * FROM #OportunidadInteresadoEn
SELECT * INTO #CRMCompentencia FROM cOportunidadCompetencia WHERE ID = @OID
UPDATE #CRMCompentencia SET ID = @DID
INSERT INTO cOportunidadCompetencia SELECT * FROM #CRMCompentencia
IF ISNULL(@GenerarMovTipo, '') IN('OPORT.G')
BEGIN
SELECT * INTO #OportunidadD FROM cOportunidadD WHERE ID = @OID
UPDATE #OportunidadD SET ID = @DID
INSERT INTO cOportunidadD SELECT * FROM #OportunidadD
END
END ELSE
IF @Modulo = 'CORTE'
BEGIN
IF ISNULL(@GenerarMovTipo, '') = 'CORTE.REPEXTERNO'
BEGIN
SELECT * INTO #CorteDReporte FROM cCorteDReporte WHERE ID = @OID
UPDATE #CorteDReporte SET ID = @DID
INSERT INTO cCorteDReporte SELECT * FROM #CorteDReporte
END
IF ISNULL(@GenerarMovTipo, '') IN('CORTE.CORTEIMPORTE', 'CORTE.CORTECONTABLE', 'CORTE.CORTEUNIDADES', 'CORTE.CORTECX')
BEGIN
SELECT * INTO #CorteDConsulta FROM cCorteDConsulta WHERE ID = @OID
UPDATE #CorteDConsulta SET ID = @DID
INSERT INTO cCorteDConsulta SELECT * FROM #CorteDConsulta
END
END ELSE
IF @Modulo = 'FRM'
BEGIN
SELECT * INTO #FormaExtraD FROM cFormaExtraD WHERE ID = @OID
UPDATE #FormaExtraD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cFormaExtraD SELECT * FROM #FormaExtraD
END ELSE
IF @Modulo = 'CAPT'
BEGIN
SELECT * INTO #CapturaD FROM cCapturaD WHERE ID = @OID
UPDATE #CapturaD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cCapturaD SELECT * FROM #CapturaD
END ELSE
IF @Modulo = 'GES'
BEGIN
SELECT * INTO #GestionAgenda FROM cGestionAgenda WHERE ID = @OID
UPDATE #GestionAgenda SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cGestionAgenda SELECT * FROM #GestionAgenda
SELECT * INTO #GestionPara FROM cGestionPara WHERE ID = @OID
UPDATE #GestionPara SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cGestionPara SELECT * FROM #GestionPara
SELECT * INTO #GestionRecurso FROM cGestionRecurso WHERE ID = @OID
UPDATE #GestionRecurso SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cGestionRecurso SELECT * FROM #GestionRecurso
SELECT ID, Tipo, Indicador, Referencia, LecturaAnterior, Lectura INTO #GestionActivoFIndicador FROM GestionActivoFIndicador WHERE ID = @OID
UPDATE #GestionActivoFIndicador SET ID = @DID
INSERT INTO GestionActivoFIndicador (ID, Tipo, Indicador, Referencia, LecturaAnterior, Lectura) SELECT ID, Tipo, Indicador, Referencia, LecturaAnterior, Lectura
FROM #GestionActivoFIndicador
END ELSE
IF @Modulo = 'CP'
BEGIN
SELECT * INTO #CPD FROM cCPD WHERE ID = @OID
UPDATE #CPD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cCPD SELECT * FROM #CPD
SELECT * INTO #CPCal FROM cCPCal WHERE ID = @OID
UPDATE #CPCal SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cCPCal SELECT * FROM #CPCal
SELECT * INTO #CPArt FROM cCPArt WHERE ID = @OID
UPDATE #CPArt SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cCPArt SELECT * FROM #CPArt
END ELSE
IF @Modulo = 'PCP'
BEGIN
SELECT * INTO #PCPD FROM cPCPD WHERE ID = @OID
UPDATE #PCPD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cPCPD SELECT * FROM #PCPD
SELECT * INTO #PCPDRegla FROM cPCPDRegla WHERE ID = @OID
UPDATE #PCPDRegla SET ID = @DID
INSERT INTO cPCPDRegla SELECT * FROM #PCPDRegla
END ELSE
IF @Modulo = 'PROY'
BEGIN
SELECT * INTO #ProyectoD FROM cProyectoD WHERE ID = @OID
UPDATE #ProyectoD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
IF @GenerarMov IS NOT NULL UPDATE #ProyectoD  SET Avance = NULL, Estado = NULL
INSERT INTO cProyectoD SELECT * FROM #ProyectoD
END
/*ELSE
IF @Modulo = 'ACT'
BEGIN
SELECT * INTO #ActD FROM cActD WHERE ID = @OID
UPDATE #ActD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cActD SELECT * FROM #ActD
END*/
/*ELSEOfertaD
IF @Modulo = 'MEX01'
BEGIN
SELECT * INTO #ModuloExtra01D FROM cModuloExtra01D WHERE ID = @OID
UPDATE #ModuloExtra01D SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cModuloExtra01D SELECT * FROM #ModuloExtra01D
END*/
/*ELSE
IF @Modulo = 'MEX02'
BEGIN
SELECT * INTO #ModuloExtra02D FROM cModuloExtra02D WHERE ID = @OID
UPDATE #ModuloExtra02D SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cModuloExtra02D SELECT * FROM #ModuloExtra02D
END*/
/*ELSE
IF @Modulo = 'MEX03'
BEGIN
SELECT * INTO #ModuloExtra03D FROM cModuloExtra03D WHERE ID = @OID
UPDATE #ModuloExtra03D SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cModuloExtra03D SELECT * FROM #ModuloExtra03D
END*/
/*ELSE
IF @Modulo = 'MEX04'
BEGIN
SELECT * INTO #ModuloExtra04D FROM cModuloExtra04D WHERE ID = @OID
UPDATE #ModuloExtra04D SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cModuloExtra04D SELECT * FROM #ModuloExtra04D
END*/
/*ELSE
IF @Modulo = 'MEX05'
BEGIN
SELECT * INTO #ModuloExtra05D FROM cModuloExtra05D WHERE ID = @OID
UPDATE #ModuloExtra05D SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cModuloExtra05D SELECT * FROM #ModuloExtra05D
END*/
/*ELSE
IF @Modulo = 'MEX06'
BEGIN
SELECT * INTO #ModuloExtra06D FROM cModuloExtra01D WHERE ID = @OID
UPDATE #ModuloExtra06D SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cModuloExtra06D SELECT * FROM #ModuloExtra06D
END*/
/*ELSE
IF @Modulo = 'MEX07'
BEGIN
SELECT * INTO #ModuloExtra07D FROM cModuloExtra07D WHERE ID = @OID
UPDATE #ModuloExtra07D SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cModuloExtra07D SELECT * FROM #ModuloExtra07D
END*/
/*ELSE
IF @Modulo = 'MEX08'
BEGIN
SELECT * INTO #ModuloExtra08D FROM cModuloExtra08D WHERE ID = @OID
UPDATE #ModuloExtra08D SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cModuloExtra08D SELECT * FROM #ModuloExtra08D
END*/
/*ELSE
IF @Modulo = 'MEX09'
BEGIN
SELECT * INTO #ModuloExtra09D FROM cModuloExtra09D WHERE ID = @OID
UPDATE #ModuloExtra09D SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cModuloExtra09D SELECT * FROM #ModuloExtra09D
END*/
ELSE
IF @Modulo = 'ORG'
BEGIN
SELECT * INTO #OrganizaD FROM cOrganizaD WHERE ID = @OID
UPDATE #OrganizaD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cOrganizaD SELECT * FROM #OrganizaD
END
ELSE
IF @Modulo = 'RE'
BEGIN
SELECT * INTO #ReclutaD FROM cReclutaD WHERE ID = @OID
UPDATE #ReclutaD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cReclutaD SELECT * FROM #ReclutaD
SELECT * INTO #ReclutaPlaza FROM cReclutaPlaza WHERE ID = @OID
UPDATE #ReclutaPlaza SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cReclutaPlaza SELECT * FROM #ReclutaPlaza
SELECT * INTO #ReclutaCompetenciaTipo FROM cReclutaCompetenciaTipo WHERE ID = @OID
UPDATE #ReclutaCompetenciaTipo SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cReclutaCompetenciaTipo SELECT * FROM #ReclutaCompetenciaTipo
END
ELSE
IF @Modulo = 'ISL'
BEGIN
SELECT * INTO #ISLD FROM cISLD WHERE ID = @OID
UPDATE #ISLD SET Sucursal = @Sucursal, SucursalOrigen = @Sucursal, ID = @DID
INSERT INTO cISLD SELECT * FROM #ISLD
END
END

