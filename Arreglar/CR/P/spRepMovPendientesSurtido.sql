SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRepMovPendientesSurtido
@Modulo			varchar(50),
@ID				int

AS BEGIN
DECLARE
@MovCur     varchar(50),
@MovIDCur   varchar(50),
@IDCur      int
CREATE TABLE #PedSurtido(
ID          int,
Mov			varchar(50) NULL,
MovID		varchar(50) NULL,
Estatus     varchar(50) NULL,
Agente    	varchar(50) NULL,
Tarima		varchar(100) NULL,
Cantidad    float NULL,
Hijo        int NULL)
CREATE TABLE #PedSurtidoHijo(
ID          int,
Mov			varchar(50) NULL,
MovID		varchar(50) NULL,
Estatus     varchar(50) NULL,
Agente    	varchar(50) NULL,
Tarima		varchar(100) NULL,
Cantidad    float NULL,
Hijo        int NULL)
CREATE TABLE #PedSurtidoFinal(
ID          int,
Mov			varchar(50) NULL,
MovID		varchar(50) NULL,
Estatus     varchar(50) NULL,
Agente    	varchar(50) NULL,
Tarima		varchar(100) NULL,
Cantidad    float NULL,
Hijo        int NULL)
IF @Modulo='VTAS'
BEGIN
INSERT #PedSurtido
(ID,  Mov,   MovID,   Agente,       Estatus,  Tarima,   Cantidad,           Hijo)
SELECT DISTINCT c.ID, c.Mov, c.MovID, e.Montacarga, CASE WHEN ISNULL(d.ID,0) <> 0 THEN 'PENDIENTE' ELSE c.Estatus END, e.Tarima, e.CantidadPicking, 0
FROM Venta a
JOIN MovFlujo b ON b.OID=a.ID AND b.Cancelado=0
JOIN TMA c ON c.Mov=b.DMov AND c.MovID=b.DMovID
LEFT JOIN WMSSurtidoPendiente d ON a.ID = d.ID AND d.Modulo = 'VTAS'
LEFT OUTER JOIN TMAD e ON e.ID=c.ID
WHERE a.ID=@ID
DECLARE crVtaSurtido CURSOR FOR
SELECT Mov, MovID, ID
FROM #PedSurtido
OPEN crVtaSurtido
FETCH NEXT FROM crVtaSurtido INTO @MovCur, @MovIDCur, @IDCur
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT #PedSurtidoHijo
(ID,    Mov,   MovID,   Agente,       Estatus,  Tarima,   Cantidad,           Hijo)
SELECT @IDCur, c.Mov, c.MovID, d.Montacarga, c.Estatus, d.Tarima, d.CantidadPicking, 1
FROM TMA a
JOIN MovFlujo b ON b.OID=a.ID AND b.Cancelado=0 AND DModulo='TMA' AND OModulo='TMA'
JOIN TMA c ON c.Mov=b.DMov AND c.MovID=b.DMovID
LEFT OUTER JOIN TMAD d ON d.ID=c.ID
WHERE a.ID=@IDCur
FETCH NEXT FROM crVtaSurtido INTO @MovCur, @MovIDCur, @IDCur
END
CLOSE crVtaSurtido
DEALLOCATE crVtaSurtido
END
IF @Modulo='INV'
BEGIN
INSERT #PedSurtido
(ID,  Mov,   MovID,   Agente,       Estatus,  Tarima,   Cantidad,           Hijo)
SELECT DISTINCT c.ID, c.Mov, c.MovID, e.Montacarga, CASE WHEN ISNULL(d.ID,0) <> 0 THEN 'PENDIENTE' ELSE c.Estatus END, e.Tarima, e.CantidadPicking, 0
FROM INV a
JOIN MovFlujo b ON b.OID=a.ID AND b.Cancelado=0
JOIN TMA c ON c.Mov=b.DMov AND c.MovID=b.DMovID
LEFT JOIN WMSSurtidoPendiente d ON a.ID = d.ID AND d.Modulo = 'INV'
LEFT OUTER JOIN TMAD e ON e.ID=c.ID
WHERE a.ID=@ID
DECLARE crVtaSurtido CURSOR FOR
SELECT Mov, MovID, ID
FROM #PedSurtido
OPEN crVtaSurtido
FETCH NEXT FROM crVtaSurtido INTO @MovCur, @MovIDCur, @IDCur
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT #PedSurtidoHijo
(ID,    Mov,   MovID,   Agente,       Estatus,  Tarima,   Cantidad,           Hijo)
SELECT @IDCur, c.Mov, c.MovID, d.Montacarga, c.Estatus, d.Tarima, d.CantidadPicking, 1
FROM TMA a
JOIN MovFlujo b ON b.OID=a.ID AND b.Cancelado=0 AND DModulo='TMA' AND OModulo='TMA'
JOIN TMA c ON c.Mov=b.DMov AND c.MovID=b.DMovID
LEFT OUTER JOIN TMAD d ON d.ID=c.ID
WHERE a.ID=@IDCur
FETCH NEXT FROM crVtaSurtido INTO @MovCur, @MovIDCur, @IDCur
END
CLOSE crVtaSurtido
DEALLOCATE crVtaSurtido
END
IF @Modulo='COMS'
BEGIN
INSERT #PedSurtido
(ID,  Mov,   MovID,   Agente,       Estatus,  Tarima,   Cantidad,           Hijo)
SELECT DISTINCT c.ID, c.Mov, c.MovID, e.Montacarga, CASE WHEN ISNULL(d.ID,0) <> 0 THEN 'PENDIENTE' ELSE c.Estatus END, e.Tarima, e.CantidadPicking, 0
FROM Compra a
JOIN MovFlujo b ON b.OID=a.ID AND b.Cancelado=0
JOIN TMA c ON c.Mov=b.DMov AND c.MovID=b.DMovID
LEFT JOIN WMSSurtidoPendiente d ON a.ID = d.ID AND d.Modulo = 'COMS'
LEFT OUTER JOIN TMAD e ON e.ID=c.ID
WHERE a.ID=@ID
DECLARE crVtaSurtido CURSOR FOR
SELECT Mov, MovID, ID
FROM #PedSurtido
OPEN crVtaSurtido
FETCH NEXT FROM crVtaSurtido INTO @MovCur, @MovIDCur, @IDCur
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT #PedSurtidoHijo
(ID,    Mov,   MovID,   Agente,       Estatus,  Tarima,   Cantidad,           Hijo)
SELECT @IDCur, c.Mov, c.MovID, d.Montacarga, c.Estatus, d.Tarima, d.CantidadPicking, 1
FROM TMA a
JOIN MovFlujo b ON b.OID=a.ID AND b.Cancelado=0 AND DModulo='TMA' AND OModulo='TMA'
JOIN TMA c ON c.Mov=b.DMov AND c.MovID=b.DMovID
LEFT OUTER JOIN TMAD d ON d.ID=c.ID
WHERE a.ID=@IDCur
FETCH NEXT FROM crVtaSurtido INTO @MovCur, @MovIDCur, @IDCur
END
CLOSE crVtaSurtido
DEALLOCATE crVtaSurtido
END
INSERT INTO #PedSurtidoFinal
SELECT a.*
FROM #PedSurtido a
INSERT INTO #PedSurtidoFinal
SELECT a.*
FROM #PedSurtidoHijo a
SELECT DISTINCT a.*, b.Nombre,
Visible = (CASE WHEN EXISTS(SELECT TOP 1 Estatus FROM #PedSurtidoFinal z WHERE z.ID=a.ID AND Estatus IN ('PENDIENTE', 'PROCESAR')) THEN 1 ELSE 0 END)
FROM #PedSurtidoFinal a
LEFT OUTER JOIN Agente b on b.Nombre=a.Agente
ORDER BY ID, Hijo
RETURN
END

