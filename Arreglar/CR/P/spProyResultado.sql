SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spProyResultado
@Proyecto	varchar(50)

AS BEGIN
DECLARE
@Modulo		varchar(5),
@Mov		varchar(20),
@Tipo		varchar(20),
@Factor		float,
@ProyectoOriginal	varchar(50)
DELETE ProyResultado WHERE Proyecto = @Proyecto
SELECT @ProyectoOriginal = dbo.fnProyectoOriginal(@Proyecto)
DECLARE crCfgMovProy CURSOR LOCAL FOR
SELECT Modulo, Mov, Tipo, Factor
FROM CfgMovProy
OPEN crCfgMovProy
FETCH NEXT FROM crCfgMovProy INTO @Modulo, @Mov, @Tipo, @Factor
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Modulo = 'VTAS'
INSERT ProyResultado (
Proyecto,  Empresa, Modulo,  ModuloID, Mov,  MovID, FechaEmision, Tipo,  Costo,                         Venta)
SELECT @Proyecto, Empresa, @Modulo, ID,       @Mov, MovID, FechaEmision, @Tipo, CostoTotal*TipoCambio*@Factor, Importe*TipoCambio*@Factor
FROM Venta
WHERE Mov = @Mov AND Proyecto = @Proyecto AND Proyecto LIKE @ProyectoOriginal+'%' AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
ELSE
IF @Modulo = 'INV'
INSERT ProyResultado (
Proyecto,  Empresa, Modulo,  ModuloID, Mov,  MovID, FechaEmision, Tipo,  Costo)
SELECT @Proyecto, Empresa, @Modulo, ID,       @Mov, MovID, FechaEmision, @Tipo, Importe*TipoCambio*@Factor
FROM Inv
WHERE Mov = @Mov AND Proyecto = @Proyecto AND Proyecto LIKE @ProyectoOriginal+'%' AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
ELSE
IF @Modulo = 'COMS'
INSERT ProyResultado (
Proyecto,  Empresa, Modulo,  ModuloID, Mov,  MovID, FechaEmision, Tipo,  Costo)
SELECT @Proyecto, Empresa, @Modulo, ID,       @Mov, MovID, FechaEmision, @Tipo, Importe*TipoCambio*@Factor
FROM Compra
WHERE Mov = @Mov AND Proyecto = @Proyecto AND Proyecto LIKE @ProyectoOriginal+'%' AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
ELSE
IF @Modulo = 'GAS'
INSERT ProyResultado (
Proyecto,  Empresa,   Modulo,  ModuloID, Mov,  MovID,   FechaEmision,   Tipo,  Gasto)
SELECT @Proyecto, e.Empresa, @Modulo, e.ID,     @Mov, e.MovID, e.FechaEmision, @Tipo, SUM(d.Importe)*e.TipoCambio*@Factor
FROM Gasto e
JOIN GastoD d ON d.ID = e.ID
WHERE e.Mov = @Mov AND d.Proyecto = @Proyecto AND d.Proyecto LIKE @ProyectoOriginal+'%' AND e.Estatus IN ('PENDIENTE', 'CONCLUIDO')
GROUP BY e.ID, e.Mov, e.MovID, e.FechaEmision, e.Empresa, e.TipoCambio
ELSE
IF @Modulo = 'ASIS'
INSERT ProyResultado (
Proyecto,  Empresa,   Modulo,  ModuloID, Mov,  MovID,   FechaEmision,   Tipo,  Costo)
SELECT @Proyecto, e.Empresa, @Modulo, e.ID,     @Mov, e.MovID, e.FechaEmision, @Tipo, SUM(d.Costo*d.Cantidad)/* *e.TipoCambio*/*@Factor
FROM Asiste e
JOIN AsisteD d ON d.ID = e.ID
WHERE e.Mov = @Mov AND d.Proyecto = @Proyecto AND d.Proyecto LIKE @ProyectoOriginal+'%' AND e.Estatus IN ('PENDIENTE', 'CONCLUIDO')
GROUP BY e.ID, e.Mov, e.MovID, e.FechaEmision, e.Empresa, e.TipoCambio
ELSE
IF @Modulo = 'CXC'
INSERT ProyResultado (
Proyecto,  Empresa, Modulo,  ModuloID, Mov,  MovID, FechaEmision, Tipo,  Ingresos)
SELECT @Proyecto, Empresa, @Modulo, ID,       @Mov, MovID, FechaEmision, @Tipo, Importe*TipoCambio*@Factor
FROM Cxc
WHERE Mov = @Mov AND Proyecto = @Proyecto AND Proyecto LIKE @ProyectoOriginal+'%' AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
ELSE
IF @Modulo = 'CXP'
INSERT ProyResultado (
Proyecto,  Empresa, Modulo,  ModuloID, Mov,  MovID, FechaEmision, Tipo,  Egresos)
SELECT @Proyecto, Empresa, @Modulo, ID,       @Mov, MovID, FechaEmision, @Tipo, Importe*TipoCambio*@Factor
FROM Cxp
WHERE Mov = @Mov AND Proyecto = @Proyecto AND Proyecto LIKE @ProyectoOriginal+'%' AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
END
FETCH NEXT FROM crCfgMovProy INTO @Modulo, @Mov, @Tipo, @Factor
END
CLOSE crCfgMovProy
DEALLOCATE crCfgMovProy
UPDATE Proy SET FechaProyResultado = GETDATE() WHERE Proyecto = @Proyecto
END

