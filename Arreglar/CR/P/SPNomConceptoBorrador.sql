SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC SPNomConceptoBorrador
@ID INT

AS BEGIN
SELECT D.id, D.Personal, P.ApellidoPaterno, P.ApellidoMaterno, P.Nombre, P.Departamento, D.Movimiento, D.Concepto, D.Importe, D.Cantidad
FROM NominaD D
JOIN Personal P on D.Personal=P.Personal
WHERE ID=@ID and D.Movimiento in ('Percepcion','Deduccion')
END

