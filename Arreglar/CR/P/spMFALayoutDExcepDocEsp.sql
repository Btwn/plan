SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spMFALayoutDExcepDocEsp
@log_id						int,
@d_id						int,
@Accion						varchar(50),
@origen_vista				varchar(255),
@folio						varchar(50),
@referencia					varchar(50),
@aplicacion_origen_id		int,
@aplicacion_origen_modulo	varchar(50),
@aplicacion_tipo_aplicacion	varchar(50),
@empresa					varchar(5),
@aplicacion_Mov				varchar(20),
@aplicacion_OrigenTipo		varchar(5),
@aplicacion_Origen			varchar(20),
@SQL						varchar(max)	OUTPUT,
@SQLDelete 					varchar(max)	OUTPUT,
@Ok							int				OUTPUT,
@OkRef						varchar(255)	OUTPUT

AS BEGIN
DECLARE @TablaExcepcion		varchar(255),
@documento_origen_id	int
SELECT @documento_origen_id = ID FROM MFAMovimientoLista WHERE Modulo = @aplicacion_origen_modulo AND Movimiento = @referencia AND Empresa = @empresa
SELECT @TablaExcepcion = 'MFAMovExcepcion'
SELECT @SQLDelete = 'DELETE ' + @TablaExcepcion + ' WHERE Modulo = ''' + ISNULL(@aplicacion_origen_modulo, '') + ''' AND ModuloID = ''' + ISNULL(CONVERT(varchar, @documento_origen_id), '') + '''' + CHAR(13) + CHAR(10)
SELECT @SQL = 'IF NOT EXISTS(SELECT * FROM ' + @TablaExcepcion + ' WHERE Modulo = ''' + ISNULL(@aplicacion_origen_modulo, '') + ''' AND ModuloID = ''' + ISNULL(CONVERT(varchar, @documento_origen_id), '') + ''')' + CHAR(13) + CHAR(10)
SELECT @SQL = @SQL + 'INSERT INTO ' + @TablaExcepcion + '(Modulo, ModuloID) VALUES(''' + ISNULL(CONVERT(varchar, @aplicacion_origen_modulo), '') + ''', ''' + ISNULL(CONVERT(varchar, @documento_origen_id), '') + ''')' + CHAR(13) + CHAR(10)
RETURN
END

