SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFormaCampoHTML
@FormaTipo		varchar(20)

AS BEGIN
SELECT fc.Campo, fc.Etiqueta, fc.Grupo, fc.TipoDato, fc.EsContrasena, fc.EsMayusculas, fc.LongitudMaxima, fc.AyudaTipo
FROM FormaCampo fc
JOIN FormaGrupo fg ON fg.FormaTipo = fc.FormaTipo and fg.Grupo = fc.Grupo
WHERE fc.FormaTipo = @FormaTipo
ORDER BY fg.Orden, fc.Orden
END

