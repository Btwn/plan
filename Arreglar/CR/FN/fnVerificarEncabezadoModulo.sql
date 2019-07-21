SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnVerificarEncabezadoModulo
(
@ID					int,
@Modulo				varchar(5)
)
RETURNS bit

AS BEGIN
DECLARE
@Resultado				bit
SELECT @Resultado = 0
IF @Modulo = 'VTAS'  IF EXISTS(SELECT ID FROM Venta        WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'COMS'  IF EXISTS(SELECT ID FROM Compra       WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'ST'    IF EXISTS(SELECT ID FROM Soporte      WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'EMB'   IF EXISTS(SELECT ID FROM Embarque     WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'DIN'   IF EXISTS(SELECT ID FROM Dinero       WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'AF'    IF EXISTS(SELECT ID FROM ActivoFijo   WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'NOM'   IF EXISTS(SELECT ID FROM Nomina       WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'ASIS'  IF EXISTS(SELECT ID FROM Asiste       WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'GAS'   IF EXISTS(SELECT ID FROM Gasto        WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CAP'   IF EXISTS(SELECT ID FROM Capital      WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CAM'   IF EXISTS(SELECT ID FROM Cambio       WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'PROY'  IF EXISTS(SELECT ID FROM Proyecto     WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'INC'   IF EXISTS(SELECT ID FROM Incidencia   WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CONC'  IF EXISTS(SELECT ID FROM Conciliacion WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'PPTO'  IF EXISTS(SELECT ID FROM Presup       WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CREDI' IF EXISTS(SELECT ID FROM Credito      WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CMP'   IF EXISTS(SELECT ID FROM Campana      WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'FIS'   IF EXISTS(SELECT ID FROM Fiscal       WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CONTP' IF EXISTS(SELECT ID FROM ContParalela WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'OPORT' IF EXISTS(SELECT ID FROM Oportunidad  WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CORTE' IF EXISTS(SELECT ID FROM Corte        WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'ORG'   IF EXISTS(SELECT ID FROM Organiza     WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'RE'	   IF EXISTS(SELECT ID FROM Recluta      WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'FRM'   IF EXISTS(SELECT ID FROM FormaExtra   WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CAPT'  IF EXISTS(SELECT ID FROM Captura      WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'GES'   IF EXISTS(SELECT ID FROM Gestion      WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'OFER'  IF EXISTS(SELECT ID FROM Oferta       WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'PACTO' IF EXISTS(SELECT ID FROM Contrato     WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CXC'   IF EXISTS(SELECT ID FROM Cxc          WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CXP'   IF EXISTS(SELECT ID FROM Cxp          WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'INV'   IF EXISTS(SELECT ID FROM Inv          WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'AGENT' IF EXISTS(SELECT ID FROM Agent        WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'PROD'  IF EXISTS(SELECT ID FROM Prod         WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CONT'  IF EXISTS(SELECT ID FROM Cont         WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CP'    IF EXISTS(SELECT ID FROM CP           WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CR'    IF EXISTS(SELECT ID FROM CR           WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'ISL'   IF EXISTS(SELECT ID FROM ISL          WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'PC'    IF EXISTS(SELECT ID FROM PC           WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'RH'    IF EXISTS(SELECT ID FROM RH           WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'RSS'   IF EXISTS(SELECT ID FROM RSS          WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'TMA'   IF EXISTS(SELECT ID FROM TMA          WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'VALE'  IF EXISTS(SELECT ID FROM Vale         WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0
RETURN (@Resultado)
END

