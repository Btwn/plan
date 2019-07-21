SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovReporteIntelisis
@Empresa     varchar(5),
@Modulo	varchar(5),
@Mov		varchar(20),
@ID		int = NULL,
@Afectar bit

AS BEGIN
DECLARE
@ReporteIntelisis       bit,
@Reporteador            varchar(30),
@AlmacenarPDF           bit,
@GenerarPdfAfectar      bit,
@CFDReporteIntelisis    varchar(30),
@Estatus                varchar(15),
@EstatusCfg             varchar(15),
@CFDFlex                bit
SET @ReporteIntelisis = 0
SELECT @CFDFlex = CFDFlex
FROM EmpresaGral
WHERE Empresa = @Empresa 
SET @CFDFlex = ISNULL(@CFDFlex,0)
IF @CFDFlex = 1
BEGIN
SELECT @Reporteador = Reporteador, @AlmacenarPDF = AlmacenarPDF,@GenerarPdfAfectar = GenerarPdfAfectar
FROM EmpresaCFD
WHERE Empresa = @Empresa
IF @Modulo = 'VTAS'
SELECT @Estatus = Estatus, @Mov = Mov
FROM Venta
WHERE ID = @ID
IF @Modulo = 'CXC'
SELECT @Estatus = Estatus, @Mov = Mov
FROM Cxc
WHERE ID = @ID
IF @Reporteador = 'Reporteador Intelisis' AND @AlmacenarPDF = 1 AND (@GenerarPdfAfectar = 1 OR @Afectar = 0)
BEGIN
SELECT @CFDReporteIntelisis = CFDReporteIntelisis
FROM MovTipo
WHERE Modulo = @Modulo AND Mov = @Mov
SELECT @EstatusCfg = MAX(ISNULL(Estatus,''))
FROM MovTipoCFDFlex
WHERE Modulo = @Modulo AND Mov = @Mov
IF ISNULL(@EstatusCfg,'') = ''
SELECT @EstatusCfg = ISNULL(eDocEstatus,'')
FROM MovTipo
WHERE Modulo = @Modulo AND Mov = @Mov
IF ISNULL(@CFDReporteIntelisis,'') <> '' AND (@Estatus = @EstatusCfg OR (@EstatusCfg = '(VARIOS)' AND @Estatus IN (SELECT NULLIF(Estatus,'') FROM MovTipoCFDFlexEstatus WHERE Modulo = @Modulo AND Mov = @Mov)))
BEGIN
SET @ReporteIntelisis = 1
END
END
END
SELECT 'ReporteIntelisis' = @ReporteIntelisis
RETURN
END

