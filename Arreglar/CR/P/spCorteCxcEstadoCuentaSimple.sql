SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCorteCxcEstadoCuentaSimple
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
@Sucursal				int,
@Moneda					varchar(10),
@EstatusEspecifico		varchar(15),
@Etiqueta				bit,
@GraficarTipo			varchar(30),
@Contacto				varchar(10),
@Titulo					varchar(100),
@FechaA					datetime,
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
@CuentaD           = NULLIF(InfoClienteD,''),
@CuentaA           = NULLIF(InfoClienteA,''),
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
EXEC spContactoDireccionHorizontal @EstacionTrabajo, 'Cliente', @CuentaD, @CuentaA, 1,1,1,0
INSERT @ContactoDireccion(
Contacto, Direccion1, Direccion2, Direccion3, Direccion4,Direccion5, Direccion6, Direccion7, Direccion8)
SELECT Contacto, Direccion1, Direccion2, Direccion3, Direccion4,Direccion5, Direccion6, Direccion7, Direccion8
FROM ContactoDireccionHorizontal
WHERE Estacion = @EstacionTrabajo
/*
DECLARE crContactoDireccion CURSOR FAST_FORWARD FOR
SELECT DISTINCT Cte.Cliente
FROM EstadoCuenta
JOIN Cte ON EstadoCuenta.Cuenta = Cte.Cliente
WHERE EstadoCuenta.Estacion = @EstacionTrabajo
AND EstadoCuenta.Modulo = @Modulo
OPEN crContactoDireccion
FETCH NEXT FROM crContactoDireccion INTO @Contacto
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT @ContactoDireccion(Contacto, Direccion1, Direccion2, Direccion3, Direccion4,Direccion5, Direccion6, Direccion7, Direccion8)
SELECT					   Contacto, Direccion1, Direccion2, Direccion3, Direccion4,Direccion5, Direccion6, Direccion7, Direccion8
FROM dbo.fnContactoDireccionHorizontal('Cliente',@Contacto,1,1,1,0)
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
Auxiliar.FechaConciliacion,					Auxiliar.Sucursal,							Cte.Cliente,							Cte.Nombre,
Cte.NombreCorto,								Cte.Numero,									Cte.Tipo,								Cte.Direccion,
Cte.EntreCalles,								Cte.Plano,									Cte.Observaciones,						Cte.Colonia,
Cte.CodigoPostal,								Cte.Poblacion,								Cte.Estado,								Cte.Pais,
Cte.Zona,										Cte.RFC,									Cte.Telefonos,							Cte.Fax,
Cte.PedirTono,									Cte.Contacto1,								Cte.Contacto2,							Cte.eMail1,
Cte.eMail2,									Cte.DirInternet,							Cte.Categoria,							Cte.Familia,
Cte.Credito,									Cte.Grupo 'CteGrupo',						Cte.DiaRevision1,						Cte.DiaRevision2,
Cte.HorarioRevision,							Cte.DiaPago1,								Cte.DiaPago2,							Cte.HorarioPago,
Cte.ZonaImpuesto,								Cte.PedidosParciales,						Cte.Clase,								Cte.Estatus,
Cte.UltimoCambio,								Cte.Alta,									Cte.Conciliar,							Cte.Descuento,
Cte.Proyecto,									Cte.Agente,									Cte.AgenteServicio,						Cte.EnviarA,
Cte.FormaEnvio,								Cte.Condicion,								Cte.Ruta,								Cte.ListaPrecios,
Cte.DefMoneda,									Cte.VtasConsignacion,						Cte.AlmacenVtasConsignacion,			Cte.Mensaje,
Cte.Extencion1,								Cte.Extencion2,								Cte.CURP,								d.Direccion1 DireccionNormalizada1,
d.Direccion2 DireccionNormalizada2,			d.Direccion3 DireccionNormalizada3,			d.Direccion4 DireccionNormalizada4,		d.Direccion5 DireccionNormalizada5,
d.Direccion6 DireccionNormalizada6,			d.Direccion7 DireccionNormalizada7,			d.Direccion8 DireccionNormalizada8,		Cte.CreditoEspecial,
Cte.CreditoConDias,							Cte.CreditoDias,							cc.ConDias,								cc.Dias,
Cte.CreditoConCondiciones,						Cte.CreditoCondiciones,						cc.Condiciones,							cc.ConCondiciones,
Cte.CreditoConLimite,							Cte.CreditoLimite,							cc.ConLimiteCredito,					cc.LimiteCredito,
Cte.CreditoMoneda,								cc.MonedaCredito,							ec.ContMoneda MonedaContable,			@Etiqueta as Etiqueta,
@FechaD as FechaDesde,							GETDATE() as FechaHasta,
CASE WHEN Cte.CreditoEspecial = 1 THEN
CASE WHEN Cte.CreditoConLimite = 1 THEN ISNULL(Cte.CreditoLimite,0.0) ELSE NULL END
ELSE
CASE WHEN cc.ConLimiteCredito = 1 THEN ISNULL(cc.LimiteCredito,0.0) ELSE NULL END
END ClienteLimiteCredito,
CASE WHEN Cte.CreditoEspecial = 1 THEN
CASE WHEN Cte.CreditoConLimite = 1 THEN ISNULL(Cte.CreditoMoneda,'') ELSE NULL END
ELSE
CASE WHEN cc.ConLimiteCredito = 1 THEN ISNULL(cc.MonedaCredito,'') ELSE NULL END
END ClienteLimiteCreditoMoneda,
ISNULL(CASE WHEN Cte.CreditoEspecial = 1 THEN
CASE WHEN Cte.CreditoConCondiciones = 1 THEN NULLIF(Cte.CreditoCondiciones,'') ELSE NULL END
ELSE
CASE WHEN cc.ConCondiciones = 1 THEN NULLIF(cc.Condiciones,'') ELSE CONVERT(varchar,NULL) END
END,Cte.Condicion) ClienteCondicionPago,
CASE WHEN Cte.CreditoEspecial = 1 THEN
CASE WHEN Cte.CreditoConDias = 1 THEN ISNULL(Cte.CreditoDias,0) ELSE CONVERT(int,NULL) END
ELSE
CASE WHEN cc.ConDias = 1 THEN ISNULL(cc.Dias,0) ELSE CONVERT(int,NULL) END
END ClienteCreditoDias,
@VerGraficaDetalle VerGraficaDetalle
INTO #EstadoCuenta
FROM EstadoCuenta
LEFT OUTER JOIN Auxiliar ON EstadoCuenta.AuxiliarID=Auxiliar.ID
JOIN Cte ON EstadoCuenta.Cuenta=Cte.Cliente
JOIN Empresa ON Empresa.Empresa = EstadoCuenta.Empresa
JOIN @ContactoDireccion d ON d.Contacto = Cte.Cliente
LEFT OUTER JOIN CteCredito cc ON cc.Credito = Cte.Credito AND cc.Empresa = @Empresa
JOIN EmpresaCFG ec ON ec.Empresa = Empresa.Empresa
WHERE EstadoCuenta.Estacion= @EstacionTrabajo
AND EstadoCuenta.Modulo = 'CXC'
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
Aplica,					AplicaID,				Referencia,						Cargo,					Abono,					ClienteCreditoDias,
ClienteCondicionPago,	ClienteLimiteCredito,	ClienteLimiteCreditoMoneda,		@ModuloID
FROM #EstadoCuenta
INSERT INTO #ContactoDireccion(
Contacto,				Direccion1,				Direccion2,						Direccion3,				Direccion4,				Direccion5,
Direccion6,				Direccion7,				Direccion8)
SELECT Contacto,				Direccion1,				Direccion2,						Direccion3,				Direccion4,				Direccion5,
Direccion6,				Direccion7,				Direccion8
FROM @ContactoDireccion
END
END

