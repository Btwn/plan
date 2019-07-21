SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepCampanaLlamadas
@FechaD   datetime,
@FechaA   datetime,
@Empresa  varchar(10)

AS BEGIN
SELECT c.ID, c.Mov, c.MovID, c.Asunto, cd.RID, ISNULL(ce.Tipo, 'Otra') as 'Tipo', ce.Observaciones, cd.Usuario, u.Nombre,
TotalLlamadas = (SELECT count(ce.Tipo) FROM CampanaEvento ce WHERE ID=cd.ID /*AND ce.Tipo in ('Llamada')*/ AND ce.FechaHora BETWEEN @FechaD AND @FechaA)
FROM Campana c
JOIN CampanaD cd ON c.ID = cd.ID
JOIN CampanaEvento ce ON c.ID = ce.ID AND cd.RID = ce.RID
JOIN Usuario u  ON cd.Usuario = u.Usuario
JOIN MovTipo m ON c.Mov = m.Mov AND m.Modulo = 'CMP'
WHERE c.Empresa = @Empresa
AND dbo.fnFechaSinHora(ce.FechaHora) BETWEEN dbo.fnFechaSinHora(@FechaD) AND dbo.fnFechaSinHora(@FechaA)
AND m.Clave <> 'CMP.A' 
RETURN
END

