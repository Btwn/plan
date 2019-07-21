SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDIRetencionAsunto
@Empresa		varchar(5),
@Proveedor		varchar(10),
@ID			int,
@Asunto		varchar(max) OUTPUT,
@Mensaje		varchar(max) OUTPUT

AS BEGIN
DECLARE @NombreProv		varchar(100),
@RFC				varchar(15),
@ConceptoSAT		varchar(50),
@Retencion		varchar(255),
@Ejercicio		int,
@PeriodoIni		int,
@PeriodoFin		int,
@EmpresaNombre	varchar(100),
@EmpresaRFC		varchar(20)
SELECT @NombreProv = Nombre, @RFC = RFC FROM Prov WITH (NOLOCK) WHERE Proveedor = @Proveedor
SELECT @ConceptoSAT = ConceptoSAT, @Ejercicio = Ejerc, @PeriodoIni = MesIni, @PeriodoFin = MesFin FROM CFDRetencion WITH (NOLOCK) WHERE Modulo = 'CXP' AND ModuloID = @ID
SELECT @EmpresaNombre = Nombre, @EmpresaRFC = RFC FROM Empresa WITH (NOLOCK) WHERE Empresa = @Empresa
SELECT @Retencion = Retencion FROM CFDIRetSATRetencion WITH (NOLOCK) WHERE Clave = @ConceptoSAT
SELECT @Asunto = REPLACE(@Asunto, '<Empresa>', LTRIM(RTRIM(ISNULL(@Empresa, ''))))
SELECT @Asunto = REPLACE(@Asunto, '<EmpresaNombre>', LTRIM(RTRIM(ISNULL(@EmpresaNombre, ''))))
SELECT @Asunto = REPLACE(@Asunto, '<EmpresaRFC>', LTRIM(RTRIM(ISNULL(@EmpresaRFC, ''))))
SELECT @Asunto = REPLACE(@Asunto, '<Proveedor>', LTRIM(RTRIM(ISNULL(@Proveedor, ''))))
SELECT @Asunto = REPLACE(@Asunto, '<Nombre>', LTRIM(RTRIM(ISNULL(@NombreProv,''))))
SELECT @Asunto = REPLACE(@Asunto, '<RFC>', LTRIM(RTRIM(ISNULL(@RFC,''))))
SELECT @Asunto = REPLACE(@Asunto, '<Concepto>', LTRIM(RTRIM(ISNULL(@ConceptoSAT, ''))))
SELECT @Asunto = REPLACE(@Asunto, '<Retencion>', LTRIM(RTRIM(ISNULL(@Retencion, ''))))
SELECT @Asunto = REPLACE(@Asunto, '<Ejercicio>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, @Ejercicio),''))))
SELECT @Asunto = REPLACE(@Asunto, '<PeriodoIni>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, @PeriodoIni),''))))
SELECT @Asunto = REPLACE(@Asunto, '<PeriodoFin>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, @PeriodoFin),''))))
SELECT @Mensaje = REPLACE(@Mensaje, '<Empresa>', LTRIM(RTRIM(ISNULL(@Empresa, ''))))
SELECT @Mensaje = REPLACE(@Mensaje, '<EmpresaNombre>', LTRIM(RTRIM(ISNULL(@EmpresaNombre, ''))))
SELECT @Mensaje = REPLACE(@Mensaje, '<EmpresaRFC>', LTRIM(RTRIM(ISNULL(@EmpresaRFC, ''))))
SELECT @Mensaje = REPLACE(@Mensaje, '<Proveedor>', LTRIM(RTRIM(ISNULL(@Proveedor, ''))))
SELECT @Mensaje = REPLACE(@Mensaje, '<Nombre>', LTRIM(RTRIM(ISNULL(@NombreProv,''))))
SELECT @Mensaje = REPLACE(@Mensaje, '<RFC>', LTRIM(RTRIM(ISNULL(@RFC,''))))
SELECT @Mensaje = REPLACE(@Mensaje, '<Concepto>', LTRIM(RTRIM(ISNULL(@ConceptoSAT, ''))))
SELECT @Mensaje = REPLACE(@Mensaje, '<Retencion>', LTRIM(RTRIM(ISNULL(@Retencion, ''))))
SELECT @Mensaje = REPLACE(@Mensaje, '<Ejercicio>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, @Ejercicio),''))))
SELECT @Mensaje = REPLACE(@Mensaje, '<PeriodoIni>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, @PeriodoIni),''))))
SELECT @Mensaje = REPLACE(@Mensaje, '<PeriodoFin>', LTRIM(RTRIM(ISNULL(CONVERT(varchar, @PeriodoFin),''))))
END

