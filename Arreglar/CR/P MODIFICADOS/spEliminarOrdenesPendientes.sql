SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEliminarOrdenesPendientes
@ID					int,
@Accion				char(20),
@Base				char(20),
@Empresa	      	char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov	  	      	char(20),
@MovID             	varchar(20),
@MovTipo     		char(20),
@MovMoneda	      	char(10),
@MovTipoCambio	 	float,
@Estatus	 	    char(15),
@EstatusNuevo	    char(15),
@FechaEmision		datetime,
@FechaRegistro		datetime,
@FechaAfectacion    datetime,
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@UtilizarID			int,
@UtilizarMovTipo    char(20),
@Ok					int		OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Referencia						varchar(50),
@AlmacenOrigen					char(10),
@AlmacenDestino					char(10),
@ArticuloDestino				char(20),
@UnidadDestino					varchar(50),
@Articulo						char(20),
@ArtTipo						varchar(20),
@UnidadOrigen					varchar(50),
@Renglon						float,
@RenglonSub						int,
@RenglonID						int,
@RenglonTipo					char(1),
@OCID							int,
@CompraPerdidaID				int,
@CompraPerdidaMov				char(20),
@PedidoID						int,
@VentaPerdidaID					int,
@VentaPerdidaMov				char(20),
@CompraPerdidaAutoPorcentaje	float,
@VentaPerdidaAutoPorcentaje		float,
@CantidadOriginal				float,
@CantidadPendiente				float
IF @Modulo = 'COMS' AND (SELECT CompraPerdidaAuto FROM EmpresaCfg WITH(NOLOCK) WHERE Empresa = @Empresa) = 1
BEGIN
SELECT @CompraPerdidaMov = CompraPerdida
FROM EmpresaCfgMov
WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @CompraPerdidaAutoPorcentaje=ISNULL(CompraPerdidaAutoPorcentaje,0.0)
FROM EmpresaCfg
WITH(NOLOCK) WHERE Empresa=@Empresa
DECLARE crComprasPendientes CURSOR FOR
SELECT DISTINCT e.ID
FROM CompraD d
 WITH(NOLOCK) JOIN Compra e  WITH(NOLOCK) ON e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE' AND e.Mov = d.Aplica AND e.MovID = d.AplicaID
JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = @Modulo AND mt.Mov = e.Mov AND mt.Clave = 'COMS.O'
WHERE d.ID = @ID
OPEN crComprasPendientes
FETCH NEXT FROM crComprasPendientes  INTO @OCID
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
IF EXISTS(SELECT * FROM CompraD WHERE ID = @OCID AND NULLIF(CantidadPendiente, 0.0) IS NOT NULL)
BEGIN
SELECT @CantidadOriginal = SUM(ISNULL(Cantidad,0)),
@CantidadPendiente = SUM(ISNULL(CantidadPendiente,0))
FROM CompraD WHERE ID = @OCID
IF 100-((@CantidadPendiente/@CantidadOriginal)*100) > @CompraPerdidaAutoPorcentaje
BEGIN
EXEC @CompraPerdidaID = spAfectar @Modulo, @OCID, 'GENERAR', 'PENDIENTE', @CompraPerdidaMov, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @Ok IS NULL
EXEC spAfectar @Modulo, @CompraPerdidaID, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
END
END
FETCH NEXT FROM crComprasPendientes  INTO @OCID
END  
CLOSE crComprasPendientes
DEALLOCATE crComprasPendientes
END
IF @Modulo = 'VTAS' AND (SELECT VentaPerdidaAuto FROM EmpresaCfg WITH(NOLOCK) WHERE Empresa = @Empresa) = 1
BEGIN
SELECT @VentaPerdidaMov = VentaPerdida
FROM EmpresaCfgMov
WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @VentaPerdidaAutoPorcentaje=ISNULL(VentaPerdidaAutoPorcentaje,0.0)
FROM EmpresaCfg
WITH(NOLOCK) WHERE Empresa=@Empresa
DECLARE crPedidosPendientes CURSOR FOR
SELECT DISTINCT e.ID
FROM VentaD d
 WITH(NOLOCK) JOIN Venta e  WITH(NOLOCK) ON e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE' AND e.Mov = d.Aplica AND e.MovID = d.AplicaID
JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = @Modulo AND mt.Mov = e.Mov AND mt.Clave = 'VTAS.P'
WHERE d.ID = @ID
OPEN crPedidosPendientes
FETCH NEXT FROM crPedidosPendientes  INTO @PedidoID
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
BEGIN
/*        IF EXISTS(SELECT * FROM VentaD WHERE ID = @PedidoID AND NULLIF(CantidadReservada, 0.0) IS NOT NULL)
EXEC spAfectar @Modulo, @PedidoID, 'DESRESERVAR', 'RESERVADO', @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT*/
IF EXISTS(SELECT * FROM VentaD WHERE ID = @PedidoID AND ISNULL(CantidadPendiente, 0.0) + ISNULL(CantidadReservada,0) + ISNULL(CantidadOrdenada,0) > 0)
BEGIN
SELECT @CantidadOriginal = SUM(ISNULL(Cantidad,0)),
@CantidadPendiente = SUM(ISNULL(CantidadPendiente,0) + ISNULL(CantidadReservada,0) + ISNULL(CantidadOrdenada,0))
FROM VentaD WHERE ID = @PedidoID
IF 100-((@CantidadPendiente/@CantidadOriginal)*100) > @VentaPerdidaAutoPorcentaje
BEGIN
EXEC @VentaPerdidaID = spAfectar @Modulo, @PedidoID, 'GENERAR', 'PENDIENTE', @VentaPerdidaMov, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok = 80030 SELECT @Ok = NULL, @OkRef = NULL
IF @Ok IS NULL
EXEC spAfectar @Modulo, @VentaPerdidaID, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
END
END
FETCH NEXT FROM crPedidosPendientes  INTO @PedidoID
END  
CLOSE crPedidosPendientes
DEALLOCATE crPedidosPendientes
END
RETURN
END

