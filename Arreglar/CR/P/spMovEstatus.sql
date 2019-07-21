SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovEstatus
@Modulo		 char(5),
@Estatus	 char(15),
@ID		 int,
@Generar	 bit,
@GenerarID	 int,
@GenerarAfectado bit,
@Ok		 int	OUTPUT

AS BEGIN
DECLARE
@GenerarEstatus char(15)
IF @@TRANCOUNT = 0 SELECT @Ok = 10
IF @Ok IS NOT NULL RETURN
IF @GenerarAfectado = 1 SELECT @GenerarEstatus = 'AFECTANDO' ELSE SELECT @GenerarEstatus = 'SINAFECTAR'
IF @Modulo = 'CONT'  UPDATE Cont         SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  UPDATE Venta        SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  UPDATE Prod         SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  UPDATE Compra       SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'INV'   UPDATE Inv          SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   UPDATE Cxc          SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   UPDATE Cxp          SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' UPDATE Agent        SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   UPDATE Gasto        SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   UPDATE Dinero       SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   UPDATE Embarque     SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   UPDATE Nomina       SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'RH'    UPDATE RH           SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  UPDATE Asiste       SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'AF'    UPDATE ActivoFijo   SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'PC'    UPDATE PC           SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  UPDATE Oferta       SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  UPDATE Vale         SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'CR'    UPDATE CR           SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'ST'    UPDATE Soporte      SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   UPDATE Capital      SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'INC'   UPDATE Incidencia   SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  UPDATE Conciliacion SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  UPDATE Presup       SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' UPDATE Credito      SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   UPDATE TMA          SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   UPDATE RSS          SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   UPDATE Campana      SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   UPDATE Fiscal       SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' UPDATE ContParalela SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' UPDATE Oportunidad  SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' UPDATE Corte        SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   UPDATE FormaExtra   SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  UPDATE Captura      SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'GES'   UPDATE Gestion      SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'CP'    UPDATE CP           SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   UPDATE PCP          SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  UPDATE Proyecto     SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   UPDATE Organiza     SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'RE'    UPDATE Recluta	   SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   UPDATE ISL          SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   UPDATE Cambio       SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' UPDATE Contrato     SET Estatus = @Estatus WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  UPDATE SAUX         SET Estatus = @Estatus WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
IF @Generar = 1
BEGIN
IF @Modulo = 'CONT'  UPDATE Cont         SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'VTAS'  UPDATE Venta        SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'PROD'  UPDATE Prod         SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'COMS'  UPDATE Compra       SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'INV'   UPDATE Inv          SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'CXC'   UPDATE Cxc          SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'CXP'   UPDATE Cxp          SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'AGENT' UPDATE Agent        SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'GAS'   UPDATE Gasto        SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'DIN'   UPDATE Dinero       SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'EMB'   UPDATE Embarque     SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'NOM'   UPDATE Nomina       SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'RH'    UPDATE RH           SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'ASIS'  UPDATE Asiste       SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'AF'    UPDATE ActivoFijo   SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'PC'    UPDATE PC           SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'OFER'  UPDATE Oferta       SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'VALE'  UPDATE Vale         SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'CR'    UPDATE CR           SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'ST'    UPDATE Soporte      SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'CAP'   UPDATE Capital      SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'INC'   UPDATE Incidencia   SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'CONC'  UPDATE Conciliacion SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'PPTO'  UPDATE Presup       SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'CREDI' UPDATE Credito      SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'TMA'   UPDATE TMA          SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'RSS'   UPDATE RSS          SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'CMP'   UPDATE Campana      SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'FIS'   UPDATE Fiscal       SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'CONTP' UPDATE ContParalela SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'OPORT' UPDATE Oportunidad  SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'CORTE' UPDATE Corte        SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'FRM'   UPDATE FormaExtra   SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'CAPT'  UPDATE Captura      SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'GES'   UPDATE Gestion      SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'CP'    UPDATE CP           SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'PCP'   UPDATE PCP          SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'PROY'  UPDATE Proyecto     SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'ORG'   UPDATE Organiza     SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'RE'    UPDATE Recluta	     SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'ISL'   UPDATE ISL          SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'CAM'   UPDATE Cambio       SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'PACTO' UPDATE Contrato     SET Estatus = @GenerarEstatus WHERE ID = @GenerarID ELSE
IF @Modulo = 'SAUX'  UPDATE SAUX         SET Estatus = @GenerarEstatus WHERE ID = @GenerarID
IF @@ERROR <> 0 SELECT @Ok = 1
END
RETURN
END

