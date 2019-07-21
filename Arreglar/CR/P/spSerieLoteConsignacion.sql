SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSerieLoteConsignacion
@Empresa		varchar(5),
@Articulo		varchar(20),
@SubCuenta		varchar(50),
@SerieLote		varchar(50),
@Modulo			varchar(20),
@ModuloID		varchar(20),
@Accion			varchar(20),
@Cantidad		float,
@EsEntrada		bit = 0,
@EsSalida		bit = 0,
@Ok		int = NULL OUTPUT,
@OkRef		varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@MovTipo				varchar(20),
@SubMovTipo				varchar(20),
@CantidadSobrante		float,
@CantidadDisponible		float,
@CantidadAbonar			float,
@OModulo				varchar(5),
@OModuloID				int,
@OModuloDisponible		varchar(5),
@OModuloIDDisponible	int,
@CargoU					float,
@AbonoU					float
IF @Modulo = 'COMS' SELECT @MovTipo = mt.Clave, @SubMovTipo = mt.SubClave FROM MovTipo mt JOIN Compra m ON m.Mov = mt.Mov WHERE mt.Modulo = @Modulo AND m.ID = @ModuloID ELSE
IF @Modulo = 'VTAS' SELECT @MovTipo = mt.Clave, @SubMovTipo = mt.SubClave FROM MovTipo mt JOIN Venta m  ON m.Mov = mt.Mov WHERE mt.Modulo = @Modulo AND m.ID = @ModuloID ELSE
IF @Modulo = 'PROD' SELECT @MovTipo = mt.Clave, @SubMovTipo = mt.SubClave FROM MovTipo mt JOIN Prod m   ON m.Mov = mt.Mov WHERE mt.Modulo = @Modulo AND m.ID = @ModuloID ELSE
IF @Modulo = 'INV'  SELECT @MovTipo = mt.Clave, @SubMovTipo = mt.SubClave FROM MovTipo mt JOIN Inv m    ON m.Mov = mt.Mov WHERE mt.Modulo = @Modulo AND m.ID = @ModuloID
IF @Accion IN ('AFECTAR')
BEGIN
IF @Modulo = 'COMS' AND @MovTipo = 'COMS.F' AND @SubMovTipo = 'COMS.SLC' AND @EsEntrada = 1
BEGIN
IF NOT EXISTS(SELECT * FROM SerieLoteConsignacion WHERE SerieLote = @SerieLote AND Articulo = @Articulo AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'') AND OModuloID = @ModuloID AND OModulo = @Modulo AND Empresa = @Empresa)
BEGIN
INSERT SerieLoteConsignacion (Empresa,  OModulo, OModuloID, Articulo,  SubCuenta,             SerieLote,  Estatus)
VALUES (@Empresa, @Modulo, @ModuloID, @Articulo, ISNULL(@SubCuenta,''), @SerieLote, 'ALTA')
IF @@ERROR <> 0 SELECT @Ok = 1
END
IF @Ok IS NULL
BEGIN
INSERT SerieLoteConsignacionAux (Empresa,  OModulo, OModuloID, Articulo,  SubCuenta,             SerieLote,  Modulo,  ModuloID,  Fecha,                         CargoU,    AbonoU)
VALUES (@Empresa, @Modulo, @ModuloID, @Articulo, ISNULL(@SubCuenta,''), @SerieLote, @Modulo, @ModuloID, dbo.fnFechaSinHora(GETDATE()), @Cantidad, 0.0)
IF @@ERROR <> 0 SELECT @Ok = 1
END
END ELSE
IF @EsEntrada = 1 AND (@MovTipo NOT IN ('COMS.F') AND @SubMovTipo NOT IN ('COMS.SLC'))
BEGIN
SET @CantidadSobrante = @Cantidad
WHILE @CantidadSobrante > 0.0 AND NULLIF(@Ok,0) IS NULL
BEGIN
SELECT @OModuloDisponible = NULL, @OModuloIDDisponible = NULL
SELECT TOP 1
@OModuloDisponible   = OModulo,
@OModuloIDDisponible = OModuloID
FROM SerieLoteConsignacion
WHERE SerieLote = @SerieLote
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND Articulo = @Articulo
AND Empresa = @Empresa
AND Estatus = 'ALTA'
IF @OModuloDisponible IS NOT NULL AND @OModuloIDDisponible IS NOT NULL
BEGIN
SELECT
@CantidadDisponible = SUM(ISNULL(CargoU,0.0)-ISNULL(AbonoU,0.0))
FROM SerieLoteConsignacionAux WITH(ROWLOCK)
WHERE SerieLote = @SerieLote
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND Articulo = @Articulo
AND OModulo = @OModuloDisponible
AND OModuloID = @OModuloIDDisponible
AND Empresa = @Empresa
SELECT
@CantidadDisponible = ISNULL(CargoU,0.0) - @CantidadDisponible
FROM SerieLoteConsignacionAux WITH(ROWLOCK)
WHERE SerieLote = @SerieLote
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND Articulo = @Articulo
AND OModulo = @OModuloDisponible
AND OModuloID = @OModuloIDDisponible
AND Modulo = @OModuloDisponible
AND ModuloID = @OModuloIDDisponible
AND Empresa = @Empresa
IF @CantidadDisponible > @CantidadSobrante  SET @CantidadAbonar = @CantidadSobrante ELSE
IF @CantidadDisponible <= @CantidadSobrante SET @CantidadAbonar = @CantidadDisponible
INSERT SerieLoteConsignacionAux (Empresa,  OModulo,            OModuloID,            Articulo,  SubCuenta,             SerieLote,  Modulo,  ModuloID,  Fecha,                         CargoU,          AbonoU)
VALUES (@Empresa, @OModuloDisponible, @OModuloIDDisponible, @Articulo, ISNULL(@SubCuenta,''), @SerieLote, @Modulo, @ModuloID, dbo.fnFechaSinHora(GETDATE()), @CantidadAbonar, 0.0)
IF @@ERROR <> 0 SELECT @Ok = 1
IF NULLIF(@Ok,0) IS NULL
BEGIN
UPDATE SerieLoteConsignacion
SET Estatus = 'ALTA'
FROM SerieLoteConsignacion
WHERE SerieLote = @SerieLote
AND Articulo = @Articulo
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND OModuloID = @OModuloIDDisponible
AND OModulo = @OModuloDisponible
AND Empresa = @Empresa
AND Estatus = 'BAJA'
IF @@ERROR <> 0 SELECT @Ok = 1
END
IF @CantidadDisponible > @CantidadSobrante  SET @CantidadSobrante = 0.0 ELSE
IF @CantidadDisponible <= @CantidadSobrante SET @CantidadSobrante = @CantidadSobrante - @CantidadDisponible
IF @CantidadDisponible > @CantidadSobrante  SET @CantidadDisponible = @CantidadDisponible - @CantidadAbonar ELSE
IF @CantidadDisponible <= @CantidadSobrante SET @CantidadDisponible = 0.0
END ELSE
SET @CantidadSobrante = 0.0
END
END ELSE
IF @EsSalida = 1
BEGIN
SET @CantidadSobrante = @Cantidad
WHILE @CantidadSobrante > 0.0 AND NULLIF(@Ok,0) IS NULL
BEGIN
SELECT @OModuloDisponible = NULL, @OModuloIDDisponible = NULL
SELECT TOP 1
@OModuloDisponible   = OModulo,
@OModuloIDDisponible = OModuloID
FROM SerieLoteConsignacion
WHERE SerieLote = @SerieLote
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND Articulo = @Articulo
AND Empresa = @Empresa
AND Estatus = 'ALTA'
IF @OModuloDisponible IS NOT NULL AND @OModuloIDDisponible IS NOT NULL
BEGIN
SELECT
@CantidadDisponible = SUM(ISNULL(CargoU,0.0)-ISNULL(AbonoU,0.0))
FROM SerieLoteConsignacionAux WITH(ROWLOCK)
WHERE SerieLote = @SerieLote
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND Articulo = @Articulo
AND OModulo = @OModuloDisponible
AND OModuloID = @OModuloIDDisponible
AND Empresa = @Empresa
IF @CantidadDisponible > @CantidadSobrante  SET @CantidadAbonar = @CantidadSobrante ELSE
IF @CantidadDisponible <= @CantidadSobrante SET @CantidadAbonar = @CantidadDisponible
INSERT SerieLoteConsignacionAux (Empresa,  OModulo,            OModuloID,            Articulo,  SubCuenta,             SerieLote,  Modulo,  ModuloID,  Fecha,                         CargoU, AbonoU)
VALUES (@Empresa, @OModuloDisponible, @OModuloIDDisponible, @Articulo, ISNULL(@SubCuenta,''), @SerieLote, @Modulo, @ModuloID, dbo.fnFechaSinHora(GETDATE()), 0.0,    @CantidadAbonar)
IF @@ERROR <> 0 SELECT @Ok = 1
IF @CantidadDisponible > @CantidadSobrante  SET @CantidadSobrante = 0.0 ELSE
IF @CantidadDisponible <= @CantidadSobrante SET @CantidadSobrante = @CantidadSobrante - @CantidadDisponible
IF @CantidadDisponible > @CantidadSobrante  SET @CantidadDisponible = @CantidadDisponible - @CantidadAbonar ELSE
IF @CantidadDisponible <= @CantidadSobrante SET @CantidadDisponible = 0.0
IF @CantidadDisponible = 0.0
BEGIN
UPDATE SerieLoteConsignacion
SET Estatus = 'BAJA'
FROM SerieLoteConsignacion
WHERE SerieLote = @SerieLote
AND ISNULL(SubCuenta,'') = ISNULL(@SubCuenta,'')
AND Articulo = @Articulo
AND OModuloID = @OModuloIDDisponible
AND OModulo = @OModuloDisponible
AND Empresa = @Empresa
AND Estatus = 'ALTA'
IF @@ERROR <> 0 SELECT @Ok = 1
END
END ELSE
SET @CantidadSobrante = 0.0
END
END
END ELSE
IF @Accion IN ('CANCELAR')
BEGIN
DECLARE crSerieLoteConsignacionAux INSENSITIVE CURSOR FOR
SELECT OModulo, OModuloID, CargoU, AbonoU
FROM SerieLoteConsignacionAux
WHERE Modulo = @Modulo
AND ModuloID = @ModuloID
AND Empresa = @Empresa
AND Articulo = @Articulo
AND SubCuenta = @SubCuenta
AND SerieLote = @SerieLote
OPEN crSerieLoteConsignacionAux
FETCH NEXT FROM crSerieLoteConsignacionAux INTO @OModulo, @OModuloID, @CargoU, @AbonoU
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
INSERT SerieLoteConsignacionAux (Empresa,  OModulo,  OModuloID,  Articulo,  SubCuenta,             SerieLote,  Modulo,  ModuloID,  Fecha,                         CargoU,  AbonoU)
VALUES (@Empresa, @OModulo, @OModuloID, @Articulo, ISNULL(@SubCuenta,''), @SerieLote, @Modulo, @ModuloID, dbo.fnFechaSinHora(GETDATE()), @AbonoU, @CargoU)
IF @@ERROR <> 0 SELECT @Ok = 1
FETCH NEXT FROM crSerieLoteConsignacionAux INTO @OModulo, @OModuloID, @CargoU, @AbonoU
END
CLOSE crSerieLoteConsignacionAux
DEALLOCATE crSerieLoteConsignacionAux
END
END

