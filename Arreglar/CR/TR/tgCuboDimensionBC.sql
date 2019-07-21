SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgCuboDimensionBC ON CuboDimension

FOR UPDATE, DELETE
AS BEGIN
DECLARE
@CuboN	varchar(20),
@CuboA	varchar(20),
@DimensionN	varchar(50),
@DimensionA	varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @CuboN = Cubo, @DimensionN = Dimension FROM Inserted
SELECT @CuboA = Cubo, @DimensionA = Dimension FROM Deleted
IF @DimensionN = @DimensionA RETURN
IF @DimensionN IS NULL
BEGIN
DELETE CuboDimensionNivel 	WHERE Cubo = @CuboA AND Dimension = @DimensionA
END ELSE
BEGIN
UPDATE CuboDimensionNivel 	SET Dimension =  @DimensionN WHERE Cubo = @CuboA AND Dimension = @DimensionA
END
END

