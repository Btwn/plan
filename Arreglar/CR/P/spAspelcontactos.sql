SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spAspelcontactos]

AS DECLARE
@SrvOrigenSAE		varchar(50),
@BDOrigenSAE		varchar(30),
@OrigenSAE			varchar(100),
@RutaSAE			varchar(250),
@EmpresaSAE			int,
@SrvIntelisis		varchar(50),
@BaseDatosIntelisis	varchar(30),
@sql				nvarchar(1000),
@Cuenta				int,
@Empresa			varchar(2),
@Tabla				varchar(15),
@contac				varchar(20),
@Juego				smallint,
@Descrip			varchar(20),
@Id					int,
@direccion			varchar(100),
@telefono			varchar(50),
@email				varchar(100),
@tipocontac			varchar(20),
@nombre				varchar(50),
@telefonos			varchar(50),
@tipo				varchar(20),
@usuario			varchar(10)
BEGIN
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SELECT @SrvOrigenSAE = Valor FROM AspelCfgOpcion WHERE Descripcion = 'Servidor SAE'
select @Cuenta = count(*) from master.dbo.sysservers where srvname = @SrvOrigenSAE
if @Cuenta = 0
exec sp_addlinkedserver @SrvOrigenSAE
SELECT @BDOrigenSAE = Valor FROM AspelCfgOpcion WHERE Descripcion = 'Base De Datos SAE'
SELECT @SrvOrigenSAE = Valor FROM AspelCfgOpcion WHERE Descripcion = 'Servidor SAE'
SELECT @EmpresaSAE = Valor FROM AspelCfgOpcion WHERE Descripcion = 'Empresa SAE'
SET @Empresa = RIGHT('00' + convert(varchar, @EmpresaSAE),2)
SET @Tabla = 'CONTAC' + @Empresa
exec master..sp_serveroption @SrvOrigenSAE, 'use remote collation', 'false'
DECLARE
@IDCTECTODIR int
SET @sql = 'DECLARE curcontac CURSOR FOR ' +
'SELECT ltrim(rtrim(CCLIE)), NOMBRE, DIRECCION, TELEFONO,EMAIL,TIPOCONTAC ' +
'FROM '+ @SrvOrigenSAE + '.' + @BDOrigenSAE + '.dbo.' + @Tabla
EXEC sp_executesql @Sql
OPEN curcontac
FETCH NEXT FROM curcontac INTO @contac,@nombre,@direccion,@telefono,@email,@tipocontac
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT INTO ctecto (Cliente, Nombre,Telefonos,email,pedirtono,tipo,usuario,cfd_enviar, Atencion)
VALUES (dbo.fnAspelJustificaClave(@contac), @Nombre,@Telefono,@email,0,@tipo, @Usuario,0,@contac)
SET @IDCTECTODIR = SCOPE_IDENTITY()
INSERT INTO ctectodireccion (Cliente, ID, Tipo, Direccion)
VALUES (dbo.fnAspelJustificaClave(@contac), @IDCTECTODIR, 'Trabajo', @direccion)
FETCH NEXT FROM curcontac INTO @contac,@nombre,@direccion,@telefono,@email,@tipocontac
END
CLOSE curcontac
DEALLOCATE curcontac
SET ANSI_NULLS OFF
SET ANSI_WARNINGS OFF
END

