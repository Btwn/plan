SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroIS_Activar2

AS BEGIN
EXEC('if exists (select * from sysobjects where id = object_id(''dbo.spSincroISInsertarEncabezado'') and type = ''P'') drop procedure dbo.spSincroISInsertarEncabezado')
EXEC('CREATE PROCEDURE spSincroISInsertarEncabezado
@Modulo			varchar(5),
@Empresa		varchar(5),
@Usuario		varchar(10),
@IDRemoto		int,
@SucursalRemota	int,
@SucursalLocal	int,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Mov				varchar(20),
@Cliente			varchar(10),
@Articulo			varchar(10),
@Proveedor			varchar(10),
@Agente				varchar(10),
@Condicion			varchar(50),
@Moneda				varchar(10),
@Almacen			varchar(10),
@UsuarioResponsable	varchar(10),
@FechaContable		datetime,
@Estatus			varchar(15),
@Tabla				varchar(100),
@IDLocal			int,
@SincroGUID			uniqueidentifier,
@SincroID				timestamp,
@Descripcion			varchar(50)
SET @Mov                = ''Error SincroIS''
SET @Estatus            = ''ERR SINCRO''
SET @Cliente            = ''ERR SINCRO''
SET @Articulo           = ''ERR SINCRO''
SET @Proveedor          = ''ERR SINCRO''
SET @Agente             = ''ERR SINCRO''
SET @Condicion          = ''ERR SINCRO''
SET @Moneda             = ''ERR SINCRO''
SET @Almacen            = ''ERR SINCRO''
SET @Descripcion        = ''ERR SINCRO''
SET @FechaContable      = GETDATE()
SET @UsuarioResponsable = @Usuario
SET @Tabla = dbo.fnSincroISMovTabla(@Modulo)
IF EXISTS(SELECT 1 FROM IDLOCAL WHERE IDRemoto = @IDRemoto AND Tabla = @Tabla AND  SucursalRemota = @SucursalRemota) RETURN
EXEC spSetInformacionContexto ''SINCROIS'', 1
IF @Modulo = ''AF'' INSERT ActivoFijo (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''AGENT'' INSERT AGENT (Empresa, Mov, Moneda, Agente, Estatus) VALUES (@Empresa, @Mov, @Moneda, @Agente, @Estatus) ELSE
IF @Modulo = ''ASIS'' INSERT Asiste (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''CAM'' INSERT Cambio (Empresa, Mov, Cliente, Condicion, Estatus) VALUES (@Empresa, @Mov, @Cliente, @Condicion, @Estatus) ELSE
IF @Modulo = ''CAP'' INSERT Capital (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''CAPT'' INSERT Captura (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''CMP'' INSERT Campana (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''COMS'' INSERT Compra (Empresa, Mov, Moneda, Estatus) VALUES (@Empresa, @Mov, @Moneda, @Estatus) ELSE
IF @Modulo = ''CONC'' INSERT Conciliacion (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''CONT'' INSERT CONT (Empresa, Mov, FechaContable, Moneda, Estatus) VALUES (@Empresa, @Mov, @FechaContable, @Moneda, @Estatus) ELSE
IF @Modulo = ''CP'' INSERT CP (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''CR'' INSERT CR (Empresa, Mov, Moneda, Estatus) VALUES (@Empresa, @Mov, @Moneda, @Estatus) ELSE
IF @Modulo = ''CREDI'' INSERT Credito (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''CXC'' INSERT CXC (Empresa, Mov, Moneda, Cliente, Estatus) VALUES (@Empresa, @Mov, @Moneda, @Cliente, @Estatus) ELSE
IF @Modulo = ''CXP'' INSERT CXP (Empresa, Mov, Moneda, Proveedor, Estatus) VALUES (@Empresa, @Mov, @Moneda, @Proveedor, @Estatus) ELSE
IF @Modulo = ''DIN'' INSERT Dinero (Empresa, Mov, Moneda, Estatus) VALUES (@Empresa, @Mov, @Moneda, @Estatus) ELSE
IF @Modulo = ''EMB'' INSERT Embarque (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''FIS'' INSERT Fiscal (Empresa, Mov, Moneda, Estatus) VALUES (@Empresa, @Mov, @Moneda, @Estatus) ELSE
IF @Modulo = ''CONTP'' INSERT ContParalela (Empresa, Mov, Moneda, Estatus) VALUES (@Empresa, @Mov, @Moneda, @Estatus) ELSE
IF @Modulo = ''OPORT'' INSERT Oportunidad (Empresa, Mov, Moneda, Estatus) VALUES (@Empresa, @Mov, @Moneda, @Estatus) ELSE
IF @Modulo = ''CORTE''INSERT Corte (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''FRM'' INSERT FormaExtra (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''GAS'' INSERT Gasto (Empresa, Mov, Moneda, Estatus) VALUES (@Empresa, @Mov, @Moneda, @Estatus) ELSE
IF @Modulo = ''GES'' INSERT Gestion (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''INC'' INSERT Incidencia (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''INV'' INSERT INV (Empresa, Mov, Moneda, Estatus) VALUES (@Empresa, @Mov, @Moneda, @Estatus) ELSE
IF @Modulo = ''ISL'' INSERT ISL (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''NOM'' INSERT Nomina (Empresa, Mov, Moneda, Estatus) VALUES (@Empresa, @Mov, @Moneda, @Estatus) ELSE
IF @Modulo = ''OFER'' INSERT Oferta (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''ORG'' INSERT Organiza (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''PACTO'' INSERT Contrato (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''PC'' INSERT PC (Empresa, Mov, Moneda, Estatus) VALUES (@Empresa, @Mov, @Moneda, @Estatus) ELSE
IF @Modulo = ''PPTO'' INSERT Presup (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''PROD'' INSERT PROD (Empresa, Mov, Moneda, Estatus) VALUES (@Empresa, @Mov, @Moneda, @Estatus) ELSE
IF @Modulo = ''PROY'' INSERT Proyecto (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''RE'' INSERT Recluta (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''RH'' INSERT RH (Empresa, Mov, Moneda, Estatus) VALUES (@Empresa, @Mov, @Moneda, @Estatus) ELSE
IF @Modulo = ''RSS'' INSERT RSS (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''ST'' INSERT Soporte (Empresa, Mov, UsuarioResponsable, Estatus) VALUES (@Empresa, @Mov, @UsuarioResponsable, @Estatus) ELSE
IF @Modulo = ''TMA'' INSERT TMA (Empresa, Mov, Estatus) VALUES (@Empresa, @Mov, @Estatus) ELSE
IF @Modulo = ''VALE'' INSERT VALE (Empresa, Mov, Moneda, Estatus) VALUES (@Empresa, @Mov, @Moneda, @Estatus) ELSE
IF @Modulo = ''VTAS'' INSERT Venta (Empresa, Mov, Moneda, Cliente, Almacen, Estatus) VALUES (@Empresa, @Mov, @Moneda, @Cliente, @Almacen, @Estatus) ELSE
IF @Modulo = ''PRECI'' INSERT Precio (Descripcion) VALUES (@Descripcion) ELSE
IF @Modulo = ''SIS01'' INSERT AroEventoPerdida (Descripcion) VALUES (@Descripcion) ELSE
IF @Modulo = ''SIS02'' INSERT AroRiesgoEvaluacion (Observaciones) VALUES (@Descripcion) ELSE
IF @Modulo = ''SIS03'' INSERT ArtMaterialHist (Articulo) VALUES (@Articulo) ELSE
IF @Modulo = ''SIS04'' INSERT GRP_Presupuesto (Partida) VALUES (@Articulo) ELSE
IF @Modulo = ''SIS05'' INSERT MovSituacion (Cuesta, PermiteAfectacion, PermiteRetroceder, PermiteBrincar, ControlUsuarios, Sucursal, Logico1, Logico2) VALUES (0,0,0,0,0,-1,0,0) ELSE
IF @Modulo = ''SIS06'' INSERT PlantillaOffice (Forma) VALUES (@Articulo) ELSE
IF @Modulo = ''SIS07'' INSERT CteCto (Cliente) VALUES (@Cliente) ELSE
IF @Modulo = ''SIS08'' INSERT Tarea (FechaEmision) VALUES (@FechaContable) ELSE
IF @Modulo = ''SIS09'' INSERT NomX (Finiquito, AceptaBajas, Logico1, Logico2, Logico3, Logico4, Logico5, FiltrarUltimoDiaPagado) VALUES (0, 0, 0, 0, 0, 0, 0, 0) ELSE
IF @Modulo = ''SIS10'' INSERT eDocD (Modulo, eDoc) VALUES (@Modulo, @Mov) ELSE
IF @Modulo = ''SIS11'' INSERT ContX (Modulo) VALUES (@Modulo) ELSE
IF @Modulo = ''SIS12'' INSERT Evento (Fecha) VALUES (@FechaContable) ELSE
IF @Modulo = ''SIS13'' INSERT EmbarqueMov (Sucursal, Logico1, Logico2, Logico3, Logico4, Logico5, DireccionNumero, DireccionNumeroInt, MapaLatitud, MapaLongitud, MapaPrecision) VALUES (-1, 0, 0, 0, 0, 0, @Descripcion, @Descripcion, 0.0, 0.0, 0)
SET @IDLocal = SCOPE_IDENTITY()
IF @Modulo = ''AF''    SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM ActivoFijo          WHERE ID = @IDLocal ELSE
IF @Modulo = ''AGENT'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM AGENT               WHERE ID = @IDLocal ELSE
IF @Modulo = ''ASIS''  SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Asiste              WHERE ID = @IDLocal ELSE
IF @Modulo = ''CAM''   SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Cambio              WHERE ID = @IDLocal ELSE
IF @Modulo = ''CAP''   SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Capital             WHERE ID = @IDLocal ELSE
IF @Modulo = ''CAPT''  SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Captura             WHERE ID = @IDLocal ELSE
IF @Modulo = ''CMP''   SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Campana             WHERE ID = @IDLocal ELSE
IF @Modulo = ''COMS''  SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Compra              WHERE ID = @IDLocal ELSE
IF @Modulo = ''CONC''  SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Conciliacion        WHERE ID = @IDLocal ELSE
IF @Modulo = ''CONT''  SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM CONT                WHERE ID = @IDLocal ELSE
IF @Modulo = ''CP''    SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM CP                  WHERE ID = @IDLocal ELSE
IF @Modulo = ''CR''    SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM CR                  WHERE ID = @IDLocal ELSE
IF @Modulo = ''CREDI'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Credito             WHERE ID = @IDLocal ELSE
IF @Modulo = ''CXC''   SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM CXC                 WHERE ID = @IDLocal ELSE
IF @Modulo = ''CXP''   SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM CXP                 WHERE ID = @IDLocal ELSE
IF @Modulo = ''DIN''   SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Dinero              WHERE ID = @IDLocal ELSE
IF @Modulo = ''EMB''   SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Embarque            WHERE ID = @IDLocal ELSE
IF @Modulo = ''FIS''   SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Fiscal              WHERE ID = @IDLocal ELSE
IF @Modulo = ''CONTP'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM ContParalela        WHERE ID = @IDLocal ELSE
IF @Modulo = ''OPORT'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Oportunidad         WHERE ID = @IDLocal ELSE
IF @Modulo = ''CORTE'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Corte               WHERE ID = @IDLocal ELSE
IF @Modulo = ''FRM''   SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM FormaExtra          WHERE ID = @IDLocal ELSE
IF @Modulo = ''GAS''   SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Gasto               WHERE ID = @IDLocal ELSE
IF @Modulo = ''GES''   SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Gestion             WHERE ID = @IDLocal ELSE
IF @Modulo = ''INC''   SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Incidencia          WHERE ID = @IDLocal ELSE
IF @Modulo = ''INV''   SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM INV                 WHERE ID = @IDLocal ELSE
IF @Modulo = ''ISL''   SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM ISL                 WHERE ID = @IDLocal ELSE
IF @Modulo = ''NOM''   SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Nomina              WHERE ID = @IDLocal ELSE
IF @Modulo = ''OFER''  SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Oferta              WHERE ID = @IDLocal ELSE
IF @Modulo = ''ORG''   SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Organiza            WHERE ID = @IDLocal ELSE
IF @Modulo = ''PACTO'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Contrato            WHERE ID = @IDLocal ELSE
IF @Modulo = ''PC''    SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM PC                  WHERE ID = @IDLocal ELSE
IF @Modulo = ''PPTO''  SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Presup              WHERE ID = @IDLocal ELSE
IF @Modulo = ''PROD''  SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM PROD                WHERE ID = @IDLocal ELSE
IF @Modulo = ''PROY''  SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Proyecto            WHERE ID = @IDLocal ELSE
IF @Modulo = ''RE''    SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Recluta             WHERE ID = @IDLocal ELSE
IF @Modulo = ''RH''    SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM RH                  WHERE ID = @IDLocal ELSE
IF @Modulo = ''RSS''   SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM RSS                 WHERE ID = @IDLocal ELSE
IF @Modulo = ''ST''    SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Soporte             WHERE ID = @IDLocal ELSE
IF @Modulo = ''TMA''   SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM TMA                 WHERE ID = @IDLocal ELSE
IF @Modulo = ''VALE''  SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM VALE                WHERE ID = @IDLocal ELSE
IF @Modulo = ''VTAS''  SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Venta               WHERE ID = @IDLocal ELSE
IF @Modulo = ''PRECI'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Precio              WHERE ID = @IDLocal ELSE 
IF @Modulo = ''SIS01'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM AroEventoPerdida    WHERE ID = @IDLocal ELSE 
IF @Modulo = ''SIS02'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM AroRiesgoEvaluacion WHERE ID = @IDLocal ELSE 
IF @Modulo = ''SIS03'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM ArtMaterialHist     WHERE ID = @IDLocal ELSE 
IF @Modulo = ''SIS04'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM GRP_Presupuesto     WHERE ID = @IDLocal ELSE 
IF @Modulo = ''SIS05'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM MovSituacion        WHERE ID = @IDLocal ELSE 
IF @Modulo = ''SIS06'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM PlantillaOffice     WHERE ID = @IDLocal ELSE 
IF @Modulo = ''SIS07'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM CteCto              WHERE ID = @IDLocal ELSE 
IF @Modulo = ''SIS08'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Tarea               WHERE ID = @IDLocal ELSE 
IF @Modulo = ''SIS09'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM NomX                WHERE ID = @IDLocal ELSE 
IF @Modulo = ''SIS10'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM eDocD               WHERE RID = @IDLocal ELSE 
IF @Modulo = ''SIS11'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM ContX               WHERE ID = @IDLocal ELSE  
IF @Modulo = ''SIS12'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM Evento              WHERE ID = @IDLocal ELSE  
IF @Modulo = ''SIS13'' SELECT @SincroGUID = SincroGUID, @SincroID = SincroID FROM EmbarqueMov         WHERE ID = @IDLocal       
IF @SincroID IS NOT NULL
INSERT SincroISNoRebote (SincroID, Sucursal) VALUES (@SincroID, @SucursalRemota)
INSERT IDLocal (Tabla,  SucursalRemota,  IDRemoto,  SucursalLocal,  IDLocal,  RegistroTemporal)
VALUES (@Tabla, @SucursalRemota, @IDRemoto, @SucursalLocal, @IDLocal, @SincroGUID)
EXEC spSetInformacionContexto ''SINCROIS'', 0
END')
END

