SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpMESAntesAfectar
@Modulo		        char(5),
@ID               int,
@Accion		        char(20),
@Base		          char(20),
@GenerarMov		    char(20),
@Usuario		      char(10),
@SincroFinal		  bit,
@EnSilencio	      bit,
@Ok               int 		      OUTPUT,
@OkRef            varchar(255) 	OUTPUT,
@FechaRegistro	  datetime
AS
BEGIN
DECLARE
@Empresa						varchar(5),
@Mov							varchar(20),
@MovTipo			varchar(10),
@GrupoSaldos		varchar(20),
@Cliente			varchar(20),
@LimiteCredito		Money,
@ImporteMov			Money,
@Articulo			varchar(20),
@ImpuestosC			Money,
@DescuentoC			Money,
@DescuentoI			Money,
@ImporteMovT		Money,
@Lanzamiento    int
IF @Modulo = 'VTAS'
BEGIN
EXEC spMovInfo @ID, @Modulo, @MovTipo = @MovTipo OUTPUT
IF @MovTipo IN ('VTAS.P', 'VTAS.PR') AND @Accion = 'CANCELAR'
BEGIN
IF EXISTS(SELECT vd.ID FROM VentaDMES vd WHERE vd.ID = @ID AND vd.LineaPedidoMes = 1)
SELECT @Ok = 10060, @OkRef = 'Los productos ya fueron importados en MES'
END
/*
IF @MovTipo IN ('VTAS.P', 'VTAS.PR') AND @Accion IN ('VERIFICAR','AFECTAR')
BEGIN
SELECT @GrupoSaldos = NULL, @Cliente = NULL, @LimiteCredito = NULL, @ImporteMov = NULL,
@DescuentoC   = NULL, @DescuentoI = NULL,  @ImporteMovT = NULL, @ImpuestosC = NULL
SELECT @Cliente = Cliente , @ImporteMov = Importe, @DescuentoC = DescuentoGlobal, @ImpuestosC = Impuestos
FROM	Venta  WHERE	Id = @ID
SELECT @DescuentoI = @ImporteMov * @DescuentoC / 100
SELECT @ImporteMovT = @ImporteMov - @DescuentoI + @ImpuestosC
SELECT @GrupoSaldos = Rama FROM Cte WHERE Cliente = @Cliente
IF @GrupoSaldos <> ''
BEGIN
SELECT @LimiteCredito = LimiteCredito FROM VersaConsolidaSaldos WHERE Grupo = @GrupoSaldos
IF @ImporteMovT > @LimiteCredito
SELECT @Ok = 20014, @OkRef = 'Agrupador de Saldos : ' + CHAR(13) + CHAR(13)+ @GrupoSaldos
END
DECLARE crVentaD CURSOR FOR
SELECT Articulo
FROM   VentaD
WHERE  ID = @ID
OPEN crVentaD
FETCH next FROM crVentaD INTO @Articulo
WHILE @@FETCH_STATUS = 0
BEGIN
IF NOT EXISTS(SELECT Padre FROM	IPmesversa.dbo.vw_SeleccionEstructura WHERE Padre = @Articulo)
SELECT @Ok = 25300, @OkRef = 'Debe especificar Estructura en MES / Articulo : ' + @Articulo
FETCH next FROM crVentaD INTO @Articulo
END
CLOSE crVentaD
DEALLOCATE crVentaD
END
*/
/* validacion para que centro de costos en el articulo en cualquier movimiento de ventas sea obligatorio. JRD 07-Mar-2016 */
END
/* VERSA: Valida que el Periodo en Ventas este Abierto Antes de Cancelar. */
/*
DECLARE
@Estatus						varchar(20),
@Ejercicio						int,
@Periodo						int
/* VERSA: No Permite Afectar un Movimiento del Modulo de Ventas sino hay Detalle. */
IF @Modulo = 'VTAS' AND @Accion = 'AFECTAR'
IF NOT EXISTS (SELECT Articulo FROM VentaD WHERE ID = @ID)
SELECT @Ok = 20400
/* VERSA: Valida que el Periodo en Ventas este Abierto Antes de Cancelar. */
IF @Modulo = 'COMS' AND @Accion = 'CANCELAR'
BEGIN
SELECT @Empresa = Empresa,
@Mov = Mov,
@Estatus = Estatus,
@Ejercicio = Ejercicio,
@Periodo = Periodo
FROM Compra
WHERE ID = @ID
SELECT @MovTipo = Clave
FROM MovTipo
WHERE Modulo = @Modulo
AND Mov = @Mov
IF (@MovTipo IN ('COMS.GX') OR (@MovTipo = 'COMS.B' AND @Mov = 'Bonif. Extemporanea')) AND @Estatus = 'CONCLUIDO'
IF EXISTS(SELECT EsEstadistica FROM CompraD WHERE ID = @ID AND EsEstadistica = 1)
IF EXISTS (SELECT * FROM CerrarPeriodo WHERE Empresa = @Empresa AND Rama = 'VTAS' AND Ejercicio = @Ejercicio AND Periodo = @Periodo)
SELECT @Ok = 60110
END
*/
IF @Modulo = 'COMS' AND @Accion IN ('VERIFICAR', 'AFECTAR')
BEGIN
EXEC spMovInfo @ID, @Modulo, @Mov = @Mov OUTPUT, @Empresa = @Empresa OUTPUT
IF @Mov = 'EntradaCompraMaquila'
BEGIN
DECLARE crCompraValidar CURSOR FOR
SELECT d.Articulo, d.MesLanzamiento
FROM CompraD d
WHERE d.ID = @ID
GROUP BY d.Articulo, d.MesLanzamiento
OPEN crCompraValidar
FETCH NEXT FROM crCompraValidar INTO @Articulo, @Lanzamiento
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF NOT EXISTS(
SELECT d.Articulo
FROM Inv e
JOIN InvD d ON e.ID = d.ID
JOIN PrevisionesConsumoMes p ON d.MesLanzamiento = p.Lanzamiento AND d.Articulo = p.Hijo  AND p.FaseConsumo = 'Ext'
WHERE e.Empresa = @Empresa
AND e.Estatus = 'CONCLUIDO'
AND e.Mov = 'Entrada Produccion'
AND p.Padre = @Articulo
AND d.MesLanzamiento = @Lanzamiento)
SELECT @Ok = 10060, @OkRef = 'No se ha capturado la Entrada Producción del Artículo ' + RTRIM(@Articulo) + ' con el lanzamiento ' + RTRIM(@Lanzamiento)
FETCH NEXT FROM crCompraValidar INTO @Articulo, @Lanzamiento
END
CLOSE crCompraValidar
DEALLOCATE crCompraValidar
END
END
RETURN
END

