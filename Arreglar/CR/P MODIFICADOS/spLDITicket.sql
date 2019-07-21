SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLDITicket
@ID	                int,
@Estacion             int

AS BEGIN
DECLARE @Comprobante     varchar(max),
@IDLog           int,
@Resultado       bit
SELECT @Resultado = 0
IF (EXISTS(SELECT * FROM VentaCobro v  WITH (NOLOCK)  JOIN FormaPago f  WITH (NOLOCK) ON v.FormaCobro1 = f.FormaPago WHERE v.ID  = @ID AND ISNULL(LDI,0) = 1) OR
EXISTS(SELECT * FROM VentaCobro v  WITH (NOLOCK)  JOIN FormaPago f  WITH (NOLOCK) ON v.FormaCobro2 = f.FormaPago WHERE v.ID  = @ID AND ISNULL(LDI,0) = 1) OR
EXISTS(SELECT * FROM VentaCobro v  WITH (NOLOCK)  JOIN FormaPago f  WITH (NOLOCK) ON v.FormaCobro3 = f.FormaPago WHERE v.ID  = @ID AND ISNULL(LDI,0) = 1) OR
EXISTS(SELECT * FROM VentaCobro v  WITH (NOLOCK)  JOIN FormaPago f  WITH (NOLOCK) ON v.FormaCobro4 = f.FormaPago WHERE v.ID  = @ID AND ISNULL(LDI,0) = 1) OR
EXISTS(SELECT * FROM VentaCobro v  WITH (NOLOCK)  JOIN FormaPago f  WITH (NOLOCK) ON v.FormaCobro5 = f.FormaPago WHERE v.ID  = @ID AND ISNULL(LDI,0) = 1) )
IF EXISTS(SELECT * FROM  LDIMovLog WITH (NOLOCK) WHERE Modulo = 'VTAS' AND IDModulo = @ID AND DescripcionRespuesta LIKE '%Aprobada%')
BEGIN
SELECT TOP 1 @Comprobante = Comprobante FROM LDIMovLog WITH (NOLOCK)  WHERE Modulo = 'VTAS' AND IDModulo = @ID AND DescripcionRespuesta LIKE '%Aprobada%'
DELETE POSLDITicket WHERE Estacion = @Estacion
INSERT  POSLDITicket(Estacion, RID, Campo)
SELECT               @Estacion, @ID, Campo
FROM dbo.fnPOSGenerarTicket(@Comprobante,'<BR>')
SELECT @Resultado = 1
END
SELECT @Resultado
END

