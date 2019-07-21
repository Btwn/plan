SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAsignarSucursalEstatusRelacionadas
@ID		int,
@Modulo		char(5),
@Sucursal	int

AS BEGIN
IF @Modulo = 'CONT'  UPDATE ContD       SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  UPDATE VentaD      SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  UPDATE ProdD       SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'INV'   UPDATE InvD        SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  UPDATE CompraD     SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   UPDATE CxcD        SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   UPDATE CxpD        SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' UPDATE AgentD      SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   UPDATE GastoD      SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   UPDATE DineroD     SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'AF'    UPDATE ActivoFijoD SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'PC'    UPDATE PCD         SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  UPDATE OfertaD     SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  UPDATE ValeD       SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CR'
BEGIN
UPDATE CRVenta  SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE CRAgente SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE CRCobro  SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE CRCaja   SET Sucursal = @Sucursal WHERE ID = @ID
END ELSE
IF @Modulo = 'NOM'   UPDATE NominaD       SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'RH'    UPDATE RHD           SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  UPDATE AsisteD       SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   UPDATE EmbarqueD     SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   UPDATE CambioD       SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   UPDATE CapitalD      SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'INC'   UPDATE IncidenciaD   SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  UPDATE ConciliacionD SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  UPDATE PresupD 	    SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   UPDATE TMAD          SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   UPDATE RSSD          SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   UPDATE CampanaD      SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   UPDATE FiscalD       SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   UPDATE FormaExtraD   SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  UPDATE CapturaD      SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'GES'
BEGIN
UPDATE GestionPara    SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE GestionRecurso SET Sucursal = @Sucursal WHERE ID = @ID
END ELSE
IF @Modulo = 'CP'
BEGIN
UPDATE CPD   SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE CPCal SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE CPEsp SET Sucursal = @Sucursal WHERE ID = @ID
END ELSE
IF @Modulo = 'PCP'  UPDATE PCPD      SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'PROY'
BEGIN
UPDATE ProyectoDia	    SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE ProyectoD	    SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE ProyectoDRecurso SET Sucursal = @Sucursal WHERE ID = @ID
END ELSE
IF @Modulo = 'ST'    UPDATE SoporteD      SET Sucursal = @Sucursal WHERE ID = @ID
IF @Modulo = 'VTAS'
BEGIN
UPDATE ServicioAccesorios SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE ServicioTarea      SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE VentaCobro         SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE VentaDLogPicos     SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE VentaOrigen        SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE VentaOtros         SET Sucursal = @Sucursal WHERE ID = @ID
END ELSE
IF @Modulo = 'COMS'
BEGIN
UPDATE CompraGastoDiverso  SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE CompraGastoDiversoD SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE CompraDProrrateo    SET Sucursal = @Sucursal WHERE ID = @ID
END ELSE
IF @Modulo = 'INV'
BEGIN
UPDATE InvGastoDiverso  SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE InvGastoDiversoD SET Sucursal = @Sucursal WHERE ID = @ID
END ELSE
IF @Modulo = 'GAS'
BEGIN
UPDATE GastoDProrrateo SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE GastoAplica     SET Sucursal = @Sucursal WHERE ID = @ID
END ELSE
IF @Modulo = 'ORG'   UPDATE OrganizaD SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'RE'
BEGIN
UPDATE ReclutaD			SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE ReclutaPlaza			SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE ReclutaCometenciaTipo	SET Sucursal = @Sucursal WHERE ID = @ID
END ELSE
IF @Modulo = 'ISL'   UPDATE ISLD	SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CXC' UPDATE CxcAplicaDif SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CXP' UPDATE CxpAplicaDif SET Sucursal = @Sucursal WHERE ID = @ID
RETURN
END

