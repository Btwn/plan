SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovGenerarSinAfectar
@Empresa	char(5),
@Modulo		char(5),
@Usuario	char(10),
@Mov		char(20),
@MovID 		varchar(20),
@GenerarDirecto	bit,
@GenerarMov	char(20),
@ID		int	OUTPUT,
@GenerarID	int	OUTPUT,
@Ok		int	OUTPUT

AS BEGIN
DECLARE
@Sucursal		int,
@GenerarMovID	int,
@Almacen		char(10),
@AlmacenDestino 	char(10),
@FechaEmision	datetime,
@Moneda		char(10),
@TipoCambio		float,
@Estatus		char(15)
SELECT @FechaEmision = GETDATE(), @Estatus = 'SINAFECTAR', @GenerarMovID = NULL
EXEC spExtraerFecha @FechaEmision OUTPUT
BEGIN TRANSACTION
EXEC spMovEnID @Modulo, @Empresa, @Mov, @MovID, @ID OUTPUT, @Moneda OUTPUT, @Ok OUTPUT
SELECT @TipoCambio = TipoCambio FROM Mon WITH(NOLOCK) WHERE Moneda = @Moneda
IF (SELECT ISNULL(ArrastrarTipoCambioGenerarMov, 0) FROM EmpresaGral WITH(NOLOCK) WHERE Empresa = @Empresa) = 1 OR
(SELECT ISNULL(ArrastrarTipoCambioGenerarMov, 0) FROM MovTipo WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = @GenerarMov) = 1
SELECT @TipoCambio = NULL
IF @Modulo = 'VTAS' SELECT @Sucursal = Sucursal, @Almacen = Almacen, @AlmacenDestino = AlmacenDestino FROM Venta WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'PROD' SELECT @Sucursal = Sucursal, @Almacen = Almacen FROM Prod WITH(NOLOCK) WHERE ID = @ID ELSE
IF @Modulo = 'INV'  SELECT @Sucursal = Sucursal, @Almacen = Almacen, @AlmacenDestino = AlmacenDestino FROM Inv  WITH(NOLOCK)  WHERE ID = @ID ELSE
IF @Modulo = 'COMS' SELECT @Sucursal = Sucursal, @Almacen = Almacen FROM Compra WITH(NOLOCK) WHERE ID = @ID
EXEC spMovCopiarEncabezado @Sucursal, @Modulo, @ID, @Empresa, @Mov, @MovID, @Usuario, @FechaEmision, @Estatus,
@Moneda, @TipoCambio, @Almacen, @AlmacenDestino,
@GenerarDirecto, @GenerarMov, @GenerarMovID,
@GenerarID OUTPUT, @Ok OUTPUT, 0
COMMIT TRANSACTION
RETURN
END

