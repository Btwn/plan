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
IF @Modulo = 'CONT'  UPDATE Cont        WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  UPDATE Venta       WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  UPDATE Prod        WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  UPDATE Compra      WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'INV'   UPDATE Inv         WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   UPDATE Cxc         WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   UPDATE Cxp         WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' UPDATE Agent       WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   UPDATE Gasto       WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   UPDATE Dinero      WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   UPDATE Embarque    WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   UPDATE Nomina      WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'RH'    UPDATE RH          WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  UPDATE Asiste      WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'AF'    UPDATE ActivoFijo  WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'PC'    UPDATE PC          WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  UPDATE Oferta      WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  UPDATE Vale        WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CR'    UPDATE CR          WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'ST'    UPDATE Soporte     WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   UPDATE Capital     WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'INC'   UPDATE Incidencia  WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  UPDATE Conciliacion WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  UPDATE Presup      WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' UPDATE Credito     WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   UPDATE TMA         WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   UPDATE RSS         WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   UPDATE Campana     WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   UPDATE Fiscal      WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' UPDATE ContParalela WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' UPDATE Oportunidad WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' UPDATE Corte       WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   UPDATE FormaExtra  WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  UPDATE Captura     WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'GES'   UPDATE Gestion     WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CP'    UPDATE CP          WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   UPDATE PCP         WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  UPDATE Proyecto    WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   UPDATE Organiza    WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'RE'    UPDATE Recluta	    WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   UPDATE ISL         WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   UPDATE Cambio      WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' UPDATE Contrato    WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'	 UPDATE SAUX		WITH (ROWLOCK) SET SucursalDestino = @SucursalDestino WHERE ID = @ID
COMMIT TRANSACTION
RETURN
END

