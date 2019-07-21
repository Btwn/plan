SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spMovSituacionBinariaValidarCondUsuario
@Modulo				varchar(5),
@ID					int,
@Mov				varchar(20),
@Estatus			varchar(15),
@Situacion			varchar(50),
@SituacionID		int,
@CondicionUsuario	varchar(max),
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
@ValidaCondUsuario	bit			OUTPUT

AS BEGIN
DECLARE @SQL					nvarchar(max),
@Parametros			nvarchar(max)
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
@ValidaCondUsuario	bit			OUTPUT'
SELECT @CondicionUsuario = REPLACE(@CondicionUsuario,CHAR(10),'')
SELECT @CondicionUsuario = REPLACE(@CondicionUsuario,CHAR(13),'')
SELECT @CondicionUsuario = ISNULL(RTRIM(@CondicionUsuario),'')
IF NULLIF(RTRIM(@CondicionUsuario),'') IS NULL
BEGIN
SELECT @ValidaCondUsuario = 1
RETURN
END
EXEC spMovSituacionBinariaParsearCondUsuario @Modulo, @ID, @Mov, @Estatus, @Situacion, @SituacionID, @Cajero, @Causa, @Clase, @Concepto, @Condicion, @Contacto,
@CtaDinero, @Ejercicio, @Empresa, @EnviarA, @FechaCancelacion, @FechaEmision, @FechaRegistro, @FormaEnvio, @Importe,
@Impuestos, @Moneda, @MovID, @Observaciones, @Origen, @OrigenID, @OrigenTipo, @Periodo, @Proyecto, @RamaID, @Referencia,
@Retenciones, @SubClase, @Sucursal, @TipoCambio, @Total, @UEN, @Usuario, @Vencimiento, @ZonaImpuesto, @CondicionUsuario OUTPUT
SELECT @SQL = 'IF (' + @CondicionUsuario + ') SELECT @ValidaCondUsuario = 1 ELSE SELECT @ValidaCondUsuario = 0'
BEGIN TRY
EXEC sp_executesql @SQL, @Parametros, @ID, @Cajero, @Causa, @Clase, @Concepto, @Condicion, @Contacto, @CtaDinero, @Ejercicio, @Empresa, @EnviarA, @FechaCancelacion,
@FechaEmision, @FechaRegistro, @FormaEnvio, @Importe, @Impuestos, @Moneda, @MovID, @Observaciones, @Origen, @OrigenID, @OrigenTipo, @Periodo,
@Proyecto, @RamaID, @Referencia, @Retenciones, @SubClase, @Sucursal, @TipoCambio, @Total, @UEN, @Usuario, @Vencimiento, @ZonaImpuesto, @ValidaCondUsuario OUTPUT
END TRY
BEGIN CATCH
SELECT @ValidaCondUsuario = 0
RETURN
END CATCH
END

