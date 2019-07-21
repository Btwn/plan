SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDistAlmacenesDestino (
@Empresa           varchar(5)
)

AS
BEGIN
DECLARE @TablaAlm table(
ID                    int IDENTITY(1,1),
Almacen               varchar(10)   NULL,
Nombre                varchar(100)   NULL
)
DECLARE @TablaRet table(
Clave                 varchar(10),
Nombre                varchar(100)
)
INSERT INTO @TablaAlm (Almacen,Nombre)
SELECT a.Almacen,a.Nombre
FROM AlmDist a
JOIN Alm b ON (a.Almacen = b.Almacen)
WHERE a.Empresa = @Empresa
AND a.Distribuir = 1
AND a.EsDestino = 1
AND b.Estatus = 'ALTA'
ORDER BY a.Nombre
INSERT INTO @TablaRet (Clave,Nombre)
SELECT UPPER(LTRIM(RTRIM(ISNULL(Almacen,'')))), UPPER(LTRIM(RTRIM(ISNULL(Nombre,''))))
FROM @TablaAlm
ORDER BY ID
SELECT Clave, Nombre FROM @TablaRet
END

