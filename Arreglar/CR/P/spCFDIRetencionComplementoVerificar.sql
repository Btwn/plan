SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionComplementoVerificar
@Estacion		int,
@Empresa		varchar(5),
@Sucursal		int,
@Usuario		varchar(10),
@Proveedor		varchar(10),
@Ok				int				OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS
BEGIN
DECLARE @ConceptoSAT		varchar(2),
@ConceptoSATAnt	varchar(2),
@Complemento		varchar(20),
@Version			varchar(5),
@Vista			varchar(100),
@XMLComplemento	varchar(max),
@Referencia		varchar(50)
SELECT Modulo, ModuloID, Complemento, ConceptoSAT, RTRIM(Mov)+' '+RTRIM(MovID) 'Referencia'
INTO #Valida
FROM CFDIRetencionD
JOIN CFDIRetSATRetencion ON CFDIRetencionD.ConceptoSAT = CFDIRetSATRetencion.Clave
WHERE EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND Proveedor = @Proveedor
AND ISNULL(CFDIRetSATRetencion.Complemento, '') <> ''
SELECT @ConceptoSATAnt = ''
WHILE(1=1)
BEGIN
SELECT @ConceptoSAT = MIN(ConceptoSAT)
FROM #Valida
WHERE ConceptoSAT > @ConceptoSATAnt
IF @ConceptoSAT IS NULL BREAK
SELECT @ConceptoSATAnt = @ConceptoSAT
SELECT @Version = NULL, @Vista = NULL, @Complemento = NULL
SELECT @Complemento = Complemento, @Referencia = Referencia FROM #Valida WHERE ConceptoSAT = @ConceptoSAT
SELECT @Version = Version, @Vista = Vista FROM CFDIRetencionCompXMLPlantilla WHERE Complemento = @Complemento
EXEC spCFDIRetencionXMLComplemento @Estacion, @Empresa, @Sucursal, @Usuario, @Proveedor, @ConceptoSAT, @Version, @Vista, NULL, @XMLComplemento = @XMLComplemento OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @XMLComplemento = REPLACE(ISNULL(@XMLComplemento, ''), 'T00:00:00', '')
SELECT @XMLComplemento = dbo.fnCFDILimpiarXML(@XMLComplemento, ' SELLO CERTIFICADO ')
SELECT @XMLComplemento = REPLACE(@XMLComplemento, '<pagosaextranjeros:Beneficiario />', '')
IF @Ok IS NULL
EXEC spCFDIRetencionXMLCompVerificar @Estacion, @Empresa, @Sucursal, @Usuario, @Proveedor, @ConceptoSAT, @Version, @XMLComplemento, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NOT NULL
BEGIN
SELECT @OkRef = '('+@Referencia+') ' + @OkRef
UPDATE CFDIRetencionD
SET Ok = @Ok,
OkRef = @OkRef
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND Empresa = @Empresa
AND Proveedor = @Proveedor
END
END
RETURN
END

