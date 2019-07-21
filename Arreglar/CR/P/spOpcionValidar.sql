SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOpcionValidar
@Articulo	char(20),
@SubCuenta	varchar(50),
@Accion			char(20),
@CfgOpcionBloquearDescontinuado		bit, 
@CfgOpcionPermitirDescontinuado		bit, 
@Ok									int          	OUTPUT,
@OkRef								varchar(255) 	OUTPUT

AS BEGIN
DECLARE
@p 			int,
@Salir		bit,
@l			char(1),
@Opcion		char(1),
@UltOpcion		char(1),
@NumSt		char(20),
@ListaEspecifica	varchar(50),
@Numero		int,
@Requeridos		int,
@TieneDetalle	bit,
@TipoDetalle	varchar(20),
@Descontinuado	bit 
CREATE TABLE #Opcion(Opcion char(1) COLLATE Database_Default NULL, Numero int NULL)
SELECT @SubCuenta = ISNULL(@SubCuenta,1) 
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
SELECT @Requeridos = 0
SELECT @Requeridos = ISNULL(COUNT(*), 0) FROM ArtOpcion WHERE Articulo = @Articulo AND Requerido = 1
IF @Requeridos <> ISNULL((SELECT COUNT(*) FROM ArtOpcion ao, #Opcion o WHERE ao.Articulo = @Articulo AND ao.Requerido = 1 AND ao.Opcion = o.Opcion), 0) SELECT @Ok = 20046
SELECT @UltOpcion = NULL
DECLARE crOpcion CURSOR FOR
SELECT op.Opcion, op.Numero, o.TieneDetalle, NULLIF(RTRIM(UPPER(o.TipoDetalle)), ''), ISNULL(Descontinuado,0) 
FROM #Opcion op LEFT OUTER JOIN Opcion o 
ON op.Opcion = o.Opcion LEFT OUTER JOIN OpcionD od 
ON od.Opcion = o.Opcion AND od.Numero = op.Numero 
OPEN crOpcion
FETCH NEXT FROM crOpcion INTO @Opcion, @Numero, @TieneDetalle, @TipoDetalle, @Descontinuado 
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF @TieneDetalle IS NULL SELECT @Ok = 20042
ELSE
BEGIN
IF @UltOpcion IS NOT NULL AND @Opcion <= @UltOpcion SELECT @Ok = 20049
SELECT @UltOpcion = @Opcion
SELECT @ListaEspecifica = NULL
SELECT @ListaEspecifica = NULLIF(RTRIM(ListaEspecifica), '') FROM ArtOpcion WHERE Articulo = @Articulo AND Opcion = @Opcion
IF @@ROWCOUNT = 0 SELECT @Ok = 20047
END
IF @Ok IS NULL
BEGIN
IF @TipoDetalle IN (NULL, 'NUMERO')
BEGIN
IF @TieneDetalle = 1
BEGIN
IF UPPER(@ListaEspecifica) IN (NULL, '(TODAS)')
BEGIN
IF NOT EXISTS(SELECT * FROM OpcionD WHERE Opcion = @Opcion AND Numero = @Numero) SELECT @Ok = 20048
END ELSE
IF UPPER(@ListaEspecifica) = '(ESPECIAL)'
BEGIN
IF NOT EXISTS(SELECT * FROM ArtOpcionD WHERE Articulo = @Articulo AND Opcion = @Opcion AND Numero = @Numero) SELECT @Ok = 20048
IF @Accion = 'AFECTAR'
BEGIN
IF (SELECT TieneMovimientos FROM ArtOpcionD WHERE Articulo = @Articulo AND Opcion = @Opcion AND Numero = @Numero) = 0
UPDATE ArtOpcionD SET TieneMovimientos = 1 WHERE Articulo = @Articulo AND Opcion = @Opcion AND Numero = @Numero
END
END ELSE
BEGIN
IF NOT EXISTS(SELECT * FROM OpcionListaD WHERE Opcion = @Opcion AND Lista = @ListaEspecifica AND Numero = @Numero) SELECT @Ok = 20048
END
IF @Accion = 'AFECTAR'
BEGIN
IF (SELECT TieneMovimientos FROM OpcionD WHERE Opcion = @Opcion AND Numero = @Numero) = 0
UPDATE OpcionD SET TieneMovimientos = 1 WHERE Opcion = @Opcion AND Numero = @Numero
END
IF NULLIF(@Ok,0) IS NULL AND @CfgOpcionBloquearDescontinuado = 1 AND @CfgOpcionPermitirDescontinuado = 0 AND @Descontinuado = 1 SELECT @Ok = 20053 
END ELSE
IF @Numero IS NOT NULL SELECT @Ok = 20048
END ELSE
BEGIN
IF @Numero IS NULL SELECT @Ok = 20048
END
IF @Accion = 'AFECTAR'
BEGIN
IF (SELECT TieneMovimientos FROM Opcion WHERE Opcion = @Opcion) = 0
UPDATE Opcion SET TieneMovimientos = 1 WHERE Opcion = @Opcion
IF (SELECT TieneMovimientos FROM ArtOpcion WHERE Articulo = @Articulo AND Opcion = @Opcion) = 0
UPDATE ArtOpcion SET TieneMovimientos = 1 WHERE Articulo = @Articulo AND Opcion = @Opcion
END
END
IF @Ok IS NOT NULL SELECT @OkRef = RTRIM(@Articulo)+' - '+RTRIM(Descripcion)+' ('+@Opcion+LTRIM(CONVERT(char, @Numero))+')' FROM Opcion WHERE Opcion = @Opcion
END
FETCH NEXT FROM crOpcion INTO @Opcion, @Numero, @TieneDetalle, @TipoDetalle, @Descontinuado 
END
CLOSE crOpcion
DEALLOCATE crOpcion
RETURN
END

