SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spOportunidadParsearMensaje
@EstacionTrabajo			int,
@PlantillaeMail				varchar(20),
@ID							int,
@Empresa					varchar(5),
@Sucursal					int,
@UEN						int,
@Usuario					varchar(10),
@Mov						varchar(50),
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
@Asunto						varchar(255) OUTPUT,
@Mensaje					varchar(max) OUTPUT,
@Ok							int = NULL OUTPUT,
@OkRef						varchar(255) = NULL OUTPUT,
@RutaAnexo					varchar(255) = NULL OUTPUT,
@NombreAnexo				varchar(255) = NULL OUTPUT

AS BEGIN
DECLARE @Ahora				datetime,
@Hoy	 				datetime,
@ConsultaNombre		varchar(50),
@Valor				varchar(255)
SET @Ahora = GETDATE()
SET @Hoy = dbo.fnFechaSinHora(@Ahora)
SET @Asunto = REPLACE(@Asunto,'<Empresa>',ISNULL(RTRIM(@Empresa),''))
SET @Asunto = REPLACE(@Asunto,'<EmpresaNombre>',ISNULL(RTRIM(@EmpresaNombre),''))
SET @Asunto = REPLACE(@Asunto,'<Sucursal>',ISNULL(RTRIM(CONVERT(varchar,@Sucursal)),''))
SET @Asunto = REPLACE(@Asunto,'<SucursalNombre>',ISNULL(RTRIM(@SucursalNombre),''))
SET @Asunto = REPLACE(@Asunto,'<UEN>',ISNULL(RTRIM(CONVERT(varchar,@UEN)),''))
SET @Asunto = REPLACE(@Asunto,'<UENNombre>',ISNULL(RTRIM(@UENNombre),''))
SET @Asunto = REPLACE(@Asunto,'<Usuario>',ISNULL(RTRIM(@Usuario),''))
SET @Asunto = REPLACE(@Asunto,'<UsuarioNombre>',ISNULL(RTRIM(@UsuarioNombre),''))
SET @Asunto = REPLACE(@Asunto,'<Movimiento>',ISNULL(RTRIM(@Mov),''))
SET @Asunto = REPLACE(@Asunto,'<Estatus>',ISNULL(RTRIM(@Estatus),''))
SET @Asunto = REPLACE(@Asunto,'<Situacion>',ISNULL(RTRIM(@Situacion),''))
SET @Asunto = REPLACE(@Asunto,'<Proyecto>',ISNULL(RTRIM(@Proyecto),''))
SET @Asunto = REPLACE(@Asunto,'<ContactoTipo>',ISNULL(RTRIM(@ContactoTipo),''))
SET @Asunto = REPLACE(@Asunto,'<Contacto>',ISNULL(RTRIM(@Contacto),''))
SET @Asunto = REPLACE(@Asunto,'<Importe>',ISNULL(RTRIM(CONVERT(varchar, CONVERT(money, @Importe), 1)),''))
SET @Asunto = REPLACE(@Asunto,'<ContactoNombre>',ISNULL(RTRIM(@ContactoNombre),''))
SET @Asunto = REPLACE(@Asunto,'<Hoy>',ISNULL(RTRIM(CONVERT(varchar,@Hoy)),''))
SET @Asunto = REPLACE(@Asunto,'<Ahora>',ISNULL(RTRIM(CONVERT(varchar,@Ahora)),''))
SET @Asunto = REPLACE(@Asunto,'<FechaEmision>',ISNULL(RTRIM(CONVERT(varchar,@FechaEmision)),''))
SET @Asunto = REPLACE(@Asunto,'<Modulo>', 'Oportunidades')
SET @Asunto = REPLACE(@Asunto,'<ID>',ISNULL(RTRIM(CONVERT(varchar,@ID)),''))
SET @Mensaje = REPLACE(@Mensaje,'<Modulo>', 'Oportunidades')
SET @Mensaje = REPLACE(@Mensaje,'<Empresa>',ISNULL(RTRIM(@Empresa),''))
SET @Mensaje = REPLACE(@Mensaje,'<EmpresaNombre>',ISNULL(RTRIM(@EmpresaNombre),''))
SET @Mensaje = REPLACE(@Mensaje,'<Sucursal>',ISNULL(RTRIM(CONVERT(varchar,@Sucursal)),''))
SET @Mensaje = REPLACE(@Mensaje,'<SucursalNombre>',ISNULL(RTRIM(@SucursalNombre),''))
SET @Mensaje = REPLACE(@Mensaje,'<UEN>',ISNULL(RTRIM(CONVERT(varchar,@UEN)),''))
SET @Mensaje = REPLACE(@Mensaje,'<UENNombre>',ISNULL(RTRIM(@UENNombre),''))
SET @Mensaje = REPLACE(@Mensaje,'<Usuario>',ISNULL(RTRIM(@Usuario),''))
SET @Mensaje = REPLACE(@Mensaje,'<UsuarioNombre>',ISNULL(RTRIM(@UsuarioNombre),''))
SET @Mensaje = REPLACE(@Mensaje,'<Movimiento>',ISNULL(RTRIM(@Mov),''))
SET @Mensaje = REPLACE(@Mensaje,'<Estatus>',ISNULL(RTRIM(@Estatus),''))
SET @Mensaje = REPLACE(@Mensaje,'<Situacion>',ISNULL(RTRIM(@Situacion),''))
SET @Mensaje = REPLACE(@Mensaje,'<Proyecto>',ISNULL(RTRIM(@Proyecto),''))
SET @Mensaje = REPLACE(@Mensaje,'<ContactoTipo>',ISNULL(RTRIM(@ContactoTipo),''))
SET @Mensaje = REPLACE(@Mensaje,'<Contacto>',ISNULL(RTRIM(@Contacto),''))
SET @Mensaje = REPLACE(@Mensaje,'<Importe>',ISNULL(RTRIM(CONVERT(varchar, CONVERT(money, @Importe), 1)),''))
SET @Mensaje = REPLACE(@Mensaje,'<ContactoNombre>',ISNULL(RTRIM(@ContactoNombre),''))
SET @Mensaje = REPLACE(@Mensaje,'<Hoy>',ISNULL(RTRIM(CONVERT(varchar,@Hoy)),''))
SET @Mensaje = REPLACE(@Mensaje,'<Ahora>',ISNULL(RTRIM(CONVERT(varchar,@Ahora)),''))
SET @Mensaje = REPLACE(@Mensaje,'<FechaEmision>',ISNULL(RTRIM(CONVERT(varchar,@FechaEmision)),''))
SET @Mensaje = REPLACE(@Mensaje,'<ID>',ISNULL(RTRIM(CONVERT(varchar,@ID)),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<Empresa>',ISNULL(RTRIM(@Empresa),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<EmpresaNombre>',ISNULL(RTRIM(@EmpresaNombre),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<Sucursal>',ISNULL(RTRIM(CONVERT(varchar,@Sucursal)),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<SucursalNombre>',ISNULL(RTRIM(@SucursalNombre),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<UEN>',ISNULL(RTRIM(CONVERT(varchar,@UEN)),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<UENNombre>',ISNULL(RTRIM(@UENNombre),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<Usuario>',ISNULL(RTRIM(@Usuario),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<UsuarioNombre>',ISNULL(RTRIM(@UsuarioNombre),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<Movimiento>',ISNULL(RTRIM(@Mov),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<Estatus>',ISNULL(RTRIM(@Estatus),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<Situacion>',ISNULL(RTRIM(@Situacion),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<Proyecto>',ISNULL(RTRIM(@Proyecto),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<ContactoTipo>',ISNULL(RTRIM(@ContactoTipo),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<Contacto>',ISNULL(RTRIM(@Contacto),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<Importe>',ISNULL(RTRIM(CONVERT(varchar, CONVERT(money, @Importe), 1)),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<ContactoNombre>',ISNULL(RTRIM(@ContactoNombre),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<Hoy>',ISNULL(RTRIM(CONVERT(varchar,@Hoy)),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<Ahora>',ISNULL(RTRIM(CONVERT(varchar,@Ahora)),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<FechaEmision>',ISNULL(RTRIM(CONVERT(varchar,@FechaEmision)),''))
SET @RutaAnexo = REPLACE(@RutaAnexo,'<Modulo>', 'Oportunidades')
SET @RutaAnexo = REPLACE(@RutaAnexo,'<ID>',ISNULL(RTRIM(CONVERT(varchar,@ID)),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<Empresa>',ISNULL(RTRIM(@Empresa),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<EmpresaNombre>',ISNULL(RTRIM(@EmpresaNombre),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<Sucursal>',ISNULL(RTRIM(CONVERT(varchar,@Sucursal)),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<SucursalNombre>',ISNULL(RTRIM(@SucursalNombre),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<UEN>',ISNULL(RTRIM(CONVERT(varchar,@UEN)),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<UENNombre>',ISNULL(RTRIM(@UENNombre),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<Usuario>',ISNULL(RTRIM(@Usuario),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<UsuarioNombre>',ISNULL(RTRIM(@UsuarioNombre),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<Movimiento>',ISNULL(RTRIM(@Mov),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<Estatus>',ISNULL(RTRIM(@Estatus),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<Situacion>',ISNULL(RTRIM(@Situacion),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<Proyecto>',ISNULL(RTRIM(@Proyecto),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<ContactoTipo>',ISNULL(RTRIM(@ContactoTipo),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<Contacto>',ISNULL(RTRIM(@Contacto),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<Importe>',ISNULL(RTRIM(CONVERT(varchar, CONVERT(money, @Importe), 1)),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<ContactoNombre>',ISNULL(RTRIM(@ContactoNombre),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<Hoy>',ISNULL(RTRIM(CONVERT(varchar,@Hoy)),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<Ahora>',ISNULL(RTRIM(CONVERT(varchar,@Ahora)),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<FechaEmision>',ISNULL(RTRIM(CONVERT(varchar,@FechaEmision)),''))
SET @NombreAnexo = REPLACE(@NombreAnexo,'<Modulo>', 'Oportunidades')
SET @NombreAnexo = REPLACE(@NombreAnexo,'<ID>',ISNULL(RTRIM(CONVERT(varchar,@ID)),''))
SELECT @Mensaje = REPLACE(@Mensaje,'<','&#060;')
SELECT @Mensaje = REPLACE(@Mensaje,'>','&#062;')
END

