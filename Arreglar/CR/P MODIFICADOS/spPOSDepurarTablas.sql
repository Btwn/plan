SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSDepurarTablas
@EstacionTrabajo		int,
@Empresa                varchar(5),
@Sucursal				int,
@Usuario				varchar(10),
@FechaD					datetime

AS
BEGIN
DECLARE
@Host                 varchar(10),
@Cluster              varchar(10),
@Ok                   int,
@OkRef                varchar(255),
@FormaPago            varchar(50),
@Importe              float ,
@CtaDinero            varchar(10),
@Caja                 varchar(10),
@Cajero               varchar(10),
@ImporteRef           float,
@TipoCambio           float,
@MonedaRef            varchar(10),
@CtaDineroDestino     varchar(10),
@MonedaPrincipal      varchar(10),
@MovInsertar          varchar(20),
@MovIDInsertar        varchar(20),
@IDInsertar           varchar(50)
SELECT TOP 1 @MonedaPrincipal = Moneda
FROM POSLTipoCambioRef WITH(NOLOCK)
WHERE TipoCambio = 1 AND Sucursal = @Sucursal AND EsPrincipal = 1
SELECT TOP 1 @MovInsertar = Mov
FROM MovTipo WITH(NOLOCK)
WHERE Modulo = 'POS' AND Clave = 'POS.SALDOIN'
DECLARE @Tabla table(
FormaPago			varchar(50),
Importe				float ,
CtaDinero			varchar(10),
Caja				varchar(10),
Cajero				varchar(10),
Host				varchar(10),
ImporteRef			float,
TipoCambio			float,
MonedaRef			varchar(10),
CtaDineroDestino	varchar(10))
EXEC spPOSHost @Host OUTPUT, @Cluster OUTPUT
IF @FechaD IS NULL
SELECT @FechaD= GETDATE()
SELECT @FechaD = dbo.fnFechaSinHora(@FechaD)
BEGIN TRAN
INSERT @Tabla(
FormaPago, Importe, CtaDinero, Caja, Cajero, Host, ImporteRef, TipoCambio, MonedaRef, CtaDineroDestino)
SELECT
plc.FormaPago, SUM(plc.Importe* mt.Factor),  plc.Caja,  plc.Caja,  plc.Cajero, plc.Host, SUM(plc.ImporteRef* mt.Factor), plc.TipoCambio, plc.MonedaRef, plc.Caja
FROM POSLCobro plc WITH(NOLOCK)
JOIN POSL p WITH(NOLOCK) ON plc.ID = p.ID
JOIN MovTipo mt WITH(NOLOCK) ON p.Mov = mt.Mov AND mt.Modulo = 'POS'
WHERE p.Estatus IN('CONCLUIDO','TRASPASADO')
AND p.Host = @Host
AND dbo.fnFechaSinHora(p.FechaRegistro) <= @FechaD
GROUP BY plc.FormaPago, plc.Caja,  plc.Cajero, plc.Host, plc.TipoCambio, plc.MonedaRef
HAVING SUM(plc.Importe) <> 0.0
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
BEGIN
DELETE POSLVenta
FROM POSLVenta v JOIN POSL p ON p.ID = v.ID
WHERE p.Host = @Host
AND dbo.fnFechaSinHora(p.FechaRegistro) <= @FechaD
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
DELETE POSLSerieLote
FROM POSLSerieLote v JOIN POSL p ON p.ID = v.ID
WHERE p.Host = @Host
AND dbo.fnFechaSinHora(p.FechaRegistro) <= @FechaD
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
DELETE POSVentaCobro
FROM POSVentaCobro v JOIN POSL p ON p.ID = v.ID
WHERE p.Host = @Host
AND dbo.fnFechaSinHora(p.FechaRegistro) <= @FechaD
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
DELETE POSLDenominacion
FROM POSLDenominacion v JOIN POSL p ON p.ID = v.ID
WHERE p.Host = @Host
AND dbo.fnFechaSinHora(p.FechaRegistro) <= @FechaD
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
DELETE POSLCobro
FROM POSLCobro v JOIN POSL p ON p.ID = v.ID
WHERE p.Host = @Host
AND dbo.fnFechaSinHora(p.FechaRegistro)   <= @FechaD
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
DELETE POSL WHERE  Host = @Host AND dbo.fnFechaSinHora(FechaRegistro) <= @FechaD
IF @@ERROR <> 0
SET @Ok = 1
END
IF @Ok IS NULL
BEGIN
DECLARE crCobro CURSOR LOCAL FOR
SELECT FormaPago, Importe, CtaDinero, Caja, Cajero, Host, ImporteRef, TipoCambio, MonedaRef, CtaDineroDestino
FROM @Tabla
OPEN crCobro
FETCH NEXT FROM crCobro INTO @FormaPago, @Importe, @CtaDinero, @Caja, @Cajero, @Host, @ImporteRef, @TipoCambio, @MonedaRef, @CtaDineroDestino
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @IDInsertar = NEWID()
EXEC spPOSConsecutivoAuto @Empresa, @Sucursal, @MovInsertar, @MovIDInsertar OUTPUT, NULL, NULL, NULL, NULL, @Ok OUTPUT, @OkRef OUTPUT
IF @MovInsertar IS NOT NULL  AND @Ok IS NULL
INSERT POSL (
ID, Empresa, Modulo, Mov, MovID, FechaEmision, FechaRegistro, Moneda, TipoCambio,
Usuario, Estatus, Cajero, CtaDinero,
Importe, CtaDineroDestino, Sucursal, Host, Cluster, Caja)
SELECT
@IDInsertar, @Empresa, 'DIN', @MovInsertar, @MovIDInsertar, dbo.fnFechaSinHora(GETDATE()), GETDATE(), @MonedaPrincipal, 1,
@Usuario, 'CONCLUIDO', @Cajero, ISNULL(NULLIF(@CtaDinero,''),@Caja),
@Importe, ISNULL(NULLIF(@CtaDineroDestino,''),@Caja), @Sucursal, @Host,  @Cluster, @Caja
IF @@ERROR <> 0
SET @Ok = 1
IF @Ok IS NULL
INSERT POSLCobro (
ID, FormaPago, Importe, CtaDinero, Caja, Cajero, Host, ImporteRef, TipoCambio, MonedaRef, CtaDineroDestino)
SELECT
@IDInsertar, @FormaPago, @Importe, @CtaDinero, @Caja, @Cajero, @Host, @ImporteRef, @TipoCambio, @MonedaRef, @CtaDineroDestino
IF @@ERROR <> 0
SET @Ok = 1
END
FETCH NEXT FROM crCobro INTO @FormaPago, @Importe, @CtaDinero, @Caja, @Cajero, @Host, @ImporteRef, @TipoCambio, @MonedaRef, @CtaDineroDestino
END
CLOSE crCobro
DEALLOCATE crCobro
END
IF @Ok IS NULL
COMMIT TRAN
ELSE
ROLLBACK TRAN
IF @Ok IS NOT NULL
SELECT @OkRef = Descripcion +' '+ISNULL(@OkRef,'')
FROM MensajeLista WITH(NOLOCK)
WHERE Mensaje = @Ok
ELSE
SELECT @OkRef = 'PROCESO CONCLUIDO CON EXITO'
SELECT @OkRef
END

