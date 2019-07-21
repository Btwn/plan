SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDistAlmDist
@Empresa              varchar(5),
@Almacen              varchar(10),
@Nombre               varchar(20),
@Distribuir           bit

AS
BEGIN
SET NOCOUNT ON
SET @Empresa    = UPPER(LTRIM(RTRIM(ISNULL(@Empresa,''))))
SET @Almacen    = UPPER(LTRIM(RTRIM(ISNULL(@Almacen,''))))
SET @Nombre     = UPPER(LTRIM(RTRIM(ISNULL(@Nombre,''))))
SET @Distribuir = ISNULL(@Distribuir,0)
IF EXISTS (SELECT TOP 1 Empresa FROM AlmDist WHERE Empresa = @Empresa AND Almacen = @Almacen)
BEGIN
UPDATE AlmDist
SET Nombre = @Nombre, Distribuir = @Distribuir
WHERE Empresa = @Empresa AND Almacen = @Almacen
END
ELSE
BEGIN
INSERT INTO AlmDist(Empresa,Almacen,Nombre,Distribuir)
VALUES(@Empresa,@Almacen,@Nombre,@Distribuir)
END
SET NOCOUNT OFF
END

