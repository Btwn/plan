SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebArtsugerirDescripcionHTML
@Articulo            varchar(20)

AS BEGIN
DECLARE
@Descripcion varchar(MAX),
@Temp1     varchar(255),
@Temp2     varchar(255),
@Temp3     varchar(255),
@Temp4     varchar(255),
@Temp5     varchar(255),
@Temp6     varchar(255),
@Temp7     varchar(255),
@Temp8     varchar(255),
@Temp9     varchar(255),
@Temp10    varchar(255),
@Inicio    int,
@Fin       int
SELECT @Descripcion = Comentario FROM AnexoCta WHERE Rama = 'INV' AND Cuenta = @Articulo
IF @Descripcion IS NULL
SELECT @Descripcion = Descripcion1 FROM Art WHERE Articulo = @Articulo
SELECT @Descripcion = ISNULL(@Descripcion,'')
SELECT @Descripcion = dbo.fneWebDescripcionHTML(SUBSTRING(@Descripcion,1,2559))
SELECT @Temp1 = SUBSTRING(@Descripcion,1,255)
SELECT @Temp2 = SUBSTRING(@Descripcion,256,511)
SELECT @Temp3 = SUBSTRING(@Descripcion,512,767)
SELECT @Temp4 = SUBSTRING(@Descripcion,768,1023)
SELECT @Temp5 = SUBSTRING(@Descripcion,1024,1279)
SELECT @Temp6 = SUBSTRING(@Descripcion,1280,1535)
SELECT @Temp7 = SUBSTRING(@Descripcion,1536,1791)
SELECT @Temp8 = SUBSTRING(@Descripcion,1792,2047)
SELECT @Temp9 = SUBSTRING(@Descripcion,2048,2303)
SELECT @Temp10 = SUBSTRING(@Descripcion,2304,2559)
SELECT RTRIM(ISNULL(@Temp1,'')),LTRIM(RTRIM(ISNULL(@Temp2,''))), LTRIM(RTRIM(ISNULL(@Temp3,''))), LTRIM(RTRIM(ISNULL(@Temp4,''))), LTRIM(RTRIM(ISNULL(@Temp5,''))),LTRIM(RTRIM(ISNULL(@Temp6,''))), LTRIM(RTRIM(ISNULL(@Temp7,'')))  , LTRIM(RTRIM(ISNULL(@Temp8,''))), LTRIM(RTRIM(ISNULL(@Temp9,'')))  ,LTRIM(RTRIM(ISNULL(@Temp10,'')))
END

