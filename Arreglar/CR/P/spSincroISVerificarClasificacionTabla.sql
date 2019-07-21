SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER ON
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSincroISVerificarClasificacionTabla

AS BEGIN
DECLARE
@SysTabla				varchar(50),
@Tipo					varchar(20),
@Modulo					varchar(5),
@SQL					nvarchar(MAX),
@TablaRemota			varchar(50),
@TieneTablaRemota		bit,
@TieneModulo			bit,
@Campo					varchar(100),
@CampoModulo			varchar(100),
@TipoDatos				varchar(100),
@Ancho					int,
@AceptaNulos			bit,
@EsIdentity				bit,
@EsCalculado			bit,
@TieneIDRemoto			bit
DECLARE @Resultado TABLE
(
Tabla					varchar(50),
Tipo					varchar(50),
Modulo				varchar(5)
)
DECLARE crSysTabla CURSOR FOR
SELECT SysTabla, dbo.fnSincroISTablaTipo(SysTabla), Modulo
FROM SysTabla
WHERE SincroActivo = 1
ORDER BY SysTabla
OPEN crSysTabla
FETCH NEXT FROM crSysTabla INTO @SysTabla, @Tipo, @Modulo
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @TieneTablaRemota = 0, @TieneModulo = 0, @TieneIDRemoto = 0, @CampoModulo = NULL
SELECT @TablaRemota = dbo.fnIDLocalTablaModulo(@SysTabla)
IF @TablaRemota IS NOT NULL AND @SysTabla <> @TablaRemota SELECT @TieneTablaRemota = 1
DECLARE crSysCampo CURSOR LOCAL FOR
SELECT Campo, TipoDatos, Ancho, AceptaNulos, EsIdentity, EsCalculado
FROM SysCampoExt
WHERE Tabla = @SysTabla
ORDER BY Orden
OPEN crSysCampo
FETCH NEXT FROM crSysCampo INTO @Campo, @TipoDatos, @Ancho, @AceptaNulos, @EsIdentity, @EsCalculado
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @TieneTablaRemota = 0 AND @Campo LIKE '%Modulo%' AND @Ancho = 5
SELECT @TieneModulo = 1, @CampoModulo = @Campo
IF @TieneModulo = 1 AND @Campo IN ('ID', 'ModuloID', 'OID', 'DID') AND @TipoDatos = 'int' SELECT @TieneIDRemoto = 1
END
FETCH NEXT FROM crSysCampo INTO @Campo, @TipoDatos, @Ancho, @AceptaNulos, @EsIdentity, @EsCalculado
END
CLOSE crSysCampo
DEALLOCATE crSysCampo
IF (@TieneTablaRemota = 1 OR (@TieneModulo = 1 AND @TieneIDRemoto = 1)) AND @Tipo NOT IN ('Movimiento','MovimientoInfo')
INSERT @Resultado (Tabla, Tipo, Modulo) VALUES (@SysTabla, @Tipo, @Modulo)
FETCH NEXT FROM crSysTabla INTO @SysTabla, @Tipo, @Modulo
END
CLOSE crSysTabla
DEALLOCATE crSysTabla
SELECT * FROM @Resultado
END

