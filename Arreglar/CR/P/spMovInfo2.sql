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
IF @Modulo = 'CONT'  SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Cont       WHERE ID = @ID ELSE
IF @Modulo = 'VTAS'  SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Venta      WHERE ID = @ID ELSE
IF @Modulo = 'PROD'  SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Prod       WHERE ID = @ID ELSE
IF @Modulo = 'INV'   SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Inv        WHERE ID = @ID ELSE
IF @Modulo = 'COMS'  SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Compra     WHERE ID = @ID ELSE
IF @Modulo = 'CXC'   SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Cxc        WHERE ID = @ID ELSE
IF @Modulo = 'CXP'   SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Cxp        WHERE ID = @ID ELSE
IF @Modulo = 'AGENT' SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Agent      WHERE ID = @ID ELSE
IF @Modulo = 'GAS'   SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Gasto      WHERE ID = @ID ELSE
IF @Modulo = 'DIN'   SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Dinero     WHERE ID = @ID ELSE
IF @Modulo = 'AF'    SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM ActivoFijo WHERE ID = @ID ELSE
IF @Modulo = 'PC'    SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM PC         WHERE ID = @ID ELSE
IF @Modulo = 'VALE'  SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Vale       WHERE ID = @ID ELSE
IF @Modulo = 'NOM'   SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Nomina     WHERE ID = @ID ELSE
IF @Modulo = 'RH'    SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM RH         WHERE ID = @ID ELSE
IF @Modulo = 'ASIS'  SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion FROM Asiste     WHERE ID = @ID ELSE
IF @Modulo = 'EMB'   SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion  FROM Embarque   WHERE ID = @ID ELSE
IF @Modulo = 'ST'    SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion  FROM Soporte    WHERE ID = @ID ELSE
IF @Modulo = 'CAM'   SELECT @Sucursal = Sucursal, @Mov = Mov, @MovID = MovID, @Situacion = Situacion  FROM Cambio     WHERE ID = @ID
RETURN
END

