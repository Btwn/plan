SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDistArticuloImagen (
@Empresa              varchar(5),
@Articulo             varchar(20)
)

AS
BEGIN
DECLARE @Nombre       varchar(255)
DECLARE @Direccion    varchar(255)
DECLARE @Rama         varchar(5)
DECLARE @Tipo         varchar(10)
SET @Empresa  = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Articulo = LTRIM(RTRIM(ISNULL(@Articulo,'')))
SET @Rama     = 'INV'
SET @Tipo     = 'Imagen'
SELECT TOP 1
@Nombre    = LTRIM(RTRIM(ISNULL(Nombre,''))),
@Direccion = LTRIM(RTRIM(ISNULL(Direccion,'')))
FROM AnexoCta
WHERE Rama = @Rama
AND Tipo = @Tipo
AND Cuenta = @Articulo
ORDER BY Orden
SELECT @Nombre AS Nombre, @Direccion AS Direccion
END

