SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spReEncabezadosCompraVenta

AS BEGIN
SET NOCOUNT ON
DECLARE
@ID		  	 int,
@DescuentoGlobal	 float,
@CfgImpInc		 bit,
@CfgMultiUnidades	 bit,
@Empresa		 char(5),
@UltEmpresa		 char(5)
SELECT @UltEmpresa = NULL
DECLARE crVenta CURSOR FOR SELECT Empresa, ID, DescuentoGlobal FROM Venta ORDER BY Empresa
OPEN crVenta
FETCH NEXT FROM crVenta INTO @Empresa, @ID, @DescuentoGlobal
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Empresa <> @UltEmpresa
BEGIN
SELECT @CfgImpInc = VentaPreciosImpuestoIncluido FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @CfgMultiUnidades = MultiUnidades FROM EmpresaCfg2 WHERE Empresa = @Empresa
SELECT @UltEmpresa = @Empresa
END
EXEC spInvReCalcEncabezado @ID, 'VTAS', @CfgImpInc, @CfgMultiUnidades, @DescuentoGlobal
END
FETCH NEXT FROM crVenta INTO @Empresa, @ID, @DescuentoGlobal
END
CLOSE crVenta
DEALLOCATE crVenta
SELECT @UltEmpresa = NULL
DECLARE crCompra CURSOR FOR SELECT Empresa, ID, DescuentoGlobal FROM Compra
OPEN crCompra
FETCH NEXT FROM crCompra INTO @Empresa, @ID, @DescuentoGlobal
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Empresa <> @UltEmpresa
BEGIN
SELECT @CfgMultiUnidades = MultiUnidades FROM EmpresaCfg2 WHERE Empresa = @Empresa
SELECT @UltEmpresa = @Empresa
END
EXEC spInvReCalcEncabezado @ID, 'COMS', 0, @CfgMultiUnidades, @DescuentoGlobal
END
FETCH NEXT FROM crCompra INTO @Empresa, @ID, @DescuentoGlobal
END
CLOSE crCompra
DEALLOCATE crCompra
RETURN
END

