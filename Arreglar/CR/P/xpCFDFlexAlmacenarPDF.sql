SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.xpCFDFlexAlmacenarPDF
@Empresa                            varchar(5),
@Modulo                             varchar(5),
@ModuloID                           int,
@AlmacenarPDF                       varchar(5)      OUTPUT,
@Ok                                 int             OUTPUT,
@OkRef                              varchar(255)    OUTPUT
AS BEGIN
RETURN
END

