SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelInsertaUnidades]

AS BEGIN
INSERT INTO ArtUnidad (Articulo, Unidad, Factor, Peso, Volumen)
SELECT DISTINCT Articulo, Valor, Factor, Peso, Volumen
FROM AspelCargaProp WITH (NOLOCK) where ARticulo not in (SELECT articulo from Artunidad WITH (NOLOCK))
AND Campo = 'Unidad'
INSERT INTO Unidad (Unidad, Factor, Decimales)
SELECT DISTINCT Valor, Factor, 5
FROM AspelCargaProp WITH (NOLOCK) WHERE UPPER(Valor) not in (select UPPER(Unidad) from Unidad WITH (NOLOCK))
AND Campo = 'Unidad'
INSERT INTO UnidadConversion(Unidad, Conversion)
SELECT DISTINCT Valor, Unidad
FROM AspelCargaProp WITH (NOLOCK) where Unidad not in (select Unidad from Unidadconversion WITH (NOLOCK))
AND Campo = 'Unidad' AND Unidad <> ''
END

