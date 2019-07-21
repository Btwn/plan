SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFormaVirtualCopiar
@FormaVirtualD	varchar(100),
@FormaVirtualA	varchar(100)

AS BEGIN
IF NOT EXISTS(SELECT * FROM FormaVirtual WHERE FormaVirtual = @FormaVirtualA)
BEGIN
DELETE FormaVirtualCarpeta WHERE FormaVirtual = @FormaVirtualA
DELETE FormaVirtualCampo   WHERE FormaVirtual = @FormaVirtualA
DELETE FormaVirtualAccion  WHERE FormaVirtual = @FormaVirtualA
INSERT FormaVirtual (
FormaVirtual,   Titulo, Forma, Modo)
SELECT @FormaVirtualA, Titulo, Forma, Modo
FROM FormaVirtual
WHERE FormaVirtual = @FormaVirtualD
INSERT FormaVirtualCarpeta (
FormaVirtual,   Carpeta, Nombre, Pagina, Etiqueta, Visible, Orden, Filtro1, Filtro2, Filtro3, Filtro4, Filtro5, Filtro6)
SELECT @FormaVirtualA, Carpeta, Nombre, Pagina, Etiqueta, Visible, Orden, Filtro1, Filtro2, Filtro3, Filtro4, Filtro5, Filtro6
FROM FormaVirtualCarpeta
WHERE FormaVirtual = @FormaVirtualD
INSERT FormaVirtualCampo (
FormaVirtual,   Vista, Campo, Nombre, Etiqueta, Visible, Activo)
SELECT @FormaVirtualA, Vista, Campo, Nombre, Etiqueta, Visible, Activo
FROM FormaVirtualCampo
WHERE FormaVirtual = @FormaVirtualD
INSERT FormaVirtualAccion (
FormaVirtual,   Accion, Nombre, Etiqueta, Visible, Activo)
SELECT @FormaVirtualA, Accion, Nombre, Etiqueta, Visible, Activo
FROM FormaVirtualAccion
WHERE FormaVirtual = @FormaVirtualD
END
RETURN
END

