SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW SysTipoDatos

AS
SELECT "Tabla"		= t.Name,
"Campo"		= c.Name,
"TipoDatos"	= y.Name,
"Tamano"		= c.Length,
"Nulos"		= c.IsNullable,
"Calculado"	= c.iscomputed
FROM sysobjects t,
syscolumns c,
systypes y
WHERE t.id = c.id
AND t.type = 'U'
AND c.xusertype = y.xusertype

