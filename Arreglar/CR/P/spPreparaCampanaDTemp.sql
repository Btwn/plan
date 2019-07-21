SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPreparaCampanaDTemp @ID int, @RID Int

AS BEGIN
DECLARE
@Cliente varchar(10),
@Nombre  varchar(100)
IF @RID IS NOT NULL
BEGIN
DELETE CampanaDTemp
WHERE RID = @RID
SELECT @Cliente = Contacto
FROM CampanaD
WHERE ID = @ID AND RID = @RID
SELECT @Nombre = Nombre
FROM Cte
WHERE Cliente = @Cliente
INSERT INTO CampanaDTemp(RID,Cliente,Situacion,Observaciones,Instruccion,FechaD,FechaA,ListaPreciosEsp)
SELECT RID,@Nombre,Situacion,Observaciones,Instruccion,FechaD,FechaA,ListaPreciosEsp
FROM CampanaD
WHERE ID = @ID AND RID = @RID
END
END

