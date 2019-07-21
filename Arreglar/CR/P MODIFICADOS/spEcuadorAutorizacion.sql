SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEcuadorAutorizacion
@Sucursal		int,
@Empresa     	char(5),
@Modulo		char(5),
@ID			int,
@Accion		varchar(20),
@EstatusNuevo	varchar(20),
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE @EcuadorMostrarAnexo		varchar(20),
@Mov				varchar(20),
@MovID			varchar(20),
@FechaRegistro		datetime,
@AutorizacionSRI		varchar(50),
@Serie			varchar(10),
@Consecutivo			bigint,
@Articulo			varchar(50),
@EsEcuador			bit,
@TipoRegistro			varchar(20),
@Renglon			float,
@RenglonSub			int,
@SQL				nvarchar(MAX),
@Tabla			varchar(50),
@LongitudSecuencialSRI	int,
@Secuencial			varchar(16),
@Establecimiento		varchar(20),
@PuntoEmision			varchar(50),
@SecuencialSRI		varchar(50),
@VigenteA			datetime,
@SustentoComprobante		varchar(20),
@TipoComprobante		varchar(20)
SELECT @EsEcuador = EsEcuador, @LongitudSecuencialSRI = LongitudSecuencialSRI FROM Empresa WHERE Empresa = @Empresa
IF @Modulo = 'COMS' SELECT @Mov = RTRIM(c.Mov), @MovID = RTRIM(c.MovID), @FechaRegistro = c.FechaRegistro, @AutorizacionSRI = c.AutorizacionSRI, @TipoRegistro = p.TipoRegistro FROM Compra c  WITH(NOLOCK) JOIN Prov p  WITH(NOLOCK) ON p.Proveedor = c.Proveedor WHERE ID = @ID ELSE
IF @Modulo = 'VTAS' SELECT @Mov = RTRIM(v.Mov), @MovID = RTRIM(v.MovID), @FechaRegistro = v.FechaRegistro, @AutorizacionSRI = v.AutorizacionSRI, @TipoRegistro = c.TipoRegistro FROM Venta v  WITH(NOLOCK) JOIN Cte c  WITH(NOLOCK) ON c.Cliente = v.Cliente WHERE ID = @ID ELSE
IF @Modulo = 'GAS'  SELECT @Mov = RTRIM(g.Mov), @MovID = RTRIM(g.MovID), @FechaRegistro = g.FechaRegistro, @AutorizacionSRI = g.AutorizacionSRI, @TipoRegistro = p.TipoRegistro FROM Gasto g  WITH(NOLOCK) JOIN Prov p  WITH(NOLOCK) ON p.Proveedor = g.Acreedor WHERE ID = @ID
EXEC spMovIDEnSerieConsecutivo @MovID, @Serie OUTPUT, @Consecutivo OUTPUT
SELECT @EcuadorMostrarAnexo = RTRIM(EcuadorMostrarAnexo) FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
IF @EcuadorMostrarAnexo IN ('Detalle','Encabezado') AND @Accion = 'AFECTAR' AND @EsEcuador = 1
BEGIN
IF @EcuadorMostrarAnexo = 'Encabezado'
BEGIN
IF @Modulo = 'VTAS'
BEGIN
SELECT @Establecimiento = NULLIF(Establecimiento,''),
@PuntoEmision = NULLIF(PuntoEmision,''),
@SecuencialSRI = NULLIF(SecuencialSRI,''),
@AutorizacionSRI = NULLIF(AutorizacionSRI,''),
@VigenteA = VigenteA
FROM Venta
WITH(NOLOCK) WHERE ID = @ID
IF @Establecimiento IS NULL AND @Ok IS NULL SELECT @Ok = 25480 ELSE
IF @PuntoEmision IS NULL AND @Ok IS NULL SELECT @Ok = 25481 ELSE
IF @AutorizacionSRI IS NULL AND @Ok IS NULL SELECT @ok = 25483 ELSE
IF @VigenteA IS NULL AND @Ok IS NULL SELECT @ok = 25484
IF @OK IS NOT NULL RETURN
END ELSE
IF @Modulo IN ('COMS')
BEGIN
SELECT @SustentoComprobante = NULLIF(SustentoComprobante,''),
@TipoComprobante = NULLIF(TipoComprobante,''),
@Establecimiento = NULLIF(Establecimiento,''),
@PuntoEmision = NULLIF(PuntoEmision,'')
FROM Compra
WITH(NOLOCK) WHERE ID = @ID
IF @SustentoComprobante IS NULL AND @Ok IS NULL SELECT @Ok = 25485 ELSE
IF @TipoComprobante IS NULL AND @Ok IS NULL SELECT @Ok = 25486 ELSE
IF @Establecimiento IS NULL AND @Ok IS NULL SELECT @Ok = 25480 ELSE
IF @PuntoEmision IS NULL AND @Ok IS NULL SELECT @Ok = 25481
END ELSE
BEGIN
IF @Modulo IN ('GAS')
BEGIN
SELECT @SustentoComprobante = NULLIF(SustentoComprobante,''),
@TipoComprobante = NULLIF(TipoComprobante,''),
@Establecimiento = NULLIF(Establecimiento,''),
@PuntoEmision = NULLIF(PuntoEmision,'')
FROM Gasto
WITH(NOLOCK) WHERE ID = @ID
IF @SustentoComprobante IS NULL AND @Ok IS NULL SELECT @Ok = 25485 ELSE
IF @TipoComprobante IS NULL AND @Ok IS NULL SELECT @Ok = 25486 ELSE
IF @Establecimiento IS NULL AND @Ok IS NULL SELECT @Ok = 25480 ELSE
IF @PuntoEmision IS NULL AND @Ok IS NULL SELECT @Ok = 25481
END
END
IF @Modulo = 'VTAS' AND @Ok IS NULL SET @Tabla = 'Venta'  ELSE
IF @Modulo = 'COMS' AND @Ok IS NULL SET @Tabla = 'Compra' ELSE
IF @Modulo = 'GAS'  AND @Ok IS NULL SET @Tabla = 'Gasto'
SELECT @Modulo = ConsecutivoModulo FROM MovTipo WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov
IF @Modulo = 'VTAS' AND NOT EXISTS(SELECT TOP 1 * FROM EcuadorAutorizacion WHERE Modulo = @Modulo AND Mov = @Mov AND Empresa = @Empresa AND ISNULL(Sucursal,@Sucursal) = @Sucursal AND RTRIM(ISNULL(Serie,'')) = RTRIM(ISNULL(@Serie,'')) AND @Consecutivo BETWEEN ISNULL(FolioD,@Consecutivo) AND ISNULL(FolioA,@Consecutivo) AND Vigencia >= @FechaRegistro AND Autorizacion = @AutorizacionSRI ORDER BY Vigencia DESC) SELECT @Ok = 31010, @OkRef = 'Error en la Aprobaci�n del Anexo Transaccional.'
IF @OK IS NULL
BEGIN
IF @Modulo = 'VTAS'
BEGIN
SELECT @LongitudSecuencialSRI = LongitudSecuencialSRI FROM Empresa WHERE Empresa = @Empresa
EXEC spLlenarCeros @MovID, @LongitudSecuencialSRI, @Secuencial OUTPUT
END
END
SET @SQL = 'UPDATE ' + RTRIM(@Tabla) + ' SET TipoIdentificacion  = ' + CHAR(39) + ISNULL(RTRIM(@TipoRegistro),'') + CHAR(39) + ', SecuencialSRI = ' + CHAR(39) + ISNULL(RTRIM(@Secuencial),'') + CHAR(39) + ' WHERE ID = ' + RTRIM(CONVERT(varchar,@ID))
IF @Ok IS NULL
BEGIN
EXEC sp_ExecuteSql @SQL
IF @@ERROR <> 0 SET @Ok = 1
END
END ELSE
BEGIN
IF @Modulo = 'VTAS' DECLARE crDetalle CURSOR FOR SELECT AutorizacionSRI, Articulo, Renglon, RenglonSub FROM VentaD  WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'COMS' DECLARE crDetalle CURSOR FOR SELECT AutorizacionSRI, Articulo, Renglon, RenglonSub FROM CompraD WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'GAS'  DECLARE crDetalle CURSOR FOR SELECT AutorizacionSRI, Concepto, Renglon, CONVERT(int,NULL) FROM GastoD WITH(NOLOCK) WHERE ID = @ID
SELECT @Modulo = ConsecutivoModulo FROM MovTipo WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov
IF @Modulo = 'VTAS' AND @Ok IS NULL SET @Tabla = 'VentaD'  ELSE
IF @Modulo = 'COMS' AND @Ok IS NULL SET @Tabla = 'CompraD' ELSE
IF @Modulo = 'GAS'  AND @Ok IS NULL SET @Tabla = 'GastoD'
OPEN crDetalle
FETCH NEXT FROM crDetalle  INTO @AutorizacionSRI, @Articulo, @Renglon, @RenglonSub
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF @Modulo = 'VTAS'
BEGIN
SELECT @Establecimiento = Establecimiento,
@PuntoEmision = PuntoEmision,
@SecuencialSRI = SecuencialSRI,
@AutorizacionSRI = AutorizacionSRI,
@VigenteA = VigenteA
FROM VentaD
WITH(NOLOCK) WHERE ID = @ID
AND Renglon = @Renglon
AND RenglonSub = @RenglonSub
IF @Establecimiento IN (NULL,'') SELECT @ok = 25480 ELSE
IF @PuntoEmision IN (NULL,'') SELECT @ok = 25481 ELSE
IF @AutorizacionSRI IN (NULL,'') SELECT @ok = 25483 ELSE
IF @VigenteA IN (NULL,'')SELECT @ok = 25484
IF @OK IS NOT NULL RETURN
END
IF @Modulo = 'VTAS'
BEGIN
SELECT @Establecimiento = Establecimiento,
@PuntoEmision = PuntoEmision,
@SecuencialSRI = SecuencialSRI,
@AutorizacionSRI = AutorizacionSRI,
@VigenteA = VigenteA
FROM VentaD
WITH(NOLOCK) WHERE ID = @ID
AND Renglon = @Renglon
AND RenglonSub = @RenglonSub
IF @Establecimiento IN (NULL,'') AND @Ok IS NULL SELECT @Ok = 25480 ELSE
IF @PuntoEmision IN (NULL,'') AND @Ok IS NULL SELECT @Ok = 25481 ELSE
IF @AutorizacionSRI IN (NULL,'') AND @Ok IS NULL SELECT @ok = 25483 ELSE
IF @VigenteA IN (NULL,'') AND @Ok IS NULL SELECT @ok = 25484
IF @OK IS NOT NULL RETURN
END ELSE
IF @Modulo IN ('COMS')
BEGIN
SELECT @SustentoComprobante = SustentoComprobante,
@TipoComprobante = TipoComprobante,
@Establecimiento = Establecimiento,
@PuntoEmision = PuntoEmision
FROM CompraD
WITH(NOLOCK) WHERE ID = @ID
AND Renglon = @Renglon
IF @SustentoComprobante IN (NULL,'') AND @Ok IS NULL SELECT @Ok = 25485 ELSE
IF @TipoComprobante IN (NULL,'') AND @Ok IS NULL SELECT @Ok = 25486 ELSE
IF @Establecimiento IN (NULL,'') AND @Ok IS NULL SELECT @Ok = 25480 ELSE
IF @PuntoEmision IN (NULL,'') AND @Ok IS NULL SELECT @Ok = 25481
END ELSE
BEGIN
SELECT @SustentoComprobante = SustentoComprobante,
@TipoComprobante = TipoComprobante,
@Establecimiento = Establecimiento,
@PuntoEmision = PuntoEmision
FROM GastoD
WITH(NOLOCK) WHERE ID = @ID
AND Renglon = @Renglon
IF @SustentoComprobante IN (NULL,'') AND @Ok IS NULL SELECT @Ok = 25485 ELSE
IF @TipoComprobante IN (NULL,'') AND @Ok IS NULL SELECT @Ok = 25486 ELSE
IF @Establecimiento IN (NULL,'') AND @Ok IS NULL SELECT @Ok = 25480 ELSE
IF @PuntoEmision IN (NULL,'') AND @Ok IS NULL SELECT @Ok = 25481
END
IF @Modulo = 'VTAS' AND NOT EXISTS(SELECT TOP 1 * FROM EcuadorAutorizacion WHERE Modulo = @Modulo AND Mov = @Mov AND Empresa = @Empresa AND ISNULL(Sucursal,@Sucursal) = @Sucursal AND RTRIM(ISNULL(Serie,'')) = RTRIM(ISNULL(@Serie,'')) AND @Consecutivo BETWEEN ISNULL(FolioD,@Consecutivo) AND ISNULL(FolioA,@Consecutivo) AND Vigencia >= @FechaRegistro AND Autorizacion = @AutorizacionSRI ORDER BY Vigencia DESC) SELECT @Ok = 31010, @OkRef = 'Error en la Aprobaci�n del Anexo Transaccional. (' +  RTRIM(@Articulo) + ')'
IF @OK IS NULL
BEGIN
IF @Modulo = 'VTAS'
BEGIN
SELECT @LongitudSecuencialSRI = LongitudSecuencialSRI FROM Empresa WHERE Empresa = @Empresa
EXEC spLlenarCeros @MovID, @LongitudSecuencialSRI, @Secuencial OUTPUT
END
END
SET @SQL = 'UPDATE ' + RTRIM(@Tabla) + ' SET TipoIdentificacion  = ' + CHAR(39) + ISNULL(RTRIM(@TipoRegistro),'') + CHAR(39) + ', SecuencialSRI = ' + CHAR(39) + ISNULL(RTRIM(@Secuencial),'') + CHAR(39) + ' WHERE ID = ' + RTRIM(CONVERT(varchar,@ID))+ ' AND Renglon = ' + RTRIM(CONVERT(varchar,@Renglon)) + ' AND RenglonSub = ' + RTRIM(CONVERT(varchar,@RenglonSub))
IF @Ok IS NULL
BEGIN
EXEC sp_ExecuteSql @SQL
IF @@ERROR <> 0 SET @Ok = 1
END
FETCH NEXT FROM crDetalle  INTO @AutorizacionSRI, @Articulo, @Renglon, @RenglonSub
END
CLOSE crDetalle
DEALLOCATE crDetalle
END
END
END

