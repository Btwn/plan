SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelInsertaCompras]
(
@Estacion	int
)

AS BEGIN
DECLARE
@Modulo				varchar(5),
@FechaEmision		datetime,
@Proveedor			varchar(30),
@Mov				varchar(20),
@Empresa			varchar(5),
@Moneda				varchar(30),
@TipoCambio			float(15),
@Usuario			varchar(10),
@Estatus			varchar(15),
@Almacen			varchar(30),
@Importe			money,
@Impuesto			money,
@Sucursal			int,
@ID					int,
@Renglon			int,
@RenglonID			int,
@Cantidad			float(15),
@Articulo			varchar(20),
@Costo				money,
@Descuento1			float(15),
@Impuesto1			float(15),
@Impuesto2			float(15),
@Impuesto3			float(15),
@Observaciones		varchar(30),
@MovID				varchar(20),
@FlagError			bit,
@ManObj				int,
@ManArch			int,
@Cadena				varchar(500),
@Conta				int,
@Rid				int,
@Tipo				varchar(20),
@SerieLote			varchar(20),
@HayLote			int,
@Referencia			varchar(20),
@DescGlobal			float(15),
@Ok					int,
@OkRef				varchar(255),
@MovIdOri			varchar(20),
@Cuenta				int
set @cuenta = 0
UPDATE AspelProcesos SET
Estatus = 1
WHERE Proceso = 'Compras'
SELECT @Usuario = Valor FROM AspelCfg WHERE Descripcion = 'Usuario'
SELECT @Observaciones = Valor FROM AspelCfg WHERE Descripcion = 'Observaciones'
create table #Pasito
(
Id	int, Descripcion	varchar(500)
)
SET @FlagError = 0
SET @Conta = 0
EXEC spCreaArchivo 'C:\Log_Compras.txt', @ManObj OUT, @ManArch OUT
SET @Ok = NULL
BEGIN TRANSACTION ASPEL
UPDATE Aspel_Paso SET
Compras = 0, DescripcionCompras = ''
INSERT COMPRA (Empresa, Mov, FechaEmision, UltimoCambio, Moneda, TipoCambio, Usuario, Estatus, Prioridad,
RenglonID, Proveedor, FechaRequerida, Almacen, Vencimiento, Importe, OrigenTipo, Origen,
FechaEntrega, Sucursal,	Observaciones,SucursalOrigen, Referencia,
DescuentoGlobal, MOVID)
SELECT Empresa, Mov, FechaEmision, FechaEmision, Moneda, TipoCambio, @Usuario, Estatus, 'Normal',
5, Proveedor, FechaEmision, Almacen, FechaEmision, (SUM(ISNULL(Debe,0))+SUM(ISNULL(Haber,0))), 'Usuario', @Usuario,
FechaEmision, Sucursal, @Observaciones+' '+LTRIM(ISNULL(MovID,'')), Sucursal, LTRIM(ISNULL(Referencia,'')),
Gastos, MovID
FROM AspelCargaReg
WHERE Modulo = 'COMS'
GROUP BY Empresa, Sucursal, Modulo, FechaEmision, Mov, MovID, Proveedor, Moneda, TipoCambio, Estatus,
Almacen,Referencia,Gastos
ORDER BY MovID
CREATE TABLE #COMPRAD
(
Consecut		int	IDENTITY(1,1) NOT NULL,
ID				int			NULL,
Renglon			float(15)	NULL,
RenglonID		int			NUll,
Cantidad		float(15)	NUll,
Almacen			varchar(30)	NUll,
Articulo		varchar(20)	NUll,
FechaRequerida	datetime	NUll,
FechaEntrega	datetime	NUll,
Costo			money		NUll,
DescuentoLinea	money		NUll,
Impuesto1		float(15)	NUll,
Impuesto2		float(15)	NUll,
Impuesto3		float(15)	NUll,
Sucursal		int			NUll,
SucursalOrigen	int			NUll,
MovId			varchar(20)	NULL,
Mov				varchar(20) NULL
)
INSERT #COMPRAD (Cantidad, Almacen, Articulo, Costo, DescuentoLinea, Impuesto1,
Impuesto2, Impuesto3, MovId, Mov)
SELECT Cantidad, Almacen, Articulo, Costo, Descuento1, Impuesto1, Impuesto2, Impuesto3, MovId, Mov
FROM AspelCargaReg
WHERE Modulo = 'COMS'
ORDER BY MovID
UPDATE #COMPRAD SET
ID = C.ID, FechaRequerida = C.FechaEmision, FechaEntrega = C.FechaEmision, Sucursal = C.Sucursal, SucursalOrigen = C.Sucursal
FROM #COMPRAD, COMPRA C
WHERE #COMPRAD.MovId = C.MovId and #COMPRAD.Mov = C.Mov
SET @Renglon = 0
SET @RenglonID = 0
DECLARE crCompras CURSOR FOR
SELECT Consecut, MovId
FROM #COMPRAD
FOR UPDATE OF Renglon, RenglonID
OPEN crCompras
FETCH NEXT FROM crCompras INTO @ID, @MovId
SET @MovIdOri = 0
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @MovIdOri <> @MovId
BEGIN
SET @MovIdOri = @MovId
SET @Renglon = 2048
SET @RenglonID = 1
END
ELSE
BEGIN
SET @Renglon = @Renglon + 2048
SET @RenglonID = @RenglonID + 1
END
UPDATE #COMPRAD SET
Renglon = @Renglon, RenglonID = @RenglonID
WHERE CURRENT OF crCompras
FETCH NEXT FROM crCompras INTO @ID, @MovId
END
CLOSE crCompras
DEALLOCATE crCompras
SET @Renglon = @Renglon + 2048
SET @RenglonID = @RenglonID + 1
INSERT COMPRAD (ID,Renglon,RenglonID,Cantidad,Almacen,Articulo,FechaRequerida,FechaEntrega,Costo,DescuentoLinea,Impuesto1,
Impuesto2, Impuesto3, Sucursal, SucursalOrigen)
SELECT  ID,Renglon,RenglonID,Cantidad,Almacen,Articulo,FechaRequerida,FechaEntrega,Costo,DescuentoLinea,Impuesto1,
Impuesto2, Impuesto3, Sucursal, SucursalOrigen from #COMPRAD
ORDER BY Consecut
DECLARE crCabecera CURSOR FOR
SELECT 'COMS', ID, Usuario, MovID, Mov
FROM COMPRA WHERE MOV = (select MovDebenocontable from aspelcfgmodulomayor where Modulo = 'COMS' )
or MOV = (select MovHabernocontable from aspelcfgmodulomayor where Modulo = 'COMS' )
ORDER BY ID
OPEN crCabecera
FETCH NEXT FROM crCabecera INTO @Modulo, @ID, @Usuario, @MovID, @Mov
WHILE @@FETCH_STATUS <> -1
BEGIN
EXEC spAfectar @Modulo, @ID, 'AFECTAR', 'Todo', NULL, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT, NULL, 1, @Estacion
IF @Ok IS NOT NULL 
BEGIN
SELECT @Ok, @Modulo, @Mov, @MovID
SELECT @OkRef = @OkRef + ', ' + @Modulo + ':' + CONVERT(varchar,@ID) + @Mov +', ' + MovID FROM Compra WHERE ID = @ID
SET @OkRef = @OkRef + ', ' + @Modulo + ':' + CONVERT(varchar,@ID)
SET @Conta = @Conta + 1
SET @Cadena = 'Modulo ' + @Modulo + ', Mov ' + @Mov + ', MovID ' + isnull(@MovID, 'Sin MovID') 
Insert Into #Pasito(Id, Descripcion) Values (@Conta, @Cadena)
SET @FlagError = 1
END
FETCH NEXT FROM crCabecera INTO  @Modulo, @ID, @Usuario, @MovID, @Mov
END
CLOSE crCabecera
DEALLOCATE crCabecera
UPDATE AspelProcesos SET
Estatus = 1
WHERE Proceso = 'Compras'
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
SELECT @Ok = 30230, @OkRef = 'Errores en el Módulo Compras, verificar el Archivo C:\Log_Compras'
COMMIT TRANSACTION ASPEL
UPDATE Aspel_Paso SET
DescripcionCompras = 'Migración con Errores, Revise Archivo C:\Log_Compras.txt'
END
ELSE
BEGIN
SELECT @Conta = COUNT(*) FROM COMPRA
UPDATE Aspel_Paso SET
Compras = 1, DescripcionCompras = 'Importación Correcta', RegistrosCompras = @Conta
COMMIT TRANSACTION ASPEL
END
EXEC spCierraArchivo @ManObj, @ManArch
Exec spAspelActualizaProcesos 0
IF @FlagError = 1
SELECT 'Migración con Errores, Revise Archivo C:\Log_Compras.txt'
ELSE
SELECT 'Importación Correcta'
END

