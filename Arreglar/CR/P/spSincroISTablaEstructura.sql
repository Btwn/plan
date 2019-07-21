SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISTablaEstructura
@Tabla			varchar(255),
@SELECT			varchar(max)	= NULL OUTPUT,
@TABLE			varchar(max)	= NULL OUTPUT,
@DECALRE		varchar(max)	= NULL OUTPUT,
@SET			varchar(max)	= NULL OUTPUT,
@PARAMS			varchar(max)	= NULL OUTPUT,
@WITH			varchar(max)	= NULL OUTPUT,
@JOIN			varchar(max)	= NULL OUTPUT,
@VALUES			varchar(max)	= NULL OUTPUT,
@CampoIdentity		varchar(100)	= NULL OUTPUT,
@ExcluirTimeStamp	bit = 0,
@ExcluirCalculados	bit = 0,
@ExcluirBLOBs		bit = 0,
@ExcluirImage		bit = 0,
@ExcluirIdentity	bit = 0,
@ASCampo			bit = 0,
@PK					bit = 0,
@Prefijo			varchar(100)	= NULL,
@Sufijo				varchar(100)	= NULL,
@JOIN_Tabla1		varchar(100)	= NULL,
@JOIN_Tabla2		varchar(100)	= NULL,
@ReemplazarCampo	varchar(100)	= NULL,
@ReemplazarValor	varchar(100)	= NULL,
@SucursalRemota		int				= NULL,
@SELECT_VALUES		varchar(max)	= NULL OUTPUT,
@SELECT_IDLocal		varchar(max)    = NULL OUTPUT,
@SELECTCampoLocal	bit = 0	               OUTPUT,
@JOIN_Mov			varchar(max)	= NULL OUTPUT,
@WHERE_IDLocal		varchar(max)	= NULL OUTPUT,
@JOIN_Encabezado	varchar(max)	= NULL OUTPUT,
@WHERE_Encabezado	varchar(max)	= NULL OUTPUT,
@SET_JOIN_T1		varchar(max)    = NULL OUTPUT,
@SET_JOIN_T2		varchar(max)    = NULL OUTPUT,
@GenerarTabla		bit = 0,
@TablaVirtual		varchar(50) = NULL, 
@SET_JOIN_T3		varchar(max)    = NULL OUTPUT, 
@WHERE_Mov			varchar(max)	= NULL OUTPUT, 
@JOIN_IDLocal		varchar(max)	= NULL OUTPUT  

AS BEGIN
DECLARE
@Campo				varchar(265),
@TipoDatos			varchar(256),
@TipoDatosExt		varchar(256),
@AS					varchar(256),
@Valor				varchar(256),
@Ancho				smallint,
@AceptaNulos		bit,
@EsIdentity			bit,
@EsCalculado		bit,
@Continuar			bit,
@TablaRemota		varchar(100),
@TieneTablaRemota	bit,
@SELECTCampo		varchar(255),
@TieneModulo		bit,
@CampoModulo		varchar(100),
@Modulo				varchar(5),
@TablaVirtualTipo	varchar(50), 
@ContadorCampoIDLocal		int 
IF @GenerarTabla = 1 DELETE FROM SincroISTablaEstructura WHERE SPID = @@SPID AND Tabla = @Tabla
SELECT @SELECT = NULL, @SELECT_VALUES = NULL, @VALUES = NULL, @TABLE = NULL, @DECALRE = NULL, @SET = NULL, @PARAMS = NULL, @WITH = NULL, @JOIN = NULL, @CampoIdentity = NULL, @SELECT_IDLocal = NULL, @SELECTCampoLocal = 0, @WHERE_IDLocal = NULL, @JOIN_Encabezado = NULL, @WHERE_Encabezado = NULL, @SET_JOIN_T1 = NULL, @SET_JOIN_T2 = NULL, @SET_JOIN_T3 = NULL, @ContadorCampoIDLocal = 1, @JOIN_IDLocal = NULL 
SELECT @Prefijo = ISNULL(@Prefijo, ''), @Sufijo = ISNULL(@Sufijo, ''), @JOIN_Tabla1 = ISNULL(@JOIN_Tabla1, ''), @JOIN_Tabla2 = ISNULL(@JOIN_Tabla2, '')
SELECT @TieneTablaRemota = 0, @TieneModulo = 0
SELECT @TablaRemota = dbo.fnIDLocalTablaModulo(@Tabla)
IF @TablaRemota IS NOT NULL AND @Tabla <> @TablaRemota SELECT @TieneTablaRemota = 1
IF @TablaVirtual <> @Tabla AND NULLIF(@TablaVirtual,'') IS NOT NULL AND @TablaRemota IS NOT NULL AND @TieneTablaRemota = 1 
BEGIN
SELECT @TablaVirtualTipo = Tipo FROM SysTabla WHERE SysTabla = @TablaVirtual
IF @TablaVirtualTipo NOT IN ('Movimiento','MovimientoInfo')
SELECT @TablaRemota = NULL, @TieneTablaRemota = 0
END
IF @JOIN_Tabla1 <> '' SELECT @JOIN_Tabla1 = @JOIN_Tabla1 + '.'
IF @JOIN_Tabla2 <> '' SELECT @JOIN_Tabla2 = @JOIN_Tabla2 + '.'
IF @PK = 1
DECLARE crSysCampo CURSOR LOCAL FOR
SELECT Campo, TipoDatos, Ancho, ISNULL(AceptaNulos,0), ISNULL(EsIdentity,0), ISNULL(EsCalculado,0)
FROM SysCampoExt
WHERE Tabla = @Tabla AND Campo IN (SELECT Campo FROM dbo.fnTablaPK(@Tabla))
ORDER BY Orden
ELSE
DECLARE crSysCampo CURSOR LOCAL FOR
SELECT Campo, TipoDatos, Ancho, AceptaNulos, EsIdentity, EsCalculado
FROM SysCampoExt
WHERE Tabla = @Tabla
ORDER BY Orden
OPEN crSysCampo
FETCH NEXT FROM crSysCampo INTO @Campo, @TipoDatos, @Ancho, @AceptaNulos, @EsIdentity, @EsCalculado
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Continuar = 1
IF (@TieneTablaRemota = 0 OR @Tabla IN ('EmbarqueMov')) AND @Campo LIKE '%Modulo%' AND @Ancho = 5 
SELECT @TieneModulo = 1, @CampoModulo = @Campo
IF @EsIdentity = 1 SELECT @CampoIdentity = @Campo
IF @EsIdentity = 1 AND @ExcluirIdentity = 1 SELECT @Continuar = 0
IF @ExcluirTimeStamp = 1 AND LOWER(@TipoDatos) = 'timestamp' SELECT @Continuar = 0
IF @ExcluirCalculados = 1 AND @EsCalculado = 1 SELECT @Continuar = 0
IF @ExcluirBLOBs = 1 AND LOWER(@TipoDatos) IN ('text', 'ntext', 'image') SELECT @Continuar = 0
IF @ExcluirImage = 1 AND LOWER(@TipoDatos) = 'image' SELECT @Continuar = 0
IF @Continuar = 1
BEGIN
SELECT @TipoDatosExt = @TipoDatos
IF LOWER(@TipoDatos) IN ('char', 'varchar', 'nchar', 'nvarchar', 'binary')
SELECT @TipoDatosExt = @TipoDatosExt+'('+CASE WHEN @Ancho = -1 THEN 'max' ELSE CONVERT(varchar, @Ancho) END+')'
IF @ASCampo = 1 SELECT @AS = ' AS '+@Campo ELSE SELECT @AS = ''
IF @Campo = @ReemplazarCampo SELECT @Valor = @ReemplazarValor ELSE SELECT @Valor = @Prefijo+@Campo+@Sufijo+@AS
SELECT @SELECTCampo = @Prefijo+@Campo+@Sufijo
SELECT @SELECT      = CASE WHEN @EsIdentity = 0 THEN dbo.fnSincroISConcatenarMAX(@SELECT, @SELECTCampo+@AS, ', ') ELSE @SELECT END,                             
@VALUES      = dbo.fnSincroISConcatenarMAX(@VALUES, @Valor, ', '),                                       
@TABLE       = dbo.fnSincroISConcatenarMAX(@TABLE, @Campo + ' ' + @TipoDatosExt, ', '),                  
@WITH        = dbo.fnSincroISConcatenarMAX(@WITH, @Campo + ' ' + @TipoDatosExt, ', '),                   
@JOIN        = dbo.fnSincroISConcatenarMAX(@JOIN, @JOIN_Tabla1+@Campo+'='+@JOIN_Tabla2+@Campo, ' AND '), 
@DECALRE     = dbo.fnSincroISConcatenarMAX(@DECALRE, '@'+@Campo+' '+@TipoDatosExt, ', '),                
@SET         = dbo.fnSincroISConcatenarMAX(@SET, @Prefijo+@Campo+@Sufijo+'=@'+@Campo, ', '),             
@SET_JOIN_T1 = dbo.fnSincroISConcatenarMAX(@SET_JOIN_T1, @Prefijo+@Campo+@Sufijo+'='+@JOIN_Tabla1+@Campo, ', '),        
@SET_JOIN_T2 = dbo.fnSincroISConcatenarMAX(@SET_JOIN_T2, @Prefijo+@Campo+@Sufijo+'='+@JOIN_Tabla2+@Campo, ', '),        
@PARAMS      = dbo.fnSincroISConcatenarMAX(@PARAMS, '@'+@Campo, ', ')/*,                                 
@PIPES       = dbo.fnSincroISConcatenarMAX(@PIPES, 'CONVERT(varchar(max), '+@Campo+')', '+"|"+')*/
IF @TieneTablaRemota = 1 AND ((@Campo IN ('ID','IDSeccion','SeccionID') AND @Tabla NOT IN ('Evento')) OR (@Campo IN ('Evento') AND @Tabla IN ('EventoD'))) AND @TipoDatos = 'int' AND @TieneModulo = 0
BEGIN
SELECT @SET_JOIN_T3 = dbo.fnSincroISConcatenarMAX(@SET_JOIN_T3, @Prefijo+@Campo+@Sufijo+'=dbo.fnIDLocal('''+ISNULL(@TablaRemota,'')+''','+CONVERT(varchar, ISNULL(@SucursalRemota,''))+', '+ISNULL(@JOIN_Tabla1,'')+ISNULL(@Campo,'')+')', ', ')        
END ELSE
BEGIN
SELECT @SET_JOIN_T3 = dbo.fnSincroISConcatenarMAX(@SET_JOIN_T3, @Prefijo+@Campo+@Sufijo+'='+@JOIN_Tabla1+@Campo, ', ')        
END
IF @TieneTablaRemota = 1 AND ((@Campo IN ('ID','IDSeccion','SeccionID') AND @Tabla NOT IN ('Evento')) OR (@Campo IN ('Evento') AND @Tabla IN ('EventoD'))) AND @TipoDatos = 'int' AND @TieneModulo = 0
BEGIN
IF @SELECTCampoLocal = 1 SELECT @SELECT_IDLocal = @SELECT_IDLocal + ' OR ' ELSE
IF @SELECTCampoLocal = 0 SELECT @SELECT_IDLocal = ''
SELECT @SELECT_IDLocal = @SELECT_IDLocal + '((dbo.fnIDLocal('''+@TablaRemota+''', '+CONVERT(varchar, @SucursalRemota)+', '+@Prefijo+@Campo+@Sufijo+') IS NULL) AND ('+@Prefijo+@Campo+@Sufijo+' IS NOT NULL))'
IF @GenerarTabla = 1
BEGIN
SELECT @Modulo = Modulo FROM SysTabla WHERE SysTabla = @Tabla
INSERT SincroISTablaEstructura (SPID,   Tabla,  Modulo,  Campo,                   SucursalRemota,  SELECT_IDLocal)
VALUES (@@SPID, @Tabla, @Modulo, @Prefijo+@Campo+@Sufijo, @SucursalRemota, '((dbo.fnIDLocal('''+@TablaRemota+''', '+CONVERT(varchar, @SucursalRemota)+', '+@Prefijo+@Campo+@Sufijo+') IS NULL) AND ('+@Prefijo+@Campo+@Sufijo+' IS NOT NULL))')
END
SELECT @SELECTCampo = 'dbo.fnIDLocal('''+@TablaRemota+''', '+CONVERT(varchar, @SucursalRemota)+', ' +@Prefijo+@Campo+@Sufijo+')', @SELECTCampoLocal = 1
SELECT @JOIN_Encabezado = ISNULL(@JOIN_Encabezado,'') + ' LEFT OUTER JOIN ' + @TablaRemota + ' ON ' + @Tabla + '.' + @Campo + ' = ' + @TablaRemota + '.ID '
END
IF @TieneModulo = 1 AND @Campo IN ('ID', 'ModuloID', 'OID', 'DID') AND @TipoDatos = 'int' AND @EsIdentity = 0
BEGIN
IF @SELECTCampoLocal = 1 SELECT @SELECT_IDLocal = @SELECT_IDLocal + ' OR ', @WHERE_IDLocal = @WHERE_IDLocal + ' AND ', @WHERE_Encabezado = @WHERE_Encabezado + ' OR ', @JOIN_Mov = @JOIN_Mov + ' LEFT OUTER JOIN Mov m' + LTRIM(RTRIM(CONVERT(varchar,@ContadorCampoIDLocal))) + ' ON ', @WHERE_MOV = @WHERE_MOV + ' OR ' ELSE 
IF @SELECTCampoLocal = 0
BEGIN
SELECT @SELECT_IDLocal = ''
SELECT @WHERE_IDLocal = ''
SELECT @WHERE_Encabezado = ''
SELECT @JOIN_Mov = ' LEFT OUTER JOIN Mov m' + LTRIM(RTRIM(CONVERT(varchar,@ContadorCampoIDLocal))) + ' ON ' 
SELECT @WHERE_Mov = '' 
END
IF @GenerarTabla = 1
BEGIN
INSERT SincroISTablaEstructura (SPID,   Tabla,  CampoModulo,                   Campo,                   SucursalRemota,  SELECT_IDLocal)
VALUES (@@SPID, @Tabla, @Prefijo+@CampoModulo+@Sufijo, @Prefijo+@Campo+@Sufijo, @SucursalRemota, '((dbo.fnIDLocalModulo('+@Prefijo+@CampoModulo+@Sufijo+', '+CONVERT(varchar, @SucursalRemota)+', '+@Prefijo+@Campo+@Sufijo+') IS NULL) AND ('+@Prefijo+@Campo+@Sufijo+' IS NOT NULL AND '+@Prefijo+@CampoModulo+@Sufijo+' IS NOT NULL))')
END
SELECT @SELECT_IDLocal = @SELECT_IDLocal + '((dbo.fnIDLocalModulo('+@Prefijo+@CampoModulo+@Sufijo+', '+CONVERT(varchar, @SucursalRemota)+', '+@Prefijo+@Campo+@Sufijo+') IS NULL) AND ('+@Prefijo+@Campo+@Sufijo+' IS NOT NULL AND '+@Prefijo+@CampoModulo+@Sufijo+' IS NOT NULL))'
SELECT @JOIN_Mov = @JOIN_Mov + ' ' + @Tabla+'.'+@CampoModulo+' = m' + LTRIM(RTRIM(CONVERT(varchar,@ContadorCampoIDLocal))) + '.Modulo AND '+@Tabla+'.'+@Campo+' = m' + LTRIM(RTRIM(CONVERT(varchar,@ContadorCampoIDLocal))) + '.ID '  
SELECT @WHERE_Mov = @WHERE_Mov + ' ISNULL(m' + LTRIM(RTRIM(CONVERT(varchar,@ContadorCampoIDLocal))) + '.Sucursal,dbo.fnSincroISMovSucursal('+ @Tabla+'.'+@CampoModulo+ ','+@Tabla+'.'+@Campo+')) IN (SELECT Sucursal FROM dbo.fnSucursalesLigadas(@SucursalDestino)) ' 
SET @ContadorCampoIDLocal = @ContadorCampoIDLocal + 1 
SELECT @SELECTCampo = 'dbo.fnIDLocalModulo('+@Prefijo+@CampoModulo+@Sufijo+', '+CONVERT(varchar, @SucursalRemota)+', '+@Prefijo+@Campo+@Sufijo+')', @SELECTCampoLocal = 1
SELECT @WHERE_IDLocal = @WHERE_IDLocal + '(NULLIF('+@Tabla+'.'+@Campo+',0) IS NOT NULL AND NULLIF('+@Tabla+'.'+@CampoModulo+','+CHAR(39)+CHAR(39)+') IS NOT NULL)'
SELECT @WHERE_Encabezado = @WHERE_Encabezado + 'dbo.fnVerificarEncabezadoModulo(ISNULL('+@Tabla+'.'+@Campo+',0),'+@Tabla+'.'+@CampoModulo+') = 0 '
SELECT @TieneModulo = 0
END
IF @Campo = 'PolizaID' AND @TipoDatos = 'int'
BEGIN
IF @SELECTCampoLocal = 1 SELECT @SELECT_IDLocal = @SELECT_IDLocal + ' OR ' ELSE
IF @SELECTCampoLocal = 0 SELECT @SELECT_IDLocal = ''
IF @GenerarTabla = 1
BEGIN
SELECT @Modulo = Modulo FROM SysTabla WHERE SysTabla = @Tabla
INSERT SincroISTablaEstructura (SPID,   Tabla,  Modulo, Campo,                   SucursalRemota,  SELECT_IDLocal)
VALUES (@@SPID, @Tabla, 'CONT', @Prefijo+@Campo+@Sufijo, @SucursalRemota, '((dbo.fnIDLocalModulo(''CONT'', '+CONVERT(varchar, @SucursalRemota)+', '+@Prefijo+@Campo+@Sufijo+') IS NULL) AND ('+@Prefijo+@Campo+@Sufijo+' IS NOT NULL))')
END
SELECT @SELECT_IDLocal = @SELECT_IDLocal + '((dbo.fnIDLocalModulo(''CONT'', '+CONVERT(varchar, @SucursalRemota)+', '+@Prefijo+@Campo+@Sufijo+') IS NULL) AND ('+@Prefijo+@Campo+@Sufijo+' IS NOT NULL))'
SELECT @SELECTCampo = 'dbo.fnIDLocalModulo(''CONT'', '+CONVERT(varchar, @SucursalRemota)+', '+@Prefijo+@Campo+@Sufijo+')', @SELECTCampoLocal = 1
END
IF @Campo = 'GestionID' AND @TipoDatos = 'int'
BEGIN
IF @SELECTCampoLocal = 1 SELECT @SELECT_IDLocal = @SELECT_IDLocal + ' OR ' ELSE
IF @SELECTCampoLocal = 0 SELECT @SELECT_IDLocal = ''
IF @GenerarTabla = 1
BEGIN
SELECT @Modulo = Modulo FROM SysTabla WHERE SysTabla = @Tabla
INSERT SincroISTablaEstructura (SPID,   Tabla,  Modulo, Campo,                   SucursalRemota,  SELECT_IDLocal)
VALUES (@@SPID, @Tabla, 'GES',  @Prefijo+@Campo+@Sufijo, @SucursalRemota, '((dbo.fnIDLocalModulo(''GES'', '+CONVERT(varchar, @SucursalRemota)+', '+@Prefijo+@Campo+@Sufijo+') IS NULL) AND ('+@Prefijo+@Campo+@Sufijo+' IS NOT NULL))')
END
SELECT @SELECT_IDLocal = @SELECT_IDLocal + '((dbo.fnIDLocalModulo(''GES'', '+CONVERT(varchar, @SucursalRemota)+', '+@Prefijo+@Campo+@Sufijo+') IS NULL) AND ('+@Prefijo+@Campo+@Sufijo+' IS NOT NULL))'
SELECT @SELECTCampo = 'dbo.fnIDLocalModulo(''GES'', '+CONVERT(varchar, @SucursalRemota)+', '+@Prefijo+@Campo+@Sufijo+')', @SELECTCampoLocal = 1
END
IF @Campo = 'EmbarqueMov' AND @TipoDatos = 'int' 
BEGIN
IF @SELECTCampoLocal = 1 SELECT @SELECT_IDLocal = @SELECT_IDLocal + ' OR ' ELSE
IF @SELECTCampoLocal = 0 SELECT @SELECT_IDLocal = ''
IF @GenerarTabla = 1
BEGIN
SELECT @Modulo = Modulo FROM SysTabla WHERE SysTabla = @Tabla
INSERT SincroISTablaEstructura (SPID,   Tabla,  Modulo,  Campo,                   SucursalRemota,  SELECT_IDLocal)
VALUES (@@SPID, @Tabla, 'SIS13', @Prefijo+@Campo+@Sufijo, @SucursalRemota, '((dbo.fnIDLocalModulo(''SIS13'', '+CONVERT(varchar, @SucursalRemota)+', '+@Prefijo+@Campo+@Sufijo+') IS NULL) AND ('+@Prefijo+@Campo+@Sufijo+' IS NOT NULL))')
END
SELECT @SELECT_IDLocal = @SELECT_IDLocal + '((dbo.fnIDLocalModulo(''SIS13'', '+CONVERT(varchar, @SucursalRemota)+', '+@Prefijo+@Campo+@Sufijo+') IS NULL) AND ('+@Prefijo+@Campo+@Sufijo+' IS NOT NULL))'
SELECT @SELECTCampo = 'dbo.fnIDLocalModulo(''SIS13'', '+CONVERT(varchar, @SucursalRemota)+', '+@Prefijo+@Campo+@Sufijo+')', @SELECTCampoLocal = 1
END
SELECT @SELECT_VALUES = CASE WHEN @EsIdentity = 0 THEN dbo.fnSincroISConcatenarMAX(@SELECT_VALUES,@SELECTCampo+@AS, ', ') ELSE @SELECT_VALUES END
IF @PK = 1 
BEGIN
SELECT @JOIN_IDLocal = dbo.fnSincroISConcatenarMAX(@JOIN_IDLocal, @SELECTCampo+'='+@JOIN_Tabla2+@Campo, ' AND ') 
END
IF CHARINDEX('CHAR', UPPER(@TipoDatos)) > 0
SELECT @TABLE = @TABLE + ' COLLATE Database_Default NULL'
ELSE
SELECT @TABLE = @TABLE + ' NULL'
END
END
FETCH NEXT FROM crSysCampo INTO @Campo, @TipoDatos, @Ancho, @AceptaNulos, @EsIdentity, @EsCalculado
END
CLOSE crSysCampo
DEALLOCATE crSysCampo
RETURN
END

