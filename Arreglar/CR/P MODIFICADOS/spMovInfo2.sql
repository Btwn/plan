SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovInfo2
@ID		int,
@Modulo		char(5),
@Sucursal	int 		OUTPUT,
@Mov		char(20) 	OUTPUT,
@MovID		varchar(20) 	OUTPUT,
@Situacion	varchar(50) 	OUTPUT

AS BEGIN
SELECT @Sucursal = NULL, @Mov = NULL, @MovID = NULL, @Situacion = NULL
IF @Modulo = 'CONT'  SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Cont     WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Venta    WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Prod     WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'INV'   SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Inv      WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Compra   WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Cxc      WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Cxp      WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Agent    WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Gasto    WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Dinero   WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'AF'    SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM ActivoFijo WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PC'    SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM PC       WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Vale     WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Nomina   WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'RH'    SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM RH       WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Asiste   WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion  FROM Embarque WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'ST'    SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion  FROM Soporte  WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion  FROM Cambio   WITH(NOLOCK) WHERE ID = @ID
RETURN
END

