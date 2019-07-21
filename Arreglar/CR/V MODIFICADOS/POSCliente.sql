SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW POSCliente

AS
SELECT Cte.Cliente, Cte.Nombre, Cte.RFC, Cte.Estatus, Cte.Situacion, Cte.Categoria,Cte.Familia,Cte.Grupo,Cte.Agente,Cte.Tipo,Cte.Espacio,cb.Codigo
FROM Cte Cte WITH(NOLOCK) LEFT JOIN CB cb WITH(NOLOCK) ON Cte.Cliente = cb.Cuenta AND cb.TipoCuenta = 'Clientes'

