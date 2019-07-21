SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCambiarUsuario
@Modulo  	char(5),
@ID	    	int,
@Usuario 	char(10)

AS BEGIN
IF NOT EXISTS(SELECT * FROM Usuario WHERE Usuario=@Usuario) RETURN
BEGIN TRANSACTION
IF @Modulo = 'CONT'  UPDATE Cont         SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  UPDATE Venta        SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  UPDATE Prod         SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  UPDATE Compra       SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'INV'   UPDATE Inv          SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   UPDATE Cxc          SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   UPDATE Cxp          SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' UPDATE Agent        SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   UPDATE Gasto        SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   UPDATE Dinero       SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   UPDATE Embarque     SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   UPDATE Nomina       SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'RH'    UPDATE RH           SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  UPDATE Asiste       SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'AF'    UPDATE ActivoFijo   SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'PC'    UPDATE PC           SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  UPDATE Oferta       SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  UPDATE Vale         SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'CR'    UPDATE CR           SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'ST'    UPDATE Soporte      SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   UPDATE Capital      SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'INC'   UPDATE Incidencia   SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  UPDATE Conciliacion SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  UPDATE Presup       SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' UPDATE Credito      SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   UPDATE TMA          SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   UPDATE RSS          SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   UPDATE Campana      SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   UPDATE Fiscal       SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' UPDATE ContParalela SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' UPDATE Oportundidad SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' UPDATE Corte        SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   UPDATE FormaExtra   SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  UPDATE Captura      SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'GES'   UPDATE Gestion      SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'CP'    UPDATE CP           SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   UPDATE PCP          SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  UPDATE Proyecto     SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   UPDATE Organiza     SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'RE'    UPDATE Recluta	     SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   UPDATE ISL          SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   UPDATE Cambio       SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' UPDATE Contrato     SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'	 UPDATE SAUX		 SET Usuario = NULLIF(RTRIM(@Usuario), '') WHERE ID = @ID
COMMIT TRANSACTION
RETURN
END

