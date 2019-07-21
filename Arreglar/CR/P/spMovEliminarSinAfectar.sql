SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovEliminarSinAfectar
@Modulo	char(5),
@ID		int

AS BEGIN
BEGIN TRANSACTION
IF @Modulo = 'CONT'  DELETE Cont         WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'VTAS'  DELETE Venta        WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'PROD'  DELETE Prod         WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'COMS'  DELETE Compra       WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'INV'   DELETE Inv          WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CXC'   DELETE Cxc          WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CXP'   DELETE Cxp          WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'AGENT' DELETE Agent        WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'GAS'   DELETE Gasto        WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'DIN'   DELETE Dinero       WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'EMB'   DELETE Embarque     WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'NOM'   DELETE Nomina       WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'RH'    DELETE RH           WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'ASIS'  DELETE Asiste       WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'AF'    DELETE ActivoFijo   WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'PC'    DELETE PC           WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'OFER'  DELETE Oferta       WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'VALE'  DELETE Vale         WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CR'    DELETE CR           WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'ST'    DELETE Soporte      WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CAP'   DELETE Capital      WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'INC'   DELETE Incidencia   WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CONC'  DELETE Conciliacion WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'PPTO'  DELETE Presup       WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CREDI' DELETE Credito	   WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'TMA'   DELETE TMA          WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'RSS'   DELETE RSS          WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CMP'   DELETE Campana      WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'FIS'   DELETE Fiscal       WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CONTP' DELETE ContParalela WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'OPORT' DELETE Oportunidad  WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CORTE' DELETE Corte        WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'FRM'   DELETE FormaExtra   WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CAPT'  DELETE Captura      WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'GES'   DELETE Gestion      WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CP'    DELETE CP           WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'PCP'   DELETE PCP          WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'PROY'  DELETE Proyecto     WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'ORG'   DELETE Organiza     WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'RE'    DELETE Recluta      WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'ISL'   DELETE ISL          WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'CAM'   DELETE Cambio       WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'PACTO' DELETE Contrato     WHERE ID = @ID AND Estatus = 'SINAFECTAR' ELSE
IF @Modulo = 'SAUX'  DELETE SAUX         WHERE ID = @ID AND Estatus = 'SINAFECTAR'
IF @@ROWCOUNT <> 0
BEGIN
IF @Modulo = 'CONT'
BEGIN
DELETE ContD   WHERE ID = @ID
DELETE ContReg WHERE ID = @ID
END ELSE
IF @Modulo = 'VTAS'  DELETE VentaD      WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  DELETE ProdD       WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  DELETE CompraD     WHERE ID = @ID ELSE
IF @Modulo = 'INV'   DELETE InvD        WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   DELETE CxcD        WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   DELETE CxpD        WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' DELETE AgentD      WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   DELETE GastoD      WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   DELETE DineroD     WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   DELETE EmbarqueD   WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   DELETE NominaD     WHERE ID = @ID ELSE
IF @Modulo = 'RH'    DELETE RHD         WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  DELETE AsisteD     WHERE ID = @ID ELSE
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
DELETE CRCaja   WHERE ID = @ID
END ELSE
IF @Modulo = 'ST'    DELETE SoporteD      WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   DELETE CapitalD      WHERE ID = @ID ELSE
IF @Modulo = 'INC'   DELETE IncidenciaD   WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  DELETE ConciliacionD WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  DELETE PresupD       WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   DELETE TMAD          WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   DELETE CampanaD      WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   DELETE FiscalD       WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' DELETE ContParalelaD WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' DELETE OportunidadD          WHERE ID = @ID ELSE
IF @Modulo = 'CORTE'
BEGIN
DELETE CorteD        WHERE ID = @ID
DELETE CorteDReporte WHERE ID = @ID
END ELSE
IF @Modulo = 'FRM'   DELETE FormaExtraD   WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  DELETE CapturaD      WHERE ID = @ID ELSE
IF @Modulo = 'GES'
BEGIN
DELETE GestionPara    WHERE ID = @ID
DELETE GestionRecurso WHERE ID = @ID
END ELSE
IF @Modulo = 'CP'
BEGIN
DELETE CPD   WHERE ID = @ID
DELETE CPCal WHERE ID = @ID
DELETE CPEsp WHERE ID = @ID
END ELSE
IF @Modulo = 'PCP'
BEGIN
DELETE PCPD WHERE ID = @ID
DELETE PCPDRegla WHERE ID = @ID
END ELSE
/*    IF @Modulo = 'PROY'
BEGIN
DELETE ProyectoAct
FROM Fase t
JOIN ProyectoAct a ON a.FaseID = t.FaseID
WHERE t.ProyectoID = @ID AND t.Estatus = 'SINAFECTAR'
DELETE ProyectoTarea WHERE ProyectoID = @ID AND Estatus = 'SINAFECTAR'
DELETE Fase     WHERE ID = @ID
END ELSE*/
IF @Modulo = 'ORG'   DELETE OrganizaD   WHERE ID = @ID ELSE
IF @Modulo = 'RE'
BEGIN
DELETE ReclutaD			WHERE ID = @ID
DELETE ReclutaPlaza		WHERE ID = @ID
DELETE ReclutaCompetenciaTipo	WHERE ID = @ID
END ELSE
IF @Modulo = 'ISL'   DELETE ISLD        WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   DELETE CambioD     WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  DELETE SAUXD       WHERE ID = @ID
COMMIT TRANSACTION
END ELSE
ROLLBACK TRANSACTION
END

