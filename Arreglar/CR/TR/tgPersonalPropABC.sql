SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgPersonalPropABC ON PersonalProp

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@PropiedadI  	varchar(50),
@NivelEmpresaI	bit,
@NivelSucursalI	bit,
@NivelPuestoI	bit,
@NivelCategoriaI	bit,
@NivelPersonalI	bit,
@PropiedadD		varchar(50),
@porOmision		varchar(50)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @PropiedadI = Propiedad,
@NivelEmpresaI = ISNULL(NivelEmpresa, 0),
@NivelSucursalI = ISNULL(NivelSucursal, 0),
@NivelPuestoI = ISNULL(NivelPuesto, 0),
@NivelCategoriaI = ISNULL(NivelCategoria, 0),
@NivelPersonalI = ISNULL(NivelPersonal, 0),
@porOmision = NULLIF(RTRIM(porOmision), '') FROM Inserted
SELECT @PropiedadD = Propiedad FROM Deleted
IF EXISTS (SELECT Pais FROM PersonalPropPais WHERE Pais = 'México')
UPDATE PersonalPropPais SET Pais = 'Mexico'
IF EXISTS (SELECT Pais FROM Empresa WHERE Pais = 'México')
UPDATE Empresa SET Pais = 'Mexico'
IF EXISTS (SELECT Pais FROM Sucursal WHERE Pais = 'México')
UPDATE Sucursal SET Pais = 'Mexico'
IF EXISTS (SELECT Pais FROM Personal WHERE Pais = 'México')
UPDATE Personal SET Pais = 'Mexico'
IF @PropiedadI IS NULL
BEGIN
DELETE PersonalPropValor WHERE Propiedad = @PropiedadD
DELETE PersonalPropPais  WHERE Propiedad = @PropiedadD
END ELSE BEGIN
IF @PropiedadD IS NULL
INSERT PersonalPropPais (Propiedad, Pais) VALUES (@PropiedadI, 'Mexico')
ELSE
UPDATE PersonalPropPais SET Propiedad = @PropiedadI WHERE Propiedad = @PropiedadD
IF @PropiedadD IS NOT NULL AND @PropiedadI <> @PropiedadD
UPDATE PersonalPropValor SET Propiedad = @PropiedadI WHERE Propiedad = @PropiedadD
IF @NivelEmpresaI = 0
DELETE PersonalPropValor WHERE Propiedad = @PropiedadI AND Rama = 'EMP'
ELSE
INSERT PersonalPropValor (
Propiedad, Valor, Rama, Cuenta)
SELECT @PropiedadI, @porOmision, 'EMP', e.Empresa
FROM Empresa e
JOIN PersonalPropPais pp ON pp.Propiedad = @PropiedadI AND pp.Pais = e.Pais
WHERE e.Empresa NOT IN (SELECT v.Cuenta FROM PersonalPropValor v WHERE v.Rama = 'EMP' AND v.Propiedad = @PropiedadI)
IF @NivelSucursalI = 0
DELETE PersonalPropValor WHERE Propiedad = @PropiedadI AND Rama = 'SUC'
ELSE
INSERT PersonalPropValor (Propiedad, Valor, Rama, Cuenta)
SELECT @PropiedadI, @porOmision, 'SUC', s.Sucursal
FROM Sucursal s
JOIN PersonalPropPais pp ON pp.Propiedad = @PropiedadI AND pp.Pais = s.Pais
WHERE s.Sucursal NOT IN (SELECT CONVERT(int, v.Cuenta) FROM PersonalPropValor v WHERE v.Rama = 'SUC' AND v.Propiedad = @PropiedadI)
IF @NivelPuestoI = 0
DELETE PersonalPropValor WHERE Propiedad = @PropiedadI AND Rama = 'PUE'
ELSE
INSERT PersonalPropValor (Propiedad, Valor, Rama, Cuenta) SELECT @PropiedadI, @porOmision, 'PUE', Puesto FROM Puesto WHERE Puesto NOT IN (SELECT Cuenta FROM PersonalPropValor WHERE Rama = 'PUE' AND Propiedad = @PropiedadI)
IF @NivelCategoriaI = 0
DELETE PersonalPropValor WHERE Propiedad = @PropiedadI AND Rama = 'CAT'
ELSE
INSERT PersonalPropValor (Propiedad, Valor, Rama, Cuenta) SELECT @PropiedadI, @porOmision, 'CAT', Categoria FROM PersonalCat WHERE Categoria NOT IN (SELECT Cuenta FROM PersonalPropValor WHERE Rama = 'CAT' AND Propiedad = @PropiedadI)
IF @NivelPersonalI = 0
DELETE PersonalPropValor WHERE Propiedad = @PropiedadI AND Rama = 'PER'
ELSE
INSERT PersonalPropValor (
Propiedad,  Valor,        Rama,  Cuenta)
SELECT @PropiedadI, @porOmision, 'PER', p.Personal
FROM Personal p
JOIN Empresa e ON e.Empresa = p.Empresa
JOIN PersonalPropPais pp ON pp.Propiedad = @PropiedadI AND pp.Pais = e.Pais
WHERE p.Personal NOT IN (SELECT v.Cuenta FROM PersonalPropValor v WHERE v.Rama = 'PER' AND v.Propiedad = @PropiedadI)
END
END

