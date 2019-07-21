SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spEmbarqueAsignar
@Sucursal		int,
@Estacion		int,
@ID			int,
@BorrarAnterior	bit = 0

AS BEGIN
DECLARE
@ListaID		int,
@Modulo			char(10),
@Paquetes		int,
@Observaciones	varchar(100),
@Orden 			int,
@MovPorcentaje	float,
@IDVtas         int
IF NOT EXISTS(SELECT * FROM Embarque WHERE ID = @ID)
RETURN
BEGIN TRANSACTION
IF @BorrarAnterior = 1
BEGIN
DELETE EmbarqueD WHERE ID = @ID
DELETE EmbarqueDArt WHERE ID = @ID
DELETE GuiaEmbarqueD WHERE Modulo = 'EMB' AND ID = @ID
END
SELECT @Orden = ISNULL(MAX(Orden), 0) FROM EmbarqueD WHERE ID = @ID AND EmbarqueMov NOT IN (SELECT ID FROM ListaID WITH(NOLOCK) WHERE Estacion = @Estacion)
UPDATE EmbarqueMov
 WITH(ROWLOCK) SET AsignadoID = @ID
WHERE ID IN (SELECT ID FROM ListaID WITH(NOLOCK) WHERE Estacion = @Estacion)
AND AsignadoID IS NULL
DECLARE crLista CURSOR
FOR SELECT l.ID, e.Paquetes, e.Modulo, e.ObservacionesEmbarque
FROM ListaID l, EmbarqueMov e
WITH(NOLOCK) WHERE l.Estacion = @Estacion AND l.ID = e.ID AND AsignadoID = @ID
OPEN crLista
FETCH NEXT FROM crLista  INTO @ListaID, @Paquetes, @Modulo, @Observaciones
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Orden = @Orden + 1
IF @Modulo = 'VTAS'
BEGIN
/*
INSERT EmbarqueDArt (Sucursal, ID, EmbarqueMov, Modulo, ModuloID, Renglon, RenglonSub, CantidadTotal, ImporteTotal, Cantidad)
SELECT @Sucursal, @ID, @ListaID, em.Modulo, em.ModuloID, d.Renglon, d.RenglonSub, d.CantidadNeta, d.ImporteTotal, d.CantidadNeta-ISNULL(d.CantidadEmbarcada, 0)
FROM EmbarqueMov em, VentaTCalc d
WITH(NOLOCK) WHERE em.ID = @ListaID AND em.Modulo = @Modulo
AND em.ModuloID = d.ID
*/
SELECT @IDVtas = (SELECT ModuloID FROM EmbarqueMov WITH(NOLOCK) WHERE ID = @ListaID AND Modulo = @Modulo)
SELECT d.ID, d.Renglon, d.RenglonSub, d.CantidadNeta, d.ImporteTotal, d.CantidadNeta-ISNULL(d.CantidadEmbarcada, 0) CantidadNeta1, Tarima 
INTO #VentaTCalc
FROM VentaTCalc d
WITH(NOLOCK) WHERE d.ID = @IDVtas
INSERT EmbarqueDArt (Sucursal, ID, EmbarqueMov, Modulo, ModuloID, Renglon, RenglonSub, CantidadTotal, ImporteTotal, Cantidad, Tarima) 
SELECT @Sucursal, @ID, @ListaID, @Modulo, d.ID, d.Renglon, d.RenglonSub, d.CantidadNeta, d.ImporteTotal, d.CantidadNeta1/*-ISNULL(d.CantidadEmbarcada, 0)*/, d.Tarima 
FROM #VentaTCalc d
DROP TABLE #VentaTCalc
END
ELSE
IF @Modulo = 'COMS'
BEGIN
INSERT EmbarqueDArt (Sucursal, ID, EmbarqueMov, Modulo, ModuloID, Renglon, RenglonSub, CantidadTotal, ImporteTotal, Cantidad, Tarima) 
SELECT @Sucursal, @ID, @ListaID, em.Modulo, em.ModuloID, d.Renglon, d.RenglonSub, d.CantidadNeta, d.ImporteTotal, d.CantidadNeta-ISNULL(d.CantidadEmbarcada, 0), d.Tarima 
FROM EmbarqueMov em, CompraTCalc d
WITH(NOLOCK) WHERE em.ID = @ListaID AND em.Modulo = @Modulo
AND em.ModuloID = d.ID
END
SELECT @MovPorcentaje = (SUM(ISNULL(Cantidad, 0)*ImporteTotal)/NULLIF(SUM(ISNULL(CantidadTotal, 0)*ImporteTotal), 0)) * 100
FROM EmbarqueDArt
WITH(NOLOCK) WHERE ID = @ID AND EmbarqueMov = @ListaID
INSERT EmbarqueD (Sucursal, ID, EmbarqueMov, MovPorcentaje, Orden, Paquetes, Observaciones)
VALUES (@Sucursal, @ID, @ListaID, @MovPorcentaje, @Orden, @Paquetes, @Observaciones)
END
FETCH NEXT FROM crLista  INTO @ListaID, @Paquetes, @Modulo, @Observaciones
END 
CLOSE crLista
DEALLOCATE crLista
UPDATE EmbarqueMov
 WITH(ROWLOCK) SET AsignadoID = NULL
WHERE AsignadoID = @ID AND ID NOT IN (SELECT EmbarqueMov FROM EmbarqueD WITH(NOLOCK) WHERE ID = @ID)
INSERT INTO GuiaEmbarqueD (Sucursal, Modulo, ID, Guia)
SELECT DISTINCT @Sucursal, 'EMB', @ID, g.Guia
FROM GuiaEmbarqueD g, EmbarqueMov e, ListaID l
WITH(NOLOCK) WHERE l.Estacion = @Estacion AND l.ID = e.ID
AND g.Modulo = e.Modulo AND g.ID = e.ModuloID
DELETE ListaID WHERE Estacion = @Estacion
COMMIT TRANSACTION
RETURN
END

