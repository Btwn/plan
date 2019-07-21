SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInvCostoInv
@ID	 int

AS BEGIN
DECLARE
@Concepto		 varchar(50),
@Acreedor		 char(10),
@RenglonID		 int,
@Importe		 money,
@Retencion		 float,
@Retencion2		 float,
@Retencion3		 money,
@Impuestos		 float,
@Moneda		 char(10),
@TipoCambio		 float,
@Prorrateo		 char(20),
@PedimentoEspecifico char(20),
@Multiple		 bit,
@Mensaje		 varchar(255)
IF (SELECT Estatus FROM Inv WITH(NOLOCK) WHERE ID = @ID) NOT IN ('SINAFECTAR', 'BORRADOR', 'CONFIRMAR')
BEGIN
SELECT @Mensaje = Descripcion FROM MensajeLista WITH(NOLOCK) WHERE Mensaje = 60090
RAISERROR (@Mensaje,16,-1)
RETURN
END
UPDATE InvD WITH(ROWLOCK) SET CostoInv = Costo WHERE ID = @ID
DECLARE crGastoDiverso CURSOR FOR
SELECT Concepto, Acreedor, RenglonID, Importe, Moneda, TipoCambio, NULLIF(RTRIM(UPPER(Prorrateo)), ''), NULLIF(RTRIM(PedimentoEspecifico), ''), ISNULL(Multiple, 0)
FROM InvGastoDiverso WITH(NOLOCK)
WHERE ID = @ID
OPEN crGastoDiverso
FETCH NEXT FROM crGastoDiverso INTO @Concepto, @Acreedor, @RenglonID, @Importe, @Moneda, @TipoCambio, @Prorrateo, @PedimentoEspecifico, @Multiple
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Multiple = 1
BEGIN
SELECT @Importe = SUM(Importe),
@Retencion = SUM(Retencion),
@Retencion2 = SUM(Retencion2),
@Retencion3 = SUM(Retencion3),
@Impuestos = SUM(Impuestos)
FROM InvGastoDiversoD WITH(NOLOCK)
WHERE ID = @ID AND Concepto = @Concepto AND Acreedor = @Acreedor AND RenglonID = @RenglonID
UPDATE InvGastoDiverso WITH(ROWLOCK)
SET Importe    = @Importe,
Retencion  = @Retencion,
Retencion2 = @Retencion2,
Retencion3 = @Retencion3,
Impuestos  = @Impuestos
WHERE CURRENT OF crGastoDiverso
END
IF @Prorrateo NOT IN (NULL, 'NO')
EXEC spInvProratear @ID, @Prorrateo, @Importe, @Moneda, @TipoCambio, @PedimentoEspecifico
END
FETCH NEXT FROM crGastoDiverso INTO @Concepto, @Acreedor, @RenglonID, @Importe, @Moneda, @TipoCambio, @Prorrateo, @PedimentoEspecifico, @Multiple
END
CLOSE crGastoDiverso
DEALLOCATE crGastoDiverso
END

