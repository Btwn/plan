SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPlanArtMaxMinActualizar(
@Empresa              char(5),
@Usuario              varchar(10),
@Estacion             int
)

AS BEGIN
DECLARE @Filas		int,
@Mensaje	varchar(255)
SET @Filas = 0
SET @Mensaje = ''
BEGIN TRY
UPDATE PlanArtMaxMin
SET DiasInvD  = b.DiasInvD,
CantidadA  = b.CantidadA,
DiasInvFin = b.DiasInvFin,
Aplicar    = b.Aplicar
FROM PlanArtMaxMin a
INNER JOIN PlanArtMaxMinTemp b ON a.ID = b.ID
SELECT @Filas = COUNT(ID)
FROM PlanArtMaxMinTemp
WHERE Empresa  = @Empresa
AND Usuario  = @Usuario
AND Estacion = @Estacion
DELETE PlanArtMaxMinTemp
WHERE Empresa  = @Empresa
AND Usuario  = @Usuario
AND Estacion = @Estacion
END TRY
BEGIN CATCH
SET @Filas = 0
SET @Mensaje = ERROR_MESSAGE()
END CATCH
SELECT @Filas AS Filas, @Mensaje AS Mensaje
END

