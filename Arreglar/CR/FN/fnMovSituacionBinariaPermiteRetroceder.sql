SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMovSituacionBinariaPermiteRetroceder(
@Modulo			varchar(5),
@Mov			varchar(20),
@Estatus		varchar(15),
@Situacion		varchar(50)
)
RETURNS bit
AS
BEGIN
DECLARE @PermiteRetroceder		 bit  
IF ISNULL(@Situacion, '') IN('')
SELECT @Situacion = RTRIM(@Mov)+' '+RTRIM(Nombre) FROM Estatus WHERE Estatus = @Estatus
SELECT @PermiteRetroceder = ISNULL(PermiteRetroceder, 0) FROM MovSituacion WHERE Modulo = @Modulo AND Mov = @Mov AND Estatus = @Estatus AND Situacion = @Situacion 
RETURN(@PermiteRetroceder) 
END

