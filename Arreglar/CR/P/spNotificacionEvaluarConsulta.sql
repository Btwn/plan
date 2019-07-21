SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNotificacionEvaluarConsulta
@ID							int,
@Modulo						varchar(5),
@Notificacion				varchar(50),
@NotificacionClave			varchar(50),
@Empresa					varchar(5),
@Sucursal					int,
@UEN						int,
@Usuario					varchar(10),
@Mov						varchar(20),
@Estatus					varchar(15),
@Situacion					varchar(50),
@Proyecto					varchar(50),
@ContactoTipo				varchar(20),
@Contacto					varchar(10),
@Importe					float,
@EmpresaNombre				varchar(100),
@SucursalNombre				varchar(100),
@UENNombre					varchar(100),
@UsuarioNombre				varchar(100),
@ContactoNombre				varchar(100),
@FechaEmision				datetime,
@Consulta					nvarchar(max),
@Resultado					varchar(255) OUTPUT,
@Ok							int = NULL OUTPUT,
@OkRef						varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE
@Ahora				datetime,
@Hoy					datetime,
@SQL					nvarchar(max),
@Parametros			nvarchar(max),
@Error				int,
@ErrorRef				varchar(255)
SET @Ahora = GETDATE()
SET @Hoy = dbo.fnFechaSinHora(@Ahora)
SET @Consulta = REPLACE(@Consulta,'<Modulo>',CHAR(39) + ISNULL(RTRIM(@Modulo),'') + CHAR(39))
SET @Consulta = REPLACE(@Consulta,'<ID>',ISNULL(RTRIM(CONVERT(varchar,@ID)),''))
SET @Consulta = REPLACE(@Consulta,'<Modulo>',CHAR(39) + ISNULL(RTRIM(@Modulo),'') + CHAR(39))
SET @Consulta = REPLACE(@Consulta,'<Empresa>',CHAR(39) + ISNULL(RTRIM(@Empresa),'') + CHAR(39))
SET @Consulta = REPLACE(@Consulta,'<EmpresaNombre>',CHAR(39) + ISNULL(RTRIM(@EmpresaNombre),'') + CHAR(39))
SET @Consulta = REPLACE(@Consulta,'<Sucursal>',ISNULL(RTRIM(CONVERT(varchar,@Sucursal)),''))
SET @Consulta = REPLACE(@Consulta,'<SucursalNombre>',CHAR(39) + ISNULL(RTRIM(@SucursalNombre),'') + CHAR(39))
SET @Consulta = REPLACE(@Consulta,'<UEN>',ISNULL(RTRIM(CONVERT(varchar,@UEN)),''))
SET @Consulta = REPLACE(@Consulta,'<UENNombre>',CHAR(39) + ISNULL(RTRIM(@UENNombre),'') + CHAR(39))
SET @Consulta = REPLACE(@Consulta,'<Usuario>',CHAR(39) + ISNULL(RTRIM(@Usuario),'') + CHAR(39))
SET @Consulta = REPLACE(@Consulta,'<UsuarioNombre>',CHAR(39) + ISNULL(RTRIM(@UsuarioNombre),'') + CHAR(39))
SET @Consulta = REPLACE(@Consulta,'<Movimiento>',CHAR(39) + ISNULL(RTRIM(@Mov),'') + CHAR(39))
SET @Consulta = REPLACE(@Consulta,'<Estatus>',CHAR(39) + ISNULL(RTRIM(@Estatus),'') + CHAR(39))
SET @Consulta = REPLACE(@Consulta,'<Situacion>',CHAR(39) + ISNULL(RTRIM(@Situacion),'') + CHAR(39))
SET @Consulta = REPLACE(@Consulta,'<Proyecto>',CHAR(39) + ISNULL(RTRIM(@Proyecto),'') + CHAR(39))
SET @Consulta = REPLACE(@Consulta,'<ContactoTipo>',CHAR(39) + ISNULL(RTRIM(@ContactoTipo),'') + CHAR(39))
SET @Consulta = REPLACE(@Consulta,'<Contacto>',CHAR(39) + ISNULL(RTRIM(@Contacto),'') + CHAR(39))
SET @Consulta = REPLACE(@Consulta,'<Importe>',ISNULL(RTRIM(CONVERT(varchar,@Importe)),''))
SET @Consulta = REPLACE(@Consulta,'<ContactoNombre>',CHAR(39) + ISNULL(RTRIM(@ContactoNombre),'') + CHAR(39))
SET @Consulta = REPLACE(@Consulta,'<Hoy>',CHAR(39) + ISNULL(RTRIM(CONVERT(varchar,@Hoy)),'') + CHAR(39))
SET @Consulta = REPLACE(@Consulta,'<Ahora>',CHAR(39) + ISNULL(RTRIM(CONVERT(varchar,@Ahora)),'') + CHAR(39))
SET @Consulta = REPLACE(@Consulta,'<FechaEmision>',CHAR(39) + ISNULL(RTRIM(CONVERT(varchar,@FechaEmision)),'') + CHAR(39))
SET @Consulta = REPLACE(@Consulta,'<Notificacion>',CHAR(39) + ISNULL(RTRIM(@Notificacion),'') + CHAR(39))
SET @Consulta = ISNULL(@Consulta,'')
IF NULLIF(@Consulta,'') IS NOT NULL
BEGIN
SET @Parametros = N'@Resultado varchar(255) OUTPUT, @Error int OUTPUT, @ErrorRef varchar(255) OUTPUT'
SET @SQL = N'BEGIN TRY ' +
N'  SET @Resultado = (' + RTRIM(@Consulta) + ') ' +
N'END TRY ' +
N'BEGIN CATCH ' +
N'  SELECT @Error = @@ERROR,  @ErrorRef = ERROR_MESSAGE() ' +
N'  IF XACT_STATE() = -1 ' +
N'  BEGIN ' +
N'    ROLLBACK TRAN ' +
N'    SET @ErrorRef = ' + CHAR(39) + 'Error: ' + CHAR(39) + ' + CONVERT(varchar,@Error) + ' + CHAR(39) + ', ' + CHAR(39) + ' + @ErrorRef ' +
N'    RAISERROR(@ErrorRef,20,1) WITH LOG ' +
N'  END ' +
N'END CATCH '
EXECUTE sp_executesql @SQL, @Parametros,
@Resultado = @Resultado OUTPUT,
@Error = @Error OUTPUT,
@ErrorRef = @ErrorRef OUTPUT
IF @Error IS NOT NULL SELECT @Ok = @Error, @OkRef = @ErrorRef
END
RETURN
END

