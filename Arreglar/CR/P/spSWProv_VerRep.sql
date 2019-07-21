SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spSWProv_VerRep
@Proveedor		VARCHAR(10),
@Empresa		VARCHAR(5),
@Estatus		VARCHAR(15),
@FechaIni 		date,
@FechaFin 		date
AS BEGIN
SET NOCOUNT ON
SELECT ID, RTrim(Mov) + isnull(' ' + RTrim(MovID), '') as Titulo, Submodulo,  Proveedor, Mov, MovID , Estatus, FechaEmision, FechaInicio, FechaConclusion, Empresa
FROM Soporte
WHERE Proveedor = @Proveedor AND Empresa = @Empresa AND  FechaEmision BETWEEN @FechaIni AND @FechaFin
AND Estatus = CASE WHEN ISNULL(@Estatus, '') = '' THEN Estatus ELSE @Estatus END
ORDER BY ID
SET NOCOUNT OFF
RETURN
END

