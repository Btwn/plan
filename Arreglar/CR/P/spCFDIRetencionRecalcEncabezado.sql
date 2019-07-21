SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionRecalcEncabezado
@Estacion		int

AS
BEGIN
DECLARE @Modulo		varchar(5),
@ModuloAnt	varchar(5),
@ModuloID		int,
@ModuloIDAnt	int
DELETE CFDIRetencion        WHERE EstacionTrabajo = @Estacion
DELETE CFDIRetencionCalcTmp WHERE EstacionTrabajo = @Estacion
CREATE TABLE #CFDIRetencion(
EstacionTrabajo		int			NULL,
Modulo				varchar(5)	COLLATE DATABASE_DEFAULT NULL,
ModuloID			int			NULL,
Sucursal			int			NULL,
Empresa				varchar(5)	COLLATE DATABASE_DEFAULT NULL,
Proveedor			varchar(10)	COLLATE DATABASE_DEFAULT NULL,
ConceptoSAT			varchar(50)	COLLATE DATABASE_DEFAULT NULL,
PorcentajeDeducible	float		NULL,
FechaEmision		datetime	NULL,
Ejercicio			int			NULL,
Periodo				int			NULL,
Importe				float		NULL,
IVA					float		NULL,
IEPS				float		NULL,
Retencion1			float		NULL,
Retencion2			float		NULL,
)
SELECT @ModuloAnt = ''
WHILE(1=1)
BEGIN
SELECT @Modulo = MIN(Modulo)
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND Modulo > @ModuloAnt
IF @Modulo IS NULL BREAK
SELECT @ModuloAnt = @Modulo
SELECT @ModuloIDAnt = 0
WHILE(1=1)
BEGIN
SELECT @ModuloID = MIN(ModuloID)
FROM CFDIRetencionD
WHERE EstacionTrabajo = @Estacion
AND Modulo = @Modulo
AND ModuloID > @ModuloIDAnt
IF @ModuloID IS NULL BREAK
SELECT @ModuloIDAnt = @ModuloID
IF EXISTS(SELECT *
FROM CFDIRetencionD
WHERE EsRetencion = 1
AND EstacionTrabajo = @Estacion
AND Modulo = @Modulo
AND ModuloID = @ModuloID)
BEGIN
INSERT INTO #CFDIRetencion(
EstacionTrabajo, Modulo, ModuloID, Sucursal, Empresa, Proveedor, ConceptoSAT, PorcentajeDeducible, FechaEmision, Ejercicio, Periodo, Importe, IVA, IEPS, Retencion1,      Retencion2)
SELECT EstacionTrabajo, Modulo, ModuloID, Sucursal, Empresa, Proveedor, ConceptoSAT, PorcentajeDeducible, FechaEmision, Ejercicio, Periodo, Importe, IVA, 0.0,  SUM(Retencion1), SUM(Retencion2)
FROM CFDIRetencionD
WHERE EsRetencion = 1
AND EstacionTrabajo = @Estacion
AND Modulo = @Modulo
AND ModuloID = @ModuloID
GROUP BY EstacionTrabajo, Modulo, ModuloID, Sucursal, Empresa, Proveedor, ConceptoSAT, PorcentajeDeducible, FechaEmision, Ejercicio, Periodo, Importe, IVA, IEPS
UNION ALL
SELECT EstacionTrabajo, Modulo, ModuloID, Sucursal, Empresa, Proveedor, ConceptoSAT, PorcentajeDeducible, FechaEmision, Ejercicio, Periodo, SUM(Importe), SUM(IVA), SUM(IEPS), SUM(Retencion1), SUM(Retencion2)
FROM CFDIRetencionD
WHERE EsComplemento = 1
AND EstacionTrabajo = @Estacion
AND Modulo = @Modulo
AND ModuloID = @ModuloID
GROUP BY EstacionTrabajo, Modulo, ModuloID, Sucursal, Empresa, Proveedor, ConceptoSAT, PorcentajeDeducible, FechaEmision, Ejercicio, Periodo
UNION ALL
SELECT EstacionTrabajo, Modulo, ModuloID, Sucursal, Empresa, Proveedor, ConceptoSAT, PorcentajeDeducible, FechaEmision, Ejercicio, Periodo, 0.0, 0.0, SUM(IEPS), 0.0, 0.0
FROM CFDIRetencionD
WHERE EsIEPS = 1
AND EstacionTrabajo = @Estacion
AND Modulo = @Modulo
AND ModuloID = @ModuloID
GROUP BY EstacionTrabajo, Modulo, ModuloID, Sucursal, Empresa, Proveedor, ConceptoSAT, PorcentajeDeducible, FechaEmision, Ejercicio, Periodo
END
ELSE
BEGIN
INSERT INTO #CFDIRetencion(
EstacionTrabajo, Modulo, ModuloID, Sucursal, Empresa, Proveedor, ConceptoSAT, PorcentajeDeducible, FechaEmision, Ejercicio, Periodo, Importe, IVA, IEPS, Retencion1,      Retencion2)
SELECT EstacionTrabajo, Modulo, ModuloID, Sucursal, Empresa, Proveedor, ConceptoSAT, PorcentajeDeducible, FechaEmision, Ejercicio, Periodo, Importe, IVA, 0.0,  SUM(Retencion1), SUM(Retencion2)
FROM CFDIRetencionD
WHERE EsRetencion = 1
AND EstacionTrabajo = @Estacion
AND Modulo = @Modulo
AND ModuloID = @ModuloID
GROUP BY EstacionTrabajo, Modulo, ModuloID, Sucursal, Empresa, Proveedor, ConceptoSAT, PorcentajeDeducible, FechaEmision, Ejercicio, Periodo, Importe, IVA, IEPS
UNION ALL
SELECT EstacionTrabajo, Modulo, ModuloID, Sucursal, Empresa, Proveedor, ConceptoSAT, PorcentajeDeducible, FechaEmision, Ejercicio, Periodo, SUM(Importe), SUM(IVA), SUM(IEPS), SUM(Retencion1), SUM(Retencion2)
FROM CFDIRetencionD
WHERE EsComplemento = 1
AND EstacionTrabajo = @Estacion
AND Modulo = @Modulo
AND ModuloID = @ModuloID
GROUP BY EstacionTrabajo, Modulo, ModuloID, Sucursal, Empresa, Proveedor, ConceptoSAT, PorcentajeDeducible, FechaEmision, Ejercicio, Periodo
UNION ALL
SELECT EstacionTrabajo, Modulo, ModuloID, Sucursal, Empresa, Proveedor, ConceptoSAT, PorcentajeDeducible, FechaEmision, Ejercicio, Periodo, Importe, IVA, IEPS, 0.0, 0.0
FROM CFDIRetencionD
WHERE EsIEPS = 1
AND EstacionTrabajo = @Estacion
AND Modulo = @Modulo
AND ModuloID = @ModuloID
GROUP BY EstacionTrabajo, Modulo, ModuloID, Sucursal, Empresa, Proveedor, ConceptoSAT, PorcentajeDeducible, FechaEmision, Ejercicio, Periodo, Importe, IVA, IEPS
END
END
END
INSERT INTO CFDIRetencion(
EstacionTrabajo,   Modulo,   ModuloID,   Mov,   MovID,    Sucursal,   Empresa,   Proveedor,   ConceptoSAT,   FechaEmision,   Ejercicio,   Periodo, Importe,        IVA,        IEPS,        Retencion1,        Retencion2)
SELECT c.EstacionTrabajo, c.Modulo, c.ModuloID, o.Mov, o.MovID,  c.Sucursal, c.Empresa, c.Proveedor, c.ConceptoSAT, c.FechaEmision, c.Ejercicio, c.Periodo, SUM(c.Importe), SUM(c.IVA), SUM(c.IEPS), SUM(c.Retencion1), SUM(c.Retencion2)
FROM #CFDIRetencion c
JOIN Compra o ON c.Modulo = 'COMS' AND c.ModuloID = o.ID
GROUP BY c.EstacionTrabajo, c.Modulo, c.ModuloID, c.Sucursal, c.Empresa, c.Proveedor, c.ConceptoSAT, c.FechaEmision, c.Ejercicio, c.Periodo, o.Mov, o.MovID
UNION ALL
SELECT c.EstacionTrabajo, c.Modulo, c.ModuloID, o.Mov, o.MovID,  c.Sucursal, c.Empresa, c.Proveedor, c.ConceptoSAT, c.FechaEmision, c.Ejercicio, c.Periodo, SUM(c.Importe), SUM(c.IVA), SUM(c.IEPS), SUM(c.Retencion1), SUM(c.Retencion2)
FROM #CFDIRetencion c
JOIN Gasto o ON c.Modulo = 'GAS' AND c.ModuloID = o.ID
GROUP BY c.EstacionTrabajo, c.Modulo, c.ModuloID, c.Sucursal, c.Empresa, c.Proveedor, c.ConceptoSAT, c.FechaEmision, c.Ejercicio, c.Periodo, o.Mov, o.MovID
INSERT INTO CFDIRetencionCalcTmp(
EstacionTrabajo,   Modulo,   ModuloID,   Mov,   MovID,    Sucursal,   Empresa,   Proveedor,   ConceptoSAT,   PorcentajeDeducible,   FechaEmision,   Ejercicio,   Periodo, Importe,        IVA,        IEPS,        Retencion1,        Retencion2)
SELECT c.EstacionTrabajo, c.Modulo, c.ModuloID, o.Mov, o.MovID,  c.Sucursal, c.Empresa, c.Proveedor, c.ConceptoSAT, c.PorcentajeDeducible, c.FechaEmision, c.Ejercicio, c.Periodo, SUM(c.Importe), SUM(c.IVA), SUM(c.IEPS), SUM(c.Retencion1), SUM(c.Retencion2)
FROM #CFDIRetencion c
JOIN Compra o ON c.Modulo = 'COMS' AND c.ModuloID = o.ID
GROUP BY c.EstacionTrabajo, c.Modulo, c.ModuloID, c.Sucursal, c.Empresa, c.Proveedor, c.ConceptoSAT, c.PorcentajeDeducible, c.FechaEmision, c.Ejercicio, c.Periodo, o.Mov, o.MovID
UNION ALL
SELECT c.EstacionTrabajo, c.Modulo, c.ModuloID, o.Mov, o.MovID,  c.Sucursal, c.Empresa, c.Proveedor, c.ConceptoSAT, c.PorcentajeDeducible, c.FechaEmision, c.Ejercicio, c.Periodo, SUM(c.Importe), SUM(c.IVA), SUM(c.IEPS), SUM(c.Retencion1), SUM(c.Retencion2)
FROM #CFDIRetencion c
JOIN Gasto o ON c.Modulo = 'GAS' AND c.ModuloID = o.ID
GROUP BY c.EstacionTrabajo, c.Modulo, c.ModuloID, c.Sucursal, c.Empresa, c.Proveedor, c.ConceptoSAT, c.PorcentajeDeducible, c.FechaEmision, c.Ejercicio, c.Periodo, o.Mov, o.MovID
RETURN
END

