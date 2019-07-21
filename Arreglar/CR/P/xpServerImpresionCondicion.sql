SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpServerImpresionCondicion
@Empresa varchar(10),
@Modulo		char(5),
@Mov		varchar(20),
@Serie		varchar(20),
@MovID		varchar(20),
@Estatus	varchar(20)
AS BEGIN
DECLARE @ID int
/*
IF @Modulo ='VTAS' and @mOV = 'FACTURA' AND @Empresa = 'DEMO'
BEGIN
EXEC spMovInfo @Modulo = @Modulo, @Empresa = @Empresa, @Mov = @Mov, @MovID = @MovID, @ID = @ID OUTPUT
EXEC xpMostrarAccion @empresa, @Mov, @ID, @Modulo, 'IMPRIMIR'
END
ELSE*/
SELECT 'Imprimir' = 1
RETURN
END

