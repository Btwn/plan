SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.xpCxAplicaDifMov
@ID                                 int,
@AplicaDifID                        int,
@Modulo                             char(5),
@Accion                             char(20),
@Base                               char(20),
@FechaRegistro                      datetime,
@GenerarMov                         char(20),
@Usuario                            char(10),
@Conexion                           bit,
@SincroFinal                        bit,
@Mov                                char(20)        OUTPUT,
@MovID                              varchar(20)     OUTPUT,
@IDGenerar                          int             OUTPUT,
@Ok                                 int             OUTPUT,
@OkRef                              varchar(255)    OUTPUT,
@INSTRUCCIONES_ESP                  varchar(20)     = NULL
AS BEGIN
RETURN
END

