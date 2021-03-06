SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInInsertarRutaTabla
@eDocIn			varchar(50),
@Ruta			varchar(50),
@Modulo			varchar(20)

AS BEGIN
IF NOT EXISTS(SELECT * FROM eDocInRutaTabla WHERE eDocIn = @eDocIn AND Ruta = @Ruta)
BEGIN
INSERT eDocInRutaTabla(eDocIn,  Ruta,  Tablas, DetalleDe)
SELECT @eDocIn, @Ruta, Tablas,  DetalleDe
FROM eDocInModuloOmision
WHERE Modulo = @Modulo
ORDER BY Orden
END
END

