SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepCartaPortePDF
(
@Modulo			varchar(5),
@ID				int,
@Sucursal		int,
@Nombre			varchar(255),
@Ruta			varchar(255)
)

AS
BEGIN
IF NOT EXISTS(SELECT * FROM AnexoMov WHERE Rama = @Modulo AND ID = @ID AND Nombre = @Nombre)
INSERT AnexoMov(Rama, ID, Nombre, Direccion, Icono, Tipo, Orden, Comentario, Sucursal, CFD)
VALUES(@Modulo, @ID, @Nombre, @Ruta, 745, 'Archivo', 1, '', @Sucursal, 0)
END

