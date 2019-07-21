SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAsisteNoReportoAsistenciaEnviaEmail
@Estacion		int

AS BEGIN
DECLARE @InfoEmpresa   	varchar(5),
@InfoSucursal		int,
@InfoFechaD		DateTime,
@InfoFechaA		DateTime,
@DBMailPerfil		varchar(50)
SELECT @InfoEmpresa = rp.InfoEmpresa,
@InfoSucursal = rp.InfoSucursal,
@InfoFechaD = rp.InfoFechaD,
@InfoFechaA = rp.InfoFechaA
FROM RepParam rp
WHERE rp.Estacion = @Estacion
SELECT @DBMailPerfil = eg.DBMailPerfil
FROM EmpresaGral eg
WHERE eg.Empresa = @InfoEmpresa
DELETE AsisteEmailEnviado
EXEC spAsisteNoReportoAsistenciaCalc @Estacion, @InfoEmpresa, @InfoFechaD, @InfoFechaA, @ReportaA = NULL, @Sucursal = @InfoSucursal, @EnviarMail = 1, @DBMailPerfil = @DBMailPerfil
/*SELECT aee.Empresa,
aee.FechaEnvio,
aee.Personal,
aee.Email,
aee.Titulo,
aee.Mensaje,
aee.Estatus
FROM AsisteEmailEnviado aee
WHERE aee.Estacion = @Estacion
AND aee.Empresa = @InfoEmpresa */
END

