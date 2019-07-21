SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spTMAAplicar
@ID			int,
@Accion		char(20),
@Empresa		char(5),
@Tarima		varchar(20),
@Almacen		varchar(10),
@PosicionAnterior	varchar(10),
@PosicionNueva	varchar(10),
@AplicaMovTipo	varchar(20),
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@IDAplica int
IF @Accion <> 'CANCELAR'
BEGIN
SELECT @IDAplica = NULL
SELECT @IDAplica = MIN(e.ID)
FROM TMA e
JOIN MovTipo mt ON mt.Modulo = 'TMA' AND mt.Mov = e.Mov AND mt.Clave = @AplicaMovTipo
JOIN TMAD d ON d.ID = e.ID
WHERE e.Empresa = @Empresa AND e.Estatus = 'PENDIENTE'
AND d.Tarima = @Tarima AND d.Almacen = @Almacen AND d.Posicion = @PosicionAnterior AND d.PosicionDestino = @PosicionNueva AND d.EstaPendiente = 1
IF @IDAplica IS NOT NULL
BEGIN
UPDATE TMAD
SET EstaPendiente = 0
WHERE ID = @IDAplica AND Tarima = @Tarima AND Almacen = @Almacen AND Posicion = @PosicionAnterior AND PosicionDestino = @PosicionNueva AND EstaPendiente = 1
IF NOT EXISTS(SELECT * FROM TMAD WHERE ID = @IDAplica AND EstaPendiente = 1)
UPDATE TMA SET Estatus = 'CONCLUIDO' WHERE ID = @IDAplica
END
END ELSE
BEGIN
SELECT @IDAplica = NULL
SELECT @IDAplica = MAX(e.ID)
FROM TMA e
JOIN MovTipo mt ON mt.Modulo = 'TMA' AND mt.Mov = e.Mov AND mt.Clave = @AplicaMovTipo
JOIN TMAD d ON d.ID = e.ID
WHERE e.Empresa = @Empresa AND e.Estatus IN ('PENDIENTE', 'CONCLUIDO')
AND d.Tarima = @Tarima AND d.Almacen = @Almacen AND d.Posicion = @PosicionAnterior AND d.PosicionDestino = @PosicionNueva AND d.EstaPendiente = 0
IF @IDAplica IS NOT NULL
BEGIN
UPDATE TMAD
SET EstaPendiente = 1
WHERE ID = @IDAplica AND Tarima = @Tarima AND Almacen = @Almacen AND Posicion = @PosicionAnterior AND PosicionDestino = @PosicionNueva AND EstaPendiente = 0
IF EXISTS(SELECT * FROM TMAD WHERE ID = @IDAplica AND EstaPendiente = 1)
UPDATE TMA SET Estatus = 'PENDIENTE' WHERE ID = @IDAplica
END
END
RETURN
END

