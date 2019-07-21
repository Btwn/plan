SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spProdCostearAvance
@Sucursal		int,
@Accion		char(20),
@Empresa		char(5),
@Modulo		char(5),
@ID			int,
@Mov			char(20),
@MovID		varchar(20),
@MovTipo		char(20),
@MovMoneda		char(10),
@MovTipoCambio	float,
@FechaEmision	datetime,
@FechaRegistro	datetime,
@Usuario		char(10),
@Proyecto		varchar(50),
@Ejercicio		int,
@Periodo		int,
@Referencia	      	varchar(50),
@Observaciones     	varchar(255),
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@ProdSerieLote      varchar(50),
@Articulo		char(20),
@SubCuenta		varchar(50),
@Comision		money,
@ManoObra		money,
@Indirectos		money,
@Maquila		money,
@MaquilaIVA		money,
@Orden		int,
@Centro		char(10),
@Cxp		bit,
@Proveedor		char(10),
@CxpMov 		varchar(20),
@Concepto 		varchar(50),
@Impuesto1 		float,
@Condicion		varchar(50),
@CxModulo 		char(5),
@CxMov 		char(20),
@CxMovID 		varchar(20)
DECLARE crProdD CURSOR FOR
SELECT ProdSerieLote, Orden, Centro, Articulo, ISNULL(RTRIM(SubCuenta), ''), ISNULL(SUM(Comision), 0.0), ISNULL(SUM(ManoObra), 0.0), ISNULL(SUM(Indirectos), 0.0), ISNULL(SUM(Maquila), 0.0)
FROM ProdD
WHERE ID = @ID
GROUP BY ProdSerieLote, Orden, Centro, Articulo, SubCuenta
ORDER BY ProdSerieLote, Orden, Centro, Articulo, SubCuenta
OPEN crProdD
FETCH NEXT FROM crProdD INTO @ProdSerieLote, @Orden, @Centro, @Articulo, @SubCuenta, @Comision, @ManoObra, @Indirectos, @Maquila
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Comision   <> 0.0 EXEC spProdSerieLoteCosto @Sucursal, @Accion, @Empresa, @Modulo, @ID, @MovTipo, NULL, @ProdSerieLote, @Articulo, @SubCuenta, @Comision,   @MovMoneda, 'Comisiones', 1
IF @ManoObra   <> 0.0 EXEC spProdSerieLoteCosto @Sucursal, @Accion, @Empresa, @Modulo, @ID, @MovTipo, NULL, @ProdSerieLote, @Articulo, @SubCuenta, @ManoObra,   @MovMoneda, 'Mano Obra', 1
IF @Indirectos <> 0.0 EXEC spProdSerieLoteCosto @Sucursal, @Accion, @Empresa, @Modulo, @ID, @MovTipo, NULL, @ProdSerieLote, @Articulo, @SubCuenta, @Indirectos, @MovMoneda, 'Indirectos', 1
IF @Maquila    <> 0.0
BEGIN
SELECT @Cxp = Cxp, @Proveedor = NULLIF(RTRIM(Proveedor), ''), @CxpMov = CxpMov, @Concepto = Concepto, @Impuesto1 = Impuesto1, @Condicion = Condicion FROM Centro WHERE Centro = @Centro
EXEC xpProdCostearAvanceCxp @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @FechaRegistro, @Usuario, @Proyecto, @Ejercicio, @Periodo, @Referencia, @Observaciones,
@Ok OUTPUT, @OkRef OUTPUT, @Cxp OUTPUT, @Proveedor OUTPUT, @CxpMov OUTPUT, @Concepto OUTPUT, @Impuesto1 OUTPUT, @Condicion OUTPUT
IF @Cxp = 0 SELECT @Ok = 25355, @OkRef = @Centro
IF @Proveedor IS NULL AND @Ok IS NULL SELECT @Ok = 40020
SELECT @MaquilaIVA = @Maquila * (@Impuesto1 / 100)
IF @Ok IS NULL
EXEC spGenerarCx @Sucursal, @Sucursal, @Sucursal, @Accion, NULL, @Empresa, @Modulo, @ID, @Mov, @MovID, @MovTipo, @MovMoneda, @MovTipoCambio,
@FechaEmision, @Concepto, @Proyecto, @Usuario, NULL, @Referencia, NULL, @Observaciones,
@FechaRegistro, @Ejercicio, @Periodo,
@Condicion, NULL, @Proveedor, NULL, NULL, NULL, NULL, NULL,
@Maquila, @MaquilaIVA, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, @CxpMov,
@CxModulo OUTPUT, @CxMov OUTPUT, @CxMovID OUTPUT,
@Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NULL
EXEC spProdSerieLoteCosto @Sucursal, @Accion, @Empresa, @Modulo, @ID, @MovTipo, NULL, @ProdSerieLote, @Articulo, @SubCuenta, @Maquila,    @MovMoneda, 'Maquila', 1
END
END
FETCH NEXT FROM crProdD INTO @ProdSerieLote, @Orden, @Centro, @Articulo, @SubCuenta, @Comision, @ManoObra, @Indirectos, @Maquila
END
CLOSE crProdD
DEALLOCATE crProdD
RETURN
END

