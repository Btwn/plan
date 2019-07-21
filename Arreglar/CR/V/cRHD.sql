SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW cRHD

AS
SELECT
ID,
Renglon,
Personal,
SueldoDiario,
SDI,
TipoContrato,
PeriodoTipo,
Jornada,
TipoSueldo,
Categoria,
Departamento,
Puesto,
Grupo,
Observaciones,
FechaAlta,
FechaAntiguedad,
SucursalTrabajo,
Calificacion,
Sucursal,
SucursalOrigen,
ReportaA,
CentroCostos,
Incremento,
SueldoNuevo,
Plaza,
SueldoDiarioComplemento,
SueldoMensual,
RataHora,
FechaInicioContrato,
DuracionContrato,
Logico1,
Logico2,
Logico3,
Logico4,
Logico5
FROM
RHD

