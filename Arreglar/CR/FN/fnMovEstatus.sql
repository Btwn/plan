SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMovEstatus (@Modulo char(5), @ID int)
RETURNS varchar(15)

AS BEGIN
DECLARE
@Estatus	varchar(15)
SELECT @Estatus = NULL
IF @Modulo = 'VTAS'  SELECT @Estatus = Estatus FROM Venta 		WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   SELECT @Estatus = Estatus FROM Cxc 		WHERE ID = @ID ELSE
IF @Modulo = 'ST'    SELECT @Estatus = Estatus FROM Soporte 		WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  SELECT @Estatus = Estatus FROM Compra 		WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   SELECT @Estatus = Estatus FROM Cxp 		WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' SELECT @Estatus = Estatus FROM Agent 		WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   SELECT @Estatus = Estatus FROM Gasto 		WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   SELECT @Estatus = Estatus FROM Dinero    	WHERE ID = @ID ELSE
IF @Modulo = 'AF'    SELECT @Estatus = Estatus FROM ActivoFijo 	WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  SELECT @Estatus = Estatus FROM Vale 		WHERE ID = @ID ELSE
IF @Modulo = 'CR'    SELECT @Estatus = Estatus FROM CR 		WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   SELECT @Estatus = Estatus FROM Cambio 		WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   SELECT @Estatus = Estatus FROM Capital 		WHERE ID = @ID ELSE
IF @Modulo = 'INC'   SELECT @Estatus = Estatus FROM Incidencia 	WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  SELECT @Estatus = Estatus FROM Conciliacion	WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  SELECT @Estatus = Estatus FROM Presup		WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' SELECT @Estatus = Estatus FROM Credito		WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   SELECT @Estatus = Estatus FROM TMA 		WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   SELECT @Estatus = Estatus FROM RSS 		WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   SELECT @Estatus = Estatus FROM Campana		WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   SELECT @Estatus = Estatus FROM Fiscal		WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' SELECT @Estatus = Estatus FROM ContParalela	WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' SELECT @Estatus = Estatus FROM Oportunidad   WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' SELECT @Estatus = Estatus FROM Corte		    WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   SELECT @Estatus = Estatus FROM Organiza		WHERE ID = @ID ELSE
IF @Modulo = 'RE'    SELECT @Estatus = Estatus FROM Recluta		WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   SELECT @Estatus = Estatus FROM ISL		WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   SELECT @Estatus = Estatus FROM FormaExtra	WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  SELECT @Estatus = Estatus FROM Captura		WHERE ID = @ID ELSE
IF @Modulo = 'GES'   SELECT @Estatus = Estatus FROM Gestion		WHERE ID = @ID ELSE
IF @Modulo = 'CP'    SELECT @Estatus = Estatus FROM CP		WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   SELECT @Estatus = Estatus FROM PCP		WHERE ID = @ID ELSE
IF @Modulo = 'CONT'  SELECT @Estatus = Estatus FROM Cont 		WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  SELECT @Estatus = Estatus FROM Prod 		WHERE ID = @ID ELSE
IF @Modulo = 'INV'   SELECT @Estatus = Estatus FROM Inv 		WHERE ID = @ID ELSE
IF @Modulo = 'PC'    SELECT @Estatus = Estatus FROM PC 		WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  SELECT @Estatus = Estatus FROM Oferta		WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' SELECT @Estatus = Estatus FROM Contrato		WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   SELECT @Estatus = Estatus FROM Nomina 		WHERE ID = @ID ELSE
IF @Modulo = 'RH'    SELECT @Estatus = Estatus FROM RH 			WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  SELECT @Estatus = Estatus FROM Asiste 		WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   SELECT @Estatus = Estatus FROM Embarque 		WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  SELECT @Estatus = Estatus FROM SAUX 			WHERE ID = @ID
RETURN (@Estatus)
END

