SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpInvVerificarInvFisicoWMS
@ID					int,
@Modulo				varchar(5),
@MovTipo	        char(20),
@Almacen            char(10),
@Ok               	int           	= NULL OUTPUT,
@OkRef            	varchar(255)  	= NULL OUTPUT
AS BEGIN
DECLARE
@WMS			bit
SELECT @WMS = ISNULL(WMS,0) FROM Alm WHERE Almacen = @Almacen
IF @Modulo = 'INV' AND @MovTipo = 'INV.IF' AND @WMS = 1
IF(SELECT COUNT(ISNULL(Tarima,'')) FROM InvD WHERE ID = @ID AND ISNULL(Tarima,'') = '') <> 0
SELECT @Ok = 13130
RETURN
END

