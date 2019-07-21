SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRSVerRotacionInv
@Empresa 		varchar(10),
@ArticuloD		varchar(20),
@ArticuloA		varchar(20),
@FechaD 		datetime,
@FechaA 		datetime,
@Sucursal		int			= NULL

AS
BEGIN
DECLARE
@Estacion		        int,
@CfgMoneda				varchar(10),
@CfgMonedaTipoCambio	float,
@UltimoDiaMesD			int,
@PeriodoD				int,
@UltimoDiaMesA			int,
@PeriodoA				int,
@crSucursal				int,
@crNombre				varchar(100),
@crMoneda				char(10),
@crArticulo				varchar(20),
@crDescripcion1			varchar(100),
@crUnidad				varchar(50),
@crSubCuenta			varchar(50),
@crCostoInvInicial		money,
@crCostoInvFinal		money
SELECT @Estacion=@@SPID
DELETE VerRotacionInv WHERE Estacion = @Estacion
IF @FechaA<@FechaD
BEGIN
SELECT 'La Fecha Fin, debe ser mayor a la Fecha Inicial'
RETURN
END
SELECT @CfgMoneda = ContMoneda
FROM EmpresaCfg
WHERE Empresa = @Empresa
SELECT @CfgMonedaTipoCambio = TipoCambio
FROM Mon
WHERE Moneda = @CfgMoneda
INSERT VerRotacionInv (Estacion, Empresa, Sucursal, Nombre, Articulo, Descripcion1, Unidad, Moneda, SubCuenta, CostoTotalNetoMN)
SELECT
@Estacion,
v.Empresa,
v.Sucursal,
s.Nombre,
d.Articulo,
d.Articulo+' - '+a.Descripcion1, 
a.Unidad,
a.MonedaCosto,
ISNULL(d.SubCuenta, ''),
CONVERT(money, SUM(ISNULL(d.Costo, 0.0) * ((ISNULL(d.Cantidad, 0.0) - ISNULL(d.CantidadCancelada, 0.0)) *
(CASE
WHEN v.Mov IN ('VTAS.D', 'VTAS.DF') THEN -1
WHEN v.Mov IN ('VTAS.B') THEN 0
ELSE 1
END)) * ISNULL(v.TipoCambio, 0.0)))
FROM Venta v
INNER JOIN VentaD d ON v.ID = d.ID
INNER JOIN MovTipo mt ON v.Mov = mt.Mov
INNER JOIN Art a ON d.Articulo = a.Articulo
INNER JOIN Sucursal s ON v.Sucursal = s.Sucursal
WHERE v.Empresa = @Empresa
AND v.Sucursal = ISNULL(@Sucursal, v.Sucursal)
AND v.FechaEmision BETWEEN @FechaD AND @FechaA
AND v.Estatus IN ('PENDIENTE', 'CONCLUIDO')
AND mt.Modulo = 'VTAS' AND (mt.Clave IN ('VTAS.F', 'VTAS.FAR', 'VTAS.FB', 'VTAS.FM', 'VTAS.D', 'VTAS.DF', 'VTAS.B') OR (mt.Clave IN ('VTAS.EST') AND v.Mov IN ('Gasto Extemporaneo', 'Bonif. Extemporanea')))
AND a.Articulo BETWEEN @ArticuloD AND @ArticuloA
GROUP BY
v.Empresa,
v.Sucursal,
s.Nombre,
d.Articulo,
d.SubCuenta,
a.Descripcion1,
a.Unidad,
a.MonedaCosto
ORDER BY
v.Empresa,
v.Sucursal,
s.Nombre,
d.Articulo,
d.SubCuenta,
a.Descripcion1,
a.Unidad,
a.MonedaCosto
SELECT @PeriodoD = MONTH(@FechaD)
SELECT @UltimoDiaMesD = dbo.fnDiasMes(MONTH(@FechaD), YEAR(@FechaD))
IF DAY(@FechaD) = @UltimoDiaMesD
SELECT @PeriodoD = @PeriodoD + 1
DECLARE crVerRotacionInvInicialAcumU CURSOR LOCAL FOR
SELECT
au.Sucursal,
s.Nombre,
au.Moneda,
au.Cuenta,
a.Articulo+' - '+a.Descripcion1, 
a.Unidad,
au.SubCuenta,
CONVERT(money, SUM(ISNULL(au.Cargos, 0.0) - ISNULL(au.Abonos, 0.0)))
FROM AcumU au
INNER JOIN Art a ON au.Cuenta = a.Articulo
INNER JOIN Sucursal s ON au.Sucursal = s.Sucursal
WHERE au.Rama = 'INV'
AND au.Empresa = @Empresa
AND au.Sucursal = ISNULL(@Sucursal, au.Sucursal)
AND au.Ejercicio = YEAR(@FechaD)
AND au.Periodo < @PeriodoD
AND a.Articulo BETWEEN @ArticuloD AND @ArticuloA
GROUP BY
au.Sucursal,
s.Nombre,
au.Moneda,
au.Cuenta,
a.Articulo,  
a.Descripcion1,
a.Unidad,
au.SubCuenta
HAVING CONVERT(money, SUM(ISNULL(au.Cargos, 0.0) - ISNULL(au.Abonos, 0.0))) <> 0.0
ORDER BY
au.Sucursal,
s.Nombre,
au.Moneda,
au.Cuenta,
a.Articulo,  
a.Descripcion1,
a.Unidad,
au.SubCuenta
OPEN crVerRotacionInvInicialAcumU
FETCH NEXT FROM crVerRotacionInvInicialAcumU INTO @crSucursal, @crNombre, @crMoneda, @crArticulo, @crDescripcion1, @crUnidad, @crSubCuenta, @crCostoInvInicial
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
UPDATE VerRotacionInv
SET CostoInvInicial = @crCostoInvInicial
WHERE Estacion = @Estacion
AND Empresa = @Empresa AND Sucursal = @crSucursal AND Moneda = @crMoneda AND Articulo = @crArticulo AND SubCuenta = @crSubCuenta
IF @@ROWCOUNT = 0
INSERT VerRotacionInv (Estacion, Empresa, Sucursal, Nombre, Articulo, Descripcion1, Unidad, Moneda, SubCuenta, CostoInvInicial)
VALUES (@Estacion, @Empresa, @crSucursal, @crNombre, @crArticulo, @crDescripcion1, @crUnidad, @crMoneda, @crSubCuenta, @crCostoInvInicial)
END
FETCH NEXT FROM crVerRotacionInvInicialAcumU INTO @crSucursal, @crNombre, @crMoneda, @crArticulo, @crDescripcion1, @crUnidad, @crSubCuenta, @crCostoInvInicial
END
CLOSE crVerRotacionInvInicialAcumU
DEALLOCATE crVerRotacionInvInicialAcumU
IF DAY(@FechaD) < @UltimoDiaMesD
BEGIN
DECLARE crVerRotacionInvInicialAuxU CURSOR LOCAL FOR
SELECT
au.Sucursal,
s.Nombre,
au.Moneda,
au.Cuenta,
a.Articulo+' '+a.Descripcion1,  
a.Unidad,
au.SubCuenta,
CONVERT(money, SUM(ISNULL(au.Cargo, 0.0) - ISNULL(au.Abono, 0.0)))
FROM AuxiliarU au
INNER JOIN Art a ON au.Cuenta = a.Articulo
INNER JOIN Sucursal s ON au.Sucursal = s.Sucursal
WHERE au.Rama = 'INV'
AND au.Empresa = ISNULL(@Empresa, au.Empresa)
AND au.Sucursal = ISNULL(@Sucursal, au.Sucursal)
AND au.Ejercicio = YEAR(@FechaD)
AND au.Periodo = MONTH(@FechaD)
AND au.Fecha <= @FechaD
AND a.Articulo BETWEEN @ArticuloD AND @ArticuloA
GROUP BY
au.Sucursal,
s.Nombre,
au.Moneda,
au.Cuenta,
a.Articulo,  
a.Descripcion1,
a.Unidad,
au.SubCuenta
HAVING CONVERT(money, SUM(ISNULL(au.Cargo, 0.0) - ISNULL(au.Abono, 0.0))) <> 0.0
ORDER BY
au.Sucursal,
s.Nombre,
au.Moneda,
au.Cuenta,
a.Articulo,  
a.Descripcion1,
a.Unidad,
au.SubCuenta
OPEN crVerRotacionInvInicialAuxU
FETCH NEXT FROM crVerRotacionInvInicialAuxU INTO @crSucursal, @crNombre, @crMoneda, @crArticulo, @crDescripcion1, @crUnidad, @crSubCuenta, @crCostoInvInicial
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
UPDATE VerRotacionInv
SET CostoInvInicial = ISNULL(CostoInvInicial, 0.0) + @crCostoInvInicial
WHERE Estacion = @Estacion
AND Empresa = @Empresa AND Sucursal = @crSucursal AND Moneda = @crMoneda AND Articulo = @crArticulo AND SubCuenta = @crSubCuenta
IF @@ROWCOUNT = 0
INSERT VerRotacionInv (Estacion, Empresa, Sucursal, Nombre, Articulo, Descripcion1, Unidad, Moneda, SubCuenta, CostoInvInicial)
VALUES (@Estacion, @Empresa, @crSucursal, @crNombre, @crArticulo, @crDescripcion1, @crUnidad, @crMoneda, @crSubCuenta, @crCostoInvInicial)
END
FETCH NEXT FROM crVerRotacionInvInicialAuxU INTO @crSucursal, @crNombre, @crMoneda, @crArticulo, @crDescripcion1, @crUnidad, @crSubCuenta, @crCostoInvInicial
END
CLOSE crVerRotacionInvInicialAuxU
DEALLOCATE crVerRotacionInvInicialAuxU
END
SELECT @PeriodoA = MONTH(@FechaA)
SELECT @UltimoDiaMesA = dbo.fnDiasMes(MONTH(@FechaA), YEAR(@FechaA))
IF DAY(@FechaA) = @UltimoDiaMesA
SELECT @PeriodoA = @PeriodoA + 1
DECLARE crVerRotacionInvFinalAcumU CURSOR LOCAL FOR
SELECT
au.Sucursal,
s.Nombre,
au.Moneda,
au.Cuenta,
a.Articulo+' '+a.Descripcion1,
a.Unidad,
au.SubCuenta,
CONVERT(money, SUM(ISNULL(au.Cargos, 0.0) - ISNULL(au.Abonos, 0.0)))
FROM AcumU au
INNER JOIN Art a ON au.Cuenta = a.Articulo
INNER JOIN Sucursal s ON au.Sucursal = s.Sucursal
WHERE au.Rama = 'INV'
AND au.Empresa = @Empresa
AND au.Sucursal = ISNULL(@Sucursal, au.Sucursal)
AND au.Ejercicio = YEAR(@FechaA)
AND au.Periodo < @PeriodoA
AND a.Articulo BETWEEN @ArticuloD AND @ArticuloA
GROUP BY
au.Sucursal,
s.Nombre,
au.Moneda,
au.Cuenta,
a.Articulo,  
a.Descripcion1,
a.Unidad,
au.SubCuenta
HAVING CONVERT(money, SUM(ISNULL(au.Cargos, 0.0) - ISNULL(au.Abonos, 0.0))) <> 0.0
ORDER BY
au.Sucursal,
s.Nombre,
au.Moneda,
au.Cuenta,
a.Articulo,  
a.Descripcion1,
a.Unidad,
au.SubCuenta
OPEN crVerRotacionInvFinalAcumU
FETCH NEXT FROM crVerRotacionInvFinalAcumU INTO @crSucursal, @crNombre, @crMoneda, @crArticulo, @crDescripcion1, @crUnidad, @crSubCuenta, @crCostoInvFinal
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
UPDATE VerRotacionInv
SET CostoInvFinal = @crCostoInvFinal
WHERE Estacion = @Estacion
AND Empresa = @Empresa AND Sucursal = @crSucursal AND Moneda = @crMoneda AND Articulo = @crArticulo AND SubCuenta = @crSubCuenta
IF @@ROWCOUNT = 0
INSERT VerRotacionInv (Estacion, Empresa, Sucursal, Nombre, Articulo, Descripcion1, Unidad, Moneda, SubCuenta, CostoInvFinal)
VALUES (@Estacion, @Empresa, @crSucursal, @crNombre, @crArticulo, @crDescripcion1, @crUnidad, @crMoneda, @crSubCuenta, @crCostoInvFinal)
END
FETCH NEXT FROM crVerRotacionInvFinalAcumU INTO @crSucursal, @crNombre, @crMoneda, @crArticulo, @crDescripcion1, @crUnidad, @crSubCuenta, @crCostoInvFinal
END
CLOSE crVerRotacionInvFinalAcumU
DEALLOCATE crVerRotacionInvFinalAcumU
IF DAY(@FechaA) < @UltimoDiaMesA
BEGIN
DECLARE crVerRotacionInvFinalAuxU CURSOR LOCAL FOR
SELECT
au.Sucursal,
s.Nombre,
au.Moneda,
au.Cuenta,
a.Articulo+' '+a.Descripcion1,
a.Unidad,
au.SubCuenta,
CONVERT(money, SUM(ISNULL(au.Cargo, 0.0) - ISNULL(au.Abono, 0.0)))
FROM AuxiliarU au
INNER JOIN Art a ON au.Cuenta = a.Articulo
INNER JOIN Sucursal s ON au.Sucursal = s.Sucursal
WHERE au.Rama = 'INV'
AND au.Empresa = @Empresa
AND au.Sucursal = ISNULL(@Sucursal, au.Sucursal)
AND au.Ejercicio = YEAR(@FechaA)
AND au.Periodo = MONTH(@FechaA)
AND au.Fecha <= @FechaA
AND a.Articulo BETWEEN @ArticuloD AND @ArticuloA
GROUP BY
au.Sucursal,
s.Nombre,
au.Moneda,
au.Cuenta,
a.Articulo,  
a.Descripcion1,
a.Unidad,
au.SubCuenta
HAVING CONVERT(money, SUM(ISNULL(au.Cargo, 0.0) - ISNULL(au.Abono, 0.0))) <> 0.0
ORDER BY
au.Sucursal,
s.Nombre,
au.Moneda,
au.Cuenta,
a.Articulo,  
a.Descripcion1,
a.Unidad,
au.SubCuenta
OPEN crVerRotacionInvFinalAuxU
FETCH NEXT FROM crVerRotacionInvFinalAuxU INTO @crSucursal, @crNombre, @crMoneda, @crArticulo, @crDescripcion1, @crUnidad, @crSubCuenta, @crCostoInvFinal
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
UPDATE VerRotacionInv
SET CostoInvFinal = ISNULL(CostoInvFinal, 0.0) + @crCostoInvFinal
WHERE Estacion = @Estacion
AND Empresa = @Empresa AND Sucursal = @crSucursal AND Moneda = @crMoneda AND Articulo = @crArticulo AND SubCuenta = @crSubCuenta
IF @@ROWCOUNT = 0
INSERT VerRotacionInv (Estacion, Empresa, Sucursal, Nombre, Articulo, Descripcion1, Unidad, Moneda, SubCuenta, CostoInvFinal)
VALUES (@Estacion, @Empresa, @crSucursal, @crNombre, @crArticulo, @crDescripcion1, @crUnidad, @crMoneda, @crSubCuenta, @crCostoInvFinal)
END
FETCH NEXT FROM crVerRotacionInvFinalAuxU INTO @crSucursal, @crNombre, @crMoneda, @crArticulo, @crDescripcion1, @crUnidad, @crSubCuenta, @crCostoInvFinal
END
CLOSE crVerRotacionInvFinalAuxU
DEALLOCATE crVerRotacionInvFinalAuxU
END
DECLARE @NumPeriodos int
SELECT @NumPeriodos=ROUND(DATEDIFF(DAY,@FechaD,@FechaA)/30.4,0)
UPDATE VerRotacionInv
SET CostoInvPromedio = (ISNULL(CostoInvInicial, 0.0) + ISNULL(CostoInvFinal, 0.0)) / @NumPeriodos
WHERE Estacion = @Estacion
UPDATE VerRotacionInv
SET VerRotacionInv.CostoInvPromedioMN = vri.CostoInvPromedio *
CASE WHEN UPPER(vri.Moneda) <> UPPER(@CfgMoneda) THEN ISNULL(m.TipoCambio, 1.0) / NULLIF(@CfgMonedaTipoCambio, 0.0) ELSE @CfgMonedaTipoCambio END
FROM VerRotacionInv vri
INNER JOIN Mon m ON vri.Moneda = m.Moneda
WHERE Estacion = @Estacion
UPDATE VerRotacionInv
SET Rotacion = CONVERT(float, ISNULL(CostoTotalNetoMN, 0.0) / NULLIF(CostoInvPromedioMN, 0.0))
WHERE Estacion = @Estacion
SELECT *
FROM VerRotacionInv r
WHERE Estacion = @Estacion 
END

