SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOrigenCobrosInstMAVI
@IDCobro   int

AS BEGIN
DECLARE
@Mov    varchar(20),
@ID     int,
@MovID    varchar(20),
@MovOrigen   varchar(20),
@MovIDOrigen  varchar(20),
@OrigenID   varchar(20),
@Origen    varchar(20)
IF EXISTS(SELECT * FROM NegociaMoratoriosMAVI WHERE IDCobro = @IDCobro AND Mov in ('Contra Recibo','Contra Recibo Inst'))
BEGIN
DECLARE crActOrigenCR CURSOR FOR
SELECT ID, Mov, MovId FROM NegociaMoratoriosMAVI WHERE IDCobro = @IDCobro AND Mov in ('Contra Recibo','Contra Recibo Inst')
OPEN crActOrigenCR
FETCH NEXT FROM crActOrigenCR INTO @ID, @Mov, @MovId
WHILE @@FETCH_STATUS <> -1
BEGIN  
IF @@FETCH_STATUS <> -2
BEGIN  
SELECT @Origen = Origen,
@OrigenID = OrigenID
FROM CXC
WHERE Mov = @Mov AND MovID = @MovId
SELECT @MovOrigen = Origen,
@MovIDOrigen = OrigenID
FROM CXC
WHERE Mov = @Origen AND MovID = @OrigenID
UPDATE NegociaMoratoriosMAVI
SET Origen = @MovOrigen,
OrigenID = @MovIDOrigen
WHERE ID = @ID AND Mov = @Mov AND MovId = @MovId
END  
FETCH NEXT FROM crActOrigenCR INTO @ID, @Mov, @MovId
END 
CLOSE crActOrigenCR
DEALLOCATE crActOrigenCR
END
END

