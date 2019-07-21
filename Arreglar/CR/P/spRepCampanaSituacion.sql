SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepCampanaSituacion
@Empresa  varchar(10),
@Mov      varchar(20),
@Estatus  varchar(15)

AS BEGIN
IF @Mov in (NULL, '', '(Todos)', '(Todas)', 'NULL') SELECT @Mov
IF @Estatus in (NULL, '', '(Todos)', '(Todas)', 'NULL') SELECT @Estatus = NULL
SELECT c.ID, c.Mov, c.MovID, c.Asunto, cd.RID, cd.Situacion,
TotalContatos = (SELECT Count(cd.RID) FROM CampanaD cd WHERE cd.ID = c.ID)
FROM Campana c JOIN CampanaD cd
ON c.ID = cd.ID
WHERE c.Empresa = ISNULL(@Empresa, c.Empresa)
AND c.Mov = ISNULL(@Mov, c.Mov)
AND c.Estatus = ISNULL(@Estatus, c.Estatus)
ORDER BY c.ID
RETURN
END

