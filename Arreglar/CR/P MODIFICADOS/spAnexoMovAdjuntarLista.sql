SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spAnexoMovAdjuntarLista
@Modulo			varchar(5),
@ID				int,
@Nombre			varchar(255),
@Archivo		varchar(max)		OUTPUT,
@Ok				int			 = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE @Direccion	varchar(255),
@Existe		bit
SELECT @Nombre = '%' + REPLACE(@Nombre, '*', '%')
DECLARE @IDR		int,
@IDRAnt	int
SELECT @IDRAnt = 0
WHILE(1=1)
BEGIN
SELECT @IDR = MIN(IDR)
FROM AnexoMov WITH(NOLOCK)
WHERE Rama = @Modulo
AND ID = @ID
AND Direccion LIKE @Nombre
AND IDR > @IDRAnt
IF @IDR IS NULL BREAK
SELECT @IDRAnt = @IDR
SELECT @Direccion = Direccion FROM AnexoMov WITH(NOLOCK) WHERE Rama = @Modulo AND ID = @ID AND IDR = @IDR
EXEC spVerificarArchivo @Direccion, @Existe OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Existe = 1
SELECT @Archivo = ISNULL(@Archivo, '') + @Direccion + ';'
END
IF RIGHT(@Archivo, 1) = ';'
SELECT @Archivo = SUBSTRING(@Archivo, 1, LEN(@Archivo) - 1)
END

