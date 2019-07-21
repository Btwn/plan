SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSTicketDenominacion
@ID                 varchar(36),
@Empresa            varchar(5),
@MovClave           varchar(20),
@FormaPago          varchar(50),
@Estacion           int,
@LargoLineaTicket   int,
@EsImpresion        bit =0,
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
@String2              varchar(max)
SET @Ticket = ''
IF @MovClave IN('POS.CCM','POS.CPCM','POS.CC','POS.CPC') AND EXISTS(SELECT * FROM POSLDenominacion WHERE ID = @ID AND Formapago = @FormaPago)
BEGIN
SELECT @String2 = dbo.fnCentrar(UPPER('   DENOMINACION '), @LargoLineaTicket /3) +
dbo.fnCentrar(UPPER('    CANTIDAD'), @LargoLineaTicket /3) +
dbo.fnCentrar(UPPER('         TOTAL'), @LargoLineaTicket /3) + '<BR>' +
REPLICATE('-', @LargoLineaTicket +CASE WHEN @EsImpresion=0 THEN 32 ELSE 0 END) + '<BR>'
DECLARE crDenominacion CURSOR LOCAL FOR
SELECT Nombre, Denominacion, Cantidad
FROM POSLDenominacion
WHERE ID = @ID AND ISNULL(Cantidad,0) > 0
AND Formapago = @FormaPago
OPEN crDenominacion
FETCH NEXT FROM crDenominacion INTO @Nombre, @Denominacion, @Cantidad
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @String = dbo.fnCentrar(CONVERT(varchar,dbo.fnRellenarConCaracter(@Denominacion,5,'i',CHAR(32)) ), @LargoLineaTicket /3) +
dbo.fnCentrar(CONVERT(varchar,dbo.fnRellenarConCaracter(ISNULL(@Cantidad,0.0),8,'i',CHAR(32)) ), @LargoLineaTicket /2) +
dbo.fnCentrar(dbo.fnRellenarConCaracter(ISNULL(dbo.fnFormatoMoneda((@Cantidad*@Denominacion),@Empresa),0.0),9,'i',CHAR(32)), @LargoLineaTicket /2) + '<BR>'
END
SELECT @Ticket = @Ticket + @String
FETCH NEXT FROM crDenominacion INTO @Nombre, @Denominacion, @Cantidad
END
CLOSE crDenominacion
DEALLOCATE crDenominacion
SELECT @Ticket = @String2 + @Ticket
END
RETURN
END

