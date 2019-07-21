SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSincroISMovSucursal (@Modulo varchar(5), @ID int)
RETURNS varchar(50)

AS BEGIN
DECLARE
@Sucursal	int
SELECT @Sucursal = NULL
IF @Modulo = 'VTAS'  SELECT @Sucursal = Sucursal   FROM Venta         WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  SELECT @Sucursal = Sucursal   FROM Compra        WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'ST'    SELECT @Sucursal = Sucursal   FROM Soporte       WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   SELECT @Sucursal = Sucursal   FROM Embarque      WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   SELECT @Sucursal = Sucursal   FROM Dinero        WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'AF'    SELECT @Sucursal = Sucursal   FROM ActivoFijo    WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   SELECT @Sucursal = Sucursal   FROM Nomina        WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  SELECT @Sucursal = Sucursal   FROM Asiste        WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   SELECT @Sucursal = Sucursal   FROM Gasto         WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   SELECT @Sucursal = Sucursal   FROM Capital       WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   SELECT @Sucursal = Sucursal   FROM Cambio        WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  SELECT @Sucursal = Sucursal   FROM Proyecto      WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'INC'   SELECT @Sucursal = Sucursal   FROM Incidencia    WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  SELECT @Sucursal = Sucursal   FROM Conciliacion  WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  SELECT @Sucursal = Sucursal   FROM Presup        WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' SELECT @Sucursal = Sucursal   FROM Credito       WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   SELECT @Sucursal = Sucursal   FROM Campana       WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   SELECT @Sucursal = Sucursal   FROM Fiscal        WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' SELECT @Sucursal = Sucursal   FROM ContParalela  WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' SELECT @Sucursal = Sucursal   FROM Oportunidad   WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' SELECT @Sucursal = Sucursal   FROM Corte         WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   SELECT @Sucursal = Sucursal   FROM Organiza      WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'RE'    SELECT @Sucursal = Sucursal   FROM Recluta       WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   SELECT @Sucursal = Sucursal   FROM FormaExtra    WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  SELECT @Sucursal = Sucursal   FROM Captura       WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'GES'   SELECT @Sucursal = Sucursal   FROM Gestion       WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  SELECT @Sucursal = Sucursal   FROM Oferta        WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' SELECT @Sucursal = Sucursal   FROM Contrato      WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   SELECT @Sucursal = Sucursal   FROM Cxp           WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   SELECT @Sucursal = Sucursal   FROM TMA           WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' SELECT @Sucursal = Sucursal   FROM AGENT         WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   SELECT @Sucursal = Sucursal    FROM ISL           WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  SELECT @Sucursal = Sucursal    FROM PROD          WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CONT'  SELECT @Sucursal = Sucursal    FROM CONT          WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CP'    SELECT @Sucursal = Sucursal    FROM CP            WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PC'    SELECT @Sucursal = Sucursal    FROM PC            WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'RH'    SELECT @Sucursal = Sucursal    FROM RH            WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   SELECT @Sucursal = Sucursal    FROM CXC           WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  SELECT @Sucursal = Sucursal    FROM VALE          WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   SELECT @Sucursal = Sucursal    FROM RSS           WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CR'    SELECT @Sucursal = Sucursal    FROM CR            WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'INV'   SELECT @Sucursal = Sucursal    FROM INV           WITH(NOLOCK) WHERE ID = @ID
ELSE SET @Sucursal = NULL
RETURN (@Sucursal)
END

