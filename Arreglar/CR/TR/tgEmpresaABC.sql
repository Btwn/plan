SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgEmpresaABC ON Empresa

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@EmpresaI	char(5),
@EmpresaD	char(5),
@PaisI	varchar(50),
@PaisD	varchar(50),
@ID		int,
@ConfiguracionI		char(10),
@ConfiguracionD		char(10)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @EmpresaI = Empresa, @PaisI = Pais, @ConfiguracionI = NULLIF(RTRIM(Configuracion), '') FROM Inserted
SELECT @EmpresaD = Empresa, @PaisD = Pais, @ConfiguracionD = NULLIF(RTRIM(Configuracion), '') FROM Deleted
IF @PaisI = 'México' SELECT @PaisI ='Mexico'
IF @PaisD = 'México' SELECT @PaisD ='Mexico'
IF EXISTS (SELECT Pais FROM PersonalPropPais WHERE Pais = 'México')
UPDATE PersonalPropPais SET Pais = 'Mexico'
IF EXISTS (SELECT Pais FROM Empresa WHERE Pais = 'México')
UPDATE Empresa SET Pais = 'Mexico'
IF EXISTS (SELECT Pais FROM Sucursal WHERE Pais = 'México')
UPDATE Sucursal SET Pais = 'Mexico'
IF EXISTS (SELECT Pais FROM Personal WHERE Pais = 'México')
UPDATE Personal SET Pais = 'Mexico'
IF @EmpresaI = @EmpresaD AND @PaisI <> @PaisD
BEGIN
DELETE PersonalPropValor WHERE Rama = 'EMP' AND Cuenta = @EmpresaI
INSERT PersonalPropValor (Propiedad, Rama, Cuenta, Valor)
SELECT p.Propiedad, 'EMP', @EmpresaI, p.porOmision
FROM PersonalProp p
JOIN PersonalPropPais pp ON pp.Propiedad = p.Propiedad AND pp.Pais = @PaisI
WHERE p.NivelEmpresa = 1
IF @PaisI = 'Ecuador'
BEGIN
SELECT @ID = ID FROM Compra WHERE TipoComprobante IS NOT NULL OR SustentoComprobante IS NOT NULL OR TipoIdentificacion IS NOT NULL OR DerechoDevolucion IS NOT NULL OR Establecimiento IS NOT NULL OR PuntoEmision IS NOT NULL OR SecuencialSRI IS NOT NULL OR AutorizacionSRI IS NOT NULL OR VigenteA IS NOT NULL OR SecuenciaRetencion IS NOT NULL OR Comprobante IS NOT NULL OR FechaContableMov IS NOT NULL
IF @@ROWCOUNT = 0
BEGIN
EXEC spDROP_COLUMN 'Compra', 'TipoComprobante'
EXEC spDROP_COLUMN 'Compra', 'SustentoComprobante'
EXEC spDROP_COLUMN 'Compra', 'TipoIdentificacion'
EXEC spDROP_COLUMN 'Compra', 'DerechoDevolucion'
EXEC spDROP_COLUMN 'Compra', 'Establecimiento'
EXEC spDROP_COLUMN 'Compra', 'PuntoEmision'
EXEC spDROP_COLUMN 'Compra', 'SecuencialSRI'
EXEC spDROP_COLUMN 'Compra', 'AutorizacionSRI'
EXEC spDROP_COLUMN 'Compra', 'VigenteA'
EXEC spDROP_COLUMN 'Compra', 'SecuenciaRetencion'
EXEC spDROP_COLUMN 'Compra', 'Comprobante'
EXEC spDROP_COLUMN 'Compra', 'FechaContableMov'
EXEC spDROP_COLUMN 'Compra', 'PuntoEmisionRetencion'
EXEC spDROP_COLUMN 'Compra', 'SecuencialSRIRetencion'
END
SELECT @ID = ID FROM CompraD WHERE TipoComprobante IS NOT NULL OR SustentoComprobante IS NOT NULL OR TipoIdentificacion IS NOT NULL OR DerechoDevolucion IS NOT NULL OR Establecimiento IS NOT NULL OR PuntoEmision IS NOT NULL OR SecuencialSRI IS NOT NULL OR AutorizacionSRI IS NOT NULL OR VigenteA IS NOT NULL OR SecuenciaRetencion IS NOT NULL OR Comprobante IS NOT NULL OR FechaContableMov IS NOT NULL
IF @@ROWCOUNT = 0
BEGIN
EXEC spDROP_COLUMN 'CompraD', 'TipoComprobante'
EXEC spDROP_COLUMN 'CompraD', 'SustentoComprobante'
EXEC spDROP_COLUMN 'CompraD', 'TipoIdentificacion'
EXEC spDROP_COLUMN 'CompraD', 'DerechoDevolucion'
EXEC spDROP_COLUMN 'CompraD', 'Establecimiento'
EXEC spDROP_COLUMN 'CompraD', 'PuntoEmision'
EXEC spDROP_COLUMN 'CompraD', 'SecuencialSRI'
EXEC spDROP_COLUMN 'CompraD', 'AutorizacionSRI'
EXEC spDROP_COLUMN 'CompraD', 'VigenteA'
EXEC spDROP_COLUMN 'CompraD', 'SecuenciaRetencion'
EXEC spDROP_COLUMN 'CompraD', 'Comprobante'
EXEC spDROP_COLUMN 'CompraD', 'FechaContableMov'
END
SELECT @ID = ID FROM Venta WHERE TipoComprobante IS NOT NULL OR SustentoComprobante IS NOT NULL OR TipoIdentificacion IS NOT NULL OR DerechoDevolucion IS NOT NULL OR Establecimiento IS NOT NULL OR PuntoEmision IS NOT NULL OR SecuencialSRI IS NOT NULL OR AutorizacionSRI IS NOT NULL OR VigenteA IS NOT NULL OR SecuenciaRetencion IS NOT NULL OR Comprobante IS NOT NULL OR FechaContableMov IS NOT NULL
IF @@ROWCOUNT = 0
BEGIN
EXEC spDROP_COLUMN 'Venta', 'TipoComprobante'
EXEC spDROP_COLUMN 'Venta', 'SustentoComprobante'
EXEC spDROP_COLUMN 'Venta', 'TipoIdentificacion'
EXEC spDROP_COLUMN 'Venta', 'DerechoDevolucion'
EXEC spDROP_COLUMN 'Venta', 'Establecimiento'
EXEC spDROP_COLUMN 'Venta', 'PuntoEmision'
EXEC spDROP_COLUMN 'Venta', 'SecuencialSRI'
EXEC spDROP_COLUMN 'Venta', 'AutorizacionSRI'
EXEC spDROP_COLUMN 'Venta', 'VigenteA'
EXEC spDROP_COLUMN 'Venta', 'SecuenciaRetencion'
EXEC spDROP_COLUMN 'Venta', 'Comprobante'
EXEC spDROP_COLUMN 'Venta', 'FechaContableMov'
END
SELECT @ID = ID FROM VentaD WHERE TipoComprobante IS NOT NULL OR SustentoComprobante IS NOT NULL OR TipoIdentificacion IS NOT NULL OR DerechoDevolucion IS NOT NULL OR Establecimiento IS NOT NULL OR PuntoEmision IS NOT NULL OR SecuencialSRI IS NOT NULL OR AutorizacionSRI IS NOT NULL OR VigenteA IS NOT NULL OR SecuenciaRetencion IS NOT NULL OR Comprobante IS NOT NULL OR FechaContableMov IS NOT NULL
IF @@ROWCOUNT = 0
BEGIN
EXEC spDROP_COLUMN 'VentaD', 'TipoComprobante'
EXEC spDROP_COLUMN 'VentaD', 'SustentoComprobante'
EXEC spDROP_COLUMN 'VentaD', 'TipoIdentificacion'
EXEC spDROP_COLUMN 'VentaD', 'DerechoDevolucion'
EXEC spDROP_COLUMN 'VentaD', 'Establecimiento'
EXEC spDROP_COLUMN 'VentaD', 'PuntoEmision'
EXEC spDROP_COLUMN 'VentaD', 'SecuencialSRI'
EXEC spDROP_COLUMN 'VentaD', 'AutorizacionSRI'
EXEC spDROP_COLUMN 'VentaD', 'VigenteA'
EXEC spDROP_COLUMN 'VentaD', 'SecuenciaRetencion'
EXEC spDROP_COLUMN 'VentaD', 'Comprobante'
EXEC spDROP_COLUMN 'VentaD', 'FechaContableMov'
END
SELECT @ID = ID FROM Gasto WHERE TipoComprobante IS NOT NULL OR SustentoComprobante IS NOT NULL OR TipoIdentificacion IS NOT NULL OR DerechoDevolucion IS NOT NULL OR Establecimiento IS NOT NULL OR PuntoEmision IS NOT NULL OR SecuencialSRI IS NOT NULL OR AutorizacionSRI IS NOT NULL OR VigenteA IS NOT NULL OR SecuenciaRetencion IS NOT NULL OR Comprobante IS NOT NULL OR FechaContableMov IS NOT NULL
IF @@ROWCOUNT = 0
BEGIN
EXEC spDROP_COLUMN 'Gasto', 'TipoComprobante'
EXEC spDROP_COLUMN 'Gasto', 'SustentoComprobante'
EXEC spDROP_COLUMN 'Gasto', 'TipoIdentificacion'
EXEC spDROP_COLUMN 'Gasto', 'DerechoDevolucion'
EXEC spDROP_COLUMN 'Gasto', 'Establecimiento'
EXEC spDROP_COLUMN 'Gasto', 'PuntoEmision'
EXEC spDROP_COLUMN 'Gasto', 'SecuencialSRI'
EXEC spDROP_COLUMN 'Gasto', 'AutorizacionSRI'
EXEC spDROP_COLUMN 'Gasto', 'VigenteA'
EXEC spDROP_COLUMN 'Gasto', 'SecuenciaRetencion'
EXEC spDROP_COLUMN 'Gasto', 'Comprobante'
EXEC spDROP_COLUMN 'Gasto', 'FechaContableMov'
EXEC spDROP_COLUMN 'Gasto', 'PuntoEmisionRetencion'
EXEC spDROP_COLUMN 'Gasto', 'SecuencialSRIRetencion'
END
SELECT @ID = ID FROM GastoD WHERE TipoComprobante IS NOT NULL OR SustentoComprobante IS NOT NULL OR TipoIdentificacion IS NOT NULL OR DerechoDevolucion IS NOT NULL OR Establecimiento IS NOT NULL OR PuntoEmision IS NOT NULL OR SecuencialSRI IS NOT NULL OR AutorizacionSRI IS NOT NULL OR VigenteA IS NOT NULL OR SecuenciaRetencion IS NOT NULL OR Comprobante IS NOT NULL OR FechaContableMov IS NOT NULL
IF @@ROWCOUNT = 0
BEGIN
EXEC spDROP_COLUMN 'GastoD', 'TipoComprobante'
EXEC spDROP_COLUMN 'GastoD', 'SustentoComprobante'
EXEC spDROP_COLUMN 'GastoD', 'TipoIdentificacion'
EXEC spDROP_COLUMN 'GastoD', 'DerechoDevolucion'
EXEC spDROP_COLUMN 'GastoD', 'Establecimiento'
EXEC spDROP_COLUMN 'GastoD', 'PuntoEmision'
EXEC spDROP_COLUMN 'GastoD', 'SecuencialSRI'
EXEC spDROP_COLUMN 'GastoD', 'AutorizacionSRI'
EXEC spDROP_COLUMN 'GastoD', 'VigenteA'
EXEC spDROP_COLUMN 'GastoD', 'SecuenciaRetencion'
EXEC spDROP_COLUMN 'GastoD', 'Comprobante'
EXEC spDROP_COLUMN 'GastoD', 'FechaContableMov'
EXEC spDROP_COLUMN 'GastoD', 'EcuadorTipoOperacionGasto'
END
EXEC spALTER_TABLE 'Compra', 'TipoComprobante', 'varchar(20) NULL'
EXEC spALTER_TABLE 'Compra', 'SustentoComprobante', 'varchar(20) NULL'
EXEC spALTER_TABLE 'Compra', 'TipoIdentificacion', 'varchar(20) NULL'
EXEC spALTER_TABLE 'Compra', 'DerechoDevolucion', 'bit NULL'
EXEC spALTER_TABLE 'Compra', 'Establecimiento', 'varchar(20) NULL'
EXEC spALTER_TABLE 'Compra', 'PuntoEmision', 'varchar(50) NULL'
EXEC spALTER_TABLE 'Compra', 'SecuencialSRI', 'varchar(50) NULL'
EXEC spALTER_TABLE 'Compra', 'AutorizacionSRI', 'varchar(50) NULL'
EXEC spALTER_TABLE 'Compra', 'VigenteA', 'datetime NULL'
EXEC spALTER_TABLE 'Compra', 'SecuenciaRetencion', 'varchar(50) NULL'
EXEC spALTER_TABLE 'Compra', 'Comprobante', 'bit NULL'
EXEC spALTER_TABLE 'Compra', 'FechaContableMov', 'datetime NULL'
EXEC spALTER_TABLE 'Compra', 'PuntoEmisionRetencion', 'varchar(50) NULL'
EXEC spALTER_TABLE 'Compra', 'SecuencialSRIRetencion', 'varchar(50) NULL'
EXEC spALTER_TABLE 'CompraD', 'TipoComprobante', 'varchar(20) NULL'
EXEC spALTER_TABLE 'CompraD', 'SustentoComprobante', 'varchar(20) NULL'
EXEC spALTER_TABLE 'CompraD', 'TipoIdentificacion', 'varchar(20) NULL'
EXEC spALTER_TABLE 'CompraD', 'DerechoDevolucion', 'bit NULL'
EXEC spALTER_TABLE 'CompraD', 'Establecimiento', 'varchar(20) NULL'
EXEC spALTER_TABLE 'CompraD', 'PuntoEmision', 'varchar(50) NULL'
EXEC spALTER_TABLE 'CompraD', 'SecuencialSRI', 'varchar(50) NULL'
EXEC spALTER_TABLE 'CompraD', 'AutorizacionSRI', 'varchar(50) NULL'
EXEC spALTER_TABLE 'CompraD', 'VigenteA', 'datetime NULL'
EXEC spALTER_TABLE 'CompraD', 'SecuenciaRetencion', 'varchar(50) NULL'
EXEC spALTER_TABLE 'CompraD', 'Comprobante', 'bit NULL'
EXEC spALTER_TABLE 'CompraD', 'FechaContableMov', 'datetime NULL'
EXEC spALTER_TABLE 'Venta', 'TipoComprobante', 'varchar(20) NULL'
EXEC spALTER_TABLE 'Venta', 'SustentoComprobante', 'varchar(20) NULL'
EXEC spALTER_TABLE 'Venta', 'TipoIdentificacion', 'varchar(20) NULL'
EXEC spALTER_TABLE 'Venta', 'DerechoDevolucion', 'bit NULL'
EXEC spALTER_TABLE 'Venta', 'Establecimiento', 'varchar(20) NULL'
EXEC spALTER_TABLE 'Venta', 'PuntoEmision', 'varchar(50) NULL'
EXEC spALTER_TABLE 'Venta', 'SecuencialSRI', 'varchar(50) NULL'
EXEC spALTER_TABLE 'Venta', 'AutorizacionSRI', 'varchar(50) NULL'
EXEC spALTER_TABLE 'Venta', 'VigenteA', 'datetime NULL'
EXEC spALTER_TABLE 'Venta', 'SecuenciaRetencion', 'varchar(50) NULL'
EXEC spALTER_TABLE 'Venta', 'Comprobante', 'bit NULL'
EXEC spALTER_TABLE 'Venta', 'FechaContableMov', 'datetime NULL'
EXEC spALTER_TABLE 'VentaD', 'TipoComprobante', 'varchar(20) NULL'
EXEC spALTER_TABLE 'VentaD', 'SustentoComprobante', 'varchar(20) NULL'
EXEC spALTER_TABLE 'VentaD', 'TipoIdentificacion', 'varchar(20) NULL'
EXEC spALTER_TABLE 'VentaD', 'DerechoDevolucion', 'bit NULL'
EXEC spALTER_TABLE 'VentaD', 'Establecimiento', 'varchar(20) NULL'
EXEC spALTER_TABLE 'VentaD', 'PuntoEmision', 'varchar(50) NULL'
EXEC spALTER_TABLE 'VentaD', 'SecuencialSRI', 'varchar(50) NULL'
EXEC spALTER_TABLE 'VentaD', 'AutorizacionSRI', 'varchar(50) NULL'
EXEC spALTER_TABLE 'VentaD', 'VigenteA', 'datetime NULL'
EXEC spALTER_TABLE 'VentaD', 'SecuenciaRetencion', 'varchar(50) NULL'
EXEC spALTER_TABLE 'VentaD', 'Comprobante', 'bit NULL'
EXEC spALTER_TABLE 'VentaD', 'FechaContableMov', 'datetime NULL'
EXEC spALTER_TABLE 'Gasto', 'TipoComprobante', 'varchar(20) NULL'
EXEC spALTER_TABLE 'Gasto', 'SustentoComprobante', 'varchar(20) NULL'
EXEC spALTER_TABLE 'Gasto', 'TipoIdentificacion', 'varchar(20) NULL'
EXEC spALTER_TABLE 'Gasto', 'DerechoDevolucion', 'bit NULL'
EXEC spALTER_TABLE 'Gasto', 'Establecimiento', 'varchar(20) NULL'
EXEC spALTER_TABLE 'Gasto', 'PuntoEmision', 'varchar(50) NULL'
EXEC spALTER_TABLE 'Gasto', 'SecuencialSRI', 'varchar(50) NULL'
EXEC spALTER_TABLE 'Gasto', 'AutorizacionSRI', 'varchar(50) NULL'
EXEC spALTER_TABLE 'Gasto', 'VigenteA', 'datetime NULL'
EXEC spALTER_TABLE 'Gasto', 'SecuenciaRetencion', 'varchar(50) NULL'
EXEC spALTER_TABLE 'Gasto', 'Comprobante', 'bit NULL'
EXEC spALTER_TABLE 'Gasto', 'FechaContableMov', 'datetime NULL'
EXEC spALTER_TABLE 'GastoD', 'TipoComprobante', 'varchar(20) NULL'
EXEC spALTER_TABLE 'GastoD', 'SustentoComprobante', 'varchar(20) NULL'
EXEC spALTER_TABLE 'GastoD', 'TipoIdentificacion', 'varchar(20) NULL'
EXEC spALTER_TABLE 'GastoD', 'DerechoDevolucion', 'bit NULL'
EXEC spALTER_TABLE 'GastoD', 'Establecimiento', 'varchar(20) NULL'
EXEC spALTER_TABLE 'GastoD', 'PuntoEmision', 'varchar(50) NULL'
EXEC spALTER_TABLE 'GastoD', 'SecuencialSRI', 'varchar(50) NULL'
EXEC spALTER_TABLE 'GastoD', 'AutorizacionSRI', 'varchar(50) NULL'
EXEC spALTER_TABLE 'GastoD', 'VigenteA', 'datetime NULL'
EXEC spALTER_TABLE 'GastoD', 'SecuenciaRetencion', 'varchar(50) NULL'
EXEC spALTER_TABLE 'GastoD', 'Comprobante', 'bit NULL'
EXEC spALTER_TABLE 'GastoD', 'FechaContableMov', 'datetime NULL'
EXEC spALTER_TABLE 'GastoD', 'EcuadorTipoOperacionGasto', 'varchar(50) NULL'
END
END
IF @EmpresaI IS NULL AND @EmpresaD IS NULL RETURN
IF @EmpresaD IS NULL
BEGIN
DELETE EmpresaCfg        WHERE Empresa = @EmpresaI
DELETE EmpresaCfg2       WHERE Empresa = @EmpresaI
DELETE EmpresaCfgNomAuto WHERE Empresa = @EmpresaI
DELETE EmpresaCfgPuntosEnVales	WHERE Empresa = @EmpresaI
DELETE EmpresaCfgMov     WHERE Empresa = @EmpresaI
DELETE EmpresaCfgMovWMS     WHERE Empresa = @EmpresaI 
DELETE EmpresaCfgAcceso  WHERE Empresa = @EmpresaI
DELETE EmpresaCfgPV      WHERE Empresa = @EmpresaI
DELETE EmpresaCfgFRP     WHERE Empresa = @EmpresaI  
DELETE EmpresaGral       WHERE Empresa = @EmpresaI
DELETE PersonalPropValor WHERE Rama = 'EMP' AND Cuenta = @EmpresaI
DELETE EmpresaCfgMovCompra	WHERE Empresa = @EmpresaI
DELETE EmpresaCfgMovCxp		WHERE Empresa = @EmpresaI
DELETE EmpresaCfgMovCxc		WHERE Empresa = @EmpresaI 
DELETE EmpresaCfgMovCP		WHERE Empresa = @EmpresaI
DELETE EmpresaCfgMovPCP		WHERE Empresa = @EmpresaI
DELETE EmpresaCfgMovGES		WHERE Empresa = @EmpresaI
DELETE EmpresaCfgMovContParalela WHERE Empresa = @EmpresaI
INSERT EmpresaCfg        (Empresa) VALUES (@EmpresaI)
INSERT EmpresaCfg2       (Empresa) VALUES (@EmpresaI)
INSERT EmpresaCfgNomAuto (Empresa) VALUES (@EmpresaI)
INSERT EmpresaCfgPuntosEnVales	(Empresa) VALUES (@EmpresaI)
INSERT EmpresaCfgMov     (Empresa) VALUES (@EmpresaI)
INSERT EmpresaCfgMovWMS     (Empresa) VALUES (@EmpresaI) 
INSERT EmpresaCfgMovRecluta (Empresa) VALUES (@EmpresaI)
INSERT EmpresaCfgMovVenta (Empresa) VALUES (@EmpresaI)
INSERT EmpresaCfgMovCorte (Empresa) VALUES (@EmpresaI)
INSERT EmpresaCfgMovOPORT (Empresa) VALUES (@EmpresaI)
INSERT EmpresaCfgMovImp(Empresa, Modulo, Mov, Estatus, ReporteImpresora, ReportePantalla, Sucursal) VALUES(@EmpresaI, 'CORTE', 'Estado Cuenta Cxc',		'CONCLUIDO', 'CorteEdoCtaCx',	'CorteEdoCtaCx', 0)
INSERT EmpresaCfgMovImp(Empresa, Modulo, Mov, Estatus, ReporteImpresora, ReportePantalla, Sucursal) VALUES(@EmpresaI, 'CORTE', 'Estado Cuenta Cxp',		'CONCLUIDO', 'CorteEdoCtaCx',	'CorteEdoCtaCx', 0)
INSERT EmpresaCfgMovImp(Empresa, Modulo, Mov, Estatus, ReporteImpresora, ReportePantalla, Sucursal) VALUES(@EmpresaI, 'CORTE', 'Reporte Externo',		'CONCLUIDO', 'CorteRepExterno', 'CorteRepExterno', 0)
INSERT EmpresaCfgMovImp(Empresa, Modulo, Mov, Estatus, ReporteImpresora, ReportePantalla, Sucursal) VALUES(@EmpresaI, 'CORTE', 'Valuacion Inventario',	'CONCLUIDO', 'CorteInvVal',		'CorteInvVal', 0)
INSERT EmpresaCfgMovImp(Empresa, Modulo, Mov, Estatus, ReporteImpresora, ReportePantalla, Sucursal) VALUES(@EmpresaI, 'CORTE', 'Corte Importe',			'CONCLUIDO', 'CorteImporte',	'CorteImporte', 0)
INSERT EmpresaCfgMovImp(Empresa, Modulo, Mov, Estatus, ReporteImpresora, ReportePantalla, Sucursal) VALUES(@EmpresaI, 'CORTE', 'Corte Contable',		'CONCLUIDO', 'CorteContable',	'CorteContable', 0)
INSERT EmpresaCfgMovImp(Empresa, Modulo, Mov, Estatus, ReporteImpresora, ReportePantalla, Sucursal) VALUES(@EmpresaI, 'CORTE', 'Corte Unidades',		'CONCLUIDO', 'CorteUnidades',	'CorteUnidades', 0)
INSERT EmpresaCfgMovImp(Empresa, Modulo, Mov, Estatus, ReporteImpresora, ReportePantalla, Sucursal) VALUES(@EmpresaI, 'CORTE', 'Corte Cx',				'CONCLUIDO', 'CorteCx',			'CorteCx', 0)
INSERT EmpresaCfgMovImp(Empresa, Modulo, Mov, Estatus, ReporteImpresora, ReportePantalla, Sucursal) VALUES(@EmpresaI, 'CORTE', 'Estado Cuenta Cxc',		'CANCELADO', 'CorteEdoCtaCx',	'CorteEdoCtaCx', 0)
INSERT EmpresaCfgMovImp(Empresa, Modulo, Mov, Estatus, ReporteImpresora, ReportePantalla, Sucursal) VALUES(@EmpresaI, 'CORTE', 'Estado Cuenta Cxp',		'CANCELADO', 'CorteEdoCtaCx',	'CorteEdoCtaCx', 0)
INSERT EmpresaCfgMovImp(Empresa, Modulo, Mov, Estatus, ReporteImpresora, ReportePantalla, Sucursal) VALUES(@EmpresaI, 'CORTE', 'Reporte Externo',		'CANCELADO', 'CorteRepExterno', 'CorteRepExterno', 0)
INSERT EmpresaCfgMovImp(Empresa, Modulo, Mov, Estatus, ReporteImpresora, ReportePantalla, Sucursal) VALUES(@EmpresaI, 'CORTE', 'Valuacion Inventario',	'CANCELADO', 'CorteInvVal',		'CorteInvVal', 0)
INSERT EmpresaCfgMovImp(Empresa, Modulo, Mov, Estatus, ReporteImpresora, ReportePantalla, Sucursal) VALUES(@EmpresaI, 'CORTE', 'Corte Importe',			'CANCELADO', 'CorteImporte',	'CorteImporte', 0)
INSERT EmpresaCfgMovImp(Empresa, Modulo, Mov, Estatus, ReporteImpresora, ReportePantalla, Sucursal) VALUES(@EmpresaI, 'CORTE', 'Corte Contable',		'CANCELADO', 'CorteContable',	'CorteContable', 0)
INSERT EmpresaCfgMovImp(Empresa, Modulo, Mov, Estatus, ReporteImpresora, ReportePantalla, Sucursal) VALUES(@EmpresaI, 'CORTE', 'Corte Unidades',		'CANCELADO', 'CorteUnidades',	'CorteUnidades', 0)
INSERT EmpresaCfgMovImp(Empresa, Modulo, Mov, Estatus, ReporteImpresora, ReportePantalla, Sucursal) VALUES(@EmpresaI, 'CORTE', 'Corte Cx',				'CANCELADO', 'CorteCx',			'CorteCx', 0)
INSERT EmpresaCfgMovCompra (Empresa) VALUES (@EmpresaI) 
INSERT EmpresaCfgMovCxp (Empresa) VALUES (@EmpresaI) 
INSERT EmpresaCfgMovCxc (Empresa) VALUES (@EmpresaI) 
INSERT EmpresaCfgMovCP (Empresa) VALUES (@EmpresaI)
INSERT EmpresaCfgMovPCP (Empresa) VALUES (@EmpresaI)
INSERT EmpresaCfgMovGES (Empresa) VALUES (@EmpresaI) 
INSERT EmpresaCfgMovDinero (Empresa) VALUES (@EmpresaI) 
INSERT EmpresaCfgMovContParalela (Empresa) VALUES (@EmpresaI) 
INSERT EmpresaCfgAcceso  (Empresa) VALUES (@EmpresaI)
INSERT EmpresaCfgPV      (Empresa) VALUES (@EmpresaI)
INSERT EmpresaCfgFRP      (Empresa) VALUES (@EmpresaI)  
INSERT EmpresaGral       (Empresa) VALUES (@EmpresaI)
INSERT PersonalPropValor (Propiedad, Rama, Cuenta, Valor)
SELECT p.Propiedad, 'EMP', @EmpresaI, p.porOmision
FROM PersonalProp p
JOIN PersonalPropPais pp ON pp.Propiedad = p.Propiedad AND pp.Pais = @PaisI
WHERE p.NivelEmpresa = 1
END ELSE
IF @EmpresaI IS NULL
BEGIN
DELETE EmpresaCfg        WHERE Empresa = @EmpresaD
DELETE EmpresaCfg2       WHERE Empresa = @EmpresaD
DELETE EmpresaCfgNomAuto WHERE Empresa = @EmpresaD
DELETE EmpresaCfgPuntosEnVales	WHERE Empresa = @EmpresaD
DELETE EmpresaCfgMov     WHERE Empresa = @EmpresaD
DELETE EmpresaCfgMovWMS     WHERE Empresa = @EmpresaD 
DELETE EmpresaCfgAcceso  WHERE Empresa = @EmpresaD
DELETE EmpresaCfgPV      WHERE Empresa = @EmpresaD
DELETE EmpresaCfgFRP      WHERE Empresa = @EmpresaD
DELETE EmpresaGral       WHERE Empresa = @EmpresaD
DELETE EmpresaPedidosReservarEsp WHERE Empresa = @EmpresaD
DELETE PersonalPropValor WHERE Rama = 'EMP' AND Cuenta = @EmpresaD
DELETE EmpresaSocio      WHERE Empresa = @EmpresaD
DELETE EmpresaCfgMovRecluta WHERE Empresa = @EmpresaD
DELETE EmpresaCfgMovVenta WHERE Empresa = @EmpresaD
DELETE EmpresaCfgMovCorte WHERE Empresa = @EmpresaD
DELETE EmpresaCfgMovOPORT WHERE Empresa = @EmpresaD
DELETE EmpresaCfgMovImp WHERE Empresa = @EmpresaD AND Modulo = 'CORTE'
DELETE EmpresaCfgMovDinero       WHERE Empresa = @EmpresaD
END ELSE
IF @EmpresaD <> @EmpresaI
BEGIN
UPDATE EmpresaCfg        SET Empresa = @EmpresaI WHERE Empresa = @EmpresaD
UPDATE EmpresaCfg2       SET Empresa = @EmpresaI WHERE Empresa = @EmpresaD
UPDATE EmpresaCfgNomAuto SET Empresa = @EmpresaI WHERE Empresa = @EmpresaD
UPDATE EmpresaCfgPuntosEnVales SET Empresa = @EmpresaI WHERE Empresa = @EmpresaD
UPDATE EmpresaCfgMov     SET Empresa = @EmpresaI WHERE Empresa = @EmpresaD
UPDATE EmpresaCfgMovWMS     SET Empresa = @EmpresaI WHERE Empresa = @EmpresaD 
UPDATE EmpresaCfgAcceso  SET Empresa = @EmpresaI WHERE Empresa = @EmpresaD
UPDATE EmpresaCfgPV      SET Empresa = @EmpresaI WHERE Empresa = @EmpresaD
UPDATE EmpresaCfgFRP      SET Empresa = @EmpresaI WHERE Empresa = @EmpresaD
UPDATE EmpresaGral       SET Empresa = @EmpresaI WHERE Empresa = @EmpresaD
UPDATE EmpresaCfgMovDinero       SET Empresa = @EmpresaI WHERE Empresa = @EmpresaD
UPDATE EmpresaPedidosReservarEsp SET Empresa = @EmpresaI WHERE Empresa = @EmpresaD
UPDATE PersonalPropValor SET Cuenta  = @EmpresaI WHERE Rama = 'EMP' AND Cuenta = @EmpresaD
UPDATE EmpresaSocio      SET Empresa = @EmpresaI WHERE Empresa = @EmpresaD
END
IF @EmpresaI IS NOT NULL
BEGIN
IF @ConfiguracionI IS NULL
EXEC spCopiarTablaLista 'Empresa', @EmpresaI
ELSE BEGIN
EXEC spCopiarTabla 'Empresa', @ConfiguracionI, @EmpresaI
END
END
END

