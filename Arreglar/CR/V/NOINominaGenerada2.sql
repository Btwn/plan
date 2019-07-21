SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW NOINominaGenerada2

AS
SELECT n.Empresa,n.ID,n.FechaD,n.FechaA,n.Estatus
FROM Nomina n JOIN MovTipo m ON n.Mov = m.Mov AND m.Modulo = 'NOM'
WHERE n.Estatus = 'CANCELADO'
AND n.NOI = 1
AND m.Clave IN('NOM.N','NOM.NE')
AND n.FechaA NOT IN(SELECT n.FechaA FROM Nomina n JOIN MovTipo m ON n.Mov = m.Mov AND m.Modulo = 'NOM' WHERE n.Estatus NOT IN('CONCLUIDO','BORRADOR') AND n.NOI = 1
AND m.Clave IN('NOM.N','NOM.NE'))
GROUP BY n.Empresa,n.ID,n.FechaD,n.FechaA ,n.Estatus
UNION ALL
SELECT n.Empresa,n.ID,n.FechaD,n.FechaA,n.Estatus
FROM Nomina n JOIN MovTipo m ON n.Mov = m.Mov AND m.Modulo = 'NOM'
WHERE n.Estatus = 'BORRADOR'
AND n.NOI = 1
AND m.Clave IN('NOM.N','NOM.NE')
GROUP BY n.Empresa,n.ID,n.FechaD,n.FechaA,n.Estatus

