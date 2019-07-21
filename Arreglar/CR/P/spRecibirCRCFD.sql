SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRecibirCRCFD
@XML	text

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
@CFDCadenaOriginal		varchar(max),
@RegistroModificado		xml,
@iDatos					int,
@CRAfectarAuto			bit
DECLARE @Documento TABLE
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
SET @XMLMAX = CONVERT(varchar(max),@XML)
SET @XMLMAX = REPLACE(@XMLMAX,'encoding="UTF-8"','encoding="WINDOWS-1252"')
EXEC sp_xml_preparedocument @iXML OUTPUT, @XMLMAX
INSERT @Documento (Empresa, Sucursal, FechaTrabajo, ID, CFDID, CFDSerie, CFDFolio, Registro, CadenaOriginal)
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
FROM openxml (@iXML,'/CR/Registro',3)
WITH (Empresa varchar(5) '../@Empresa', Sucursal int '../@Sucursal', FechaTrabajo datetime '../@FechaTrabajo', ID int, CFDID int, CFDSerie varchar(20), CFDFolio varchar(20), Registro varchar(max) '.', CadenaOriginal varchar(max))
EXEC sp_xml_removedocument @iXML
DECLARE crDocumento CURSOR FOR
SELECT Empresa, Sucursal, CFDSerie, CFDFolio, Registro, FechaTrabajo, ID, CFDID, CadenaOriginal
FROM @Documento
OPEN crDocumento
FETCH NEXT FROM crDocumento INTO @Empresa, @Sucursal, @CFDSerie, @CFDFolio, @Registro, @FechaTrabajo, @ID, @CFDID, @CadenaOriginal
WHILE @@FETCH_STATUS = 0
BEGIN
IF EXISTS(SELECT * FROM CRCFD WHERE CFDFolio = @CFDFolio AND CFDSerie = @CFDSerie AND Sucursal = @Sucursal AND Empresa = @Empresa)
BEGIN
UPDATE CRCFD
SET
FechaTrabajo   = @FechaTrabajo,
ID             = @ID,
CFDID          = @CFDID,
CadenaOriginal = @CadenaOriginal,
Registro       = @Registro,
Estatus        = 'PENDIENTE'
WHERE CFDFolio = @CFDFolio AND CFDSerie = @CFDSerie AND Sucursal = @Sucursal AND Empresa = @Empresa AND Estatus NOT IN ('CONCLUIDO')
END ELSE
BEGIN
INSERT CRCFD (Empresa,  Sucursal,  CFDSerie,  CFDFolio,  FechaTrabajo,  ID,  CFDID,  Registro,  Estatus,     CadenaOriginal)
VALUES (@Empresa, @Sucursal, @CFDSerie, @CFDFolio, @FechaTrabajo, @ID, @CFDID, @Registro, 'PENDIENTE', @CadenaOriginal)
END
SELECT @CRAfectarAuto = ISNULL(CRAfectarAuto, 0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @CRAfectarAUTO = 1
EXEC spCRCFDAfectar @Empresa, @Sucursal, @CFDSerie, @CFDFolio
FETCH NEXT FROM crDocumento INTO @Empresa, @Sucursal, @CFDSerie, @CFDFolio, @Registro, @FechaTrabajo, @ID, @CFDID, @CadenaOriginal
END
CLOSE crDocumento
DEALLOCATE crDocumento
SELECT "Mensaje" = ''
RETURN
END

