SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spMovCampoExtraCrearVista]
@Modulo VARCHAR(5)
AS
BEGIN
	DECLARE
		@a INT
	   ,@c VARCHAR(5)
	   ,@Tabla VARCHAR(50)
	   ,@Vista VARCHAR(50)
	   ,@CampoExtra VARCHAR(50)
	   ,@SELECT VARCHAR(MAX)
	SELECT @Tabla = dbo.fnMovTabla(@Modulo)
	SELECT @a = 0
		  ,@Vista = 'dbo.' + @Tabla + 'CampoExtra'
		  ,@SELECT = ''
	DECLARE
		crMovTipoCampoExtra
		CURSOR FOR
		SELECT DISTINCT CampoExtra
		FROM MovTipoCampoExtra
		WHERE Modulo = @Modulo
	OPEN crMovTipoCampoExtra
	FETCH NEXT FROM crMovTipoCampoExtra INTO @CampoExtra
	WHILE @@FETCH_STATUS <> -1
	AND @@Error = 0
	BEGIN

	IF @@FETCH_STATUS <> -2
	BEGIN
		SELECT @a = @a + 1
		SELECT @c = CONVERT(VARCHAR, @a)
		SELECT @SELECT = @SELECT + ',"' + @CampoExtra + '"=(SELECT Valor FROM MovCampoExtra ce WHERE ce.Modulo="' + @Modulo + '" AND ce.Mov=m.Mov AND ce.ID=m.ID AND ce.CampoExtra="' + @CampoExtra + '")'
	END

	FETCH NEXT FROM crMovTipoCampoExtra INTO @CampoExtra
	END
	CLOSE crMovTipoCampoExtra
	DEALLOCATE crMovTipoCampoExtra
	EXEC ('if exists (select * from sysobjects where id = object_id("' + @Vista + '") and type ="V") drop view ' + @Vista)
	EXEC ('CREATE VIEW ' + @Vista + ' AS SELECT m.*' + @SELECT + ' FROM ' + @Tabla + ' m')
	RETURN
END

