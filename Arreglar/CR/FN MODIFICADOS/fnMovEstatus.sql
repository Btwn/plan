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
IF @Modulo = 'VTAS'  SELECT @Estatus = Estatus FROM Venta 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   SELECT @Estatus = Estatus FROM Cxc 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'ST'    SELECT @Estatus = Estatus FROM Soporte 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  SELECT @Estatus = Estatus FROM Compra 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   SELECT @Estatus = Estatus FROM Cxp 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' SELECT @Estatus = Estatus FROM Agent 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   SELECT @Estatus = Estatus FROM Gasto 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   SELECT @Estatus = Estatus FROM Dinero    	WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'AF'    SELECT @Estatus = Estatus FROM ActivoFijo 	WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  SELECT @Estatus = Estatus FROM Vale 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CR'    SELECT @Estatus = Estatus FROM CR 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   SELECT @Estatus = Estatus FROM Cambio 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   SELECT @Estatus = Estatus FROM Capital 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'INC'   SELECT @Estatus = Estatus FROM Incidencia 	WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  SELECT @Estatus = Estatus FROM Conciliacion	WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  SELECT @Estatus = Estatus FROM Presup		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' SELECT @Estatus = Estatus FROM Credito		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   SELECT @Estatus = Estatus FROM TMA 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   SELECT @Estatus = Estatus FROM RSS 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   SELECT @Estatus = Estatus FROM Campana		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   SELECT @Estatus = Estatus FROM Fiscal		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' SELECT @Estatus = Estatus FROM ContParalela	WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' SELECT @Estatus = Estatus FROM Oportunidad   WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' SELECT @Estatus = Estatus FROM Corte		    WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   SELECT @Estatus = Estatus FROM Organiza		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'RE'    SELECT @Estatus = Estatus FROM Recluta		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   SELECT @Estatus = Estatus FROM ISL		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   SELECT @Estatus = Estatus FROM FormaExtra	WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  SELECT @Estatus = Estatus FROM Captura		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'GES'   SELECT @Estatus = Estatus FROM Gestion		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CP'    SELECT @Estatus = Estatus FROM CP		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   SELECT @Estatus = Estatus FROM PCP		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CONT'  SELECT @Estatus = Estatus FROM Cont 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  SELECT @Estatus = Estatus FROM Prod 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'INV'   SELECT @Estatus = Estatus FROM Inv 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PC'    SELECT @Estatus = Estatus FROM PC 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  SELECT @Estatus = Estatus FROM Oferta		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' SELECT @Estatus = Estatus FROM Contrato		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   SELECT @Estatus = Estatus FROM Nomina 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'RH'    SELECT @Estatus = Estatus FROM RH 			WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  SELECT @Estatus = Estatus FROM Asiste 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   SELECT @Estatus = Estatus FROM Embarque 		WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  SELECT @Estatus = Estatus FROM SAUX 			WITH(NOLOCK) WHERE ID = @ID
RETURN (@Estatus)
END

