SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSRecargaTemp
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
IF EXISTS(SELECT * FROM POSLVenta p JOIN Art a ON p.Articulo = a.Articulo WHERE p.ID = @ID AND ISNULL(a.LDI,0)= 1 AND NULLIF(a.LDIServicio,'') IS NOT NULL)
EXEC spPOSInsertarLDIRecargaTemp @ID, @Servicio, @Empresa, @Usuario, @Sucursal, @Importe, @Telefono
IF EXISTS(SELECT * FROM POSLVenta p JOIN Art a ON p.Articulo = a.Articulo WHERE p.ID = @ID AND ISNULL(a.EmidaRecargaTelefonica,0) = 1)
EXEC spPOSInsertarEmidaRecargaTemp @ID, @Servicio, @Empresa, @Usuario, @Sucursal, @Importe, @Telefono, @Estacion
END

