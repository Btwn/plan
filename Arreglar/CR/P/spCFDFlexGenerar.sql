SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDFlexGenerar
@Estacion        int,
@ID              int,
@Modulo          varchar(5),
@Ok              int 	 OUTPUT,
@OkRef           varchar(255)OUTPUT

AS BEGIN
DECLARE
@Empresa            varchar(5),
@Estatus            varchar(15),
@EstatusAnterior    varchar(15),
@Mov                varchar(20),
@MovID              varchar(20),
@eDocOk             int,
@eDocOkRef          varchar(255)
SELECT @Empresa = Empresa, @Estatus = Estatus, @EstatusAnterior = EstatusAnterior, @Mov = Mov, @MovID = MovID
FROM CFDFlexTemp
WHERE ID = @ID AND Modulo = @Modulo AND Estacion = @@SPID
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
BEGIN
SELECT @eDocOk = NULL, @eDocOkRef = NULL
EXEC spCFDFlex @Estacion, @Empresa, @Modulo, @ID, @Estatus, @eDocOk OUTPUT, @eDocOkRef OUTPUT, 0, @Mov, @MovID, NULL, 0, 0, NULL, NULL, @EstatusAnterior
IF @eDocOk IS NOT NULL SELECT @Ok = @eDocOk, @OkRef = @eDocOkRef
END
RETURN
END

