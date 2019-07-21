SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDistPorcentaje (
@Empresa              varchar(5),
@AlmacenOrigen        varchar(10)
)

AS
BEGIN
SET @Empresa = LTRIM(RTRIM(ISNULL(@Empresa,'')))
DECLARE @TablaRet table(
ID                    int IDENTITY(1,1),
Almacen               varchar(10)   NULL,
Nombre                varchar(100)  NULL,
Direccion             varchar(100)  NULL,
NombreMostar          varchar(100)  NULL,
Porcentaje            float         NULL
)
INSERT INTO @TablaRet(Almacen,Nombre,Direccion,NombreMostar,Porcentaje)
SELECT LTRIM(RTRIM(ISNULL(a.Almacen,''))),
LTRIM(RTRIM(ISNULL(a.Nombre,''))),
LTRIM(RTRIM(ISNULL(a.Direccion,''))),
LTRIM(RTRIM(ISNULL(d.Nombre,''))),
ISNULL(d.Porcentaje,0)
FROM Alm a
LEFT JOIN AlmDist d ON (a.Almacen = d.Almacen)
WHERE a.Estatus = 'ALTA'
AND d.Empresa = @Empresa
AND d.Distribuir = 1
DELETE FROM @TablaRet WHERE Almacen = @AlmacenOrigen
SELECT
Almacen               AS [Almacen],
Nombre                AS [Nombre],
Direccion             AS [Direccion] ,
NombreMostar          AS [NombreMostar],
Porcentaje            AS [Porcentaje]
FROM @TablaRet
ORDER BY ID
END

