SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelInsertaCxc]
(
@Estacion	int
)

AS BEGIN
DECLARE
@Modulo				varchar(5),
@FechaEmision		datetime,
@Vencimiento		datetime,
@Cliente			varchar(30),
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
@Referencia			varchar(50),
@Ok					int,
@OkRef				varchar(255),
@IVADESGLOSA		FLOAT,
@Ivafiscal	float,
@iepsfiscal float
UPDATE AspelProcesos SET
Estatus = 1
WHERE Proceso = 'CxC'
SELECT @Usuario = Valor FROM AspelCfg WHERE Descripcion = 'Usuario'
SET @IVADESGLOSA = 1.15
declare
@MovID	varchar(20),
@Rid	int
create table #Pasito
(
Id	int, Descripcion	varchar(500)
)
SET @FlagError = 0
SET @Conta = 0
EXEC spCreaArchivo 'C:\Log_CxC.txt', @ManObj OUT, @ManArch OUT
SET @Ok = NULL
BEGIN TRANSACTION ASPEL
UPDATE Aspel_Paso SET
CuentasPorCobrar = 0, DescripcionCxC = ''
DECLARE crCabecera CURSOR FOR
SELECT Empresa, Sucursal, Modulo, FechaEmision, Cliente, Mov, Moneda, TipoCambio, Estatus, (SUM(ISNULL(Debe,0))+SUM(ISNULL(Haber,0))) Importe,
MovId, Referencia, Vencimiento, concepto, Impuesto1, Impuesto2
FROM AspelCargaReg
WHERE Modulo = 'CXC'
GROUP BY Empresa, Sucursal, Modulo, FechaEmision, Cliente, Mov, Moneda, TipoCambio, Estatus,  MovId, Referencia, Vencimiento, concepto,Impuesto1, Impuesto2
OPEN crCabecera
FETCH NEXT FROM crCabecera INTO @Empresa, @Sucursal, @Modulo, @FechaEmision, @Cliente, @Mov, @Moneda, @TipoCambio, @Estatus, @Importe,  @MovID, @Referencia, @Vencimiento, @Observaciones, @ivafiscal,@iepsfiscal
WHILE @@FETCH_STATUS <> -1
BEGIN
INSERT CXC (Empresa,Mov,FechaEmision,UltimoCambio,Moneda,TipoCambio,Usuario,Estatus,Cliente,ClienteMoneda,ClienteTipoCambio,Condicion,Vencimiento,FormaCobro,Importe,Impuestos,Concepto,Observaciones, Referencia, MOVID, Ivafiscal, Iepsfiscal)
VALUES (@Empresa,@Mov,@FechaEmision,@FechaEmision,@Moneda,@TipoCambio,@Usuario,@Estatus,@Cliente,@Moneda,@TipoCambio,'(Fecha)',@Vencimiento,'Cheque',@Importe-(@Importe*@Ivafiscal)-(@Importe*@Iepsfiscal),(@Importe*@Ivafiscal)+(@Importe*@Iepsfiscal),'Aspel',@Observaciones, @Referencia, @MOVID,@Ivafiscal,@iepsfiscal)
SET @ID = SCOPE_IDENTITY()
EXEC spAfectar @Modulo, @ID, 'AFECTAR', 'Todo', NULL, @Usuario, 0, 1, @Ok OUTPUT, @OkRef OUTPUT, NULL, 1, @Estacion
IF @Ok IS NOT NULL AND @Ok<80000 BEGIN
SET @OkRef = @OkRef + ', ' + @Modulo + ':' + CONVERT(varchar,@ID)
SET @Conta = @Conta + 1
SET @Cadena = 'Modulo ' + @Modulo + ', Mov ' + @Mov + ', MovID ' + @MovID + ', Fecha ' + convert(varchar,@FechaEmision, 103) + ', Cliente ' + @Cliente
Insert Into #Pasito(Id, Descripcion) Values (@Conta, @Cadena)
SET @FlagError = 1
END
FETCH NEXT FROM crCabecera INTO @Empresa, @Sucursal, @Modulo, @FechaEmision, @Cliente, @Mov, @Moneda, @TipoCambio, @Estatus, @Importe,  @MovID, @Referencia, @Vencimiento, @Observaciones, @ivafiscal,@iepsfiscal
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
SELECT @Ok = 30230, @OkRef = 'Errores en el Módulo CxC, verificar el Archivo C:\Log_CxC'
END
EXEC spCierraArchivo @ManObj, @ManArch
IF @FlagError = 1
BEGIN
UPDATE Aspel_Paso SET
DescripcionCxC = 'Migración con Errores, Revise Archivo C:\Log_CxC.txt'
COMMIT TRANSACTION ASPEL
END
ELSE
BEGIN
SELECT @Conta = COUNT(*) FROM CXC
UPDATE Aspel_Paso SET
CuentasPorCobrar = 1, DescripcionCxC = 'Importación Correcta', RegistrosCxC = @Conta
COMMIT TRANSACTION ASPEL
END
Exec spAspelActualizaProcesos 0
IF @FlagError = 1
SELECT 'Migración con Errores, Revise Archivo C:\Log_CXC.txt'
ELSE
SELECT 'Importación Correcta'
END

