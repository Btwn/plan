SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSGeneraApertura
@Empresa			varchar(5),
@Sucursal			int,
@Usuario			varchar(10),
@ID					varchar(50),
@FechaRegitro		datetime,
@Caja				varchar(10),
@Ok					int		OUTPUT,
@OkRef				varchar(255)    OUTPUT

AS
BEGIN
DECLARE
@FormaPago		        varchar(50),
@MovInsertar			varchar(20),
@MovIDInsertar			varchar(20),
@IDInsertar				varchar(36),
@FechaEmision			datetime,
@Host					varchar(20),
@Cluster				varchar(20),
@Moneda					varchar(20),
@RedondeoMonetarios		int,
@TipoCambio             float,
@CtaDineroDestino       varchar(20),
@CtaDinero              varchar(20),
@Fecha                  datetime,
@SugerirFechaCierre     bit,
@FechaCierre            datetime
SELECT @RedondeoMonetarios = dbo.fnPOSRedondeoMonetarios(@Empresa)
SELECT TOP 1 @Moneda = MonedaRef, @TipoCambio = TipoCambio, @CtaDineroDestino = CtaDineroDestino , @CtaDinero = CtaDinero, @FormaPago = FormaPago
FROM POSLCobro
WHERE ID = @ID
SELECT @Caja = Caja FROM POSL WHERE ID = @ID
EXEC spPOSHost @Host OUTPUT, @Cluster OUTPUT
SELECT @SugerirFechaCierre = SugerirFechaCierre
FROM POSCfg
WHERE Empresa = @Empresa
SELECT @FechaCierre = Fecha
FROM POSFechaCierre
WHERE Sucursal = @Sucursal
SELECT @FechaCierre = dbo.fnPOSFechaCierre(@Empresa,@Sucursal,@FechaCierre,@Caja)
SELECT @FechaEmision = CASE WHEN @SugerirFechaCierre = 1 THEN @FechaCierre ELSE dbo.fnFechaSinHora(GETDATE())END
SELECT TOP 1 @MovInsertar = Mov
FROM MovTipo mt
WHERE mt.Modulo = 'POS'
AND mt.Clave = 'POS.AC'
SELECT @FormaPago = codigo
FROM cb
WHERE cb.FormaPago = @FormaPago
AND cb.TipoCuenta = 'Forma Pago'
SELECT @IDInsertar = NEWID()
SELECT @Fecha =   DATEADD(n, -1, @FechaRegitro)
EXEC spPOSConsecutivoAuto @Empresa, @Sucursal, @MovInsertar, @MovIDInsertar OUTPUT, NULL, NULL, NULL, NULL, @Ok OUTPUT, @OkRef OUTPUT
IF @MovInsertar IS NOT NULL
INSERT POSL (
ID, Empresa, Modulo, Mov, MovID, FechaEmision, FechaRegistro, Moneda, TipoCambio, Usuario, Estatus, Cliente, Almacen, Agente,
Cajero, CtaDinero, Importe, CtaDineroDestino, Sucursal, Host, IDR, Cluster, Caja)
SELECT
@IDInsertar, Empresa, 'DIN', @MovInsertar, @MovIDInsertar,  @FechaEmision, @Fecha,  @Moneda, @TipoCambio, Usuario, 'CONCLUIDO', Cliente, Almacen, Agente,
Cajero, @CtaDineroDestino, 0.0, @CtaDinero, Sucursal, @Host, @ID, @Cluster, Caja
FROM POSL
WHERE ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
IF @MovInsertar IS NOT NULL AND @Ok IS NULL
INSERT POSLCobro (
ID, FormaPago, Importe, CtaDinero, Fecha, Caja, Cajero, Host, ImporteRef, TipoCambio,MonedaRef, CtaDineroDestino)
SELECT TOP 1
@IDInsertar, @FormaPago, 0.0, CtaDineroDestino, dbo.fnFechaSinHora(GETDATE()), @Caja, Cajero, Host, 0.0, 1, @Moneda, CtaDinero
FROM POSLCobro
WHERE ID = @ID
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
BEGIN
IF NOT EXISTS(SELECT * FROM POSEstatusCaja WHERE Caja = @Caja)
INSERT POSEstatusCaja (
Caja, Host, Cajero, Usuario, Abierto,Bloqueado)
VALUES (
@Caja, @Host, @Usuario, @Usuario, 1,0)
ELSE
UPDATE POSEstatusCaja SET Host = @Host,
Cajero = @Usuario,
Usuario = @Usuario,
Abierto = 1
WHERE Caja = @Caja
END
END

