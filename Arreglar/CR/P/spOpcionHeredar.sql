SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOpcionHeredar
@SubCuenta	varchar(50),
@Material	varchar(20),
@mSubCuenta	varchar(50)	OUTPUT,
@Ok             int          	OUTPUT,
@OkRef          varchar(255) 	OUTPUT

AS BEGIN
DECLARE
@p 			int,
@Salir		bit,
@l			char(1),
@Opcion		char(1),
@NumSt		char(20),
@Numero		int
SELECT @mSubCuenta = NULL
CREATE TABLE #Opcion(Opcion char(1) COLLATE Database_Default NULL, Numero int NULL)
SELECT @Salir = 0, @p = 1, @Opcion = NULL, @NumSt = NULL
WHILE @Salir = 0 AND @p <= LEN(@SubCuenta) AND @Ok IS NULL
BEGIN
SELECT @l = RTRIM(SUBSTRING(@SubCuenta, @p, 1))
IF dbo.fnEsNumerico(@l) = 1
BEGIN
IF @Opcion IS NULL SELECT @Ok = 20045
SELECT @NumSt = RTRIM(ISNULL(@NumSt, '')) + @l
END ELSE
BEGIN
IF @Opcion IS NOT NULL
BEGIN
IF @NumSt IS NULL
SELECT @Numero = NULL
ELSE
SELECT @Numero = CONVERT(int, @NumSt)
INSERT #Opcion (Opcion, Numero) VALUES (@Opcion, @Numero)
SELECT @Opcion = NULL, @NumSt = NULL
END
SELECT @Opcion = @l
END
SELECT @p = @p + 1
END
IF @Opcion IS NOT NULL
BEGIN
SELECT @Numero = NULLIF(CONVERT(int, @NumSt), 0)
INSERT #Opcion (Opcion, Numero) VALUES (@Opcion, @Numero)
SELECT @Opcion = NULL, @NumSt = NULL
END
DECLARE crOpcion CURSOR FOR
SELECT o.Opcion, o.Numero
FROM ArtOpcion ao, #Opcion o
WHERE ao.Articulo = @Material AND ao.Opcion = o.Opcion
ORDER BY Orden
OPEN crOpcion
FETCH NEXT FROM crOpcion INTO @Opcion, @Numero
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @mSubCuenta = ISNULL(@mSubCuenta, '') + @Opcion
IF @Numero IS NOT NULL
SELECT @mSubCuenta = @mSubCuenta + LTRIM(CONVERT(char, @Numero))
END
FETCH NEXT FROM crOpcion INTO @Opcion, @Numero
END
CLOSE crOpcion
DEALLOCATE crOpcion
RETURN
END

