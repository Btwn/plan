SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpCFDIRegistrarlog
@Proceso				varchar(100),
@Empresa				varchar(5)	 = NULL,
@Modulo				char(5)		 = NULL,
@ID					int			 = NULL,
@Mov					varchar(20)	 = NULL,
@MovID				varchar(20)	 = NULL,
@Documento			varchar(max) = NULL,
@Timbrado			bit			 = NULL,
@Ok					int			 = NULL,
@OkREf				varchar(255) = NULL,
@Texto				varchar(max) = NULL
AS BEGIN
DECLARE @Registrarlog bit
SELECT @Registrarlog = RegistrarLog FROM EmpresaCFD WHERE Empresa = @Empresa
IF @Timbrado IS NULL SELECT @Timbrado = 0
IF @Registrarlog = 1
BEGIN
INSERT CFDILog (Proceso, Empresa, Modulo, ID, Mov, MovID, Documento, Timbrado, FechaLog, NoError, Mensaje, Texto)
VALUES (@Proceso, @Empresa, @Modulo,  @ID,@Mov, @MovID, @Documento, @Timbrado, getdate(), @Ok, @OkRef, @Texto)
END
RETURN
END

