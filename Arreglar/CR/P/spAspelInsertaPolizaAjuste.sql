SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelInsertaPolizaAjuste]
(
@Estacion	int
)

AS BEGIN
DECLARE
@Modulo				varchar(5),
@FechaEmision		datetime,
@Mov				varchar(20),
@MovID				varchar(20),
@Empresa			varchar(5),
@Moneda				varchar(30),
@TipoCambio			float(15),
@Usuario			varchar(10),
@Estatus			varchar(15),
@Sucursal			int,
@ID					int,
@Renglon			int,
@Cuenta				varchar(20),
@Debe				money,
@Haber				money,
@Observaciones		varchar(100),
@FlagError			bit,
@ManObj				int,
@ManArch			int,
@Cadena				varchar(500),
@Conta				int,
@Rid				int,
@Ok	int,
@OkRef	varchar(255)
IF EXISTS(SELECT Valor FROM AspelCfgOpcion WHERE Descripcion = 'Generar Poliza De Ajuste' AND Valor = 'No') RETURN
SELECT @Usuario = Valor FROM AspelCfg WHERE Descripcion = 'Usuario'
SELECT @Moneda = Valor FROM AspelCfg WHERE Descripcion = 'Moneda'
SELECT @Observaciones = Valor FROM AspelCfg WHERE Descripcion = 'Observaciones'
create table #Pasito
(
Id	int, Descripcion	varchar(500)
)
SET @FlagError = 0
SET @Conta = 0
EXEC spCreaArchivo 'C:\Log_Ajuste.txt', @ManObj OUT, @ManArch OUT
SET @Ok = NULL
BEGIN TRANSACTION ASPEL
UPDATE Aspel_Paso SET
PolizaAjuste = 0, DescripcionPolAjuste = ''
DECLARE crCabecera CURSOR FOR
SELECT Empresa, Sucursal, Modulo, Mov, MovID, FechaEmision, Estatus, RID
FROM AspelCargaReg
WHERE Modulo = 'AJUST'
GROUP BY Empresa, Sucursal, Modulo, Mov, MovID, FechaEmision, Estatus, RID
OPEN crCabecera
FETCH NEXT FROM crCabecera INTO @Empresa, @Sucursal, @Modulo, @Mov, @MovID, @FechaEmision, @Estatus
WHILE @@FETCH_STATUS <> -1
BEGIN
SELECT @Mov = TipoPoliza FROM AspelCargaProp WHERE Campo = 'TipoPoliza' AND Valor = @Mov
INSERT CONT (Empresa,Mov,FechaEmision,FechaContable,UltimoCambio,Moneda,TipoCambio,Usuario,Estatus, Observaciones, Concepto)
VALUES (@Empresa,@Mov,@FechaEmision,@FechaEmision,@FechaEmision,@Moneda,1,@Usuario,@Estatus, @Observaciones, @Observaciones)
SET @ID = SCOPE_IDENTITY()
DECLARE crDetalle CURSOR FOR
SELECT Mayor, ISNULL(Debe,0), ISNULL(Haber,0)
FROM AspelCargaReg
WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND Modulo = @Modulo AND Mov = @Mov AND FechaEmision = @FechaEmision AND
Estatus = @Estatus
SET @Renglon = 0
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO @Cuenta, @Debe, @Haber
WHILE @@FETCH_STATUS <> -1
BEGIN
SET @Renglon = @Renglon + 2048
INSERT CONTD (ID, Renglon, Cuenta, Debe, Haber)
VALUES (@ID, @Renglon, @Cuenta, @Debe, @Haber)
FETCH NEXT FROM crDetalle INTO @Cuenta, @Debe, @Haber
END
CLOSE crDetalle
DEALLOCATE crDetalle
EXEC spAfectar 'CONT', @ID, 'AFECTAR', 'Todo', NULL, @Usuario, 0, 1,@Ok OUTPUT,@OkRef OUTPUT, NULL, 1, @Estacion
IF @Ok IS NOT NULL AND @Ok<80000 BEGIN
SET @OkRef = @OkRef + ', ' + @Modulo + ':' + CONVERT(varchar,@ID)
SET @OkRef = @OkRef + ', ' + @Modulo + ':' + CONVERT(varchar,@ID)
SET @Conta = @Conta + 1
SET @Cadena = 'Modulo ' + @Modulo + ', Mov ' + @Mov + ', MovID ' + @MovID + ', Fecha ' + convert(varchar,@FechaEmision, 103)
Insert Into #Pasito(Id, Descripcion) Values (@Conta, @Cadena)
SET @FlagError = 1
END
FETCH NEXT FROM crCabecera INTO @Empresa, @Sucursal, @Modulo, @Mov, @MovID, @FechaEmision, @Estatus
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
SELECT @Ok = 30230, @OkRef = 'Errores en el Módulo Polizas Ajuste, verificar el Archivo C:\Log_Ajuste'
END
EXEC spCierraArchivo @ManObj, @ManArch
IF @FlagError = 1
BEGIN
UPDATE Aspel_Paso SET
DescripcionPolAjuste = 'Migración con Errores, Revise Archivo C:\Log_Ajuste.txt'
ROLLBACK TRANSACTION ASPEL
END
ELSE
BEGIN
SELECT @Conta = COUNT(*)
FROM AspelCargaReg
WHERE Modulo = 'AJUST'
GROUP BY Empresa, Sucursal, Modulo, Mov, MovID, FechaEmision, Estatus
UPDATE Aspel_Paso SET
PolizaAjuste = 1, DescripcionPolAjuste = 'Importación Correcta', RegistrosPolAjuste = @Conta
COMMIT TRANSACTION ASPEL
END
END

