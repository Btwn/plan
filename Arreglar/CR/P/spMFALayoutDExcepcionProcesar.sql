SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spMFALayoutDExcepcionProcesar
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
@aplicacion_MovTipo			varchar(20),
@SQL						varchar(max)	OUTPUT,
@SQLDelete					varchar(max)	OUTPUT,
@Ok							int				OUTPUT,
@OkRef						varchar(255)	OUTPUT

AS BEGIN
IF @Accion IN('M-Excep. Ap.')
EXEC spMFALayoutDExcepAp @log_id, @d_id, @Accion, @origen_vista, @folio, @referencia, @aplicacion_origen_id, @aplicacion_origen_modulo, @aplicacion_tipo_aplicacion, @empresa, @aplicacion_Mov, @aplicacion_OrigenTipo, @aplicacion_Origen, @aplicacion_MovTipo, @SQL = @SQL OUTPUT, @SQLDelete = @SQLDelete OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
ELSE IF @Accion IN('N-Excep. Doc.')
EXEC spMFALayoutDExcepDoc @log_id, @d_id, @Accion, @origen_vista, @folio, @referencia, @aplicacion_origen_id, @aplicacion_origen_modulo, @aplicacion_tipo_aplicacion, @empresa, @aplicacion_Mov, @aplicacion_OrigenTipo, @aplicacion_Origen, @SQL = @SQL OUTPUT, @SQLDelete = @SQLDelete OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
ELSE IF @Accion = 'O-Excep. Ap. Esp.'
EXEC spMFALayoutDExcepApEsp @log_id, @d_id, @Accion, @origen_vista, @folio, @referencia, @aplicacion_origen_id, @aplicacion_origen_modulo, @aplicacion_tipo_aplicacion, @empresa, @aplicacion_Mov, @aplicacion_OrigenTipo, @aplicacion_Origen, @SQL = @SQL OUTPUT, @SQLDelete = @SQLDelete OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
ELSE IF @Accion = 'P-Excep. Doc. Esp.'
EXEC spMFALayoutDExcepDocEsp @log_id, @d_id, @Accion, @origen_vista, @folio, @referencia, @aplicacion_origen_id, @aplicacion_origen_modulo, @aplicacion_tipo_aplicacion, @empresa, @aplicacion_Mov, @aplicacion_OrigenTipo, @aplicacion_Origen, @SQL = @SQL OUTPUT, @SQLDelete = @SQLDelete OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
ELSE IF @Accion IN('Q-Excep. Reporte', 'R-Excep. Reporte IEPS', 'S-Excep. Reporte IETU', 'T-Excep. Reporte IVA')
EXEC spMFALayoutDExcepReporte @log_id, @d_id, @Accion, @origen_vista, @folio, @referencia, @aplicacion_origen_id, @aplicacion_origen_modulo, @aplicacion_tipo_aplicacion, @empresa, @aplicacion_Mov, @aplicacion_OrigenTipo, @aplicacion_Origen, @SQL = @SQL OUTPUT, @SQLDelete = @SQLDelete OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
ELSE IF @Accion IN('H-Cambiar a Aplicacion', 'I-Cambiar a Cobro', 'J-Cambiar a Endoso', 'K-Cambiar a Pago', 'L-Cambiar a Redoc.')
EXEC spMFALayoutDAplicacionCambio @log_id, @d_id, @Accion, @origen_vista, @folio, @referencia, @aplicacion_origen_id, @aplicacion_origen_modulo, @aplicacion_tipo_aplicacion, @empresa, @aplicacion_Mov, @aplicacion_OrigenTipo, @aplicacion_Origen, @SQL = @SQL OUTPUT, @SQLDelete = @SQLDelete OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
ELSE IF @Accion IN('A-Agregar Anticipo', 'B-Agregar Comp. Gasto', 'C-Agregar Factura', 'D-Agregar Nota Cargo', 'E-Agregar Nota Credito', 'F-Agregar Devolucion', 'G-Agregar Prestamo')
EXEC spMFALayoutDAgregarDocumento @log_id, @d_id, @Accion, @origen_vista, @folio, @referencia, @aplicacion_origen_id, @aplicacion_origen_modulo, @aplicacion_tipo_aplicacion, @empresa, @aplicacion_Mov, @aplicacion_OrigenTipo, @aplicacion_Origen, @SQL = @SQL OUTPUT, @SQLDelete = @SQLDelete OUTPUT, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
RETURN
END

