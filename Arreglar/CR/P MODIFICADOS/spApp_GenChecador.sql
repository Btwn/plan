SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC dbo.spApp_GenChecador
@Personal		varchar(10),
@MapaLatitud	float,
@MapaLongitud	float,
@Archivo		varchar(max) = NULL
AS
BEGIN SET NOCOUNT ON
DECLARE @Cuenta varchar(20), @Color varchar(50), @Mensaje varchar(MAX), @Retardo int, @Empresa varchar(5), @Usuario varchar(10), @Sucursal int
DECLARE @Nombre varchar(30), @ApellidoPaterno varchar(30), @ApellidoMaterno varchar(30), @Estatus char(15), @EstaPresente bit, @FechaNacimiento datetime, @Direccion varchar(255)
DECLARE @FechaActual datetime = GETDATE()
DECLARE @tmpSPResult AS TABLE (Color varchar(50), Mensaje varchar(MAX), Retardo int)
SELECT @Empresa = Empresa, @Sucursal = SucursalTrabajo FROM Personal WITH(NOLOCK) WHERE Personal = @Personal
SELECT @Usuario = Usuario, @Sucursal = CASE WHEN @Sucursal IS NULL THEN Sucursal ELSE @Sucursal END FROM Usuario WITH(NOLOCK) WHERE Personal = @Personal
IF (@Personal IS NULL OR NOT EXISTS(SELECT Personal FROM Personal WITH(NOLOCK) WHERE Personal = @Personal))
BEGIN
SELECT Mensaje Ok, Descripcion OkRef FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = 20950
return
END
IF (@Sucursal IS NULL)
BEGIN
SELECT Mensaje Ok, Descripcion OkRef FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = 10200
return
END
IF (@Empresa IS NULL)
BEGIN
SELECT Mensaje Ok, Descripcion OkRef FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = 26070
return
END
BEGIN TRY
INSERT INTO @tmpSPResult EXEC xpAccesoControl @Empresa = @Empresa, @Sucursal = @Sucursal, @Usuario = @Usuario, @Codigo = @Personal, @FechaHora = @FechaActual
SELECT @Color = Color, @Mensaje = Mensaje, @Retardo = Retardo FROM @tmpSPResult
SELECT @Nombre = A.Nombre, @ApellidoPaterno = A.ApellidoPaterno, @ApellidoMaterno = A.ApellidoMaterno, @Estatus = A.Estatus, @EstaPresente = PP.EstaPresente, @FechaNacimiento = A.FechaNacimiento, @Direccion = B.Direccion
FROM Personal A WITH(NOLOCK) LEFT OUTER JOIN AnexoCta B WITH(NOLOCK) ON (B.Cuenta = A.Personal AND UPPER(B.Nombre) = 'Foto' AND B.Tipo = 'Imagen') LEFT OUTER JOIN Personal PP ON PP.Personal = A.Personal WHERE A.Personal = @Personal
EXEC dbo.spAsisteRegistro @Empresa = @Empresa, @Sucursal = 0, @Usuario = @Usuario, @Personal = @Personal, @EstaPresente = @EstaPresente, @Retardo = @Retardo, @FechaHora = @FechaActual
DECLARE @ID				AS INT,
@IDR			AS INT,
@strChars		AS VARCHAR(62),
@AnexoBase64	AS VARCHAR(8),
@index			AS INT,
@cont			AS INT,
@IDb64			AS INT
SET @strChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
SET @AnexoBase64 = ''
SET @cont = 0
WHILE @cont < 8
BEGIN
SET @index = ceiling((SELECT RAND()) * (len(@strChars)))
SET @AnexoBase64 = @AnexoBase64 + substring(@strChars, @index, 1)
SET @cont = @cont + 1
END
IF (NULLIF(@AnexoBase64,'') IS NULL OR LEN(@AnexoBase64) <> 8)
BEGIN
RAISERROR ('Error al generar identificador de imágen', 18, 1)
RETURN
END
SELECT TOP 1 @ID = ID, @IDR = Renglon FROM AsisteD WITH(NOLOCK) WHERE Personal = @Personal and FechaA = CONVERT(VARCHAR(10), GETDATE(), 112) ORDER BY FechaA DESC, HoraRegistro DESC, ID DESC, Renglon DESC
UPDATE AsisteD WITH(ROWLOCK) SET MapaLatitud = @MapaLatitud, MapaLongitud = @MapaLongitud WHERE ID = @ID AND Renglon = @IDR
INSERT INTO AnexoBase64 (Rama, ID, IDR, AnexoBase64, Archivo) SELECT 'ASIS', @ID , @IDR, @AnexoBase64, @Archivo
SELECT	LTRIM(RTRIM(@Nombre + ISNULL(' ' + @ApellidoPaterno, '') + ISNULL(' ' + @ApellidoMaterno, ''))) Nombre, LTRIM(RTRIM(@Color)) Color, LTRIM(RTRIM(@Mensaje)) Mensaje,LTRIM(RTRIM(@Direccion)) Direccion
FROM	Personal PP WHERE PP.Personal = @Personal
END TRY
BEGIN CATCH
SELECT '-1' Ok, ERROR_MESSAGE() OkRef
return
END CATCH
SET NOCOUNT OFF
END

