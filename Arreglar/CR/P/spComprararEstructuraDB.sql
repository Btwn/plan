SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spComprararEstructuraDB
@Estacion		int

AS BEGIN
DECLARE
@SQL			nvarchar(max),
@Servidor1		varchar(100),
@BaseDatos1		varchar(100),
@Servidor2		varchar(100),
@BaseDatos2		varchar(100)
SELECT @Servidor1 = InfoServidor1,
@Servidor2 = InfoServidor2,
@BaseDatos1 = InfoBaseDatos1,
@BaseDatos2 = InfoBaseDatos2
FROM RepParam
WHERE Estacion = @Estacion
DELETE SincroCamposBD1 WHERE Estacion = @Estacion
DELETE SincroCamposBD2 WHERE Estacion = @Estacion
DELETE SincroComparacion WHERE Estacion = @Estacion
SELECT @SQL = N'
INSERT SincroCamposBD1 (Estacion,    Tabla,   Campo,   Orden,   TipoDatos,   Ancho,   [Precision],   Escala,   AceptaNulos,   EsIdentity,   EsCalculado,   Collation,   Tipo)
SELECT @Estacion, c.Tabla, c.Campo, c.Orden, c.TipoDatos, c.Ancho, c.[Precision], c.Escala, c.AceptaNulos, c.EsIdentity, c.EsCalculado, c.Collation, c.Tipo
FROM ' + @Servidor1 + '.' + @BaseDatos1 + '.information_schema.tables t JOIN ' + @Servidor1 + '.' + @BaseDatos1 + '.dbo.SysCampoExt c
ON RTRIM(LTRIM(c.Tabla)) = RTRIM(LTRIM(Table_Name))
WHERE Table_Catalog = ''' + @BaseDatos1 + '''' + ' ORDER BY Tabla'
EXEC sp_executesql @SQL, N'@Estacion int, @BaseDatos1 varchar(100)', @Estacion = @Estacion, @BaseDatos1 = @BaseDatos1
SELECT @SQL = N'
INSERT SincroCamposBD2 (Estacion,    Tabla,   Campo,   Orden,   TipoDatos,   Ancho,   [Precision],   Escala,   AceptaNulos,   EsIdentity,   EsCalculado,   Collation,   Tipo)
SELECT @Estacion, c.Tabla, c.Campo, c.Orden, c.TipoDatos, c.Ancho, c.[Precision], c.Escala, c.AceptaNulos, c.EsIdentity, c.EsCalculado, c.Collation, c.Tipo
FROM ' + @Servidor2 + '.' + @BaseDatos2 + '.information_schema.tables t JOIN ' + @Servidor2 + '.' + @BaseDatos2 + '.dbo.SysCampoExt c
ON RTRIM(LTRIM(c.Tabla)) = RTRIM(LTRIM(Table_Name))
WHERE Table_Catalog = ''' + @BaseDatos2 + '''' + ' ORDER BY Tabla'
EXEC sp_executesql @SQL, N'@Estacion int, @BaseDatos2 varchar(100)', @Estacion = @Estacion, @BaseDatos2 = @BaseDatos2
INSERT SincroComparacion (Estacion, TablaNombre,               Campo,                     BD1Orden, BD2Orden, BD1TipoDatos, BD2TipoDatos, BD1Ancho, BD2Ancho, BD1Precision,   BD2Precision,   BD1Escala, BD2Escala, BD1AceptaNulos, BD2AceptaNulos, BD1EsIdentity, BD2EsIdentity, BD1EsCalculado, BD2EsCalculado, BD1Collation, BD2Collation, BD1Tipo, BD2Tipo)
SELECT @Estacion, ISNULL(c1.Tabla,c2.Tabla), ISNULL(c1.Campo,c2.Campo), c1.Orden, c2.Orden, c1.TipoDatos, c2.TipoDatos, c1.Ancho, c2.Ancho, c1.[Precision], c2.[Precision], c1.Escala, c2.Escala, c1.AceptaNulos, c2.AceptaNulos, c1.EsIdentity, c2.EsIdentity, c1.EsCalculado, c2.EsCalculado, c1.Collation, c2.Collation, c1.Tipo, c2.Tipo
FROM SincroCamposBD1 c1 LEFT OUTER JOIN SincroCamposBD2 c2
ON c2.Tabla = c1.Tabla AND c2.Campo = c1.Campo AND c1.Estacion = @Estacion AND c2.Estacion = @Estacion
WHERE c1.TipoDatos <> c2.TipoDatos
OR c1.Ancho <> c2.Ancho
OR c1.[Precision] <> c2.[Precision]
OR c1.TipoDatos <> c2.TipoDatos
OR c1.Escala <> c2.Escala
OR c1.AceptaNulos <> c2.AceptaNulos
OR c1.EsIdentity <> c2.EsIdentity
OR c1.Collation <> c2.Collation
OR c1.Tipo <> c2.Tipo
INSERT SincroComparacion (Estacion, TablaNombre,               Campo,                     BD1Orden, BD2Orden, BD1TipoDatos, BD2TipoDatos, BD1Ancho, BD2Ancho, BD1Precision,   BD2Precision,   BD1Escala, BD2Escala, BD1AceptaNulos, BD2AceptaNulos, BD1EsIdentity, BD2EsIdentity, BD1EsCalculado, BD2EsCalculado, BD1Collation, BD2Collation, BD1Tipo, BD2Tipo)
SELECT @Estacion, ISNULL(c1.Tabla,c2.Tabla), ISNULL(c1.Campo,c2.Campo), c1.Orden, c2.Orden, c1.TipoDatos, c2.TipoDatos, c1.Ancho, c2.Ancho, c1.[Precision], c2.[Precision], c1.Escala, c2.Escala, c1.AceptaNulos, c2.AceptaNulos, c1.EsIdentity, c2.EsIdentity, c1.EsCalculado, c2.EsCalculado, c1.Collation, c2.Collation, c1.Tipo, c2.Tipo
FROM SincroCamposBD1 c1 RIGHT OUTER JOIN SincroCamposBD2 c2
ON c2.Tabla = c1.Tabla AND c2.Campo = c1.Campo AND c1.Estacion = @Estacion AND c2.Estacion = @Estacion
WHERE c1.TipoDatos <> c2.TipoDatos
OR c1.Ancho <> c2.Ancho
OR c1.[Precision] <> c2.[Precision]
OR c1.TipoDatos <> c2.TipoDatos
OR c1.Escala <> c2.Escala
OR c1.AceptaNulos <> c2.AceptaNulos
OR c1.EsIdentity <> c2.EsIdentity
OR c1.Collation <> c2.Collation
OR c1.Tipo <> c2.Tipo
/*
SELECT Estacion, Tabla, Campo, BD1Orden, BD2Orden, BD1TipoDatos, BD2TipoDatos, BD1Ancho, BD2Ancho, BD1Precision, BD2Precision, BD1Escala, BD2Escala, BD1AceptaNulos, BD2AceptaNulos, BD1EsIdentity, BD2EsIdentity, BD1EsCalculado, BD2EsCalculado, BD1Collation, BD2Collation, BD1Tipo, BD2Tipo
FROM SincroComparacion
WHERE Estacion = @Estacion
GROUP BY Estacion, Tabla, Campo, BD1Orden, BD2Orden, BD1TipoDatos, BD2TipoDatos, BD1Ancho, BD2Ancho, BD1Precision, BD2Precision, BD1Escala, BD2Escala, BD1AceptaNulos, BD2AceptaNulos, BD1EsIdentity, BD2EsIdentity, BD1EsCalculado, BD2EsCalculado, BD1Collation, BD2Collation, BD1Tipo, BD2Tipo
*/
END

