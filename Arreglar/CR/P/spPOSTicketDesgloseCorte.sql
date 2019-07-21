SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSTicketDesgloseCorte
@ID                 varchar(36),
@Empresa            varchar(5),
@Sucursal           int,
@Host               varchar(20),
@Usuario            varchar(10),
@MovClave           varchar(20),
@Caja               varchar(50),
@Estacion           int,
@LargoLineaTicket   int,
@Ticket             varchar(max)=NULL  OUTPUT,
@Ok                 int       =NULL    OUTPUT,
@OkRef              varchar(255)=NULL  OUTPUT

AS
BEGIN
DECLARE
@Nombre              varchar(50),
@Denominacion        float,
@Cantidad            float,
@String              varchar(max),
@String2             varchar(max),
@Fecha               datetime,
@Mov                 varchar(20),
@MovID               varchar(20),
@Importe             varchar(20),
@ImporteRef          varchar(20),
@Moneda              varchar(10),
@MonedaPrincipal     varchar(10),
@OtraMoneda          bit,
@Orden               int,
@OrdenMov            int
SET @OtraMoneda = 0
SELECT TOP 1 @MonedaPrincipal = Moneda
FROM POSLTipoCambioRef
WHERE TipoCambio = 1
AND Sucursal = @Sucursal    AND EsPrincipal = 1
SELECT @OrdenMov = Orden
FROM POSL
WHERE ID = @ID
SELECT @Orden= max(p.Orden)
FROM POSL p JOIN MovTipo  m ON p.Mov = m.Mov AND m.Modulo='POS'
WHERE p.Host = @Host AND p.Empresa = @Empresa
AND p.Usuario = @Usuario AND p.CtaDineroDestino = @Caja
AND m.Clave IN ('POS.AC','POS.ACM')
AND p.Estatus IN('CONCLUIDO','TRASPASADO')
AND p.ID <> @ID
AND p.Orden < @OrdenMov
GROUP BY p.Orden
ORDER BY p.Orden asc
SET @Ticket = ISNULL(@Ticket,'')
IF EXISTS (SELECT * FROM POSL p JOIN POSLCobro c ON p.ID = c.ID  JOIN MovTipo m ON p.Mov = m.Mov AND m.Modulo='POS'
WHERE m.Clave IN ('POS.AC', 'POS.ACM', 'POS.AP', 'POS.CAC', 'POS.CACM', 'POS.CC', 'POS.CCC', 'POS.CCCM', 'POS.CCM', 'POS.CPC', 'POS.CPCM', 'POS.CTCAC', 'POS.CTCM', 'POS.CTCRC', 'POS.CTRM', 'POS.EC', 'POS.F', 'POS.FA', 'POS.IC', 'POS.N', 'POS.TCAC', 'POS.TCM', 'POS.TCM', 'POS.TCRC', 'POS.TRM','POS.TCM','POS.CTCM','POS.CXCC','POS.CXCD')
AND p.Estatus IN('CONCLUIDO','TRASPASADO')
AND p.Orden BETWEEN @Orden AND @OrdenMov
AND p.Host = @Host AND p.Empresa = @Empresa AND p.Usuario = @Usuario
AND c.MonedaRef <> @MonedaPrincipal
AND (CASE WHEN m.Clave IN('POS.AC','POS.AP','POS.ACM','POS.CCC','POS.CCCM') THEN p.CtaDineroDestino
ELSE c.Caja
END) = @Caja)
SET @OtraMoneda = 1
IF @MovClave IN('POS.CCM','POS.CC')
BEGIN
IF @OtraMoneda = 1
SELECT @String2 = dbo.fnCentrar(UPPER('Movimiento '), @LargoLineaTicket /4) + dbo.fnAlinearDerecha(UPPER('IMPORTE M/N'), 15) +
dbo.fnCentrar(UPPER('IMPORTE'), @LargoLineaTicket /2) + '<BR>' +REPLICATE('-', @LargoLineaTicket+40) + '<BR>'
ELSE
SELECT @String2 = dbo.fnCentrar(UPPER('Movimiento '), @LargoLineaTicket /4) + dbo.fnCentrar(UPPER('IMPORTE'), @LargoLineaTicket/2 ) +
'<BR>' + REPLICATE('-', @LargoLineaTicket+40) + '<BR>'
DECLARE crSaldos CURSOR LOCAL FOR
SELECT p.Mov,p.MovID,SUM(c.Importe*m.Factor),SUM(c.ImporteRef*m.Factor), c.MonedaRef
FROM POSL p JOIN POSLCobro c ON p.ID = c.ID
JOIN MovTipo m ON p.Mov = m.Mov AND m.Modulo='POS'
WHERE m.Clave IN ('POS.AC', 'POS.ACM', 'POS.AP', 'POS.CAC', 'POS.CACM', 'POS.CC', 'POS.CCC', 'POS.CCCM', 'POS.CCM', 'POS.CPC', 'POS.CPCM', 'POS.CTCAC', 'POS.CTCM', 'POS.CTCRC', 'POS.CTRM', 'POS.EC', 'POS.F', 'POS.FA', 'POS.IC', 'POS.N', 'POS.TCAC', 'POS.TCM', 'POS.TCM', 'POS.TCRC', 'POS.TRM','POS.TCM','POS.CTCM','POS.CXCC','POS.CXCD')
AND p.Estatus IN('CONCLUIDO','TRASPASADO')
AND p.Orden BETWEEN @Orden AND @OrdenMov
AND p.Host = @Host AND p.Empresa = @Empresa AND p.Usuario = @Usuario
AND (CASE WHEN m.Clave IN('POS.AC','POS.AP','POS.ACM','POS.CCC','POS.CCCM') THEN p.CtaDineroDestino ELSE c.Caja  END) = @Caja
GROUP BY   p.Mov,p.MovID, c.MonedaRef,p.Orden
ORDER BY p.Orden Asc
OPEN crSaldos
FETCH NEXT FROM crSaldos INTO @Mov, @MovID, @Importe,@ImporteRef, @Moneda
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @OtraMoneda = 1
SELECT @String =dbo.fnRellenarConCaracter(SUBSTRING(ISNULL(@Mov+' '+@MovID ,''),1,30),25,'D',' ') +
dbo.fnRellenarConCaracter(SUBSTRING(ISNULL(dbo.fnFormatoMoneda((@Importe),@Empresa),0.0),1,15),15,'I',' ') +
dbo.fnRellenarConCaracter(SUBSTRING(ISNULL(dbo.fnFormatoMoneda((@ImporteRef),@Empresa),0.0),1,15),15,'I',' ') + '<BR>'
ELSE
SELECT @String =dbo.fnRellenarConCaracter(SUBSTRING(ISNULL(@Mov+' '+@MovID ,''),1,25),25,'D',' ') +
dbo.fnRellenarConCaracter(SUBSTRING(ISNULL(dbo.fnFormatoMoneda((@ImporteRef),@Empresa),0.0),1,15),15,'I',' ') + '<BR>'
END
SELECT @Ticket = ISNULL(@Ticket,'') + ISNULL(@String,'')
FETCH NEXT FROM crSaldos INTO  @Mov, @MovID, @Importe, @ImporteRef, @Moneda
END
CLOSE crSaldos
DEALLOCATE crSaldos
SELECT @Ticket = @String2 + @Ticket
END
RETURN
END

