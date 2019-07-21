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
IF @Modulo = 'CONT'  SELECT @ID = MAX(ID) FROM Cont       WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'VTAS'  SELECT @ID = MAX(ID) FROM Venta      WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'PROD'  SELECT @ID = MAX(ID) FROM Prod       WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'COMS'  SELECT @ID = MAX(ID) FROM Compra     WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'INV'   SELECT @ID = MAX(ID) FROM Inv        WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CXC'   SELECT @ID = MAX(ID) FROM Cxc        WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CXP'   SELECT @ID = MAX(ID) FROM Cxp        WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'AGENT' SELECT @ID = MAX(ID) FROM Agent      WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'GAS'   SELECT @ID = MAX(ID) FROM Gasto      WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'DIN'   SELECT @ID = MAX(ID) FROM Dinero     WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'EMB'   SELECT @ID = MAX(ID) FROM Embarque   WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'NOM'   SELECT @ID = MAX(ID) FROM Nomina     WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'RH'    SELECT @ID = MAX(ID) FROM RH         WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'ASIS'  SELECT @ID = MAX(ID) FROM Asiste     WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'AF'    SELECT @ID = MAX(ID) FROM ActivoFijo WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'PC'    SELECT @ID = MAX(ID) FROM PC         WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'OFER'  SELECT @ID = MAX(ID) FROM Oferta     WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'VALE'  SELECT @ID = MAX(ID) FROM Vale       WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CR'    SELECT @ID = MAX(ID) FROM CR         WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'ST'    SELECT @ID = MAX(ID) FROM Soporte    WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CAP'   SELECT @ID = MAX(ID) FROM Capital    WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'INC'   SELECT @ID = MAX(ID) FROM Incidencia WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CONC'  SELECT @ID = MAX(ID) FROM Conciliacion WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'PPTO'  SELECT @ID = MAX(ID) FROM Presup     WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CREDI' SELECT @ID = MAX(ID) FROM Credito    WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'TMA'   SELECT @ID = MAX(ID) FROM TMA        WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'RSS'   SELECT @ID = MAX(ID) FROM RSS        WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CMP'   SELECT @ID = MAX(ID) FROM Campana    WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'FIS'   SELECT @ID = MAX(ID) FROM Fiscal     WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CONTP' SELECT @ID = MAX(ID) FROM ContParalela WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'OPORT' SELECT @ID = MAX(ID) FROM Oportunidad WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CORTE' SELECT @ID = MAX(ID) FROM Corte      WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'FRM'   SELECT @ID = MAX(ID) FROM FormaExtra WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CAPT'  SELECT @ID = MAX(ID) FROM Captura    WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'GES'   SELECT @ID = MAX(ID) FROM Gestion    WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CP'    SELECT @ID = MAX(ID) FROM CP         WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'PCP'   SELECT @ID = MAX(ID) FROM PCP        WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'PROY'  SELECT @ID = MAX(ID) FROM Proyecto   WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'ORG'   SELECT @ID = MAX(ID) FROM Organiza   WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'RE'    SELECT @ID = MAX(ID) FROM Recluta    WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'ISL'   SELECT @ID = MAX(ID) FROM ISL        WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'CAM'   SELECT @ID = MAX(ID) FROM Cambio     WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'PACTO' SELECT @ID = MAX(ID) FROM Contrato   WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID ELSE
IF @Modulo = 'SAUX'  SELECT @ID = MAX(ID) FROM SAUX       WITH(NOLOCK) WHERE Empresa = @Empresa AND Mov = @Mov AND MovID = @MovID
END

