SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaG4CargaArchivo
@Estacion    INT,
@Empresa     VARCHAR(5),
@Sucursal    INT,
@ID          INT,
@OK          INT,
@PeriodoTipo VARCHAR(50),
@FechaD      DATETIME,
@FechaA      DATETIME,
@UUID        VARCHAR(101)

AS BEGIN
DECLARE
@Archivo            VARCHAR(500),
@Bulk               VARCHAR(400),
@Renglon	          FLOAT,
@Mov                VARCHAR(20),
@IDNomX             INT,
@Debug              BIT,
@Directorio         VARCHAR(255),
@Ruta               VARCHAR(255),
@Ruta2              VARCHAR(255),
@ComandShell        VARCHAR(255)
SELECT @Mov = Mov FROM Nomina WHERE ID = @ID
SELECT @IDNomX = ID FROM NomX WHERE NomMov = @Mov
SELECT TOP 1 @Directorio = DirectorioArchivosZip, @Debug = ISNULL(Debug, 0)  FROM ServiciosG3 WHERE Servicio = 'Nomina' AND Estatus = 1
SELECT @Ruta =    @Directorio+'\'+@UUID,
@Ruta2 =   @Directorio+'\'+@UUID+'CSV',
@Archivo = @Directorio+'\'+@UUID+'CSV\output.csv'
SELECT @Renglon = 2048
TRUNCATE TABLE OutputNominaG4
CREATE TABLE #OutputNominaG4(
Personal    VARCHAR(100),
Cuenta      VARCHAR(100) NULL,
Importe     VARCHAR(100) NULL,
Cantidad    VARCHAR(100) NULL,
Concepto    VARCHAR(100),
Movimiento  VARCHAR(100) NULL,
Fecha       VARCHAR(100) NULL,
Grupo       VARCHAR(50)  NULL,
Objeto      VARCHAR(100) NULL,
)
CREATE TABLE #OutputNominaG4_2(
Personal          VARCHAR(100),
Cuenta            VARCHAR(100) NULL,
Importe           VARCHAR(100) NULL,
Cantidad          VARCHAR(100) NULL,
Concepto          VARCHAR(100),
ConceptoIntelisis VARCHAR(100) NULL,
Movimiento        VARCHAR(100) NULL,
Fecha             VARCHAR(100) NULL,
Grupo             VARCHAR(50)  NULL,
Objeto            VARCHAR(100) NULL,
TipoCuenta        VARCHAR(50)  NULL,
CuentaContable    VARCHAR(50)  NULL,
TipoAgrupador     VARCHAR(50)  NULL,
GrupoPersonal     VARCHAR(50)  NULL,
CentroCostos      VARCHAR(20)  NULL,
Departamento      VARCHAR(50)  NULL,
Puesto            VARCHAR(50)  NULL,
UEN               INT          NULL,
SucursalTrabajo   INT          NULL,
Area              VARCHAR(50)  NULL,
Proyecto          VARCHAR(50)  NULL,
Categoria         VARCHAR(50)  NULL,
Renglon           INT IDENTITY(2048, 2048),
CuentaD           VARCHAR(10)  NULL,
constraint priOutputNominaG4_2 primary key clustered (Renglon)
)
CREATE NONCLUSTERED INDEX Compuesto
ON #OutputNominaG4_2 ([Personal],[Objeto])
INCLUDE ([Importe],[Cantidad],[Concepto],[Fecha],[Grupo],[Renglon])
SELECT @Bulk = 'BULK
INSERT #OutputNominaG4
FROM '''+@Archivo+'''
WITH
( FIELDTERMINATOR = ''|'',
ROWTERMINATOR = ''0x0a'',
CODEPAGE = ''ACP'' )'
EXEC(@Bulk)
INSERT INTO #OutputNominaG4_2 (Personal,      Cuenta,         Importe,        Cantidad,   Concepto,   ConceptoIntelisis, Movimiento,    Fecha,   Grupo,      Objeto,   TipoCuenta,   TipoAgrupador,   CuentaContable,
GrupoPersonal, CentroCostos,   Departamento,   Puesto,     UEN,        SucursalTrabajo,   Area,          Proyecto,   Categoria)
SELECT                    o.Personal,    o.Cuenta,       o.Importe,      o.Cantidad, o.Concepto, n.Concepto,        o.Movimiento,  o.Fecha, o.Grupo,    o.Objeto, n.TipoCuenta, n.TipoAgrupador, CASE WHEN n.TipoCuenta = 'Especifica' THEN n.CuentaEspecifica ELSE CASE WHEN n.TipoCuenta = 'Personal' THEN p.Cuenta ELSE CASE WHEN n.TipoCuenta = 'Personal Retencion' THEN p.CuentaRetencion ELSE NULL END END END,
p.Grupo,       p.CentroCostos, p.Departamento, p.Puesto,   p.UEN,      p.SucursalTrabajo, p.Area,  p.Proyecto, p.Categoria
FROM #OutputNominaG4 o
JOIN Personal p on p.Personal = o.Personal
JOIN NominaConceptoEx n ON n.Clave = o.Concepto AND n.Objeto = o.Objeto AND n.IDNomX = @IDNomX
WHERE n.Ocultar = 'no'
ORDER BY Personal, Movimiento
UPDATE o SET o.CuentaContable = n.Cuenta
FROM #OutputNominaG4_2 o  JOIN NominaG4TablaCuentas n ON n.Clave = o.Concepto AND n.Objeto = o.Objeto AND n.IDNomX = @IDNomX AND o.TipoAgrupador = n.TipoAgrupador AND n.Valor = o.GrupoPersonal
WHERE o.TipoCuenta = 'Tabla'  AND o.TipoAgrupador = 'Grupo'
UPDATE o SET o.CuentaContable = n.Cuenta
FROM #OutputNominaG4_2 o  JOIN NominaG4TablaCuentas n ON n.Clave = o.Concepto AND n.Objeto = o.Objeto AND n.IDNomX = @IDNomX AND o.TipoAgrupador = n.TipoAgrupador AND n.Valor = o.CentroCostos
WHERE o.TipoCuenta = 'Tabla'  AND o.TipoAgrupador = 'CentroCostos'
UPDATE o SET o.CuentaContable = n.Cuenta
FROM #OutputNominaG4_2 o  JOIN NominaG4TablaCuentas n ON n.Clave = o.Concepto AND n.Objeto = o.Objeto AND n.IDNomX = @IDNomX AND o.TipoAgrupador = n.TipoAgrupador AND n.Valor = o.Departamento
WHERE o.TipoCuenta = 'Tabla'  AND o.TipoAgrupador = 'Departamento'
UPDATE o SET o.CuentaContable = n.Cuenta
FROM #OutputNominaG4_2 o  JOIN NominaG4TablaCuentas n ON n.Clave = o.Concepto AND n.Objeto = o.Objeto AND n.IDNomX = @IDNomX AND o.TipoAgrupador = n.TipoAgrupador AND n.Valor = o.Puesto
WHERE o.TipoCuenta = 'Tabla'  AND o.TipoAgrupador = 'Puesto'
UPDATE o SET o.CuentaContable = n.Cuenta
FROM #OutputNominaG4_2 o  JOIN NominaG4TablaCuentas n ON n.Clave = o.Concepto AND n.Objeto = o.Objeto AND n.IDNomX = @IDNomX AND o.TipoAgrupador = n.TipoAgrupador AND n.Valor = o.UEN
WHERE o.TipoCuenta = 'Tabla'  AND o.TipoAgrupador = 'UEN'
UPDATE o SET o.CuentaContable = n.Cuenta
FROM #OutputNominaG4_2 o  JOIN NominaG4TablaCuentas n ON n.Clave = o.Concepto AND n.Objeto = o.Objeto AND n.IDNomX = @IDNomX AND o.TipoAgrupador = n.TipoAgrupador AND n.Valor = o.SucursalTrabajo
WHERE o.TipoCuenta = 'Tabla'  AND o.TipoAgrupador = 'SucursalTrabajo'
UPDATE o SET o.CuentaContable = n.Cuenta
FROM #OutputNominaG4_2 o  JOIN NominaG4TablaCuentas n ON n.Clave = o.Concepto AND n.Objeto = o.Objeto AND n.IDNomX = @IDNomX AND o.TipoAgrupador = n.TipoAgrupador AND n.Valor = o.Area
WHERE o.TipoCuenta = 'Tabla'  AND o.TipoAgrupador = 'Area'
UPDATE o SET o.CuentaContable = n.Cuenta
FROM #OutputNominaG4_2 o  JOIN NominaG4TablaCuentas n ON n.Clave = o.Concepto AND n.Objeto = o.Objeto AND n.IDNomX = @IDNomX AND o.TipoAgrupador = n.TipoAgrupador AND n.Valor = o.Proyecto
WHERE o.TipoCuenta = 'Tabla'  AND o.TipoAgrupador = 'Proyecto'
UPDATE o SET o.CuentaContable = n.Cuenta
FROM #OutputNominaG4_2 o  JOIN NominaG4TablaCuentas n ON n.Clave = o.Concepto AND n.Objeto = o.Objeto AND n.IDNomX = @IDNomX AND o.TipoAgrupador = n.TipoAgrupador AND n.Valor = o.Categoria
WHERE o.TipoCuenta = 'Tabla'  AND o.TipoAgrupador = 'Categoria'
INSERT INTO #OutputNominaG4_2 (Personal,   Cuenta,   Importe, Cantidad, Concepto,   Movimiento,   Fecha, Grupo,   Objeto,   CuentaD, ConceptoIntelisis)
SELECT                    o.Personal, o.Cuenta, Importe, Cantidad, o.Concepto, o.Movimiento, Fecha, o.Grupo, o.Objeto, p.Valor, n.Concepto
FROM #OutputNominaG4 o
JOIN NominaConceptoEx n ON n.Clave = o.Concepto AND n.Objeto = o.Objeto AND n.IDNomX = @IDNomX
LEFT JOIN PersonalPropValor p ON p.Propiedad = n.AcreedorPropiedad AND p.Cuenta = @Empresa AND p.Rama = 'EMP'
WHERE ISNULL(o.Personal, '') = '' AND n.Ocultar = 'no'
IF @OK = 200
BEGIN
INSERT INTO NominaD (ID,   Renglon,   Modulo, Personal,   Importe,   Cantidad,   Concepto,            FechaA,                     Movimiento,   Sucursal,  SucursalOrigen, CuentaContable)
SELECT          @ID,  o.Renglon, 'NOM',  o.Personal, o.Importe, o.Cantidad, o.ConceptoIntelisis, CONVERT(DATETIME, o.Fecha), o.Movimiento, @Sucursal, @Sucursal,      o.CuentaContable
FROM #OutputNominaG4_2 o
WHERE ISNULL(o.Personal, '') <> ''
INSERT INTO NominaD (ID,  Renglon,   Modulo, Cuenta,                      Importe,   Concepto,            FechaA,  Movimiento,  Sucursal,  SucursalOrigen)
SELECT          @ID, o.Renglon, 'CXP',  ISNULL(o.Cuenta, o.CuentaD), o.Importe, o.ConceptoIntelisis, o.Fecha, 'por Pagar', @Sucursal, @Sucursal
FROM #OutputNominaG4_2 o
WHERE ISNULL(o.Personal, '') = ''
UPDATE Nomina SET PeriodoTipo = @PeriodoTipo, FechaD = @FechaD, FechaA = @FechaA, Estatus = 'BORRADOR' WHERE ID = @ID
IF @Debug = 0
BEGIN
SELECT @ComandShell = 'rd '+ @Ruta  +' /S /Q;'
EXEC xp_cmdshell @ComandShell, NO_OUTPUT
SELECT @ComandShell = 'rd '+ @Ruta2  +' /S /Q;'
EXEC xp_cmdshell @ComandShell, NO_OUTPUT
END
SELECT 'Proceso Concluido'
END
ELSE
BEGIN
SELECT 'Proceso Concluido Con Errores'
END
END

