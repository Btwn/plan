SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexTimbrarCFDILote
@Estacion			int,
@Empresa			varchar(5),
@Usuario			varchar(10)

AS BEGIN
DECLARE
@RutaTemporal		varchar(255),
@Modulo				varchar(5),
@ModuloID			int,
@Archivo			varchar(255),
@XML				varchar(max),
@Temporal			varchar(255),
@Timbrado			bit,
@Ok					int,
@OkRef				varchar(255),
@Mov				varchar(20),
@MovID				varchar(20),
@iDatos				int,
@RutaCFDI			varchar(255),
@CFDUUID			uniqueidentifier,
@CFDFechaTimbrado	datetime,
@TFDVersion			varchar(10),
@SelloSAT			varchar(max),
@noCertificadoSAT	varchar(20),
@PrefijoCFDI		varchar(255),
@Estatus            varchar(15)
DECLARE crListaModuloID CURSOR FOR
SELECT Modulo, ID
FROM ListaModuloID
WHERE Estacion = @Estacion
OPEN crListaModuloID
FETCH NEXT FROM crListaModuloID INTO @Modulo, @ModuloID
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Mov = '', @MovID = ''
IF @Modulo = 'VTAS'
SELECT @Mov = RTRIM(Mov), @MovID = RTRIM(MovID), @Estatus = Estatus FROM Venta WHERE ID = @ModuloID
ELSE
IF @Modulo = 'COMS'
SELECT @Mov = RTRIM(Mov), @MovID = RTRIM(MovID), @Estatus = Estatus FROM Compra WHERE ID = @ModuloID
ELSE
IF @Modulo = 'CXC'
SELECT @Mov = RTRIM(Mov), @MovID = RTRIM(MovID), @Estatus = Estatus FROM Cxc WHERE ID = @ModuloID
ELSE
IF @Modulo = 'CXP'
SELECT @Mov = RTRIM(Mov), @MovID = RTRIM(MovID), @Estatus = Estatus FROM Cxp WHERE ID = @ModuloID
EXEC spCFDFlex @Estacion, @Empresa, @Modulo, @ModuloID, @Estatus, @Ok OUTPUT, @OkRef OUTPUT
IF @@ERROR <> 0 SET @Ok = 1
FETCH NEXT FROM crListaModuloID INTO @Modulo, @ModuloID
END
CLOSE crListaModuloID
DEALLOCATE crListaModuloID
DELETE FROM ListaModuloID WHERE Estacion = @Estacion
IF @Ok IS NOT NULL
BEGIN
SELECT @OkRef =  ISNULL(Descripcion,'') +ISNULL(@OkRef,'') FROM MensajeLista WHERE Mensaje = @Ok
SELECT @OkRef
END
ELSE
SELECT 'PROCESO CONCLUIDO EXISTOSAMENTE'
END

