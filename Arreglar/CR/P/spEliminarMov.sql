SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEliminarMov
@Modulo		char(5),
@ID		int

AS BEGIN
DECLARE
@MovID	varchar(20),
@Estatus	char(15)
SELECT @MovID = NULL, @Estatus = NULL
IF @Modulo = 'CONT'  SELECT @MovID = MovID, @Estatus = Estatus FROM Cont  	   WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  SELECT @MovID = MovID, @Estatus = Estatus FROM Venta        WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  SELECT @MovID = MovID, @Estatus = Estatus FROM Prod         WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  SELECT @MovID = MovID, @Estatus = Estatus FROM Compra       WHERE ID = @ID ELSE
IF @Modulo = 'INV'   SELECT @MovID = MovID, @Estatus = Estatus FROM Inv          WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   SELECT @MovID = MovID, @Estatus = Estatus FROM Cxc          WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   SELECT @MovID = MovID, @Estatus = Estatus FROM Cxp          WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' SELECT @MovID = MovID, @Estatus = Estatus FROM Agent        WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   SELECT @MovID = MovID, @Estatus = Estatus FROM Gasto        WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   SELECT @MovID = MovID, @Estatus = Estatus FROM Dinero       WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   SELECT @MovID = MovID, @Estatus = Estatus FROM Embarque     WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   SELECT @MovID = MovID, @Estatus = Estatus FROM Nomina       WHERE ID = @ID ELSE
IF @Modulo = 'RH'    SELECT @MovID = MovID, @Estatus = Estatus FROM RH      	   WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  SELECT @MovID = MovID, @Estatus = Estatus FROM Asiste       WHERE ID = @ID ELSE
IF @Modulo = 'AF'    SELECT @MovID = MovID, @Estatus = Estatus FROM ActivoFijo   WHERE ID = @ID ELSE
IF @Modulo = 'PC'    SELECT @MovID = MovID, @Estatus = Estatus FROM PC           WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  SELECT @MovID = MovID, @Estatus = Estatus FROM Oferta       WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  SELECT @MovID = MovID, @Estatus = Estatus FROM Vale         WHERE ID = @ID ELSE
IF @Modulo = 'CR'    SELECT @MovID = MovID, @Estatus = Estatus FROM CR           WHERE ID = @ID ELSE
IF @Modulo = 'ST'    SELECT @MovID = MovID, @Estatus = Estatus FROM Soporte      WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   SELECT @MovID = MovID, @Estatus = Estatus FROM Capital      WHERE ID = @ID ELSE
IF @Modulo = 'INC'   SELECT @MovID = MovID, @Estatus = Estatus FROM Incidencia   WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  SELECT @MovID = MovID, @Estatus = Estatus FROM Conciliacion WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  SELECT @MovID = MovID, @Estatus = Estatus FROM Presup       WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' SELECT @MovID = MovID, @Estatus = Estatus FROM Credito	   WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   SELECT @MovID = MovID, @Estatus = Estatus FROM TMA          WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   SELECT @MovID = MovID, @Estatus = Estatus FROM RSS          WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   SELECT @MovID = MovID, @Estatus = Estatus FROM Campana      WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   SELECT @MovID = MovID, @Estatus = Estatus FROM Fiscal       WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' SELECT @MovID = MovID, @Estatus = Estatus FROM ContParalela WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' SELECT @MovID = MovID, @Estatus = Estatus FROM Oportunidad  WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' SELECT @MovID = MovID, @Estatus = Estatus FROM Corte        WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   SELECT @MovID = MovID, @Estatus = Estatus FROM FormaExtra   WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  SELECT @MovID = MovID, @Estatus = Estatus FROM Captura      WHERE ID = @ID ELSE
IF @Modulo = 'GES'   SELECT @MovID = MovID, @Estatus = Estatus FROM Gestion      WHERE ID = @ID ELSE
IF @Modulo = 'CP'    SELECT @MovID = MovID, @Estatus = Estatus FROM CP           WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   SELECT @MovID = MovID, @Estatus = Estatus FROM PCP          WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  SELECT @MovID = MovID, @Estatus = Estatus FROM Proyecto     WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   SELECT @MovID = MovID, @Estatus = Estatus FROM Organiza     WHERE ID = @ID ELSE
IF @Modulo = 'RE'    SELECT @MovID = MovID, @Estatus = Estatus FROM Recluta      WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   SELECT @MovID = MovID, @Estatus = Estatus FROM ISL          WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   SELECT @MovID = MovID, @Estatus = Estatus FROM Cambio       WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' SELECT @MovID = MovID, @Estatus = Estatus FROM Contrato     WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  SELECT @MovID = MovID, @Estatus = Estatus FROM SAUX         WHERE ID = @ID
IF @MovID IS NOT NULL OR @Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') RETURN 0
IF @Modulo = 'CONT'  DELETE Cont         WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  DELETE Venta        WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  DELETE Prod         WHERE ID = @ID ELSE
IF @Modulo = 'INV'   DELETE Inv          WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  DELETE Compra       WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   DELETE Cxc          WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   DELETE Cxp          WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' DELETE Agent        WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   DELETE Gasto        WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   DELETE Dinero       WHERE ID = @ID ELSE
IF @Modulo = 'AF'    DELETE ActivoFijo   WHERE ID = @ID ELSE
IF @Modulo = 'PC'    DELETE PC           WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  DELETE Oferta       WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  DELETE Vale         WHERE ID = @ID ELSE
IF @Modulo = 'CR'    DELETE CR           WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   DELETE Nomina       WHERE ID = @ID ELSE
IF @Modulo = 'RH'    DELETE RH           WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  DELETE Asiste       WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   DELETE Embarque     WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   DELETE Cambio       WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' DELETE Contrato     WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   DELETE Capital      WHERE ID = @ID ELSE
IF @Modulo = 'INC'   DELETE Incidencia   WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  DELETE Conciliacion WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  DELETE Presup       WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' DELETE Credito	   WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   DELETE TMA          WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   DELETE RSS          WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   DELETE Campana      WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   DELETE Fiscal       WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' DELETE ContParalela WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' DELETE Oportunidad  WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' DELETE Corte        WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   DELETE FormaExtra   WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  DELETE Captura      WHERE ID = @ID ELSE
IF @Modulo = 'GES'   DELETE Gestion      WHERE ID = @ID ELSE
IF @Modulo = 'CP'    DELETE CP           WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   DELETE PCP          WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  DELETE Proyecto     WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   DELETE Organiza     WHERE ID = @ID ELSE
IF @Modulo = 'RE'    DELETE Recluta      WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   DELETE ISL          WHERE ID = @ID ELSE
IF @Modulo = 'ST'    DELETE Soporte      WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  DELETE SAUX         WHERE ID = @ID
IF @Modulo = 'CONT'
BEGIN
DELETE ContD   WHERE ID = @ID
DELETE ContReg WHERE ID = @ID
END ELSE
IF @Modulo = 'VTAS'  DELETE VentaD      WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  DELETE ProdD       WHERE ID = @ID ELSE
IF @Modulo = 'INV'   DELETE InvD        WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  DELETE CompraD     WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   DELETE CxcD        WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   DELETE CxpD        WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' DELETE AgentD      WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   DELETE GastoD      WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   DELETE DineroD     WHERE ID = @ID ELSE
IF @Modulo = 'AF'    DELETE ActivoFijoD WHERE ID = @ID ELSE
IF @Modulo = 'PC'    DELETE PCD         WHERE ID = @ID ELSE
IF @Modulo = 'OFER'
BEGIN
DELETE OfertaFiltro WHERE ID = @ID
DELETE OfertaD      WHERE ID = @ID
DELETE OfertaDVol   WHERE ID = @ID
END ELSE
IF @Modulo = 'VALE'  DELETE ValeD       WHERE ID = @ID ELSE
IF @Modulo = 'CR'
BEGIN
DELETE CRVenta  WHERE ID = @ID
DELETE CRAgente WHERE ID = @ID
DELETE CRCobro  WHERE ID = @ID
DELETE CRVenta  WHERE ID = @ID
END ELSE
IF @Modulo = 'NOM'   DELETE NominaD       WHERE ID = @ID ELSE
IF @Modulo = 'RH'    DELETE RHD           WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  DELETE AsisteD       WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   DELETE EmbarqueD     WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   DELETE CambioD       WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   DELETE CapitalD      WHERE ID = @ID ELSE
IF @Modulo = 'INC'   DELETE IncidenciaD   WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  DELETE ConciliacionD WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  DELETE PresupD       WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   DELETE TMAD          WHERE ID = @ID ELSE
IF @Modulo = 'CMP'
BEGIN
DELETE CampanaD            WHERE ID = @ID
DELETE CampanaEncuesta     WHERE ID = @ID
DELETE CampanaEvento       WHERE ID = @ID
DELETE CampanaCorreo       WHERE ID = @ID
DELETE CampanaTarea        WHERE ID = @ID
DELETE CampanaCfgCorreo    WHERE ID = @ID
DELETE CampanaCfgSituacion WHERE ID = @ID
END ELSE
IF @Modulo = 'FIS'   DELETE FiscalD       WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' DELETE ContParalelaD WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' DELETE OportunidadD        WHERE ID = @ID ELSE
IF @Modulo = 'CORTE'
BEGIN
DELETE CorteD			WHERE ID = @ID
DELETE CorteDReporte    WHERE ID = @ID
END ELSE
IF @Modulo = 'FRM'   DELETE FormaExtraD WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  DELETE CapturaD    WHERE ID = @ID ELSE
IF @Modulo = 'GES'
BEGIN
DELETE GestionPara    WHERE ID = @ID
DELETE GestionRecurso WHERE ID = @ID
END ELSE
IF @Modulo = 'CP'
BEGIN
DELETE CPD    WHERE ID = @ID
DELETE CPCal  WHERE ID = @ID
DELETE CPEsp  WHERE ID = @ID
END ELSE
IF @Modulo = 'PCP'
BEGIN
DELETE PCPD WHERE ID = @ID
DELETE PCPDRegla WHERE ID = @ID
END ELSE
IF @Modulo = 'PROY'
BEGIN
DELETE ProyectDia       WHERE ID = @ID
DELETE ProyectD         WHERE ID = @ID
DELETE ProyectoDRecurso WHERE ID = @ID
END ELSE
IF @Modulo = 'ST'    DELETE SoporteD    WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  DELETE SAUXD       WHERE ID = @ID
IF @Modulo = 'VTAS'
BEGIN
DELETE VentaDAgente       WHERE ID = @ID
DELETE ServicioAccesorios WHERE ID = @ID
DELETE ServicioTarea      WHERE ID = @ID
DELETE VentaCobro         WHERE ID = @ID
DELETE VentaCobroD        WHERE ID = @ID
DELETE VentaDLogPicos     WHERE ID = @ID
DELETE VentaOrigen        WHERE ID = @ID
DELETE VentaOtros         WHERE ID = @ID
DELETE VentaEntrega       WHERE ID = @ID
END ELSE
IF @Modulo = 'COMS'
BEGIN
DELETE CompraGastoDiverso  WHERE ID = @ID
DELETE CompraGastoDiversoD WHERE ID = @ID
DELETE CompraDProrrateo    WHERE ID = @ID
END ELSE
IF @Modulo = 'INV'
BEGIN
DELETE InvGastoDiverso  WHERE ID = @ID
DELETE InvGastoDiversoD WHERE ID = @ID
END ELSE
IF @Modulo = 'GAS'
BEGIN
DELETE GastoDProrrateo WHERE ID = @ID
DELETE GastoAplica     WHERE ID = @ID
END ELSE
IF @Modulo = 'ORG' DELETE OrganizaD    WHERE ID = @ID ELSE
IF @Modulo = 'RE'
BEGIN
DELETE ReclutaD			WHERE ID = @ID
DELETE ReclutaPlaza			WHERE ID = @ID
DELETE ReclutaCompetenciaTipo	WHERE ID = @ID
END ELSE
IF @Modulo = 'ISL' DELETE ISLD	 WHERE ID = @ID ELSE
IF @Modulo = 'CXC' DELETE CxcAplicaDif WHERE ID = @ID ELSE
IF @Modulo = 'CXP' DELETE CxpAplicaDif WHERE ID = @ID
RETURN 1
END

