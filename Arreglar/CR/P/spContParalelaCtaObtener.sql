SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spContParalelaCtaObtener
@ID			int,
@CuentaD	varchar(20),
@CuentaA	varchar(20),
@Nivel		varchar(10),
@Ok			int				OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS
BEGIN
DELETE ContParalelaD WHERE ID = @ID
CREATE TABLE #Cta(
RID					int				IDENTITY,
Cuenta				varchar(20)		COLLATE DATABASE_DEFAULT NULL,
Rama				varchar(20)		COLLATE DATABASE_DEFAULT NULL,
Descripcion			varchar(100)	COLLATE DATABASE_DEFAULT NULL,
Tipo				varchar(15)		COLLATE DATABASE_DEFAULT NULL,
Categoria			varchar(50)		COLLATE DATABASE_DEFAULT NULL,
Grupo				varchar(50)		COLLATE DATABASE_DEFAULT NULL,
Familia				varchar(50)		COLLATE DATABASE_DEFAULT NULL,
EsAcreedora			bit				NULL,
EsAcumulativa		bit				NULL,
Estatus				varchar(15)		COLLATE DATABASE_DEFAULT NULL,
TieneMovimientos	bit				NULL
)
IF @Nivel = 'AUXILIAR'
INSERT INTO #Cta(
Cuenta, Rama, Descripcion, Tipo, Categoria, Grupo, Familia, EsAcreedora, EsAcumulativa, Estatus, TieneMovimientos)
SELECT Cuenta, Rama, Descripcion, Tipo, Categoria, Grupo, Familia, EsAcreedora, EsAcumulativa, Estatus, TieneMovimientos
FROM Cta
WHERE Cuenta BETWEEN ISNULL(NULLIF(RTRIM(@CuentaD), ''), Cuenta) AND ISNULL(NULLIF(RTRIM(@CuentaA), ''), Cuenta)
AND Tipo IN ('MAYOR', 'SUBCUENTA', 'AUXILIAR')
UNION ALL
SELECT Cuenta, Rama, Descripcion, Tipo, Categoria, Grupo, Familia, EsAcreedora, EsAcumulativa, Estatus, TieneMovimientos
FROM Cta
WHERE Tipo IN ('ESTRUCTURA')
ELSE IF @Nivel = 'SUBCUENTA'
INSERT INTO #Cta(
Cuenta, Rama, Descripcion, Tipo, Categoria, Grupo, Familia, EsAcreedora, EsAcumulativa, Estatus, TieneMovimientos)
SELECT Cuenta, Rama, Descripcion, Tipo, Categoria, Grupo, Familia, EsAcreedora, EsAcumulativa, Estatus, TieneMovimientos
FROM Cta
WHERE Cuenta BETWEEN ISNULL(NULLIF(RTRIM(@CuentaD), ''), Cuenta) AND ISNULL(NULLIF(RTRIM(@CuentaA), ''), Cuenta)
AND Tipo IN ('MAYOR', 'SUBCUENTA')
UNION ALL
SELECT Cuenta, Rama, Descripcion, Tipo, Categoria, Grupo, Familia, EsAcreedora, EsAcumulativa, Estatus, TieneMovimientos
FROM Cta
WHERE Tipo IN ('ESTRUCTURA')
ELSE IF @Nivel = 'MAYOR'
INSERT INTO #Cta(
Cuenta, Rama, Descripcion, Tipo, Categoria, Grupo, Familia, EsAcreedora, EsAcumulativa, Estatus, TieneMovimientos)
SELECT Cuenta, Rama, Descripcion, Tipo, Categoria, Grupo, Familia, EsAcreedora, EsAcumulativa, Estatus, TieneMovimientos
FROM Cta
WHERE Cuenta BETWEEN ISNULL(NULLIF(RTRIM(@CuentaD), ''), Cuenta) AND ISNULL(NULLIF(RTRIM(@CuentaA), ''), Cuenta)
AND Tipo IN ('MAYOR')
UNION ALL
SELECT Cuenta, Rama, Descripcion, Tipo, Categoria, Grupo, Familia, EsAcreedora, EsAcumulativa, Estatus, TieneMovimientos
FROM Cta
WHERE Tipo IN ('ESTRUCTURA')
INSERT INTO ContParalelaD(
ID, Renglon,  Cuenta, Rama, Descripcion, Tipo, Categoria, Grupo, Familia, EsAcreedora, EsAcumulativa, Estatus, TieneMovimientos)
SELECT @ID, RID*2048, Cuenta, Rama, Descripcion, Tipo, Categoria, Grupo, Familia, EsAcreedora, EsAcumulativa, Estatus, TieneMovimientos
FROM #Cta
RETURN
END

