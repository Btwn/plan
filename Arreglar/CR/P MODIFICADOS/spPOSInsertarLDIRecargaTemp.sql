SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertarLDIRecargaTemp
@ID             varchar(36),
@Servicio	    varchar(20),
@Empresa	    varchar(5),
@Usuario	    varchar(10),
@Sucursal		int,
@Importe        float,
@Telefono       varchar(10)

AS
BEGIN
IF EXISTS(SELECT * FROM POSLDIRecargaTemp WITH (NOLOCK) WHERE ID = @ID)
DELETE POSLDIRecargaTemp WHERE ID = @ID
INSERT POSLDIRecargaTemp(
ID, Servicio, Empresa, Usuario, Sucursal, Importe, Telefono)
SELECT
@ID, @Servicio, @Empresa, @Usuario, @Sucursal, @Importe, @Telefono
END

