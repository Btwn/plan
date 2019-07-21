SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSRevisaACZaragoza
@ID varchar(36)

AS
BEGIN
DECLARE
@Ok					int,
@OkReF				varchar(255),
@MovClave			varchar(20),
@Usuario			varchar(10),
@DefFormaPago		varchar(50)
SELECT @Ok = 0, @OkReF = NULL
SELECT @MovClave = m.Clave, @Usuario = p.Usuario
FROM POSL p WITH (NOLOCK)
JOIN MovTipo m WITH (NOLOCK) ON p.Mov = m.Mov AND m.Modulo = 'POS'
WHERE p.ID = @ID
SELECT @DefFormaPago = ISNULL(NULLIF(DefFormaPago,''),'EFECTIVO')
FROM Usuario WITH (NOLOCK)
WHERE Usuario = @Usuario
IF EXISTS (SELECT * FROM POSLCobro WITH (NOLOCK) WHERE ID = @ID AND FormaPago <> @DefFormaPago) AND @MovClave IN ('POS.AC', 'POS.ACM')
SELECT @Ok = 1
IF @Ok = 1
SELECT @OkReF = 'No se puede realizar Aperturas con una Forma Pago diferente a Efectivo'
SELECT @OkReF
END

