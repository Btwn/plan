SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSGenerarComponenteCB
@ID						varchar(36),
@Codigo					varchar(50),
@Estacion				int,
@ArticuloPrincipal		varchar(20),
@RenglonID				int

AS
BEGIN
DECLARE
@Ok         int,
@Mensaje	varchar(255)
EXEC spPOSInsertaComponenteCB @ID, @Codigo, @Estacion, @ArticuloPrincipal, @RenglonID , 0, @Mensaje OUTPUT
IF @Mensaje IS NULL
SELECT @Mensaje = 'INGRESE EL NUEVO COMPONENTE'
SELECT @Mensaje
END

