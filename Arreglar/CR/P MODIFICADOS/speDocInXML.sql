SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInXML
@eDocIn					varchar(50),
@Ruta					varchar(50),
@Documento                              varchar(max),
@Empresa                                varchar(5),
@Usuario				varchar(10),
@Sucursal				int,
@Origen                                 varchar(max),
@Ok					int = NULL OUTPUT,
@OkRef					varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Hoy				datetime,
@HoyTexto			varchar(50),
@Movimiento		        varchar(20),
@Modulo			varchar(5),
@UsuarioMoneda                varchar(10),
@EmpresaMoneda                varchar(10),
@Almacen                      varchar(10),
@Tabla                        varchar(50),
@Parametros                   nvarchar(max),
@ID                           int,
@IDGenerar                    int,
@Afectar                      bit,
@SQL                          nvarchar(max),
@SQL2                         varchar(max),
@SQL3                         nvarchar(max),
@XML                          xml,
@TipoCambio                   float,
@Estacion                     int,
@Estatus                      varchar(20),
@Mov                          varchar(20),
@MovID                        varchar(20),
@AntesAfectar                 varchar(50)
SELECT @Estacion = @@SPID
DELETE FROM eDocInVariableTemp WHERE Estacion = @@SPID
SET @eDocIn = RTRIM(ISNULL(@eDocIn,''))
SET @Ruta = RTRIM(ISNULL(@Ruta,''))
SET @Sucursal = ISNULL(@Sucursal,0)
SELECT @Movimiento = RTRIM(ISNULL(Mov,'')), @Modulo = RTRIM(ISNULL(Modulo,'')), @Afectar = ISNULL(Afectar,0), @AntesAfectar = NULLIF(AntesAfectar,'') FROM eDocINRuta WHERE eDocIn = @eDocIN AND Ruta = @Ruta
SELECT @Documento = dbo.fneDocInBorrarXmlnsOmision(@Documento)
SELECT @Xml = CONVERT(xml,@Documento)
SELECT @UsuarioMoneda = DefMoneda, @Almacen = DefAlmacen FROM Usuario WHERE Usuario = @Usuario
SELECT @EmpresaMoneda = ContMoneda FROM EmpresaCfg WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @TipoCambio = m.TipoCambio FROM Mon m WHERE m.Moneda = ISNULL(@UsuarioMoneda,@EmpresaMoneda)
IF NULLIF(@eDocIn,'') IS NULL OR NOT EXISTS(SELECT 1 FROM eDocIn WHERE eDocIn = @eDocIn) SELECT @Ok = 72200, @OkRef = '(' + RTRIM(@eDocIn) + ', ' + @Ruta + ')' ELSE
IF NULLIF(@Ruta,'') IS NULL OR NOT EXISTS(SELECT 1 FROM eDocInRuta WHERE eDocIn = @eDocIn AND Ruta = @Ruta) SELECT @Ok = 72210, @OkRef = '(' + RTRIM(@eDocIn) + ', ' + @Ruta + ')'   ELSE
IF NULLIF(@Modulo,'') IS NULL OR NOT EXISTS(SELECT 1 FROM Modulo WHERE Modulo = @Modulo) SELECT @Ok = 70020, @OkRef = '(' + RTRIM(@eDocIn) + ', ' + @Ruta + ', ' + @Modulo + ')'   ELSE
IF NULLIF(@Movimiento,'') IS NULL OR NOT EXISTS(SELECT 1 FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Movimiento) SELECT @Ok = 70025, @OkRef = '(' + RTRIM(@eDocIn) + ', ' + @Ruta + ', ' + @Modulo + ', ' + @Movimiento + ')'   ELSE
IF NULLIF(@Usuario,'') IS NULL SELECT @Ok = 71010, @OkRef = '(' + RTRIM(@eDocIn) + ', ' + @Ruta + ')' ELSE
IF NULLIF(@Almacen,'') IS NULL AND EXISTS (SELECT * FROM eDocInRutaTablaD WHERE CampoTabla LIKE 'Almacen%' AND EsIndependiente = 1 AND ExpresionXML = '{Almacen}' AND eDocIn = @eDocIn AND Ruta = @Ruta )  SELECT @Ok = 10576, @OkRef = '(' + RTRIM(@eDocIn) + ', ' + @Ruta + ')' ELSE
IF NOT EXISTS(SELECT 1 FROM Sucursal WHERE Sucursal = @Sucursal) SELECT @Ok = 72060, @OkRef = '(' + RTRIM(@eDocIn) + ', ' + @Ruta + ')'
SET @Hoy = dbo.fnFechaSinHora(GETDATE())
SET @HoyTexto = RTRIM(CONVERT(varchar,@Hoy,126))
INSERT eDocInVariableTemp (Estacion, Variable, Valor, Tipo) VALUES (@@SPID, 'Hoy', @HoyTexto, 'FECHA')
INSERT eDocInVariableTemp (Estacion, Variable, Valor, Tipo) VALUES (@@SPID, 'Usuario', @Usuario, 'TEXTO')
INSERT eDocInVariableTemp (Estacion, Variable, Valor, Tipo) VALUES (@@SPID, 'Sucursal', @Sucursal, 'NUMERICO')
INSERT eDocInVariableTemp (Estacion, Variable, Valor, Tipo) VALUES (@@SPID, 'Movimiento', @Movimiento, 'TEXTO')
INSERT eDocInVariableTemp (Estacion, Variable, Valor, Tipo) VALUES (@@SPID, 'Modulo', @Modulo, 'TEXTO')
INSERT eDocInVariableTemp (Estacion, Variable, Valor, Tipo) VALUES (@@SPID, 'Moneda', ISNULL(NULLIF(@UsuarioMoneda,''),@EmpresaMoneda), 'TEXTO')
INSERT eDocInVariableTemp (Estacion, Variable, Valor, Tipo) VALUES (@@SPID, 'Almacen', @Almacen, 'TEXTO')
INSERT eDocInVariableTemp (Estacion, Variable, Valor, Tipo) VALUES (@@SPID, 'EstatusSinAfectar', 'SINAFECTAR', 'TEXTO')
INSERT eDocInVariableTemp (Estacion, Variable, Valor, Tipo) VALUES (@@SPID, 'TipoCambio', @TipoCambio, 'NUMERICO')
IF @Ok IS  NULL
EXEC speDocInInsertarConsecutivos @eDocIn, @Ruta, @Xml OUTPUT, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
BEGIN
DECLARE crGeneraInsertTabla CURSOR FOR
SELECT Tablas
FROM eDocInRutaTabla WITH(NOLOCK)
WHERE  eDocIn = @eDocIn AND  Ruta = @Ruta
GROUP BY Tablas
OPEN crGeneraInsertTabla
FETCH NEXT FROM crGeneraInsertTabla  INTO @Tabla
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @SQL = dbo.fneDocInGenerarInsertTabla(@eDocIn,@Ruta,@Tabla)
SET @Parametros = N'@XML xml, @Ok int OUTPUT, @OkRef varchar(255) OUTPUT,@ID int OUTPUT'
BEGIN TRY
EXECUTE sp_executesql @SQL, @Parametros, @XML = @XML, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT,@ID = @ID OUTPUT
END TRY
BEGIN CATCH
SELECT @Ok = @@ERROR,  @OkRef = ERROR_MESSAGE()
IF XACT_STATE() = -1
BEGIN
ROLLBACK TRAN
SET @OkRef = ' Error al insertar la tabla '+@Tabla+' '+ + CONVERT(varchar,@Ok) + @OkRef+'('+@Tabla+')'
RAISERROR(@OkRef,20,1) WITH LOG
END
END CATCH
IF @Ok IS NOT NULL
SET @OkRef = ' Error al insertar la tabla '+@Tabla+' (' + CONVERT(varchar,@Ok) +') '+ @OkRef+'('+@Tabla+')'
IF @ID IS NOT NULL
BEGIN
INSERT eDocInVariableTemp (Estacion, Variable, Valor, Tipo) VALUES (@@SPID, 'ID', @ID, 'NUMERICO')
IF @@ERROR <> 0 SELECT @Ok = 72320 , @OkRef = @OkRef +'('+@Tabla+')'
SELECT @IDGenerar = @ID
END
SET @ID = NULL
FETCH NEXT FROM crGeneraInsertTabla  INTO @Tabla
END
CLOSE crGeneraInsertTabla
DEALLOCATE crGeneraInsertTabla
END
IF @Ok IS NULL
BEGIN
SELECT @Tabla = dbo.fnMovTabla(@Modulo)
IF @AntesAfectar IS NOT NULL AND @IDGenerar IS NOT NULL
EXEC speDocInAntesAfectar @AntesAfectar, @eDocIn, @Ruta, @IDGenerar, @Modulo, @Ok OUTPUT, @OkRef OUTPUT
IF @IDGenerar IS NOT NULL AND @Afectar = 1 AND @Ok IS NULL
EXEC spAfectar @Modulo, @IDGenerar, 'AFECTAR','TODO', NULL ,@Usuario, NULL, 1, @Ok OUTPUT, @OkRef OUTPUT, @Conexion = 1
ELSE
IF @IDGenerar IS NOT NULL AND @Afectar = 0  AND @Ok IS NULL
SELECT @SQL2 = 'UPDATE '+ @Tabla+' SET Estatus = '+CHAR(39)+'BORRADOR'+CHAR(39)+' WHERE ID = '+CONVERT(varchar,@IDGenerar)
EXEC (@SQL2)
IF @@ERROR <> 0 SET @Ok = 1
IF @Ok IS NULL
BEGIN
SET @SQL3 = N'  SELECT  @Mov = Mov , @MovID = MovID, @Estatus = Estatus FROM  '+@Tabla+'  WHERE ID = '+CONVERT(varchar,@IDGenerar)
EXEC sp_executesql @SQL3, N'@Mov varchar(20)  OUTPUT,@MovID   varchar(20)  OUTPUT, @Estatus  varchar(20)  OUTPUT', @Mov = @Mov  OUTPUT, @MovID = @MovID OUTPUT, @Estatus = @Estatus OUTPUT
END
IF @Ok IS NULL AND @IDGenerar IS NOT NULL
INSERT eDocInRutaTemp( eDocIn,  Ruta,  Modulo,  ID,         Estacion,  Mov,                 Estatus, Origen)
SELECT                 @eDocIn, @Ruta, @Modulo, @IDGenerar, @Estacion, @Mov + ' ' + ISNULL(@MovID,''), @Estatus, @Origen
IF @@ERROR <> 0 SET @Ok = 1
END
END

