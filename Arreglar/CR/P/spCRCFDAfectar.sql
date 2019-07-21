SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCRCFDAfectar
(
@EmpresaCR			varchar(5) = NULL,
@SucursalCR			int = NULL,
@CFDSerieCR			varchar(20) = NULL,
@CFDFolioCR			varchar(20) = NULL
)

AS BEGIN
DECLARE
@iXML						int,
@ID						int,
@CFDID					int,
@CFDSerie					varchar(20),
@CFDFolio					varchar(20),
@CFD						varchar(max),
@XMLMAX					varchar(max),
@Empresa					varchar(5),
@Sucursal					int,
@FechaTrabajo				datetime,
@Registro					varchar(max),
@CadenaOriginal			varchar(max),
@ModuloID					int,
@MovID					varchar(20),
@CFDFecha					datetime,
@Ejercicio				int,
@Periodo					int,
@CFDAprobacion			varchar(20),
@CFDnoCertificado			varchar(20),
@CFDSello					varchar(max),
@CFDImporte				float,
@CFDRFC					varchar(15),
@CFDImpuesto1				float,
@CFDImpuesto2				float,
@RegistroModificado		xml,
@iDatos					int
DECLARE @DocumentoX TABLE
(
Empresa			varchar(5) NULL,
Sucursal			int NULL,
FechaTrabajo		datetime NULL,
ID				int NULL,
CFDID				int NULL,
CFDSerie			varchar(20) NULL,
CFDFolio			varchar(20) NULL,
Registro			varchar(max) NULL,
CadenaOriginal	varchar(max) NULL,
ModuloID			int NULL,
MovID				varchar(20)
)
INSERT @DocumentoX (Empresa, Sucursal, FechaTrabajo, ID, CFDID, CFDSerie, CFDFolio, Registro, CadenaOriginal)
SELECT
Empresa,
Sucursal,
FechaTrabajo,
ID,
CFDID,
CFDSerie,
CFDFolio,
Registro,
CadenaOriginal
FROM CRCFD
WHERE CFDFolio = ISNULL(@CFDFolioCR,CFDFolio)
AND CFDSerie = ISNULL(@CFDSerieCR,CFDSerie)
AND Sucursal = ISNULL(@SucursalCR,Sucursal)
AND Empresa  = ISNULL(@EmpresaCR,Empresa)
AND Estatus  = 'PENDIENTE'
UPDATE @DocumentoX
SET
ModuloID = v.ID,
MovID    = v.MovID
FROM @DocumentoX d JOIN Venta v
ON d.Empresa = v.Empresa AND d.Sucursal = v.Sucursal AND d.CFDSerie = v.CRCFDSerie AND d.CFDFolio = v.CRCFDFolio
DECLARE crDocumentoX CURSOR FOR
SELECT Empresa, Sucursal, MovID, CFDSerie, CFDFolio, Registro, ModuloID, CadenaOriginal
FROM @DocumentoX
OPEN crDocumentoX
FETCH NEXT FROM crDocumentoX INTO @Empresa, @Sucursal, @MovID, @CFDSerie, @CFDFolio, @Registro, @ModuloID, @CadenaOriginal
WHILE @@FETCH_STATUS = 0
BEGIN
SET @RegistroModificado = CONVERT(XML,REPLACE(@Registro,'xmlns=','xmlns:Temp='))
EXEC sp_xml_preparedocument @iDatos OUTPUT, @RegistroModificado
SELECT
@CFDFecha = fecha,
@CFDAprobacion = noAprobacion,
@CFDnoCertificado = noCertificado,
@CFDSello = sello,
@CFDImporte = total
FROM OPENXML (@iDatos, '/Comprobante', 1) WITH (fecha datetime, serie varchar(10), folio int, noAprobacion varchar(15), noCertificado varchar(20), sello varchar(max), total float)
SELECT
@CFDRFC = rfc
FROM OPENXML (@iDatos, '/Comprobante/Receptor', 1) WITH (rfc varchar(15))
SELECT
@CFDImpuesto1 = ISNULL(SUM(ISNULL(importe,0.0)),0.0)
FROM OPENXML (@iDatos, '/Comprobante/Impuestos/Traslados/Traslado', 1) WITH (importe float, impuesto varchar(50))
WHERE impuesto = 'IVA'
SELECT
@CFDImpuesto2 = ISNULL(SUM(ISNULL(importe,0.0)),0.0)
FROM OPENXML (@iDatos, '/Comprobante/Impuestos/Traslados/Traslado', 1) WITH (importe float, impuesto varchar(50))
WHERE impuesto = 'IEPS'
EXEC sp_xml_removedocument @iDatos
IF NOT EXISTS(SELECT * FROM CFD WHERE ModuloID = @ModuloID AND Modulo = 'VTAS')
BEGIN
INSERT CFD (Modulo,  ModuloID,  Fecha,     Ejercicio,       Periodo,          Empresa,  MovID,  Serie,     Folio,     RFC,     Aprobacion,     Importe,     Impuesto1,     Impuesto2,     noCertificado,     Sello,     Documento, CadenaOriginal)
VALUES ('VTAS',  @ModuloID, @CFDFecha, YEAR(@CFDFecha), MONTH(@CFDFecha), @Empresa, @MovID, @CFDSerie, @CFDFolio, @CFDRFC, @CFDAprobacion, @CFDImporte, @CFDImpuesto1, @CFDImpuesto2, @CFDnoCertificado, @CFDSello, @Registro, @CadenaOriginal)
END ELSE
BEGIN
UPDATE CFD
SET
Fecha           = @CFDFecha,
Ejercicio       = YEAR(@Ejercicio),
Periodo         = YEAR(@Ejercicio),
Empresa         = YEAR(@Empresa),
MovID           = @MovID,
Serie           = @CFDSerie,
Folio           = @CFDFolio,
RFC             = @CFDRFC,
Aprobacion      = @CFDAprobacion,
Importe         = @CFDImporte,
Impuesto1       = @CFDImpuesto1,
Impuesto2       = @CFDImpuesto2,
noCertificado   = @CFDnoCertificado,
Sello           = @CFDSello,
Documento       = @Registro,
CadenaOriginal  = @CadenaOriginal
WHERE ModuloID = @ModuloID
AND Modulo   = 'VTAS'
END
UPDATE CRCFD SET Estatus = 'CONCLUIDO' WHERE CFDFolio = @CFDFolio AND CFDSerie = @CFDSerie AND Sucursal = @Sucursal AND Empresa = @Empresa AND Estatus NOT IN ('CONCLUIDO')
FETCH NEXT FROM crDocumentoX INTO @Empresa, @Sucursal, @MovID, @CFDSerie, @CFDFolio, @Registro, @ModuloID, @CadenaOriginal
END
CLOSE crDocumentoX
DEALLOCATE crDocumentoX
SELECT "Mensaje" = ''
RETURN
END

