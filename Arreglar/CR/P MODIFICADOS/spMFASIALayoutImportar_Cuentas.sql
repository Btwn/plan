SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMFASIALayoutImportar_Cuentas
@Usuario					varchar(20),
@Empresa					varchar(5),
@Ejercicio				int,
@Periodo					int,
@SIABaseIndependiente	bit,
@SIABaseDatos			varchar(255)

AS BEGIN
SET NOCOUNT ON
DECLARE @Moneda		varchar(10),
@SQL			nvarchar(max),
@BaseDatos	varchar(255),
@Parametros	nvarchar(max)
SELECT @BaseDatos = DB_NAME()
IF @SIABaseIndependiente = 0 SELECT @SIABaseDatos = DB_NAME()
SELECT @Moneda = ContMoneda FROM EmpresaCfg  WITH (NOLOCK) WHERE Empresa = @Empresa
SELECT @Parametros = '@Empresa	varchar(5),
@Ejercicio	int,
@Periodo	int'
SELECT @SQL = 'DELETE ' + @SIABaseDatos + '.dbo.tmpPolizas WHERE ID_empresa = @Empresa AND Ejercicio = @Ejercicio AND Periodo = @Periodo'
EXEC sp_executesql @SQL, @Parametros, @Empresa = @Empresa, @Ejercicio = @Ejercicio, @Periodo = @Periodo
SELECT @SQL = 'DELETE ' + @SIABaseDatos + '.dbo.tmpSaldo_Inicial WHERE ID_empresa = @Empresa AND Ejercicio = @Ejercicio AND Periodo = @Periodo'
EXEC sp_executesql @SQL, @Parametros, @Empresa = @Empresa, @Ejercicio = @Ejercicio, @Periodo = @Periodo
SELECT @Parametros = '@Empresa	varchar(5)'
SELECT @SQL = 'DELETE ' + @SIABaseDatos + '.dbo.tmpEmpresas WHERE ID_empresa = @Empresa'
EXEC sp_executesql @SQL, @Parametros, @Empresa = @Empresa
SELECT @SQL = 'DELETE ' + @SIABaseDatos + '.dbo.tmpContactos WHERE ID_empresa = @Empresa'
EXEC sp_executesql @SQL, @Parametros, @Empresa = @Empresa
SELECT @SQL = 'DELETE ' + @SIABaseDatos + '.dbo.tmpCuentas_Contables WHERE ID_empresa = @Empresa'
EXEC sp_executesql @SQL, @Parametros, @Empresa = @Empresa
SELECT @SQL = 'INSERT INTO ' + @SIABaseDatos + '.dbo.tmpEmpresas(
ID_empresa, Nombre, Grupo, Direccion, DireccionNumero, DireccionNumeroInt, Clave_ciudad, CodigoPostal, Telefonos, RFC)
SELECT ID_empresa, Nombre, Grupo, Direccion, DireccionNumero, DireccionNumeroInt, Clave_ciudad, CodigoPostal, Telefonos, RFC
FROM ' + @BaseDatos + '.dbo.MFAEmpresa
WHERE ID_empresa = @Empresa'
EXEC sp_executesql @SQL, @Parametros, @Empresa = @Empresa
SELECT @SQL = 'INSERT INTO ' + @SIABaseDatos + '.dbo.tmpContactos(
Clave, Nombres, Apellidos, Puesto, Telefono, Email, ID_empresa)
SELECT Clave, Nombres, Apellidos, Puesto, Telefono, Email, @Empresa
FROM MFAContacto WITH (NOLOCK) '
EXEC sp_executesql @SQL, @Parametros, @Empresa = @Empresa
SELECT @SQL = 'INSERT INTO ' + @SIABaseDatos + '.dbo.tmpCuentas_Contables(
ID_empresa, Cuenta_contable, Cuenta_control, Descripcion, Clase_cuenta, Moneda, Estatus, ID_impuesto)
SELECT Empresa,    Cuenta_contable, Cuenta_control, Descripcion, Clase_cuenta, Moneda, Estatus, ''''
FROM MFACuentaContable WITH (NOLOCK) 
WHERE Empresa = @Empresa'
EXEC sp_executesql @SQL, @Parametros, @Empresa = @Empresa
SELECT @Parametros = '@Empresa	varchar(5),
@Ejercicio	int,
@Periodo	int'
SELECT @SQL = 'INSERT INTO ' + @SIABaseDatos + '.dbo.tmpPolizas(
ID_empresa, Cuenta_contable, Ejercicio, Periodo, Debe, Haber, Tipo_moneda, Tipo_cambio, ID_concepto, ID_recordatorio, Referencia, Origen_modulo)
SELECT Empresa,    Cuenta_contable, Ejercicio, Periodo, Debe, Haber, Tipo_moneda, Tipo_cambio, ID_concepto, ID_recordatorio, Referencia, Origen_modulo
FROM MFAPolizas WITH (NOLOCK) 
WHERE Empresa = @Empresa
AND Ejercicio = @Ejercicio
AND Periodo = @Periodo'
EXEC sp_executesql @SQL, @Parametros, @Empresa = @Empresa, @Ejercicio = @Ejercicio, @Periodo = @Periodo
SELECT @Parametros = '@Empresa	varchar(5),
@Ejercicio	int,
@Periodo	int,
@Moneda		varchar(10)'
SELECT @SQL = 'INSERT INTO ' + @SIABaseDatos + '.dbo.tmpSaldo_Inicial(
ID_empresa, Cuenta_contable, Ejercicio,   Periodo, Saldo_inicial_debe,                                                                                                                                                                                                     Saldo_inicial_haber)
SELECT @Empresa,    Cuenta,          @Ejercicio, @Periodo, CASE EsAcreedora WHEN 0 THEN dbo.fnMFACuentaSaldoInicial(@Empresa,@Ejercicio,@Periodo,Cuenta, @Moneda, ''Cargos'') - dbo.fnMFACuentaSaldoInicial(@Empresa,@Ejercicio,@Periodo, Cuenta, @Moneda, ''Abonos'') ELSE 0 END, CASE EsAcreedora WHEN 1 THEN dbo.fnMFACuentaSaldoInicial(@Empresa,@Ejercicio,@Periodo,Cuenta, @Moneda, ''Cargos'') - dbo.fnMFACuentaSaldoInicial(@Empresa,@Ejercicio,@Periodo, Cuenta, @Moneda, ''Abonos'') ELSE 0 END
FROM MFASaldoInicial WITH (NOLOCK) '
EXEC sp_executesql @SQL, @Parametros, @Empresa = @Empresa, @Ejercicio = @Ejercicio, @Periodo = @Periodo, @Moneda = @Moneda
SELECT @Parametros = '@Empresa	varchar(5),
@Ejercicio	int,
@Periodo	int'
SELECT @SQL = 'INSERT INTO ' + @SIABaseDatos + '.dbo.tmpSaldo_Inicial(
ID_empresa, Cuenta_contable,  Ejercicio,  Periodo, Saldo_inicial_debe,   Saldo_inicial_haber)
SELECT @Empresa,    cuenta_contable, @Ejercicio, @Periodo, saldo_inicial_cargos, saldo_inicial_abonos
FROM MFASaldoInicialComp WITH (NOLOCK) '
EXEC sp_executesql @SQL, @Parametros, @Empresa = @Empresa, @Ejercicio = @Ejercicio, @Periodo = @Periodo
END

