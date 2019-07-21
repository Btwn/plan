SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaG4Validar
@Estacion      INT,
@Empresa       VARCHAR(5),
@Sucursal      INT,
@ID            INT,
@PeriodoTipo   VARCHAR(50),
@FechaD        DATETIME,
@FechaA        DATETIME,
@TipoNominaG4  VARCHAR(50),
@Ok            INT OUTPUT,
@OkRef         VARCHAR(255) OUTPUT

AS
BEGIN
DECLARE
@Mov    VARCHAR(50),
@IDNomX INT
SELECT @Mov = Mov FROM Nomina WHERE ID = @ID
SELECT @IDNomX = ID FROM NomX WHERE NomMov = @Mov
SELECT @Ok = NULL
DELETE NominaG4ErroresCFG WHERE Estacion = @Estacion
IF EXISTS(SELECT Objeto, IDNomX, Concepto, count(*) NumeroVeces FROM NominaConceptoEx GROUP BY Objeto, IDNomX, Concepto HAVING COUNT(*) >= 2 AND IDNomX = 1 AND isnull(Concepto, '') <>'')
BEGIN
SELECT @OK = 1, @OkRef = 'Existe Conceptos repetiodos dentro del mismo Objeto de NominaConceptoEx'
INSERT INTO NominaG4ErroresCFG (Estacion,  Rama, Cuenta, Propiedad, Valor,    Descripcion)
SELECT                     @Estacion, NULL, Objeto, Concepto,  COUNT(*), @OkRef
FROM NominaConceptoEx
GROUP BY Objeto, IDNomX, Concepto
HAVING COUNT(*) >= 2 AND IDNomX = @IDNomX AND isnull(Concepto, '') <>''
END
IF @TipoNominaG4 = 'Nomina Normal'
BEGIN
IF EXISTS (SELECT * FROM Personal WHERE Personal IN (SELECT Clave FROM ListaSt WHERE Estacion = @Estacion) AND ISNULL(FechaBaja, '') <> '')
BEGIN
SELECT @OK = 1, @OkRef = 'En una Nómina Normal no pueden existir empleados con fecha de baja'
INSERT INTO NominaG4ErroresCFG (Estacion,  Rama, Cuenta,   Propiedad, Valor, Descripcion)
SELECT                     @Estacion, NULL, Personal, FechaBaja, NULL,  @OkRef
FROM Personal
WHERE Personal IN (SELECT Clave FROM ListaSt WHERE Estacion = @Estacion) AND ISNULL(FechaBaja, '') <> ''
END
END
IF Exists (SELECT * FROM PersonalProp WHERE NivelPersonal = 1 AND NivelEmpresa  = 1)
BEGIN
SELECT @OK = 1, @OkRef = 'Existen propiedades configuradas a nivel Personal y Empresa al mismo tiempo'
INSERT INTO NominaG4ErroresCFG (Estacion,  Rama, Cuenta, Propiedad, Valor, Descripcion)
SELECT                     @Estacion, NULL, NULL,   Propiedad, NULL,  @OkRef
FROM PersonalProp
WHERE NivelPersonal = 1 AND NivelEmpresa  = 1
END
IF Exists (SELECT * FROM PersonalProp WHERE NivelPersonal = 1 AND NivelSucursal = 1)
BEGIN
SELECT @OK = 1, @OkRef = 'Existen propiedades configuradas a nivel Personal y Sucursal al mismo tiempo'
INSERT INTO NominaG4ErroresCFG (Estacion,  Rama, Cuenta, Propiedad, Valor, Descripcion)
SELECT                     @Estacion, NULL, NULL,   Propiedad, NULL,  @OkRef
FROM PersonalProp
WHERE NivelPersonal = 1 AND NivelSucursal = 1
END
IF Exists (SELECT * FROM PersonalProp WHERE NivelPersonal = 1 AND NivelCategoria = 1)
BEGIN
SELECT @OK = 1, @OkRef = 'Existen propiedades configuradas a nivel Personal y Categoria al mismo tiempo'
INSERT INTO NominaG4ErroresCFG (Estacion,  Rama, Cuenta, Propiedad, Valor, Descripcion)
SELECT                     @Estacion, NULL, NULL,   Propiedad, NULL,  @OkRef
FROM PersonalProp
WHERE NivelPersonal = 1 AND NivelCategoria = 1
END
IF Exists (SELECT * FROM PersonalProp WHERE NivelPersonal = 1 AND NivelPuesto = 1)
BEGIN
SELECT @OK = 1, @OkRef = 'Existen propiedades configuradas a nivel Personal y Puesto al mismo tiempo'
INSERT INTO NominaG4ErroresCFG (Estacion,  Rama, Cuenta, Propiedad, Valor, Descripcion)
SELECT                     @Estacion, NULL, NULL,   Propiedad, NULL,  @OkRef
FROM PersonalProp
WHERE NivelPersonal = 1 AND NivelPuesto = 1
END
IF Exists (SELECT * FROM PersonalProp WHERE NivelEmpresa = 1 AND NivelSucursal = 1)
BEGIN
SELECT @OK = 1, @OkRef = 'Existen propiedades configuradas a nivel Empresa y Sucursal al mismo tiempo'
INSERT INTO NominaG4ErroresCFG (Estacion,  Rama, Cuenta, Propiedad, Valor, Descripcion)
SELECT                     @Estacion, NULL, NULL,   Propiedad, NULL,  @OkRef
FROM PersonalProp
WHERE NivelEmpresa = 1 AND NivelSucursal = 1
END
IF Exists (SELECT * FROM PersonalProp WHERE NivelEmpresa = 1 AND NivelCategoria = 1)
BEGIN
SELECT @OK = 1, @OkRef = 'Existen propiedades configuradas a nivel Empresa y Categoria al mismo tiempo'
INSERT INTO NominaG4ErroresCFG (Estacion,  Rama, Cuenta, Propiedad, Valor, Descripcion)
SELECT                     @Estacion, NULL, NULL,   Propiedad, NULL,  @OkRef
FROM PersonalProp
WHERE  NivelEmpresa = 1 AND NivelCategoria = 1
END
IF Exists (SELECT * FROM PersonalProp WHERE NivelEmpresa = 1 AND NivelPuesto = 1)
BEGIN
SELECT @OK = 1, @OkRef = 'Existen propiedades configuradas a nivel Empresa y Puesto al mismo tiempo'
INSERT INTO NominaG4ErroresCFG (Estacion,  Rama, Cuenta, Propiedad, Valor, Descripcion)
SELECT                     @Estacion, NULL, NULL,   Propiedad, NULL,  @OkRef
FROM PersonalProp
WHERE NivelEmpresa = 1 AND NivelPuesto = 1
END
IF Exists (SELECT * FROM PersonalProp WHERE NivelSucursal = 1 AND NivelCategoria = 1)
BEGIN
SELECT @OK = 1, @OkRef = 'Existen propiedades configuradas a nivel Sucursal y Categoria al mismo tiempo'
INSERT INTO NominaG4ErroresCFG (Estacion,  Rama, Cuenta, Propiedad, Valor, Descripcion)
SELECT                     @Estacion, NULL, NULL,   Propiedad, NULL,  @OkRef
FROM PersonalProp
WHERE NivelSucursal = 1 AND NivelCategoria = 1
END
IF Exists (SELECT * FROM PersonalProp WHERE NivelSucursal = 1 AND NivelPuesto = 1)
BEGIN
SELECT @OK = 1, @OkRef = 'Existen propiedades configuradas a nivel Sucursal y Puesto al mismo tiempo'
INSERT INTO NominaG4ErroresCFG (Estacion,  Rama, Cuenta, Propiedad, Valor, Descripcion)
SELECT                     @Estacion, NULL, NULL,   Propiedad, NULL,  @OkRef
FROM PersonalProp
WHERE NivelSucursal = 1 AND NivelPuesto = 1
END
IF Exists (SELECT * FROM PersonalProp WHERE NivelCategoria = 1 AND NivelPuesto = 1)
BEGIN
SELECT @OK = 1, @OkRef = 'Existen propiedades configuradas a nivel Categoria y Puesto al mismo tiempo'
INSERT INTO NominaG4ErroresCFG (Estacion,  Rama, Cuenta, Propiedad, Valor, Descripcion)
SELECT                     @Estacion, NULL, NULL,   Propiedad, NULL,  @OkRef
FROM PersonalProp
WHERE NivelCategoria = 1 AND NivelPuesto = 1
END
IF Exists(SELECT * FROM NominaConceptoEx n LEFT JOIN PersonalPropValor p ON n.Concepto = p.Propiedad WHERE n.Obligatorio = 1 AND n.Objeto = 'Nomina.Empresa.Propiedad' AND p.Rama = 'EMP' AND p.Cuenta = @Empresa AND Valor = NULL)
BEGIN
SELECT @OK = 1, @OkRef = 'Existen propiedades de la empresa que estan vacias'
INSERT INTO NominaG4ErroresCFG (Estacion,  Rama,  Cuenta,   Propiedad,   Valor, Descripcion)
SELECT                     @Estacion, 'EMP', @Empresa, p.Propiedad, NULL,  @OkRef
FROM NominaConceptoEx n
LEFT JOIN PersonalPropValor p ON n.Concepto = p.Propiedad
WHERE n.Obligatorio = 1 AND n.Objeto = 'Nomina.Empresa.Propiedad' AND p.Rama = 'EMP' AND p.Cuenta = @Empresa AND Valor = NULL
END
IF Exists(SELECT * FROM Personal p JOIN ListaSt l ON l.Clave = p.Personal WHERE Estacion = @Estacion AND ISNULL(FechaAlta, '') = '')
BEGIN
SELECT @OK = 1, @OkRef = 'Existen Empleados con el dato Fecha de Alta vacio'
INSERT INTO NominaG4ErroresCFG (Estacion,  Rama,  Cuenta,     Propiedad,   Valor, Descripcion)
SELECT                     @Estacion, 'PER', p.Personal, 'FechaAlta', NULL,  @OkRef
FROM Personal p JOIN ListaSt l ON l.Clave = p.Personal WHERE Estacion = @Estacion AND ISNULL(FechaAlta, '') = ''
END
IF Exists(SELECT * FROM Personal p JOIN ListaSt l ON l.Clave = p.Personal WHERE Estacion = @Estacion AND ISNULL(FechaAntiguedad, '') = '')
BEGIN
SELECT @OK = 1, @OkRef = 'Existen Empleados con el dato Fecha Antigüedad vacio'
INSERT INTO NominaG4ErroresCFG (Estacion,  Rama,  Cuenta,     Propiedad,          Valor, Descripcion)
SELECT                     @Estacion, 'PER', p.Personal, 'FechaAntiguedad',  NULL,  @OkRef
FROM Personal p JOIN ListaSt l ON l.Clave = p.Personal WHERE Estacion = @Estacion AND ISNULL(FechaAntiguedad, '') = ''
END
IF Exists(SELECT * FROM Personal p JOIN ListaSt l ON l.Clave = p.Personal WHERE Estacion = @Estacion AND ISNULL(p.SueldoDiario*30, 0.00) = 0.00)
BEGIN
SELECT @OK = 1, @OkRef = 'Existen Empleados con el dato Sueldo Diario vacio'
INSERT INTO NominaG4ErroresCFG (Estacion,  Rama,  Cuenta,     Propiedad, Valor, Descripcion)
SELECT                     @Estacion, 'PER', p.Personal, 'Sueldo',  NULL,  @OkRef
FROM Personal p JOIN ListaSt l ON l.Clave = p.Personal WHERE Estacion = @Estacion AND ISNULL(p.SueldoDiario*30, 0.00) = 0.00
END
IF Exists(SELECT * FROM Personal p JOIN ListaSt l ON l.Clave = p.Personal WHERE Estacion = @Estacion AND ISNULL(PeriodoTipo, '') = '')
BEGIN
SELECT @OK = 1, @OkRef = 'Existen Empleados con el dato Tipo Periodo vacio'
INSERT INTO NominaG4ErroresCFG (Estacion,  Rama,  Cuenta,     Propiedad,       Valor, Descripcion)
SELECT                     @Estacion, 'PER', p.Personal, 'Tipo Periodo',  NULL,  @OkRef
FROM Personal p JOIN ListaSt l ON l.Clave = p.Personal WHERE Estacion = @Estacion AND ISNULL(PeriodoTipo, '') = ''
END
IF Exists(SELECT * FROM Personal p JOIN ListaSt l ON l.Clave = p.Personal WHERE Estacion = @Estacion AND ISNULL(Sindicato, '') = '')
BEGIN
SELECT @OK = 1, @OkRef = 'Existen Empleados con el dato Sindicato vacio'
INSERT INTO NominaG4ErroresCFG (Estacion,  Rama,  Cuenta,     Propiedad,   Valor, Descripcion)
SELECT                     @Estacion, 'PER', p.Personal, 'Sindicato', NULL,  @OkRef
FROM Personal p JOIN ListaSt l ON l.Clave = p.Personal WHERE Estacion = @Estacion AND ISNULL(Sindicato, '') = ''
END
IF @Ok <> NULL
SELECT @OkRef = 'Existen errores, revisar Log.'
RETURN
END

