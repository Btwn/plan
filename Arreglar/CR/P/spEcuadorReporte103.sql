SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEcuadorReporte103 @Estacion int

AS BEGIN
DECLARE
@Empresa		varchar(5),
@Nombre		varchar(100),
@Direccion		varchar(140),
@Poblacion		varchar(30),
@Pais			varchar(30),
@InfoFechaA		datetime,
@InfoFechaD		datetime,
@Sucursal		int,
@Moneda		varchar(15),
@TipoCambio		float,
@Descripcion		varchar (50),
@BaseImponible	money,
@Codigo		int,
@Tasa			int,
@ImpuestoRetenido	money,
@Resultado		varchar(555)
SELECT @Empresa = InfoEmpresa,
@InfoFechaA = InfoFechaA,
@InfoFechaD = InfoFechaD,
@Sucursal = InfoSucursal,
@Moneda = InfoMoneda
FROM RepParam
WHERE Estacion = @Estacion
SELECT @Nombre = Nombre,
@Direccion = Direccion + '' + DireccionNumero + '' + DireccionNumeroInt,
@Poblacion = Poblacion,
@Pais = Pais
FROM Empresa
WHERE Empresa = @Empresa
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
CREATE TABLE #EcuadorRep103(
Descripcion		varchar (50)	NULL,
BaseImponible		money,
Codigo			int,
Tasa			int,
ImpuestoRetenido	money
)
INSERT #EcuadorRep103(Descripcion,BaseImponible, Codigo, Tasa, ImpuestoRetenido)
SELECT TipoImpuesto.Concepto Descripcion,
SUM(((CompraD.Costo * CompraD.Cantidad) - ISNULL(CompraD.Descuento, 0) * Compra.TipoCambio)) / @TipoCambio BaseImponible,
TipoImpuesto.TipoImpuesto Codigo,
TipoImpuesto.Tasa,
SUM((((CompraD.Costo * CompraD.Cantidad) - ISNULL(Comprad.Descuento,0) * Compra.TipoCambio) * (TipoImpuesto.Tasa / 100))) /@TipoCambio  ImpuestoRetenido
FROM TipoImpuesto JOIN CompraD
ON TipoImpuesto.TipoImpuesto = CompraD.TipoImpuesto3 JOIN Compra
ON CompraD.ID = Compra.ID JOIN MovTipo
ON Compra.Mov = MovTipo.Mov
WHERE MovTipo.Clave IN('COMS.F') AND MovTipo.Modulo IN ('COMS') AND Estatus IN ('CONCLUIDO') AND Compra.FechaRegistro BETWEEN @InfoFechaD AND @InfoFechaA
GROUP BY TipoImpuesto.TipoImpuesto, TipoImpuesto.Tasa, TipoImpuesto.Concepto
INSERT #EcuadorRep103
SELECT TipoImpuesto.Concepto Descripcion,
SUM(((GastoD.Precio * GastoD.Cantidad) * Gasto.TipoCambio)) / @TipoCambio BaseImponible,
TipoImpuesto.TipoImpuesto Codigo,
TipoImpuesto.Tasa,
SUM(((((GastoD.Precio * GastoD.Cantidad) * Gasto.TipoCambio) * (TipoImpuesto.Tasa / 100)))) / @TipoCambio  ImpuestoRetenido
FROM TipoImpuesto JOIN GastoD
ON TipoImpuesto.TipoImpuesto = GastoD.TipoImpuesto3 JOIN Gasto
ON GastoD.ID = Gasto.ID JOIN MovTipo
ON Gasto.Mov = MovTipo.Mov
WHERE MovTipo.Clave IN('GAS.G') AND MovTipo.Modulo IN ('GAS') AND Estatus IN ('CONCLUIDO') AND Gasto.FechaRegistro BETWEEN @InfoFechaD AND @InfoFechaA
GROUP BY TipoImpuesto.TipoImpuesto, TipoImpuesto.Tasa, TipoImpuesto.Concepto
CREATE TABLE #EcuadorRep103A(
Descripcion		varchar(50)	NULL,
BaseImponible		varchar(50)	NULL,
Codigo			varchar(50)	NULL,
Tasa			varchar(50)	NULL,
ImpuestoRetenido	varchar(50)	NULL
)
INSERT #EcuadorRep103A (Descripcion, BaseImponible, Codigo, Tasa, ImpuestoRetenido) VALUES ('Empresa:', @Nombre,'','','')
INSERT #EcuadorRep103A (Descripcion, BaseImponible, Codigo, Tasa, ImpuestoRetenido)VALUES ('Direccion:', @Direccion,'','','')
INSERT #EcuadorRep103A (Descripcion, BaseImponible, Codigo, Tasa, ImpuestoRetenido)VALUES ('Poblacion:', @Poblacion,'','','')
INSERT #EcuadorRep103A (Descripcion, BaseImponible, Codigo, Tasa, ImpuestoRetenido)VALUES ('Pais:', @Pais,'','','')
INSERT #EcuadorRep103A (Descripcion, BaseImponible, Codigo, Tasa, ImpuestoRetenido)VALUES ('Formulario 103','','','','')
INSERT #EcuadorRep103A (Descripcion, BaseImponible, Codigo, Tasa, ImpuestoRetenido)VALUES (@InfoFechaA, @InfoFechaD,'','','')
INSERT #EcuadorRep103A (Descripcion, BaseImponible, Codigo, Tasa, ImpuestoRetenido)VALUES ('','','','','')
INSERT #EcuadorRep103A (Descripcion, BaseImponible, Codigo, Tasa, ImpuestoRetenido)VALUES ('Descripcion', 'Base Imponible', 'Codigo', 'Tasa', 'Impuesto Retenido')
DECLARE crEcuadorRep103 CURSOR FAST_FORWARD FOR
SELECT Descripcion, CONVERT(varchar(50),SUM(BaseImponible)), Codigo, Tasa, CONVERT(varchar(50),SUM(ImpuestoRetenido))
FROM #EcuadorRep103
GROUP BY Descripcion, Codigo, Tasa
OPEN crEcuadorRep103
FETCH NEXT FROM crEcuadorRep103 INTO @Descripcion, @BaseImponible, @Codigo, @Tasa, @ImpuestoRetenido
WHILE @@FETCH_STATUS =  0
BEGIN
INSERT #EcuadorRep103A values (@Descripcion, @BaseImponible, @Codigo, @Tasa, @ImpuestoRetenido)
FETCH NEXT FROM crEcuadorRep103 INTO @Descripcion, @BaseImponible, @Codigo, @Tasa, @ImpuestoRetenido
END
CLOSE crEcuadorRep103
DEALLOCATE crEcuadorRep103
SELECT @BaseImponible = SUM(BaseImponible),
@ImpuestoRetenido = SUM(ImpuestoRetenido)
FROM #EcuadorRep103
INSERT #EcuadorRep103A  VALUES ('', CONVERT(varchar(50),@BaseImponible), '', '', CONVERT(varchar(50),@ImpuestoRetenido))
SELECT * FROM #EcuadorRep103a
RETURN
END

