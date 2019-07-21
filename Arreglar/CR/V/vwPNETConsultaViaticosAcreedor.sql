SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.vwPNETConsultaViaticosAcreedor
AS
SELECT
ROW_NUMBER() OVER ( ORDER BY CONVERT(DATETIME,g.ID) DESC) AS RowIndex,
g.ID,
g.Mov,
g.FechaEmision,
g.Observaciones,
g.Moneda,
g.Clase,
g.SubClase,
g.Estatus,
g.Comentarios,
g.Nota,
g.Acreedor,
g.FormaPago FROM Gasto as g

