SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDineroGenerarIntereses
@Sucursal		int,
@Empresa		char(5),
@Usuario		char(10),
@FechaD		datetime,
@FechaA		datetime,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@FechaRegistro   		datetime,
@Conteo	     		int,
@Hoy	     		datetime,
@InteresesMov		varchar(20),
@ReevaluacionMov		varchar(20),
@DineroID			int,
@DineroMov	     		varchar(20),
@DineroMovID		varchar(20),
@ConDesglose		bit,
@ID				int,
@Mov			varchar(20),
@MovID			varchar(20),
@Saldo			money,
@Importe			money,
@InteresTipo		varchar(20),
@Titulo			varchar(10),
@TasaDiaria			float,
@TituloValor		float,
@ValorOrigen		float,
@Referencia			varchar(50),
@CfgInversionIntereses	varchar(20)
SELECT @InteresesMov = BancoIntereses,
@ReevaluacionMov = DineroReevaluacionTitulo
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT @ConDesglose           = DineroDesgloseObligatorio,
@CfgInversionIntereses = UPPER(DineroInversionIntereses)
FROM EmpresaCfg
WHERE Empresa = @Empresa
IF @CfgInversionIntereses <> 'CIERRE DIARIO' RETURN
SELECT @Conteo = 0
EXEC spExtraerFecha @FechaD OUTPUT
EXEC spExtraerFecha @FechaA OUTPUT
SELECT @FechaRegistro = GETDATE()
SELECT @Hoy = @FechaD
WHILE @Hoy < @FechaA
BEGIN
DECLARE crInversionPendiente CURSOR FOR
SELECT d.ID, d.Mov, d.MovID, ISNULL(d.Saldo, 0.0), d.Tasa / NULLIF(d.TasaDias, 0), UPPER(d.InteresTipo), d.Titulo, d.TituloValor, t.Valor
FROM Dinero d
LEFT OUTER JOIN Titulo t ON t.Titulo = d.Titulo
JOIN MovTipo mt ON mt.Modulo = 'DIN' AND mt.Mov = d.Mov AND mt.Clave = 'DIN.INV'
WHERE d.Empresa = @Empresa AND d.Estatus = 'PENDIENTE'
OPEN crInversionPendiente
FETCH NEXT FROM crInversionPendiente INTO @ID, @Mov, @MovID, @Saldo, @TasaDiaria, @InteresTipo, @Titulo, @ValorOrigen, @TituloValor
IF @@ERROR <> 0 SELECT @Ok = 1
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Saldo <> 0.0 AND @Ok IS NULL
BEGIN
SELECT @Referencia = RTRIM(@Mov) + ' ' + RTRIM(@MovID), @Importe = 0.0
IF @InteresTipo = 'TASA FIJA'
SELECT @DineroMov = @InteresesMov,
@Importe = (ISNULL(@Saldo * (@TasaDiaria/100.0), 0.0)),
@Titulo = NULL, @ValorOrigen = NULL, @TituloValor = NULL
ELSE
IF @InteresTipo = 'TITULO'
SELECT @DineroMov = @ReevaluacionMov,
@Importe = (@Saldo * ((@TituloValor/@ValorOrigen)-1.0))
INSERT Dinero (
Sucursal, SucursalOrigen, Empresa, Mov,  FechaEmision,  Concepto, Proyecto, UEN, Moneda, TipoCambio, Usuario,  Referencia,  Estatus,      CtaDinero, CtaDineroDestino, Importe,  ConDesglose,  FormaPago, Titulo,  TituloValor,  ValorOrigen)
SELECT Sucursal, Sucursal,       Empresa, @DineroMov, @Hoy,          Concepto, Proyecto, UEN, Moneda, TipoCambio, @Usuario, @Referencia, 'SINAFECTAR', CtaDinero, CtaDineroDestino, @Importe, @ConDesglose, FormaPago, @Titulo, @TituloValor, @ValorOrigen
FROM Dinero
WHERE ID = @ID
IF @@ERROR <> 0 SELECT @Ok = 1
SELECT @DineroID = SCOPE_IDENTITY()
IF @ConDesglose = 1
INSERT DineroD (
Sucursal,  ID,        Renglon, Importe)
SELECT @Sucursal, @DineroID, 2048,    @Importe
EXEC spAfectar 'DIN', @DineroID, @Usuario = @Usuario, @Conexion = 1, @EnSilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
FETCH NEXT FROM crInversionPendiente INTO @ID, @Mov, @MovID, @Saldo, @TasaDiaria, @InteresTipo, @Titulo, @ValorOrigen, @TituloValor
END 
CLOSE crInversionPendiente
DEALLOCATE crInversionPendiente
SELECT @Hoy = DATEADD(day, 1, @Hoy)
END
RETURN
END

