SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexInfo
@Estacion				int,
@Empresa				varchar(5),
@Sucursal				int,
@Tipo					varchar(20),
@NoCertificado		varchar(20)  = NULL OUTPUT,
@ContrasenaSello		varchar(100) = NULL OUTPUT,
@CertificadoBase64	varchar(max) = NULL OUTPUT,
@RutaLlave			varchar(255) = NULL OUTPUT,
@RutaCertificado		varchar(255) = NULL OUTPUT,
@Ok					int			 = NULL OUTPUT,
@OkRef				varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@SucursalCFDFlex  bit
SELECT @SucursalCFDFlex = ISNULL(CFDFlex, 0) FROM Sucursal WITH (NOLOCK) WHERE Sucursal = @Sucursal
IF ISNULL(@SucursalCFDFlex, 0) = 1 AND ISNULL(@Tipo,'') <> 'Empresa'
SELECT @NoCertificado = NoCertificado,
@ContrasenaSello = ContrasenaSello,
@CertificadoBase64 = CertificadoBase64,
@RutaLlave = Llave,
@RutaCertificado = RutaCertificado
FROM Sucursal WITH (NOLOCK)
WHERE Sucursal = @Sucursal
ELSE
SELECT @NoCertificado = NoCertificado,
@ContrasenaSello = ContrasenaSello,
@CertificadoBase64 = CertificadoBase64,
@RutaLlave = Llave,
@RutaCertificado = RutaCertificado
FROM EmpresaCFD WITH (NOLOCK)
WHERE Empresa = @Empresa
END

