SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spSDIVariablesDetalle
@FechaD	 DATETIME,
@FechaA	 DATETIME,
@Periodo CHAR(20)

AS BEGIN
SELECT  N.Mov,
N.MovID,
N.Ejercicio,
N.Periodo,
N.FechaD,
N.FechaA,
D.Personal,
'Nombre'=P.Nombre+' '+P.ApellidoPaterno+' '+P.ApellidoMaterno,
D.Concepto,
D.Cantidad,
D.Importe
FROM  Nomina N JOIN NominaD D ON N.ID=D.ID
JOIN Personal P ON D.Personal=P.Personal
JOIN NomXPersonal NXP ON D.Concepto=NXP.Concepto
WHERE  N.MOV='Nomina'
AND  N.Estatus='CONCLUIDO'
AND  N.PeriodoTipo=@Periodo
AND  NXP.Acum LIKE '%Total Gravable IMSS Variable%' 
AND  NXP.ID=1
AND  N.FechaEmision BETWEEN @FechaD AND @FechaA
GROUP BY  N.ID, N.Mov, N.MovID, N.FechaEmision, N.Estatus, N.Ejercicio, N.Periodo, N.FechaD, N.FechaA, D.Personal, P.Nombre, P.ApellidoPaterno, P.ApellidoMaterno, D.Concepto, D.Cantidad, D.Importe, D.Movimiento
ORDER BY D.Personal
END
/*
EXEC spSDIVariablesDetalle '01/01/2015','28/02/2015','Quincenal'
*/

