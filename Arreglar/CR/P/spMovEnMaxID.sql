SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovEnMaxID
@Modulo		char(5),
@Empresa	char(5),
@Mov		char(20),
@MovID 		varchar(20),
@ID		int	 OUTPUT,
@Ok		int 	 OUTPUT

AS BEGIN
SELECT @ID = NULL
IF @Modulo = 'CONT'  SELECT @ID = MAX(ID) FROM Cont         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'VTAS'  SELECT @ID = MAX(ID) FROM Venta        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'PROD'  SELECT @ID = MAX(ID) FROM Prod         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'COMS'  SELECT @ID = MAX(ID) FROM Compra       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'INV'   SELECT @ID = MAX(ID) FROM Inv          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CXC'   SELECT @ID = MAX(ID) FROM Cxc          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CXP'   SELECT @ID = MAX(ID) FROM Cxp          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'AGENT' SELECT @ID = MAX(ID) FROM Agent        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'GAS'   SELECT @ID = MAX(ID) FROM Gasto        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'DIN'   SELECT @ID = MAX(ID) FROM Dinero       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'EMB'   SELECT @ID = MAX(ID) FROM Embarque     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'NOM'   SELECT @ID = MAX(ID) FROM Nomina       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'RH'    SELECT @ID = MAX(ID) FROM RH           WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'ASIS'  SELECT @ID = MAX(ID) FROM Asiste       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'AF'    SELECT @ID = MAX(ID) FROM ActivoFijo   WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'PC'    SELECT @ID = MAX(ID) FROM PC           WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'OFER'  SELECT @ID = MAX(ID) FROM Oferta       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'VALE'  SELECT @ID = MAX(ID) FROM Vale         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CR'    SELECT @ID = MAX(ID) FROM CR           WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'ST'    SELECT @ID = MAX(ID) FROM Soporte      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CAP'   SELECT @ID = MAX(ID) FROM Capital      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'INC'   SELECT @ID = MAX(ID) FROM Incidencia   WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CONC'  SELECT @ID = MAX(ID) FROM Conciliacion WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'PPTO'  SELECT @ID = MAX(ID) FROM Presup       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CREDI' SELECT @ID = MAX(ID) FROM Credito      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'TMA'   SELECT @ID = MAX(ID) FROM TMA          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'RSS'   SELECT @ID = MAX(ID) FROM RSS          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CMP'   SELECT @ID = MAX(ID) FROM Campana      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'FIS'   SELECT @ID = MAX(ID) FROM Fiscal       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CONTP' SELECT @ID = MAX(ID) FROM ContParalela WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'OPORT' SELECT @ID = MAX(ID) FROM Oportunidad  WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CORTE' SELECT @ID = MAX(ID) FROM Corte        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'FRM'   SELECT @ID = MAX(ID) FROM FormaExtra   WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CAPT'  SELECT @ID = MAX(ID) FROM Captura      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'GES'   SELECT @ID = MAX(ID) FROM Gestion      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CP'    SELECT @ID = MAX(ID) FROM CP           WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'PCP'   SELECT @ID = MAX(ID) FROM PCP          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'PROY'  SELECT @ID = MAX(ID) FROM Proyecto     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'ORG'   SELECT @ID = MAX(ID) FROM Organiza     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'RE'    SELECT @ID = MAX(ID) FROM Recluta      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'ISL'   SELECT @ID = MAX(ID) FROM ISL          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CAM'   SELECT @ID = MAX(ID) FROM Cambio       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'PACTO' SELECT @ID = MAX(ID) FROM Contrato     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'SAUX'  SELECT @ID = MAX(ID) FROM SAUX         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID
END

