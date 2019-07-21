SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSGenereDoctos
@ID  varchar(36) ,
@Mov varchar(20) = NULL,
@Cadena varchar(MAX)  OUTPUT

AS BEGIN
DECLARE
@FechaEmision  DateTime ,
@FechaCorte    DateTime,
@EsPar         varchar(5),
@Importe       money,
@NoDoctos  int,
@i    int,
@CadenaDoc  varchar(MAX),  
@DAPeriodo  char(15)
SELECT @FechaEmision=FechaEmision,@EsPar=Cte.Grupo,@NoDoctos=DANumeroDocumentos,
@Importe=
ROUND(((ISNULL(SUM(ISNULL(((POSLVenta.Cantidad - ISNULL(POSLVenta.CantidadObsequio,0)) * (POSLVenta.Precio - (POSLVenta.Precio * (ISNULL(POSLVenta.DescuentoLinea,0)/100)))),0)),0.0))-
(SUM(ISNULL(((POSLVenta.Cantidad - ISNULL(POSLVenta.CantidadObsequio,0)) * (POSLVenta.Precio - (POSLVenta.Precio * (ISNULL(POSLVenta.DescuentoLinea,0)/100)))),0) * (CASE WHEN ISNULL(POSLVenta.AplicaDescGlobal, 1) = 1 THEN ISNULL(POSL.DescuentoGlobal,0.0
) ELSE 0 END) /100))+
(SUM(dbo.fnPOSImporteMov(( ISNULL(((POSLVenta.Cantidad - ISNULL(POSLVenta.CantidadObsequio,0)) * ((POSLVenta.Precio - (POSLVenta.Precio * (ISNULL(POSLVenta.DescuentoLinea,0)/100)))-((POSLVenta.Precio - (POSLVenta.Precio * (ISNULL(POSLVenta.DescuentoLinea,0)/100))) *
(CASE WHEN ISNULL(POSLVenta.AplicaDescGlobal, 1) = 1 THEN ISNULL(POSL.DescuentoGlobal,0.0) ELSE 0 END)/100))),0)),POSLVenta.Impuesto1,POSLVenta.Impuesto2, POSLVenta.Impuesto3 ,POSLVenta.Cantidad)-(ISNULL(((POSLVenta.Cantidad - ISNULL(POSLVenta.CantidadObsequio,0)) * ((POSLVenta.Precio - (POSLVenta.Precio *
(ISNULL(POSLVenta.DescuentoLinea,0)/100)))-((POSLVenta.Precio - (POSLVenta.Precio * (ISNULL(POSLVenta.DescuentoLinea,0)/100))) * (CASE WHEN ISNULL(POSLVenta.AplicaDescGlobal, 1) = 1 THEN ISNULL(POSL.DescuentoGlobal,0.0) ELSE 0 END)/100))),0))))),4)
/DANumeroDocumentos,
@DAPeriodo = DAPeriodo
FROM  POSL JOIN POSLVenta ON POSL.ID=POSLVenta.ID
JOIN Cte ON PosL.Cliente=Cte.Cliente
JOIN Condicion ON POSL.Condicion=Condicion.Condicion
WHERE POSL.ID=@ID
GROUP BY FechaEmision,Cte.Grupo,DANumeroDocumentos, DAPeriodo
IF @Mov='Factura Credito' AND @EsPar IN ('Non', 'Par') AND @DAPeriodo = 'Mensual'
BEGIN
DELETE TmpImprimirDocCte WHERE ID=@ID  And Modulo='VTAS' And Mov=@Mov
SELECT @i=1 ,@Cadena=''
WHILE @i < = @NoDoctos
BEGIN
IF @EsPar='Par'
BEGIN
IF  DAY(@FechaEmision) < = 31
SELECT  @FechaCorte=dbo.fnUltimoDiaMes(DATEADD(MONTH,@i,@FechaEmision)+1)
ELSE
SELECT  @FechaCorte=dbo.fnUltimoDiaMes(DATEADD(MONTH,@i+1,@FechaEmision))
END
ELSE IF @EsPar='Non' AND @DAPeriodo = 'Mensual'
BEGIN
IF DAY(@FechaEmision) < = 15
SELECT @FechaCorte=CONVERT(VARCHAR,YEAR(DATEADD(MONTH,@i,@FechaEmision)))+CONVERT(VARCHAR,REPLACE(STR((MONTH(DATEADD(MONTH,@i,@FechaEmision))),2,0),' ','0'))+'15'
ELSE
SELECT @FechaCorte=CONVERT(VARCHAR,YEAR(DATEADD(MONTH,@i+1,@FechaEmision)))+CONVERT(VARCHAR,REPLACE(STR((MONTH(DATEADD(MONTH,@i+1,@FechaEmision))),2,0),' ','0'))+'15'
END
SELECT @Cadena=@Cadena+('DOC  '+ Convert(varchar,@i) +' Vencimiento :' + CONVERT(VARCHAR,@FechaCorte,103)+  ' Importe : ' + dbo.fnFormatoMoneda(@Importe,''))+'<BR>'
SELECT @CadenaDoc=('DOC '+ Convert(varchar,@i) +'  Vencimiento : ' + CONVERT(VARCHAR,@FechaCorte,103)+  ' Importe : ' + dbo.fnFormatoMoneda(@Importe,''))
INSERT INTO TmpImprimirDocCte VALUES (@CadenaDoc,@ID,'VTAS',@Mov)
SET @i+=1
END
END
IF @Mov='Factura Credito' AND @EsPar IN ('Non', 'Par')  AND @DAPeriodo = 'Quincenal'
BEGIN
DELETE TmpImprimirDocCte WHERE ID=@ID  And Modulo='VTAS' And Mov=@Mov
EXEC spPOSProrrateoFecha  @@spid, 1, @FechaEmision, 'Quincenal', @NoDoctos
SELECT @Cadena=@Cadena+('DOC '+ Convert(varchar,ROW_NUMBER() OVER(ORDER BY Fecha ASC)) +' Vencimiento :' + CONVERT(VARCHAR,Fecha,103)+  ' Importe : ' + dbo.fnFormatoMoneda(@Importe,'FREY'))+'<BR>' FROM ProrrateoFecha WHERE Estacion = @@spid
INSERT INTO TmpImprimirDocCte
SELECT ('DOC  '+ Convert(varchar,ROW_NUMBER() OVER(ORDER BY Fecha ASC)) +' Vencimiento :' + CONVERT(VARCHAR,Fecha,103)+  ' Importe : ' + dbo.fnFormatoMoneda(@Importe,'')), @ID,'VTAS',@Mov
FROM ProrrateoFecha
WHERE Estacion = @@spid
GROUP BY Fecha
END
RETURN
END

