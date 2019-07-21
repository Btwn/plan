SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionXMLGenerar
@ID					int,
@Estacion			int,
@Empresa			varchar(5),
@Sucursal			int,
@Usuario			varchar(10),
@Proveedor			varchar(10),
@ConceptoSAT		varchar(2),
@IDMov	            varchar(20),
@Version			varchar(5),
@XML				varchar(max)	OUTPUT,
@XMLDetalle			varchar(max)	OUTPUT,
@XMLComplemento		varchar(max)	OUTPUT,
@XMLAddenda			varchar(max)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS
BEGIN
DECLARE @Vista			varchar(100),
@XMLVerifica		varchar(max)
SELECT @XML = Plantilla, @Vista = Vista FROM CFDIRetencionXMLPlantilla WHERE Version = @Version
/* Actualiza los Montos Gravados y Excentos en la vista CFDIRetencionCalc para que aparescan en el XML
de acuerdo a la tabla de configuración CFDIRetSATRetencion y su concepto (Clave cátalogo SAT) */
EXEC spCFDIRetencionXMLComprobante @Estacion, @Empresa, @Sucursal, @Usuario, @Proveedor, @ConceptoSAT, @Version, @Vista, @XMLComprobante = @XML OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
EXEC spCFDIRetencionXMLDetalle @ID, @Estacion, @Empresa, @Sucursal, @Usuario, @Proveedor, @ConceptoSAT,@IDMov, @Version, @Vista, @XML = @XML OUTPUT, @XMLDetalle = @XMLDetalle OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @XMLVerifica = REPLACE(@XML, '@Complemento', '')
SELECT @XMLVerifica = REPLACE(ISNULL(@XMLVerifica, ''), 'T00:00:00', '')
SELECT @XMLVerifica = dbo.fnCFDILimpiarXML(@XMLVerifica, ' SELLO CERTIFICADO ')
SELECT @XMLVerifica = REPLACE(@XMLVerifica, '@Addenda', '')
SELECT @XMLVerifica = REPLACE(@XMLVerifica, '<retenciones:Nacional />', '')
SELECT @XMLVerifica = REPLACE(@XMLVerifica, '<retenciones:Extranjero />', '')
IF @Ok IS NULL
EXEC spCFDIRetencionXMLVerificar @Estacion, @Empresa, @Sucursal, @Usuario, @Proveedor, @ConceptoSAT, @Version, @XMLVerifica, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
EXEC spCFDIRetencionXMLComplemento @Estacion, @Empresa, @Sucursal, @Usuario, @Proveedor, @ConceptoSAT, @Version, @Vista, @XML = @XML OUTPUT, @XMLComplemento = @XMLComplemento OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @XMLComplemento = REPLACE(ISNULL(@XMLComplemento, ''), 'T00:00:00', '')
SELECT @XMLComplemento = dbo.fnCFDILimpiarXML(@XMLComplemento, ' SELLO CERTIFICADO ')
SELECT @XMLComplemento = REPLACE(@XMLComplemento, '<pagosaextranjeros:Beneficiario />', '')
IF @Ok IS NULL
EXEC spCFDIRetencionXMLCompVerificar @Estacion, @Empresa, @Sucursal, @Usuario, @Proveedor, @ConceptoSAT, @Version, @XMLComplemento, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
EXEC spCFDIRetencionXMLAddenda @Estacion, @Empresa, @Sucursal, @Usuario, @Proveedor, @ConceptoSAT, @Version, @Vista, @XML = @XML OUTPUT, @XMLAddenda = @XMLAddenda OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @XML = REPLACE(ISNULL(@XML, ''), 'T00:00:00', ''),
@XMLComplemento = REPLACE(ISNULL(@XMLComplemento, ''), 'T00:00:00', ''),
@XMLDetalle = REPLACE(ISNULL(@XMLDetalle, ''), 'T00:00:00', ''),
@XMLAddenda = REPLACE(ISNULL(@XMLAddenda, ''), 'T00:00:00', '')
SELECT @XML			 = dbo.fnCFDILimpiarXML(@XML, ' SELLO CERTIFICADO '),
@XMLComplemento = dbo.fnCFDILimpiarXML(@XMLComplemento, ' SELLO CERTIFICADO '),
@XMLDetalle = dbo.fnCFDILimpiarXML(@XMLDetalle, ' SELLO CERTIFICADO '),
@XMLAddenda = dbo.fnCFDILimpiarXML(@XMLAddenda, ' SELLO CERTIFICADO ')
SELECT @XML = REPLACE(@XML, '<retenciones:Nacional />', '')
SELECT @XML = REPLACE(@XML, '<retenciones:Extranjero />', '')
SELECT @XML = REPLACE(@XML , '<pagosaextranjeros:Beneficiario />', '')
SELECT @XML = '<?xml version="1.0" encoding="UTF-8"?>' + @XML
RETURN
END

