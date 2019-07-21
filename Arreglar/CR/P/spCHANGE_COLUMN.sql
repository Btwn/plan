SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCHANGE_COLUMN
@Tabla				sysname,
@Campo				sysname,
@TipoAnterior		varchar(20),
@LongitudAnterior	int,
@TipoNuevo			varchar(20),
@LongitudNueva		int

AS BEGIN
DECLARE
@Tipo	varchar(255)
SET @Tipo = ''
IF @TipoNuevo = 'varchar'
SELECT @Tipo = @TipoNuevo + '(' + ISNULL(CONVERT(varchar,@LongitudNueva),255) + ') NULL'
ELSE
SELECT @Tipo = @TipoNuevo + ' NULL'
IF EXISTS (SELECT * FROM information_schema.columns WHERE TABLE_NAME = @Tabla AND COLUMN_NAME = @Campo AND DATA_TYPE = @TipoAnterior AND CHARACTER_MAXIMUM_LENGTH = @LongitudAnterior)
BEGIN
EXEC spDROP_COLUMN @Tabla, @Campo
EXEC spALTER_TABLE @Tabla, @Campo, @Tipo
END
RETURN
END

