SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebSesionPaginaParam
@SesionID	uniqueidentifier,
@Origen		varchar(255),
@Pagina		varchar(20),
@Parametro	varchar(50),
@Valor		varchar(7000),
@Mensaje	varchar(255)	= NULL OUTPUT

AS BEGIN
SELECT @Mensaje = NULL
DELETE WebSesionPaginaParam
WHERE SesionID = @SesionID AND Pagina = @Pagina AND Parametro = @Parametro
INSERT WebSesionPaginaParam (
SesionID,  Pagina,  Parametro,  Valor)
VALUES (@SesionID, @Pagina, @Parametro, @Valor)
RETURN
END

