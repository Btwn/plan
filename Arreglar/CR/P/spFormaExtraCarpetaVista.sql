SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFormaExtraCarpetaVista
@Accion		varchar(20),		
@FormaExtra	varchar(100),
@Carpeta	varchar(100),
@Vista		varchar(100),
@Datos		text

AS BEGIN
SELECT @Accion = UPPER(@Accion)
IF @Accion = 'AGREGAR'
BEGIN
UPDATE FormaExtraCarpetaVista
SET Datos = @Datos
WHERE FormaExtra = @FormaExtra AND Carpeta = @Carpeta AND Vista = @Vista
IF @@ROWCOUNT = 0
INSERT FormaExtraCarpetaVista (FormaExtra, Carpeta, Vista, Datos) VALUES (@FormaExtra, @Carpeta, @Vista, @Datos)
END ELSE
IF @Accion = 'ELIMINAR'
DELETE FormaExtraCarpetaVista
WHERE FormaExtra = @FormaExtra AND Carpeta = @Carpeta AND Vista = @Vista
RETURN
END

