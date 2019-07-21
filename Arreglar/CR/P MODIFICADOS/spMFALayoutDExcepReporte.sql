SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spMFALayoutDExcepReporte
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
@AplicaIetu			varchar(2),
@AplicaIeps			varchar(2),
@AplicaIVA			varchar(2),
@aplicacion_Aplica	varchar(20)
SELECT @aplicacion_Aplica = dbo.fnMovEnReferencia(@referencia)
IF @Accion = 'Q-Excep. Reporte'
SELECT @AplicaIetu = 'No', @AplicaIeps = 'No', @AplicaIVA = 'No'
ELSE IF @Accion = 'R-Excep. Reporte IEPS'
SELECT @AplicaIetu = 'Si', @AplicaIeps = 'No', @AplicaIVA = 'Si'
ELSE IF @Accion = 'S-Excep. Reporte IETU'
SELECT @AplicaIetu = 'No', @AplicaIeps = 'Si', @AplicaIVA = 'Si'
ELSE IF @Accion = 'T-Excep. Reporte IVA'
SELECT @AplicaIetu = 'Si', @AplicaIeps = 'Si', @AplicaIVA = 'No'
SELECT @TablaExcepcion = 'MovTipoMFAAplicaReporteExcepcion'
SELECT @SQLDelete = 'DELETE ' + @TablaExcepcion + ' WHERE Modulo = ''' + ISNULL(@aplicacion_origen_modulo, '') + ''' AND Mov = ''' + ISNULL(@aplicacion_Mov, '') + ''' AND OrigenTipo = ''' + ISNULL(@aplicacion_origen_modulo, '') + ''' AND Origen = ''' + ISNULL(@aplicacion_Aplica, '') + '''' + CHAR(13) + CHAR(10)
SELECT @SQL = 'IF NOT EXISTS(SELECT * FROM '+ @TablaExcepcion + ' WHERE Modulo = ''' + ISNULL(@aplicacion_origen_modulo, '') + ''' AND Mov = ''' + ISNULL(@aplicacion_Mov, '') + ''' AND OrigenTipo = ''' + ISNULL(@aplicacion_origen_modulo, '') + ''' AND Origen = ''' + ISNULL(@aplicacion_Aplica, '') + ''')' + CHAR(13) + CHAR(10)
SELECT @SQL = @SQL + 'INSERT INTO ' + @TablaExcepcion + '(Modulo, Mov, OrigenTipo, Origen, AplicaIetu, AplicaIeps, AplicaIVA) VALUES(''' + ISNULL(@aplicacion_origen_modulo, '') + ''', ''' + ISNULL(@aplicacion_Mov, '') + ''', ''' + ISNULL(@aplicacion_origen_modulo, '') + ''', ''' + ISNULL(@aplicacion_Aplica, '') + ''', ''' + @AplicaIetu + ''', ''' + @AplicaIeps + ''', ''' + @AplicaIVA + ''')' + CHAR(13) + CHAR(10)
RETURN
END

