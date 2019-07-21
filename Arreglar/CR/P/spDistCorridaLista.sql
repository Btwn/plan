SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDistCorridaLista (
@Empresa              varchar(5),
@Sucursal             int,
@Usuario              varchar(10),
@Estacion             int
)

AS
BEGIN
DECLARE @Corrida        int
DECLARE @FechaRegistro  datetime
DECLARE @i              int
DECLARE @k              int
DECLARE @TablaRet table(
ID                    int IDENTITY(1,1),
Empresa               varchar(5)   NULL,
Corrida               int          NULL,
Almacen               varchar(10)  NULL,
FechaRegistro         datetime     NULL,
Procesado             bit          NULL
)
SET @Empresa   = LTRIM(RTRIM(ISNULL(@Empresa,'')))
SET @Sucursal  = UPPER(LTRIM(RTRIM(ISNULL(@Sucursal,''))))
SET @Usuario   = UPPER(LTRIM(RTRIM(ISNULL(@Usuario,''))))
SET @Estacion  = ISNULL(@Estacion,1)
INSERT INTO @TablaRet(Empresa,Corrida,Almacen,Procesado)
SELECT Empresa,Corrida,Almacen,Procesado
FROM Distribucion
WHERE Empresa = @Empresa AND Procesado = 0
GROUP BY Empresa,Corrida,Almacen,Procesado
SELECT @k = MAX(ID) FROM @TablaRet
SET @i = 1
WHILE NOT @i > @k
BEGIN
SET @FechaRegistro = NULL
SELECT @Corrida = Corrida FROM @TablaRet WHERE ID = @i
SELECT @FechaRegistro = ISNULL(FechaRegistro,0) FROM Distribucion WHERE Corrida = @Corrida
UPDATE @TablaRet SET FechaRegistro = @FechaRegistro WHERE ID = @i
SET @i = @i + 1
END
SELECT ID,Empresa,Corrida,Almacen,FechaRegistro,Procesado FROM @TablaRet
ORDER BY Corrida
END

