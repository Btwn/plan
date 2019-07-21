SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spMFALayoutDAgregarDocumento
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
@DocumentoTipo		varchar(50),
@aplicacion_Aplica	varchar(20)
SELECT @aplicacion_Aplica = dbo.fnMovEnReferencia(@referencia)
IF @Accion = 'A-Agregar Anticipo'
SELECT @DocumentoTipo = 'anticipo'
ELSE IF @Accion = 'B-Agregar Comp. Gasto'
SELECT @DocumentoTipo = 'comprobante_gasto'
ELSE IF @Accion = 'C-Agregar Factura'
SELECT @DocumentoTipo = 'factura'
ELSE IF @Accion = 'D-Agregar Nota Cargo'
SELECT @DocumentoTipo = 'nota_cargo'
ELSE IF @Accion = 'E-Agregar Nota Credito'
SELECT @DocumentoTipo = 'nota_credito'
ELSE IF @Accion = 'F-Agregar Devolucion'
SELECT @DocumentoTipo = 'devolucion'
ELSE IF @Accion = 'G-Agregar Prestamo'
SELECT @DocumentoTipo = 'prestamo'
SELECT @TablaExcepcion = 'MovTipoMFADocAdicion'
SELECT @SQLDelete = 'DELETE ' + @TablaExcepcion + ' WHERE Modulo = ''' + ISNULL(@aplicacion_origen_modulo, '') + ''' AND Mov = ''' + ISNULL(CONVERT(varchar, @aplicacion_Aplica), '') + '''' + CHAR(13) + CHAR(10)
SELECT @SQL = 'IF NOT EXISTS(SELECT * FROM '+ @TablaExcepcion + ' WHERE Modulo = ''' + ISNULL(@aplicacion_origen_modulo, '') + ''' AND Mov = ''' + ISNULL(CONVERT(varchar, @aplicacion_Aplica), '') + ''')' + CHAR(13) + CHAR(10)
SELECT @SQL = @SQL + 'INSERT INTO ' + @TablaExcepcion + '(Modulo, Mov, DocumentoTipo) VALUES(''' + ISNULL(CONVERT(varchar, @aplicacion_origen_modulo), '') + ''', ''' + ISNULL(CONVERT(varchar, @aplicacion_Aplica), '') + ''', ''' + @DocumentoTipo + ''')' + CHAR(13) + CHAR(10)
RETURN
END

