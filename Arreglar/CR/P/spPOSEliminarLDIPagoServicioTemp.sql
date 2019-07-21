SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSEliminarLDIPagoServicioTemp
@ID                 varchar(36),
@Servicio	        varchar(20),
@Empresa	        varchar(5),
@Usuario	        varchar(10),
@Sucursal	        int,
@Importe            float,
@Codigo             varchar(50)

AS
BEGIN
IF EXISTS(SELECT * FROM POSLDIPagoServicioTemp WHERE ID = @ID)
DELETE POSLDIPagoServicioTemp WHERE ID = @ID
IF EXISTS(SELECT * FROM POSLVenta WHERE ID = @ID)
DELETE POSLVenta WHERE ID = @ID
END

