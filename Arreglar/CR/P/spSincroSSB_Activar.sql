SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroSSB_Activar

AS BEGIN
DECLARE
@Sucursal			int,
@SincroSSB			bit,
@MismaInstancia		bit,
@SQL			varchar(max),
@CertificadoDialogo		varchar(255),
@CertificadoDialogoArchivo	varchar(255),
@PuertoSSB			int,
@RutaCertificados		varchar(100),
@BaseLocal			varchar(100),
@ServicioLocal		varchar(100),
@UsuarioLocal		varchar(100)
CREATE TABLE #Resultado (ID int IDENTITY(1,1) NOT NULL PRIMARY KEY, SQL varchar(255) NULL)
/*
Dominio\DominioUsuario = usuario que inicia el servicio de SQL en matriz y sucusales, y debe pertenecer al rol de servidor sysadmin, esto se puede consultar viendo las propiedades del login (inicio de sesion), en funciones del servidor. en el modulo central lo creamos con codigo de SQL
*/
SELECT @BaseLocal = DB_NAME()
SELECT @SincroSSB = ISNULL(SincroSSB,0),
@MismaInstancia = SincroSSBMismaInstancia,
@Sucursal = Sucursal,
@PuertoSSB = PuertoSSB,
@RutaCertificados = RutaCertificados
FROM Version
SELECT @CertificadoDialogo = 'CertificadoDialogoSSB_'+CONVERT(varchar, @Sucursal)
SELECT @CertificadoDialogoArchivo = @RutaCertificados+'\'+@CertificadoDialogo+'.cer'
SELECT @ServicioLocal = 'ServicioSSB_'+CONVERT(varchar, @Sucursal)
SELECT @UsuarioLocal = 'UsuarioSSB_'+CONVERT(varchar, @Sucursal)
INSERT #Resultado (SQL) SELECT CHAR(45)+CHAR(45)+' PARA EJECUTAR ESTE SCRIPT ES NECESARIO ESTAR EN MODO EXCLUSIVO'
INSERT #Resultado (SQL) SELECT 'SET DATEFIRST 7'
INSERT #Resultado (SQL) SELECT 'SET ANSI_NULLS OFF'
INSERT #Resultado (SQL) SELECT 'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED'
INSERT #Resultado (SQL) SELECT 'SET LOCK_TIMEOUT -1'
INSERT #Resultado (SQL) SELECT 'SET QUOTED_IDENTIFIER OFF'
INSERT #Resultado (SQL) SELECT 'GO'
INSERT #Resultado (SQL) SELECT 'USE master'
INSERT #Resultado (SQL) SELECT 'ALTER DATABASE '+@BaseLocal+' SET TRUSTWORTHY ON';
INSERT #Resultado (SQL) SELECT 'ALTER DATABASE '+@BaseLocal+' SET NEW_BROKER';
INSERT #Resultado (SQL) SELECT 'ALTER DATABASE '+@BaseLocal+' SET ENABLE_BROKER';
INSERT #Resultado (SQL) SELECT 'GO'
INSERT #Resultado (SQL) SELECT 'USE '+@BaseLocal
INSERT #Resultado (SQL) SELECT 'GO'
INSERT #Resultado (SQL) SELECT 'IF NOT EXISTS(SELECT * FROM sys.symmetric_keys WHERE name LIKE ''%DatabaseMasterKey%'') CREATE MASTER KEY ENCRYPTION BY PASSWORD = N''INTELISIS/508121212'''
INSERT #Resultado (SQL) SELECT 'GO'
IF @MismaInstancia = 0
BEGIN
INSERT #Resultado (SQL) SELECT 'USE master'
INSERT #Resultado (SQL) SELECT 'GO'
INSERT #Resultado (SQL) SELECT 'IF NOT EXISTS(SELECT * FROM sys.symmetric_keys WHERE name LIKE ''%DatabaseMasterKey%'') CREATE MASTER KEY ENCRYPTION BY PASSWORD = N''INTELISIS/50811212'''
INSERT #Resultado (SQL) SELECT 'GO'
INSERT #Resultado (SQL) SELECT 'USE '+@BaseLocal
INSERT #Resultado (SQL) SELECT 'GO'
INSERT #Resultado (SQL) SELECT 'IF NOT EXISTS(SELECT * FROM sysusers WHERE name = '''+@UsuarioLocal+''') CREATE USER '+@UsuarioLocal+' WITHOUT LOGIN'
INSERT #Resultado (SQL) SELECT 'GO'
INSERT #Resultado (SQL) SELECT 'IF EXISTS(SELECT * FROM sys.certificates WHERE name = '''+@CertificadoDialogo+''') DROP CERTIFICATE '+@CertificadoDialogo
INSERT #Resultado (SQL) SELECT 'GO'
INSERT #Resultado (SQL) SELECT 'CREATE CERTIFICATE '+@CertificadoDialogo+' AUTHORIZATION '+@UsuarioLocal+' WITH SUBJECT = N''Certificado Dialogo SSB de la Sucursal '+CONVERT(varchar, @Sucursal)+''', EXPIRY_DATE = N''01/01/2099'''
INSERT #Resultado (SQL) SELECT 'GO'
INSERT #Resultado (SQL) SELECT CHAR(45)+CHAR(45)+' EXEC xp_cmdshell ''del '+@CertificadoDialogoArchivo+''''
INSERT #Resultado (SQL) SELECT 'GO'
INSERT #Resultado (SQL) SELECT 'BACKUP CERTIFICATE '+@CertificadoDialogo+' TO FILE = N'''+@CertificadoDialogoArchivo+''''
INSERT #Resultado (SQL) SELECT 'GO'
END
INSERT #Resultado (SQL) SELECT 'USE '+@BaseLocal
INSERT #Resultado (SQL) SELECT 'GO'
INSERT #Resultado (SQL) SELECT 'IF NOT EXISTS (SELECT * FROM sys.service_message_types WHERE name=''SincroSSB/Sincro'') CREATE MESSAGE TYPE [SincroSSB/Sincro] VALIDATION = NONE'
INSERT #Resultado (SQL) SELECT 'IF NOT EXISTS (SELECT * FROM sys.service_message_types WHERE name=''SincroSSB/SincroFinal'') CREATE MESSAGE TYPE [SincroSSB/SincroFinal] VALIDATION = NONE'
INSERT #Resultado (SQL) SELECT 'IF NOT EXISTS (SELECT * FROM sys.service_message_types WHERE name=''SincroSSB/SolicitarRespaldo'') CREATE MESSAGE TYPE [SincroSSB/SolicitarRespaldo] VALIDATION = NONE'
INSERT #Resultado (SQL) SELECT 'IF NOT EXISTS (SELECT * FROM sys.service_message_types WHERE name=''SincroSSB/SolicitarTRCL'') CREATE MESSAGE TYPE [SincroSSB/SolicitarTRCL] VALIDATION = NONE'
INSERT #Resultado (SQL) SELECT 'IF NOT EXISTS (SELECT * FROM sys.service_message_types WHERE name=''SincroSSB/SolicitarPrueba'') CREATE MESSAGE TYPE [SincroSSB/SolicitarPrueba] VALIDATION = NONE'
INSERT #Resultado (SQL) SELECT 'IF NOT EXISTS (SELECT * FROM sys.service_message_types WHERE name=''SincroSSB/Prueba'') CREATE MESSAGE TYPE [SincroSSB/Prueba] VALIDATION = NONE'
INSERT #Resultado (SQL) SELECT 'IF EXISTS (SELECT * FROM sys.service_contracts WHERE name=''ContratoSSB'') DROP CONTRACT ContratoSSB'
INSERT #Resultado (SQL) SELECT 'GO'
INSERT #Resultado (SQL) SELECT 'CREATE CONTRACT ContratoSSB ([SincroSSB/Sincro] SENT BY ANY, [SincroSSB/SincroFinal] SENT BY ANY, [SincroSSB/SolicitarRespaldo] SENT BY ANY, [SincroSSB/SolicitarTRCL] SENT BY ANY, [SincroSSB/SolicitarPrueba] SENT BY ANY, [SincroSSB/Prueba] SENT BY ANY)'
INSERT #Resultado (SQL) SELECT 'IF NOT EXISTS (SELECT * FROM sys.service_queues WHERE name=''ColaSSB'') CREATE QUEUE ColaSSB WITH STATUS=ON, ACTIVATION (PROCEDURE_NAME = spSincroSSBModoAuto, MAX_QUEUE_READERS = 5, EXECUTE AS ''dbo'')'
INSERT #Resultado (SQL) SELECT 'IF NOT EXISTS (SELECT * FROM sys.services WHERE name='''+@ServicioLocal+''') CREATE SERVICE '+@ServicioLocal+' AUTHORIZATION '+@UsuarioLocal+' ON QUEUE ColaSSB (ContratoSSB)'
INSERT #Resultado (SQL) SELECT 'GO'
INSERT #Resultado (SQL) SELECT 'UPDATE Version SET Sincro = 0, SincroSSB = 1'
INSERT #Resultado (SQL) SELECT 'GO'
INSERT #Resultado (SQL) SELECT 'EXEC spSincroSSBActualizar'
INSERT #Resultado (SQL) SELECT 'GO'
SELECT SQL FROM #Resultado ORDER BY ID
END

