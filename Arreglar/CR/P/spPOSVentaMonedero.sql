SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSVentaMonedero
@Empresa			char(5),
@ID					varchar(36),
@Accion				char(20),
@FechaEmision		datetime,
@Usuario			char(10),
@Sucursal			int,
@MovMoneda			char(10),
@MovTipoCambio		float,
@Tarjeta			varchar(20),
@Ok 				int 			OUTPUT,
@OkRef 				varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@OFER							bit,
@CfgVentaPuntosArtCat			bit,
@Renglon						float,
@RenglonTarjeta					float,
@RenglonID						int,
@RenglonTipo					varchar(1),
@Articulo						varchar(20),
@Categoria						varchar(50),
@Precio							money,
@Impuesto1						float,
@DescuentoGlobal				float,
@DescuentoLinea					float,
@Porcentaje						float,
@Continuar						bit,
@VentaPreciosImpuestoIncluido 	bit,
@Factor							int,
@Cargo							money,
@EsCancelacion					bit,
@TarjetaMoneda					char(10),
@TarjetaTipoCambio				float,
@FactorMoneda					float,
@Total							money,
@TotalCargo						money,
@CantidadVenta                  float,
@Servicio                       varchar(20),
@ArtTarjeta                     varchar(20),
@Importe                        float,
@OKRefLDI                       varchar(500),
@MonederoLDI                    bit,
@PrecioImpuestoInc              float,
@MovClave                       varchar(20),
@MovSubClave                    varchar(20)
SELECT @MovClave = m.Clave, @MovSubClave = m.SubClave
FROM MovTipo m JOIN POSL p ON m.Mov = p.Mov AND m.Modulo = 'POS'
WHERE  p.ID = @ID
SELECT @Total = 0, @Cargo = 0, @Porcentaje = 0
SELECT @OFER = OFER
FROM EmpresaGral
WHERE Empresa = @Empresa
SELECT @MonederoLDI = ISNULL(MonederoLDI,0)
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @CfgVentaPuntosArtCat = ISNULL(VentaPuntosArtCat, 0)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT  @ArtTarjeta = ec.CxcArticuloTarjetasDef
FROM EmpresaCfg ec
WHERE ec.Empresa = @Empresa
IF NOT EXISTS(SELECT * FROM POSValeSerie WHERE Serie = @Tarjeta AND Estatus = 'CIRCULACION')
SELECT @OK = 30097, @Continuar = 0
ELSE
SELECT @Continuar = 1
IF @Accion = 'CANCELAR'
SELECT @EsCancelacion = 1, @Factor = -1
ELSE
SELECT @EsCancelacion = 0, @Factor = 1
SELECT @VentaPreciosImpuestoIncluido = ISNULL(VentaPreciosImpuestoIncluido,0)
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @TarjetaMoneda = Moneda
FROM POSValeSerie
WHERE Serie = @Tarjeta AND Estatus = 'CIRCULACION'
IF @Continuar = 1 AND @Accion = 'AFECTAR'
BEGIN
IF @Continuar = 1
BEGIN
DECLARE ctCteFrecuente CURSOR FOR
SELECT d.Renglon, d.Articulo, d.Precio, ISNULL(d.Impuesto1,0), CASE WHEN ISNULL(d.AplicaDescGlobal, 1) = 1
THEN ISNULL(v.DescuentoGlobal,0.0)
ELSE 0
END, ISNULL(d.DescuentoLinea,0),
NULLIF(RTRIM(a.Categoria), ''), ISNULL(f.Porcentaje,0), d.PrecioImpuestoInc
FROM POSL v, POSLVenta d, Art a, ArtCatTarjetaPuntos f
WHERE v.ID = d.ID
AND d.Articulo = a.Articulo
AND a.Categoria = f.Categoria
AND @FechaEmision BETWEEN f.FechaD AND f.FechaA
AND v.ID = @ID
AND ISNULL(f.Porcentaje,0) > 0
OPEN ctCteFrecuente
FETCH NEXT FROM ctCteFrecuente INTO @Renglon, @Articulo, @Precio, @Impuesto1, @DescuentoGlobal, @DescuentoLinea,
@Categoria, @Porcentaje, @PrecioImpuestoInc
WHILE @@FETCH_STATUS = 0
BEGIN
IF @CfgVentaPuntosArtCat = 1 AND @OFER = 0 AND @Ok IS NULL
BEGIN
IF @VentaPreciosImpuestoIncluido = 0
SELECT @Cargo = ROUND(((@PrecioImpuestoInc)*(1-(@DescuentoLinea/100.0))*(1-(@DescuentoGlobal/100) ) ),2)
ELSE
SELECT @Cargo = ROUND(((@Precio)*(1-(@DescuentoLinea/100.0))*(1-(@DescuentoGlobal/100) ) ),2)
SELECT @Cargo = ISNULL(@Cargo,0)*(@Porcentaje/100)
IF @Cargo > 0.0
UPDATE POSLVenta SET Puntos = dbo.fnImporteMonTarjeta(@Cargo, @MovMoneda, @MovTipoCambio, @TarjetaMoneda,NULL, @Sucursal )
WHERE ID = @ID AND Renglon = @Renglon
END
FETCH NEXT FROM ctCteFrecuente INTO @Renglon, @Articulo, @Precio, @Impuesto1, @DescuentoGlobal, @DescuentoLinea,
@Categoria, @Porcentaje, @PrecioImpuestoInc
END
CLOSE ctCteFrecuente
DEALLOCATE ctCteFrecuente
END
SELECT @CantidadVenta = SUM(Cantidad)
FROM POSLVenta
WHERE ID = @ID
SELECT @Total = SUM(Puntos)
FROM POSLVenta
WHERE ID = @ID AND  Puntos > 0
SELECT @TotalCargo = SUM(Puntos)*-1
FROM POSLVenta
WHERE ID = @ID AND  Puntos < 0
IF @Tarjeta IS NOT NULL AND @Ok IS NULL AND @MonederoLDI = 1
EXEC spPOSLDIValidarTarjeta  'MON CONSULTA',@ID, @Tarjeta,@Empresa,@Usuario,@Sucursal,@Importe OUTPUT, @Ok OUTPUT, @OkRef  OUTPUT, @OKRefLDI OUTPUT
IF @OKRefLDI = 'Tarjeta no registrada' AND @MonederoLDI = 1
BEGIN
SELECT @Ok = NULL,@OkRef = NULL
EXEC spPOSLDI 'MON ALTA NUEVO', @ID, @Tarjeta, @Empresa, @Usuario, @Sucursal, NULL, NULL, 1, NULL, @Ok OUTPUT, @OkRef  OUTPUT, 'POS'
IF (SELECT Estatus FROM POSValeSerie WHERE Serie = @Tarjeta)='DISPONIBLE' AND @Ok IS NULL
BEGIN
SELECT @Renglon = MAX(Renglon)+ 2048.0, @RenglonID = MAX(RenglonID)+1
FROM POSLVenta
WHERE ID = @ID
SELECT @RenglonTipo = dbo.fnRenglonTipo('SERIE')
IF NOT EXISTS(SELECT Articulo FROM POSLVenta WHERE ID = @ID AND Articulo = @ArtTarjeta)AND @Ok IS NULL
INSERT POSLVenta(
ID,  Renglon, RenglonID, RenglonTipo, Cantidad, Articulo, Precio, CantidadInventario)
SELECT
@ID, @Renglon, @RenglonID, @RenglonTipo, 1, @ArtTarjeta, 0.0, 1
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL AND NOT EXISTS(SELECT * FROM POSLSerieLote WHERE ID = @ID AND  SerieLote = @Tarjeta)AND @Ok IS NULL
BEGIN
INSERT POSLSerieLote (
ID, RenglonID, Articulo, SubCuenta, SerieLote)
VALUES (
@ID, @RenglonID, @ArtTarjeta, '', @Tarjeta)
IF @@ERROR <> 0
SET @Ok = 1
END
IF  @Ok IS NULL
UPDATE POSValeSerie SET  Estatus = 'CIRCULACION' WHERE Serie = @Tarjeta
END
END
IF ISNULL(@Importe,0.0)< ISNULL(@TotalCargo,0.0)
SELECT @Ok = 30096, @OkRef = 'Tarjeta ' + @Tarjeta
IF @MovClave = 'POS.N' AND @MovSubClave= 'POS.DREF'
SELECT @CantidadVenta = ABS(@CantidadVenta)
IF ISNULL(@TotalCargo, 0.0) > 0.0 AND @CantidadVenta >0.0 AND  @Ok IS NULL AND @MonederoLDI = 1
EXEC spPOSLDI 'MON CARGO', @ID, @Tarjeta, @Empresa, @Usuario, @Sucursal, NULL, @TotalCargo, 1, null, @Ok OUTPUT, @OkRef OUTPUT, 'POS'
IF ISNULL(@Total, 0.0) > 0.0 AND @CantidadVenta <0.0 AND  @Ok IS NULL AND @MonederoLDI = 1
EXEC spPOSLDI 'MON CARGO', @ID, @Tarjeta, @Empresa, @Usuario, @Sucursal, NULL, @Total, 1, null, @Ok OUTPUT, @OkRef OUTPUT, 'POS'
IF ISNULL(@TotalCargo, 0.0) > 0.0 AND @CantidadVenta <0.0 AND  @Ok IS NULL AND @MonederoLDI = 1
EXEC spPOSLDI 'MON ABONO', @ID, @Tarjeta, @Empresa, @Usuario, @Sucursal, NULL, @TotalCargo, 1, null, @Ok OUTPUT, @OkRef OUTPUT, 'POS'
END
IF  @Accion = 'CANCELAR'
BEGIN
SELECT @Total = SUM(Puntos) FROM POSLVenta WHERE ID = @ID
IF ISNULL(@Total, 0) > 0    AND @MonederoLDI = 1
EXEC spPOSLDI 'MON CARGO', @ID, @Tarjeta,  @Empresa, @Usuario, @Sucursal, NULL, @Total, 1, NULL, @Ok OUTPUT, @OkRef OUTPUT,'POS'
END
RETURN
END

