SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMaestroMesImportar

AS
BEGIN
IF NOT EXISTS(SELECT * FROM AlmMes)
INSERT AlmMES
(CodigoAlmacen, RazonSocial,   NombreComercial,  Direccion1,    Direccion2,
Poblacion,     Provincia,     Pais,             CodigoPostal,  Idioma, Sucursal, EstatusIntelIMES)
SELECT Almacen, Nombre, Nombre, RTRIM(ISNULL(Direccion, ''))+' '+RTRIM(ISNULL(DireccionNumero, '')), Colonia,
Poblacion, Estado, Pais, CodigoPostal, Idioma, Sucursal, 0
FROM Alm
WHERE ISNULL(Mes, 0) = 1
IF NOT EXISTS(SELECT * FROM FormaPagoMES)
INSERT INTO FormaPagoMES(FormaPago, Descripcion, TipoDocumento, DiasPrimerVencimiento, DiasEntreVencimientos, EstatusIntelIMES)
SELECT FormaPago, FormaPago, '',            0,                     0, 0
FROM FormaPago
IF NOT EXISTS(SELECT * FROM MonMes)
INSERT INTO MonMes(Moneda, Descripcion, DescripcionAbreviada, NumeroDecimales, EstatusIntelIMES)
SELECT Clave, Moneda, Clave, 2, 0
FROM Mon
IF NOT EXISTS(SELECT * FROM PaisMes)
INSERT PaisMES
(Pais,   Clave,   DescripcionAbreviada, CodPaisIntrastat, DigitosNIF, MiembroCE)
SELECT ISNULL(Pais,'Mexico'), Clave, Clave, Clave, 13, 0
FROM Pais
if not exists(SELECT * FROM UnidadMes)
INSERT UnidadMES (UnidadMedida, Descripcion, EstatusIntelIMES)
SELECT SUBSTRING(Clave, 1, 5), Unidad, 0
FROM Unidad
WHERE NULLIF(RTRIM(Clave), '') is not null
IF NOT EXISTS(SELECT * FROM SucursalMes)
INSERT INTO SucursalMes(Sucursal)
SELECT Sucursal FROM Sucursal s
IF NOT EXISTS(SELECT * FROM ArtFamMes)
INSERT INTO ArtFamMes(Clave, Descripcion, EstatusIntelIMES)
SELECT af.ClaveMES, af.Familia, 0 FROM ArtFam af
IF NOT EXISTS(SELECT * FROM ArtSubFamMes)
INSERT INTO ArtSubFamMes(Clave, Descripcion, EstatusIntelIMES)
SELECT ag.ClaveMES, ag.Grupo, 0 FROM ArtGrupo ag
SELECT 'Proceso Concluido'
RETURN
END

