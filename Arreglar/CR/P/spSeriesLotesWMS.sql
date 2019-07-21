SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSeriesLotesWMS
@Empresa			        char(5),
@Modulo                  char(5),
@Accion			        char(20),
@EsEntrada			    bit,
@EsSalida			    bit,
@ID  			        int,
@RenglonID			    int,
@Articulo                char(20),
@SubCuenta			    varchar(50),
@MovTipo			        char(20),
@AplicaMovTipo		    char(20),
@FechaEmision		    datetime,
@Temp			        bit = 0,
@Tarima			        varchar(20),
@CantidadMovimiento      float,
@Ok 				        int		OUTPUT,
@OkRef 			        varchar(255)	OUTPUT

AS BEGIN
DECLARE
@SubCuentaNull		varchar(50),
@SerieLote			varchar(50),
@Propiedades		char(20),
@Cantidad			float,
@MovSubTipo				char(20),
@OrigenTipo                 varchar(10)
SELECT @MovSubTipo = NULLIF(RTRIM(mt.SubClave), '')
FROM MovTipo mt
WHERE mt.Modulo = @Modulo AND mt.Clave = @MovTipo
IF @Accion = 'AFECTAR'
BEGIN
DECLARE crSerieLoteMov CURSOR FOR
SELECT NULLIF(RTRIM(SerieLote), ''), ISNULL(Cantidad, 0.0), NULLIF(RTRIM(Propiedades), '')
FROM SerieLoteMov
WHERE Empresa   = @Empresa
AND Modulo    = @Modulo
AND ID        = @ID
AND RenglonID = @RenglonID
AND Articulo  = @Articulo
AND SubCuenta = ISNULL(@SubCuenta, SubCuenta)
OPEN crSerieLoteMov
FETCH NEXT FROM crSerieLoteMov INTO @SerieLote, @Cantidad, @Propiedades
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND (@Cantidad <> 0.0)
BEGIN
IF EXISTS (SELECT * FROM TarimaSerieLote WHERE SerieLote = @SerieLote AND Tarima = @Tarima)
BEGIN
UPDATE TarimaSerieLote
SET Existencia = ISNULL(Existencia,0) + @Cantidad
WHERE SerieLote = @SerieLote AND ISNULL(Tarima,'') = ISNULL(@Tarima,'')
END
IF NOT EXISTS (SELECT * FROM TarimaSerieLote WHERE SerieLote = @SerieLote AND ISNULL(Tarima,'') = ISNULL(@Tarima,''))
BEGIN
INSERT TarimaSerieLote (Tarima, SerieLote, Propiedades, Existencia)
VALUES (@Tarima, @SerieLote, @Propiedades, @Cantidad)
END
END
FETCH NEXT FROM crSerieLoteMov INTO @SerieLote, @Cantidad, @Propiedades
IF @@ERROR <> 0 SELECT @Ok = 1
END
CLOSE crSerieLoteMov
DEALLOCATE crSerieLoteMov
END
IF @Accion = 'CANCELAR'
BEGIN
DECLARE crSerieLoteMov CURSOR FOR
SELECT NULLIF(RTRIM(SerieLote), ''), ISNULL(Cantidad, 0.0), NULLIF(RTRIM(Propiedades), '')
FROM SerieLoteMov
WHERE Empresa   = @Empresa
AND Modulo    = @Modulo
AND ID        = @ID
AND RenglonID = @RenglonID
AND Articulo  = @Articulo
AND NULLIF(RTRIM(SubCuenta), '') = @SubCuentaNull
OPEN crSerieLoteMov
FETCH NEXT FROM crSerieLoteMov INTO @SerieLote, @Cantidad, @Propiedades
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND (@Cantidad <> 0.0)
BEGIN
IF EXISTS (SELECT * FROM TarimaSerieLote WHERE SerieLote = @SerieLote AND ISNULL(Tarima,'') = ISNULL(@Tarima,''))
BEGIN
UPDATE TarimaSerieLote
SET Existencia = ISNULL(Existencia,0) - @Cantidad
WHERE SerieLote = @SerieLote AND ISNULL(Tarima,'') = ISNULL(@Tarima,'')
END
END
FETCH NEXT FROM crSerieLoteMov INTO @SerieLote, @Cantidad, @Propiedades
IF @@ERROR <> 0 SELECT @Ok = 1
END
CLOSE crSerieLoteMov
DEALLOCATE crSerieLoteMov
END
RETURN
END

