SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepHistPersonal
@Estacion		int

AS BEGIN
DECLARE	@PersonalD	varchar(10),
@PersonalA	varchar(10),
@FechaD		DateTime,
@FechaA		DateTime,
@Empresa	char(5)
SELECT @PersonalD = rp.InfoPersonalD,
@PersonalA = rp.InfoPersonalA,
@FechaD = rp.InfoFechaD,
@FechaA = rp.InfoFechaA,
@Empresa = rp.InfoEmpresa
FROM RepParam rp
WHERE rp.Estacion = @Estacion
IF ISNULL(@PersonalD, '') IN ('Todos','(Todos)','', NULL) SELECT @PersonalD = MIN(Personal) FROM Personal
IF ISNULL(@PersonalA, '') IN ('Todos','(Todos)','', NULL) SELECT @PersonalA = MAX(Personal) FROM Personal
SELECT d.Personal,
NombreCompleto = p.Nombre + ' ' + p.ApellidoPaterno + ' ' + ISNULL(p.ApellidoMaterno, ''),
d.ID,
r.Empresa,
r.Mov,
r.MovID,
r.FechaEmision,
r.Moneda,
UsuarioEjecuto = r.Usuario
FROM RH r
INNER JOIN RHD d ON r.ID = d.ID
INNER JOIN Personal p ON d.Personal = p.Personal
WHERE r.Estatus = 'CONCLUIDO'
AND d.Personal BETWEEN @PersonalD AND @PersonalA
AND r.FechaEmision BETWEEN @FechaD AND @FechaA
AND r.Empresa = @Empresa
END

