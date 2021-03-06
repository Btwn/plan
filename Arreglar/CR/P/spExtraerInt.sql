SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spExtraerInt
@Texto 	  	varchar(8000)	OUTPUT,
@int     	int		OUTPUT,
@Separador	varchar(10)

AS BEGIN
DECLARE
@IntSt	varchar(255)
SELECT @Int = NULL
EXEC spExtraerDato @Texto OUTPUT, @intSt OUTPUT, @Separador
IF dbo.fnEsNumerico(@IntSt) = 1
SELECT @Int = CONVERT(int, @IntSt)
RETURN
END

