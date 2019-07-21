SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroIS_Sincronizar
@Usuario	varchar(10),
@Debug		bit	= 0

AS BEGIN
DECLARE @Sucursal							int,
@Transmitiendo					bit,
@SincroISDropBox					bit,
@SincroISDropBoxRuta				varchar(255),
@ISDropBoxDiasResguardoArchivos	int,
@Ok								int,
@OkRef							varchar(255)
CHECKPOINT
DBCC DROPCLEANBUFFERS
EXEC("CHECKPOINT; DBCC DROPCLEANBUFFERS;")
SELECT @Sucursal = Sucursal, @Transmitiendo = SincroISTransmitiendo, @SincroISDropBox = ISNULL(SincroISDropBox, 0), @SincroISDropBoxRuta = dbo.fnDirectorioEliminarDiagonalFinal(SincroISDropBoxRuta), @ISDropBoxDiasResguardoArchivos = ISDropBoxDiasResguardoArchivos FROM Version
IF @SincroISDropBox = 1
BEGIN
EXEC spSincroISReceptorEliminarArchivosDropBox @SincroISDropBox, @SincroISDropBoxRuta, @Sucursal, @ISDropBoxDiasResguardoArchivos
EXEC spSincroISReceptorPaqueteDropBox @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spSincroISReceptorDropBox
END
EXEC spSetInformacionContexto 'SINCROIS', 1
UPDATE Version SET SincroISTransmitiendo = 1
EXEC spSetInformacionContexto 'SINCROIS', 0
EXEC spSincroIS_Recibir @Usuario, @Debug
IF @Sucursal > 0 EXEC spSincroIS_Enviar @Usuario
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
EXEC spSincroISTransmisor @SincroISDropBox = @SincroISDropBox, @SincroISDropBoxRuta = @SincroISDropBoxRuta
SET ANSI_NULLS OFF
SET ANSI_WARNINGS OFF
RETURN
END

