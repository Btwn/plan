SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spMFAContBalanzaCfg
@Empresa		varchar(5),
@Ejercicio		int,
@Periodo		int,
@FechaD			datetime,
@FechaA			datetime

AS BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
UPDATE EmpresaMFA  WITH (ROWLOCK) SET IncluirPolizasEspecificas = 1 WHERE Empresa = @Empresa
DELETE MFAContAdicion
FROM MFAContAdicion   WITH(NOLOCK)
JOIN Cont           WITH(NOLOCK) ON MFAContAdicion.ModuloID = Cont.ID
WHERE Cont.Ejercicio = ISNULL(@ejercicio, Cont.Ejercicio)
AND Cont.Periodo   = ISNULL(@periodo, Cont.Periodo)
AND Cont.Empresa = @Empresa
AND Cont.FechaEmision     >= ISNULL(@FechaD, FechaEmision)
AND Cont.FechaEmision     <= ISNULL(@FechaA, FechaEmision)
INSERT INTO MFAContAdicion(
ModuloID)
SELECT a.ID
FROM Cont a WITH(NOLOCK), ContD b WITH(NOLOCK), Movtipo c WITH(NOLOCK)
WHERE a.Id = b.Id
AND a.Estatus   = 'CONCLUIDO'
AND a.Ejercicio = ISNULL(@ejercicio, a.Ejercicio)
AND a.Periodo = ISNULL(@periodo, a.Periodo)
AND a.Empresa = @Empresa
AND a.FechaEmision >= ISNULL(@FechaD, FechaEmision)
AND a.FechaEmision <= ISNULL(@FechaA, FechaEmision)
AND a.Mov = c.Mov
AND c.Modulo = 'CONT'
AND c.Clave <> 'CONT.PR'
AND ISNULL(b.Presupuesto, 0) = 0
GROUP BY a.ID
DELETE MFAContAdicion
FROM MFAContAdicion  WITH (NOLOCK)
JOIN Cont WITH(NOLOCK) ON MFAContAdicion.ModuloID = Cont.ID
JOIN layout_aplicaciones_cuenta WITH(NOLOCK) ON layout_aplicaciones_cuenta.ContID = Cont.ID AND layout_aplicaciones_cuenta.ContID = MFAContAdicion.ModuloID
WHERE Cont.Ejercicio = ISNULL(@ejercicio, Cont.Ejercicio)
AND Cont.Periodo = ISNULL(@periodo, Cont.Periodo)
AND Cont.Empresa = @Empresa
AND Cont.FechaEmision >= ISNULL(@FechaD, Cont.FechaEmision)
AND Cont.FechaEmision <= ISNULL(@FechaA, Cont.FechaEmision)
END

