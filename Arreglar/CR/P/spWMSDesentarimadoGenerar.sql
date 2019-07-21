SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSDesentarimadoGenerar
@ID					int,
@Tarima				varchar(20),
@PCK				float,
@Articulo			varchar(20),
@CantidadAfectar	float,
@RenglonWMS			int,
@TarimaWMS			varchar(20),
@IDGenerar			int				OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT

AS BEGIN
DECLARE
@Empresa			char(5),
@Usuario			varchar(20),
@MovGenerar			varchar(20),
@Almacen			varchar(20),
@Sucursal			int,
@Renglon			int,
@RenglonSub			int,
@RenglonID			int,
@Moneda				varchar(20),
@Unidad				varchar(50),
@Posicion			varchar(10)
SELECT @Empresa  =  Empresa,
@Usuario  =  Usuario,
@Almacen  =  Almacen,
@Sucursal =  Sucursal
FROM TMA
WHERE ID = @ID
SELECT @Posicion = DefPosicionRecibo FROM Alm WHERE Almacen = @Almacen
SELECT @Moneda = ContMoneda FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @Unidad = Unidad FROM Art WHERE Articulo = @Articulo
SELECT @MovGenerar = InvDesentarimado FROM EmpresaCfgMov WHERE Empresa = @Empresa
IF @IDGenerar IS NULL
BEGIN
INSERT Inv (
Empresa,  Sucursal,  Mov,         Almacen,  FechaEmision,                  Usuario,  Estatus,      AlmacenDestino, Moneda,  TipoCambio, PosicionWMS)
SELECT   @Empresa, @Sucursal, @MovGenerar, @Almacen, dbo.fnFechaSinHora(GETDATE()), @Usuario, 'SINAFECTAR', @Almacen,       @Moneda, 1, @Posicion
IF @@ERROR <> 0 SET @Ok = 1
SELECT @IDGenerar = @@IDENTITY
END
IF @IDGenerar IS NOT NULL
BEGIN
SELECT @Renglon    = ISNULL(MAX(Renglon),0) + 2048,
@RenglonSub = ISNULL(MAX(RenglonSub),0) + 1,
@RenglonID  = ISNULL(MAX(RenglonID),0) + 1
FROM InvD
WHERE ID = @IDGenerar
INSERT InvD (
ID,         Renglon,  RenglonSub,  RenglonID,  Sucursal,  Almacen,    Articulo,  Cantidad,         CantidadInventario, Tarima,  Unidad)
SELECT   @IDGenerar, @Renglon, @RenglonSub, @RenglonID, @Sucursal, @Almacen,   @Articulo, @CantidadAfectar, @CantidadAfectar,	 @Tarima, @Unidad
IF @@ERROR <> 0 SET @Ok = 1
UPDATE TMAD
SET CantidadPicking	= ISNULL(NULLIF(CantidadPicking - @CantidadAfectar,0),@CantidadAfectar),
CantidadPendiente	= NULLIF(CantidadPendiente,0) - @CantidadAfectar
WHERE ID = @ID
AND Tarima = @TarimaWMS
AND Renglon = @RenglonWMS
END
RETURN
END

