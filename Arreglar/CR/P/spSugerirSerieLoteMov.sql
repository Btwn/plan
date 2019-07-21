SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSugerirSerieLoteMov
@Empresa	char(5),
@Modulo		char(5),
@ID		int,
@MovTipo	varchar(20),
@Almacen	char(10),
@RenglonID	int,
@Articulo	char(20),
@SubCuenta	varchar(50),
@Sucursal	int,
@Cantidad	float,
@Paquete	int,
@EnSilencio	bit = 0

AS BEGIN
DECLARE
@a			int,
@LotesFijos		bit,
@LotesAuto		bit,
@ArtConsecutivo	int,
@AFConsecutivo	int,
@EsEntrada		bit,
@EsAF		bit,
@SugerirEntrada	bit
SELECT @LotesFijos = 0, @LotesAuto = 0, @SubCuenta = ISNULL(NULLIF(NULLIF(RTRIM(@SubCuenta), ''), '0'), ''), @EsEntrada = 0, @EsAF = 0
SELECT @LotesFijos = ISNULL(LotesFijos, 0), @LotesAuto = ISNULL(LotesAuto, 0), @ArtConsecutivo = ISNULL(Consecutivo, 0) FROM Art WHERE Articulo = @Articulo AND Tipo = 'LOTE'
IF (SELECT UPPER(Tipo) FROM Alm WHERE Almacen = @Almacen) = 'ACTIVOS FIJOS' SELECT @EsAF = 1
IF @MovTipo IN ('COMS.F', 'COMS.FL', 'COMS.EG', 'COMS.EI', 'INV.E', 'INV.EP') SELECT @EsEntrada = 1
IF NOT EXISTS(SELECT * FROM SerieLoteMov WHERE Empresa = @Empresa AND Modulo = @Modulo AND ID = @ID AND RenglonID = @RenglonID AND Articulo = @Articulo AND ISNULL(SubCuenta, '') = @SubCuenta)
BEGIN
IF @EsAF = 1 AND @EsEntrada = 1
BEGIN
SELECT @SugerirEntrada = ISNULL(AFSugerirSerieEntrada, 0), @AFConsecutivo = ISNULL(AFConsecutivo, 0) FROM EmpresaCfg WHERE Empresa = @Empresa
IF @SugerirEntrada = 1
BEGIN
SELECT @a = 0
WHILE @a<@Cantidad
BEGIN
SELECT @a = @a + 1
INSERT SerieLoteMov (Empresa,  Sucursal,  Modulo,  ID,  RenglonID,  Articulo,  SubCuenta,  SerieLote, Cantidad)
VALUES (@Empresa, @Sucursal, @Modulo, @ID, @RenglonID, @Articulo, @SubCuenta, CONVERT(varchar, @AFConsecutivo+@a), 1)
END
UPDATE EmpresaCfg SET AFConsecutivo = @AFConsecutivo+@Cantidad WHERE Empresa = @Empresa
SELECT @LotesFijos = CONVERT(bit, 0)
RETURN
END
END
IF @LotesFijos = 1 OR (@LotesAuto = 1 AND ISNULL(@Paquete, 0) > 0 AND @EsEntrada = 1)
BEGIN
IF @LotesFijos = 1
INSERT SerieLoteMov (Empresa,  Sucursal,  Modulo,  ID,  RenglonID,  Articulo,  SubCuenta,  SerieLote, Cantidad)
SELECT @Empresa, @Sucursal, @Modulo, @ID, @RenglonID, @Articulo, @SubCuenta, Lote,      NULL
FROM ArtLoteFijo
WHERE Articulo = @Articulo
ELSE
IF @LotesAuto = 1
BEGIN
SELECT @a = 0
WHILE @a<@Paquete
BEGIN
SELECT @a = @a + 1
INSERT SerieLoteMov (Empresa,  Sucursal,  Modulo,  ID,  RenglonID,  Articulo,  SubCuenta,  SerieLote, Cantidad)
VALUES (@Empresa, @Sucursal, @Modulo, @ID, @RenglonID, @Articulo, @SubCuenta, CONVERT(varchar, @ArtConsecutivo+@a), @Cantidad/@Paquete)
END
UPDATE Art SET Consecutivo = @ArtConsecutivo+@Paquete WHERE Articulo = @Articulo
END
END
END
IF @EnSilencio = 0
SELECT "LotesFijos" = @LotesFijos
RETURN
END

