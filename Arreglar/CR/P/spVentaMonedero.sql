SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVentaMonedero
@Empresa		char(5),
@Modulo			char(10),
@ID			int,
@Mov			char(20),
@MovID			varchar(20),
@MovTipo		char(20),
@Accion			char(20),
@FechaEmision		datetime,
@Ejercicio		int,
@Periodo		int,
@Usuario		char(10),
@Sucursal		int,
@MovMoneda		char(10),
@MovTipoCambio		float,
@Ok 			int 		OUTPUT,
@OkRef 			varchar(255)	OUTPUT,
@LDI                    bit = 0

AS
BEGIN
DECLARE
@OFER				bit,
@CfgVentaPuntosArtCat		bit,
@Renglon			float,
@Articulo			varchar(20),
@Categoria			varchar(50),
@Precio				money,
@Impuesto1			float,
@DescuentoGlobal		float,
@DescuentoLinea			float,
@Porcentaje			float,
@Continuar			bit,
@VentaPreciosImpuestoIncluido 	bit,
@Factor				int,
@Cargo				money,
@EsCancelacion			bit,
@TarjetaMoneda			char(10),
@TarjetaTipoCambio		float,
@Tarjeta			char(20),
@Total				money,
@Cantidad			float, 
@Importe                        float ,
@TotalCargo			money  ,
@OrigenTipo          varchar(10)   
IF @Modulo = 'VTAS'
SELECT @OrigenTipo = NULLIF(OrigenTipo,'') FROM Venta WHERE ID = @ID
SELECT @Total = 0, @Cargo = 0, @Porcentaje = 0
SELECT @OFER = OFER
FROM EmpresaGral
WHERE Empresa = @Empresa
SELECT @CfgVentaPuntosArtCat = ISNULL(VentaPuntosArtCat, 0)
FROM EmpresaCfg2
WHERE Empresa = @Empresa
SELECT Top 1 @Tarjeta = Serie
FROM TarjetaSerieMov
WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID
IF NOT Exists(SELECT * FROM ValeSerie WHERE Serie = @Tarjeta AND TipoTarjeta = 1)
SELECT @OK = 30097, @Continuar = 0
ELSE
SELECT @Continuar = 1
IF @Accion = 'CANCELAR'
SELECT @EsCancelacion = 1, @Factor = -1
ELSE
SELECT @EsCancelacion = 0, @Factor = 1
SELECT @VentaPreciosImpuestoIncluido = ISNULL(VentaPreciosImpuestoIncluido,0)
FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @TarjetaMoneda = Moneda FROM ValeSerie WHERE Serie = @Tarjeta AND TipoTarjeta = 1
IF @TarjetaMoneda <> @MovMoneda AND @OrigenTipo NOT IN ('POS') 
BEGIN
SELECT @Ok = 36161
END
IF @Continuar = 1 AND @Accion IN('AFECTAR', 'RESERVAR', 'RESERVARPARCIAL') AND @CfgVentaPuntosArtCat = 1 AND @OFER = 0 
BEGIN
EXEC xpVentaMonederoContinuar @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @Accion, @FechaEmision,
@Ejercicio, @Periodo, @Usuario, @Sucursal, @MovMoneda, @MovTipoCambio,
@Continuar OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Continuar = 1
BEGIN
DECLARE ctCteFrecuente CURSOR FOR
SELECT d.Renglon, d.Articulo, d.Precio, ISNULL(d.Impuesto1,0), ISNULL(v.DescuentoGlobal,0), ISNULL(d.DescuentoLinea,0), NULLIF(RTRIM(a.Categoria), ''), ISNULL(f.Porcentaje,0), d.Cantidad 
FROM Venta v, VentaD d, Art a, ArtCatTarjetaPuntos f
WHERE v.ID = d.ID
AND d.Articulo = a.Articulo
AND a.Categoria = f.Categoria
AND @FechaEmision BETWEEN f.FechaD AND f.FechaA
AND v.ID = @ID
AND ISNULL(f.Porcentaje,0) > 0
OPEN ctCteFrecuente
FETCH NEXT FROM ctCteFrecuente INTO @Renglon, @Articulo, @Precio, @Impuesto1, @DescuentoGlobal, @DescuentoLinea, @Categoria, @Porcentaje, @Cantidad 
WHILE @@FETCH_STATUS = 0
BEGIN
IF @VentaPreciosImpuestoIncluido = 0
SELECT @Cargo = ROUND(((@Precio*(1.0+(@Impuesto1/100.0)))*(1-(@DescuentoLinea/100.0))*(1-(@DescuentoGlobal/100) ) ),2)
ELSE
SELECT @Cargo = ROUND(((@Precio)*(1-(@DescuentoLinea/100.0))*(1-(@DescuentoGlobal/100) ) ),2)
SELECT @Cargo = @Cantidad * (ISNULL(@Cargo,0)*(@Porcentaje/100)) 
IF @Cargo > 0
BEGIN
UPDATE VentaD SET Puntos = dbo.fnImporteMonTarjeta(@Cargo, @MovMoneda, @MovTipoCambio, @TarjetaMoneda,NULL, @Sucursal)   WHERE ID = @ID AND Renglon = @Renglon
END
ELSE
UPDATE VentaD SET Puntos = dbo.fnImporteMonTarjeta(Puntos, @MovMoneda, @MovTipoCambio, @TarjetaMoneda,NULL, @Sucursal)   WHERE ID = @ID AND Renglon = @Renglon
FETCH NEXT FROM ctCteFrecuente INTO @Renglon, @Articulo, @Precio, @Impuesto1, @DescuentoGlobal, @DescuentoLinea, @Categoria, @Porcentaje, @Cantidad 
END
CLOSE ctCteFrecuente
DEALLOCATE ctCteFrecuente
END
END
IF @Continuar = 1 OR @Accion = 'CANCELAR'
BEGIN
SELECT @Total = SUM(Puntos) FROM VentaD  WHERE ID = @ID AND  Puntos > 0
SELECT @TotalCargo = SUM(Puntos)*-1 FROM VentaD  WHERE ID = @ID AND  Puntos < 0
SELECT @Importe = (@Total*@Factor)
IF ISNULL(@Total, 0) > 0 AND @Ok IS NULL
INSERT INTO AuxiliarValeSerie (Sucursal,  Mov,  MovID,  Modulo,  ModuloID, Serie,    Ejercicio,  Periodo,  Fecha,          Cargo,                             Abono, PorConciliar, EsCancelacion)
VALUES (                   @Sucursal, @Mov, @MovID, @Modulo, @ID,      @Tarjeta, @Ejercicio, @Periodo, @FechaEmision, (@Total*@Factor)/**@FactorMoneda*/, NULL,  0,            @EsCancelacion)
IF ISNULL(@TotalCargo, 0) >0
BEGIN
IF dbo.fnVerSaldoVale(@Tarjeta)< @TotalCargo
SELECT @Ok = 30096, @OkRef = 'Tarjeta ' + @Tarjeta
IF @Ok IS NULL
INSERT INTO AuxiliarValeSerie (
Sucursal, Mov, MovID, Modulo, ModuloID, Serie, Ejercicio, Periodo, Fecha, Cargo, Abono, PorConciliar, EsCancelacion)
VALUES (@Sucursal, @Mov, @MovID, @Modulo, @ID, @Tarjeta, @Ejercicio, @Periodo, @FechaEmision,NULL ,/**@FactorMoneda*/ (@TotalCargo*@Factor), 0, @EsCancelacion)
END
IF @LDI = 1 AND ISNULL(@Total, 0) > 0 AND @Ok IS NULL AND @OrigenTipo NOT IN ('POS')
EXEC spLDIVentaGenerarAbonoVale @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @Accion, @FechaEmision, @Ejercicio, @Periodo, @Usuario, @Sucursal, @MovMoneda, @MovTipoCambio, @Importe, @Ok OUTPUT, @OkRef OUTPUT
END
RETURN
END

