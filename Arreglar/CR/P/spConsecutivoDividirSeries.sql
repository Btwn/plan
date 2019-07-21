SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spConsecutivoDividirSeries]
@Serie Varchar(10),
@ConsecutivoFiscal INT,
@Tipo CHAR(20) ,
@Sucursal INT ,
@Consecutivo VARCHAR(20) OUTPUT ,
@Maximo INT = NULL ,
@Referencia VARCHAR(50) = NULL OUTPUT ,
@PrefijoEsp VARCHAR(10) = NULL ,
@AutoGenerar BIT = 0

AS
BEGIN
SET NOCOUNT ON
DECLARE @Nivel CHAR(20) ,
@Prefijo CHAR(10) ,
@UltConsecutivo INT ,
@TieneControl BIT ,
@Concurrencia VARCHAR(20) ,
@Tabla VARCHAR(100) ,
@SQL NVARCHAR(4000),
@DividirSeries BIT
SELECT  @UltConsecutivo = NULL ,
@Consecutivo = NULL ,
@Prefijo = NULL ,
@Referencia = NULL
SELECT  @Nivel = UPPER(Nivel) ,
@Prefijo = ISNULL(RTRIM(Prefijo), '') ,
@TieneControl = ISNULL(TieneControl, 0) ,
@Concurrencia = UPPER(ISNULL(RTRIM(Concurrencia), '')) ,
@UltConsecutivo = ISNULL(Consecutivo, 0),
@DividirSeries = DividirSeries
FROM    Consecutivo WITH (NOLOCK)
WHERE   Tipo = @Tipo
IF @@ROWCOUNT = 0
AND @AutoGenerar = 1
BEGIN
SELECT  @Nivel = 'Global' ,
@Concurrencia = 'Normal'
INSERT  Consecutivo
( Tipo, Nivel, Concurrencia )
VALUES  ( @Tipo, @Nivel, @Concurrencia )
END
IF @PrefijoEsp IS NOT NULL
SELECT  @Prefijo = @PrefijoEsp
IF @Concurrencia = 'ALTA'
BEGIN
SELECT  @Tabla = 'Consecutivo/' + RTRIM(CONVERT(VARCHAR(20), @Tipo))
IF @Prefijo <> ''
SELECT  @Tabla = @Tabla + '/'
+ CONVERT(VARCHAR(20), @Prefijo)
IF @Nivel = 'SUCURSAL'
BEGIN
SELECT  @Tabla = @Tabla + '/S'
+ CONVERT(VARCHAR, @Sucursal)
SELECT  @UltConsecutivo = Consecutivo
FROM    ConsecutivoSucursal WITH (NOLOCK)
WHERE   Tipo = @Tipo
AND Sucursal = @Sucursal
END
SELECT @Tabla = @Tabla + '/' + @Serie
IF @DividirSeries = 1 AND @ConsecutivoFiscal = 0
SELECT  @Tabla = @Tabla + '/C'  
IF NOT EXISTS ( SELECT  *
FROM    sysobjects WITH (NOLOCK)
WHERE   id = OBJECT_ID(@Tabla)
AND type = 'U' )
BEGIN
SELECT  @SQL = N'CREATE TABLE [' + @Tabla
+ '] (Consecutivo int IDENTITY('
+ CONVERT(VARCHAR, ISNULL(@UltConsecutivo, 0)
+ 1)
+ ', 1) NOT NULL PRIMARY KEY, Fecha datetime NULL DEFAULT GETDATE())'
EXEC sp_ExecuteSQL @SQL
END
SELECT  @SQL = N'INSERT [' + @Tabla
+ '] (Fecha) VALUES (DEFAULT) SELECT @UltConsecutivo=@@IDENTITY'
EXEC sp_ExecuteSQL @SQL, N'@UltConsecutivo int OUTPUT',
@UltConsecutivo OUTPUT
END
ELSE
BEGIN
IF @Nivel = 'SUCURSAL'
BEGIN
UPDATE  ConsecutivoSucursal WITH ( ROWLOCK )
SET     @UltConsecutivo = Consecutivo = ISNULL(Consecutivo,
0) + 1
WHERE   Tipo = @Tipo
AND Sucursal = @Sucursal
IF @@ROWCOUNT = 0
INSERT  ConsecutivoSucursal
( Tipo, Sucursal, Consecutivo )
VALUES  ( @Tipo, @Sucursal, 1 )
IF @UltConsecutivo > @Maximo
UPDATE  ConsecutivoSucursal WITH ( ROWLOCK )
SET     @UltConsecutivo = Consecutivo = 1
WHERE   Tipo = @Tipo
AND Sucursal = @Sucursal
SELECT  @Prefijo = Prefijo
FROM    Sucursal WITH ( NOLOCK )
WHERE   Sucursal = @Sucursal
END
ELSE
BEGIN
UPDATE  Consecutivo WITH ( ROWLOCK )
SET     @UltConsecutivo = Consecutivo = ISNULL(Consecutivo,
0) + 1
WHERE   Tipo = @Tipo
IF @UltConsecutivo > @Maximo
UPDATE  Consecutivo WITH ( ROWLOCK )
SET     @UltConsecutivo = Consecutivo = 1
WHERE   Tipo = @Tipo
END
END
IF @UltConsecutivo > 0
SELECT  @Consecutivo = RTRIM(@Prefijo)
+ CONVERT(VARCHAR, @UltConsecutivo)
RETURN
END

