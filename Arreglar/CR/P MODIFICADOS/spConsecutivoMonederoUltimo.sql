SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spConsecutivoMonederoUltimo
@Sucursal         int        ,
@Empresa          varchar( 5),
@Modulo           varchar( 5),
@Mov              varchar(20),
@Ejercicio        int        ,
@Periodo          int        ,
@Consecutivo      bigint      OUTPUT,
@Ok               int         OUTPUT
AS
BEGIN
SELECT @Consecutivo = NULL
SELECT @Consecutivo = MAX(Consecutivo)
FROM MonederoC WITH (NOLOCK)
WHERE Sucursal  = @Sucursal
AND Empresa   = @Empresa
AND Mov       = @Mov
AND Ejercicio = @Ejercicio
AND Periodo   = @Periodo
RETURN
END

