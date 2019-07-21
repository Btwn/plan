SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVINEntrada
@Empresa	char(5),
@Modulo 	char(5),
@ID 		int,
@Mov		char(20),
@RenglonID 	int,
@Articulo	char(20),
@FechaEmision	datetime,
@FechaRequerida	datetime,
@ImporteNeto    float,
@Impuesto1Neto  float,
@VIN		varchar(20)	OUTPUT,
@Ok		int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@TipoUnidad		varchar(20),
@NumeroEconomico	varchar(20),
@FechaEntrada	datetime,
@FechaMRS		datetime,
@Interfase          bit,
@IntercambioDirecto	bit
DECLARE crVIN CURSOR FOR
SELECT v.VIN, v.TipoUnidad, NULLIF(RTRIM(v.NumeroEconomico), ''), ISNULL(v.FechaFacturaCompra, @FechaEmision), v.FechaMRS, v.IntercambioDirecto, v.Interfase
FROM VIN v, SerieLoteMov s
WHERE s.Empresa = @Empresa AND s.Modulo = @Modulo AND s.ID = @ID AND s.RenglonID = @RenglonID AND s.Articulo  = @Articulo
AND v.VIN = s.SerieLote
OPEN crVIN
FETCH NEXT FROM crVIN INTO @VIN, @TipoUnidad, @NumeroEconomico, @FechaEntrada, @FechaMRS, @IntercambioDirecto, @Interfase
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @NumeroEconomico IS NULL
EXEC xpVINNumeroEconomico @VIN, @TipoUnidad, @Articulo, @FechaEntrada, @NumeroEconomico OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
EXEC xpVINFechaMRS @VIN, @Mov, @FechaEntrada, @FechaRequerida, @FechaMRS OUTPUT, @IntercambioDirecto OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
UPDATE VIN
SET FechaEntrada          = @FechaEntrada,
NumeroEconomico       = @NumeroEconomico,
FechaMRS              = @FechaMRS,
IntercambioDirecto    = @IntercambioDirecto,
CompraID	           = @ID,
SubTotalFacturaCompra = CASE WHEN @Interfase = 0 OR UPPER(@TipoUnidad) = 'SEMINUEVO' THEN @ImporteNeto   ELSE SubTotalFacturaCompra END,
IVAFacturaCompra      = CASE WHEN @Interfase = 0 OR UPPER(@TipoUnidad) = 'SEMINUEVO' THEN @Impuesto1Neto ELSE IVAFacturaCompra      END,
TotalFacturaCompra    = CASE WHEN @Interfase = 0 OR UPPER(@TipoUnidad) = 'SEMINUEVO' THEN @ImporteNeto+@Impuesto1Neto ELSE TotalFacturaCompra END
WHERE CURRENT OF crVIN
END
FETCH NEXT FROM crVIN INTO @VIN, @TipoUnidad, @NumeroEconomico, @FechaEntrada, @FechaMRS, @IntercambioDirecto, @Interfase
END
CLOSE crVIN
DEALLOCATE crVIN
RETURN
END

