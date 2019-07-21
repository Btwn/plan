SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDineroSugerirCorteMultimoneda
@Sucursal			int,
@DineroID			int,
@Empresa			char(5),
@Caja			char(10),
@CorteParcialDelCajero	bit	= 0

AS BEGIN
DECLARE
@DineroMovTipo	char(20),
@DineroTipoCambio	float,
@TipoCambio         float,
@DineroCajero	char(10),
@Cajero		char(10),
@MovTipo		char(20),
@UltimoID		int,
@ID			int,
@ConDesglose	bit,
@Total		money,
@Importe		money,
@Renglon		float,
@Moneda		char(10),
@FormaPago		varchar(50),
@FormaPagoD		varchar(50),
@CtaDinero		char(10),
@CtaDineroDestino	char(10),
@FondoFijo		money,
@FondoFijoFormaPago	varchar(50),
@Continuar		bit,
@DescontarFondoFijo	money,
@Referencia	varchar(50)
CREATE TABLE #CorteCaja (
Referencia	varchar(50)	COLLATE Database_Default NULL,
FormaPago		varchar(50)	COLLATE Database_Default NULL,
Moneda		varchar(10)	COLLATE Database_Default NULL,
Importe		money		NULL
)
SELECT @DineroMovTipo = mt.Clave,
@DineroTipoCambio = d.TipoCambio,
@DineroCajero = d.Cajero
FROM Dinero d, MovTipo mt
WHERE d.ID = @DineroID AND mt.Modulo = 'DIN' AND d.Mov = mt.Mov
SELECT @FondoFijo = ISNULL(FondoFijo, 0),
@FondoFijoFormaPago = NULLIF(RTRIM(FondoFijoFormaPago), '')
FROM CtaDinero
WHERE CtaDinero = @Caja
INSERT #CorteCaja (FormaPago) VALUES (NULL)
INSERT #CorteCaja (FormaPago) SELECT FormaPago FROM FormaPago
SELECT @UltimoID = ISNULL(MAX(ID), 0) FROM Dinero d, MovTipo mt WHERE d.Empresa = @Empresa AND d.Mov = mt.Mov AND mt.Clave = 'DIN.C' AND d.Estatus = 'CONCLUIDO' AND CtaDinero = @Caja
DECLARE crCorteCaja CURSOR
FOR SELECT f.ID, f.CtaDinero, f.CtaDineroDestino, f.ConDesglose, f.Importe, f.FormaPago, d.Importe, d.FormaPago, mt.Clave, f.Cajero, d.Referencia, f.Moneda
FROM Dinero f
LEFT OUTER JOIN DineroD d ON f.ID = d.ID
JOIN MovTipo mt ON f.Mov = mt.Mov
WHERE f.Empresa = @Empresa
AND f.ID > @UltimoID
AND mt.Clave IN ('DIN.I', 'DIN.E', 'DIN.F', 'DIN.TC', 'DIN.A', 'DIN.AP'/*, 'DIN.CP'*/)
AND f.Estatus = 'CONCLUIDO'
AND mt.SubClave NOT IN ('DIN.AMULTIMONEDA')
AND ((f.CtaDinero = @Caja AND f.Corte IS NULL) OR (f.CtaDineroDestino = @Caja AND f.CorteDestino IS NULL))
ORDER BY f.Moneda
OPEN crCorteCaja
FETCH NEXT FROM crCorteCaja INTO @ID, @CtaDinero, @CtaDineroDestino, @ConDesglose, @Total, @FormaPago, @Importe, @FormaPagoD, @MovTipo, @Cajero, @Referencia, @Moneda
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Continuar = 1
IF @MovTipo = 'DIN.CP' AND @CtaDineroDestino = @Caja SELECT @Continuar = 0
IF @MovTipo = 'DIN.CP' AND @CorteParcialDelCajero = 1 AND @DineroCajero <> @Cajero SELECT @Continuar = 0
IF @Continuar = 1
BEGIN
IF @MovTipo IN ('DIN.E', 'DIN.F', 'DIN.CP') OR (@MovTipo = 'DIN.TC' AND @CtaDinero = @Caja)
SELECT @Total = -@Total, @Importe = -@Importe
IF @ConDesglose = 0
UPDATE #CorteCaja SET Importe = ISNULL(Importe, 0.0) + @Total, Referencia = @Referencia, Moneda = @Moneda WHERE FormaPago = @FormaPago
ELSE
UPDATE #CorteCaja SET Importe = ISNULL(Importe, 0.0) + @Importe, Referencia = @Referencia, Moneda = @Moneda WHERE FormaPago = @FormaPagoD
END
END
FETCH NEXT FROM crCorteCaja INTO @ID, @CtaDinero, @CtaDineroDestino, @ConDesglose, @Total, @FormaPago, @Importe, @FormaPagoD, @MovTipo, @Cajero, @Referencia, @Moneda
END
CLOSE crCorteCaja
DEALLOCATE crCorteCaja
BEGIN TRANSACTION
DELETE DineroD WHERE ID = @DineroID
SELECT @Renglon = 0.0, @Total = 0.0
SELECT @DescontarFondoFijo = (SELECT ISNULL(SUM(Importe), 0) FROM #CorteCaja) - (SELECT ISNULL(SUM(s.Saldo*m.TipoCambio), 0) - @FondoFijo
FROM DineroSaldo s, Mon m
WHERE s.Empresa = @Empresa AND s.CtaDinero = @Caja AND s.Moneda = m.Moneda)
DECLARE crFormaPago CURSOR FOR SELECT NULLIF(RTRIM(FormaPago), ''), Importe, NULLIF(RTRIM(Referencia), ''), Moneda FROM #CorteCaja WHERE ISNULL(Importe, 0.0) <> 0.0
OPEN crFormaPago
FETCH NEXT FROM crFormaPago INTO @FormaPago, @Importe, @Referencia, @Moneda
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @DescontarFondoFijo <> 0.0 AND @FormaPago = @FondoFijoFormaPago AND @DineroTipoCambio = 1.0 AND @DineroMovTipo = 'DIN.CP'
SELECT @Importe = @Importe - @DescontarFondoFijo
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
IF @Importe <> 0.0
BEGIN
SELECT @Renglon = @Renglon + 2048, @Total = @Total + (@Importe * @TipoCambio)
INSERT DineroD (Sucursal, ID, Renglon, RenglonSub, Importe, FormaPago, Referencia, CtaDinero, Moneda, TipoCambio)
VALUES (@Sucursal, @DineroID, @Renglon, 0, @Importe, @FormaPago, @Referencia, @Caja,  @Moneda, @TipoCambio)
END
END
FETCH NEXT FROM crFormaPago INTO @FormaPago, @Importe, @Referencia, @Moneda
END
CLOSE crFormaPago
DEALLOCATE crFormaPago
UPDATE Dinero SET ConDesglose = 1, Importe = @Total WHERE ID = @DineroID
COMMIT TRANSACTION
END

