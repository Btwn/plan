SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spContParalelaMovEnID
@Modulo		char(5),
@Empresa	char(5),
@Mov		char(20),
@MovID 		varchar(20),
@ID			int			OUTPUT,
@Moneda		char(10)	OUTPUT,
@Ok			int 		OUTPUT

AS BEGIN
SELECT @ID = NULL
IF @Modulo = 'CONT'  SELECT @ID = ID, @Moneda = Moneda FROM Cont         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'VTAS'  SELECT @ID = ID, @Moneda = Moneda FROM Venta        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'PROD'  SELECT @ID = ID, @Moneda = Moneda FROM Prod         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'COMS'  SELECT @ID = ID, @Moneda = Moneda FROM Compra       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'INV'   SELECT @ID = ID, @Moneda = Moneda FROM Inv          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('CANCELADO') ELSE
IF @Modulo = 'CXC'   SELECT @ID = ID, @Moneda = Moneda FROM Cxc          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'CXP'   SELECT @ID = ID, @Moneda = Moneda FROM Cxp          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'AGENT' SELECT @ID = ID, @Moneda = Moneda FROM Agent        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'GAS'   SELECT @ID = ID, @Moneda = Moneda FROM Gasto        WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'DIN'   SELECT @ID = ID, @Moneda = Moneda FROM Dinero       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'EMB'   SELECT @ID = ID 		   	 FROM Embarque     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'NOM'   SELECT @ID = ID, @Moneda = Moneda FROM Nomina       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'RH'    SELECT @ID = ID, @Moneda = Moneda FROM RH           WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'ASIS'  SELECT @ID = ID, @Moneda = Moneda FROM Asiste       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('CANCELADO') ELSE
IF @Modulo = 'AF'    SELECT @ID = ID, @Moneda = Moneda FROM ActivoFijo   WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'PC'    SELECT @ID = ID, @Moneda = Moneda FROM PC           WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'OFER'  SELECT @ID = ID, @Moneda = Moneda FROM Oferta       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'VALE'  SELECT @ID = ID, @Moneda = Moneda FROM Vale         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'CR'    SELECT @ID = ID, @Moneda = Moneda FROM CR           WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'ST'    SELECT @ID = ID 			 FROM Soporte      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'CAP'   SELECT @ID = ID, @Moneda = Moneda FROM Capital      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'INC'   SELECT @ID = ID, @Moneda = Moneda FROM Incidencia   WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'CONC'  SELECT @ID = ID, @Moneda = Moneda FROM Conciliacion WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'PPTO'  SELECT @ID = ID, @Moneda = Moneda FROM Presup       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'CREDI' SELECT @ID = ID, @Moneda = Moneda FROM Credito      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'TMA'   SELECT @ID = ID 			 FROM TMA          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'RSS'   SELECT @ID = ID 			 FROM RSS          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'CMP'   SELECT @ID = ID 			 FROM Campana      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'FIS'   SELECT @ID = ID, @Moneda = Moneda FROM Fiscal   WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'CONTP' SELECT @ID = ID           FROM ContParalela   WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'OPORT' SELECT @ID = ID, @Moneda = Moneda FROM Oportunidad      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'CORTE' SELECT @ID = ID           FROM Corte       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'FRM'   SELECT @ID = ID 			 FROM FormaExtra   WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'CAPT'  SELECT @ID = ID 			 FROM Captura      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'GES'   SELECT @ID = ID 			 FROM Gestion      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'CP'    SELECT @ID = ID, @Moneda = Moneda FROM CP           WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'PCP'   SELECT @ID = ID, @Moneda = Moneda FROM PCP          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'PROY'  SELECT @ID = ID, @Moneda = Moneda FROM Proyecto     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'ORG'   SELECT @ID = ID, @Moneda = Moneda FROM Organiza     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'RE'    SELECT @ID = ID, @Moneda = Moneda FROM Recluta      WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'ISL'   SELECT @ID = ID, @Moneda = Moneda FROM ISL          WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'CAM'   SELECT @ID = ID 			         FROM Cambio       WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'PACTO' SELECT @ID = ID, @Moneda = Moneda FROM Contrato     WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL') ELSE
IF @Modulo = 'SAUX'  SELECT @ID = ID                   FROM SAUX         WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'BORRADOR', 'EMAIL')
IF @ID IS NULL SELECT @Ok = 60220
END

