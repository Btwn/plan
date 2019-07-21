SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDIRetencionAlmacenar
@Empresa		varchar(5),
@Usuario		varchar(10),
@Proveedor		varchar(10),
@ConceptoSAT	varchar(2),
@Version		varchar(5),
@Ejerc			int,
@MesIni			int,
@MesFin			int,
@AlmacenarXML	bit			 OUTPUT,
@AlmacenarPDF	bit			 OUTPUT,
@NomArch		varchar(255) OUTPUT,
@Reporte		varchar(100) OUTPUT,
@Ruta			varchar(255) OUTPUT,
@EnviarPara		varchar(255) OUTPUT,
@EnviarAsunto	varchar(255) OUTPUT,
@EnviarMensaje	varchar(255) OUTPUT,
@Enviar			bit          OUTPUT,
@EnviarXML		bit          OUTPUT,
@EnviarPDF		bit          OUTPUT,
@Cancelacion	bit			 = 0,
@RIDAnt         varchar(20)  = null

AS
BEGIN
DECLARE
@FechaEmision		datetime,
@FechaRegistro		datetime,
@ArchivoXML			varchar(255),
@ArchivoPDF			varchar(255),
@Nombre				varchar(100),
@eMail				varchar(100),
@AlmacenarTipo		varchar(20),
@EnviarTipo			varchar(20),
@EnviarRetencion	bit
SELECT @EnviarXML = 0, @EnviarPDF = 0, @NomArch = NULL
SELECT @Reporte = NULLIF(RepConstancia,'') FROM CFDIRetencionCfg WITH (NOLOCK)
SELECT @AlmacenarXML = AlmacenarXML, @AlmacenarPDF = AlmacenarPDF, @Ruta = RetencionAlmacenarRuta, @Nombre = RetencionNombre, @Enviar = CASE WHEN EnviarXMLRetencion = 1 OR EnviarPDFRetencion = 1 THEN 1 ELSE 0 END,
@EnviarXML = EnviarXMLRetencion, @EnviarPDF = EnviarPDFRetencion, @EnviarAsunto = EnviarAsuntoRetencion, @EnviarMensaje = EnviarMensajeRetencion, @EnviarRetencion = EnviarRetencion
FROM EmpresaCFD WITH (NOLOCK)
WHERE Empresa = @Empresa
IF @EnviarRetencion = 0 SELECT @Enviar = 0, @EnviarPDF = 0, @EnviarXML = 0
IF NULLIF(@EnviarTipo,'') IS NULL SET @EnviarTipo = 'Cliente'
SELECT @NomArch = @Nombre
SELECT @NomArch = REPLACE(@NomArch, '<Empresa>', LTRIM(RTRIM(ISNULL(@Empresa,''))))
SELECT @NomArch = REPLACE(@NomArch, '<Proveedor>', LTRIM(RTRIM(ISNULL(@Proveedor,''))))
SELECT @NomArch = REPLACE(@NomArch, '<Concepto>', LTRIM(RTRIM(ISNULL(@ConceptoSAT,''))))
SELECT @NomArch = REPLACE(@NomArch, '<Ejercicio>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, @Ejerc),''))))
SELECT @NomArch = REPLACE(@NomArch, '<Periodo>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, @MesIni),''))))
IF @RIDAnt IS NOT NULL
SELECT @NomArch = @NomArch+ '_'+CONVERT(VARCHAR,@RIDAnt)
IF @Cancelacion = 1
SELECT @Nomarch = @NomArch+'_CANCELACION'
SELECT @Ruta = REPLACE(@Ruta, '<Proveedor>', LTRIM(RTRIM(ISNULL(@Proveedor,''))))
SELECT @Ruta = REPLACE(@Ruta, '<Ejercicio>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, @Ejerc),''))))
SELECT @Ruta = REPLACE(@Ruta, '<Periodo>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, @MesIni),''))))
SELECT @Ruta = REPLACE(@Ruta, '<Empresa>', LTRIM(RTRIM(ISNULL(@Empresa,''))))
SELECT @Ruta = REPLACE(@Ruta, '<Concepto>', LTRIM(RTRIM(ISNULL(@ConceptoSAT,''))))
EXEC xpCFDRetencionAlmacenar @Empresa, @Usuario, @Proveedor, @ConceptoSAT, @Version, @AlmacenarXML = @AlmacenarXML OUTPUT, @AlmacenarPDF = @AlmacenarPDF OUTPUT,@NomArch = @NomArch OUTPUT,@Reporte = @Reporte OUTPUT,@Ruta = @Ruta OUTPUT,@EnviarPara = @EnviarPara OUTPUT,@EnviarAsunto = @EnviarAsunto OUTPUT,@EnviarMensaje = @EnviarMensaje OUTPUT, @Enviar = @Enviar OUTPUT, @EnviarXML = @EnviarXML OUTPUT, @EnviarPDF = @EnviarPDF OUTPUT, @Cancelacion = @Cancelacion
IF RIGHT(@Ruta, 1) = '\' SELECT @Ruta = SUBSTRING(@Ruta, 1, LEN(@Ruta)-1)
SELECT @EnviarPara = '',
@EnviarAsunto  = REPLACE(@EnviarAsunto, '<Nombre>', @NomArch),
@EnviarMensaje = REPLACE(@EnviarMensaje, '<Nombre>', @NomArch)
SELECT @EnviarPara = eMail1 FROM Prov WITH (NOLOCK) WHERE Proveedor = @Proveedor
RETURN
END

