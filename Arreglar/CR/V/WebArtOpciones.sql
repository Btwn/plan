SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW WebArtOpciones

AS
SELECT v.ID, v.VariacionID, v.OpcionID, o.Nombre,o.OpcionIntelisis, o.Orden OrdenOpcion, v.Orden, v.NumeroIntelisis,v.Valor
FROM WebArtOpcion o LEFT JOIN WebArtOpcionValor v ON o.ID = v.OpcionID AND o.VariacionID = v.VariacionID

