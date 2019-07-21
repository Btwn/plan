SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spinsertagrupos

AS
DECLARE
@BDatos			varchar(30),		
@BDOrigenSAE			varchar(30),
@SrvOrigenSAE			varchar(50),
@OrigenSAE				varchar(100),
@RutaSAE				varchar(250),
@Empresa			varchar(2),
@ImportaCOI			bit,
@SrvOrigenCOI			varchar(50),
@BDOrigenCOI			varchar(30),
@OrigenCOI				varchar(100),
@RutaCOI				varchar(250),
@EmpresaCOI			int,
@BaseDatosPaso		varchar(30),
@SrvIntelisis			varchar(50),
@BaseDatosIntelisis	varchar(30),
@sql					nvarchar(1000),
@Cuenta				int,
@Tabla				varchar(25)
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SELECT @SrvOrigenCOI = Valor FROM AspelCfgOpcion WITH(NOLOCK) WHERE Descripcion = 'Servidor COI'
select @Cuenta = count(*) from master.dbo.sysservers where srvname = @SrvOrigenCOI
if @Cuenta = 0
exec sp_addlinkedserver @SrvOrigenCOI
SELECT @BDOrigenCOI = Valor FROM AspelCfgOpcion WITH(NOLOCK) WHERE Descripcion = 'Base De Datos COI'
SELECT @SrvOrigenCOI = Valor FROM AspelCfgOpcion WITH(NOLOCK) WHERE Descripcion = 'Servidor COI'
SELECT @EmpresaCOI = Valor FROM AspelCfgOpcion WITH(NOLOCK) WHERE Descripcion = 'Empresa COI'
SET @Empresa = RIGHT('00' + convert(varchar, @EmpresaCOI),2)
SET @Tabla = 'DEPTO' + @Empresa
BEGIN
SET @SQL = ''
+ 'INSERT CENTROCOSTOS (CentroCostos,Descripcion,Esacumulativo,Tienemovimientos,Estatus)'
+ 'Select convert(varchar,NUM_REG), DESCRIP,' + char(39) + '0' +char(39) +',' + char(39) +'0'+char(39)+','+ char(39) + 'ALTA'+ char(39)
+ ' from '+ @SrvOrigenCOI +'.'+@BDOrigenCOI +'.dbo.'+ @Tabla
EXEC sp_executesql @SQL
END

