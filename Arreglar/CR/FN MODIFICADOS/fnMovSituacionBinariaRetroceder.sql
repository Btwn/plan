SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMovSituacionBinariaRetroceder(
@Modulo			varchar(5),
@Mov			varchar(20),
@Estatus		varchar(15),
@Situacion		varchar(50)
)
RETURNS varchar(50)
AS
BEGIN
DECLARE @Rama varchar(50)
IF ISNULL(@Situacion, '') IN('')
SELECT @Situacion = RTRIM(@Mov)+' '+RTRIM(Nombre) FROM Estatus WITH(NOLOCK) WHERE Estatus = @Estatus
SELECT @Rama = Rama FROM MovSituacion WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov AND Estatus = @Estatus AND Situacion = @Situacion
IF ISNULL(@Rama, '') IN('', '.')
SELECT @Rama = @Situacion
RETURN @Rama
END

