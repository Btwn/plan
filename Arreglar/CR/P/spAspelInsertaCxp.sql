SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelInsertaCxp]
(
@Estacion	int
)

AS BEGIN
DECLARE
@Modulo				varchar(5),
@FechaEmision		datetime,
@Vencimiento		datetime,
@Proveedor			varchar(30),
@Mov				varchar(20),
@Empresa			varchar(5),
@Moneda				varchar(30),
@TipoCambio			float(15),
@Usuario			varchar(10),
@Estatus			varchar(15),
@Importe			money,
@Impuesto			money,
@Sucursal			int,
@ID					int,
@Observaciones		varchar(30),
@FlagError			bit,
@ManObj				int,
@ManArch			int,
@Cadena				varchar(500),
@Conta				int,
@MovID				varchar(20),
@Rid				int,
@Referencia			varchar(50),
@Factura			varchar(10),
@Ok	int,
@OkRef	varchar(255),
@IVADESGLOSA FLOAT,
@Ivafiscal	float,
@iepsfiscal float
UPDATE AspelProcesos SET
Estatus = 1
WHERE Proceso = 'CxP'
SELECT @Usuario = Valor FROM AspelCfg WHERE Descripcion = 'Usuario'
SELECT @Observaciones = Valor FROM AspelCfg WHERE Descripcion = 'Observaciones'
SET @IVADESGLOSA = 1.15
create table #Pasito
(
Id	int, Descripcion	varchar(500)
)
SET @FlagError = 0
SET @Conta = 0
EXEC spCreaArchivo 'C:\Log_CxP.txt', @ManObj OUT, @ManArch OUT
SET @Ok = NULL
BEGIN TRANSACTION ASPEL
UPDATE Aspel_Paso SET
CuentasPorPagar = 0, DescripcionCxP = ''
DECLARE crCabecera CURSOR FOR
SELECT Empresa, Sucursal, Modulo, FechaEmision, Proveedor, Mov, Moneda, TipoCambio, Estatus,
ABS((SUM(ISNULL(Debe,0))+SUM(ISNULL(Haber,0)))) Importe, MovId, Referencia, MovId, Vencimiento, Impuesto1,Impuesto2
FROM AspelCargaReg
WHERE Modulo = 'CXP'
GROUP BY Empresa, Sucursal, Modulo, FechaEmision, Proveedor, Mov, Moneda, TipoCambio, Estatus, MovId, Referencia, MovId, Vencimiento,Impuesto1, Impuesto2
OPEN crCabecera
FETCH NEXT FROM crCabecera INTO @Empresa, @Sucursal, @Modulo, @FechaEmision, @Proveedor, @Mov, @Moneda, @TipoCambio, @Estatus, @Importe, @MovID, @Referencia, @Factura, @Vencimiento, @Ivafiscal, @Iepsfiscal
WHILE @@FETCH_STATUS <> -1
BEGIN
INSERT CXP (Empresa,Mov,FechaEmision,UltimoCambio,Moneda,TipoCambio,Usuario,Estatus,Proveedor,ProveedorMoneda,
ProveedorTipoCambio,Condicion,Vencimiento,FormaPago,Importe,Impuestos,FechaRegistro,Concepto,Observaciones, Referencia,MOVID,IvaFiscal, Iepsfiscal)
VALUES (@Empresa,@Mov,@FechaEmision,@FechaEmision,@Moneda,@TipoCambio,@Usuario,@Estatus,@Proveedor,@Moneda,
@TipoCambio,'(Fecha)',@Vencimiento,'Cheque',@Importe-(@Importe*@Ivafiscal)-(@Importe*@Iepsfiscal),(@Importe*@Ivafiscal)+(@Importe*@Iepsfiscal),@FechaEmision,@Observaciones,@Factura, @Referencia,@MOVID,@ivafiscal,@iepsfiscal)
SET @ID = SCOPE_IDENTITY()
EXEC spAfectar @Modulo, @ID, 'AFECTAR', 'Todo', NULL, @Usuario, 0, 1,@Ok OUTPUT, @OkRef OUTPUT, NULL, 1, @Estacion
IF @Ok IS NOT NULL AND @Ok<80000 BEGIN
SET @OkRef = @OkRef + ', ' + @Modulo + ':' + CONVERT(varchar,@ID)
SET @OkRef = @OkRef + ', ' + @Modulo + ':' + CONVERT(varchar,@ID)
SET @Conta = @Conta + 1
SET @Cadena = 'Modulo ' + @Modulo + ', Mov ' + @Mov + ', MovID ' + @MovID + ', Fecha ' + convert(varchar,@FechaEmision, 103) + ', Proveedor ' + @Proveedor
Insert Into #Pasito(Id, Descripcion) Values (@Conta, @Cadena)
SET @FlagError = 1
END
FETCH NEXT FROM crCabecera INTO @Empresa, @Sucursal, @Modulo, @FechaEmision, @Proveedor, @Mov, @Moneda, @TipoCambio, @Estatus, @Importe, @MovID, @Referencia, @Factura, @Vencimiento, @Ivafiscal, @Iepsfiscal
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
SELECT @Ok = 30230, @OkRef = 'Errores en el Módulo CxP, verificar el Archivo C:\Log_CxP'
END
EXEC spCierraArchivo @ManObj, @ManArch
IF @FlagError = 1
BEGIN
UPDATE Aspel_Paso SET
DescripcionCxP = 'Migración con Errores, Revise Archivo C:\Log_CxP.txt'
COMMIT TRANSACTION ASPEL
END
ELSE
BEGIN
SELECT @Conta = COUNT(*) FROM CXP
UPDATE Aspel_Paso SET
CuentasPorPagar = 1, DescripcionCxP = 'Importación Correcta', RegistrosCxP = @Conta
COMMIT TRANSACTION ASPEL
END
Exec spAspelActualizaProcesos 0
IF @FlagError = 1
SELECT 'Migración con Errores, Revise Archivo C:\Log_CXp.txt'
ELSE
SELECT 'Importación Correcta'
END

