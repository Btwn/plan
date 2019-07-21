SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoAnexoTarifa
@Sucursal		int,
@Empresa		char(5),
@OrigenModulo		char(5),
@OrigenID		int,
@OrigenMov		char(20),
@OrigenMovID		varchar(20),
@FechaEmision		datetime,
@FechaRegistro		datetime,
@Usuario		char(10),
@Afectar		bit,
@Ok			int		OUTPUT,
@OkRef			varchar(255)	OUTPUT

AS BEGIN
DECLARE
@ID			int,
@Mov		char(20),
@MovTipo		char(20),
@Moneda		char(10),
@TipoCambio		float,
@Clase		varchar(50),
@Subclase		varchar(50),
@Acreedor		char(10),
@Condicion		varchar(50),
@Renglon		float,
@Referencia		varchar(50),
@Concepto		varchar(50),
@Cantidad		float,
@CostoTotal		money,
@Precio		money,
@Importe		money,
@Retencion		money,
@Retencion2		money,
@Retencion3		money,
@Impuestos		money,
@SumaImporte	money,
@SumaRetencion	money,
@SumaImpuestos	money,
@EmbarqueModulo	char(5),
@Agrupador		varchar(50),
@Porcentaje 	float,
@TieneRetencion	bit,
@GenerarGasto	bit,
@PorcentajeImpuestos	float,
@PorcentajeRetencion	float,
@PorcentajeRetencion2	float,
@PorcentajeRetencion3	float,
@CfgRetencion2BaseImpuesto1	bit
SELECT @CfgRetencion2BaseImpuesto1 = ISNULL(Retencion2BaseImpuesto1, 0) FROM Version
SELECT @Acreedor             = v.Proveedor,
@GenerarGasto	       = v.GenerarGasto,
@Clase  	       = v.Clase,
@SubClase	       = v.SubClase,
@Condicion	       = v.Condicion,
@PorcentajeImpuestos  = v.Impuestos,
@PorcentajeRetencion  = v.Retencion,
@PorcentajeRetencion2 = v.Retencion2,
@PorcentajeRetencion3 = v.Retencion3
FROM Embarque e, Vehiculo v
WITH(NOLOCK) WHERE e.Vehiculo = v.Vehiculo AND e.ID = @OrigenID
IF @Acreedor IS NULL OR @GenerarGasto = 0 RETURN
SELECT @Mov = EmbarqueGastoTarifas
FROM EmpresaCfgMov
WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @MovTipo = Clave FROM MovTipo WITH(NOLOCK) WHERE Modulo = 'GAS' AND Mov = @Mov
IF @MovTipo NOT IN ('GAS.G', 'GAS.GTC', 'GAS.GP') SELECT @Ok = 35005, @OkRef = @Mov
SELECT @Moneda = ContMoneda
FROM EmpresaCfg
WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @TipoCambio  = TipoCambio FROM Mon WHERE Moneda = @Moneda
IF @Acreedor IS NULL SELECT @Ok = 40020
IF @MovTipo IN ('GAS.GP', 'GAS.CP') DELETE GastoDProrrateo WHERE ID = @ID
INSERT Gasto (Sucursal,  Empresa,  Mov,  FechaEmision,  Moneda,  TipoCambio,  Usuario,  Estatus,     UltimoCambio, Acreedor,  Clase,  SubClase,  Condicion,  AnexoModulo,   AnexoID, Prioridad)
VALUES (@Sucursal, @Empresa, @Mov, @FechaEmision, @Moneda, @TipoCambio, @Usuario, 'CONFIRMAR', GETDATE(),    @Acreedor, @Clase, @SubClase, @Condicion, @OrigenModulo, @OrigenID, 'Normal')
SELECT @ID = SCOPE_IDENTITY()
DECLARE crEmbarqueArt CURSOR FOR
SELECT e.Modulo, a.Familia, SUM(e.Cantidad), SUM(e.Cantidad*e.Costo)
FROM EmbarqueArt e, Art a
WITH(NOLOCK) WHERE e.EmbarqueID = @OrigenID AND e.Articulo = a.Articulo AND UPPER(e.Tipo) NOT IN ('DESEMBARCAR', 'PENDIENTE')
AND e.Modulo IN ('VTAS', 'INV', 'COMS')
GROUP BY e.Modulo, a.Familia
ORDER BY e.Modulo, a.Familia
SELECT @Renglon 	= 0.0,
@SumaImporte	= 0.0,
@SumaRetencion	= 0.0,
@SumaImpuestos	= 0.0
OPEN crEmbarqueArt
FETCH NEXT FROM crEmbarqueArt  INTO @EmbarqueModulo, @Agrupador, @Cantidad, @CostoTotal
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Renglon = @Renglon + 2048.0,
@Concepto = 'Flete',
@Referencia = @Agrupador
SELECT @Porcentaje = 0.0
SELECT @Porcentaje = CASE @EmbarqueModulo
WHEN 'VTAS' THEN ISNULL(PorcentajeVenta, 0.0)
WHEN 'INV'  THEN ISNULL(PorcentajeInv, 0.0)
WHEN 'COMS' THEN ISNULL(PorcentajeCompra, 0.0)
END
FROM EmbarqueTarifa
WITH(NOLOCK) WHERE Agrupador = 'Familia' AND Nombre = @Agrupador
IF @MovTipo = 'GAS.GP'
EXEC spGastoAnexoTarifaProrrateo @OrigenID, @ID, @Renglon, 0, @Concepto, @Agrupador, @CostoTotal, @EmbarqueModulo
SELECT @Importe = @CostoTotal * @Porcentaje/100.0
SELECT @Precio = @Importe / @Cantidad
SELECT @Retencion  = @Importe * (@PorcentajeRetencion/100.0),
@Retencion2 = CASE WHEN @CfgRetencion2BaseImpuesto1 = 1 THEN @Importe * (@PorcentajeImpuestos/100.0) * (@PorcentajeRetencion2/100.0) ELSE @Importe * (@PorcentajeRetencion2/100.0) END,
@Retencion3 = @Importe * (@PorcentajeRetencion3/100.0),
@Impuestos  = @Importe * (@PorcentajeImpuestos/100.0)
SELECT @SumaImporte   = @SumaImporte   + ISNULL(@Importe, 0),
@SumaRetencion = @SumaRetencion + ISNULL(@Retencion, 0) + ISNULL(@Retencion2, 0) + ISNULL(@Retencion3, 0),
@SumaImpuestos = @SumaImpuestos + ISNULL(@Impuestos, 0)
INSERT GastoD (ID,  Renglon,  Concepto,  Fecha,         Referencia,  Cantidad,  Precio,  Importe,  Retencion,  Retencion2,  Retencion3,  Impuestos,  Sucursal)
VALUES (@ID, @Renglon, @Concepto, @FechaEmision, @Referencia, @Cantidad, @Precio, @Importe, @Retencion, @Retencion2, @Retencion3, @Impuestos, @Sucursal)
END
FETCH NEXT FROM crEmbarqueArt  INTO @EmbarqueModulo, @Agrupador, @Cantidad, @CostoTotal
END
CLOSE crEmbarqueArt
DEALLOCATE crEmbarqueArt
IF @SumaRetencion > 0.0 SELECT @TieneRetencion = 1 ELSE SELECT @TieneRetencion = 0
UPDATE Gasto
 WITH(ROWLOCK) SET TieneRetencion = @TieneRetencion, Importe = @SumaImporte, Retencion = @SumaRetencion, Impuestos = @SumaImpuestos
WHERE ID = @ID
IF @Afectar = 1
BEGIN
IF EXISTS(SELECT * FROM GastoD WHERE ID = @ID)
EXEC spGasto @ID, 'GAS', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, NULL, NULL, NULL, @Ok OUTPUT, @OkRef OUTPUT
ELSE
DELETE Gasto WHERE ID = @ID
END
RETURN
END

