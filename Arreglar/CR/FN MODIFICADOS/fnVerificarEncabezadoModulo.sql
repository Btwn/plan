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
IF @Modulo = 'VTAS'  IF EXISTS(SELECT ID FROM Venta         WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'COMS'  IF EXISTS(SELECT ID FROM Compra        WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'ST'    IF EXISTS(SELECT ID FROM Soporte       WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'EMB'   IF EXISTS(SELECT ID FROM Embarque      WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'DIN'   IF EXISTS(SELECT ID FROM Dinero        WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'AF'    IF EXISTS(SELECT ID FROM ActivoFijo    WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'NOM'   IF EXISTS(SELECT ID FROM Nomina        WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'ASIS'  IF EXISTS(SELECT ID FROM Asiste        WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'GAS'   IF EXISTS(SELECT ID FROM Gasto         WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CAP'   IF EXISTS(SELECT ID FROM Capital       WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CAM'   IF EXISTS(SELECT ID FROM Cambio        WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'PROY'  IF EXISTS(SELECT ID FROM Proyecto      WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'INC'   IF EXISTS(SELECT ID FROM Incidencia    WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CONC'  IF EXISTS(SELECT ID FROM Conciliacion  WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'PPTO'  IF EXISTS(SELECT ID FROM Presup        WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CREDI' IF EXISTS(SELECT ID FROM Credito       WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CMP'   IF EXISTS(SELECT ID FROM Campana       WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'FIS'   IF EXISTS(SELECT ID FROM Fiscal        WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CONTP' IF EXISTS(SELECT ID FROM ContParalela  WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'OPORT' IF EXISTS(SELECT ID FROM Oportunidad   WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CORTE' IF EXISTS(SELECT ID FROM Corte         WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'ORG'   IF EXISTS(SELECT ID FROM Organiza      WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'RE'	   IF EXISTS(SELECT ID FROM Recluta       WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'FRM'   IF EXISTS(SELECT ID FROM FormaExtra    WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CAPT'  IF EXISTS(SELECT ID FROM Captura       WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'GES'   IF EXISTS(SELECT ID FROM Gestion       WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'OFER'  IF EXISTS(SELECT ID FROM Oferta        WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'PACTO' IF EXISTS(SELECT ID FROM Contrato      WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CXC'   IF EXISTS(SELECT ID FROM Cxc           WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CXP'   IF EXISTS(SELECT ID FROM Cxp           WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'INV'   IF EXISTS(SELECT ID FROM Inv           WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'AGENT' IF EXISTS(SELECT ID FROM Agent         WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'PROD'  IF EXISTS(SELECT ID FROM Prod          WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CONT'  IF EXISTS(SELECT ID FROM Cont          WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CP'    IF EXISTS(SELECT ID FROM CP            WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'CR'    IF EXISTS(SELECT ID FROM CR            WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'ISL'   IF EXISTS(SELECT ID FROM ISL           WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'PC'    IF EXISTS(SELECT ID FROM PC            WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'RH'    IF EXISTS(SELECT ID FROM RH            WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'RSS'   IF EXISTS(SELECT ID FROM RSS           WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'TMA'   IF EXISTS(SELECT ID FROM TMA           WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0 ELSE
IF @Modulo = 'VALE'  IF EXISTS(SELECT ID FROM Vale          WITH(NOLOCK) WHERE ID = @ID) SELECT @Resultado = 1 ELSE SELECT @Resultado = 0
RETURN (@Resultado)
END

