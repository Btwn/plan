SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMovSituacionBinariaIcono(
@Modulo			varchar(5),
@Mov			varchar(20),
@Estatus		varchar(15),
@Situacion		varchar(50),
@Rama			varchar(50),
@EsPadre		bit
)
RETURNS int
AS
BEGIN
DECLARE @SituacionVerdadero	varchar(50),
@Icono				int
SELECT @SituacionVerdadero = SituacionVerdadero
FROM MovSituacion WITH(NOLOCK)
WHERE Modulo		= @Modulo
AND Mov		= @Mov
AND Estatus	= @Estatus
AND Situacion	= @Rama
IF @Situacion = @SituacionVerdadero OR @EsPadre = 1
SELECT @Icono = 339
ELSE
SELECT @Icono = 416
RETURN @Icono
END

