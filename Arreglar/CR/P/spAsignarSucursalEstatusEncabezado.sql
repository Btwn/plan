SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAsignarSucursalEstatusEncabezado
@ID		int,
@Modulo		char(5),
@Sucursal	int,
@Estatus	char(15),
@MovID		varchar(20) = NULL

AS BEGIN
IF @Modulo = 'CONT'  UPDATE Cont         SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  UPDATE Venta        SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  UPDATE Prod         SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'INV'   UPDATE Inv          SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  UPDATE Compra       SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   UPDATE Cxc          SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   UPDATE Cxp          SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' UPDATE Agent        SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   UPDATE Gasto        SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   UPDATE Dinero       SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'AF'    UPDATE ActivoFijo   SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'PC'    UPDATE PC           SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  UPDATE Oferta       SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  UPDATE Vale         SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'CR'    UPDATE CR           SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   UPDATE Nomina       SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'RH'    UPDATE RH           SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  UPDATE Asiste       SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   UPDATE Embarque     SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'ST'    UPDATE Soporte      SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   UPDATE Capital      SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'INC'   UPDATE Incidencia   SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  UPDATE Conciliacion SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  UPDATE Presup       SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' UPDATE Credito      SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   UPDATE TMA          SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   UPDATE RSS          SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   UPDATE Campana      SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   UPDATE Fiscal       SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' UPDATE ContParalela SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' UPDATE Oportunidad  SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' UPDATE Corte        SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   UPDATE FormaExtra   SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  UPDATE Captura      SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'GES'   UPDATE Gestion      SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'CP'    UPDATE CP           SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   UPDATE PCP          SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  UPDATE Proyecto     SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   UPDATE Organiza	   SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'RE'    UPDATE Recluta	   SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   UPDATE ISL          SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   UPDATE Cambio       SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' UPDATE Contrato     SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  UPDATE SAUX		   SET Sucursal = ISNULL(@Sucursal, Sucursal), Estatus = ISNULL(@Estatus, Estatus), MovID = ISNULL(@MovID, MovID) WHERE ID = @ID
RETURN
END

