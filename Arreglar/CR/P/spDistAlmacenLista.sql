SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDistAlmacenLista (
@Empresa              varchar(5),
@Origen				bit = 0
)

AS
BEGIN
DECLARE @TablaAlm table(
ID                    int IDENTITY(1,1),
Almacen               varchar(10)   NULL,
Nombre                varchar(100)  NULL,
EsOrigen              bit,
EsDestino             bit
)
DECLARE @TablaRet table(
ID                    int IDENTITY(1,1),
Clave                 varchar(10),
Nombre                varchar(100),
EsOrigen              bit,
EsDestino              bit
)
INSERT INTO @TablaAlm (Almacen,Nombre,EsOrigen,EsDestino)
SELECT a.Almacen,a.Nombre,ISNULL(a.EsOrigen,0),ISNULL(a.EsDestino,0)
FROM AlmDist a
JOIN Alm b ON (a.Almacen = b.Almacen)
WHERE a.Empresa = @Empresa
AND a.Distribuir = 1
AND a.EsOrigen = CASE WHEN @Origen = 0 THEN a.EsOrigen ELSE 1 END
AND b.Estatus = 'ALTA'
ORDER BY a.Nombre
INSERT INTO @TablaRet (Clave,Nombre,EsOrigen,EsDestino)
SELECT UPPER(LTRIM(RTRIM(ISNULL(Almacen,'')))), UPPER(LTRIM(RTRIM(ISNULL(Nombre,'')))),EsOrigen,EsDestino
FROM @TablaAlm
ORDER BY Nombre
SELECT Clave, Nombre FROM @TablaRet WHERE EsOrigen = 1
UNION ALL
SELECT Clave, Nombre FROM @TablaRet WHERE EsOrigen = 0
END

