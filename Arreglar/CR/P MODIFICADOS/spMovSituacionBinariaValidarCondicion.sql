SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spMovSituacionBinariaValidarCondicion
@Modulo				varchar(5),
@ID					int,
@Mov				varchar(20),
@Estatus 			varchar(15),
@Situacion			varchar(50),
@SituacionID		int,
@Operador			varchar(10),
@Cajero				varchar(10),
@Causa				varchar(50),
@Clase				varchar(50),
@Concepto			varchar(50),
@Condicion			varchar(50),
@Contacto			varchar(10),
@CtaDinero			varchar(10),
@Ejercicio			int,
@Empresa			varchar(5),
@EnviarA			int,
@FechaCancelacion	datetime,
@FechaEmision		datetime,
@FechaRegistro		datetime,
@FormaEnvio			varchar(50),
@Importe			money,
@Impuestos			money,
@Moneda				varchar(10),
@MovID				varchar(20),
@Observaciones		varchar(100),
@Origen				varchar(20),
@OrigenID			varchar(20),
@OrigenTipo			varchar(10),
@Periodo			int,
@Proyecto			varchar(50),
@RamaID				int,
@Referencia			varchar(50),
@Retenciones		money,
@SubClase			varchar(50),
@Sucursal			int,
@TipoCambio			float,
@Total				money,
@UEN				int,
@Usuario			varchar(10),
@Vencimiento		datetime,
@ZonaImpuesto		varchar(30),
@ValidaCondicion	bit				OUTPUT

AS BEGIN
DECLARE @SQL					nvarchar(max),
@Parametros			nvarchar(max),
@RID					int,
@RIDAnt				int,
@Expresion1			varchar(255),
@Expresion2			varchar(255),
@Expresion3			varchar(255),
@OperadorCondicion	varchar(20)
IF NOT EXISTS(SELECT RID FROM MovSituacionBinariaCondicion WITH(NOLOCK) WHERE ID = @SituacionID)
BEGIN
SELECT @ValidaCondicion = 1
RETURN
END
IF @Operador = 'Todas'
SELECT @Operador = 'AND'
ELSE IF @Operador = 'Alguna'
SELECT @Operador = 'OR'
SELECT @SQL = 'SET ANSI_NULLS OFF IF '
SELECT @Parametros = '@ID					int,
@Cajero				varchar(10),
@Causa				varchar(50),
@Clase				varchar(50),
@Concepto			varchar(50),
@Condicion			varchar(50),
@Contacto			varchar(10),
@CtaDinero			varchar(10),
@Ejercicio			int,
@Empresa			varchar(5),
@EnviarA			int,
@FechaCancelacion	datetime,
@FechaEmision		datetime,
@FechaRegistro		datetime,
@FormaEnvio			varchar(50),
@Importe			money,
@Impuestos			money,
@Moneda				varchar(10),
@MovID				varchar(20),
@Observaciones		varchar(100),
@Origen				varchar(20),
@OrigenID			varchar(20),
@OrigenTipo			varchar(10),
@Periodo			int,
@Proyecto			varchar(50),
@RamaID				int,
@Referencia			varchar(50),
@Retenciones		money,
@SubClase			varchar(50),
@Sucursal			int,
@TipoCambio			float,
@Total				money,
@UEN				int,
@Usuario			varchar(10),
@Vencimiento		datetime,
@ZonaImpuesto		varchar(30),
@ValidaCondicion	bit			OUTPUT'
SELECT @RIDAnt = 0
WHILE(1=1)
BEGIN
SELECT @RID = MIN(RID)
FROM MovSituacionBinariaCondicion WITH(NOLOCK)
WHERE ID = @SituacionID
AND RID > @RIDAnt
IF @RID IS NULL BREAK
SELECT @RIDAnt = @RID, @Expresion1 = NULL, @Expresion2 = NULL, @OperadorCondicion = NULL
SELECT @Expresion1 = '@' + REPLACE(REPLACE(ISNULL(Expresion1, ''), '<', ''), '>', ''), @Expresion2 = ISNULL(Expresion2, ''), @Expresion3 = ISNULL(Expresion3, ''), @OperadorCondicion = ISNULL(Operador, '')
FROM MovSituacionBinariaCondicion WITH(NOLOCK)
WHERE ID = @SituacionID
AND RID = @RID
IF @OperadorCondicion = 'Entre'
SELECT @SQL = @SQL + ' (' + @Expresion1 + ' BETWEEN ''' + @Expresion2 + ''' AND ''' + @Expresion3 + ''') ' + @Operador
ELSE IF @OperadorCondicion = 'Igual que'
SELECT @SQL = @SQL + ' (' + @Expresion1 + ' = ''' + @Expresion2 + ''') ' + @Operador
ELSE IF @OperadorCondicion = 'Mayor o igual que'
SELECT @SQL = @SQL + ' (' + @Expresion1 + ' >= ''' + @Expresion2 + ''') ' + @Operador
ELSE IF @OperadorCondicion = 'Menor o igual que'
SELECT @SQL = @SQL + ' (' + @Expresion1 + ' <= ''' + @Expresion2 + ''') ' + @Operador
ELSE IF @OperadorCondicion = 'Mayor que'
SELECT @SQL = @SQL + ' (' + @Expresion1 + ' > ''' + @Expresion2 + ''') ' + @Operador
ELSE IF @OperadorCondicion = 'Menor que'
SELECT @SQL = @SQL + ' (' + @Expresion1 + ' < ''' + @Expresion2 + ''') ' + @Operador
ELSE IF @OperadorCondicion = 'Distinto que'
SELECT @SQL = @SQL + ' (' + @Expresion1 + ' <> ''' + @Expresion2 + ''') '  + @Operador
ELSE IF @OperadorCondicion = 'Contiene'
SELECT @SQL = @SQL + ' (' + @Expresion1 + ' LIKE ''%' + @Expresion2 + '%'') ' + @Operador
END
BEGIN TRY
IF @Operador = 'AND'
SELECT @SQL = LEFT(@SQL, LEN(@SQL) - 3)
IF @Operador = 'OR'
SELECT @SQL = LEFT(@SQL, LEN(@SQL) - 2)
SELECT @SQL = @SQL + ' SELECT @ValidaCondicion = 1 ELSE SELECT @ValidaCondicion = 0'
EXEC sp_executesql @SQL, @Parametros, @ID, @Cajero, @Causa, @Clase, @Concepto, @Condicion, @Contacto, @CtaDinero, @Ejercicio, @Empresa, @EnviarA, @FechaCancelacion,
@FechaEmision, @FechaRegistro, @FormaEnvio, @Importe, @Impuestos, @Moneda, @MovID, @Observaciones, @Origen, @OrigenID, @OrigenTipo, @Periodo,
@Proyecto, @RamaID, @Referencia, @Retenciones, @SubClase, @Sucursal, @TipoCambio, @Total, @UEN, @Usuario, @Vencimiento, @ZonaImpuesto, @ValidaCondicion OUTPUT
END TRY
BEGIN CATCH
SELECT @ValidaCondicion = 0
RETURN
END CATCH
RETURN
END

