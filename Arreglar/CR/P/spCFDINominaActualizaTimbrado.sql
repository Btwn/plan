SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDINominaActualizaTimbrado
@Estacion		int,
@ID				int,
@Personal		varchar(10),
@Empresa		varchar(5),
@Sucursal		int,
@Mov			varchar(20),
@MovID			varchar(20),
@Version		varchar(5),
@XML			varchar(max),
@Usuario		varchar(10),
@ArchivoQRCode	varchar(255),
@ArchivoXML		varchar(255),
@ArchivoPDF		varchar(255),
@NominaTimbrar	bit,
@Ok				int			OUTPUT,
@OkRef			varchar(255)OUTPUT

AS
BEGIN
UPDATE CFDINominaRecibo
SET ArchivoPDF = @ArchivoPDF,
ArchivoXML = @ArchivoXML,
ArchivoQRCode = @ArchivoQRCode,
Timbrado = CASE @NominaTimbrar WHEN 1 THEN 'Timbrado' ELSE 'No Timbrado' END
WHERE ID = @ID
AND Personal = @Personal
UPDATE CFDNomina
SET Timbrado = CASE @NominaTimbrar WHEN 1 THEN 1 ELSE 0 END
WHERE Modulo = 'NOM'
AND ModuloID = @ID
AND Personal = @Personal
IF NOT EXISTS(SELECT * FROM CFDNomina WHERE Modulo = 'NOM' AND ModuloID = @ID AND ISNULL(Timbrado, 0) = 0)
UPDATE Nomina SET CFDTimbrado = 1 WHERE ID = @ID
RETURN
END

