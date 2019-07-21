SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpCFDValidarFolio
@Sucursal			int,
@Empresa     		char(5),
@Modulo				char(5),
@Mov      			char(20),
@MovID				varchar(20),
@ModuloAfectacion	varchar(5),
@ID					int,
@VersionCFD			varchar(10),
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT
AS
BEGIN
RETURN
END

