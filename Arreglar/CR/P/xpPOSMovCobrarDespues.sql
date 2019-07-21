SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpPOSMovCobrarDespues
@ID						varchar(50),
@Codigo					varchar(30),
@Referencia				varchar(50),
@FormaPago				varchar(50),
@CtaDinero				varchar(10),
@ToleranciaRedondeo		float,
@CodigoAccion			varchar(50)		OUTPUT,
@Importe				float			OUTPUT,
@Saldo					float			OUTPUT,
@Ok						int				OUTPUT,
@OkRef					varchar(255)	OUTPUT
AS
BEGIN
RETURN
END

