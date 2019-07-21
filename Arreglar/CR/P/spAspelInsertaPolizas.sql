SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelInsertaPolizas]
(
@Estacion	int
)

AS BEGIN
DECLARE
@Modulo				varchar(5),
@FechaEmision		datetime,
@Mov				varchar(20),
@MovID			varchar(20),
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
@Digitos			int,
@Formato			varchar(24),
@Observaciones		varchar(100),
@FlagError			bit,
@ManObj				int,
@ManArch			int,
@Cadena				varchar(500),
@Conta				int,
@Rid				int,
@ConceptoC			varchar(50),
@Concepto			varchar(50),
@Subcuenta			varchar(50),
@ImportaCOI			bit,
@Ok					int,
@OkRef				varchar(255)
UPDATE AspelProcesos SET
Estatus = 1
WHERE Proceso = 'Polizas'
UPDATE AspelCargaReg
SET Mov = C.TipoPoliza
FROM AspelCargaReg A, AspelCargaProp C
WHERE A.Referencia = C.Valor
AND A.Mov IS NULL
SELECT @Usuario = Valor FROM AspelCfg WHERE Descripcion = 'Usuario'
SELECT @Moneda = Valor FROM AspelCfg WHERE Descripcion = 'Moneda'
SELECT @Observaciones = Valor FROM AspelCfg WHERE Descripcion = 'Observaciones'
SELECT @Formato = Valor FROM AspelCfgOpcion WHERE Descripcion = 'Formato Cuentas Contables'
SET @Digitos = LEN(REPLACE(REPLACE(RTRIM(LTRIM(@Formato)),'-',''),';2',''))
SET @Digitos = CASE WHEN @Digitos = 0 THEN 20 ELSE @Digitos END
SELECT @ImportaCOI = CASE WHEN Valor = 'Si' THEN 1 ELSE 0 END FROM AspelCfgOpcion WHERE Descripcion = 'Importar COI'
create table #Pasito
(
Id	int, Descripcion	varchar(500)
)
SET @FlagError = 0
SET @Conta = 0
EXEC spCreaArchivo 'C:\Log_Polizas.txt', @ManObj OUT, @ManArch OUT
SET @Ok = NULL
BEGIN TRANSACTION ASPEL
UPDATE Aspel_Paso SET
Polizas = 0, DescripcionPolizas = ''
IF @ImportaCOI = 1
Begin
EXEC spPolizasIniciales
End
DECLARE crCabecera CURSOR FOR
SELECT Empresa, Sucursal, Modulo, Mov, MovID, /*TipoCambio,*/FechaEmision, Estatus, Clase + Subclase
FROM AspelCargaReg
WHERE Modulo = 'CONT'
GROUP BY Empresa, Sucursal, Modulo, Mov, MovID, /*TipoCambio,*/ FechaEmision, Estatus, Clase+Subclase
OPEN crCabecera
FETCH NEXT FROM crCabecera INTO @Empresa, @Sucursal, @Modulo, @Mov, @MovID, /*@TipoCambio,*/ @FechaEmision, @Estatus, @ConceptoC
WHILE @@FETCH_STATUS <> -1
BEGIN
SELECT @Mov = TipoPoliza FROM AspelCargaProp WHERE Campo = 'TipoPoliza' AND Valor = @Mov
INSERT CONT (Empresa,Mov,FechaEmision,FechaContable,UltimoCambio,Moneda,TipoCambio,Usuario,Estatus,
Observaciones, Referencia, MOVID)
VALUES (@Empresa,@Mov,@FechaEmision,@FechaEmision,@FechaEmision,@Moneda,1/*@TipoCambio*/,@Usuario,@Estatus,
@ConceptoC,  LTRIM(RTRIM(@Observaciones)) + ' ' + LTRIM(RTRIM(@MovID)) + ' ' + LTRIM(RTRIM(@Mov)), ltrim(rtrim(@MOVID)) )
SET @ID = SCOPE_IDENTITY()
DECLARE crDetalle CURSOR FOR
SELECT dbo.fnAspelFormateaCuentas(LEFT(Mayor,@Digitos),@Formato), ISNULL(Debe,0), ISNULL(Haber,0),Centrocostos, concepto
FROM AspelCargaReg
WHERE Empresa = @Empresa AND Sucursal = @Sucursal AND Modulo = @Modulo AND Mov = @Mov AND FechaEmision = @FechaEmision /*AND TipoCambio = @TipoCambio*/ AND
Estatus = @Estatus AND MovID = @MovID
SET @Renglon = 0
OPEN crDetalle
FETCH NEXT FROM crDetalle INTO @Cuenta, @Debe, @Haber, @Subcuenta , @Concepto
WHILE @@FETCH_STATUS <> -1
BEGIN
SET @Renglon = @Renglon + 2048
INSERT CONTD (ID, Renglon, Cuenta, Debe, Haber,Subcuenta, Concepto)
VALUES (@ID, @Renglon, @Cuenta, @Debe, @Haber,@Subcuenta, @concepto)
FETCH NEXT FROM crDetalle INTO @Cuenta, @Debe, @Haber, @Subcuenta , @Concepto
END
CLOSE crDetalle
DEALLOCATE crDetalle
EXEC spAfectar @Modulo, @ID, 'AFECTAR', 'Todo', NULL, @Usuario, 0, 1,@Ok OUTPUT,@OkRef OUTPUT, NULL, 1, @Estacion
IF @Ok IS NOT NULL AND @Ok<80000 BEGIN
SET @OkRef = @OkRef + ', ' + @Modulo + ':' + CONVERT(varchar,@ID)
SET @OkRef = @OkRef + ', ' + @Modulo + ':' + CONVERT(varchar,@ID)
SET @Conta = @Conta + 1
SET @Cadena = 'Modulo ' + @Modulo + ', Mov ' + @Mov + ', MovID ' + @MovID + ', Fecha ' + convert(varchar,@FechaEmision, 103)
Insert Into #Pasito(Id, Descripcion) Values (@Conta, @Cadena)
SET @FlagError = 1
END
FETCH NEXT FROM crCabecera INTO @Empresa, @Sucursal, @Modulo, @Mov, @MovID, /*@TipoCambio,*/ @FechaEmision, @Estatus, @ConceptoC
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
SELECT @Ok = 30230, @OkRef = 'Errores en el Módulo Polizas, verificar el Archivo C:\Log_Polizas'
END
EXEC spCierraArchivo @ManObj, @ManArch
IF @FlagError = 1
BEGIN
UPDATE Aspel_Paso SET
DescripcionPolizas = 'Migración con Errores, Revise Archivo C:\Log_Polizas.txt'
COMMIT TRANSACTION ASPEL
END
ELSE
BEGIN
SELECT @Conta = COUNT(*)
FROM AspelCargaReg
WHERE Modulo = 'CONT'
GROUP BY Empresa, Sucursal, Modulo, Mov, MovID, FechaEmision, Estatus
UPDATE Aspel_Paso SET
Polizas = 1, DescripcionPolizas = 'Importación Correcta', RegistrosPolizas = @Conta
COMMIT TRANSACTION ASPEL
END
Exec spAspelActualizaProcesos 0
IF @FlagError = 1
SELECT 'Migración con Errores, Revise Archivo C:\Log_Polizas.txt'
ELSE
SELECT 'Importación Correcta'
END

