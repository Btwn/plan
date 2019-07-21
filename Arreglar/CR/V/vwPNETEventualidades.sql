SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW dbo.vwPNETEventualidades
AS
SELECT ce.ID, ce.Fecha, ce.Identificacion, ce.Acomp, ce.Apartamento, ce.Cliente, c.Nombre, ce.Torre, ce.Matricula, ce.Cajon, ce.Comentarios
FROM pNetEventualidades ce LEFT JOIN Cte c
ON ce.Cliente = c.Cliente

