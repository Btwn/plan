SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spModificarCapas
@Sucursal			int,
@Accion			char(20),
@Modulo			char(5),
@MovTipo			char(20),
@Mov		     		char(20),
@MovID	     		varchar(20),
@Fecha			datetime,
@CfgTipoCosteo    		char(20),
@Sistema			char(1),
@Empresa          		char(5),
@Articulo	     		char(20),
@SubCuenta			varchar(50),
@Cantidad	     		float,
@EsTransferenciaCosto 	bit,
@Costo	     		float 	    OUTPUT,
@Ok               		int         OUTPUT,
@CostoEspecifico 		bit 	= 0,
@AjusteCosteo		float 	= NULL OUTPUT,
@Almacen		varchar(10)	= NULL,
@ID			int		= NULL,
@Renglon		float		= NULL,
@RenglonSub		int		= NULL

AS BEGIN
DECLARE
@Suma           float,
@Requiere	    float,
@Obtenido       float,
@Existencia     float,
@CapaModulo     char(5),
@CapaMov	    char(20),
@CapaMovID	    varchar(20),
@CapaFecha	    datetime,
@CapaCosto      float,
@NuevoCosto	    float,
@Promedio       float,
@CostoAnterior  float,
@EsCargo	    bit,
@InvCapaID	    int,
@InvCapaIDN	    int
IF @CostoEspecifico = 1 SELECT @CostoAnterior = @Costo
IF @MovTipo IN ('COMS.B', 'COMS.CA', 'COMS.GX')
BEGIN
IF @CfgTipoCosteo='PEPS'
DECLARE crCapas CURSOR FOR SELECT ID, ISNULL(Existencia, 0.0), ISNULL(Costo, 0.0), Fecha, Modulo, Mov, MovID FROM InvCapa WHERE Sucursal = @Sucursal AND Sistema = @Sistema AND Empresa  = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND ISNULL(Existencia, 0.0) > 0.0 AND Activa = 1 ORDER BY Fecha ASC, ID ASC
ELSE
DECLARE crCapas CURSOR FOR SELECT ID, ISNULL(Existencia, 0.0), ISNULL(Costo, 0.0), Fecha, Modulo, Mov, MovID FROM InvCapa WHERE Sucursal = @Sucursal AND Sistema = @Sistema AND Empresa  = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND ISNULL(Existencia, 0.0) > 0.0 AND Activa = 1 ORDER BY Fecha DESC, ID DESC
END ELSE
/*IF @CostoEspecifico = 1  ** en lugar de buscar un costo especifico hay que ajustarlo
BEGIN
IF @CfgTipoCosteo='PEPS' OR @EsTransferenciaCosto = 1
DECLARE crCapas CURSOR FOR SELECT ISNULL(Existencia, 0.0), ISNULL(Costo, 0.0), Fecha, Modulo, Mov, MovID FROM InvCapa WHERE Sucursal = @Sucursal AND Sistema = @Sistema AND Empresa  = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Costo = @Costo AND ISNULL(Existencia, 0.0) > 0.0 AND Activa = 1 ORDER BY Fecha ASC, ID ASC
ELSE
DECLARE crCapas CURSOR FOR SELECT ISNULL(Existencia, 0.0), ISNULL(Costo, 0.0), Fecha, Modulo, Mov, MovID FROM InvCapa WHERE Sucursal = @Sucursal AND Sistema = @Sistema AND Empresa  = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND Costo = @Costo AND ISNULL(Existencia, 0.0) > 0.0 AND Activa = 1 ORDER BY Fecha DESC, ID DESC
END ELSE
JGD 15Febrero2011 Ticket 2976. Se comenta esta parte.
BEGIN
IF @CfgTipoCosteo='PEPS' OR @EsTransferenciaCosto = 1
DECLARE crCapas CURSOR FOR SELECT ID, ISNULL(Existencia, 0.0), ISNULL(Costo, 0.0), Fecha, Modulo, Mov, MovID FROM InvCapa WHERE Sucursal = @Sucursal AND Sistema = @Sistema AND Empresa  = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND ISNULL(Existencia, 0.0) > 0.0 AND Activa = 1 ORDER BY Fecha ASC, ID ASC
ELSE
DECLARE crCapas CURSOR FOR SELECT ID, ISNULL(Existencia, 0.0), ISNULL(Costo, 0.0), Fecha, Modulo, Mov, MovID FROM InvCapa WHERE Sucursal = @Sucursal AND Sistema = @Sistema AND Empresa  = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND ISNULL(Existencia, 0.0) > 0.0 AND Activa = 1 ORDER BY Fecha DESC, ID DESC
END
JGD 15Febrero2011 Ticket 2976. Se valida la Cancelación de una Entrada Diverza ingresada de forma Erronea, la unica condición es que este Movimiento
no tenga modificada la Existencia en InvCapa, es decir, no tenga Movientos de Salida, y de esta manera se Cancela
con respecto al Costo del Movimiento en el cual se esta parado, ignorando el tipo de Costeo PEPS
*/
BEGIN
IF @CfgTipoCosteo='PEPS' OR @EsTransferenciaCosto = 1
BEGIN
IF @CfgTipoCosteo='PEPS' AND @Accion = 'CANCELAR'
BEGIN
IF (SELECT  MAX(ISNULL(Existencia, 0.0)) FROM InvCapa WHERE Sucursal = @Sucursal AND Sistema = @Sistema AND Empresa  = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND ISNULL(Existencia, 0.0) > 0.0 AND Activa = 1 AND Mov = @Mov AND MovID = @MovID) = @Cantidad
DECLARE crCapas CURSOR FOR SELECT ID, ISNULL(Existencia, 0.0), ISNULL(Costo, 0.0), Fecha, Modulo, Mov, MovID FROM InvCapa WHERE Sucursal = @Sucursal AND Sistema = @Sistema AND Empresa  = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND ISNULL(Existencia, 0.0) > 0.0 AND Activa = 1 AND Mov = @Mov AND MovID = @MovID
ELSE
DECLARE crCapas CURSOR FOR SELECT ID, ISNULL(Existencia, 0.0), ISNULL(Costo, 0.0), Fecha, Modulo, Mov, MovID FROM InvCapa WHERE Sucursal = @Sucursal AND Sistema = @Sistema AND Empresa  = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND ISNULL(Existencia, 0.0) > 0.0 AND Activa = 1 ORDER BY Fecha ASC, ID ASC
END
ELSE
DECLARE crCapas CURSOR FOR SELECT ID, ISNULL(Existencia, 0.0), ISNULL(Costo, 0.0), Fecha, Modulo, Mov, MovID FROM InvCapa WHERE Sucursal = @Sucursal AND Sistema = @Sistema AND Empresa  = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND ISNULL(Existencia, 0.0) > 0.0 AND Activa = 1 ORDER BY Fecha ASC, ID ASC
END
ELSE
DECLARE crCapas CURSOR FOR SELECT ID, ISNULL(Existencia, 0.0), ISNULL(Costo, 0.0), Fecha, Modulo, Mov, MovID FROM InvCapa WHERE Sucursal = @Sucursal AND Sistema = @Sistema AND Empresa  = @Empresa AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND ISNULL(Existencia, 0.0) > 0.0 AND Activa = 1 ORDER BY Fecha DESC, ID DESC
END
SELECT @Suma = 0.0, @Promedio = 0.0
OPEN crCapas
FETCH NEXT FROM crCapas INTO @InvCapaID, @Existencia, @CapaCosto, @CapaFecha, @CapaModulo, @CapaMov, @CapaMovID
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @Suma < @Cantidad AND @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Requiere = @Cantidad - @Suma
IF @Requiere < @Existencia
BEGIN  
SELECT @Obtenido = @Requiere
UPDATE InvCapa SET Existencia = Existencia - @Obtenido WHERE CURRENT OF crCapas
END ELSE
BEGIN
SELECT @Obtenido = @Existencia
UPDATE InvCapa SET Activa = 0, Existencia = NULL WHERE CURRENT OF crCapas
END
IF @@ERROR <> 0 SELECT @Ok = 1
INSERT InvCapaAux (
ID,         Fecha,  Modulo,  ModuloID, Renglon,  RenglonSub,  Almacen,  AbonoU)
VALUES (@InvCapaID, @Fecha, @Modulo, @ID,      @Renglon, @RenglonSub, @Almacen, @Obtenido)
IF @MovTipo IN ('COMS.B', 'COMS.CA', 'COMS.GX')
BEGIN
IF @MovTipo = 'COMS.B' SELECT @EsCargo = 0 ELSE SELECT @EsCargo = 1
IF @Accion = 'CANCELAR' IF @EsCargo = 0 SELECT @EsCargo = 1 ELSE SELECT @EsCargo = 0
IF @EsCargo = 1 SELECT @NuevoCosto = @CapaCosto + @Costo ELSE SELECT @NuevoCosto = @CapaCosto - @Costo
INSERT INTO InvCapa (Sucursal,  Sistema,  Empresa,  Articulo,  SubCuenta,  Fecha,      Existencia, Costo,       Modulo,      Mov,      MovID)
VALUES  (@Sucursal, @Sistema, @Empresa, @Articulo, @SubCuenta, @CapaFecha, @Obtenido,  @NuevoCosto, @CapaModulo, @CapaMov, @CapaMovID)
SELECT @InvCapaIDN = SCOPE_IDENTITY()
INSERT InvCapaAux (
ID,          Fecha,  Modulo,  ModuloID, Renglon,  RenglonSub,  Almacen,  CargoU)
VALUES (@InvCapaIDN, @Fecha, @Modulo, @ID,      @Renglon, @RenglonSub, @Almacen, @Obtenido)
END
ELSE
IF @EsTransferenciaCosto = 1
BEGIN
INSERT INTO InvCapa (Sucursal,  Sistema,  Empresa,  Articulo,  SubCuenta,  Fecha,  Existencia, Costo,             Modulo,  Mov,  MovID)
VALUES  (@Sucursal, @Sistema, @Empresa, @Articulo, @SubCuenta, @Fecha, @Obtenido,  @CapaCosto+@Costo, @Modulo, @Mov, @MovID)
SELECT @InvCapaIDN = SCOPE_IDENTITY()
INSERT InvCapaAux (
ID,          Fecha,  Modulo,  ModuloID, Renglon,  RenglonSub,  Almacen,  CargoU)
VALUES (@InvCapaIDN, @Fecha, @Modulo, @ID,      @Renglon, @RenglonSub, @Almacen, @Obtenido)
END ELSE
SELECT @Promedio = ((@Promedio * @Suma) + (@Obtenido * @CapaCosto)) / (@Suma + @Obtenido)
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @Suma = @Suma + @Obtenido
END 
FETCH NEXT FROM crCapas INTO @InvCapaID, @Existencia, @CapaCosto, @CapaFecha, @CapaModulo, @CapaMov, @CapaMovID
IF @@ERROR <> 0 SELECT @Ok = 1
END 
Close crCapas
DEALLOCATE crCapas
IF @EsTransferenciaCosto = 0 SELECT @Costo = @Promedio
IF ROUND(@Suma, 4) < ROUND(@Cantidad, 4) SELECT @Ok = 20110
IF @CostoEspecifico = 1 SELECT @AjusteCosteo = @Costo - @CostoAnterior
RETURN
END

