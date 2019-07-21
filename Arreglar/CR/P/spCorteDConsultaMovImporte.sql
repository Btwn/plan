SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteDConsultaMovImporte
@ID					int,
@RID				int,
@CEmpresa			varchar(5),
@CSucursal			int,
@CUEN				int,
@CUsuario			varchar(10),
@CModulo			varchar(5),
@CMovimiento		varchar(20),
@CEstatus			varchar(15),
@CSituacion			varchar(50),
@CProyecto			varchar(50),
@CContactoTipo		varchar(20),
@CContacto			varchar(10),
@CImporteMin		float,
@CImporteMax		float,
@CValidarAlEmitir	bit,
@CAccion			varchar(8),
@CDesglosar			varchar(20),
@CAgrupador			varchar(50),
@CMoneda			varchar(10),
@Moneda				varchar(10),
@TipoCambio			float,
@CFiltrarFechas		bit,
@CPeriodo			int,
@CEjercicio			int,
@CFechaD			datetime,
@CFechaA			datetime,
@CTotalizador		varchar(255),
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS
BEGIN
DECLARE @SQL				nvarchar(max),
@Parametros		nvarchar(max),
@Tabla			varchar(255),
@TipoTotalizador	varchar(255)
SELECT @TipoTotalizador = Tipo FROM CorteMovTotalizadorTipoCampo WHERE Totalizador = @CTotalizador
SELECT @Tabla = ISNULL(dbo.fnMovTabla(@CModulo), '')
IF @Tabla = ''
BEGIN
SELECT @Ok = 10380, @OkRef = @CModulo
RETURN
END
SELECT @Parametros = '@RID				int,
@TipoCambio			float'
IF @TipoTotalizador = 'Monetario'
SELECT @SQL = 'UPDATE c
SET c.Importe = (m.' + ISNULL(@CTotalizador, '') + ' * m.TipoCambio) / @TipoCambio
FROM #CorteDTmp c
JOIN ' + @Tabla + ' m ON c.ModuloID = m.ID
WHERE c.RIDConsulta = @RID'
ELSE IF @TipoTotalizador = 'Unidad'
SELECT @SQL = 'UPDATE c
SET c.SaldoU = m.' + ISNULL(@CTotalizador, '') + '
FROM #CorteDTmp c
JOIN ' + @Tabla + ' m ON c.ModuloID = m.ID
WHERE c.RIDConsulta = @RID'
BEGIN TRY
EXEC sp_executesql @SQL, @Parametros, @RID = @RID, @TipoCambio = @TipoCambio
END TRY
BEGIN CATCH
SELECT @Ok = 1, @OkRef = dbo.fnOkRefSQL(ERROR_NUMBER(), ERROR_MESSAGE())
END CATCH
END

