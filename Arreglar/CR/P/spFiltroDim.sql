SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spFiltroDim
@EstacionTrabajo	int,
@Empresa			VARCHAR(5)

AS BEGIN
SET NOCOUNT ON
DECLARE @Finiquito varchar(100),
@Asimilado varchar(100),
@LISR varchar(100),
@IDC int
DELETE Listast WHERE Estacion =@EstacionTrabajo
IF (SELECT Obligatorio FROM DimCfg WHERE Columna=30 AND Empresa=@Empresa) = 0
BEGIN
INSERT	INTO Listast
(Estacion,			Clave)
SELECT	@EstacionTrabajo,	Columna
FROM	DimCfg
WHERE	Columna BETWEEN 33 AND 50 AND Empresa=@Empresa
END
ELSE
BEGIN
UPDATE	DimCfg	SET Obligatorio = 1
WHERE	Columna	BETWEEN 33 AND 50 AND Empresa=@Empresa
END
IF (SELECT Obligatorio FROM DimCfg WHERE Columna=31 AND Empresa=@Empresa) = 0
BEGIN
INSERT	INTO Listast
(Estacion,			Clave)
SELECT	@EstacionTrabajo,	Columna
FROM	DimCfg
WHERE	Columna BETWEEN 51 AND 57 AND Empresa=@Empresa
END
ELSE
BEGIN
UPDATE	DimCfg	SET Obligatorio = 1
WHERE	Columna	BETWEEN 51 AND 57 AND Empresa=@Empresa
END
IF (SELECT Obligatorio FROM DimCfg WHERE Columna=32 AND Empresa=@Empresa) = 0
BEGIN
INSERT	INTO Listast
(Estacion,			Clave)
SELECT	@EstacionTrabajo,	Columna
FROM	DimCfg
WHERE	Columna BETWEEN 58 AND 134 AND Empresa=@Empresa
END
ELSE
BEGIN
UPDATE	DimCfg SET Obligatorio = 1
WHERE	Columna BETWEEN 58 AND 134  AND Empresa=@Empresa
END
UPDATE	DimCfg SET Obligatorio = 0
FROM	DimCfg c JOIN Listast l ON l.Clave = c.Columna
WHERE	l.Estacion=@EstacionTrabajo AND c.Empresa=@Empresa
RETURN(0)
SET NOCOUNT OFF
END

