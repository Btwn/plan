SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpCFDFlexAntes
@Estacion		int,
@Empresa		varchar(5),
@Modulo			varchar(5),
@ID				int,
@Estatus		varchar(15),
@Ok				int OUTPUT,
@OkRef			varchar(255) OUTPUT,
@LlamadaExterna	bit = 0,
@Mov			varchar(20) = NULL,
@MovID			varchar(20) = NULL,
@Contacto		varchar(10) = NULL,
@CrearArchivo	bit = 0,
@Debug			bit = 0,
@XMLFinal		varchar(max) = NULL OUTPUT,
@Encripcion     varchar(20) = NULL
AS BEGIN
RETURN
END

