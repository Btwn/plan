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
IF @Modulo = 'CONT'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Cont         WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Venta        WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Prod         WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Compra       WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'INV'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Inv          WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Cxc          WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Cxp          WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' SELECT @Sucursal = Sucursal, @Mov = Mov FROM Agent        WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Gasto        WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Dinero       WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Embarque     WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Nomina       WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'RH'    SELECT @Sucursal = Sucursal, @Mov = Mov FROM RH           WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Asiste       WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'AF'    SELECT @Sucursal = Sucursal, @Mov = Mov FROM ActivoFijo   WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PC'    SELECT @Sucursal = Sucursal, @Mov = Mov FROM PC           WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Oferta       WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Vale         WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CR'    SELECT @Sucursal = Sucursal, @Mov = Mov FROM CR           WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'ST'    SELECT @Sucursal = Sucursal, @Mov = Mov FROM Soporte      WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Capital      WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'INC'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Incidencia   WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Conciliacion WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Presup       WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' SELECT @Sucursal = Sucursal, @Mov = Mov FROM Credito      WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM TMA          WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM RSS          WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Campana      WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Fiscal       WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' SELECT @Sucursal = Sucursal, @Mov = Mov FROM ContParalela WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' SELECT @Sucursal = Sucursal, @Mov = Mov FROM Oportunidad  WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' SELECT @Sucursal = Sucursal, @Mov = Mov FROM Corte        WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM FormaExtra   WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Captura      WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'GES'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Gestion      WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CP'    SELECT @Sucursal = Sucursal, @Mov = Mov FROM CP           WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM PCP          WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Proyecto     WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Organiza     WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'RE'    SELECT @Sucursal = Sucursal, @Mov = Mov FROM Recluta	   WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM ISL          WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   SELECT @Sucursal = Sucursal, @Mov = Mov FROM Cambio       WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' SELECT @Sucursal = Sucursal, @Mov = Mov FROM Contrato     WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  SELECT @Sucursal = Sucursal, @Mov = Mov FROM Contrato     WITH (NOLOCK) WHERE ID = @ID
IF NOT EXISTS(SELECT 1 FROM SucursalMovBloquearCambio WITH (NOLOCK) WHERE Sucursal = @Sucursal AND RTRIM(Modulo) = RTRIM(@Modulo) AND RTRIM(Mov) = RTRIM(@Mov))
BEGIN
BEGIN TRANSACTION
IF @Modulo = 'CONT'  UPDATE Cont         WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  UPDATE Venta        WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  UPDATE Prod         WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  UPDATE Compra       WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'INV'   UPDATE Inv          WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   UPDATE Cxc          WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   UPDATE Cxp          WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' UPDATE Agent        WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   UPDATE Gasto        WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   UPDATE Dinero       WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   UPDATE Embarque     WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   UPDATE Nomina       WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'RH'    UPDATE RH           WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  UPDATE Asiste       WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'AF'    UPDATE ActivoFijo   WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'PC'    UPDATE PC           WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  UPDATE Oferta       WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  UPDATE Vale         WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CR'    UPDATE CR           WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'ST'    UPDATE Soporte      WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   UPDATE Capital      WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'INC'   UPDATE Incidencia   WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  UPDATE Conciliacion WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  UPDATE Presup       WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' UPDATE Credito      WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   UPDATE TMA          WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   UPDATE RSS          WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   UPDATE Campana      WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   UPDATE Fiscal       WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' UPDATE ContParalela WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' UPDATE Oportunidad  WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' UPDATE Corte		 WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   UPDATE FormaExtra   WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  UPDATE Captura      WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'GES'   UPDATE Gestion      WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CP'    UPDATE CP           WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   UPDATE PCP          WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  UPDATE Proyecto     WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   UPDATE Organiza     WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'RE'    UPDATE Recluta	     WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   UPDATE ISL          WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   UPDATE Cambio       WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' UPDATE Contrato     WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'	 UPDATE SAUX		 WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID
SELECT NULL
COMMIT TRANSACTION
END ELSE
SELECT 'No es posible cambiar la sucursal destino del movimiento. Verifique la configuraci�n de la sucursal del movimiento.'
RETURN
END

