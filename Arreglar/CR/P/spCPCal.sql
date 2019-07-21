SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCPCal
@ID			int,
@Ejercicio		int,
@ClavePresupuestal	varchar(50),
@Tipo		varchar(20)

AS BEGIN
DECLARE
@Empresa	varchar(5),
@Sucursal	int,
@Proyecto	varchar(50),
@MovTipo	varchar(20)
SELECT @MovTipo = mt.Clave
FROM CP
JOIN MovTipo mt ON mt.Modulo = 'CP' AND mt.Mov = CP.Mov
WHERE CP.ID = @ID
IF @MovTipo = 'CP.TA'
BEGIN
IF NOT EXISTS(SELECT * FROM CPCal WHERE ID = @ID AND Ejercicio = @Ejercicio AND ClavePresupuestal = @ClavePresupuestal AND Tipo = @Tipo)
BEGIN
SELECT @Empresa = Empresa, @Sucursal = Sucursal, @Proyecto = Proyecto
FROM CP
WHERE ID = @ID
INSERT CPCal (
ID,  ClavePresupuestal,  Ejercicio,  Tipo,  Periodo, Importe,     Sucursal, SucursalOrigen)
SELECT @ID, @ClavePresupuestal, @Ejercicio, @Tipo, Periodo, Presupuesto, @Sucursal, @Sucursal
FROM CPCalDisponible
WHERE Empresa = @Empresa AND Proyecto = @Proyecto AND ClavePresupuestal = @ClavePresupuestal AND Ejercicio = @Ejercicio
END
END
RETURN
END

