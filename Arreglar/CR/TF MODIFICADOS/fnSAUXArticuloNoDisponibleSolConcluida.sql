SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSAUXArticuloNoDisponibleSolConcluida
(
@Empresa				varchar (5),
@Origen					varchar (20),
@OrigenID				varchar (20),
@OrigenSAUX				varchar (20),
@OrigenIDSAUX			varchar (20),
@Cantidad				int
)
RETURNS @Resultado TABLE
(
Articulo		varchar(20) COLLATE DATABASE_DEFAULT NULL
)

AS BEGIN
INSERT @Resultado
SELECT d.Articulo
FROM SAUX s WITH(NOLOCK)
JOIN SAUX os WITH(NOLOCK) ON s.Origen = os.Mov AND s.OrigenID = os.MovID AND s.Empresa = os.Empresa
JOIN Inv i WITH(NOLOCK)  ON i.Origen = s.Mov AND i.OrigenID = s.MovID AND i.Empresa = s.Empresa
JOIN InvD d WITH(NOLOCK) ON i.ID = d.ID
WHERE os.Mov = @Origen
AND os.MovID = @OrigenID
AND os.Empresa = @Empresa
AND i.Estatus IN ('PENDIENTE', 'CONCLUIDO')
GROUP BY d.Articulo
UNION ALL
SELECT d.Articulo
FROM Inv s WITH(NOLOCK)
JOIN InvD d WITH(NOLOCK) ON s.ID = d.ID
WHERE s.Origen = @OrigenSAUX
AND s.OrigenID = @OrigenIDSAUX
AND d.Cantidad = ISNULL(@Cantidad,1)
AND s.Empresa = @Empresa
AND s.Estatus IN ('PENDIENTE', 'CONCLUIDO')
GROUP BY d.Articulo
RETURN
END

