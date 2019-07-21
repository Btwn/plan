SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFechaRegistroCFD
@Modulo			varchar(5),
@Id				int,
@Accion			varchar(20),
@FechaRegistro	datetime OUTPUT

AS BEGIN
DECLARE
@Sql					nvarchar(max),
@Parametros			nvarchar(max),
@Tabla				varchar(20),
@Empresa				varchar(5),
@FechaMov				datetime,
@FechaHoy				datetime,
@MesMov				int,
@MesActual			int,
@CancelarFactura		varchar(20),
@CancelarFacturaFecha varchar(20)
SET @Tabla = dbo.fnMovTabla(@Modulo)
SET @Parametros = '@Empresa varchar(20) OUTPUT'
SET @SQL = 'SELECT @Empresa = Empresa FROM ' + @Tabla + ' WHERE ID = ' + CONVERT(varchar, @id)
EXEC sp_executesql @Sql, @Parametros, @Empresa = @Empresa OUTPUT
SELECT @CancelarFactura = CancelarFactura, @CancelarFacturaFecha = CancelarFacturaFecha FROM EmpresaCfg WITH (NOLOCK) WHERE Empresa = @Empresa
SELECT @FechaMov = @FechaRegistro, @FechaHoy = GETDATE()
SELECT @MesMov = MONTH(@FechaMov)
SELECT @MesActual = MONTH(@FechaHoy)
IF @Accion = 'CANCELAR'
BEGIN
SELECT @FechaRegistro = @FechaHoy
IF @Modulo = 'VTAS' AND @CancelarFactura <> 'No'
BEGIN
IF @CancelarFactura = 'Cambio Mes'
BEGIN
IF @MesMov <> @MesActual
SELECT @FechaRegistro = @FechaHoy
END ELSE
IF @CancelarFactura = 'Cambio Dia'
BEGIN
IF @FechaMov <> @FechaHoy
SELECT @FechaRegistro = @FechaHoy
END
END
END
END

