SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProdSerieLote
@Sucursal		int,
@Accion		char(20),
@Empresa		char(5),
@MovTipo     	char(20),
@FechaEmision	datetime,
@DetalleTipo		varchar(20),
@ProdSerieLote	varchar(50),
@Articulo		char(20),
@SubCuenta		varchar(50),
@MovCantidad		float,
@MovMerma		float,
@MovDesperdicio	float,
@Factor		float,
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS BEGIN
DECLARE
@FechaOrden		 datetime,
@FechaEntrada	 datetime,
@Cantidad 		 float,
@Merma		 float,
@Desperdicio	 float,
@CantidadOrdenada	 float,
@CantidadCancelada	 float,
@CantidadEntrada	 float,
@CantidadMerma	 float,
@CantidadDesperdicio float
SELECT @SubCuenta = ISNULL(RTRIM(@SubCuenta), '')
SELECT @Cantidad = @MovCantidad*@Factor, @Merma = @MovMerma*@Factor, @Desperdicio = @MovDesperdicio*@Factor
IF @Accion = 'CANCELAR' SELECT @Cantidad = -@Cantidad, @Merma = -@Merma, @Desperdicio = -@Desperdicio
SELECT @CantidadOrdenada = 0.0, @CantidadCancelada = 0.0, @CantidadEntrada = 0.0, @CantidadMerma = 0.0, @CantidadDesperdicio = 0.0,
@FechaOrden = NULL, @FechaEntrada = NULL
IF @MovTipo = 'PROD.O'  SELECT @FechaOrden   = @FechaEmision, @CantidadOrdenada = @Cantidad ELSE
IF @MovTipo = 'PROD.CO' SELECT @CantidadCancelada = @Cantidad ELSE
IF @MovTipo = 'PROD.E'  SELECT @FechaEntrada = @FechaEmision, @CantidadEntrada  = @Cantidad, @CantidadMerma = @Merma, @CantidadDesperdicio = @Desperdicio
UPDATE ProdSerieLote
SET FechaOrden          = ISNULL(@FechaOrden, FechaOrden),
FechaEntrada        = ISNULL(@FechaEntrada, FechaEntrada),
CantidadOrdenada    = NULLIF(ISNULL(CantidadOrdenada, 0.0)    + @CantidadOrdenada, 0.0),
CantidadCancelada   = NULLIF(ISNULL(CantidadCancelada, 0.0)   + @CantidadCancelada, 0.0),
CantidadEntrada     = NULLIF(ISNULL(CantidadEntrada,  0.0)    + @CantidadEntrada, 0.0),
CantidadMerma       = NULLIF(ISNULL(CantidadMerma,  0.0)      + @CantidadMerma, 0.0),
CantidadDesperdicio = NULLIF(ISNULL(CantidadDesperdicio, 0.0) + @CantidadDesperdicio, 0.0)
WHERE Empresa = @Empresa AND ProdSerieLote = @ProdSerieLote AND Articulo = @Articulo AND SubCuenta = @SubCuenta
IF @@ROWCOUNT = 0
INSERT ProdSerieLote (Sucursal,  Empresa,  FechaOrden,  FechaEntrada,  ProdSerieLote,  Articulo,  SubCuenta,  CantidadOrdenada,  CantidadCancelada,  CantidadEntrada,  CantidadMerma,  CantidadDesperdicio)
VALUES (@Sucursal, @Empresa, @FechaOrden, @FechaEntrada, @ProdSerieLote, @Articulo, @SubCuenta, @CantidadOrdenada, @CantidadCancelada, @CantidadEntrada, @CantidadMerma, @CantidadDesperdicio)
IF @MovTipo = 'PROD.CO'
IF EXISTS(SELECT * FROM ProdSerieLoteCostoAcum WHERE Empresa = @Empresa AND ProdSerieLote = @ProdSerieLote AND Articulo = @Articulo AND SubCuenta = @SubCuenta AND ISNULL(ROUND(CantidadPendiente, 4), 0) <= 0 AND ISNULL(ROUND(Saldo, 2), 0) >= 1)
SELECT @Ok = 25440, @OkRef = 'Lote: '+ @ProdSerieLote
END

