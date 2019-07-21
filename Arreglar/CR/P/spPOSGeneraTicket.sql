SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSGeneraTicket
@Estacion     int,
@Empresa      varchar(5),
@Sucursal     int,
@Usuario      varchar(10),
@ID           varchar(50)

AS
BEGIN
DECLARE
@Ticket   varchar(max)
EXEC spPOS @Estacion,NULL, @Empresa,'VTAS', @Sucursal, @Usuario, NULL,@ID, @Ticket = @Ticket OUTPUT,@DesgloseC =1  ,@EsImpresion = 1
IF EXISTS(SELECT * FROM POSReporteTicket WHERE Estacion = @Estacion)
DELETE POSReporteTicket WHERE Estacion = @Estacion
INSERT POSReporteTicket(
Estacion, RID, Campo, AbreCajon)
SELECT
@Estacion, @ID, Campo , 0
FROM dbo.fnPOSGenerarTicket(@Ticket,'<BR>')
ORDER BY ID
END

