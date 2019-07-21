SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION [dbo].[fnSaldoPendienteMovPadreMAVI](@ID int)
RETURNS money
AS
BEGIN
DECLARE
@Saldo   money,
@Mov   varchar(20),
@MovID   varchar(20),
@HayNotas int
DECLARE  @DocPendtes TABLE(Saldo money,Mov varchar(20),MovID varchar(20))
SELECT @Saldo = 0.0
IF EXISTS(SELECT ID FROM Cxc WHERE ID = @ID AND Estatus IN('CONCLUIDO','PENDIENTE'))  
BEGIN
SELECT @Mov = Mov, @MovID = MovID FROM Cxc WHERE ID = @ID
IF ((SELECT Estatus FROM Cxc WHERE ID = @ID)='PENDIENTE')
SELECT @Saldo = ISNULL(Saldo,0.0) FROM Cxc WHERE ID = @ID    
ELSE
BEGIN
INSERT @DocPendtes(Saldo,Mov ,MovID)
SELECT Saldo,Mov, MovID FROM Cxc WHERE Origen = @Mov AND OrigenID = @MovID AND Estatus = 'PENDIENTE'
SELECT @HayNotas = ISNULL(count(mov),0) from Cxc Where PadreIDMAVI = @MovID and PadreMAVI= @Mov and Estatus='PENDIENTE' and Mov = 'Nota Cargo' and Concepto IN('CANC COBRO FACTURA','CANC COBRO CRED Y PP')
IF @HayNotas <> 0
BEGIN
INSERT @DocPendtes(Saldo,Mov ,MovID)
SELECT Saldo,Mov,MovID from Cxc Where PadreIDMAVI = @MovID and PadreMAVI= @Mov and Estatus='PENDIENTE' and Mov = 'Nota Cargo' and Concepto IN('CANC COBRO FACTURA','CANC COBRO CRED Y PP')
END
SELECT @Saldo = SUM(ISNULL(Saldo,0.0)) FROM @DocPendtes
END
END
RETURN (@Saldo)
END

