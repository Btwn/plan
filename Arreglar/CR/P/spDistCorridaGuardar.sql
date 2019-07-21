SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDistCorridaGuardar (
@Empresa              varchar(5),
@Corrida              int
)

AS
BEGIN
DECLARE @ret            bit
DECLARE @Transaccion    varchar(100)
SET @ret = 0
SET @Empresa = UPPER(LTRIM(RTRIM(ISNULL(@Empresa,''))))
SET @Corrida = ISNULL(@Corrida,0)
SET @Transaccion = '@Empresa' + CAST(@Corrida AS varchar(95))
BEGIN TRY
IF EXISTS (SELECT TOP 1 Corrida FROM DistribucionT WHERE Empresa = @Empresa AND Corrida = @Corrida)
BEGIN
BEGIN TRANSACTION @Transaccion
MERGE INTO Distribucion t
USING DistribucionT s
ON t.Empresa        = s.Empresa
AND t.corrida        = s.corrida
AND t.ALmacen        = s.ALmacen
AND t.AlmacenDestino = s.AlmacenDestino
AND t.Articulo       = s.Articulo
AND t.SubCuenta      = s.SubCuenta
WHEN MATCHED THEN
UPDATE
SET Cantidad      = s.Cantidad,
FechaRegistro = s.FechaRegistro
WHEN NOT MATCHED BY TARGET THEN
INSERT(Empresa,Sucursal,Usuario,Estacion,Corrida,Almacen,AlmacenDestino,Articulo,SubCuenta,Cantidad,
FechaRegistro,FechaProcesado,Procesado)
VALUES(s.Empresa,s.Sucursal,s.Usuario,s.Estacion,s.Corrida,s.Almacen,s.AlmacenDestino,s.Articulo,s.SubCuenta,s.Cantidad,
s.FechaRegistro,s.FechaProcesado,s.Procesado);
DELETE DistribucionT WHERE Empresa = @Empresa AND Corrida = @Corrida
SET @ret = 1
COMMIT TRAN @Transaccion
END
END TRY
BEGIN CATCH
SET @ret = 0
END CATCH
SELECT @ret
END

