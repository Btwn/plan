SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInformeCXCEstadoCuenta
@EstacionTrabajo		int

AS BEGIN
DECLARE
@Empresa				varchar(5),
@Modulo					varchar(5),
@FechaD					datetime,
@Cuenta					varchar(10),
@Sucursal				int,
@Moneda					varchar(10),
@EstatusEspecifico		varchar(15),
@Etiqueta				bit,
@GraficarTipo			varchar(30),
@VerGraficaDetalle		bit
SELECT
@Empresa           =          InfoEmpresa,
@Modulo            =          LTRIM(RTRIM(InfoModulo)),
@FechaD            =          InfoFechaD,
@Cuenta            =          NULLIF(NULLIF(InfoCliente,'(Todos)'),''),
@Sucursal          =          ISNULL(InfoSucursal,-1),
@EstatusEspecifico = CASE
WHEN InfoEstatusEspecifico = 'Pendientes' THEN 'PENDIENTE'
WHEN InfoEstatusEspecifico = 'Concluidos' THEN 'CONCLUIDO'
ELSE NULL
END,
@Moneda            = CASE WHEN InfoMoneda IN('(Todas)','') THEN NULL ELSE InfoMoneda END,
@Etiqueta		   = ISNULL(InfoEtiqueta,0),
@GraficarTipo	   = ISNULL(InformeGraficarTipo,  '(Todos)'),
@VerGraficaDetalle = ISNULL(VerGraficaDetalle,0)
FROM RepParam
WHERE Estacion = @EstacionTrabajo
EXEC spInformeGenerarEstadoCuenta @EstacionTrabajo, @Empresa, @Modulo, @FechaD, @Cuenta, @Sucursal, @EstatusEspecifico, @GraficarTipo
SELECT
Empresa.Nombre EmpresaNombre,
EstadoCuenta.ID,
EstadoCuenta.Estacion,
EstadoCuenta.AuxiliarID,
EstadoCuenta.ModuloID,
LTRIM(RTRIM(EstadoCuenta.Modulo)) Modulo,
EstadoCuenta.Cuenta,
EstadoCuenta.Moneda,
EstadoCuenta.Efectivo,
EstadoCuenta.Consumos,
EstadoCuenta.Vales,
EstadoCuenta.Redondeo,
EstadoCuenta.ClienteEnviarA,
EstadoCuenta.Grafica,
EstadoCuenta.SaldoDescripcion,
EstadoCuenta.SaldoImporte,
Auxiliar.ID,
Auxiliar.Empresa,
Auxiliar.Rama,
Auxiliar.Cuenta,
Auxiliar.SubCuenta,
Auxiliar.Ejercicio,
Auxiliar.Periodo,
Auxiliar.Fecha,
Auxiliar.Grupo,
Auxiliar.Modulo,
Auxiliar.ModuloID,
Auxiliar.Mov,
Auxiliar.MovID,
Auxiliar.Cargo,
Auxiliar.Abono,
Auxiliar.Aplica,
Auxiliar.AplicaID,
Auxiliar.Acumulado,
Auxiliar.Conciliado,
Auxiliar.EsCancelacion,
Auxiliar.Moneda,
Auxiliar.TipoCambio,
Auxiliar.FechaConciliacion,
Auxiliar.Sucursal,
Cte.Cliente,
Cte.Nombre,
Cte.NombreCorto,
Cte.Numero,
Cte.Tipo,
Cte.Direccion,
Cte.EntreCalles,
Cte.Plano,
Cte.Observaciones,
Cte.Colonia,
Cte.CodigoPostal,
Cte.Poblacion,
Cte.Estado,
Cte.Pais,
Cte.Zona,
Cte.RFC,
Cte.Telefonos,
Cte.Fax,
Cte.PedirTono,
Cte.Contacto1,
Cte.Contacto2,
Cte.eMail1,
Cte.eMail2,
Cte.DirInternet,
Cte.Categoria,
Cte.Familia,
Cte.Credito,
Cte.Grupo,
Cte.DiaRevision1,
Cte.DiaRevision2,
Cte.HorarioRevision,
Cte.DiaPago1,
Cte.DiaPago2,
Cte.HorarioPago,
Cte.ZonaImpuesto,
Cte.PedidosParciales,
Cte.Clase,
Cte.Estatus,
Cte.UltimoCambio,
Cte.Alta,
Cte.Conciliar,
Cte.Descuento,
Cte.Proyecto,
Cte.Agente,
Cte.AgenteServicio,
Cte.EnviarA,
Cte.FormaEnvio,
Cte.Condicion,
Cte.Ruta,
Cte.ListaPrecios,
Cte.DefMoneda,
Cte.VtasConsignacion,
Cte.AlmacenVtasConsignacion,
Cte.Mensaje,
Cte.Extencion1,
Cte.Extencion2,
Cte.CURP,
@Etiqueta as Etiqueta,
@VerGraficaDetalle as VerGraficaDetalle,
@FechaD as FechaDesde,
GETDATE() as FechaHasta,
EmpresaCfg.ContMoneda,
Auxiliar.Cargo * Auxiliar.TipoCambio CargoMC,
Auxiliar.Abono * Auxiliar.TipoCambio AbonoMC,
Mon.TipoCambio TipoCambioMon,
EstadoCuenta.Efectivo * Mon.TipoCambio EfectivoMC,
EstadoCuenta.Consumos * Mon.TipoCambio ConsumosMC,
EstadoCuenta.Vales * Mon.TipoCambio ValesMC,
EstadoCuenta.Redondeo * Mon.TipoCambio RedondeoMC
FROM EstadoCuenta
LEFT OUTER JOIN Auxiliar ON EstadoCuenta.AuxiliarID=Auxiliar.ID
JOIN Cte ON EstadoCuenta.Cuenta=Cte.Cliente
JOIN Empresa ON Empresa.Empresa = EstadoCuenta.Empresa
JOIN EmpresaCfg ON EmpresaCfg.Empresa = Empresa.Empresa
JOIN Mon on Mon.Moneda = EstadoCuenta.Moneda
WHERE EstadoCuenta.Estacion= @EstacionTrabajo
AND EstadoCuenta.Modulo = 'CXC'
AND EstadoCuenta.Moneda = ISNULL(@Moneda,EstadoCuenta.Moneda)
END

