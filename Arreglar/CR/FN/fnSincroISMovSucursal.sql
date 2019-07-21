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
IF @Modulo = 'VTAS'  SELECT @Sucursal = Sucursal   FROM Venta        WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  SELECT @Sucursal = Sucursal   FROM Compra       WHERE ID = @ID ELSE
IF @Modulo = 'ST'    SELECT @Sucursal = Sucursal   FROM Soporte      WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   SELECT @Sucursal = Sucursal   FROM Embarque     WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   SELECT @Sucursal = Sucursal   FROM Dinero       WHERE ID = @ID ELSE
IF @Modulo = 'AF'    SELECT @Sucursal = Sucursal   FROM ActivoFijo   WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   SELECT @Sucursal = Sucursal   FROM Nomina       WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  SELECT @Sucursal = Sucursal   FROM Asiste       WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   SELECT @Sucursal = Sucursal   FROM Gasto        WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   SELECT @Sucursal = Sucursal   FROM Capital      WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   SELECT @Sucursal = Sucursal   FROM Cambio       WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  SELECT @Sucursal = Sucursal   FROM Proyecto     WHERE ID = @ID ELSE
IF @Modulo = 'INC'   SELECT @Sucursal = Sucursal   FROM Incidencia   WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  SELECT @Sucursal = Sucursal   FROM Conciliacion WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  SELECT @Sucursal = Sucursal   FROM Presup       WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' SELECT @Sucursal = Sucursal   FROM Credito      WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   SELECT @Sucursal = Sucursal   FROM Campana      WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   SELECT @Sucursal = Sucursal   FROM Fiscal       WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' SELECT @Sucursal = Sucursal   FROM ContParalela WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' SELECT @Sucursal = Sucursal   FROM Oportunidad  WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' SELECT @Sucursal = Sucursal   FROM Corte        WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   SELECT @Sucursal = Sucursal   FROM Organiza     WHERE ID = @ID ELSE
IF @Modulo = 'RE'    SELECT @Sucursal = Sucursal   FROM Recluta      WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   SELECT @Sucursal = Sucursal   FROM FormaExtra   WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  SELECT @Sucursal = Sucursal   FROM Captura      WHERE ID = @ID ELSE
IF @Modulo = 'GES'   SELECT @Sucursal = Sucursal   FROM Gestion      WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  SELECT @Sucursal = Sucursal   FROM Oferta       WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' SELECT @Sucursal = Sucursal   FROM Contrato     WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   SELECT @Sucursal = Sucursal   FROM Cxp          WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   SELECT @Sucursal = Sucursal   FROM TMA          WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' SELECT @Sucursal = Sucursal   FROM AGENT        WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   SELECT @Sucursal = Sucursal    FROM ISL          WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  SELECT @Sucursal = Sucursal    FROM PROD         WHERE ID = @ID ELSE
IF @Modulo = 'CONT'  SELECT @Sucursal = Sucursal    FROM CONT         WHERE ID = @ID ELSE
IF @Modulo = 'CP'    SELECT @Sucursal = Sucursal    FROM CP           WHERE ID = @ID ELSE
IF @Modulo = 'PC'    SELECT @Sucursal = Sucursal    FROM PC           WHERE ID = @ID ELSE
IF @Modulo = 'RH'    SELECT @Sucursal = Sucursal    FROM RH           WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   SELECT @Sucursal = Sucursal    FROM CXC          WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  SELECT @Sucursal = Sucursal    FROM VALE         WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   SELECT @Sucursal = Sucursal    FROM RSS          WHERE ID = @ID ELSE
IF @Modulo = 'CR'    SELECT @Sucursal = Sucursal    FROM CR           WHERE ID = @ID ELSE
IF @Modulo = 'INV'   SELECT @Sucursal = Sucursal    FROM INV          WHERE ID = @ID
ELSE SET @Sucursal = NULL
RETURN (@Sucursal)
END

