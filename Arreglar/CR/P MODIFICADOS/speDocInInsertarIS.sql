SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInInsertarIS
@Origen                                 varchar(255),
@Destino                                varchar(255),
@Extencion                              varchar(255),
@Empresa                                varchar(5),
@Usuario                                varchar(10),
@Sucursal                               int,
@Ok					int = NULL OUTPUT,
@OkRef	 				varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@xml         varchar(max),
@xml2        xml,
@xml3        xml,
@Resultado   varchar(max),
@Nombre      varchar(255),
@ID          int,
@Estacion    int,
@Origen2     varchar(255),
@Destino2    varchar(255),
@Contrasena  varchar(32),
@Existe      int,
@Contador    int
SELECT @Contrasena = Contrasena FROM Usuario WITH(NOLOCK) WHERE Usuario = @Usuario
SELECT @Estacion = @@SPID
EXEC speDocInListarDirectorio @Origen, @Estacion
DECLARE creDocInDir CURSOR FOR
SELECT Nombre
FROM eDocInDirDetalle WITH(NOLOCK)
WHERE   Estacion = @Estacion AND Tipo = @Extencion
ORDER BY RowNum
OPEN creDocInDir
FETCH NEXT FROM creDocInDir  INTO @Nombre
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Origen2 =NULL , @Destino2 = NULL
SELECT @Xml =  dbo.fneDocInLeerArchivo(@Origen,@Nombre)
IF @Ok IS NULL
BEGIN TRY
SELECT @xml2 = CONVERT(xml,@xml)
END TRY
BEGIN CATCH
SELECT @Ok = @@ERROR,  @OkRef = ' Error  xml Invalido ' +ERROR_MESSAGE()
IF XACT_STATE() = -1
BEGIN
ROLLBACK TRAN
SET @OkRef = ' Error  xml Invalido (' + CONVERT(varchar,@Ok) +') ' + @OkRef
RAISERROR(@OkRef,20,1) WITH LOG
END
END CATCH
SELECT @Xml = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.eDocInProcesar" SubReferencia="" Version="1.0"><Solicitud  Empresa ="'+@Empresa+'" Sucursal="'+CONVERT(varchar,@Sucursal)+'" Usuario ="'+@Usuario+'" Origen ="'+@Origen+'\'+@Nombre+'" >'+CONVERT(varchar(max),@xml2)+'</Solicitud></Intelisis>'
BEGIN TRY
SELECT @xml3 = CONVERT(xml,@xml)
END TRY
BEGIN CATCH
SELECT @Ok = @@ERROR,  @OkRef =' Error  xml Invalido ' +ERROR_MESSAGE()
IF XACT_STATE() = -1
BEGIN
ROLLBACK TRAN
SET @OkRef = ' Error  xml Invalido(' + CONVERT(varchar,@Ok) +') '+ @OkRef
RAISERROR(@OkRef,20,1) WITH LOG
END
END CATCH
IF @Ok IS NOT NULL
BEGIN
SELECT @Xml = '<?xml version="1.0" encoding="windows-1252"?><Intelisis Sistema="Intelisis" Contenido="Solicitud" Referencia="Intelisis.eDocInProcesar" SubReferencia="XML.Invalido" Version="1.0"><Solicitud  Empresa ="'+@Empresa+'" Sucursal="'+CONVERT(varchar,@Sucursal)+'" Usuario ="'+@Usuario+'" Origen ="'+@Origen+'\'+@Nombre+'" Ok ="'+CONVERT(varchar,@OK)+'" OkRef ="'+@OkRef+'">'+'<![CDATA['+ISNULL(@xml,'')+']]>'+'</Solicitud></Intelisis>'
SELECT @Ok = NULL, @OkRef = NULL
END
EXEC spIntelisisService @Usuario,@Contrasena,@xml,@Resultado,@Ok OUTPUT,@OkRef OUTPUT,1,0,@ID OUTPUT
IF @ID IS NOT NULL
UPDATE IntelisisService  WITH(ROWLOCK) SET eDocInArchivo = @Nombre
WHERE ID = @ID
SELECT @Origen2 = @Origen+'\'+@Nombre, @Destino2 = @Destino+'\'+@Nombre
IF @Ok IS NULL
BEGIN
EXEC spEliminarArchivo  @Destino2 , @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spMoverArchivo  @Origen2, @Destino2, @Ok OUTPUT, @OkRef OUTPUT
END
FETCH NEXT FROM creDocInDir  INTO @Nombre
END
CLOSE creDocInDir
DEALLOCATE creDocInDir
END

