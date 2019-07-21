SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNominaAfectarGasto
@ID					int,
@GastoID				int,
@GastoMov			char(20),
@Acreedor			char(10),
@Vencimiento			datetime,
@CfgGastoUENDetalle  bit,
@GastoUEN			int,
@CentroCostos		VARCHAR(9),
@NomAuto				bit

AS BEGIN
DECLARE
@Concepto			varchar(50),
@Referencia			varchar(50),
@ContUso			varchar(20),
@UEN				int,
@Proyecto			varchar(50),
@Actividad			varchar(50),
@Importe			money,
@Renglon			float,
@Impuestos			float,
@Retencion			float,
@Retencion2			float,
@Retencion3			float,
@TieneRetencion		bit,
@ClavePresupuestal	varchar(50) 
SELECT @Renglon = 0.0, @TieneRetencion = 0
IF @NomAuto = 0
BEGIN
IF @CfgGastoUENDetalle = 1
DECLARE crNominaGastoD CURSOR FOR
SELECT d.Concepto, /*d.Referencia,*/ d.ContUso, @GastoUEN, NULLIF(p.Proyecto, ''), SUM(d.Importe), NULLIF(p.Actividad, ''), P.CentroCostos, d.ClavePresupuestal 
FROM NominaD d
LEFT OUTER JOIN Personal p ON p.Personal = d.Personal
WHERE d.ID = @ID AND d.Modulo = 'GAS' AND d.Movimiento = @GastoMov AND d.Cuenta = @Acreedor AND d.FechaA = @Vencimiento AND d.UEN = @GastoUEN
GROUP BY d.Concepto, /*d.Referencia,*/ d.ContUso, p.Proyecto, p.Actividad, P.CentroCostos, d.ClavePresupuestal 
ELSE
DECLARE crNominaGastoD CURSOR FOR
SELECT d.Concepto, /*d.Referencia,*/ d.ContUso, d.UEN, NULLIF(p.Proyecto, ''), SUM(d.Importe), NULLIF(p.Actividad, ''), P.CentroCostos, d.ClavePresupuestal 
FROM NominaD d
LEFT OUTER JOIN Personal p ON p.Personal = d.Personal
WHERE d.ID = @ID AND d.Modulo = 'GAS' AND d.Movimiento = @GastoMov AND d.Cuenta = @Acreedor AND d.FechaA = @Vencimiento
GROUP BY d.Concepto, /*d.Referencia,*/ d.ContUso, d.UEN, p.Proyecto, p.Actividad, P.CentroCostos, d.ClavePresupuestal 
END ELSE
BEGIN
IF @CfgGastoUENDetalle = 1
DECLARE crNominaGastoD CURSOR FOR
SELECT d.Concepto/*, d.Referencia*/, d.ContUso, @GastoUEN, NULLIF(p.Proyecto, ''), SUM(d.Importe), NULLIF(p.Actividad, ''), P.CentroCostos, d.ClavePresupuestal 
FROM NominaD d
LEFT OUTER JOIN Personal p ON p.Personal = d.Personal
LEFT OUTER JOIN NominaConcepto c ON c.NominaConcepto = d.NominaConcepto 
WHERE d.ID = @ID AND (d.Modulo = 'GAS' or c.GenerarEstadisticaGas=1) AND (c.ModuloMov = @GastoMov or  (c.GenerarEstadisticaGas=1 and @GastoMov='ESTADISTICA') )
AND d.Cuenta = @Acreedor AND d.FechaA = @Vencimiento AND d.UEN = @GastoUEN
AND ISNULL(d.Importe,0) <> 0
AND P.CentroCostos = @CentroCostos
GROUP BY d.Concepto/*, d.Referencia*/, d.ContUso, p.Proyecto, p.Actividad, P.CentroCostos, d.ClavePresupuestal 
ELSE
DECLARE crNominaGastoD CURSOR FOR
SELECT d.Concepto/*, d.Referencia*/, d.ContUso, d.UEN, NULLIF(p.Proyecto, ''), SUM(d.Importe), NULLIF(p.Actividad, ''), P.CentroCostos, d.ClavePresupuestal 
FROM NominaD d
LEFT OUTER JOIN Personal p ON p.Personal = d.Personal
LEFT OUTER JOIN NominaConcepto c ON c.NominaConcepto = d.NominaConcepto 
WHERE d.ID = @ID AND  (d.Modulo = 'GAS' or c.GenerarEstadisticaGas=1) AND (c.ModuloMov = @GastoMov or  (c.GenerarEstadisticaGas=1 and @GastoMov='ESTADISTICA') ) AND d.Cuenta = @Acreedor AND d.FechaA = @Vencimiento AND ISNULL(d.Importe,0) <> 0.0
AND P.CentroCostos = @CentroCostos
GROUP BY d.Concepto/*, d.Referencia*/, d.ContUso, d.UEN, p.Proyecto, p.Actividad,  P.CentroCostos, d.ClavePresupuestal 
END
OPEN crNominaGastoD
FETCH NEXT FROM crNominaGastoD INTO @Concepto/*, @Referencia*/, @ContUso, @UEN, @Proyecto, @Importe, @Actividad, @CentroCostos, @ClavePresupuestal 
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Renglon = @Renglon + 2048.0
SELECT @Impuestos = NULL, @Retencion = NULL, @Retencion2 = NULL, @Retencion3 = NULL
SELECT @Impuestos = Impuestos, @Retencion = Retencion, @Retencion2 = Retencion2, @Retencion3 = Retencion3
FROM Concepto
WHERE Modulo = 'GAS' AND Concepto = @Concepto
IF NULLIF(@Retencion, 0) IS NOT NULL OR NULLIF(@Retencion2, 0) IS NOT NULL OR NULLIF(@Retencion3, 0) IS NOT NULL SELECT @TieneRetencion = 1
SELECT @Impuestos  = @Importe * (@Impuestos  / 100),
@Retencion  = @Importe * (@Retencion  / 100),
@Retencion2 = @Importe * (@Retencion2 / 100),
@Retencion3 = @Importe * (@Retencion3 / 100)
INSERT GastoD (ID,       Renglon,  RenglonSub, Concepto,  Cantidad, Precio,   Importe,  Referencia,  ContUso,  UEN,             Proyecto,  Impuestos,  Retencion,  Retencion2,  Retencion3,   Actividad, fecha,        ClavePresupuestal) 
VALUES (@GastoID, @Renglon, 0,          @Concepto, 1,        @Importe, @Importe, @Referencia, @ContUso, NULLIF(@UEN, 0), @Proyecto, @Impuestos, @Retencion, @Retencion2, @Retencion3, @Actividad, @Vencimiento, @ClavePresupuestal) 
END
FETCH NEXT FROM crNominaGastoD INTO @Concepto/*, @Referencia*/, @ContUso, @UEN, @Proyecto, @Importe, @Actividad, @CentroCostos, @ClavePresupuestal 
END  
CLOSE crNominaGastoD
DEALLOCATE crNominaGastoD
UPDATE Gasto SET TieneRetencion = @TieneRetencion WHERE ID = @GastoID AND TieneRetencion <> @TieneRetencion
RETURN
END

