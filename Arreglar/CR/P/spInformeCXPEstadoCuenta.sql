SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInformeCXPEstadoCuenta
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
@Cuenta            =          NULLIF(NULLIF(InfoProveedor,'(Todos)'),''),
@Sucursal          =          ISNULL(InfoSucursal,-1),
@EstatusEspecifico = CASE
WHEN InfoEstatusEspecifico = 'Pendientes' THEN 'PENDIENTE'
WHEN InfoEstatusEspecifico = 'Concluidos' THEN 'CONCLUIDO'
ELSE NULL
END,
@Moneda            = CASE WHEN InfoMoneda = '(Todas)' THEN NULL ELSE InfoMoneda END,
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
Prov.Proveedor,
Prov.Nombre,
Prov.NombreCorto,
Prov.Tipo,
Prov.Direccion,
Prov.EntreCalles,
Prov.Plano,
Prov.Observaciones,
Prov.Colonia,
Prov.CodigoPostal,
Prov.Poblacion,
Prov.Estado,
Prov.Pais,
Prov.Zona,
Prov.RFC,
Prov.Telefonos,
Prov.Fax,
Prov.PedirTono,
Prov.Contacto1,
Prov.Contacto2,
Prov.eMail1,
Prov.eMail2,
Prov.DirInternet,
Prov.Categoria,
Prov.Familia,
Prov.DiaRevision1,
Prov.DiaRevision2,
Prov.HorarioRevision,
Prov.DiaPago1,
Prov.DiaPago2,
Prov.HorarioPago,
Prov.ZonaImpuesto,
Prov.Clase,
Prov.Estatus,
Prov.UltimoCambio,
Prov.Alta,
Prov.Conciliar,
Prov.Descuento,
Prov.Proyecto,
Prov.Agente,
Prov.FormaEnvio,
Prov.Condicion,
Prov.Ruta,
Prov.DefMoneda,
Prov.Mensaje,
Prov.Extencion1,
Prov.Extencion2,
Prov.CURP,
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
JOIN Prov ON EstadoCuenta.Cuenta=Prov.Proveedor
JOIN Empresa ON Empresa.Empresa = EstadoCuenta.Empresa
JOIN EmpresaCfg ON EmpresaCfg.Empresa = Empresa.Empresa
JOIN Mon on Mon.Moneda = EstadoCuenta.Moneda
WHERE EstadoCuenta.Estacion= @EstacionTrabajo
AND EstadoCuenta.Modulo = 'CXP'
AND EstadoCuenta.Moneda = ISNULL(@Moneda,EstadoCuenta.Moneda)
END

