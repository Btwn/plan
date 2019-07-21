SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSInsertarEmidaRecargaTemp
@ID             varchar(36),
@Servicio	    varchar(20),
@Empresa	    varchar(5),
@Usuario	    varchar(10),
@Sucursal		int,
@Importe        float,
@Telefono       varchar(10),
@Estacion       int

AS
BEGIN
IF EXISTS(SELECT * FROM POSEmidaRecargaTemp WITH (NOLOCK) WHERE ID = @ID)
DELETE POSEmidaRecargaTemp WHERE ID = @ID
INSERT POSEmidaRecargaTemp(
ID, Empresa, Usuario, Sucursal, Telefono, Estacion)
SELECT
@ID, @Empresa, @Usuario, @Sucursal, @Telefono, @Estacion
END

