SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnWebConsecutivoImagen2
(
@IDCombinacion   int,
@IDArt           int,
@Archivo         varchar(255)
)
RETURNS varchar(255)

AS BEGIN
DECLARE
@Orden int,
@CantidadImagenes  int,
@Nombre varchar(50),
@Extencion          varchar(10)
SELECT @Nombre = CONVERT(varchar,@IDArt)+'_'+CONVERT(varchar,@IDCombinacion)+'_Imagen1'+ISNULL(dbo.fnWebTipoArchivo(@Archivo),'')
RETURN (@Nombre)
END

