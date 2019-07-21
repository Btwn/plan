SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spArtQuiebreProcesar
@Estacion	int,
@Empresa	char(5),
@Usuario        char(10),
@Sucursal       int,
@Periodo        int,
@Ejercicio      int,
@Cliente        char(10),
@Almacen        char(10)

AS BEGIN
DECLARE
@CfgMultiUnidades		bit,
@CfgMultiUnidadesNivel	char(20),
@CfgCompraCostoSugerido  	char(20),
@a                          int,
@Ok                         int,
@OkRef                      varchar(255),
@Moneda		        char(10),
@TipoCambio		        float,
@ID                         int,
@Mov                        varchar(20),
@MovID                      varchar(20),
@Fecha                      datetime,
@Renglon                    float,
@RenglonID                  int,
@RenglonTipo                char(1),
@UltFamilia                 varchar(50),
@Familia                    varchar(50),
@Articulo                   char(20),
@SubCuenta                  varchar(50),
@Proveedor                  char(10),
@Precio                     float,
@Costo                      float,
@VentaAjustada              float,
@VentaAjustadaFam           float,
@Cantidad                   float,
@CantidadInventario         float,
@PresupuestoFam             float,
@VentaNetaFam               float,
@Unidad                     varchar(50),
@FechaRegistro		datetime,
@Impuesto1                  float,
@Impuesto2                  float,
@Impuesto3                  money,
@ArtTipo                    varchar(20),
@ListaPrecios               varchar(50),
@Mensaje                    varchar(255)
SELECT @a = 0, @Ok = NULL, @OkRef = NULL, @UltFamilia = NULL,
@ListaPrecios = '(Precio Lista)',
@SubCuenta = NULL,
@Cliente = NULLIF(NULLIF(RTRIM(@Cliente), '0'), ''),
@FechaRegistro = GETDATE()
SELECT @Mov = VentaPresupuesto FROM EmpresaCfgMov WHERE Empresa = @Empresa
SELECT @CfgCompraCostoSugerido = cfg.CompraCostoSugerido,
@Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg, Mon m
WHERE cfg.Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
SELECT @CfgMultiUnidades       = MultiUnidades,
@CfgMultiUnidadesNivel  = ISNULL(UPPER(NivelFactorMultiUnidad), 'UNIDAD')
FROM EmpresaCfg2
WHERE Empresa = @Empresa
EXEC spIntToDateTime 1, @Periodo, @Ejercicio, @Fecha OUTPUT
DELETE CtePresupuesto WHERE Ejercicio = @Ejercicio AND Periodo = @Periodo
BEGIN TRANSACTION
WHILE @a<12 AND @Ok IS NULL
BEGIN
SELECT @ID = NULL, @Renglon = 0.0, @RenglonID = 0
SELECT @ID = ID FROM Venta WHERE Empresa = @Empresa AND Mov = @Mov AND FechaEmision = @Fecha AND Estatus <> 'CANCELADO'
IF @ID IS NOT NULL
BEGIN
EXEC spDesAfectarPresupuesto 'VTAS', @Mov, @ID
DELETE VentaD WHERE ID = @ID
END ELSE
BEGIN
INSERT Venta (Sucursal,  Empresa,  Mov,  FechaEmision, Moneda,  TipoCambio,  Almacen,  Cliente,  Usuario,  FechaRequerida, ListaPreciosEsp, Estatus)
VALUES (@Sucursal, @Empresa, @Mov, @Fecha,       @Moneda, @TipoCambio, @Almacen, @Cliente, @Usuario, @Fecha,         @ListaPrecios,   'SINAFECTAR')
SELECT @ID = SCOPE_IDENTITY()
END
DECLARE crArtQuiebre CURSOR FOR
SELECT aq.Familia, aq.Articulo, aq.VentaAjustada, a.Unidad, a.Impuesto1, a.Impuesto2, a.Impuesto3, a.Proveedor, a.Tipo
FROM ArtQuiebre aq, Art a
WHERE NULLIF(aq.VentaAjustada, 0) IS NOT NULL AND a.Articulo = aq.Articulo
ORDER BY aq.Familia, aq.Articulo
OPEN crArtQuiebre
FETCH NEXT FROM crArtQuiebre INTO @Familia, @Articulo, @VentaAjustada, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Proveedor, @ArtTipo
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Familia <> @UltFamilia
BEGIN
SELECT @VentaAjustadaFam = SUM(VentaAjustada) FROM ArtQuiebre WHERE Familia = @Familia
SELECT @VentaNetaFam = SUM(VentaNeta) FROM CteQuiebre WHERE Familia = @Familia
SELECT @PresupuestoFam = Cantidad FROM ArtFamPresupuesto WHERE Familia = @Familia AND Ejercicio = YEAR(@Fecha) AND Periodo = MONTH(@Fecha)
IF @a=0 EXEC spCtePresupuesto @Periodo, @Ejercicio, @Familia, @VentaNetaFam, @PresupuestoFam, @Moneda
SELECT @UltFamilia = @Familia
END
SELECT @Cantidad = (@VentaAjustada / @VentaAjustadaFam) * @PresupuestoFam
IF ISNULL(@Cantidad, 0.0) > 0.0
BEGIN
EXEC xpCantidadInventario @Articulo, @SubCuenta, @Unidad, @CfgMultiUnidades, @CfgMultiUnidadesNivel, @Cantidad, @CantidadInventario OUTPUT
EXEC spVerCosto @Sucursal, @Empresa, @Proveedor, @Articulo, @SubCuenta, @Unidad, @CfgCompraCostoSugerido, @Moneda, @TipoCambio, @Costo OUTPUT, 0
EXEC spRenglonTipo @ArtTipo, @SubCuenta, @RenglonTipo OUTPUT
SELECT @Renglon = @Renglon + 2048.0, @RenglonID = @RenglonID + 1
EXEC spPrecioEsp @ListaPrecios, @Moneda, @Articulo, @SubCuenta, @Precio OUTPUT
INSERT VentaD (ID,  Renglon,  RenglonSub, RenglonID,  RenglonTipo,  Impuesto1,  Impuesto2,  Impuesto3,  Almacen,  Articulo,  SubCuenta,  Cantidad,  Unidad,  CantidadInventario,  Costo,  FechaRequerida,  Precio)
VALUES (@ID, @Renglon, 0,          @RenglonID, @RenglonTipo, @Impuesto1, @Impuesto2, @Impuesto3, @Almacen, @Articulo, @SubCuenta, @Cantidad, @Unidad, @CantidadInventario, @Costo, @Fecha,          @Precio)
END
END
FETCH NEXT FROM crArtQuiebre INTO @Familia, @Articulo, @VentaAjustada, @Unidad, @Impuesto1, @Impuesto2, @Impuesto3, @Proveedor, @ArtTipo
END
CLOSE crArtQuiebre
DEALLOCATE crArtQuiebre
IF @ID IS NOT NULL
BEGIN
IF EXISTS(SELECT * FROM VentaD WHERE ID = @ID)
EXEC spInv @ID, 'VTAS', 'AFECTAR', 'TODO', @FechaRegistro, @Mov, @Usuario, 1, 0, NULL,
@Mov, @MovID, NULL, NULL,
@Ok OUTPUT, @OkRef OUTPUT, NULL
ELSE
DELETE Venta WHERE ID = @ID
END
SELECT @a = @a + 1, @Fecha = DATEADD(month, 1, @Fecha)
END
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
SELECT @Mensaje = 'Proceso Concluido con Exito.'
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT @Mensaje = Descripcion+' '+RTRIM(ISNULL(@OkRef, '')) FROM MensajeLista WHERE Mensaje = @Ok
END
SELECT @Mensaje
RETURN
END

