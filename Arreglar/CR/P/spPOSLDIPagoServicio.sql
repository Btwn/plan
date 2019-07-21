SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSLDIPagoServicio
@ID			varchar(36),
@Ok			int = NULL           OUTPUT,
@OkRef		varchar(255) = NULL  OUTPUT

AS
BEGIN
DECLARE
@Servicio	    varchar(20),
@Empresa	    varchar(5),
@Usuario	    varchar(10),
@Sucursal		int,
@Importe        float,
@Codigo         varchar(50)
SELECT @Servicio = Servicio, @Empresa = Empresa, @Usuario = Usuario, @Sucursal = Sucursal, @Importe = Importe, @Codigo = Codigo
FROM POSLDIPagoServicioTemp
WHERE ID = @ID
IF @Ok IS NULL AND ISNULL(@Importe,0.0)>0.0 AND NULLIF(@Codigo,'') IS NOT NULL
EXEC spPOSLDI    @Servicio, @ID, NULL, @Empresa, @Usuario, @Sucursal, NULL, @Importe, 1,NULL,
@Ok OUTPUT, @OkRef OUTPUT, 'POS', @Cuenta = @Codigo, @Referencia = @Codigo
END

