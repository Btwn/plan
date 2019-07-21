SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSLDIADO
@ID		varchar(36)
 
AS
BEGIN
DECLARE
@Servicio	    varchar(20),
@Empresa	    varchar(5),
@Usuario	    varchar(10),
@Sucursal	    int,
@Importe        float,
@Monedero       varchar(36),
@Modulo			varchar(5),
@Cuenta         varchar(255),
@Referencia		varchar(255),
@Ok				int,
@OkRef			varchar(255)
SELECT @Servicio = Servicio,  @Empresa = Empresa, @Usuario= Usuario, @Sucursal = Sucursal, @Importe = Importe, @Monedero = NULLIF(Monedero,''), @Referencia = Referencia
FROM POSLDITemp
WHERE ID =  @ID
IF @Servicio IS NULL
SELECT @Servicio = Servicio,  @Empresa = Empresa, @Usuario= Usuario, @Sucursal = Sucursal, @Importe = Importe, @Monedero = NULLIF(Vale,''), @Referencia = ''
FROM POSLDIValeTemp
WHERE ID =  @ID
IF @Servicio <> 'VALECARGO'
BEGIN
IF EXISTS(SELECT * FROM POSLDIRespuestaTemp WHERE ID = @ID)
DELETE POSLDIRespuestaTemp WHERE ID = @ID
EXEC spPOSLDI @Servicio, @ID, @Monedero, @Empresa, @Usuario, @Sucursal, NULL, @Importe, 1, @ADO=1, @Ok = NULL, @OkRef = NULL, @Modulo = 'POS',
@Cuenta = NULL, @Referencia = @Referencia
END
IF @Servicio = 'VALECARGO'
BEGIN
IF EXISTS(SELECT * FROM POSLDIRespuestaTemp WHERE ID = @ID)
DELETE POSLDIRespuestaTemp WHERE ID = @ID
EXEC spPOSLDI @Servicio,    @ID, @Monedero, @Empresa, @Usuario, @Sucursal, NULL, @Importe, 1, @ADO=1, @Ok = NULL , @OkRef = NULL , @Modulo = 'POS',
@Cuenta = NULL, @Referencia = @Referencia
END
END

