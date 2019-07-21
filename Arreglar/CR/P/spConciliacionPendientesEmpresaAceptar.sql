SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spConciliacionPendientesEmpresaAceptar
@ID		int

AS BEGIN
DECLARE
@Empresa		varchar(5),
@Mensaje		varchar(10),
@Institucion	varchar(20),
@Mov		varchar(20),
@MovID		varchar(20),
@Concepto		varchar(50),
@Referencia		varchar(50)
SELECT @Empresa = e.Empresa, @Institucion = cta.Institucion
FROM Conciliacion e
JOIN CtaDinero cta ON cta.CtaDinero = e.CtaDinero
WHERE e.ID = @ID
DECLARE crConciliacionD CURSOR LOCAL FOR
SELECT Concepto, Referencia
FROM ConciliacionD
WHERE ID = @ID AND Seccion = 2
OPEN crConciliacionD
FETCH NEXT FROM crConciliacionD INTO @Concepto, @Referencia
WHILE @@FETCH_STATUS <> -1 AND @@Error = 0
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spReferenciaEnMovMovID @Referencia, @Mov OUTPUT, @MovID OUTPUT
SELECT @Mensaje = NULL
SELECT @Mensaje = Mensaje
FROM MensajeInstitucion
WHERE Institucion = @Institucion AND Descripcion = @Concepto
UPDATE Dinero
SET InstitucionMensaje = @Mensaje
WHERE Empresa = @Empresa AND Conciliado = 0 AND Mov = @Mov AND MovID = @MovID AND Estatus IN ('PENDIENTE', 'CONCLUIDO', 'CONCILIADO')
END
FETCH NEXT FROM crConciliacionD INTO @Concepto, @Referencia
END
CLOSE crConciliacionD
DEALLOCATE crConciliacionD
RETURN
END

