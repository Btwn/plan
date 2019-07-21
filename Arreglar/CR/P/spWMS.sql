SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMS
@Modulo				varchar(5),
@ID				    int,
@Accion				varchar(20),
@Empresa			varchar(5),
@Sucursal			int,
@Usuario			varchar(10),
@Mov				varchar(20),
@MovID				varchar(20),
@MovTipo			varchar(20),
@Almacen			varchar(10),
@FechaEmision		datetime,
@Proyecto	     	varchar(50),
@Ok               	int			OUTPUT,
@OkRef            	varchar(255)OUTPUT

AS BEGIN
DECLARE
@ModuloDestino			varchar(5),
@MovDestino				varchar(20),
@ModuloOrigen			varchar(20),
@Estatus				varchar(20),
@EstatusEntarimado		varchar(20),
@SubClave				varchar(20),
@ArtTipo VARCHAR(20),
@CostoPromedio MONEY,
@SucursalAlmacen INT,
@ArtMoneda CHAR(10),
@ArtTipoCambio FLOAT,
@Articulo VARCHAR(20),
@SubCuenta VARCHAR(50),
@AfectarAlmacen VARCHAR(10),
@AfectarAlmacenDestino VARCHAR(10),
@EsCargo BIT,
@CostoInvTotal MONEY,
@AfectarCantidad FLOAT,
@Factor FLOAT,
@Ejercicio INT,
@Periodo INT,
@AplicaMov VARCHAR(20),
@AplicaMovID VARCHAR(20),
@Renglon FLOAT,
@RenglonID INT,
@RenglonSub INT,
@Tarima VARCHAR(20),
@SerieLote VARCHAR(50)
SELECT @SubClave = SubClave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov AND Clave = @MovTipo
IF @Modulo = 'VTAS'
SELECT @Estatus = Estatus FROM Venta WHERE ID = @ID
ELSE
IF @Modulo = 'COMS'
SELECT @Estatus = Estatus FROM Compra WHERE ID = @ID
ELSE
IF @Modulo = 'INV'
SELECT @Estatus = Estatus FROM Inv WHERE ID = @ID
ELSE
IF @Modulo = 'TMA'
SELECT @Estatus = Estatus FROM TMA WHERE ID = @ID
IF @Modulo = 'PROD'
SELECT @Estatus = Estatus FROM Prod WHERE ID = @ID
IF @Modulo = 'TMA' SELECT @Modulo = 'WMS'
IF @ModuloDestino = 'TMA' SELECT @ModuloDestino = 'WMS'
IF EXISTS (SELECT TOP 1 * FROM AlmSugerirSurtidoTarima WHERE Almacen = @Almacen AND Modulo = @Modulo AND Mov = @Mov)
SELECT @ModuloDestino = ModuloDestino, @MovDestino = MovDestino, @EstatusEntarimado = Estatus FROM AlmSugerirSurtidoTarima WHERE Almacen = @Almacen AND Modulo = @Modulo AND Mov = @Mov
IF @Modulo = 'WMS' SELECT @Modulo = 'TMA'
IF @ModuloDestino = 'WMS' SELECT @ModuloDestino = 'TMA'
IF @MovTipo = 'INV.T'
SELECT @SubClave = SubClave FROM MovTipo WHERE Modulo=@Modulo AND Mov=@Mov  
IF (SELECT Clave FROM MovTipo WHERE Modulo = @ModuloDestino AND Mov = @MovDestino) IN ('INV.SOL') AND @EstatusEntarimado = @Estatus OR
(SELECT Clave FROM MovTipo WHERE Modulo = @ModuloDestino AND Mov = @MovDestino) IN ('INV.SOL') AND @Accion = 'CANCELAR' OR
@MovTipo = 'INV.T' AND @SubClave = 'INV.TMA' AND @Modulo = 'INV' AND @Accion <> 'CANCELAR'
BEGIN
IF @Ok IS NULL
BEGIN
EXEC spGenerarOrdenEntarimado @Modulo, @ID, @Accion, @Empresa, @Sucursal, @Usuario, @Mov, @MovID, @MovTipo, @Almacen, @Ok OUTPUT, @OkRef OUTPUT
END
END
IF (SELECT LEFT(Clave,3) FROM MovTipo WHERE Modulo = @ModuloDestino AND Mov = @MovDestino) = 'TMA' OR (SELECT Clave FROM MovTipo WHERE Modulo = @ModuloDestino AND Mov = @MovDestino) = 'INV.EI' 
EXEC spGenerarOrdenTarimaAcomodo 'RECIBO', @Modulo, @ID, @Accion, @Empresa, @Sucursal, @Usuario, @Mov, @MovID, @MovTipo, @FechaEmision, @Proyecto, @Almacen, @Ok OUTPUT, @OkRef OUTPUT, @GenerarOrden = 1
IF (SELECT Clave FROM MovTipo WHERE Modulo = @ModuloDestino AND Mov = @MovDestino) IN ('INV.S') AND (SELECT SubClave FROM MovTipo WHERE Modulo = @ModuloDestino AND Mov = @MovDestino) = 'INV.SCHEP'
EXEC spGenerarConsumoChep @Modulo, @ID, @Accion, @Empresa, @Sucursal, @Usuario, @Mov, @MovID, @MovTipo, @Almacen, @MovDestino, @Ok OUTPUT, @OkRef OUTPUT
RETURN
END

