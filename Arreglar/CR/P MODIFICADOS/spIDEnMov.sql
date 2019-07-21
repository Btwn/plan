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
IF @Modulo = 'CONT'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Cont WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda, @Almacen = Almacen, @AlmacenDestino = AlmacenDestino FROM Venta WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda, @Almacen = Almacen FROM Prod WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'INV'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda, @Almacen = Almacen, @AlmacenDestino = AlmacenDestino FROM Inv  WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda, @Almacen = Almacen FROM Compra WITH (NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Cxc        WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Cxp        WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Agent      WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Gasto      WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Dinero     WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'AF'    SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM ActivoFijo WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PC'    SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM PC         WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'OFER'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Oferta     WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Vale       WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CR'    SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM CR         WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Nomina     WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'RH'    SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM RH         WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Asiste     WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CAP'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Capital    WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'INC'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Incidencia WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CONC'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Conciliacion WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PPTO'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Presup    WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CREDI' SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Credito WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'TMA'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM TMA       WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'RSS'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM RSS       WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CMP'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM Campana   WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'FIS'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Fiscal WITH(NOLOCK)  WHERE ID = @ID ELSE
IF @Modulo = 'CONTP' SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM ContParalela WITH(NOLOCK)  WHERE ID = @ID ELSE
IF @Modulo = 'OPORT' SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Oportunidad  WITH (NOLOCK)   WHERE ID = @ID ELSE
IF @Modulo = 'CORTE' SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM Corte       WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'FRM'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM FormaExtra  WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CAPT'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM Captura     WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'GES'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM Gestion     WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CP'    SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM CP        WITH(NOLOCK)  WHERE ID = @ID ELSE
IF @Modulo = 'PCP'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM PCP       WITH(NOLOCK)  WHERE ID = @ID ELSE
IF @Modulo = 'PROY'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Proyecto  WITH(NOLOCK)  WHERE ID = @ID ELSE
IF @Modulo = 'ORG'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Organiza WITH(NOLOCK)  WHERE ID = @ID ELSE
IF @Modulo = 'RE'    SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Recluta  WITH(NOLOCK)   WHERE ID = @ID ELSE
IF @Modulo = 'ISL'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM ISL      WITH(NOLOCK)  WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM Embarque WITH (NOLOCK)  WHERE ID = @ID ELSE
IF @Modulo = 'ST'    SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM Soporte  WITH (NOLOCK)  WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID FROM Cambio   WITH (NOLOCK)  WHERE ID = @ID ELSE
IF @Modulo = 'PACTO' SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID, @Moneda = Moneda FROM Contrato WITH (NOLOCK)  WHERE ID = @ID ELSE
IF @Modulo = 'SAUX'  SELECT @Empresa = Empresa, @Mov = Mov, @MovID = MovID/*, @Moneda = Moneda*/ FROM SAUX WITH (NOLOCK) WHERE ID = @ID
IF @Empresa IS NULL SELECT @Ok = 60220
END

