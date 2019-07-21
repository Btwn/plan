SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgSucursalABC ON Sucursal

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@SucursalI		int,
@SucursalD		int,
@PaisI		varchar(50),
@PaisD		varchar(50),
@EnLinea		bit,
@SucursalPrincipal	int,
@Mensaje		varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @SucursalI         = Sucursal,
@PaisI             = Pais,
@EnLinea           = EnLinea,
@SucursalPrincipal = SucursalPrincipal
FROM Inserted
SELECT @SucursalD = Sucursal,
@PaisD = Pais
FROM Deleted
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
IF @SucursalI IS NOT NULL AND @EnLinea = 1 AND @SucursalPrincipal IS NULL AND @SucursalI <> 0
BEGIN
SELECT @Mensaje = Descripcion FROM MensajeLista WHERE Mensaje = 60410
RAISERROR (@Mensaje,16,-1)
RETURN
END
IF @SucursalI = @SucursalD AND @PaisI <> @PaisD
BEGIN
DELETE PersonalPropValor WHERE Rama = 'SUC' AND Cuenta = CONVERT(char, @SucursalI)
INSERT PersonalPropValor (Propiedad, Rama, Cuenta, Valor)
SELECT p.Propiedad, 'SUC', CONVERT(char, @SucursalI), p.porOmision
FROM PersonalProp p
JOIN PersonalPropPais pp ON pp.Propiedad = p.Propiedad AND pp.Pais = @PaisI
WHERE p.NivelSucursal = 1
END
IF @SucursalI = @SucursalD RETURN
IF @SucursalD IS NULL
BEGIN
DELETE PersonalPropValor WHERE Rama = 'SUC' AND Cuenta = CONVERT(char, @SucursalI)
INSERT PersonalPropValor (Propiedad, Rama, Cuenta, Valor)
SELECT p.Propiedad, 'SUC', CONVERT(char, @SucursalI), p.porOmision
FROM PersonalProp p
JOIN PersonalPropPais pp ON pp.Propiedad = p.Propiedad AND pp.Pais = @PaisI
WHERE p.NivelSucursal = 1
END ELSE
IF @SucursalI IS NULL
BEGIN
DELETE PersonalPropValor  WHERE Rama = 'SUC' AND Cuenta = CONVERT(char, @SucursalD)
DELETE SucursalOtrosDatos WHERE Sucursal = @SucursalD
DELETE SucursalBanco      WHERE Sucursal = @SucursalD
END ELSE
IF @SucursalD <> @SucursalI
BEGIN
UPDATE PersonalPropValor  SET Cuenta  = CONVERT(char, @SucursalI) WHERE Rama = 'SUC' AND Cuenta = CONVERT(char, @SucursalD)
UPDATE SucursalOtrosDatos SET Sucursal = @SucursalI WHERE Sucursal = @SucursalD
UPDATE SucursalBanco      SET Sucursal = @SucursalI WHERE Sucursal = @SucursalD
END
END

