SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCorteCxpEstadoCuentaSimple
@EstacionTrabajo		int,
@ModuloCorte			bit		= 0,
@ModuloID				int		= 0,
@Ok                		int         = NULL OUTPUT,
@OkRef             		varchar(255)= NULL OUTPUT

AS BEGIN
DECLARE
@Empresa				varchar(5),
@Modulo					varchar(5),
@FechaD					datetime,
@CuentaD				varchar(10),
@CuentaA				varchar(10),
@Titulo					varchar(100),
@Sucursal				int,
@Moneda					varchar(10),
@EstatusEspecifico		varchar(15),
@Etiqueta				bit,
@GraficarTipo			varchar(30),
@Contacto				varchar(10),
@VerGraficaDetalle		bit
DECLARE @ContactoDireccion TABLE
(
Contacto				varchar(10)  COLLATE DATABASE_DEFAULT NULL,
Direccion1				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion2				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion3				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion4				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion5				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion6				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion7				varchar(255) COLLATE DATABASE_DEFAULT NULL,
Direccion8				varchar(255) COLLATE DATABASE_DEFAULT NULL
)
SELECT
@Empresa           = InfoEmpresa,
@Modulo            = InfoModulo,
@FechaD            = InfoFechaD,
@CuentaD           = NULLIF(InfoProveedorD,''),
@CuentaA           = NULLIF(InfoProveedorA,''),
@Sucursal          = ISNULL(InfoSucursal,-1),
@EstatusEspecifico = CASE
WHEN InfoEstatusEspecifico = 'Pendientes' THEN 'PENDIENTE'
WHEN InfoEstatusEspecifico = 'Concluidos' THEN 'CONCLUIDO'
WHEN InfoEstatusEspecifico = '(Todos)'	THEN NULL
WHEN InfoEstatusEspecifico = 'PENDIENTE'	THEN InfoEstatusEspecifico
WHEN InfoEstatusEspecifico = 'CONCLUIDO'	THEN InfoEstatusEspecifico
END,
@Moneda            = CASE WHEN InfoMoneda = '(Todas)' THEN NULL WHEN RTRIM(InfoMoneda) = '' THEN NULL ELSE InfoMoneda END,
@Etiqueta		   = ISNULL(InfoEtiqueta,0),
@GraficarTipo	   = ISNULL(InformeGraficarTipo,  '(Todos)'),
@Titulo			   = ISNULL(InfoTitulo,  ''),
@VerGraficaDetalle = ISNULL(VerGraficaDetalle,0)
FROM RepParam
WHERE Estacion = @EstacionTrabajo
EXEC spCorteGenerarEstadoCuentaSimple @EstacionTrabajo, @Empresa, @Modulo, @FechaD, @CuentaD, @CuentaA, @Sucursal, @EstatusEspecifico, @Moneda
EXEC spContactoDireccionHorizontal @EstacionTrabajo, 'Proveedor', @CuentaD, @CuentaA, 1,1,1,0
INSERT @ContactoDireccion(
Contacto, Direccion1, Direccion2, Direccion3, Direccion4,Direccion5, Direccion6, Direccion7, Direccion8)
SELECT Contacto, Direccion1, Direccion2, Direccion3, Direccion4,Direccion5, Direccion6, Direccion7, Direccion8
FROM ContactoDireccionHorizontal
WHERE Estacion = @EstacionTrabajo
/*
DECLARE crContactoDireccion CURSOR FAST_FORWARD FOR
SELECT DISTINCT Prov.Proveedor
FROM EstadoCuenta
JOIN Prov ON EstadoCuenta.Cuenta = Prov.Proveedor
WHERE EstadoCuenta.Estacion = @EstacionTrabajo
AND EstadoCuenta.Modulo = @Modulo
OPEN crContactoDireccion
FETCH NEXT FROM crContactoDireccion INTO @Contacto
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT @ContactoDireccion(Contacto, Direccion1, Direccion2, Direccion3, Direccion4,Direccion5, Direccion6, Direccion7, Direccion8)
SELECT					   Contacto, Direccion1, Direccion2, Direccion3, Direccion4,Direccion5, Direccion6, Direccion7, Direccion8
FROM dbo.fnContactoDireccionHorizontal('Proveedor',@Contacto,1,1,1,0)
FETCH NEXT FROM crContactoDireccion INTO @Contacto
END
CLOSE crContactoDireccion
DEALLOCATE crContactoDireccion
*/
SELECT Empresa.Nombre EmpresaNombre,					EstadoCuenta.ID,							EstadoCuenta.Estacion,					EstadoCuenta.AuxiliarID,
EstadoCuenta.ModuloID,							RTRIM(LTRIM(EstadoCuenta.Modulo)) Modulo,	EstadoCuenta.Cuenta,					EstadoCuenta.Moneda,
EstadoCuenta.Efectivo,							EstadoCuenta.Consumos,						EstadoCuenta.Vales,						EstadoCuenta.Redondeo,
EstadoCuenta.ClienteEnviarA,					EstadoCuenta.Grafica,						EstadoCuenta.SaldoDescripcion,			EstadoCuenta.SaldoImporte,
EstadoCuenta.Vencimiento,						EstadoCuenta.Referencia,					/*Auxiliar.ID,*/						Auxiliar.Empresa,
Auxiliar.Rama,									/*Auxiliar.Cuenta,*/						Auxiliar.SubCuenta,						Auxiliar.Ejercicio,
Auxiliar.Periodo,								Auxiliar.Fecha,								Auxiliar.Grupo,							/*Auxiliar.Modulo,*/
/*Auxiliar.ModuloID,*/							Auxiliar.Mov,								Auxiliar.MovID,							Auxiliar.Cargo,
Auxiliar.Abono,								Auxiliar.Aplica,							Auxiliar.AplicaID,						Auxiliar.Acumulado,
Auxiliar.Conciliado,							Auxiliar.EsCancelacion,						/*Auxiliar.Moneda,*/					Auxiliar.TipoCambio,
Auxiliar.FechaConciliacion,					Auxiliar.Sucursal,							Prov.Proveedor,							Prov.Nombre,
Prov.NombreCorto,								Prov.Tipo,									Prov.Direccion,							Prov.EntreCalles,
Prov.Plano,									Prov.Observaciones,							Prov.Colonia,							Prov.CodigoPostal,
Prov.Poblacion,								Prov.Estado,								Prov.Pais,								Prov.Zona,
Prov.RFC,										Prov.Telefonos,								Prov.Fax,								Prov.PedirTono,
Prov.Contacto1,								Prov.Contacto2,								Prov.eMail1,							Prov.eMail2,
Prov.DirInternet,								Prov.Categoria,								Prov.Familia,							Prov.DiaRevision1,
Prov.DiaRevision2,								Prov.HorarioRevision,						Prov.DiaPago1,							Prov.DiaPago2,
Prov.HorarioPago,								Prov.ZonaImpuesto,							Prov.Clase,								Prov.Estatus,
Prov.UltimoCambio,								Prov.Alta,									Prov.Conciliar,							Prov.Descuento,
Prov.Proyecto,									Prov.Agente,								Prov.FormaEnvio,						Prov.Condicion,
Prov.Ruta,										Prov.DefMoneda,								Prov.Mensaje,							Prov.Extencion1,
Prov.Extencion2,								Prov.CURP,									d.Direccion1 DireccionNormalizada1,		d.Direccion2 DireccionNormalizada2,
d.Direccion3 DireccionNormalizada3,			d.Direccion4 DireccionNormalizada4,			d.Direccion5 DireccionNormalizada5,     d.Direccion6 DireccionNormalizada6,
d.Direccion7 DireccionNormalizada7,			d.Direccion8 DireccionNormalizada8,			cc.LineaCredito ProveedorLimiteCredito,	ISNULL(cc.Moneda,Prov.DefMoneda) ProveedorLimiteCreditoMoneda,
ISNULL(Prov.Condicion,'') ProveedorCondicionPago,
CASE
WHEN Condicion.PorMeses = 1 AND Condicion.PorSemanas = 0 THEN ISNULL(Condicion.Meses,0)
WHEN Condicion.PorSemanas = 1 AND Condicion.PorMeses = 0 THEN ISNULL(Condicion.Semanas,0)
END ProveedorTiempoCredito,
CASE
WHEN Condicion.PorMeses = 1 AND Condicion.PorSemanas = 0 THEN 'Meses'
WHEN Condicion.PorSemanas = 1 AND Condicion.PorMeses = 0 THEN 'Semanas'
END ProveedorUnidadTiempoCredito,
ec.ContMoneda MonedaContable,					@Etiqueta as Etiqueta,						@FechaD as FechaDesde,					GETDATE() as FechaHasta,	@VerGraficaDetalle as VerGraficaDetalle
INTO #EstadoCuenta
FROM EstadoCuenta
LEFT OUTER JOIN Auxiliar ON EstadoCuenta.AuxiliarID=Auxiliar.ID
JOIN Prov ON EstadoCuenta.Cuenta=Prov.Proveedor
JOIN Empresa ON Empresa.Empresa = EstadoCuenta.Empresa
JOIN @ContactoDireccion d ON d.Contacto = Prov.Proveedor
LEFT OUTER JOIN ProvCredito cc ON cc.Proveedor = Prov.Proveedor AND cc.Empresa = @Empresa AND cc.Moneda = Prov.DefMoneda
JOIN EmpresaCFG ec ON ec.Empresa = Empresa.Empresa
LEFT OUTER JOIN Condicion ON Condicion.Condicion = Prov.Condicion
WHERE EstadoCuenta.Estacion= @EstacionTrabajo
AND EstadoCuenta.Modulo = 'CXP'
AND EstadoCuenta.Moneda = ISNULL(@Moneda,EstadoCuenta.Moneda)
IF ISNULL(@ModuloCorte, 0) = 0
SELECT * FROM #EstadoCuenta
ELSE
BEGIN
INSERT INTO #CorteD(
Cuenta,					Mov,					MovID,							Fecha,					Vencimiento,			Moneda,
Aplica,					AplicaID,				Referencia,						Cargo,					Abono,					CtaCreditoDias,
CtaCondicion,			CtaLimiteCredito,		CtaLimiteCreditoMoneda,			ID)
SELECT Cuenta,					Mov,					MovID,							Fecha,					Vencimiento,			Moneda,
Aplica,					AplicaID,				Referencia,						Cargo,					Abono,					ProveedorTiempoCredito,
ProveedorCondicionPago,	ProveedorLimiteCredito,	ProveedorLimiteCreditoMoneda,	@ModuloID
FROM #EstadoCuenta
INSERT INTO #ContactoDireccion(
Contacto,				Direccion1,				Direccion2,						Direccion3,				Direccion4,				Direccion5,
Direccion6,				Direccion7,				Direccion8)
SELECT Contacto,				Direccion1,				Direccion2,						Direccion3,				Direccion4,				Direccion5,
Direccion6,				Direccion7,				Direccion8
FROM @ContactoDireccion
END
END

