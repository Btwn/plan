SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLDIGenerarLOG
@Empresa		char(5),
@Modulo			char(10),
@ID			int,
@Servicio               varchar(20),
@Cadena                 varchar(8000),
@CadenaRespuesta        varchar(8000),
@Importe                float,
@Ok 			int 		OUTPUT,
@OkRef 			varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@IDLDI     int
INSERT LDIMovLog(IDModulo, Servicio,  Modulo,  Cadena,  CadenaRespuesta,  Importe,  RIDCobro,  Fecha, TipoTransaccion, TipoSubservicio,CodigoRespuesta, DescripcionRespuesta, OrigenRespuesta, InfoAdicional, IDTransaccion,CodigoAutorizacion,Comprobante   )
SELECT           @ID,      @Servicio, @Modulo, @Cadena, @CadenaRespuesta, @Importe, NULL, *
FROM(SELECT Parametro,Valor FROM dbo.fnLDISeparaCadena (@CadenaRespuesta)) tabla
PIVOT( MAX(Valor)
FOR [Parametro] IN ([[3], [7], [56], [14], [16], [13], [27],  [8], [50],  [163])) p
SELECT @IDLDI = SCOPE_IDENTITY()
UPDATE LDIMovLog SET   Comprobante = REPLACE(REPLACE(REPLACE(Comprobante,'^',':'),'@dd',':'),CHAR(10),'<BR>') ,Fecha = dbo.fnLDIFecha(Fecha)
WHERE  ID = @IDLDI
RETURN
END

