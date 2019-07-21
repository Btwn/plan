SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovReciboValidar
@Empresa		char(5),
@Fecha		datetime,
@Modulo		char(5),
@ID			int,
@Cuenta		char(10),
@AplicaMov		char(20),
@AplicaMovID	varchar(20),
@Articulo		char(20),
@SubCuenta		varchar(50),
@Cantidad		float,
@Unidad		varchar(50),
@Costo		float,
@Caducidad		datetime,
@Lote		varchar(50)

AS BEGIN
DECLARE
@Ok			int,
@OkRef		varchar(255),
@LotesFijos		bit,
@TieneCaducidad	bit,
@CaducidadMinima	int,
@CfgCompraCaducidad	bit,
@AplicaID		int,
@CantidadPendiente	float,
@CantidadRecibida	float,
@CostoAnterior	float,
@Factor		float
SELECT @Ok = NULL, @OkRef = NULL, @AplicaID = NULL, @AplicaMov = NULLIF(NULLIF(RTRIM(@AplicaMov), '0'), ''), @AplicaMovID = NULLIF(NULLIF(RTRIM(@AplicaMovID), '0'), '')
SELECT @SubCuenta = NULLIF(NULLIF(RTRIM(@SubCuenta), '0'), ''), @Unidad = NULLIF(NULLIF(RTRIM(@Unidad), '0'), ''), @Lote = NULLIF(NULLIF(RTRIM(@Lote), '0'), '')
SELECT @LotesFijos = ISNULL(LotesFijos, 0), @TieneCaducidad = ISNULL(TieneCaducidad, 0), @CaducidadMinima = NULLIF(CaducidadMinima, 0) FROM Art WITH(NOLOCK) WHERE Articulo = @Articulo
SELECT @CfgCompraCaducidad = ISNULL(CompraCaducidad, 0)
FROM EmpresaCfg2 WITH(NOLOCK)
WHERE Empresa = @Empresa
IF @AplicaMov IS NOT NULL
BEGIN
IF @Modulo = 'COMS' SELECT @AplicaID = ID FROM Compra WITH(NOLOCK) WHERE Empresa = @Empresa AND Proveedor = @Cuenta AND Estatus = 'PENDIENTE' AND Mov = @AplicaMov AND MovID = @AplicaMovID ELSE
IF @Modulo = 'INV'  SELECT @AplicaID = ID FROM Inv WITH(NOLOCK)  WHERE Empresa = @Empresa AND Estatus = 'PENDIENTE' AND Mov = @AplicaMov AND MovID = @AplicaMovID
END
SELECT @Factor = Factor FROM Unidad WITH(NOLOCK) WHERE Unidad = @Unidad
IF @Modulo = 'COMS' AND @LotesFijos = 1 AND @Lote IS NULL SELECT @Ok = 20060 ELSE
IF NULLIF(@Cantidad, 0) IS NULL SELECT @Ok = 20010 ELSE
IF @Unidad IS NULL SELECT @Ok = 20130 ELSE
IF NULLIF(@Costo, 0) IS NULL SELECT @Ok = 20100 ELSE
IF @Modulo = 'COMS' AND @CfgCompraCaducidad = 1 AND @TieneCaducidad = 1 AND @CaducidadMinima IS NOT NULL
BEGIN
IF @Caducidad IS NULL SELECT @Ok = 25125 ELSE
IF @Caducidad < DATEADD(day, @CaducidadMinima, @Fecha) SELECT @Ok = 25126
END
IF @Ok IS NULL AND @AplicaID IS NOT NULL
BEGIN
IF @Modulo = 'COMS'
SELECT @CantidadPendiente = ISNULL(SUM(CantidadPendiente*Factor), 0)
FROM CompraD WITH(NOLOCK)
WHERE ID = @AplicaID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND ISNULL(CantidadPendiente, 0) > 0
ELSE
IF @Modulo = 'INV'
SELECT @CantidadPendiente = ISNULL(SUM(CantidadPendiente*Factor), 0)
FROM InvD WITH(NOLOCK)
WHERE ID = @AplicaID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND ISNULL(CantidadPendiente, 0) > 0
SELECT @CantidadRecibida = ISNULL(SUM(r.Cantidad*u.Factor), 0)
FROM MovRecibo r WITH(NOLOCK), Unidad u WITH(NOLOCK)
WHERE r.Modulo = @Modulo AND r.ModuloID = @ID AND r.Articulo = @Articulo AND ISNULL(r.SubCuenta, '') = ISNULL(@SubCuenta, '')
AND r.Unidad = u.Unidad
IF @CantidadPendiente < @CantidadRecibida + (@Cantidad * @Factor)
BEGIN
IF @CantidadPendiente = 0 SELECT @Ok = 30191 ELSE SELECT @Ok = 30193
END ELSE BEGIN
SELECT @CostoAnterior = NULL
SELECT @CostoAnterior = NULLIF(MIN(Costo), 0)
FROM MovRecibo WITH(NOLOCK)
WHERE Modulo = @Modulo AND ModuloID = @ID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = ISNULL(@SubCuenta, '') AND Unidad = @Unidad AND ISNULL(Lote, '') = ISNULL(@Lote, '')
IF @CostoAnterior IS NOT NULL AND @Costo <> @CostoAnterior SELECT @Ok = 20101
END
END
IF @Ok IS NULL
SELECT @Ok
ELSE
SELECT Descripcion + ' ' + ISNULL(@OkRef, '') FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = @Ok
RETURN
END

