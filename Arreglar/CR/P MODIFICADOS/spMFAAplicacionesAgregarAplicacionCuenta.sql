SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMFAAplicacionesAgregarAplicacionCuenta
@Empresa			varchar(5)

AS BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @Base		varchar(255)
SELECT @Base = db_name()
DELETE temp2_layout_aplicaciones_cuenta WHERE Empresa = @Empresa
DELETE temp3_layout_aplicaciones_cuenta WHERE Empresa = @Empresa
DELETE layout_aplicaciones_cuenta  WHERE Empresa = @Empresa
EXEC spShrink_Log @Base
INSERT temp2_layout_aplicaciones_cuenta (empresa, origen_modulo, origen_id)
SELECT  empresa, origen_modulo, origen_id
FROM  layout_aplicaciones WITH (NOLOCK)
WHERE  empresa = @Empresa
GROUP  BY origen_id, origen_modulo, empresa
EXEC spShrink_Log @Base
PRINT 'Fin generar temp2_layout_aplicaciones_cuenta (Q26.81): ' + CONVERT(varchar,getdate(),126)
INSERT temp3_layout_aplicaciones_cuenta (empresa,       origen_modulo,       origen_id,       poliza,   poliza_id,  mov,   mov_id)
SELECT  t2lac.empresa, t2lac.origen_modulo, t2lac.origen_id, t.Poliza, t.PolizaID, t.Mov, t.MovID
FROM  temp2_layout_aplicaciones_cuenta t2lac WITH(NOLOCK)
JOIN  Cxc t WITH(NOLOCK) ON t.ID = CONVERT(int,t2lac.origen_id) AND t2lac.origen_modulo = 'CXC' AND t.Empresa = t2lac.empresa
WHERE  t.Poliza IS NOT NULL
AND  t2lac.empresa = @Empresa
EXEC spShrink_Log @Base
PRINT 'Fin generar temp3_layout_documentos_cuenta cxc (Q26.82): ' + CONVERT(varchar,getdate(),126)
INSERT temp3_layout_aplicaciones_cuenta (empresa,       origen_modulo,       origen_id,       poliza,   poliza_id, mov,   mov_id)
SELECT  t2lac.empresa, t2lac.origen_modulo, t2lac.origen_id, t.Poliza, t.PolizaID, t.Mov, t.MovID
FROM temp2_layout_aplicaciones_cuenta t2lac WITH(NOLOCK)
JOIN Cxp t WITH(NOLOCK) ON t.ID = CONVERT(int,t2lac.origen_id) AND t2lac.origen_modulo = 'CXP' AND t.Empresa = t2lac.empresa
WHERE t.Poliza IS NOT NULL
AND  t2lac.empresa = @Empresa
EXEC spShrink_Log @Base
PRINT 'Fin generar temp3_layout_documentos_cuenta cxp (Q26.83): ' + CONVERT(varchar,getdate(),126)
INSERT temp3_layout_aplicaciones_cuenta (empresa,       origen_modulo,       origen_id,       poliza,   poliza_id, mov,   mov_id)
SELECT  t2lac.empresa, t2lac.origen_modulo, t2lac.origen_id, t.Poliza, t.PolizaID, t.Mov, t.MovID
FROM temp2_layout_aplicaciones_cuenta t2lac WITH(NOLOCK)
JOIN Dinero t WITH(NOLOCK) ON t.ID = CONVERT(int,t2lac.origen_id) AND t2lac.origen_modulo = 'DIN' AND t.Empresa = t2lac.empresa
WHERE t.Poliza IS NOT NULL
AND  t2lac.empresa = @Empresa
EXEC spShrink_Log @Base
PRINT 'Fin generar temp3_layout_documentos_cuenta cxp (Q26.83): ' + CONVERT(varchar,getdate(),126)
INSERT layout_aplicaciones_cuenta (empresa,       origen_modulo,       origen_id,       cuenta_contable, debe,                     haber,                     Ejercicio,   Periodo,     ContID)
SELECT  t3lac.empresa, t3lac.origen_modulo, t3lac.origen_id, cd.Cuenta,       SUM(ISNULL(cd.Debe,0.0)), SUM(ISNULL(cd.Haber,0.0)), c.Ejercicio, c.Periodo, c.ID
FROM temp3_layout_aplicaciones_cuenta t3lac WITH(NOLOCK)
JOIN Cont c WITH(NOLOCK) ON c.MovID = t3lac.poliza_id AND c.Mov = t3lac.poliza AND c.Empresa = t3lac.empresa and c.OrigenTipo = t3lac.origen_modulo AND c.Origen = t3lac.mov AND c.OrigenID = t3lac.mov_id
JOIN ContD cd WITH(NOLOCK) ON cd.ID = c.ID
WHERE c.Estatus = 'CONCLUIDO'
AND c.Empresa = @Empresa
GROUP BY t3lac.empresa,  t3lac.origen_modulo, t3lac.origen_id, cd.Cuenta, c.Ejercicio, c.Periodo, c.ID
EXEC spShrink_Log @Base
PRINT 'Fin generar temp_layout_documentos_cuenta (Q26.85): ' + CONVERT(varchar,getdate(),126)
/*
INSERT layout_aplicaciones_cuenta (empresa,      origen_modulo,      origen_id,      cuenta_contable,      debe,      haber)
SELECT tlac.empresa,  tlac.origen_modulo, tlac.origen_id, tlac.cuenta_contable, tlac.debe, tlac.haber
FROM temp_layout_aplicaciones_cuenta tlac
PRINT 'Fin generar layout_documentos_cuenta (Q26.85): ' + CONVERT(varchar,getdate(),126)
*/
RETURN
END

