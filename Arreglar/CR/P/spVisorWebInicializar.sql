SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVisorWebInicializar
@Estacion		int,
@Formato		varchar(50)

AS BEGIN
DELETE FROM VisorWeb WHERE Estacion = @Estacion
INSERT VisorWeb (Estacion,  Orden,                       TabTitulo, Zona, ZonaTitulo, URL, Bloqueado)
SELECT  @Estacion, ISNULL(NULLIF(Orden,0),RID), TabTitulo, Zona, ZonaTitulo, URL, Bloqueado
FROM  VisorWebConfigD
WHERE  RTRIM(LTRIM(Formato)) = RTRIM(LTRIM(@Formato))
ORDER  BY RID
SELECT Formato, Descripcion, Editable FROM VisorWebConfig WHERE RTRIM(LTRIM(Formato)) = RTRIM(LTRIM(@Formato))
END

