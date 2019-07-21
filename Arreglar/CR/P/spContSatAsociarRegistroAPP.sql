SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContSatAsociarRegistroAPP
@MacAddress		varchar(50),
@ID      		int,
@Empresa  		varchar(5),
@Modulo  		varchar(5),
@Mov      		varchar(20),
@MovID  		varchar(20),
@Usuario        varchar(10),
@Estatus        varchar(15),
@Moneda         varchar(10),
@TipoCambio     float,
@Ok		        int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE
@Ruta           varchar(500),
@UUID           varchar(50),
@RFCEmisor      varchar(50),
@RFCReceptor    varchar(50),
@Documento      varchar(max),
@FechaTimbrado  datetime,
@Monto          float
BEGIN TRAN Manual
IF (@Modulo IN('VTAS','CXC')) AND (SELECT COUNT(*) FROM ContSATCFDTempAPP WHERE MacAddress = @MacAddress GROUP BY UUID HAVING COUNT(*) > 1) > 1
BEGIN
SELECT @Ok = Mensaje, @OkRef = 'Solo puedes asociar un Folio Fiscal a este modulo.'
FROM MensajeLista WHERE Mensaje = 30013
ROLLBACK TRAN Manual
SELECT @OkRef
RETURN
END
IF ( SELECT COUNT(*) FROM ContSATCFDTempAPP WHERE MacAddress = @MacAddress GROUP BY UUID HAVING COUNT(*) > 1) > 1
BEGIN
SELECT @Ok = Mensaje, @OkRef = 'Estas tratando de asociado dos Folio Fiscal iguales al mismo movimiento.'
FROM MensajeLista WHERE Mensaje = 30013
ROLLBACK TRAN Manual
SELECT @OkRef
RETURN
END
SELECT @Moneda = ISNULL(NULLIF(@Moneda,''),'MXN'), @TipoCambio = ISNULL(@TipoCambio,1.0)
DECLARE crXML CURSOR LOCAL FAST_FORWARD FOR
SELECT UUID, RFCEmisor, RFCReceptor, Fecha, Importe, Ruta, Documento
FROM ContSATCFDTempAPP
WHERE MacAddress = @MacAddress
OPEN crXML
FETCH NEXT FROM crXML INTO @UUID, @RFCEmisor, @RFCReceptor, @FechaTimbrado, @Monto, @Ruta, @Documento
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @FechaTimbrado IS NULL
SELECT @FechaTimbrado = GETDATE()
IF @Modulo IN('VTAS','CXC')
BEGIN
IF NOT EXISTS(SELECT * FROM CFD WHERE Modulo = @Modulo AND ModuloID = @ID)
INSERT CFD(Modulo,  ModuloID, Fecha,           Ejercicio,                     Periodo,                        Empresa,  RFC,          Documento, UUID , FechaTimbrado, Timbrado, Importe)
SELECT     @Modulo, @ID,      @FechaTimbrado,  DATEPART(year,@FechaTimbrado), DATEPART(MONTH,@FechaTimbrado), @Empresa, @RFCReceptor, @Documento, @UUID, @FechaTimbrado, 1, @Monto
END
ELSE
BEGIN
IF EXISTS(SELECT * FROM CFDEgreso WHERE UUID = @UUID AND Modulo = @Modulo AND ModuloID = @ID)
BEGIN
SELECT @Ok = Mensaje, @OkRef = 'El Folio Fiscal ya esta asociado a un movimiento.'
FROM MensajeLista WHERE Mensaje = 30013
END
INSERT CFDEgreso (Modulo,  ModuloID, Documento,  RFCEmisor,  RFCReceptor,  UUID,  FechaTimbrado,  Monto,  Moneda,  TipoCambio, Empresa)
SELECT            @Modulo, @ID,      @Documento, @RFCEmisor, @RFCReceptor, @UUID, @FechaTimbrado, @Monto, @Moneda, @TipoCambio, @Empresa
EXCEPT
SELECT Modulo,  ModuloID, Documento,  RFCEmisor,  RFCReceptor,  UUID,  FechaTimbrado,  Monto,  Moneda,  TipoCambio,Empresa
FROM CFDEgreso
END
FETCH NEXT FROM crXML INTO @UUID, @RFCEmisor, @RFCReceptor, @FechaTimbrado, @Monto, @Ruta, @Documento
END
CLOSE crXML
DEALLOCATE crXML
IF(@OkRef IS NULL)
BEGIN
COMMIT TRAN Manual
IF @Estatus NOT IN('SINAFECTAR','BORRADOR','CONFIRMAR')
EXEC xpContSAT @Empresa, @Modulo, @ID, NULL
END
ELSE
BEGIN
ROLLBACK TRAN Manual
SELECT @OkRef
END
RETURN
END

