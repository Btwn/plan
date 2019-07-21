SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConsecutivoActualizar
@Modulo		char(5),
@ID			int,
@MovID      		varchar(20)

AS BEGIN
IF @Modulo = 'CONT'  UPDATE Cont         SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  UPDATE Venta        SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  UPDATE Prod         SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  UPDATE Compra       SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'INV'   UPDATE Inv          SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   UPDATE Cxc          SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   UPDATE Cxp          SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' UPDATE Agent        SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   UPDATE Gasto        SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   UPDATE Dinero       SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   UPDATE Embarque     SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   UPDATE Nomina       SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'RH'    UPDATE RH           SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  UPDATE Asiste       SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'AF'    UPDATE ActivoFijo   SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'PC'    UPDATE PC           SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  UPDATE Oferta       SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  UPDATE Vale         SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CR'    UPDATE CR           SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'ST'    UPDATE Soporte      SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   UPDATE Capital      SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'INC'   UPDATE Incidencia   SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  UPDATE Conciliacion SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  UPDATE Presup       SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' UPDATE Credito      SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   UPDATE TMA          SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   UPDATE RSS          SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   UPDATE Campana      SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   UPDATE Fiscal       SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' UPDATE ContParalela SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' UPDATE Oportunidad  SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' UPDATE Corte        SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   UPDATE FormaExtra   SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  UPDATE Captura      SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'GES'   UPDATE Gestion      SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CP'    UPDATE CP           SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   UPDATE PCP          SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  UPDATE Proyecto     SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   UPDATE Organiza     SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'RE'    UPDATE Recluta	   SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   UPDATE ISL          SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   UPDATE Cambio       SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' UPDATE Contrato	   SET MovID = @MovID WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  UPDATE SAUX		   SET MovID = @MovID WHERE ID = @ID
RETURN
END

