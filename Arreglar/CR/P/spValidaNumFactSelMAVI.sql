SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spValidaNumFactSelMAVI
@ID INT ,
@Estacion INT ,
@CobroXPolitica INT

AS
BEGIN  
DECLARE @Mensaje VARCHAR(50) ,
@Sucursal INT ,
@Hoy DATETIME ,
@Vencimiento DATETIME ,
@TipoCobro INT ,
@Cantidad INT
SELECT  @Mensaje = '0'
SELECT  @TipoCobro = ISNULL(TipoCobro, 0)
FROM    TipoCobroMAVI
WHERE   IDCobro = @ID
SELECT  @Cantidad = COUNT(*)
FROM    ListaSt
WHERE   Estacion = @Estacion
IF @Cantidad < 1
SELECT  @Mensaje = 'Debe Seleccionar al menos un movimiento'
ELSE
BEGIN
IF @Cantidad > 1
SELECT  @Mensaje = 'No puede seleccionar mas de un movimiento'
ELSE
SELECT  @Mensaje = '0'
END
SELECT  @Mensaje
RETURN
END  

