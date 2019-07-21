SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSAUXArticuloNoDisponibleServicio
(
@Empresa				varchar (5),
@IDOrigen				int,
@Origen					varchar (20),
@OrigenID				varchar (20),
@Articulo				varchar (20),
@ID						int
)
RETURNS @Resultado TABLE
(
Servicio		varchar(20) COLLATE DATABASE_DEFAULT NULL
)

AS BEGIN
INSERT @Resultado
SELECT Servicio
FROM SAUXD
WHERE ID = @IDOrigen
AND Producto = @Articulo
AND Estado IN ('SINAFECTAR', 'CONCLUIDO')
AND Servicio NOT IN(SELECT d.Servicio
FROM SAUXD d JOIN SAUX s
ON d.ID = s.ID
WHERE d.ID <> @ID
AND d.Producto = @Articulo
AND s.Estatus IN ('PENDIENTE', 'CONCLUIDO')
AND s.Origen = @Origen
AND s.OrigenID = @OrigenID
AND s.Empresa = @Empresa
AND d.Servicio IN(SELECT sd.Servicio
FROM SAUX s
JOIN SAUXD sd ON s.ID = sd.ID
JOIN SAUX os  ON s.Origen = os.Mov AND s.OrigenID = os.MovID AND s.Empresa = os.Empresa
JOIN Inv i    ON i.Origen = s.Mov AND i.OrigenID = s.MovID AND s.Empresa = i.Empresa
JOIN InvD d   ON i.ID = d.ID
WHERE os.Mov = @Origen
AND os.MovID = @OrigenID
AND os.Empresa = @Empresa
AND i.Estatus IN ('PENDIENTE', 'CONCLUIDO')
GROUP BY sd.Servicio
)
GROUP BY d.Servicio
)
RETURN
END

