SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMovSituacionBinariaTieneHijos(
@Modulo			varchar(5),
@Mov			varchar(20),
@Estatus		varchar(15),
@Situacion		varchar(50),
@EsPadre		bit
)
RETURNS bit
AS
BEGIN
DECLARE @Resultado	bit
IF ISNULL(@EsPadre, 0) = 1
SELECT @Resultado = 1
ELSE
BEGIN
IF EXISTS(SELECT Situacion FROM MovSituacion WHERE Modulo = @Modulo AND Mov = @Mov AND Estatus = @Estatus AND Rama = @Situacion)
SELECT @Resultado = 1
ELSE
SELECT @Resultado = 0
END
RETURN @Resultado
END

