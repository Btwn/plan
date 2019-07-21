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
IF @Modulo = 'VTAS'  UPDATE Venta 	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones), Prioridad = ISNULL(@Prioridad, Prioridad) WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  UPDATE Prod	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones), Prioridad = ISNULL(@Prioridad, Prioridad) WHERE ID = @ID ELSE
IF @Modulo = 'INV'   UPDATE Inv	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones), Prioridad = ISNULL(@Prioridad, Prioridad) WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  UPDATE Compra 	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones), Prioridad = ISNULL(@Prioridad, Prioridad) WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   UPDATE Gasto	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones), Prioridad = ISNULL(@Prioridad, Prioridad) WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   UPDATE Dinero 	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones), Prioridad = ISNULL(@Prioridad, Prioridad) WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  UPDATE Proyecto	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones), Prioridad = ISNULL(@Prioridad, Prioridad) WHERE ID = @ID ELSE
IF @Modulo = 'ST'    UPDATE Soporte 	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones), Prioridad = ISNULL(@Prioridad, Prioridad) WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   UPDATE Cxc 	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   UPDATE Cxp 	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' UPDATE Agent 	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'AF'    UPDATE ActivoFijo   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  UPDATE Vale 	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CR'    UPDATE CR	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   UPDATE Cambio	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' UPDATE Contrato     SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   UPDATE Capital	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'INC'   UPDATE Incidencia   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  UPDATE Conciliacion SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  UPDATE Presup       SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' UPDATE Credito      SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   UPDATE TMA	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   UPDATE RSS	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   UPDATE Campana	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   UPDATE Fiscal	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' UPDATE ContParalela SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' UPDATE Oportunidad  SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' UPDATE Corte	       SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   UPDATE FormaExtra   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  UPDATE Captura      SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'GES'   UPDATE Gestion      SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CP'    UPDATE CP	       SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   UPDATE PCP	       SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   UPDATE Organiza     SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'RE'    UPDATE Recluta	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones), Prioridad = ISNULL(@Prioridad, Prioridad) WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   UPDATE ISL          SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'CONT'  UPDATE Cont	       SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'PC'    UPDATE PC	       SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  UPDATE Oferta	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   UPDATE Nomina	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'RH'    UPDATE RH	       SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  UPDATE Asiste	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   UPDATE Embarque	   SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  UPDATE SAUX	       SET UEN = ISNULL(@UEN, UEN), Usuario = ISNULL(@Usuario, Usuario), Observaciones = ISNULL(@Observaciones, Observaciones) WHERE ID = @ID
RETURN
END

