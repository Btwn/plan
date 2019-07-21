SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelInsertaProveedores]

AS BEGIN
DECLARE
@Observaciones	varchar(30),
@Sucursal	varchar(30),
@Moneda		varchar(30),
@Usuario	varchar(30),
@Condicion	varchar(50),
@Orden		int,
@Cuenta		int,
@Descuento	varchar(30)
SELECT @Observaciones = Valor FROM AspelCfg WHERE Descripcion = 'Observaciones'
IF NOT EXISTS(SELECT Categoria FROM ProvCat WHERE Categoria = @Observaciones)
INSERT INTO ProvCat (Categoria) VALUES (@Observaciones)
INSERT ProvFam (Familia)
SELECT DISTINCT A.Familia FROM AspelCargaProp A FULL JOIN ProvFam B
ON A.Familia = B.Familia WHERE Campo = 'Proveedor' AND A.Familia <> '' AND B.Familia = NULL
SELECT @Moneda = Valor FROM AspelCfg WHERE Descripcion = 'Moneda'
INSERT INTO Prov (Proveedor, Nombre, Direccion, Colonia, Poblacion, Zona, CodigoPostal, Telefonos, Fax, Email1, RFC, CURP, Categoria,
PedirTono,  Estatus, UltimoCambio, Alta, Conciliar, Tipo, ProntoPago, DefMoneda, Logico1, Logico2, Logico3, TieneMovimientos, DescuentoRecargos,
CompraAutoCargosTipo, Pagares, wGastoSolicitud, ConLimiteAnticipos, ChecarLimite, eMailAuto, Intercompania, GarantiaCostos,Observaciones,
Familia, Condicion, Descuento)
SELECT distinct Valor, Nombre, Direccion, Colonia, Poblacion, Zona, CodigoPostal, Telefonos, Fax, Email, substring(RFC, 1, 15), CURP, @Observaciones,
0, Estatus, getdate(), getdate(), 0, 'Proveedor', 0, substring(@Moneda, 1, 10), 0, 0, 0, 0, 0,
'No', 0, 0, 0, 'Anticipo', 0, 0, 0, Descripcion2, Familia, Rama,
CASE WHEN CONVERT(real, Factor) = 0 THEN NULL ELSE Factor END
FROM AspelCargaProp
WHERE Campo = 'Proveedor' and Valor not in (select Proveedor  from prov)
SELECT @Orden = MAX(Orden)  FROM Condicion
DECLARE Cur_Condicion CURSOR FOR
SELECT DISTINCT Condicion FROM Prov
WHERE Condicion IS NOT NULL
OPEN Cur_Condicion
FETCH NEXT FROM Cur_Condicion Into @Condicion
WHILE @@FETCH_STATUS <> -1
BEGIN
SELECT @Orden = @Orden + 1
SELECT @Cuenta = COUNT(*) FROM Condicion
WHERE Condicion = @Condicion
IF @Cuenta = 0
BEGIN
INSERT INTO Condicion(Condicion, DiasVencimiento, TipoDias, DiasHabiles, TipoDiasprontoPago, DiasHabilesProntoPago,
ProntoPago, PorMeses, orden, RecorrerVencimiento, DA, DAImpPrimerDoc, ControlAnticipos, Anticipado, Corte,
FechaProntoPago, TipoCondicion, InteresMoratorioBaseTabla, AutoFin, Neteo, Interesesdevengados, DATipoInteres,
FacturaCobroIntegradoParcial, PorSemanas) 
VALUES (@Condicion, CONVERT(Int, SUBSTRING(@Condicion, 1, 2)), 'Naturales ', 'Lun-Vie', 'Habiles', 'Lun-Vie',
0, 0, @Orden, 0, 0, 0, 'No', 0, 0,
'Emision', 'Credito', 0, 0, 0, 0, 'Global',
0, 0) 
END
FETCH NEXT FROM Cur_Condicion Into @Condicion
END
CLOSE Cur_Condicion
DEALLOCATE Cur_Condicion
DECLARE Cur_Descuento CURSOR FOR
SELECT DISTINCT Descuento FROM Prov
WHERE Descuento IS NOT NULL
OPEN Cur_Descuento
FETCH NEXT FROM Cur_Descuento Into @Descuento
WHILE @@FETCH_STATUS <> -1
BEGIN
SELECT @Cuenta = COUNT(*) FROM Descuento
WHERE Descuento = @Descuento
IF @Cuenta = 0
BEGIN
INSERT INTO Descuento(Descuento, Porcentaje, Descuento1)
VALUES (convert(varchar,@Descuento) + '%', @Descuento, @Descuento)			
END
FETCH NEXT FROM Cur_Descuento Into @Descuento
END
CLOSE Cur_Descuento
DEALLOCATE Cur_Descuento
END

