SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSMuestraCondicionesCobro (
@ID          varchar(36),
@Empresa     varchar(5),
@Sucursal    int,
@Estacion    int,
@FormasPago  varchar(MAX) OUTPUT
)

AS
BEGIN
DECLARE
@String							varchar(MAX),
@Codigo							varchar(50),
@FormaPago						varchar(50),
@ImporteTotal					float,
@LargoLinea						int,
@CfgAnticipoArticuloServicio	varchar(20)
SELECT @CfgAnticipoArticuloServicio = NULLIF(CxcAnticipoArticuloServicio,'')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
IF EXISTS(SELECT * FROM POSCobroCondicionTemp WHERE Estacion = @Estacion AND ID = @ID)
AND NOT EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID AND Articulo IN(SELECT Articulo FROM POSLDIArtRecargaTel))
AND NOT EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID AND Articulo =@CfgAnticipoArticuloServicio)
BEGIN
SELECT @FormasPago = '<BR> ************* COBROS POR FORMA DE PAGO  *************  <BR>'
DECLARE crFormaPago CURSOR LOCAL FOR
SELECT SUBSTRING(FormaPago,1,30), SUM(PrecioTotal)
FROM  POSCobroCondicionTemp
WHERE  Estacion = @Estacion AND ID = @ID
GROUP BY  FormaPago
OPEN crFormaPago
FETCH NEXT FROM crFormaPago INTO @FormaPago, @ImporteTotal
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @String = 'PAGO EN '+dbo.fnRellenarConCaracter(UPPER(@FormaPago),32,'D',CHAR(32)) +
dbo.fnAlinearDerecha(dbo.fnRellenarConCaracter(dbo.fnFormatoMoneda(@ImporteTotal,@Empresa),10,'i',CHAR(32)),15) + '<BR>'
SELECT @FormasPago = ISNULL(@FormasPago,'') + ISNULL(@String,'')
END
FETCH NEXT FROM crFormaPago INTO @FormaPago, @ImporteTotal
END
CLOSE crFormaPago
DEALLOCATE crFormaPago
END
END

