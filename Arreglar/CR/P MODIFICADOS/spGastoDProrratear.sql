SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoDProrratear
@ID			int,
@IDGasto		int,
@FechaDestino		datetime,
@SucursalDestino	int,
@ProyectoDestino    varchar(50)

AS BEGIN
DECLARE
@Concepto		 varchar(50),
@Fecha		 datetime,
@Referencia		 varchar(50),
@Cantidad		 float,
@Precio		 money,
@Importe		 money,
@Retencion		 money,
@Retencion2 	 money,
@Retencion3 	 money,
@Impuestos		 money,
@Impuestos2		 money,
@Impuestos3		 money,
@Sucursal		 int,
@Renglon		 float,
@ContUso		 varchar(20),
@ContUso2		 varchar(20),
@ContUso3		 varchar(20),
@VIN 		 varchar(20),
@Espacio		 char(10),
@Proyecto		 varchar(50),
@Actividad		 varchar(50),
@AFArticulo		 varchar(20),
@AFSerie		 varchar(50),	
@PorcentajeDeducible float,
@UEN		 int,
@AcreedorRef         varchar(10),
@TipoImpuesto1       varchar(10),
@TipoImpuesto2       varchar(10),
@TipoImpuesto3       varchar(10),
@TipoImpuesto4       varchar(10),
@TipoImpuesto5       varchar(10),
@TipoRetencion1      varchar(10),
@TipoRetencion2      varchar(10),
@TipoRetencion3      varchar(10),
@ClavePresupuestal   varchar(50),
@Impuesto1			 float,
@Impuesto2			 float,
@Impuesto3			 float
SELECT @Renglon = 0.0
DECLARE crGastoDProrrateo CURSOR FOR
SELECT d.Concepto, ISNULL(p.Fecha, d.Fecha), d.Referencia, "Cantidad" = d.Cantidad*(p.Porcentaje/100.0), d.Precio, "Importe" = d.Importe*(p.Porcentaje/100.0), "Retencion" = d.Retencion*(p.Porcentaje/100.0), "Retencion2" = d.Retencion2*(p.Porcentaje/100.0), "Retencion3" = d.Retencion3*(p.Porcentaje/100.0), d.Impuestos*(p.Porcentaje/100.0), d.Impuestos2*(p.Porcentaje/100.0), d.Impuestos3*(p.Porcentaje/100.0), d.Sucursal, p.ContUso, p.ContUso2, p.ContUso3, p.VIN, p.Espacio, p.Proyecto, p.Actividad, p.AFArticulo, p.AFSerie, d.PorcentajeDeducible, p.UEN, d.AcreedorRef, d.TipoImpuesto1, d.TipoImpuesto2, d.TipoImpuesto3, d.TipoImpuesto4, d.TipoImpuesto5, d.TipoRetencion1, d.TipoRetencion2, d.TipoRetencion3,d.ClavePresupuestal, d.Impuesto1, d.Impuesto2, d.Impuesto3
FROM GastoD d, GastoDProrrateo p
WITH(NOLOCK) WHERE d.ID = p.ID AND d.Renglon = p.Renglon AND d.RenglonSub = p.RenglonSub AND d.Concepto = p.Concepto AND p.SucursalProrrateo = @SucursalDestino AND p.Fecha = @FechaDestino
AND p.Proyecto=@ProyectoDestino
AND d.ID = @ID
OPEN crGastoDProrrateo
FETCH NEXT FROM crGastoDProrrateo  INTO @Concepto, @Fecha, @Referencia, @Cantidad, @Precio, @Importe, @Retencion, @Retencion2, @Retencion3, @Impuestos, @Impuestos2, @Impuestos3, @Sucursal, @ContUso, @ContUso2, @ContUso3, @VIN, @Espacio, @Proyecto, @Actividad, @AFArticulo, @AFSerie, @PorcentajeDeducible, @UEN, @AcreedorRef, @TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoImpuesto4, @TipoImpuesto5, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3,@ClavePresupuestal, @Impuesto1, @Impuesto2, @Impuesto3
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2 AND ISNULL(@Importe, 0) <> 0.0
BEGIN
/*SELECT @PorcentajeDeducible = 0.0
SELECT @PorcentajeDeducible = ISNULL(PorcentajeDeducible, 0.0) FROM Concepto WHERE Modulo = 'GAS' AND Concepto = @Concepto*/
SELECT @Renglon = @Renglon + 2048.0
INSERT GastoD (ID,       Renglon,    RenglonSub, Concepto,  Fecha,  Referencia,  Cantidad,  Precio,  Importe,  Retencion,  Retencion2,  Retencion3,  Impuestos,  Impuestos2,  Impuestos3,  ContUso,  ContUso2,  ContUso3,  VIN,   Espacio,  Sucursal,  Proyecto,  Actividad,  AFArticulo,  AFSerie,  PorcentajeDeducible,  UEN,  AcreedorRef,   TipoImpuesto1, TipoImpuesto2,  TipoImpuesto3,  TipoImpuesto4,  TipoImpuesto5,  TipoRetencion1,  TipoRetencion2,  TipoRetencion3, ClavePresupuestal, Impuesto1, Impuesto2, Impuesto3)
VALUES (@IDGasto, @Renglon,   0,          @Concepto, @Fecha, @Referencia, @Cantidad, @Precio, @Importe, @Retencion, @Retencion2, @Retencion3, @Impuestos, @Impuestos2, @Impuestos3, @ContUso, @ContUso2, @ContUso3, @VIN,  @Espacio, @Sucursal, @Proyecto, @Actividad, @AFArticulo, @AFSerie, @PorcentajeDeducible, @UEN, @AcreedorRef, @TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoImpuesto4, @TipoImpuesto5, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3, @ClavePresupuestal, @Impuesto1, @Impuesto2, @Impuesto3)
END
FETCH NEXT FROM crGastoDProrrateo  INTO @Concepto, @Fecha, @Referencia, @Cantidad, @Precio, @Importe, @Retencion, @Retencion2, @Retencion3, @Impuestos, @Impuestos2, @Impuestos3, @Sucursal, @ContUso, @ContUso2, @ContUso3, @VIN, @Espacio, @Proyecto, @Actividad, @AFArticulo, @AFSerie, @PorcentajeDeducible, @UEN, @AcreedorRef, @TipoImpuesto1, @TipoImpuesto2, @TipoImpuesto3, @TipoImpuesto4, @TipoImpuesto5, @TipoRetencion1, @TipoRetencion2, @TipoRetencion3, @ClavePresupuestal, @Impuesto1, @Impuesto2, @Impuesto3
END  
CLOSE crGastoDProrrateo
DEALLOCATE crGastoDProrrateo
RETURN
END

