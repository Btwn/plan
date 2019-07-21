SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCancelarCFD
@Modulo		varchar(10),
@ID		int

AS BEGIN
DECLARE
@Mov        varchar(20),
@MovID      varchar(20),
@Fecha      datetime,
@Nombre     varchar(40),
@Estatus    varchar(15),
@Sucursal   int,
@Usuario    varchar(10)
IF @Modulo = 'VTAS'
SELECT @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Sucursal = Sucursal, @Usuario = Usuario FROM Venta WITH (NOLOCK) WHERE ID = @ID
IF @Modulo = 'COMS'
SELECT @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Sucursal = Sucursal, @Usuario = Usuario FROM Compra WITH (NOLOCK) WHERE ID = @ID
IF @Modulo = 'CXC'
SELECT @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Sucursal = Sucursal, @Usuario = Usuario FROM Cxc WITH (NOLOCK) WHERE ID = @ID
IF @Modulo = 'CXP'
SELECT @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Sucursal = Sucursal, @Usuario = Usuario FROM Cxp WITH (NOLOCK) WHERE ID = @ID
IF @Estatus = 'CANCELADO'
BEGIN
UPDATE CFD WITH (ROWLOCK) SET Cancelado = 1 WHERE Modulo = @Modulo AND ModuloID=@ID
END
RETURN
END

