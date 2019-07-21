SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInsertarCFDFlexTemp
@Estacion           int,
@Empresa            varchar(5),
@Modulo             varchar(5),
@ID                 int,
@EstatusNuevo       varchar(15),
@Estatus            varchar(15),
@Mov                varchar(20),
@MovID              varchar(20),
@Ok                 int             OUTPUT,
@OkRef              varchar(255)    OUTPUT

AS BEGIN
INSERT CFDFlexTemp(Estacion,  Empresa,  Modulo,  ID,  Estatus,       EstatusAnterior, Mov,  MovID)
SELECT             @Estacion, @Empresa, @Modulo, @ID, @EstatusNuevo, @Estatus,        @Mov, @MovID
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL AND dbo.fnTipoCFD(@Modulo, @Mov, @EstatusNuevo)= 1
EXEC spValidarCamposCFDFlex  @Modulo, @ID, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

