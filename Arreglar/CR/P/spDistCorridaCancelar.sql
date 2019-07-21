SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDistCorridaCancelar
@Empresa              varchar(5),
@Corrida              int

AS
BEGIN
DECLARE @ret bit
SET @ret = 1
IF EXISTS(SELECT TOP 1 Empresa FROM Distribucion WHERE Empresa = @Empresa AND Corrida = @Corrida)
BEGIN
BEGIN TRY
INSERT INTO DistribucionHist (Empresa,Sucursal,Usuario,Estacion,Corrida,Almacen,AlmacenDestino,Articulo,SubCuenta,Cantidad,FechaRegistro,FechaProcesado,Procesado)
SELECT Empresa,Sucursal,Usuario,Estacion,Corrida,Almacen,AlmacenDestino,Articulo,SubCuenta,Cantidad,FechaRegistro,FechaProcesado,Procesado
FROM Distribucion WHERE Empresa = @Empresa AND Corrida = @Corrida AND Procesado = 0
DELETE FROM Distribucion WHERE Empresa = @Empresa AND Corrida = @Corrida AND Procesado = 0
END TRY
BEGIN CATCH
SET @ret = 0
END CATCH
END
SELECT @ret
END

