SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionActualizarMov
@Accion					varchar(20),
@Estacion				int,
@ID						int,
@Proveedor				varchar(10),
@Empresa				varchar(5),
@Version				varchar(5),
@ConceptoSAT			varchar(50),
@RIDAnt                 varchar(20),
@UUID					varchar(50),
@Ok						int				OUTPUT,
@OkRef					varchar(255)	OUTPUT

AS
BEGIN
DECLARE @ModuloPago		varchar(5),
@ModuloPagoAnt	varchar(5),
@IDPago			int,
@IDPagoAnt		int,
@Modulo			varchar(5),
@ModuloAnt		varchar(5),
@ModuloID			int,
@ModuloIDAnt		int
IF NULLIF(RTRIM(@UUID), '') IS NOT NULL
BEGIN
IF @Accion = 'AFECTAR'
UPDATE Cxp SET CFDRetencionTimbrado = 1 WHERE ID = @ID
ELSE IF @Accion = 'CANCELAR'
UPDATE Cxp SET CFDRetencionTimbrado = 0 WHERE ID = @ID
SELECT @ModuloPagoAnt = ''
WHILE(1=1)
BEGIN
SELECT @ModuloPago = MIN(ModuloPago)
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND ModuloPago > @ModuloPagoAnt
IF @ModuloPago IS NULL BREAK
SELECT @ModuloPagoAnt = @ModuloPago
SELECT @IDPagoAnt = 0
WHILE(1=1)
BEGIN
IF ((SELECT ISNULL(AgruparConceptoSATRetenciones,0) FROM EmpresaCfg2 WHERE Empresa = @Empresa) = 1)
SELECT @IDPago = MIN(IDPago)
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND ModuloPago = @ModuloPago
and MovID = @RIDAnt
AND IDPago > @IDPagoAnt
ELSE
SELECT @IDPago = MIN(IDPago)
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND ModuloPago = @ModuloPago
AND IDPago > @IDPagoAnt
IF @IDPago IS NULL BREAK
SELECT @IDPagoAnt = @IDPago
IF @Accion = 'AFECTAR'
BEGIN
IF @ModuloPago = 'CXP'
UPDATE Cxp SET CFDRetencionTimbrado = 1 WHERE ID = @IDPago
ELSE IF @ModuloPago = 'GAS'
UPDATE Gasto SET CFDRetencionTimbrado = 1 WHERE ID = @IDPago
ELSE IF @ModuloPago = 'DIN'
UPDATE Dinero SET CFDRetencionTimbrado = 1 WHERE ID = @IDPago
END
ELSE IF @Accion = 'CANCELAR'
BEGIN
IF @ModuloPago = 'CXP'
UPDATE Cxp SET CFDRetencionTimbrado = 0 WHERE ID = @IDPago
ELSE IF @ModuloPago = 'GAS'
UPDATE Gasto SET CFDRetencionTimbrado = 0 WHERE ID = @IDPago
ELSE IF @ModuloPago = 'DIN'
UPDATE Dinero SET CFDRetencionTimbrado = 0 WHERE ID = @IDPago
END
SELECT @ModuloAnt = ''
WHILE(1=1)
BEGIN
SELECT @Modulo = MIN(Modulo)
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND ModuloPago = @ModuloPago
AND IDPago = @IDPago
AND Modulo > @ModuloAnt
IF @Modulo IS NULL BREAK
SELECT @ModuloAnt = @Modulo
SELECT @ModuloIDAnt = 0
WHILE(1=1)
BEGIN
SELECT @ModuloID = MIN(ModuloID)
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND Proveedor = @Proveedor
AND ConceptoSAT = @ConceptoSAT
AND Empresa = @Empresa
AND ModuloPago = @ModuloPago
AND IDPago = @IDPago
AND Modulo = @Modulo
AND ModuloID > @ModuloIDAnt
IF @ModuloID IS NULL BREAK
SELECT @ModuloIDAnt = @ModuloID
IF @Accion = 'AFECTAR'
BEGIN
IF @Modulo = 'CXP'
UPDATE Cxp SET CFDRetencionTimbrado = 1 WHERE ID = @ModuloID
ELSE IF @Modulo = 'GAS'
BEGIN
UPDATE Gasto SET CFDRetencionTimbrado = 1 WHERE ID = @ModuloID
UPDATE GastoD SET Timbrado = 0 WHERE ID = @ModuloID AND Timbrado <> 1
UPDATE GastoD SET Timbrado = 1 WHERE ID = @ModuloID and Concepto in (select Concepto from CFDIRetencionConcepto Where Modulo = 'GAS' and CFDIRetClave = @ConceptoSAT)
END
ELSE IF @Modulo = 'COMS'
UPDATE Compra SET CFDRetencionTimbrado = 1 WHERE ID = @ModuloID
END
ELSE IF @Accion = 'CANCELAR'
BEGIN
IF @Modulo = 'CXP'
UPDATE Cxp SET CFDRetencionTimbrado = 0 WHERE ID = @ModuloID
ELSE IF @Modulo = 'GAS'
UPDATE Gasto SET CFDRetencionTimbrado = 0 WHERE ID = @ModuloID
ELSE IF @Modulo = 'COMS'
UPDATE Compra SET CFDRetencionTimbrado = 0 WHERE ID = @ModuloID
END
END
END
IF @Accion = 'AFECTAR'
Begin
Declare  @vMovID varchar(20),@vID int,@conteo int
SELECT @vMovID = MovID FROM CFDIRetencionD WHERE IDPago = @IDPago and ConceptoSAT = @ConceptoSAT
SELECT @vID = ID FROM Gasto WHERE MovID = @vMovID
SELECT @conteo = COUNT(ID) FROM GastoD WHERE ID = @vID  and timbrado <> 1
IF @conteo > 0
BEGIN
IF @ModuloPago = 'CXP'
UPDATE Cxp SET CFDRetencionTimbrado = 0 WHERE ID = @IDPago
ELSE IF @ModuloPago = 'GAS'
UPDATE Gasto SET CFDRetencionTimbrado = 0 WHERE ID = @IDPago
ELSE IF @ModuloPago = 'DIN'
UPDATE Dinero SET CFDRetencionTimbrado = 0 WHERE ID = @IDPago
END
END
END
END
END
RETURN
END

