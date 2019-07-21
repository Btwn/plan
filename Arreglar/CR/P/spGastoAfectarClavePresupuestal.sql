SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoAfectarClavePresupuestal
@ID               		int,
@Accion			char(20),
@Empresa          		char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              		char(20),
@MovID			varchar(20),
@MovTipo	      		char(20),
@MovMoneda			char(10),
@FechaEmision		datetime,
@Estatus			char(15),
@EstatusNuevo		char(15),
@Acreedor			char(10),
@Ok				int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@OrigenTipo		char(5),
@Origen			varchar(20),
@Clave			varchar(20),
@OrigenID		varchar(20),
@IDOrigen		int,
@Proyecto		varchar(50)
SELECT
@OrigenTipo = OrigenTipo,
@Origen		= Origen,
@OrigenID	= OrigenID
FROM Gasto
WHERE ID = @ID
SELECT @Clave = Clave FROM MovTipo WHERE Modulo = @OrigenTipo AND Mov = @Origen
IF @OrigenTipo = 'NOM' AND @Clave = 'NOM.N'
BEGIN
SELECT @IDOrigen = ID FROM Nomina WHERE Mov = @Origen AND MovID = @OrigenID AND Empresa = @Empresa
SELECT @Proyecto = Proyecto FROM Nomina WHERE ID = @IDOrigen
UPDATE Gasto
SET Proyecto = @Proyecto
WHERE ID = @ID
END
RETURN
END

