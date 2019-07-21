SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spMFALayoutDProcesar
@log_id			int,
@Cancelar		bit,
@Ok				int			 = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
SET NOCOUNT ON
DECLARE @d_id							int,
@d_idAnt						int,
@Accion						varchar(50),
@origen_vista					varchar(255),
@OkDesc						varchar(255),
@OkTipo						varchar(50),
@SQL							nvarchar(max),
@SQLDeleteEx					varchar(max),
@SQLExcepcion					varchar(max),
@SQLDelete					nvarchar(max),
@folio						varchar(50),
@referencia					varchar(50),
@aplicacion_origen_id			int,
@aplicacion_origen_modulo		varchar(50),
@aplicacion_tipo_aplicacion	varchar(50),
@aplicacion_Mov				varchar(20),
@aplicacion_MovTipo			varchar(20),
@aplicacion_OrigenTipo		varchar(5),
@aplicacion_Origen			varchar(20),
@empresa						varchar(5)
IF NOT EXISTS(SELECT * FROM layout_logd WITH (NOLOCK)  WHERE log_id = @log_id AND ISNULL(Accion, '') <> '')
SELECT @Ok = 60010
SELECT @SQL			= '',
@SQLDeleteEx	= '',
@SQLExcepcion	= '',
@SQLDelete		= ''
IF @Cancelar = 0 AND @Ok IS NULL
BEGIN
SELECT @SQL = ''
CREATE TABLE #Resultado(ID int IDENTITY, Sentencia varchar(max))
CREATE TABLE #ResultadoDelete(ID int IDENTITY, Sentencia varchar(max))
SELECT @d_idAnt = 0
WHILE(1=1)
BEGIN
SELECT @d_id = MIN(d_id)
FROM layout_logd WITH (NOLOCK) 
WHERE log_id = @log_id
AND ISNULL(Accion, '') <> ''
AND d_id > @d_idAnt
IF @d_id IS NULL BREAK
SELECT @d_idAnt = @d_id
SELECT @Accion = Accion,
@origen_vista = ISNULL(origen_vista, ''),
@folio = ISNULL(folio, ''),
@referencia = ISNULL(referencia, ''),
@aplicacion_origen_id = aplicacion_origen_id,
@aplicacion_origen_modulo = ISNULL(aplicacion_origen_modulo, ''),
@aplicacion_tipo_aplicacion = ISNULL(aplicacion_tipo_aplicacion, ''),
@empresa = ISNULL(empresa, '')
FROM layout_logd WITH (NOLOCK) 
WHERE log_id = @log_id
AND d_id = @d_id
IF @aplicacion_origen_id IS NULL
SELECT @aplicacion_origen_id = ID FROM MFAMovimientoLista  WITH (NOLOCK) WHERE Modulo = @aplicacion_origen_modulo AND Movimiento = @folio AND Empresa = @empresa
EXEC spMovInfo @aplicacion_origen_id, @aplicacion_origen_modulo, @MovTipo = @aplicacion_MovTipo OUTPUT, @Mov = @aplicacion_Mov OUTPUT, @OrigenTipo = @aplicacion_OrigenTipo OUTPUT, @Origen = @aplicacion_Origen OUTPUT
EXEC spMFALayoutDExcepcionProcesar @log_id, @d_id, @Accion, @origen_vista, @folio, @referencia, @aplicacion_origen_id, @aplicacion_origen_modulo, @aplicacion_tipo_aplicacion, @empresa, @aplicacion_Mov, @aplicacion_OrigenTipo, @aplicacion_Origen, @aplicacion_MovTipo, @SQL = @SQLExcepcion OUTPUT, @SQLDelete = @SQLDeleteEx OUTPUT,  @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF ISNULL(@SQLExcepcion, '') <> ''
INSERT INTO #Resultado(Sentencia) SELECT ISNULL(@SQLExcepcion, '') + CHAR(13) + CHAR(10)
IF ISNULL(@SQLDeleteEx, '') <> ''
INSERT INTO #ResultadoDelete(Sentencia) SELECT ISNULL(@SQLDeleteEx, '') + CHAR(13) + CHAR(10)
END
IF @Ok IS NULL
BEGIN
EXEC spMFALayoutDSentenciaArmar 'Sentencia', @SQL = @SQL OUTPUT
EXEC spMFALayoutDSentenciaArmar 'Sentencia Delete', @SQL = @SQLDelete OUTPUT
BEGIN TRY
EXEC sp_executesql @SQL
UPDATE layout_log WITH (ROWLOCK) SET SQL = @SQL, SQLDelete = @SQLDelete, EstatusAnalisis = 'CONCLUIDO' WHERE log_id = @log_id
END TRY
BEGIN CATCH
SELECT @Ok = 1, @OkRef = dbo.fnOkRefSQL(ERROR_NUMBER(), ERROR_MESSAGE())
END CATCH
END
END
ELSE IF @Cancelar = 1
BEGIN
SELECT @SQLDelete = SQLDelete FROM layout_log WITH (NOLOCK)  WHERE log_id = @log_id
BEGIN TRY
EXEC sp_executesql @SQLDelete
UPDATE layout_log  WITH (ROWLOCK) SET SQL = '', SQLDelete = '', EstatusAnalisis = 'SINAFECTAR' WHERE log_id = @log_id
END TRY
BEGIN CATCH
SELECT @Ok = 1, @OkRef = dbo.fnOkRefSQL(ERROR_NUMBER(), ERROR_MESSAGE())
END CATCH
END
IF @Ok IS NULL
SELECT @OkRef = NULL
ELSE
SELECT @OkDesc = Descripcion,
@OkTipo = Tipo
FROM MensajeLista WITH (NOLOCK) 
WHERE Mensaje = @Ok
SELECT @Ok, @OkDesc, @OkTipo, @OkRef, NULL
END

