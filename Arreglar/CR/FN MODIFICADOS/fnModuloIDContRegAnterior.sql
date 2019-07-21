SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnModuloIDContRegAnterior (@Empresa char(5), @Modulo char(5), @Mov char(20), @MovID varchar(20), @Ejercicio int, @Periodo int)
RETURNS int

AS BEGIN
DECLARE
@ID	int
SELECT @ID = NULL
IF @Modulo = 'VTAS'  SELECT @ID = ID FROM Venta 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CXC'   SELECT @ID = ID FROM Cxc 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ST'    SELECT @ID = ID FROM Soporte 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'COMS'  SELECT @ID = ID FROM Compra 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CXP'   SELECT @ID = ID FROM Cxp 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'AGENT' SELECT @ID = ID FROM Agent 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'GAS'   SELECT @ID = ID FROM Gasto 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'DIN'   SELECT @ID = ID FROM Dinero    		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'AF'    SELECT @ID = ID FROM ActivoFijo 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'VALE'  SELECT @ID = ID FROM Vale 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CR'    SELECT @ID = ID FROM CR 			WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CAM'   SELECT @ID = ID FROM Cambio 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PACTO' SELECT @ID = ID FROM Contrato 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CAP'   SELECT @ID = ID FROM Capital 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'INC'   SELECT @ID = ID FROM Incidencia 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CONC'  SELECT @ID = ID FROM Conciliacion	WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PPTO'  SELECT @ID = ID FROM Presup      	WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CREDI' SELECT @ID = ID FROM Credito		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'TMA'   SELECT @ID = ID FROM TMA 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'RSS'   SELECT @ID = ID FROM RSS 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CMP'   SELECT @ID = ID FROM Campana		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'FIS'   SELECT @ID = ID FROM Fiscal		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CONTP' SELECT @ID = ID FROM ContParalela WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'OPORT' SELECT @ID = ID FROM Oportunidad WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CORTE' SELECT @ID = ID FROM Corte		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'FRM'   SELECT @ID = ID FROM FormaExtra 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CAPT'  SELECT @ID = ID FROM Captura		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'GES'   SELECT @ID = ID FROM Gestion 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR', 'CANCELADO') ELSE
IF @Modulo = 'CP'    SELECT @ID = ID FROM CP   		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PCP'   SELECT @ID = ID FROM PCP   		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE 
IF @Modulo = 'PROY'  SELECT @ID = ID FROM Proyecto		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ORG'   SELECT @ID = ID FROM Organiza	WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'RE'    SELECT @ID = ID FROM Recluta		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ISL'   SELECT @ID = ID FROM ISL         WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CONT'  SELECT @ID = ID FROM Cont 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PROD'  SELECT @ID = ID FROM Prod 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'INV'   SELECT @ID = ID FROM Inv 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PC'    SELECT @ID = ID FROM PC 			WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'OFER'  SELECT @ID = ID FROM Oferta		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'NOM'   SELECT @ID = ID FROM Nomina 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'RH'    SELECT @ID = ID FROM RH 			WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ASIS'  SELECT @ID = ID FROM Asiste 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'EMB'   SELECT @ID = ID FROM Embarque 	WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'SAUX'  SELECT @ID = ID FROM SAUX	 	WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR')
IF @ID IS NULL
BEGIN
IF @Modulo = 'VTAS'  SELECT @ID = ID FROM Venta 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CXC'   SELECT @ID = ID FROM Cxc 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ST'    SELECT @ID = ID FROM Soporte 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'COMS'  SELECT @ID = ID FROM Compra 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CXP'   SELECT @ID = ID FROM Cxp 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'AGENT' SELECT @ID = ID FROM Agent 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'GAS'   SELECT @ID = ID FROM Gasto 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'DIN'   SELECT @ID = ID FROM Dinero    	WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'AF'    SELECT @ID = ID FROM ActivoFijo 	WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'VALE'  SELECT @ID = ID FROM Vale 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CR'    SELECT @ID = ID FROM CR 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CAM'   SELECT @ID = ID FROM Cambio 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PACTO' SELECT @ID = ID FROM Contrato		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CAP'   SELECT @ID = ID FROM Capital 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'INC'   SELECT @ID = ID FROM Incidencia 	WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CONC'  SELECT @ID = ID FROM Conciliacion	WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PPTO'  SELECT @ID = ID FROM Presup      	WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CREDI' SELECT @ID = ID FROM Credito		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'TMA'   SELECT @ID = ID FROM TMA 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'RSS'   SELECT @ID = ID FROM RSS 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CMP'   SELECT @ID = ID FROM Campana		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'FIS'   SELECT @ID = ID FROM Fiscal		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CONTP' SELECT @ID = ID FROM ContParalela WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'OPORT' SELECT @ID = ID FROM Oportunidad   WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CORTE' SELECT @ID = ID FROM Corte		    WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'FRM'   SELECT @ID = ID FROM FormaExtra	WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CAPT'  SELECT @ID = ID FROM Captura   	WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'GES'   SELECT @ID = ID FROM Captura   	WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CP'    SELECT @ID = ID FROM CP      		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PCP'   SELECT @ID = ID FROM PCP      		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE 
IF @Modulo = 'PROY'  SELECT @ID = ID FROM Proyecto		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ORG'   SELECT @ID = ID FROM Organiza		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'RE'    SELECT @ID = ID FROM Recluta		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ISL'	 SELECT @ID = ID FROM ISL         	WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CONT'  SELECT @ID = ID FROM Cont 			WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PROD'  SELECT @ID = ID FROM Prod 			WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'INV'   SELECT @ID = ID FROM Inv 			WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PC'    SELECT @ID = ID FROM PC 			WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'OFER'  SELECT @ID = ID FROM Oferta		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'NOM'   SELECT @ID = ID FROM Nomina 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'RH'    SELECT @ID = ID FROM RH 			WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ASIS'  SELECT @ID = ID FROM Asiste 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'EMB'   SELECT @ID = ID FROM Embarque 		WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'SAUX'  SELECT @ID = ID FROM SAUX 			WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR')
END
IF @ID IS NULL
BEGIN
IF @Modulo = 'VTAS'  SELECT @ID = ID FROM Venta 		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CXC'   SELECT @ID = ID FROM Cxc 		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ST'    SELECT @ID = ID FROM Soporte 		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'COMS'  SELECT @ID = ID FROM Compra 		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CXP'   SELECT @ID = ID FROM Cxp 		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'AGENT' SELECT @ID = ID FROM Agent 		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'GAS'   SELECT @ID = ID FROM Gasto 		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'DIN'   SELECT @ID = ID FROM Dinero    	WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'AF'    SELECT @ID = ID FROM ActivoFijo 	WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'VALE'  SELECT @ID = ID FROM Vale 		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CR'    SELECT @ID = ID FROM CR 		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CAM'   SELECT @ID = ID FROM Cambio 		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PACTO' SELECT @ID = ID FROM Contrato		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CAP'   SELECT @ID = ID FROM Capital 		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'INC'   SELECT @ID = ID FROM Incidencia 	WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CONC'  SELECT @ID = ID FROM Conciliacion	WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PPTO'  SELECT @ID = ID FROM Presup      	WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CREDI' SELECT @ID = ID FROM Credito		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'TMA'   SELECT @ID = ID FROM TMA 		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'RSS'   SELECT @ID = ID FROM RSS 		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CMP'   SELECT @ID = ID FROM Campana		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'FIS'   SELECT @ID = ID FROM Fiscal		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CONTP' SELECT @ID = ID FROM ContParalela  WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'OPORT' SELECT @ID = ID FROM Oportunidad   WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CORTE' SELECT @ID = ID FROM Corte		    WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'FRM'   SELECT @ID = ID FROM FormaExtra	WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CAPT'  SELECT @ID = ID FROM Captura   	WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'GES'   SELECT @ID = ID FROM Gestion   	WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CP'    SELECT @ID = ID FROM CP      		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PCP'   SELECT @ID = ID FROM PCP      		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE 
IF @Modulo = 'PROY'  SELECT @ID = ID FROM Proyecto		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ORG'   SELECT @ID = ID FROM Organiza		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'RE'    SELECT @ID = ID FROM Recluta		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ISL'   SELECT @ID = ID FROM ISL         	WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CONT'  SELECT @ID = ID FROM Cont 			WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PROD'  SELECT @ID = ID FROM Prod 			WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'INV'   SELECT @ID = ID FROM Inv 			WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PC'    SELECT @ID = ID FROM PC 			WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'OFER'  SELECT @ID = ID FROM Oferta		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'NOM'   SELECT @ID = ID FROM Nomina 		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'RH'    SELECT @ID = ID FROM RH 			WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ASIS'  SELECT @ID = ID FROM Asiste 		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'EMB'   SELECT @ID = ID FROM Embarque 		WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'SAUX'  SELECT @ID = ID FROM SAUX 			WITH(NOLOCK) WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR')
END
RETURN (@ID)
END

