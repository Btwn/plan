SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spPNetNominaCorreoEnviar
@Empresa			varchar(5)
AS BEGIN
DECLARE
@Nombre            varchar(20),
@eMailAutoPerfil	varchar(50),
@eMailAutoAsunto	varchar(255),
@eMailAutoMensaje	varchar(max),
@eMailAutoDias		int,
@Fecha				datetime,
@Personal          varchar(10),
@eMail             varchar(255),
@ReportaA          varchar(10),
@eMailReportaA     varchar(255)
DECLARE @Para TABLE(
Personal      varchar(10)  NULL,
eMail		    varchar(255) NULL,
ReportaA      varchar(10)  NULL,
eMailReportaA varchar(255) NULL)
SELECT @Nombre = MIN(Nombre) FROM EmpresaCfgPNetPlantillas WHERE Empresa = @Empresa AND ISNULL(Condicion,'') = 'Periódica' AND ISNULL(Estatus,'') = 'ACTIVA'
WHILE @Nombre IS NOT NULL
BEGIN
SELECT @eMailAutoPerfil = NULL, @eMailAutoAsunto = NULL, @eMailAutoMensaje = NULL, @eMailAutoDias = NULL
SELECT @eMailAutoPerfil = Perfil, @eMailAutoAsunto = Asunto, @eMailAutoMensaje = Mensaje, @eMailAutoDias = ISNULL(Dias,0)
FROM EmpresaCfgPNetPlantillas WHERE Empresa = @Empresa AND Nombre = @Nombre AND ISNULL(Condicion,'') = 'Periódica' AND ISNULL(Estatus,'') = 'ACTIVA'
IF ISNULL(@eMailAutoPerfil,'') = '' SELECT @eMailAutoPerfil = DBMailPerfil FROM EmpresaGral WHERE Empresa = @Empresa
IF ISNULL(@eMailAutoPerfil,'') <> ''
BEGIN
DELETE FROM @Para
SELECT @Fecha = DATEADD(day, ISNULL(@eMailAutoDias,0), dbo.fnFechaSinHora(GETDATE()))
INSERT INTO @Para
SELECT DISTINCT NominaD.Personal, ISNULL(pnet.eMail, p.eMail), p.ReportaA, ISNULL(pnetr.eMail, pr.eMail)
FROM Nomina
JOIN NominaD ON NominaD.ID = Nomina.ID
JOIN Personal p ON NominaD.Personal = p.Personal
LEFT JOIN pNetUsuario pnet ON p.Personal = pnet.Usuario
LEFT JOIN Personal pr ON p.ReportaA = pr.Personal
LEFT JOIN pNetUsuario pnetr ON p.ReportaA = pnetr.Usuario
WHERE Nomina.Empresa = @Empresa
AND Nomina.FechaA <= @Fecha
AND NominaD.Movimiento IN ('Percepcion', 'Deduccion')
AND Nomina.Estatus = 'CONCLUIDO'
AND NominaD.Modulo IN ('NOM', 'CXC', 'CXP' )
AND Nomina.Mov IN (SELECT Mov FROM MovTipo WHERE Modulo = 'NOM' AND RTRIM(UPPER(Clave)) IN ('NOM.N'))
AND NOT EXISTS (SELECT 1 FROM NominaConsulta nc WHERE nc.Personal = NominaD.Personal AND nc.Empresa = Nomina.Empresa)
AND ISNULL(p.eMail,'') <> ''
ORDER BY NominaD.Personal ASC
SELECT @Personal = MIN(Personal) FROM @Para
WHILE @Personal IS NOT NULL
BEGIN
SELECT @eMail = eMail, @ReportaA = ReportaA, @eMailReportaA = eMailReportaA FROM @Para WHERE Personal = @Personal
IF @Nombre = 'Recordatorio' AND ISNULL(@eMail,'') <> ''
EXEC spEnviarDBMail @Perfil = @eMailAutoPerfil, @Para = @eMail, @Asunto = @eMailAutoAsunto, @Mensaje = @eMailAutoMensaje, @Formato = 'HTML'
IF @Nombre = 'SeguimientO' AND ISNULL(@eMail,'') <> ''
EXEC spEnviarDBMail @Perfil = @eMailAutoPerfil, @Para = @eMail, @CC = @eMailReportaA, @Asunto = @eMailAutoAsunto, @Mensaje = @eMailAutoMensaje, @Formato = 'HTML'
SELECT @Personal = MIN(Personal) FROM @Para WHERE Personal > @Personal
END
END
SELECT @Nombre = MIN(Nombre) FROM EmpresaCfgPNetPlantillas WHERE Empresa = @Empresa AND ISNULL(Condicion,'') = 'Periódica' AND ISNULL(Estatus,'') = 'ACTIVA' AND Nombre > @Nombre
END
RETURN
END

