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
IF @Modulo = 'VTAS'  SELECT @ID = ID FROM Venta 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CXC'   SELECT @ID = ID FROM Cxc 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ST'    SELECT @ID = ID FROM Soporte 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'COMS'  SELECT @ID = ID FROM Compra 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CXP'   SELECT @ID = ID FROM Cxp 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'AGENT' SELECT @ID = ID FROM Agent 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'GAS'   SELECT @ID = ID FROM Gasto 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'DIN'   SELECT @ID = ID FROM Dinero    		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'AF'    SELECT @ID = ID FROM ActivoFijo 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'VALE'  SELECT @ID = ID FROM Vale 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CR'    SELECT @ID = ID FROM CR 			WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CAM'   SELECT @ID = ID FROM Cambio 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PACTO' SELECT @ID = ID FROM Contrato 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CAP'   SELECT @ID = ID FROM Capital 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'INC'   SELECT @ID = ID FROM Incidencia 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CONC'  SELECT @ID = ID FROM Conciliacion	WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PPTO'  SELECT @ID = ID FROM Presup      	WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CREDI' SELECT @ID = ID FROM Credito		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'TMA'   SELECT @ID = ID FROM TMA 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'RSS'   SELECT @ID = ID FROM RSS 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CMP'   SELECT @ID = ID FROM Campana		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'FIS'   SELECT @ID = ID FROM Fiscal		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CONTP' SELECT @ID = ID FROM ContParalela WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'OPORT' SELECT @ID = ID FROM Oportunidad WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CORTE' SELECT @ID = ID FROM Corte		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'FRM'   SELECT @ID = ID FROM FormaExtra 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CAPT'  SELECT @ID = ID FROM Captura		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'GES'   SELECT @ID = ID FROM Gestion 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR', 'CANCELADO') ELSE
IF @Modulo = 'CP'    SELECT @ID = ID FROM CP   		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PCP'   SELECT @ID = ID FROM PCP   		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE 
IF @Modulo = 'PROY'  SELECT @ID = ID FROM Proyecto		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ORG'   SELECT @ID = ID FROM Organiza	WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'RE'    SELECT @ID = ID FROM Recluta		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ISL'   SELECT @ID = ID FROM ISL         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CONT'  SELECT @ID = ID FROM Cont 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PROD'  SELECT @ID = ID FROM Prod 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'INV'   SELECT @ID = ID FROM Inv 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PC'    SELECT @ID = ID FROM PC 			WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'OFER'  SELECT @ID = ID FROM Oferta		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'NOM'   SELECT @ID = ID FROM Nomina 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'RH'    SELECT @ID = ID FROM RH 			WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ASIS'  SELECT @ID = ID FROM Asiste 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'EMB'   SELECT @ID = ID FROM Embarque 	WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'SAUX'  SELECT @ID = ID FROM SAUX	 	WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Ejercicio = @Ejercicio AND Periodo = @Periodo AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR')
IF @ID IS NULL
BEGIN
IF @Modulo = 'VTAS'  SELECT @ID = ID FROM Venta 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CXC'   SELECT @ID = ID FROM Cxc 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ST'    SELECT @ID = ID FROM Soporte 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'COMS'  SELECT @ID = ID FROM Compra 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CXP'   SELECT @ID = ID FROM Cxp 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'AGENT' SELECT @ID = ID FROM Agent 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'GAS'   SELECT @ID = ID FROM Gasto 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'DIN'   SELECT @ID = ID FROM Dinero    	WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'AF'    SELECT @ID = ID FROM ActivoFijo 	WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'VALE'  SELECT @ID = ID FROM Vale 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CR'    SELECT @ID = ID FROM CR 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CAM'   SELECT @ID = ID FROM Cambio 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PACTO' SELECT @ID = ID FROM Contrato		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CAP'   SELECT @ID = ID FROM Capital 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'INC'   SELECT @ID = ID FROM Incidencia 	WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CONC'  SELECT @ID = ID FROM Conciliacion	WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PPTO'  SELECT @ID = ID FROM Presup      	WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CREDI' SELECT @ID = ID FROM Credito		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'TMA'   SELECT @ID = ID FROM TMA 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'RSS'   SELECT @ID = ID FROM RSS 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CMP'   SELECT @ID = ID FROM Campana		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'FIS'   SELECT @ID = ID FROM Fiscal		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CONTP' SELECT @ID = ID FROM ContParalela WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'OPORT' SELECT @ID = ID FROM Oportunidad   WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CORTE' SELECT @ID = ID FROM Corte		    WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'FRM'   SELECT @ID = ID FROM FormaExtra	WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CAPT'  SELECT @ID = ID FROM Captura   	WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'GES'   SELECT @ID = ID FROM Captura   	WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CP'    SELECT @ID = ID FROM CP      		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PCP'   SELECT @ID = ID FROM PCP      		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE 
IF @Modulo = 'PROY'  SELECT @ID = ID FROM Proyecto		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ORG'   SELECT @ID = ID FROM Organiza		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'RE'    SELECT @ID = ID FROM Recluta		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ISL'	 SELECT @ID = ID FROM ISL         	WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CONT'  SELECT @ID = ID FROM Cont 			WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PROD'  SELECT @ID = ID FROM Prod 			WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'INV'   SELECT @ID = ID FROM Inv 			WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PC'    SELECT @ID = ID FROM PC 			WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'OFER'  SELECT @ID = ID FROM Oferta		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'NOM'   SELECT @ID = ID FROM Nomina 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'RH'    SELECT @ID = ID FROM RH 			WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ASIS'  SELECT @ID = ID FROM Asiste 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'EMB'   SELECT @ID = ID FROM Embarque 		WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'SAUX'  SELECT @ID = ID FROM SAUX 			WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR')
END
IF @ID IS NULL
BEGIN
IF @Modulo = 'VTAS'  SELECT @ID = ID FROM Venta 		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CXC'   SELECT @ID = ID FROM Cxc 		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ST'    SELECT @ID = ID FROM Soporte 		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'COMS'  SELECT @ID = ID FROM Compra 		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CXP'   SELECT @ID = ID FROM Cxp 		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'AGENT' SELECT @ID = ID FROM Agent 		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'GAS'   SELECT @ID = ID FROM Gasto 		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'DIN'   SELECT @ID = ID FROM Dinero    	WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'AF'    SELECT @ID = ID FROM ActivoFijo 	WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'VALE'  SELECT @ID = ID FROM Vale 		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CR'    SELECT @ID = ID FROM CR 		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CAM'   SELECT @ID = ID FROM Cambio 		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PACTO' SELECT @ID = ID FROM Contrato		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CAP'   SELECT @ID = ID FROM Capital 		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'INC'   SELECT @ID = ID FROM Incidencia 	WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CONC'  SELECT @ID = ID FROM Conciliacion	WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PPTO'  SELECT @ID = ID FROM Presup      	WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CREDI' SELECT @ID = ID FROM Credito		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'TMA'   SELECT @ID = ID FROM TMA 		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'RSS'   SELECT @ID = ID FROM RSS 		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CMP'   SELECT @ID = ID FROM Campana		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'FIS'   SELECT @ID = ID FROM Fiscal		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CONTP' SELECT @ID = ID FROM ContParalela  WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'OPORT' SELECT @ID = ID FROM Oportunidad   WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CORTE' SELECT @ID = ID FROM Corte		    WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'FRM'   SELECT @ID = ID FROM FormaExtra	WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CAPT'  SELECT @ID = ID FROM Captura   	WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'GES'   SELECT @ID = ID FROM Gestion   	WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CP'    SELECT @ID = ID FROM CP      		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PCP'   SELECT @ID = ID FROM PCP      		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE 
IF @Modulo = 'PROY'  SELECT @ID = ID FROM Proyecto		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ORG'   SELECT @ID = ID FROM Organiza		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'RE'    SELECT @ID = ID FROM Recluta		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ISL'   SELECT @ID = ID FROM ISL         	WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'CONT'  SELECT @ID = ID FROM Cont 			WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PROD'  SELECT @ID = ID FROM Prod 			WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'INV'   SELECT @ID = ID FROM Inv 			WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'PC'    SELECT @ID = ID FROM PC 			WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'OFER'  SELECT @ID = ID FROM Oferta		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'NOM'   SELECT @ID = ID FROM Nomina 		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'RH'    SELECT @ID = ID FROM RH 			WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'ASIS'  SELECT @ID = ID FROM Asiste 		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'EMB'   SELECT @ID = ID FROM Embarque 		WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR') ELSE
IF @Modulo = 'SAUX'  SELECT @ID = ID FROM SAUX 			WHERE Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL', 'CONFIRMAR')
END
RETURN (@ID)
END

