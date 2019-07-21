SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGASAnticipoPendienteAPP
@Empresa   char(5),
@Acreedor  varchar(10),
@Mov       varchar(20) OUTPUT,
@MovID     varchar(20) OUTPUT,
@Clase     varchar(50) OUTPUT,
@SubClase  varchar(50) OUTPUT,
@Observaciones varchar(100) OUTPUT

AS BEGIN
SELECT @Mov = NULL,  @MovID = NULL,  @Clase = NULL,  @SubClase  = NULL,  @Observaciones = NULL
DECLARE crAnticipo CURSOR
FOR SELECT  Gasto.Mov, Gasto.MovID, Gasto.Clase, Gasto.SubClase, Gasto.Observaciones
FROM Gasto
 WITH(NOLOCK) JOIN MovTipo  WITH(NOLOCK) ON Gasto.Mov = MovTipo.Mov AND  MovTipo.Modulo ='GAS'
WHERE
Gasto.Empresa = @Empresa
AND Gasto.Acreedor = @Acreedor
AND Gasto.Estatus   = 'PENDIENTE'
AND  MovTipo.Clave IN ('GAS.A')
ORDER BY Gasto.ID, GAsto.FechaEmision  DESC
OPEN crAnticipo
FETCH NEXT FROM crAnticipo  INTO @Mov, @MovID, @Clase, @SubClase, @Observaciones
CLOSE crAnticipo
DEALLOCATE crAnticipo
RETURN
END

