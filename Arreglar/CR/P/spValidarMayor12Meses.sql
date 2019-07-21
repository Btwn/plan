SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC [dbo].[spValidarMayor12Meses]
@ID int,
@Mov varchar(20),
@Modulo varchar(5)

AS BEGIN
DECLARE
@Desglose Bit,
@Mayor12meses bit
IF @Modulo='VTAS'
BEGIN
IF @Mov IN('Solicitud Credito','Analisis Credito','Pedido','Factura','Factura VIU')
BEGIN
SELECT @Mayor12meses=(SELECT CASE
WHEN (SELECT ISNULL(Cond.DANumeroDocumentos, ISNULL(Cond.Meses, (Cond.DiasVencimiento/30) )) FROM Condicion Cond
WHERE v.Condicion=Cond.Condicion) < 12 OR
(SELECT Cond.DANumeroDocumentos FROM Condicion Cond WHERE v.Condicion=Cond.Condicion) = NULL  THEN 0
WHEN (SELECT ISNULL(Cond.DANumeroDocumentos, ISNULL(Cond.Meses, (Cond.DiasVencimiento/30) )) FROM Condicion Cond
WHERE v.Condicion=Cond.Condicion)>= 12 OR
(SELECT Cond.DANumeroDocumentos FROM Condicion Cond WHERE v.Condicion=Cond.Condicion) >= 12  THEN 1
END), @Desglose=v.FacDesgloseIVA FROM Venta v WHERE v.ID=@ID
IF (@Desglose=1 AND @Mayor12meses=1)
UPDATE Venta SET FacDesgloseIVA=0 WHERE ID=@ID
END
END
IF @Modulo='CXC'
BEGIN
IF @Mov IN('Nota Cargo')
BEGIN
SELECT @Mayor12meses=(SELECT CASE
WHEN (SELECT ISNULL(Cond.DANumeroDocumentos, ISNULL(Cond.Meses, (Cond.DiasVencimiento/30) )) FROM Condicion Cond
WHERE c.Condicion=Cond.Condicion) < 12 OR
(SELECT Cond.DANumeroDocumentos FROM Condicion Cond WHERE c.Condicion=Cond.Condicion) = NULL  THEN 0
WHEN (SELECT ISNULL(Cond.DANumeroDocumentos, ISNULL(Cond.Meses, (Cond.DiasVencimiento/30) )) FROM Condicion Cond
WHERE c.Condicion=Cond.Condicion)>= 12 OR
(SELECT Cond.DANumeroDocumentos FROM Condicion Cond WHERE c.Condicion=Cond.Condicion) >= 12  THEN 1
END), @Desglose=c.FacDesgloseIVA FROM CXC c WHERE c.ID=@ID
IF (@Desglose=1 AND @Mayor12meses=1)
UPDATE CXC SET FacDesgloseIVA=0 WHERE ID=@ID
END
END
END

