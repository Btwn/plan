SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCtoCampoExtraCrearVista
@Tipo	varchar(20)

AS BEGIN
DECLARE
@a		int,
@c		varchar(5),
@Tabla	varchar(50),
@Vista	varchar(50),
@CampoExtra	varchar(50),
@SELECT	varchar(8000)
SELECT @Tabla = dbo.fnCtoTabla(@Tipo)
SELECT @a = 0, @Vista = 'dbo.'+@Tabla+'CampoExtra', @SELECT = ''
DECLARE crCtoTipoCampoExtra CURSOR FOR
SELECT DISTINCT CampoExtra
FROM CtoTipoCampoExtra
WHERE Tipo = @Tipo
OPEN crCtoTipoCampoExtra
FETCH NEXT FROM crCtoTipoCampoExtra INTO @CampoExtra
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @a = @a + 1
SELECT @c = CONVERT(varchar, @a)
SELECT @SELECT = @SELECT+', "'+@CampoExtra+'"=(SELECT Valor FROM CtoCampoExtra ce WHERE ce.Tipo="'+@Tipo+'" AND ce.SubTipo=c.Tipo AND ce.Clave=c.'+@Tipo+' AND ce.CampoExtra="'+@CampoExtra+'")'
END
FETCH NEXT FROM crCtoTipoCampoExtra INTO @CampoExtra
END
CLOSE crCtoTipoCampoExtra
DEALLOCATE crCtoTipoCampoExtra
EXEC('if exists (select * from sysobjects where id = object_id("'+@Vista+'") and type = "V") drop view '+@Vista)
EXEC('CREATE VIEW '+@Vista+'  AS SELECT c.*'+@SELECT+' FROM '+@Tabla+' c')
RETURN
END

