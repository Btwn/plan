SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRHRegistroPatronal
@ID             int,
@Registro       varchar(20),
@Folio          int,
@Estatus        varchar(15),
@AnexoEnvío     varchar(255),
@AnexoRespuesta varchar(255),
@Secuencia      int

AS BEGIN
DECLARE
@Ok                 int,
@OkRef              varchar(255)
IF @Secuencia <> 0
UPDATE RHRegistroPatronal
SET Folio              = @Folio,
Estatus            = @Estatus,
AnexoEnvio         = @AnexoEnvío,
AnexoRespuesta     = @AnexoRespuesta,
SecuencialNotaria  = @Secuencia
WHERE ID = @ID
AND SUBSTRING(RegistroPatronal, 1, 10) = @Registro
ELSE
UPDATE RHRegistroPatronal
SET Estatus            = @Estatus,
AnexoRespuesta     = @AnexoRespuesta
WHERE ID = @ID
AND SUBSTRING(RegistroPatronal, 1, 10) = @Registro
RETURN
END

