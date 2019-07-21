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
IF @Modulo = 'CONT'  UPDATE ContD       WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  UPDATE VentaD      WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  UPDATE ProdD       WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'INV'   UPDATE InvD        WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  UPDATE CompraD     WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   UPDATE CxcD        WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   UPDATE CxpD        WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' UPDATE AgentD      WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   UPDATE GastoD      WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   UPDATE DineroD     WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'AF'    UPDATE ActivoFijoD WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'PC'    UPDATE PCD         WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  UPDATE OfertaD     WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  UPDATE ValeD       WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CR'
BEGIN
UPDATE CRVenta  WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE CRAgente WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE CRCobro  WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE CRCaja   WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
END ELSE
IF @Modulo = 'NOM'   UPDATE NominaD       WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'RH'    UPDATE RHD           WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  UPDATE AsisteD       WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   UPDATE EmbarqueD     WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   UPDATE CambioD       WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   UPDATE CapitalD      WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'INC'   UPDATE IncidenciaD   WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  UPDATE ConciliacionD WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  UPDATE PresupD 	    WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   UPDATE TMAD          WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   UPDATE RSSD          WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   UPDATE CampanaD      WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   UPDATE FiscalD       WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   UPDATE FormaExtraD   WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  UPDATE CapturaD      WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'GES'
BEGIN
UPDATE GestionPara    WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE GestionRecurso WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
END ELSE
IF @Modulo = 'CP'
BEGIN
UPDATE CPD   WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE CPCal WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE CPEsp SET Sucursal = @Sucursal WHERE ID = @ID
END ELSE
IF @Modulo = 'PCP'  UPDATE PCPD      WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'PROY'
BEGIN
UPDATE ProyectoDia	    WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE ProyectoD	    WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE ProyectoDRecurso WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
END ELSE
IF @Modulo = 'ST'    UPDATE SoporteD      WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
IF @Modulo = 'VTAS'
BEGIN
UPDATE ServicioAccesorios WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE ServicioTarea      WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE VentaCobro         WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE VentaDLogPicos     WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE VentaOrigen        WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE VentaOtros         WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
END ELSE
IF @Modulo = 'COMS'
BEGIN
UPDATE CompraGastoDiverso  WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE CompraGastoDiversoD WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE CompraDProrrateo    WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
END ELSE
IF @Modulo = 'INV'
BEGIN
UPDATE InvGastoDiverso  WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE InvGastoDiversoD WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
END ELSE
IF @Modulo = 'GAS'
BEGIN
UPDATE GastoDProrrateo WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE GastoAplica     WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
END ELSE
IF @Modulo = 'ORG'   UPDATE OrganizaD WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'RE'
BEGIN
UPDATE ReclutaD			WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE ReclutaPlaza			WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
UPDATE ReclutaCometenciaTipo	SET Sucursal = @Sucursal WHERE ID = @ID
END ELSE
IF @Modulo = 'ISL'   UPDATE ISLD	WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CXC' UPDATE CxcAplicaDif WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID ELSE
IF @Modulo = 'CXP' UPDATE CxpAplicaDif WITH(ROWLOCK) SET Sucursal = @Sucursal WHERE ID = @ID
RETURN
END

