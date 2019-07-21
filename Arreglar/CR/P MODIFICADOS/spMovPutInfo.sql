SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovPutInfo
@ID		int,
@Modulo		char(5),
@UEN		int		= NULL,
@Usuario	varchar(10) 	= NULL,
@Observaciones	varchar(100)	= NULL,
@Prioridad	varchar(10)	= NULL

AS BEGIN
SELECT @UEN = NULLIF(@UEN, 0), @Usuario = NULLIF(NULLIF(RTRIM(@Usuario), ''), '0'), @Observaciones = NULLIF(NULLIF(RTRIM(@Observaciones), ''), '0')
IF @Modulo = 'VTAS'  UPDATE Venta 	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones), Prioridad = ISNULL(@Prioridad, Prioridad) WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  UPDATE Prod	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones), Prioridad = ISNULL(@Prioridad, Prioridad) WHERE ID = @ID ELSE
IF @Modulo = 'INV'   UPDATE Inv	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones), Prioridad = ISNULL(@Prioridad, Prioridad) WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  UPDATE Compra 	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones), Prioridad = ISNULL(@Prioridad, Prioridad) WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   UPDATE Gasto	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones), Prioridad = ISNULL(@Prioridad, Prioridad) WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   UPDATE Dinero 	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones), Prioridad = ISNULL(@Prioridad, Prioridad) WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  UPDATE Proyecto	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones), Prioridad = ISNULL(@Prioridad, Prioridad) WHERE ID = @ID ELSE
IF @Modulo = 'ST'    UPDATE Soporte 	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones), Prioridad = ISNULL(@Prioridad, Prioridad) WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   UPDATE Cxc 	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   UPDATE Cxp 	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' UPDATE Agent 	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'AF'    UPDATE ActivoFijo WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  UPDATE Vale 	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CR'    UPDATE CR	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   UPDATE Cambio	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' UPDATE Contrato   WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   UPDATE Capital	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'INC'   UPDATE Incidencia WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  UPDATE Conciliacion WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  UPDATE Presup     WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' UPDATE Credito    WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   UPDATE TMA	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   UPDATE RSS	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   UPDATE Campana	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   UPDATE Fiscal	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' UPDATE ContParalela WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' UPDATE Oportunidad WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' UPDATE Corte	     WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   UPDATE FormaExtra WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  UPDATE Captura    WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'GES'   UPDATE Gestion    WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CP'    UPDATE CP	     WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   UPDATE PCP	     WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   UPDATE Organiza   WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'RE'    UPDATE Recluta	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones), Prioridad = ISNULL(@Prioridad, Prioridad) WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   UPDATE ISL        WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CONT'  UPDATE Cont	     WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'PC'    UPDATE PC	     WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  UPDATE Oferta	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   UPDATE Nomina	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'RH'    UPDATE RH	     WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  UPDATE Asiste	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   UPDATE Embarque	 WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  UPDATE SAUX	     WITH(ROWLOCK) SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID
RETURN
END

