SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDistCorridaDestinos (
@Empresa              varchar(5),
@Sucursal             int,
@Usuario              varchar(10),
@Estacion             int,
@Corrida              int
)

AS
BEGIN
SELECT a.AlmacenDestino Clave, b.Nombre Nombre
FROM Distribucion a, AlmDist b
WHERE a.Empresa = @Empresa AND a.Corrida = @Corrida
AND a.AlmacenDestino = b.Almacen
GROUP BY a.AlmacenDestino, b.Nombre
ORDER BY a.AlmacenDestino, b.Nombre
END

