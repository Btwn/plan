SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCuboBC ON Cubo

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@CuboN	varchar(20),
@CuboA	varchar(20)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @CuboN = Cubo FROM Inserted
SELECT @CuboA = Cubo FROM Deleted
IF @CuboN = @CuboA RETURN
IF @CuboN IS NULL
BEGIN
DELETE CuboMedida	 	WHERE Cubo = @CuboA
DELETE CuboDimension 	WHERE Cubo = @CuboA
DELETE CuboDimensionNivel 	WHERE Cubo = @CuboA
DELETE CuboFormula	 	WHERE Cubo = @CuboA
DELETE CuboCampo	 	WHERE Cubo = @CuboA
END ELSE
BEGIN
UPDATE CuboMedida	 	SET Cubo =  @CuboN WHERE Cubo = @CuboA
UPDATE CuboDimension 	SET Cubo =  @CuboN WHERE Cubo = @CuboA
UPDATE CuboDimensionNivel 	SET Cubo =  @CuboN WHERE Cubo = @CuboA
UPDATE CuboFormula	 	SET Cubo =  @CuboN WHERE Cubo = @CuboA
UPDATE CuboCampo	 	SET Cubo =  @CuboN WHERE Cubo = @CuboA
UPDATE CuboVista	 	SET Cubo =  @CuboN WHERE Cubo = @CuboA
END
END

