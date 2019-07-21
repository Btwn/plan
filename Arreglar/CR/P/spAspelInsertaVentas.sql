SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelInsertaVentas]
(
@Estacion	int
)

AS BEGIN
DECLARE
@Modulo				varchar(5),
@FechaEmision		datetime,
@Cliente			varchar(30),
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
@Precio				money,
@Impuesto1			float(15),
@Impuesto2			float(15),
@Impuesto3			float(15),
@Descuento1			float(15),
@Descuento2			float(15),
@Costo				money,
@Observaciones		varchar(30),
@MovId				varchar(20),
@MovIdOri			varchar(20),
@FlagError			bit,
@ManObj				int,
@ManArch			int,
@Cadena				varchar(500),
@Conta				int,
@Rid				int,
@Agente				varchar(10),
@Tipo				varchar(20),
@SerieLote			varchar(20),
@HayLote			int,
@DescGlobal			float(15),
@Ok	int,
@OkRef	varchar(255),
@cuenta int
UPDATE AspelProcesos SET
Estatus = 1
WHERE Proceso = 'Facturas'
SELECT @Usuario = Valor FROM AspelCfg WHERE Descripcion = 'Usuario'
SELECT @Observaciones = Valor FROM AspelCfg WHERE Descripcion = 'Observaciones'
create table #Pasito
(
Id	int, Descripcion	varchar(500)
)
SET @FlagError = 0
SET @Conta = 0
EXEC spCreaArchivo 'C:\Log_Ventas.txt', @ManObj OUT, @ManArch OUT
SET @Ok = NULL
BEGIN TRANSACTION ASPEL
UPDATE Aspel_Paso SET
Ventas = 0, DescripcionVentas = ''
INSERT VENTA (Empresa,Mov,FechaEmision,UltimoCambio,Moneda,TipoCambio,Usuario,Estatus,Directo,Prioridad,RenglonID,Cliente,Almacen,FechaRequerida,
Vencimiento,Importe,ServicioGarantia,ServicioFlotilla,ServicioRampa,ServicioExpress,ServicioDemerito,ServicioDeducible,ServicioPuntual, GenerarPoliza,Extra,Sucursal,GenerarOP,DesglosarImpuestos,
DesglosarImpuesto2,ExcluirPlaneacion,ConVigencia,EstaImpreso,SubModulo,Logico1,Logico2,Logico3,Logico4,EspacioResultado,Comentarios,GenerarDinero,DineroConciliado,Extra1,Extra2,
Extra3,Reabastecido,SucursalVenta,AF,FordVisitoOASIS,TieneTasaEsp,SucursalOrigen,Observaciones, Agente, Referencia, DescuentoGlobal,MOVID)
SELECT Empresa, Mov, FechaEmision, FechaEmision, Moneda, TipoCambio, @Usuario, Estatus, 1, 'Normal', 4, Cliente, Almacen, FechaEmision,
FechaEmision, (SUM(ISNULL(Debe,0))+SUM(ISNULL(Haber,0))), 0, 0, 0, 0, 0, 0, 0, 0, 0,Sucursal, 0, 0,
0, 0, 0, 0, 'VTAS', 0, 0, 0, 0, 0, ' ', 0, 0, 0, 0,
0, 0, Sucursal, 0, 0, 0, Sucursal, @Observaciones + ' ' + LTRIM(ISNULL(MovID,'')), Agente, @Observaciones + ' ' + LTRIM(ISNULL(MovID,'')), Gastos,MovID
FROM AspelCargaReg
WHERE Modulo = 'VTAS'
GROUP BY Empresa, Sucursal, Modulo, FechaEmision, Cliente, Mov, MovID, Moneda, TipoCambio, Estatus, Almacen, Agente, Gastos
CREATE TABLE #VENTAD
(
Consecut		int			IDENTITY(1,1)	NOT NULL,
ID 				int 		NULL,	Renglon			float(15)	NULL,	RenglonID		int			NULL,
Cantidad		float(15)	NULL,	Almacen			varchar(30)	NULL,	Articulo		varchar(20)	NULL,
Precio			float(15)	NULL,	PrecioSugerido	float(15)	NULL,	Impuesto1		float(15)	NULL,
Impuesto2		float(15)	NULL,	Impuesto3		float(15)	NULL,	DescuentoLinea	money		NULL,
Costo			money		NULL,	FechaRequerida	datetime	NULL,	PrecioMoneda	varchar(10)	NULL,
PrecioTipoCambio float(15)	NULL,	MovId			varchar(20)	NULL, Mov varchar(20) NULL,Subcuenta varchar(50) null
)
INSERT #VENTAD (Cantidad, Almacen, Articulo, Precio, PrecioSugerido, Impuesto1, Impuesto2, Impuesto3, DescuentoLinea,
Costo, FechaRequerida, PrecioMoneda, PrecioTipoCambio, MovId, Mov, Subcuenta)
SELECT Cantidad, Almacen, Articulo, Precio, Precio, Impuesto1, Impuesto2, Impuesto3, Descuento1,
Costo, FechaEmision, Moneda, TipoCambio, MovID, Mov, subcuenta
FROM AspelCargaReg
WHERE Modulo = 'VTAS'
ORDER BY MovID
UPDATE #VENTAD SET
ID = C.ID,FechaRequerida = C.FechaEmision
FROM #VENTAD D, VENTA C
WHERE D.MovId = C.MovId AND D.Mov = C.Mov
SET @Renglon = 0
SET @RenglonID = 0
set @cuenta = 0
DECLARE crVentas CURSOR  FOR
SELECT Consecut, MovId
FROM #VENTAD
FOR UPDATE OF Renglon, RenglonID
OPEN crVentas
FETCH NEXT FROM crVentas INTO @ID, @MovId
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
UPDATE #VENTAD SET
Renglon = @Renglon, RenglonID = @RenglonID
WHERE CURRENT OF crVentas
FETCH NEXT FROM crVentas INTO @ID, @MovId
END
CLOSE crVentas
DEALLOCATE crVentas
INSERT VENTAD (ID, Renglon, RenglonID, Cantidad, Almacen, Articulo, Precio, PrecioSugerido, Impuesto1, Impuesto2, Impuesto3,
DescuentoLinea, Costo, FechaRequerida, PrecioMoneda, PrecioTipoCambio)
SELECT ID, Renglon, RenglonID, Cantidad, Almacen, Articulo, Precio, PrecioSugerido, Impuesto1, Impuesto2, Impuesto3,
DescuentoLinea, Costo, FechaRequerida, PrecioMoneda, PrecioTipoCambio
FROM #VENTAD
ORDER BY Consecut
set @cuenta =0
DECLARE crCabecera CURSOR  FOR
SELECT 'VTAS', ID, Usuario
FROM VENTA WHERE MOV in ('Sae Factura','Sae Devolución')
ORDER BY ID
OPEN crCabecera
FETCH NEXT FROM crCabecera INTO @Modulo, @ID, @Usuario
WHILE @@FETCH_STATUS <> -1
BEGIN
EXEC spAfectar @Modulo, @ID, 'AFECTAR', 'Todo', NULL, @Usuario, 0, 1, @Ok, @OkRef, NULL, 1, @Estacion
IF @Ok IS NOT NULL AND @Ok<80000
BEGIN
SET @OkRef = @OkRef + ', ' + @Modulo + ':' + CONVERT(varchar,@ID)
SET @Conta = @Conta + 1
SET @Cadena = 'Modulo ' + @Modulo + ', Mov ' + @Mov + ', MovID ' + isnull(@MovID, 'Sin MovID') + ', Fecha ' + isnull(convert(varchar,@FechaEmision, 103),'')
Insert Into #Pasito(Id, Descripcion) Values (@Conta, @Cadena)
SET @FlagError = 1
END
FETCH NEXT FROM crCabecera INTO @Modulo, @ID, @Usuario
END
CLOSE crCabecera
DEALLOCATE crCabecera
UPDATE AspelProcesos SET
Estatus = 0
WHERE Proceso = 'Facturas'
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
SELECT @Ok = 30230, @OkRef = 'Errores en el Módulo Ventas, verificar el Archivo C:\Log_Ventas'
COMMIT TRANSACTION ASPEL
UPDATE Aspel_Paso SET
DescripcionvENTAS = 'Migración con Errores, Revise Archivo C:\Log_Ventas.txt'
END
ELSE
BEGIN
SELECT @Conta = COUNT(*) FROM VENTA
UPDATE Aspel_Paso SET
Ventas = 1, DescripcionVentas = 'Importación Correcta', RegistrosVentas = @Conta
COMMIT TRANSACTION ASPEL
END
EXEC spCierraArchivo @ManObj, @ManArch
IF @FlagError = 1
SELECT 'Migración con Errores, Revise Archivo C:\Log_CXC.txt'
ELSE
SELECT 'Importación Correcta'
END

