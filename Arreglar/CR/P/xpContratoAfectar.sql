SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.xpContratoAfectar
@ID                             int,
@Accion                         char(20),
@Empresa                        char(5),
@Modulo                         char(5),
@Mov                            char(20),
@MovID                          varchar(20),
@MovTipo                        varchar(20),
@FechaEmision                   datetime,
@FechaAfectacion                datetime,
@FechaConclusion                datetime,
@Estatus                        varchar(15),
@EstatusNuevo                   varchar(15),
@IDGenerar                      int             OUTPUT,
@Usuario                        varchar(10),
@Ok                             int             OUTPUT,
@OkRef                          varchar(255)    OUTPUT
AS
BEGIN
RETURN
END

