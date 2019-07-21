SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovCopiarGastoDiverso
@Modulo	char(5),
@Sucursal	int,
@ID		int,
@GenerarID	int

AS BEGIN
DECLARE
@RenglonID		int,
@RenglonIDNuevo	int
IF @Modulo = 'COMS' DECLARE crGastoDiverso CURSOR FOR SELECT RenglonID FROM CompraGastoDiverso WHERE ID = @ID ELSE
IF @Modulo = 'INV'  DECLARE crGastoDiverso CURSOR FOR SELECT RenglonID FROM CompraGastoDiverso WHERE ID = @ID
OPEN crGastoDiverso
FETCH NEXT FROM crGastoDiverso INTO @RenglonID
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Modulo = 'COMS'
BEGIN
INSERT CompraGastoDiverso
(ID,        Concepto, Acreedor, Importe, PorcentajeImpuestos, Moneda, TipoCambio, Prorrateo, FechaEmision, Condicion, Vencimiento, Referencia, Retencion, Retencion2, Retencion3, Impuestos, Multiple, Sucursal,  PedimentoEspecifico, ProrrateoNivel)
SELECT @GenerarID, Concepto, Acreedor, Importe, PorcentajeImpuestos, Moneda, TipoCambio, Prorrateo, FechaEmision, Condicion, Vencimiento, Referencia, Retencion, Retencion2, Retencion3, Impuestos, Multiple, @Sucursal, PedimentoEspecifico, ProrrateoNivel
FROM CompraGastoDiverso
WHERE ID = @ID AND RenglonID = @RenglonID
SELECT @RenglonIDNuevo = SCOPE_IDENTITY()
INSERT CompraGastoDiversoD
(ID,         RenglonID,       Concepto, Acreedor, ConceptoD, Importe, Retencion, Retencion2, Retencion3, Impuestos, Referencia, Sucursal)
SELECT @GenerarID, @RenglonIDNuevo, Concepto, Acreedor, ConceptoD, Importe, Retencion, Retencion2, Retencion3, Impuestos, Referencia, @Sucursal
FROM CompraGastoDiversoD
WHERE ID = @ID AND RenglonID = @RenglonID
INSERT CompraGastoDiversoProv
(ID,         Concepto, Proveedor)
SELECT @GenerarID, Concepto, Proveedor
FROM CompraGastoDiversoProv
WHERE ID = @ID
INSERT CompraGastoDiversoRef
(ID,         Concepto, Referencia)
SELECT @GenerarID, Concepto, Referencia
FROM CompraGastoDiversoRef
WHERE ID = @ID
INSERT CompraGastoDiversoArt
(ID,         Concepto, Articulo)
SELECT @GenerarID, Concepto, Articulo
FROM CompraGastoDiversoArt
WHERE ID = @ID
END ELSE
IF @Modulo = 'INV'
BEGIN
INSERT InvGastoDiverso
(ID,        Concepto, Acreedor, Importe, PorcentajeImpuestos, Moneda, TipoCambio, Prorrateo, FechaEmision, Condicion, Vencimiento, Referencia, Retencion, Retencion2, Retencion3, Impuestos, Multiple, Sucursal,  PedimentoEspecifico)
SELECT @GenerarID, Concepto, Acreedor, Importe, PorcentajeImpuestos, Moneda, TipoCambio, Prorrateo, FechaEmision, Condicion, Vencimiento, Referencia, Retencion, Retencion2, Retencion3, Impuestos, Multiple, @Sucursal, PedimentoEspecifico
FROM InvGastoDiverso
WHERE ID = @ID AND RenglonID = @RenglonID
SELECT @RenglonIDNuevo = SCOPE_IDENTITY()
INSERT InvGastoDiversoD
(ID,        RenglonID,       Concepto, Acreedor, ConceptoD, Importe, Retencion, Retencion2, Retencion3, Impuestos, Referencia, Sucursal)
SELECT @GenerarID, @RenglonIDNuevo, Concepto, Acreedor, ConceptoD, Importe, Retencion, Retencion2, Retencion3, Impuestos, Referencia, @Sucursal
FROM InvGastoDiversoD
WHERE ID = @ID AND RenglonID = @RenglonID
END
END
FETCH NEXT FROM crGastoDiverso INTO @RenglonID
END  
CLOSE crGastoDiverso
DEALLOCATE crGastoDiverso
END

