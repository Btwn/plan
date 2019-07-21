SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpCFDParcialidad
@ID					int,
@Modulo				varchar(20),
@Empresa				varchar(20),
@Mov					varchar(20),
@MovTipo			    varchar(20),
@Concepto				varchar(50) OUTPUT,
@FormadePago			varchar(255) OUTPUT,
@FolioFiscalOrig		varchar(50) OUTPUT,
@SerieFolioFiscalOrig	varchar(20) OUTPUT,
@FechaFolioFiscalOrig	datetime OUTPUT,
@MontoFolioFiscalOrig	float OUTPUT,
@Ok					int OUTPUT,
@OkRef					varchar(255) OUTPUT
AS BEGIN
RETURN
END

