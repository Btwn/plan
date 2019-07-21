SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpDineroOrigenFactorMovImpuesto
@Sucursal			int,
@ID		  			int,
@Accion				char(20),
@Empresa			char(5),
@Usuario			char(10),
@Modulo				char(5),
@Mov				char(20),
@MovID				varchar(20),
@MovTipo			char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@OrigenID			int,
@OrigenMov			char(20),
@OrigenMovID		varchar(20),
@OrigenTipo		char(20),
@OrigenImporte		money,
@VerificarOrigen	bit,
@OrigenFactor		float			OUTPUT,
@Ok 				int				OUTPUT,
@OkRef 				varchar(255)	OUTPUT
AS BEGIN
RETURN
END

