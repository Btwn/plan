SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSMuestraVentaCobro
@ID		varchar(36)

AS
BEGIN
DECLARE
@String					varchar(max),
@String2				varchar(max),
@VentaCobro				varchar(max),
@Codigo					varchar(50),
@FormaPago				char(50),
@Importe				float,
@ImporteRef				float,
@LargoLinea				int,
@PuntosUtilizados		float,
@MonedaMonedero			varchar(10),
@Monedero				varchar(20),
@Empresa				varchar(5)
SELECT @LargoLinea = 100
SELECT @Monedero = Monedero
FROM POSL
WHERE ID = @ID
IF EXISTS (SELECT * FROM POSLVenta WHERE ID = @ID HAVING SUM(Puntos)>0) AND NULLIF(@Monedero,'') IS NOT NULL
BEGIN
SELECT @PuntosUtilizados = ABS(SUM(Puntos))
FROM POSLVenta
WHERE ID = @ID AND ISNULL(Puntos,0.0)> 0.0
SELECT @MonedaMonedero =  Moneda
FROM POSValeSerie
WHERE Serie = @Monedero
SELECT @String2 = dbo.fnAlinearCampoValor(ISNULL(UPPER(REPLICATE(' ', 9)+' SE ABONARAN  '+CONVERT(varchar,@PuntosUtilizados)+' '+
@MonedaMonedero+' AL MONEDERO : '), '')+ @Monedero, '<BR>', @LargoLinea)
SELECT @String2 = @String2+
'__________________________________________________________________'+'<BR>'+'__________________________________________________________________'+
'<BR><BR><BR>'
END
SELECT @VentaCobro = ISNULL(@String2,'')
IF EXISTS(SELECT * FROM POSLCobro WHERE ID = @ID)
SELECT @VentaCobro = ISNULL(@VentaCobro,'')+'FORMA PAGO' + SPACE(38)+RIGHT(dbo.fnAlinearDerecha('IMPORTE',12),10) +
SPACE(5)+RIGHT(dbo.fnAlinearDerecha('IMPORTE  M.N.',15),15) + '<BR>'+ REPLICATE('-',100)+'<BR>'
DECLARE crVentaCobro CURSOR LOCAL FOR
SELECT FormaPago, SUM(ImporteRef), SUM(Importe)
FROM POSLCobro
WHERE ID = @ID
GROUP BY  FormaPago
OPEN crVentaCobro
FETCH NEXT FROM crVentaCobro INTO  @FormaPago, @Importe, @ImporteRef
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @String = @FormaPago + SPACE(5)+RIGHT(dbo.fnAlinearDerecha(dbo.fnFormatoMoneda(ISNULL(@Importe,0.0),@Empresa),12),10) +
SPACE(5)+RIGHT(dbo.fnAlinearDerecha(dbo.fnFormatoMoneda(ISNULL(@ImporteRef,0.0),@Empresa),12),10) + '<BR>'
SELECT @VentaCobro = ISNULL(@VentaCobro,'') + ISNULL(@String,'')
END
FETCH NEXT FROM crVentaCobro INTO @FormaPago, @Importe, @ImporteRef
END
CLOSE crVentaCobro
DEALLOCATE crVentaCobro
SELECT @VentaCobro
END

