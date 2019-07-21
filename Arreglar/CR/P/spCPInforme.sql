SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCPInforme
@Estacion		int

AS BEGIN
DECLARE
@FechaD			datetime,
@FechaA			datetime,
@ClaveD			varchar(100),
@ClaveA			varchar(100),
@Proyecto		varchar(100),
@Empresa		varchar(100),
@Estatus		varchar(100),
@Titulo			varchar(100),
@VerGraficaDetalle		bit
SELECT @FechaD = InfoFechaD,
@FechaA = InfoFechaA,
@ClaveD = ISNULL(InfoClavePresupuestalD,''),
@ClaveA = ISNULL(InfoClavePresupuestalA,''),
@Proyecto = InfoProyecto,
@Empresa = InfoEmpresa,
@Estatus = InfoEstatusEspecifico,
@Titulo = RepTitulo,
@VerGraficaDetalle = ISNULL(VerGraficaDetalle,0)
FROM RepParam
WHERE Estacion = @Estacion
IF @Proyecto = '(Todos)'
SELECT @Proyecto = NULL
IF @ClaveD = ''
SELECT @ClaveD = (SELECT MIN(ClavePresupuestal) FROM ClavePresupuestal)
IF @ClaveA = ''
SELECT @ClaveA = (SELECT MAX(ClavePresupuestal) FROM ClavePresupuestal)
IF @Estatus = '(Todos)' SET @Estatus = NULL ELSE
IF @Estatus = 'Pendientes' SET @Estatus = 'PENDIENTE' ELSE
IF @Estatus = 'Concluidos' SET @Estatus = 'CONCLUIDO'
SELECT e.Empresa,
e.Proyecto,
d.ClavePresupuestal,
'Presupuesto' = ISNULL(SUM(d.Presupuesto*e.TipoCambio), 0.0),
'Comprometido' = ISNULL(SUM(d.Comprometido*e.TipoCambio), 0.0),
'Comprometido2' = ISNULL(SUM(d.Comprometido2*e.TipoCambio), 0.0),
'Devengado' = ISNULL(SUM(d.Devengado*e.TipoCambio), 0.0),
'Devengado2' = ISNULL(SUM(d.Devengado2*e.TipoCambio), 0.0),
'Ejercido' = ISNULL(SUM(d.Ejercido*e.TipoCambio), 0.0),
'EjercidoPagado' = ISNULL(SUM(d.EjercidoPagado), 0.0),
'RemanenteDisponible' = ISNULL(SUM(d.RemanenteDisponible*e.TipoCambio), 0.0),
'Anticipos' = ISNULL(SUM(d.Anticipos*e.TipoCambio), 0.0),
'Sobrante' = ISNULL(SUM(d.Sobrante*e.TipoCambio), 0.0),
'Disponible' = ISNULL(SUM(d.Disponible), 0.0),
@FechaD FechaDesde,
@FechaA FechaHasta,
@ClaveD ClaveDesde,
@ClaveA ClaveHasta,
@Titulo Titulo,
ISNULL(@Proyecto, '(Todos)') InfoProyecto,
ISNULL(@Estatus, 'Pendientes, Concluidos') InfoEstatus,
ISNULL(LTRIM(RTRIM(ISNULL(e.Origen, e.Mov))) + ' ' + LTRIM(RTRIM(ISNULL(e.OrigenID,e.MovID))) + ' - ' + LTRIM(RTRIM(SUBSTRING(CONVERT(varchar,e.FechaEmision),1,11))), '') Origen
FROM CPD d
JOIN CP e ON e.ID = d.ID AND e.Estatus = ISNULL(@Estatus, e.Estatus)
JOIN MovTipo mt ON mt.Modulo = 'CP' AND mt.Mov = e.Mov AND mt.Clave IN ('CP.AS', 'CP.TA', 'CP.TR', 'CP.OP')
LEFT OUTER JOIN Modulo m ON e.OrigenTipo = m.Modulo
WHERE ClavePresupuestal BETWEEN @ClaveD AND @ClaveA 
AND Proyecto = ISNULL(@Proyecto, Proyecto)
AND e.Estatus IN('PENDIENTE', 'CONCLUIDO')
AND e.Empresa = @Empresa
GROUP BY e.Empresa, e.Proyecto, d.ClavePresupuestal, ISNULL(LTRIM(RTRIM(ISNULL(e.Origen, e.Mov))) + ' ' + LTRIM(RTRIM(ISNULL(e.OrigenID,e.MovID))) + ' - ' + LTRIM(RTRIM(SUBSTRING(CONVERT(varchar,e.FechaEmision),1,11))), '')
END

