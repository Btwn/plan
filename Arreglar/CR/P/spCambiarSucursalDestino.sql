SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCambiarSucursalDestino
@Modulo		char(5),
@ID			int,
@SucursalDestino	int

AS BEGIN
BEGIN TRANSACTION
IF @Modulo = 'CONT'  UPDATE Cont         SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  UPDATE Venta        SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  UPDATE Prod         SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  UPDATE Compra       SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'INV'   UPDATE Inv          SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   UPDATE Cxc          SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   UPDATE Cxp          SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' UPDATE Agent        SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   UPDATE Gasto        SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   UPDATE Dinero       SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   UPDATE Embarque     SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   UPDATE Nomina       SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'RH'    UPDATE RH           SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  UPDATE Asiste       SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'AF'    UPDATE ActivoFijo   SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'PC'    UPDATE PC           SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  UPDATE Oferta       SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  UPDATE Vale         SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CR'    UPDATE CR           SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'ST'    UPDATE Soporte      SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   UPDATE Capital      SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'INC'   UPDATE Incidencia   SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  UPDATE Conciliacion SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  UPDATE Presup       SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' UPDATE Credito      SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   UPDATE TMA          SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   UPDATE RSS          SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   UPDATE Campana      SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   UPDATE Fiscal       SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' UPDATE ContParalela SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' UPDATE Oportunidad  SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' UPDATE Corte        SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   UPDATE FormaExtra   SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  UPDATE Captura      SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'GES'   UPDATE Gestion      SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CP'    UPDATE CP           SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   UPDATE PCP          SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  UPDATE Proyecto     SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   UPDATE Organiza     SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'RE'    UPDATE Recluta	     SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   UPDATE ISL          SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   UPDATE Cambio       SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' UPDATE Contrato     SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'	 UPDATE SAUX		 SET SucursalDestino = @SucursalDestino WHERE ID = @ID
COMMIT TRANSACTION
RETURN
END

