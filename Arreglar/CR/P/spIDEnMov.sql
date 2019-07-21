SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spIDEnMov
@Modulo		char(5),
@ID		int,
@Empresa	char(5)  	OUTPUT,
@Mov		char(20) 	OUTPUT,
@MovID 		varchar(20) 	OUTPUT,
@Moneda		char(10) 	OUTPUT,
@Almacen	char(10) 	OUTPUT,
@AlmacenDestino char(10) 	OUTPUT,
@Ok		int	 	OUTPUT

AS BEGIN
SELECT @Empresa = NULL, @Mov = NULL, @MovID = NULL, @Moneda = NULL
IF @Modulo = 'CONT'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Cont       WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda, @Almacen = Almacen, @AlmacenDestino = AlmacenDestino FROM Venta WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda, @Almacen = Almacen FROM Prod WHERE ID = @ID ELSE
IF @Modulo = 'INV'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda, @Almacen = Almacen, @AlmacenDestino = AlmacenDestino FROM Inv   WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda, @Almacen = Almacen FROM Compra WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Cxc        WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Cxp        WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Agent      WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Gasto      WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Dinero     WHERE ID = @ID ELSE
IF @Modulo = 'AF'    SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM ActivoFijo WHERE ID = @ID ELSE
IF @Modulo = 'PC'    SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM PC         WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Oferta     WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Vale       WHERE ID = @ID ELSE
IF @Modulo = 'CR'    SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM CR         WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Nomina     WHERE ID = @ID ELSE
IF @Modulo = 'RH'    SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM RH         WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Asiste     WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Capital    WHERE ID = @ID ELSE
IF @Modulo = 'INC'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Incidencia WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Conciliacion WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Presup     WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Credito  WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM TMA        WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM RSS        WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM Campana    WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Fiscal  WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM ContParalela WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Oportunidad     WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM Corte      WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM FormaExtra  WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM Captura     WHERE ID = @ID ELSE
IF @Modulo = 'GES'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM Gestion     WHERE ID = @ID ELSE
IF @Modulo = 'CP'    SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM CP         WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM PCP        WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Proyecto   WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Organiza WHERE ID = @ID ELSE
IF @Modulo = 'RE'    SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Recluta  WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM ISL      WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM Embarque   WHERE ID = @ID ELSE
IF @Modulo = 'ST'    SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM Soporte    WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM Cambio     WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Contrato WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID/*, @Moneda = Moneda*/ FROM SAUX WHERE ID = @ID
IF @Empresa IS NULL SELECT @Ok = 60220
END

