SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexRegistrarCertificadoXML
@Estacion				int,
@Empresa				varchar(5),
@Sucursal				int,
@Tipo					varchar(20),
@Certificar				bit = 1,
@Temporal				varchar(255) = NULL,
@XML					varchar(max) = NULL OUTPUT,
@Ok						int = NULL OUTPUT,
@OkRef					varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@FechaRegistro		datetime,
@RutaTemporal		varchar(255)
SELECT @FechaRegistro = GETDATE()
SELECT @RutaTemporal = RutaTemporal FROM EmpresaCFD WHERE Empresa = @Empresa
SELECT @Temporal = @RutaTemporal + CASE WHEN SUBSTRING(REVERSE(@RutaTemporal),1,1) <> '\' THEN '\' ELSE '' END + 'Temporal' + CONVERT(varchar,@Estacion) + '.XML'
IF @Tipo = 'Sucursal'
UPDATE Sucursal SET CertificadoBase64 = NULL, noCertificado = NULL WHERE Sucursal = @Sucursal
ELSE
UPDATE EmpresaCFD SET CertificadoBase64 = NULL, noCertificado = NULL WHERE Empresa = @Empresa
IF @Ok IS NULL
EXEC spCFDFlexInsertarCertificadoXML @Estacion, @Empresa, @Sucursal, @Tipo, @Certificar, @Temporal, @XML, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spCFDFlexValidarCertificado @Estacion, @Empresa, @Sucursal, @Tipo, @FechaRegistro, @Temporal, @Ok OUTPUT, @OkRef OUTPUT
IF @Tipo = 'Sucursal'
BEGIN
IF (SELECT CertificadoBase64 FROM Sucursal WHERE Sucursal = @Sucursal) IS NULL
SELECT @Ok = 71580, @OkRef = RutaCertificado FROM Sucursal WHERE Sucursal = @Sucursal
END
ELSE
BEGIN
IF (SELECT CertificadoBase64 FROM EmpresaCFD WHERE Empresa = @Empresa) IS NULL
SELECT @Ok = 71580, @OkRef = RutaCertificado FROM EmpresaCFD WHERE Empresa = @Empresa
END
IF @Ok IS NOT NULL
BEGIN
IF @Tipo = 'Sucursal'
UPDATE Sucursal SET CertificadoBase64 = '', noCertificado = '' WHERE Sucursal = @Sucursal
ELSE
UPDATE EmpresaCFD SET CertificadoBase64 = '', noCertificado = '' WHERE Empresa = @Empresa
SELECT @OkRef = ISNULL(Descripcion,'') + '<BR>' + @OkRef FROM MensajeLista WHERE Mensaje = @Ok
SELECT 'Error: ' + CONVERT(varchar,@Ok) + '<BR>' + @OkRef
END
ELSE
SELECT 'Certificado Válido'
END

