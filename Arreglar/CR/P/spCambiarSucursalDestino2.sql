SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCambiarSucursalDestino2
@Modulo		char(5),
@ID			int,
@SucursalDestino	int

AS BEGIN
DECLARE
@Sucursal				int,
@Mov					varchar(20)
IF @Modulo = 'CONT'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Cont         WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Venta        WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Prod         WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Compra       WHERE ID = @ID ELSE
IF @Modulo = 'INV'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Inv          WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Cxc          WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Cxp          WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' SELECT @Sucursal = Sucursal, @Mov = Mov FROM Agent        WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Gasto        WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Dinero       WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Embarque     WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Nomina       WHERE ID = @ID ELSE
IF @Modulo = 'RH'    SELECT @Sucursal = Sucursal, @Mov = Mov FROM RH           WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Asiste       WHERE ID = @ID ELSE
IF @Modulo = 'AF'    SELECT @Sucursal = Sucursal, @Mov = Mov FROM ActivoFijo   WHERE ID = @ID ELSE
IF @Modulo = 'PC'    SELECT @Sucursal = Sucursal, @Mov = Mov FROM PC           WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Oferta       WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Vale         WHERE ID = @ID ELSE
IF @Modulo = 'CR'    SELECT @Sucursal = Sucursal, @Mov = Mov FROM CR           WHERE ID = @ID ELSE
IF @Modulo = 'ST'    SELECT @Sucursal = Sucursal, @Mov = Mov FROM Soporte      WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Capital      WHERE ID = @ID ELSE
IF @Modulo = 'INC'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Incidencia   WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Conciliacion WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Presup       WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' SELECT @Sucursal = Sucursal, @Mov = Mov FROM Credito      WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM TMA          WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM RSS          WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Campana      WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Fiscal       WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' SELECT @Sucursal = Sucursal, @Mov = Mov FROM ContParalela WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' SELECT @Sucursal = Sucursal, @Mov = Mov FROM Oportunidad  WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' SELECT @Sucursal = Sucursal, @Mov = Mov FROM Corte        WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM FormaExtra   WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Captura      WHERE ID = @ID ELSE
IF @Modulo = 'GES'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Gestion      WHERE ID = @ID ELSE
IF @Modulo = 'CP'    SELECT @Sucursal = Sucursal, @Mov = Mov FROM CP           WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM PCP          WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Proyecto     WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Organiza     WHERE ID = @ID ELSE
IF @Modulo = 'RE'    SELECT @Sucursal = Sucursal, @Mov = Mov FROM Recluta	     WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM ISL          WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Cambio       WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' SELECT @Sucursal = Sucursal, @Mov = Mov FROM Contrato     WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Contrato     WHERE ID = @ID
IF NOT EXISTS(SELECT 1 FROM SucursalMovBloquearCambio WHERE Sucursal = @Sucursal AND RTRIM(Modulo) = RTRIM(@Modulo) AND RTRIM(Mov) = RTRIM(@Mov))
BEGIN
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
IF @Modulo = 'CORTE' UPDATE Corte		   SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
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
SELECT NULL
COMMIT TRANSACTION
END ELSE
SELECT 'No es posible cambiar la sucursal destino del movimiento. Verifique la configuración de la sucursal del movimiento.'
RETURN
END

