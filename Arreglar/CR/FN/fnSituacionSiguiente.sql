SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSituacionSiguiente
(
@Modulo					varchar(5),
@Mov					varchar(20),
@Estatus				varchar(15),
@Situacion				varchar(50)
)
RETURNS varchar(50)

AS BEGIN
DECLARE
@Resultado				varchar(50),
@Orden					int,
@OrdenSiguiente			int
SET @Resultado = NULL
SET @Orden = NULL
SELECT
@Orden = Orden
FROM MovSituacion
WHERE Modulo = @Modulo
AND Mov = @Mov
AND Estatus = @Estatus
AND Situacion = @Situacion
IF @Orden IS NOT NULL
BEGIN
SET @OrdenSiguiente = NULL
SELECT @OrdenSiguiente = MIN(Orden)
FROM MovSituacion
WHERE Modulo = @Modulo AND Mov = @Mov AND Estatus = @Estatus AND Orden > @Orden
SELECT @Resultado = MIN(Situacion)
FROM MovSituacion
WHERE Modulo = @Modulo AND Mov = @Mov AND Estatus = @Estatus AND  Orden = @OrdenSiguiente
END
RETURN (@Resultado)
END

