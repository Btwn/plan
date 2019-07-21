SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCompraCostoInv
@ID	 int

AS BEGIN
DECLARE
@MovTipo		 				VARCHAR(20),
@SubMovTipo         			VARCHAR(20),
@Concepto		 				VARCHAR(50),
@Acreedor		 				CHAR(10),
@RenglonID		 				INT,
@DescuentoGlobal				FLOAT,
@Importe		 				MONEY,
@Retencion		 				FLOAT,
@Retencion2		 				FLOAT,
@Retencion3		 				FLOAT,
@Impuestos		 				FLOAT,
@Moneda		 					CHAR(10),
@TipoCambio		 				FLOAT,
@Prorrateo		 				CHAR(20),
@PedimentoEspecifico			CHAR(20),
@Multiple		 				BIT,
@CompraCostosImpuestoIncluido 	BIT,
@ImporteProrratear	 			FLOAT,
@Mensaje		 				VARCHAR(255),
@ProrrateoNivel     			VARCHAR(20),
@Empresa      					VARCHAR(5),
@Mov          					VARCHAR(20),
@Proveedor    					VARCHAR(10),
@Articulo     					VARCHAR(20),
@Material						VARCHAR(20),
@Lanzamiento  					VARCHAR(100),
@Costo        					FLOAT
IF (SELECT Estatus FROM Compra WHERE ID = @ID) NOT IN ('SINAFECTAR', 'CONFIRMAR')
BEGIN
SELECT @Mensaje = Descripcion FROM MensajeLista WHERE Mensaje = 60090
RAISERROR (@Mensaje,16,-1)
RETURN
END
SELECT @CompraCostosImpuestoIncluido = ISNULL(cfg.CompraCostosImpuestoIncluido, 0)
FROM EmpresaCfg2 cfg
JOIN Compra c ON cfg.Empresa = c.Empresa
WHERE c.ID = @ID
SELECT @Empresa = c.Empresa, @Mov = c.Mov, @Proveedor = c.Proveedor, @DescuentoGlobal = ISNULL(c.DescuentoGlobal, 0.0), @MovTipo = mt.Clave, @SubMovTipo = mt.SubClave
FROM Compra c
JOIN MovTipo mt ON mt.Modulo = 'COMS' AND mt.Mov = c.Mov
WHERE c.ID = @ID
IF @Mov = 'EntradaCompraMaquila'
BEGIN
UPDATE CompraD SET CostoInv = 0 WHERE ID = @ID
DECLARE crMESCosto CURSOR FOR
SELECT d.Articulo, d.MesLanzamiento
FROM CompraD d
WHERE d.ID = @ID
GROUP BY d.Articulo, d.MesLanzamiento
OPEN crMESCosto
FETCH NEXT FROM crMESCosto INTO @Articulo, @Lanzamiento
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Costo = NULL
/*      SELECT @Costo = SUM(d.Costo)
FROM Inv e
JOIN InvD d ON e.ID = d.ID
JOIN ArtMaterial am ON d.Articulo = am.Material
WHERE e.Empresa = @Empresa
AND e.Estatus = 'CONCLUIDO'
AND e.Mov = 'Entrada Produccion'
AND am.Articulo = @Articulo AND d.MesLanzamiento = @Lanzamiento
*/
SELECT @Costo = SUM(d.Costo)
FROM Inv e
JOIN InvD d ON e.ID = d.ID
JOIN PrevisionesConsumoMes p ON d.MesLanzamiento = p.Lanzamiento AND d.Articulo = p.Hijo  AND p.FaseConsumo = 'Ext'
WHERE e.Empresa = @Empresa
AND e.Estatus = 'CONCLUIDO'
AND e.Mov = 'Entrada Produccion'
AND p.Padre = @Articulo
AND d.MesLanzamiento = @Lanzamiento
UPDATE CompraD SET CostoInv = ISNULL(Costo, 0) +  ISNULL(@Costo, 0)
WHERE ID = @ID
AND Articulo = @Articulo
/*
UPDATE CompraD SET CostoInv = ISNULL(a.CostoEstandar, 0) + ISNULL(ap.CostoAutorizado, 0)
FROM Art a, ArtProv ap
WHERE CompraD.Articulo = a.Articulo
AND ap.Articulo = a.Articulo AND ap.Proveedor = @Proveedor
AND CompraD.ID = @ID
*/
FETCH NEXT FROM crMESCosto INTO @Articulo, @Lanzamiento
END
CLOSE crMESCosto
DEALLOCATE crMESCosto
END
ELSE
BEGIN
UPDATE CompraD SET CostoInv = Costo * ((100.0-@DescuentoGlobal)/100.0) WHERE ID = @ID
UPDATE CompraD SET CostoInv = CASE WHEN DescuentoTipo = '$' THEN CostoInv - DescuentoLinea ELSE CostoInv * ((100.0-ISNULL(DescuentoLinea, 0.0))/100.0) END WHERE ID = @ID
DELETE FROM CompraGastoProrrateo WHERE ID = @ID
IF @MovTipo = 'COMS.EI' OR @SubMovTipo = 'COMS.EIMPO' UPDATE CompraD SET ValorAduana = Costo WHERE ID = @ID
DECLARE crGastoDiverso CURSOR FOR
SELECT Concepto, Acreedor, RenglonID, ISNULL(Importe, 0), ISNULL(Impuestos, 0), Moneda, TipoCambio, NULLIF(RTRIM(UPPER(Prorrateo)), ''), NULLIF(RTRIM(PedimentoEspecifico), ''), ISNULL(Multiple, 0), NULLIF(ProrrateoNivel, '')
FROM CompraGastoDiverso
WHERE ID = @ID
OPEN crGastoDiverso
FETCH NEXT FROM crGastoDiverso INTO @Concepto, @Acreedor, @RenglonID, @Importe, @Impuestos, @Moneda, @TipoCambio, @Prorrateo, @PedimentoEspecifico, @Multiple, @ProrrateoNivel
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Multiple = 1
BEGIN
SELECT @Importe = ISNULL(SUM(Importe), 0),
@Retencion = ISNULL(SUM(Retencion), 0),
@Retencion2 = ISNULL(SUM(Retencion2), 0),
@Retencion3 = ISNULL(SUM(Retencion3), 0),
@Impuestos = ISNULL(SUM(Impuestos), 0)
FROM CompraGastoDiversoD
WHERE ID = @ID AND Concepto = @Concepto AND Acreedor = @Acreedor AND RenglonID = @RenglonID
UPDATE CompraGastoDiverso
SET Importe    = @Importe,
Retencion  = @Retencion,
Retencion2 = @Retencion2,
Retencion3 = @Retencion3,
Impuestos  = @Impuestos
WHERE CURRENT OF crGastoDiverso
END
IF @CompraCostosImpuestoIncluido = 0
SELECT @ImporteProrratear = @Importe
ELSE SELECT @ImporteProrratear = @Importe + @Impuestos
IF @Prorrateo NOT IN (NULL, 'NO')
EXEC spCompraProratear @ID, @Prorrateo, @ImporteProrratear, @Moneda, @TipoCambio, @PedimentoEspecifico, @MovTipo, @Concepto, @RenglonID, @ProrrateoNivel
END
FETCH NEXT FROM crGastoDiverso INTO @Concepto, @Acreedor, @RenglonID, @Importe, @Impuestos, @Moneda, @TipoCambio, @Prorrateo, @PedimentoEspecifico, @Multiple, @ProrrateoNivel
END
CLOSE crGastoDiverso
DEALLOCATE crGastoDiverso
IF @MovTipo = 'COMS.EI'
UPDATE CompraD
SET CostoInv = CostoInv + ISNULL(ValorAduana*(ImportacionImpuesto1/100.0), 0.0) + ISNULL(ValorAduana*(ImportacionImpuesto2/100.0), 0.0)
WHERE ID = @ID
END
END

