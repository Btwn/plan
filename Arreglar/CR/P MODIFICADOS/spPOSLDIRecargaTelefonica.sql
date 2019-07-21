SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSLDIRecargaTelefonica
@ID	        varchar(36),
@Ok         int = NULL           OUTPUT,
@OkRef		varchar(255) = NULL  OUTPUT

AS
BEGIN
DECLARE
@Servicio	    varchar(20),
@Empresa	    varchar(5),
@Usuario	    varchar(10),
@Sucursal	    int,
@Importe        float,
@Telefono		varchar(10)
SELECT @Servicio = Servicio, @Empresa = Empresa, @Usuario = Usuario, @Sucursal = Sucursal, @Importe = Importe, @Telefono = Telefono
FROM POSLDIRecargaTemp WITH (NOLOCK)
WHERE ID = @ID
IF LEN(ISNULL(@Telefono,'1')) <> 10
SELECT @Ok = 30443
IF NULLIF(@Telefono,'') IS  NULL AND @Ok IS NULL
SELECT @Ok = 30449
IF NULLIF(@Servicio,'') IS NULL
SELECT @Ok = 30444
IF @Ok IS NULL AND ISNULL(@Importe,0.0)>0.0 AND NULLIF(@Telefono,'') IS NOT NULL
EXEC spPOSLDI    @Servicio, @ID, NULL, @Empresa, @Usuario, @Sucursal, NULL, @Importe, 1,@Telefono, @Ok OUTPUT, @OkRef OUTPUT, 'POS'
END

