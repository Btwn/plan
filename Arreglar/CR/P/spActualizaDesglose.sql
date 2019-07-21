SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC [dbo].[spActualizaDesglose]
@ID int,
@Mov varchar(20),
@MovID varchar(20),
@Modulo varchar(5)

AS BEGIN
DECLARE
/*@ID int,
@Mov varchar(20),
@MovID varchar(20),
@Modulo varchar(5),*/
@Desglose	bit,
@Valor		varchar(200),
@Origen		varchar(20),
@OrigenID	varchar(20),
@CampoExtra varchar (200),
@Referencia varchar(50),
@RefMov varchar(20),
@RefMovID varchar(20),
@IDFact int
/*select @ID=32146,
@Mov='Devolucion Venta',
@MovID='cdma29',
@Modulo='CxC'*/
IF (@Modulo = 'VTAS' )
BEGIN
IF (@Mov IN('Factura','Factura VIU','Factura Mayoreo'))
BEGIN
SELECT @Desglose = FacDesgloseIVA FROM Venta  WITH (NOLOCK) WHERE Mov = @Mov AND MovID = @MovID
UPDATE Cxc WITH (ROWLOCK) SET FacDesgloseIVA = @Desglose WHERE Mov = @Mov AND MovID = @MovID   
END
IF (@Mov LIKE('Devolucion%'))
BEGIN
SELECT @Origen=C.Mov, @OrigenID=C.MovID
FROM CxC C WHERE C.Mov IN ('Nota Credito', 'Nota Credito Mayoreo', 'Nota Credito VIU')
AND C.Referencia = RTRIM(@Mov) + ' ' + RTRIM(@MovID)
SELECT
@RefMov = (SELECT CASE
WHEN Referencia LIKE('Factura Mayoreo_%') THEN 'Factura Mayoreo'
WHEN Referencia LIKE('Factura VIU_%') THEN 'Factura VIU'
WHEN Referencia LIKE('Factura_%') THEN 'Factura'    
END),
@RefMovID = (SELECT CASE
WHEN Referencia LIKE('Factura Mayoreo_%') THEN substring(Referencia,len('Factura Mayoreo_')+ 1,(len(Referencia)-len('Factura Mayoreo_')))
WHEN Referencia LIKE('Factura VIU_%') THEN substring(Referencia,len('Factura VIU_')+ 1,(len(Referencia)-len('Factura VIU_')))
WHEN Referencia LIKE('Factura_%') THEN substring(Referencia,len('Factura_')+ 1,(len(Referencia)-len('Factura_')))
END)
FROM Venta  WITH (NOLOCK) WHERE  Mov=@Mov AND MovID=@MovID
SELECT @Desglose = FacDesgloseIVA FROM venta  WITH (NOLOCK) WHERE Mov=@RefMov  and MovID=@RefMovID
UPDATE CxC WITH (ROWLOCK) SET FacDesgloseIVA= @Desglose WHERE Mov=@Origen AND MovID= @OrigenID
END
END
IF (@Modulo = 'CXC')
BEGIN
IF (@Mov IN ('Factura','Factura VIU','Factura Mayoreo') OR @Mov LIKE ('Devolucion%'))
SELECT @Mov=Mov, @MovID=MovID FROM Venta WHERE ID=@ID
ELSE
SELECT @Mov=Mov, @MovID=MovID FROM CxC WHERE ID=@ID
IF (@Mov IN ('Factura','Factura VIU','Factura Mayoreo') )
BEGIN
SELECT @Desglose = FacDesgloseIVA FROM CxC WHERE Mov = @Mov AND MovID = @MovID   
UPDATE CxC WITH (ROWLOCK) SET FacDesgloseIVA = @Desglose WHERE Origen=@Mov AND OrigenID=@MovID
END
IF (@Mov IN ('Nota Credito', 'Nota Credito Mayoreo', 'Nota Credito VIU'))
BEGIN
SELECT TOP 1 @Mov=Aplica, @Movid=AplicaID FROM CXCD WITH (NOLOCK) WHERE ID=@ID
SELECT @Desglose = FacDesgloseIVA FROM CxC WITH (NOLOCK) WHERE MovID=@MovID AND Mov=@Mov 
UPDATE CxC WITH (ROWLOCK) SET FacDesgloseIVA= @Desglose WHERE ID=@ID
END
IF (@Mov IN('Nota Cargo','Nota Cargo VIU','Nota Cargo Mayoreo'))
BEGIN
SELECT @CampoExtra = Valor FROM MovCampoExtra WITH (NOLOCK) WHERE ID = @ID AND Modulo='CXC'
IF @CampoExtra <> ''
BEGIN
SELECT
@Mov = (SELECT CASE
WHEN Valor LIKE('Factura Mayoreo_%') THEN 'Factura Mayoreo'
WHEN Valor LIKE('Factura VIU_%') THEN 'Factura VIU'
WHEN Valor LIKE('Factura_%') THEN 'Factura'    
WHEN Valor LIKE('Nota Cargo_%') THEN 'Nota Cargo'
WHEN Valor LIKE('Nota Cargo Mayoreo_%') THEN 'Nota Cargo Mayoreo'
WHEN Valor LIKE('Nota Cargo VIU_%') THEN 'Nota Cargo VIU'
WHEN Valor LIKE('Endoso_%') THEN 'Endoso'
END),
@MovID = (SELECT CASE
WHEN Valor LIKE('Factura Mayoreo_%') THEN substring(Valor,len('Factura Mayoreo_')+ 1,(len(Valor)-len('Factura Mayoreo_')))
WHEN Valor LIKE('Factura VIU_%') THEN substring(Valor,len('Factura VIU_')+ 1,(len(Valor)-len('Factura VIU_')))
WHEN Valor LIKE('Factura_%') THEN substring(Valor,len('Factura_')+ 1,(len(Valor)-len('Factura_')))
WHEN Valor LIKE('Nota Cargo_%') THEN substring(Valor,len('Nota Cargo_')+ 1,(len(Valor)-len('Nota Cargo_')))
WHEN Valor LIKE('Nota Cargo Mayoreo_%') THEN substring(Valor,len('Nota Cargo Mayoreo_')+ 1,(len(Valor)-len('Nota Cargo Mayoreo_')))
WHEN Valor LIKE('Nota Cargo VIU_%') THEN substring(Valor,len('Nota Cargo VIU_')+ 1,(len(Valor)-len('Nota Cargo VIU_')))
WHEN Valor LIKE('Endoso_%') THEN substring(Valor,len('Endoso_')+ 1,(len(Valor)-len('Endoso_')))
END)
FROM MovCampoExtra WITH (NOLOCK) WHERE  ID = @ID AND Modulo='CXC'
SELECT @Desglose = FacDesgloseIVA FROM CxC WITH (NOLOCK) WHERE Mov = @Mov AND MovID = @MovID
UPDATE CxC WITH (ROWLOCK) SET FacDesgloseIVA = @Desglose WHERE ID=@ID
END
END
IF (@Mov = ('Aplicacion'))
BEGIN
SELECT TOP 1 @Origen = MovAplica, @OrigenID = MovAplicaID FROM CxC WITH (NOLOCK) WHERE ID=@ID
IF (@Origen LIKE ('Nota Credito%'))
BEGIN
SELECT TOP 1 @Mov=Aplica, @MovID=AplicaID FROM CxCD WHERE ID=@ID
SELECT @Desglose = FacDesgloseIVA FROM CxC WITH (NOLOCK) WHERE Mov = @Mov AND MovID = @MovID 
UPDATE CxC WITH (ROWLOCK) SET FacDesgloseIVA= @Desglose WHERE ID=@ID
END
END
IF (@Mov='Endoso')  
BEGIN
SELECT @Mov=Aplica, @MovID=AplicaID FROM CxCD WHERE ID=@ID
SELECT @Desglose = FacDesgloseIVA FROM CxC WHERE Mov = @Mov AND MovID = @MovID
UPDATE CxC WITH (ROWLOCK) SET FacDesgloseIVA= @Desglose WHERE ID=@ID
END
IF (@Mov='Cta Incobrable F')
BEGIN
SELECT TOP 1 @Mov=Aplica, @MovID=AplicaID FROM CxCD WITH (NOLOCK) WHERE ID=@ID
SELECT @Desglose = FacDesgloseIVA FROM CxC WITH (NOLOCK) WHERE Mov = @Mov AND MovID = @MovID
UPDATE CxC WITH (ROWLOCK) SET FacDesgloseIVA= @Desglose WHERE ID=@ID
END
IF (@Mov IN ('Cobro','Cobro Instituciones'))
BEGIN
select @IDFact=dbo.fnIDPadreAplicaCobroCFD(@ID)
SELECT @Desglose = FacDesgloseIVA FROM CxC WITH (NOLOCK) WHERE ID=@IDFact
UPDATE CxC WITH (ROWLOCK) SET FacDesgloseIVA= @Desglose WHERE ID=@ID
END
END 
END

