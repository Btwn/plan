SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOrigenNCxCancMAVI
@IDCobro   int

AS BEGIN
DECLARE
@Mov    varchar(20),
@ID     int,
@Concepto   varchar(50),
@MovID    varchar(20),
@Valor    varchar(50),
@Large    int,
@LargeOrigen  int,
@MovOrigen   varchar(20),
@MovIDOrigen  varchar(20),
@IDDetalle   int
IF EXISTS(SELECT * FROM NegociaMoratoriosMAVI WHERE IDCobro = @IDCobro AND Mov in ('Nota Cargo','Nota Cargo VIU'))
BEGIN
DECLARE crActOrigen CURSOR FOR
SELECT ID, Mov, MovId FROM NegociaMoratoriosMAVI WHERE IDCobro = @IDCobro AND Mov in ('Nota Cargo','Nota Cargo VIU')
OPEN crActOrigen
FETCH NEXT FROM crActOrigen INTO @ID, @Mov, @MovId
WHILE @@FETCH_STATUS <> -1
BEGIN  
IF @@FETCH_STATUS <> -2
BEGIN  
SELECT @Concepto = Concepto, @IDDetalle = ID from cxc where mov = @Mov and MovId = @MovId
IF @Concepto in ('CANC COBRO CRED Y PP', 'CANC COBRO FACTURA','CANC COBRO SEG AUTO','CANC COBRO SEG VIDA', 'CANC COBRO FACTURA VIU','CANC COBRO MAYOREO')
BEGIN
IF EXISTS(SELECT * FROM MovCampoExtra WHERE /*Modulo = 'Cxc' AND*/ ID = @IDDetalle)
BEGIN
SELECT @Valor = Valor FROM MovCampoExtra WHERE Modulo = 'Cxc' AND ID = @IDDetalle
SELECT @Large = LEN(@Valor)
SELECT @LargeOrigen = PATINDEX('%[_]%', @Valor)
SELECT @MovOrigen = SUBSTRING(@Valor, 1, @LargeOrigen - 1 )
SELECT @MovIDOrigen = SUBSTRING(@Valor, @LargeOrigen + 1, @Large)
UPDATE NegociaMoratoriosMAVI
SET Origen = @MovOrigen,
OrigenID = @MovIDOrigen
WHERE ID = @ID AND Mov = @Mov AND MovId = @MovId
END
END
END  
FETCH NEXT FROM crActOrigen INTO @ID, @Mov, @MovId
END 
CLOSE crActOrigen
DEALLOCATE crActOrigen
END
END

