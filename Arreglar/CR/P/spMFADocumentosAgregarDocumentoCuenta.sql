SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spMFADocumentosAgregarDocumentoCuenta
@IFRS							bit,
@IncluirPolizasEspecificas		bit,
@Empresa						varchar(5)

AS BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @Base		varchar(255)
SELECT @Base = db_name()
TRUNCATE TABLE temp2_layout_documentos_cuenta
TRUNCATE TABLE temp3_layout_documentos_cuenta
DELETE layout_documentos_cuenta WHERE Empresa = @Empresa
EXEC spShrink_Log @Base
INSERT temp2_layout_documentos_cuenta (empresa, origen_modulo, origen_id)
SELECT  empresa, origen_modulo, origen_id
FROM  layout_documentos WITH(NOLOCK)
WHERE  Empresa = @Empresa
GROUP  BY origen_id, origen_modulo, empresa
EXEC spShrink_Log @Base
PRINT 'Fin generar temp2_layout_documentos_cuenta (Q26.1): ' + CONVERT(varchar,getdate(),126)
INSERT temp3_layout_documentos_cuenta (empresa,       origen_modulo,       origen_id,       poliza,   poliza_id,  mov,   mov_id)
SELECT t2ldc.empresa, t2ldc.origen_modulo, t2ldc.origen_id, t.Poliza, t.PolizaID, t.Mov, t.MovID
FROM temp2_layout_documentos_cuenta t2ldc WITH(NOLOCK)
JOIN Venta t WITH(NOLOCK) ON t.ID = CONVERT(int,t2ldc.origen_id) AND t2ldc.origen_modulo = 'VTAS' AND t.Empresa = t2ldc.empresa
WHERE t.Poliza IS NOT NULL
AND  t2ldc.Empresa = @Empresa
EXEC spShrink_Log @Base
PRINT 'Fin generar temp3_layout_documentos_cuenta venta (Q26.2): ' + CONVERT(varchar,getdate(),126)
INSERT temp3_layout_documentos_cuenta (empresa,       origen_modulo,       origen_id,       poliza,   poliza_id,  mov,   mov_id)
SELECT  t2ldc.empresa, t2ldc.origen_modulo, t2ldc.origen_id, t.Poliza, t.PolizaID, t.Mov, t.MovID
FROM  temp2_layout_documentos_cuenta t2ldc WITH(NOLOCK)
JOIN  Compra t WITH(NOLOCK) ON t.ID = CONVERT(int,t2ldc.origen_id) AND t2ldc.origen_modulo = 'COMS' AND t.Empresa = t2ldc.empresa
WHERE  t.Poliza IS NOT NULL
AND  t2ldc.Empresa = @Empresa
EXEC spShrink_Log @Base
PRINT 'Fin generar temp3_layout_documentos_cuenta compra (Q26.3): ' + CONVERT(varchar,getdate(),126)
INSERT temp3_layout_documentos_cuenta (empresa,       origen_modulo,       origen_id,       poliza,   poliza_id,  mov,   mov_id)
SELECT  t2ldc.empresa, t2ldc.origen_modulo, t2ldc.origen_id, t.Poliza, t.PolizaID, t.Mov, t.MovID
FROM  temp2_layout_documentos_cuenta t2ldc WITH(NOLOCK)
JOIN  Gasto t WITH(NOLOCK) ON t.ID = CONVERT(int,t2ldc.origen_id) AND t2ldc.origen_modulo = 'GAS' AND t.Empresa = t2ldc.empresa
WHERE  t.Poliza IS NOT NULL
AND  t2ldc.Empresa = @Empresa
EXEC spShrink_Log @Base
PRINT 'Fin generar temp3_layout_documentos_cuenta gasto (Q26.4): ' + CONVERT(varchar,getdate(),126)
INSERT temp3_layout_documentos_cuenta (empresa,       origen_modulo,       origen_id,       poliza,   poliza_id,  mov,   mov_id)
SELECT  t2ldc.empresa, t2ldc.origen_modulo, t2ldc.origen_id, t.Poliza, t.PolizaID, t.Mov, t.MovID
FROM  temp2_layout_documentos_cuenta t2ldc WITH(NOLOCK)
JOIN  Cxc t  WITH(NOLOCK) ON t.ID = CONVERT(int,t2ldc.origen_id) AND t2ldc.origen_modulo = 'CXC' AND t.Empresa = t2ldc.empresa
WHERE  t.Poliza IS NOT NULL
AND  t2ldc.Empresa = @Empresa
EXEC spShrink_Log @Base
PRINT 'Fin generar temp3_layout_documentos_cuenta cxc (Q26.5): ' + CONVERT(varchar,getdate(),126)
INSERT temp3_layout_documentos_cuenta (empresa,       origen_modulo,       origen_id,       poliza,   poliza_id, mov,   mov_id)
SELECT t2ldc.empresa, t2ldc.origen_modulo, t2ldc.origen_id, t.Poliza, t.PolizaID, t.Mov, t.MovID
FROM temp2_layout_documentos_cuenta t2ldc WITH(NOLOCK)
JOIN Cxp t WITH(NOLOCK) ON t.ID = CONVERT(int,t2ldc.origen_id) AND t2ldc.origen_modulo = 'CXP' AND t.Empresa = t2ldc.empresa
WHERE t.Poliza IS NOT NULL
AND  t2ldc.Empresa = @Empresa
EXEC spShrink_Log @Base
PRINT 'Fin generar temp3_layout_documentos_cuenta cxp (Q26.6): ' + CONVERT(varchar,getdate(),126)
INSERT temp3_layout_documentos_cuenta (empresa,       origen_modulo,       origen_id,       poliza,   poliza_id, mov,   mov_id)
SELECT t2ldc.empresa, t2ldc.origen_modulo, t2ldc.origen_id, t.Poliza, t.PolizaID, t.Mov, t.MovID
FROM temp2_layout_documentos_cuenta t2ldc WITH(NOLOCK)
JOIN Nomina t WITH(NOLOCK) ON t.ID = CONVERT(int,t2ldc.origen_id) AND t2ldc.origen_modulo = 'NOM' AND t.Empresa = t2ldc.empresa
WHERE t.Poliza IS NOT NULL
AND  t2ldc.Empresa = @Empresa
EXEC spShrink_Log @Base
PRINT 'Fin generar temp3_layout_documentos_cuenta nom (Q26.6): ' + CONVERT(varchar,getdate(),126)
IF @IFRS = 1 AND @IncluirPolizasEspecificas = 1
BEGIN
INSERT layout_documentos_cuenta (empresa,       origen_modulo,       origen_id,       cuenta_contable, debe,                     haber,                     Ejercicio,   Periodo,     ContID)
SELECT t3ldc.empresa,  t3ldc.origen_modulo, t3ldc.origen_id, cd.Cuenta,       SUM(ISNULL(cd.Debe,0.0)), SUM(ISNULL(cd.Haber,0.0)), c.Ejercicio, c.Periodo, c.ID
FROM temp3_layout_documentos_cuenta t3ldc  WITH(NOLOCK)
JOIN Cont c WITH(NOLOCK) ON c.MovID = t3ldc.poliza_id AND c.Mov = t3ldc.poliza AND c.Empresa = t3ldc.empresa and c.OrigenTipo = t3ldc.origen_modulo AND c.Origen = t3ldc.mov AND c.OrigenID = t3ldc.mov_id
JOIN ContD cd WITH(NOLOCK) ON cd.ID = c.ID
WHERE c.Estatus = 'CONCLUIDO'
AND  t3ldc.Empresa = @Empresa
GROUP BY t3ldc.empresa,  t3ldc.origen_modulo, t3ldc.origen_id, cd.Cuenta, c.Ejercicio, c.Periodo, c.ID
EXEC spShrink_Log @Base
INSERT layout_documentos_cuenta (empresa,       origen_modulo,       origen_id,       cuenta_contable, debe,                     haber,                     Ejercicio,   Periodo,     ContID)
SELECT c.empresa,     ISNULL(c.OrigenTipo, 'CONT'), c.id,			  cd.Cuenta,       SUM(ISNULL(cd.Debe,0.0)), SUM(ISNULL(cd.Haber,0.0)), c.Ejercicio, c.Periodo, c.ID
FROM MFAContAdicion t3ldc WITH(NOLOCK)
JOIN Cont c  WITH(NOLOCK) ON c.ID = t3ldc.ModuloID
JOIN ContD cd  WITH(NOLOCK) ON cd.ID = c.ID
WHERE c.Estatus = 'CONCLUIDO'
AND c.Empresa = @Empresa
AND c.ID NOT IN(SELECT ContID FROM layout_documentos_cuenta)
GROUP BY c.empresa, c.OrigenTipo, c.id, cd.Cuenta, c.Ejercicio, c.Periodo, c.ID
EXEC spShrink_Log @Base
INSERT layout_documentos_cuenta (empresa,       origen_modulo,       origen_id,       cuenta_contable, debe,                     haber,                     Ejercicio,   Periodo,     ContID)
SELECT c.empresa,     ISNULL(c.OrigenTipo, 'CONT'), c.id,			  cd.Cuenta,       SUM(ISNULL(cd.Debe,0.0)), SUM(ISNULL(cd.Haber,0.0)), c.Ejercicio, c.Periodo, c.ID
FROM MFAContOrigenAdicion t3ldc WITH(NOLOCK)
JOIN Cont c  WITH(NOLOCK) ON ISNULL(c.OrigenTipo, '') = ISNULL(t3ldc.OrigenTipo, '') AND ISNULL(c.Origen, '') = ISNULL(t3ldc.Origen, '') AND ISNULL(c.Mov, '') = ISNULL(t3ldc.Mov, '')
JOIN ContD cd WITH(NOLOCK) ON cd.ID = c.ID
WHERE c.Estatus = 'CONCLUIDO'
AND c.Empresa = @Empresa
AND c.ID NOT IN(SELECT ContID FROM layout_documentos_cuenta)
GROUP BY c.empresa, c.OrigenTipo, c.id, cd.Cuenta, c.Ejercicio, c.Periodo, c.ID
EXEC spShrink_Log @Base
END
ELSE
INSERT layout_documentos_cuenta (empresa,       origen_modulo,       origen_id,       cuenta_contable, debe,                     haber,                     Ejercicio,   Periodo,     ContID)
SELECT t3ldc.empresa,  t3ldc.origen_modulo, t3ldc.origen_id, cd.Cuenta,       SUM(ISNULL(cd.Debe,0.0)), SUM(ISNULL(cd.Haber,0.0)), c.Ejercicio, c.Periodo, c.ID
FROM temp3_layout_documentos_cuenta t3ldc  WITH(NOLOCK)
JOIN Cont c  WITH(NOLOCK) ON c.MovID = t3ldc.poliza_id AND c.Mov = t3ldc.poliza AND c.Empresa = t3ldc.empresa and c.OrigenTipo = t3ldc.origen_modulo AND c.Origen = t3ldc.mov AND c.OrigenID = t3ldc.mov_id
JOIN ContD cd  WITH(NOLOCK) ON cd.ID = c.ID
WHERE c.Estatus = 'CONCLUIDO'
AND c.Empresa = @Empresa
GROUP BY t3ldc.empresa,  t3ldc.origen_modulo, t3ldc.origen_id, cd.Cuenta, c.Ejercicio, c.Periodo, c.ID
EXEC spShrink_Log @Base
PRINT 'Fin generar temp_layout_documentos_cuenta (Q26.7): ' + CONVERT(varchar,getdate(),126)
/*
INSERT layout_documentos_cuenta (empresa,      origen_modulo,      origen_id,      cuenta_contable,      debe,      haber)
SELECT tldc.empresa,  tldc.origen_modulo, tldc.origen_id, tldc.cuenta_contable, tldc.debe, tldc.haber
FROM temp_layout_documentos_cuenta tldc
PRINT 'Fin generar layout_documentos_cuenta (Q26.8): ' + CONVERT(varchar,getdate(),126)
*/
RETURN
END

