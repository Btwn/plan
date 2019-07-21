SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelInsertaInventarios]
(
@Estacion	int
)

AS BEGIN
DECLARE
@Modulo				varchar(5),
@Mov				varchar(20),
@Empresa			varchar(5),
@Moneda				varchar(30),
@TipoCambio			float(15),
@Usuario			varchar(10),
@Estatus			varchar(15),
@Almacen			varchar(30),
@Importe			money,
@Impuesto			money,
@ID					int,
@Renglon			int,
@RenglonID			int,
@Cantidad			float(15),
@Articulo			varchar(20),
@Costo				decimal(15,5),
@Observaciones		varchar(30),
@IDAjuste			int,
@Tipo				varchar(20),
@Serie				varchar(50),
@Sucursal			varchar(30),
@CantidadSerie		float(15),
@AjusteSeries		varchar(2),
@FlagError			bit,
@ManObj				int,
@ManArch			int,
@Cadena				varchar(500),
@Conta				int,
@MovID				varchar(20),
@Rid				int,
@Ok	int,
@OkRef	varchar(255)
UPDATE AspelProcesos SET
Estatus = 1
WHERE Proceso = 'Inventarios'
SELECT @Usuario = Valor FROM AspelCfg WHERE Descripcion = 'Usuario'
SELECT @Observaciones = Valor FROM AspelCfg WHERE Descripcion = 'Observaciones'
SELECT @Sucursal = Valor FROM AspelCfg WHERE Descripcion = 'Sucursal'
SELECT @AjusteSeries = Valor FROM AspelCfgOpcion WHERE Descripcion = 'Ajuste Automatico Existencias Series'
create table #Pasito
(
Id	int, Descripcion	varchar(500)
)
SET @FlagError = 0
SET @Conta = 0
EXEC spCreaArchivo 'C:\Log_Inventarios.txt', @ManObj OUT, @ManArch OUT
SET @Ok = NULL
BEGIN TRANSACTION ASPEL
UPDATE Aspel_Paso SET
Inventarios = 0, DescripcionInventarios = ''
DECLARE crCabecera CURSOR FOR
SELECT Empresa, Modulo, Mov, Moneda, TipoCambio, Estatus, Almacen,MovId 
FROM AspelCargaReg
WHERE Modulo = 'INV'
GROUP BY Empresa, Modulo, Mov, Moneda, TipoCambio, Estatus, Almacen,MovId 
OPEN crCabecera
FETCH NEXT FROM crCabecera INTO @Empresa, @Modulo, @Mov, @Moneda, @TipoCambio, @Estatus, @Almacen, @MovID 
INSERT INTO SerieLote (Sucursal, Empresa, Articulo, Subcuenta, SerieLote, Almacen,
Existencia, ExistenciaAlterna, UltimaEntrada, UltimaSalida)
SELECT @Sucursal, @Empresa, Articulo, '', valor, @Almacen,  1, 0, NULL, NULL
FROM AspelCargaProp
WHERE Campo = 'Serie'
WHILE (@@FETCH_STATUS <> -1) AND (@@FETCH_STATUS <> -2)
BEGIN
INSERT INV (Empresa, Mov, FechaEmision, UltimoCambio, Moneda, TipoCambio, Usuario, Estatus, RenglonID, Almacen, AlmacenTransito, FechaRequerida, Vencimiento, Observaciones, Concepto)
VALUES (@Empresa,@Mov, getdate(), getdate(), @Moneda, @TipoCambio, @Usuario, @Estatus, 4, @Almacen, '(TRANSITO)',getdate(), getdate(),@Observaciones, @Observaciones)
SET @ID = SCOPE_IDENTITY()
DECLARE crDetalle CURSOR FOR
SELECT A.Cantidad, A.Almacen, A.Articulo, A.Costo, B.Tipo
FROM AspelCargaReg A JOIN AspelCargaProp B
ON A.Articulo = B.Valor
WHERE A.Empresa = @Empresa AND A.Modulo = @Modulo AND A.Mov = @Mov AND A.Moneda = @Moneda AND
A.TipoCambio = @TipoCambio AND A.Estatus = @Estatus AND A.Almacen = @Almacen AND ISNULL(A.Cantidad,0) <> 0
AND B.Campo = 'Articulo'
SET @Renglon = 0
SET @RenglonID = 0
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO @Cantidad, @Almacen, @Articulo, @Costo, @Tipo
WHILE (@@FETCH_STATUS <> -1) AND (@@FETCH_STATUS <> -2)
BEGIN
SET @Renglon = @Renglon + 2048
SET @RenglonID = @RenglonID + 1
IF @Tipo = 'Serie'
BEGIN
SET @CantidadSerie = 0
DECLARE crSerieDetalle CURSOR FOR
SELECT Valor
FROM AspelCargaProp
WHERE Articulo = @Articulo AND Almacen = @Almacen AND Costo = @Costo AND Campo = 'Serie'
OPEN crSerieDetalle
FETCH NEXT FROM crSerieDetalle INTO @Serie
WHILE (@@FETCH_STATUS <> -1) AND (@@FETCH_STATUS <> -2)
BEGIN
INSERT SerieLoteMov (Sucursal, Empresa, Modulo, ID, RenglonID, Articulo, SerieLote, Cantidad)
VALUES (@Sucursal, @Empresa, @Modulo, @ID, @RenglonID, @Articulo, @Serie, 1)
SET @Cantidadserie = @CantidadSerie + 1
FETCH NEXT FROM crSerieDetalle INTO @Serie
END
CLOSE crSerieDetalle
DEALLOCATE crSerieDetalle
END
INSERT INVD (ID, Renglon, RenglonID, Cantidad, Almacen, Articulo, FechaRequerida, Costo)
VALUES (@ID, @Renglon, @RenglonID, @Cantidad, @Almacen, @Articulo, getdate(), @Costo)
FETCH NEXT FROM crDetalle INTO @Cantidad, @Almacen, @Articulo, @Costo, @Tipo
END
CLOSE crDetalle
DEALLOCATE crDetalle
EXEC spAfectar @Modulo, @ID, 'AFECTAR', 'Todo', NULL, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT, NULL, 1, @@SPID
IF @Ok IS NOT NULL AND @Ok<80000 BEGIN
SET @OkRef = @OkRef + ', ' + @Modulo + ':' + CONVERT(varchar,@ID)
SET @OkRef = @OkRef + ', ' + @Modulo + ':' + CONVERT(varchar,@ID)
SET @Conta = @Conta + 1
SET @Cadena = 'Modulo ' + @Modulo + ', Mov ' + @Mov + ', MovID ' + @MovID + ', Fecha ' + convert(varchar,getdate(), 103)
Insert Into #Pasito(Id, Descripcion) Values (@Conta, @Cadena)
SET @FlagError = 1
END
FETCH NEXT FROM crCabecera INTO @Empresa, @Modulo, @Mov, @Moneda, @TipoCambio, @Estatus, @Almacen, @MovID 
END
CLOSE crCabecera
DEALLOCATE crCabecera
IF @FlagError = 1
BEGIN
DECLARE crLineas CURSOR FOR
SELECT Descripcion FROM #PASITO
ORDER BY Id
OPEN crLineas
FETCH NEXT FROM crLineas INTO @Cadena
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC spInsertaEnArchivo @ManArch, @Cadena
FETCH NEXT FROM crLineas INTO @Cadena
END
CLOSE crLineas
DEALLOCATE crLineas
SELECT @Ok = 30230, @OkRef = 'Errores en el Módulo Inventarios, verificar el Archivo C:\Log_Inventarios'
END
EXEC spCierraArchivo @ManObj, @ManArch
IF @FlagError = 1
BEGIN
UPDATE Aspel_Paso SET
DescripcionInventarios = 'Migración con Errores, Revise Archivo C:\Log_Inventarios.txt'
COMMIT TRANSACTION ASPEL
END
ELSE
BEGIN
SELECT @Conta = COUNT(*) FROM INV
UPDATE Aspel_Paso SET
Inventarios = 1, DescripcionInventarios = 'Importación Correcta', RegistrosInventarios = @Conta
UPDATE Aspel_Paso SET
Inventarios = 1, DescripcionInventarios = 'Importación Correcta', RegistrosInventarios = @Conta
COMMIT TRANSACTION ASPEL
END
Exec spAspelActualizaProcesos 0
IF @FlagError = 1
SELECT 'Migración con Errores, Revise Archivo C:\Log_INV.txt'
ELSE
SELECT 'Importación Correcta'
END

