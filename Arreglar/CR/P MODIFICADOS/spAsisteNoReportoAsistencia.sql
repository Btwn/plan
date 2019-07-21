SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spAsisteNoReportoAsistencia
@Estacion		int

AS BEGIN
DECLARE @InfoEmpresa   	varchar(5),
@InfoSucursal		int,
@InfoReportaA		varchar(10),
@InfoFechaD		DateTime,
@InfoFechaA		DateTime
SELECT @InfoEmpresa = rp.InfoEmpresa,
@InfoSucursal = rp.InfoSucursal,
@InfoReportaA = rp.InfoReportaA,
@InfoFechaD = rp.InfoFechaD,
@InfoFechaA = rp.InfoFechaA
FROM RepParam rp WITH(NOLOCK)
WHERE rp.Estacion = @Estacion
EXEC spAsisteNoReportoAsistenciaCalc @Estacion, @InfoEmpresa, @InfoFechaD, @InfoFechaA, @InfoReportaA, @InfoSucursal
END

