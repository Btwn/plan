SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spAspelKits]

AS
DECLARE
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
@Kit				varchar(20),
@Art				varchar(20),
@Juego				smallint,
@Descrip			varchar(20),
@Cant				float
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
SET @Tabla = 'KITS' + @Empresa
exec master..sp_serveroption @SrvOrigenSAE, 'use remote collation', 'false'
SET @sql = 'DECLARE curKit CURSOR FOR ' +
'SELECT DISTINCT CVE_KIT ' +
'FROM '+ @SrvOrigenSAE + '.' + @BDOrigenSAE + '.dbo.' + @Tabla
EXEC sp_executesql @Sql
OPEN curKit
FETCH NEXT FROM curKit INTO @Kit
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Juego = 64
SET @Cuenta = 0
SET @sql = 'DECLARE curArtD CURSOR FOR ' +
'SELECT CVE_ART, CANTIDAD ' +
'FROM '+ @SrvOrigenSAE + '.' + @BDOrigenSAE + '.dbo.' + @Tabla + ' ' +
'WHERE CVE_KIT = ' + CHAR(39) + @Kit + CHAR(39)
EXEC sp_executesql @Sql
OPEN curArtD
FETCH NEXT FROM curArtD INTO @Art, @Cant
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Juego = @Juego + 1
SET @Cuenta = @Cuenta + 1
SET @Descrip = 'Componente ' + CONVERT(varchar, @Cuenta)
INSERT INTO ArtJuego (Articulo, Juego, Descripcion, Cantidad)
VALUES (@Kit, char(@Juego), @Descrip, @Cant)
INSERT INTO ArtJuegoD (Articulo, Juego, Renglon,Opcion, SubCuenta)
VALUES (@Kit, char(@Juego), 2048, @Art, NULL)
FETCH NEXT FROM curArtD INTO @Art, @cant
END
CLOSE curArtD
DEALLOCATE curArtD
FETCH NEXT FROM curKit INTO @Kit
END
CLOSE curKit
DEALLOCATE curKit
SET ANSI_NULLS OFF
SET ANSI_WARNINGS OFF
END

