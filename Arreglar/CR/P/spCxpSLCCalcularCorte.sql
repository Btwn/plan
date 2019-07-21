SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCxpSLCCalcularCorte
@Estacion				int,
@ID						int,
@IDGenerar				int,
@FechaCorte				datetime,
@CostoTotalMovimientos	float = NULL OUTPUT,
@Ok						int = NULL OUTPUT,
@OkRef					varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Mov						varchar(20),
@MovID						varchar(20),
@MovImporteTotal			float,
@MovTipo					varchar(20),
@SubMovTipo					varchar(20),
@OModulo					varchar(5),
@OModuloID					int,
@OMov						varchar(20),
@OMovTipo					varchar(20),
@OSubMovTipo				varchar(20),
@Empresa					varchar(5),
@CantidadMovimientos		float,
@CantidadSaldoInicial		float,
@CostoMovimientos			float,
@Articulo					varchar(20),
@SubCuenta					varchar(50),
@SerieLote					varchar(50),
@ParticipacionSerieLote		float,
@CantidadSerieLote			float,
@ParticipacionMovimientos	float,
@Origen						varchar(20),
@OrigenID					varchar(20)
SELECT
@Origen = Origen,
@OrigenID = OrigenID,
@Mov = Mov,
@MovID = MovID,
@Empresa = Empresa,
@MovImporteTotal =  ISNULL(Importe,0.0) + ISNULL(Impuestos,0.0) - (ISNULL(Retencion,0.0)+ISNULL(Retencion2,0.0)+ISNULL(Retencion3,0.0))
FROM Cxp WHERE ID = @ID
SELECT @MovTipo = Clave, @SubMovTipo = SubClave FROM MovTipo WHERE Modulo = 'CXP' AND Mov = @Mov
IF @MovTipo NOT IN ('CXP.F') OR @SubMovTipo NOT IN ('CXP.SLC') SELECT @Ok = 75510, @OkRef = ISNULL(@Mov,'') + ' ' + ISNULL(@MovID,'')
IF @Ok IS NULL OR @Ok IN (80030)
BEGIN
EXEC spMovOrigen 'CXP', @ID, 0, @OModulo OUTPUT, @OModuloID OUTPUT
IF @OModulo = 'COMS'
BEGIN
SELECT @OMov = Mov FROM Compra WHERE ID = @OModuloID
SELECT @OMovTipo = Clave, @OSubMovTipo = SubClave FROM MovTipo WHERE Modulo = 'COMS' AND Mov = @OMov
IF @OMovTipo NOT IN ('COMS.F') OR @OSubMovTipo NOT IN ('COMS.SLC') SELECT @Ok = 75500, @OkRef = ISNULL(@Mov,'') + ' ' + ISNULL(@MovID,'')
END ELSE
BEGIN
SELECT @Ok = 75500, @OkRef = ISNULL(@Mov,'') + ' ' + ISNULL(@MovID,'')
END
END
IF NULLIF(@Ok,0) IS NULL OR @Ok IN (80030)
BEGIN
DELETE FROM SerieLoteConsignacionAuxTemp WHERE ModuloID = @IDGenerar AND Modulo = 'CXP' AND Estacion = @Estacion
IF @@ERROR <> 0 SET @Ok = 1
END
SET @CostoTotalMovimientos = 0.0
DECLARE crSerieLoteMov CURSOR FOR
SELECT slm.Articulo, ISNULL(slm.SubCuenta,''), slm.SerieLote, ISNULL(SUM(ISNULL(slm.Cantidad,0.0)),0.0)
FROM SerieLoteMov slm JOIN CompraD cd
ON cd.RenglonID = slm.RenglonID AND cd.ID = slm.ID AND slm.Modulo = 'COMS' AND slm.Empresa = @Empresa
WHERE slm.Modulo = @OModulo
AND slm.ID = @OModuloID
GROUP BY slm.SerieLote, ISNULL(slm.SubCuenta,''), slm.Articulo
OPEN crSerieLoteMov
FETCH NEXT FROM crSerieLoteMov INTO @Articulo, @SubCuenta, @SerieLote, @CantidadSerieLote
WHILE @@FETCH_STATUS = 0 AND (@Ok IS NULL OR @Ok IN (80030))
BEGIN
INSERT SerieLoteConsignacionAuxTemp (Estacion,  Modulo, ModuloID,   Empresa, OModulo, OModuloID, Articulo, SubCuenta,  SerieLote, RIDOriginal, MModulo, MModuloID, Fecha, CargoU, AbonoU, CorteID, CorteIDAnterior)
SELECT  @Estacion, 'CXP',  @IDGenerar, Empresa, OModulo, OModuloID, Articulo, SubCuenta,  SerieLote, RID,         Modulo,  ModuloID,  Fecha, CargoU, AbonoU, CorteID, CorteIDAnterior
FROM  SerieLoteConsignacionAux
WHERE  Fecha <= @FechaCorte
AND SerieLote = @SerieLote
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND Articulo = @Articulo
AND OModuloID = @OModuloID
AND OModulo = @OModulo
AND Empresa = @Empresa
SET @CantidadSaldoInicial = dbo.fnSerieLoteConsignacionSaldoInicial(@Estacion, 'CXP', @IDGenerar, @Empresa, @OModulo, @OModuloID, @Articulo, @SubCuenta, @SerieLote, @FechaCorte)
SET @CantidadMovimientos = dbo.fnSerieLoteConsignacionMovimientos(@Estacion, 'CXP', @IDGenerar, @Empresa, @OModulo, @OModuloID, @Articulo, @SubCuenta, @SerieLote, @FechaCorte)
SET @ParticipacionSerieLote = dbo.fnSerieLoteConsignacionParticipacion(@Empresa, @OModuloID, @Articulo, @SubCuenta, @SerieLote)
SET @ParticipacionMovimientos = (ISNULL(@CantidadMovimientos,0.0) / ISNULL(@CantidadSerieLote,0.0)) * ISNULL(@ParticipacionSerieLote,0.0)
SET @CostoMovimientos = @MovImporteTotal * @ParticipacionMovimientos
SET @CostoTotalMovimientos = @CostoTotalMovimientos + @CostoMovimientos
FETCH NEXT FROM crSerieLoteMov INTO @Articulo, @SubCuenta, @SerieLote, @CantidadSerieLote
END
CLOSE crSerieLoteMov
DEALLOCATE crSerieLoteMov
IF @Ok IS NULL
BEGIN
UPDATE Cxp SET ConsignacionFechaCorte = @FechaCorte WHERE ID = @IDGenerar
UPDATE CxpD
SET Importe = @CostoTotalMovimientos
WHERE ID = @IDGenerar
AND Aplica = @Origen
AND AplicaID = @OrigenID
END
END

