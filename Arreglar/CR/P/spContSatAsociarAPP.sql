SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContSatAsociarAPP
@MacAddress   varchar(50),
@Modulo       char(20),
@ModuloID     int,
@Empresa      char(5),
@FechaEmision datetime,
@Mov          varchar(10),
@RFCReceptor  varchar(20),
@RFCEmisor    varchar(20),
@Importe      money,
@UUID         varchar(50),
@Moneda       varchar(10),
@TipoCambio   float,
@Usuario      varchar(10),
@Ruta		  varchar(500),
@Documento	  varchar(MAX),
@Ok           int          OUTPUT,
@OkRef        varchar(255) OUTPUT

AS
BEGIN
DELETE ContSATCFDTempAPP WHERE MacAddress = @MacAddress
INSERT INTO ContSATCFDTempAPP (MacAddress, Modulo, ModuloID, Empresa, Fecha, RFCReceptor, RFCEmisor, Importe, UUID, Ruta, Documento)
VALUES (@MacAddress,  @Modulo, @ModuloID, @Empresa, @FechaEmision, @RFCReceptor, @RFCEmisor, @Importe, @UUID, @Ruta, @Documento)
IF EXISTS (SELECT * FROM ContSATCFDTempAPP WHERE MacAddress = @MacAddress AND Modulo = @Modulo AND ModuloID = @ModuloID)
BEGIN
EXEC spContSatAsociarRegistroAPP  @MacAddress, @ModuloID , @Empresa, @Modulo, @Mov, NULL, @Usuario, 'SINAFECTAR',@Moneda, @TipoCambio, @Ok OUTPUT,  @OkRef OUTPUT
END
RETURN
END

