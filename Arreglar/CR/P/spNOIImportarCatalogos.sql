SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNOIImportarCatalogos
@Empresa       varchar(5),
@TablaPeriodo  varchar(10),
@Estacion      int,
@FechaA        datetime

AS BEGIN
EXEC spNOIImportarConceptoNomina @Empresa,@TablaPeriodo,@Estacion
EXEC spNOIImportarDepartamento @Empresa,@Estacion
EXEC spNOIImportarPuestos @Empresa,@Estacion
EXEC spNOIImportarPersonal @Empresa,@TablaPeriodo,@Estacion, @FechaA
EXEC spNOIImportarNomina @Empresa,@TablaPeriodo,@Estacion
END

