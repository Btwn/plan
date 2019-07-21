SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpGenerarCFDAddendaTag
@Estacion		int,
@Modulo			char(5),
@ID				int,
@Layout			varchar(50),
@EsCFDI			bit		= 0,
@EsTagInicial	bit		= 0
AS BEGIN
/*
IF  @Layout = 'CHEDRAUI' AND @EsCFDI = 1
BEGIN
IF @EsTagInicial = 1
SELECT  '<cfdi:Addenda>    <lev1add:EDCINVOICE xsi:schemaLocation='+char(34)+'http://www.edcinvoice.com/lev1add http://www.edcinvoice.com/lev1add/lev1add.xsd'+char(34)+' xmlns:lev1add='+char(34)+'http://www.edcinvoice.com/lev1add'+char(34)+'>'
ELSE
SELECT '</lev1add:EDCINVOICE></cfdi:Addenda>'
END ELSE*/
SELECT ''
RETURN
END

