SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgClavePresupuestalDesgloseCat ON ClavePresupuestal
FOR INSERT, UPDATE
AS
BEGIN
UPDATE ClavePresupuestal
SET
Categoria1 = NULLIF(dbo.fnPCPClavePresupuestalExtraerCategoria('1',p.ClavePresupuestalMascara,cp.ClavePresupuestal),''),
Categoria2 = NULLIF(dbo.fnPCPClavePresupuestalExtraerCategoria('2',p.ClavePresupuestalMascara,cp.ClavePresupuestal),''),
Categoria3 = NULLIF(dbo.fnPCPClavePresupuestalExtraerCategoria('3',p.ClavePresupuestalMascara,cp.ClavePresupuestal),''),
Categoria4 = NULLIF(dbo.fnPCPClavePresupuestalExtraerCategoria('4',p.ClavePresupuestalMascara,cp.ClavePresupuestal),''),
Categoria5 = NULLIF(dbo.fnPCPClavePresupuestalExtraerCategoria('5',p.ClavePresupuestalMascara,cp.ClavePresupuestal),''),
Categoria6 = NULLIF(dbo.fnPCPClavePresupuestalExtraerCategoria('6',p.ClavePresupuestalMascara,cp.ClavePresupuestal),''),
Categoria7 = NULLIF(dbo.fnPCPClavePresupuestalExtraerCategoria('7',p.ClavePresupuestalMascara,cp.ClavePresupuestal),''),
Categoria8 = NULLIF(dbo.fnPCPClavePresupuestalExtraerCategoria('8',p.ClavePresupuestalMascara,cp.ClavePresupuestal),''),
Categoria9 = NULLIF(dbo.fnPCPClavePresupuestalExtraerCategoria('9',p.ClavePresupuestalMascara,cp.ClavePresupuestal),''),
CategoriaA = NULLIF(dbo.fnPCPClavePresupuestalExtraerCategoria('A',p.ClavePresupuestalMascara,cp.ClavePresupuestal),''),
CategoriaB = NULLIF(dbo.fnPCPClavePresupuestalExtraerCategoria('B',p.ClavePresupuestalMascara,cp.ClavePresupuestal),''),
CategoriaC = NULLIF(dbo.fnPCPClavePresupuestalExtraerCategoria('C',p.ClavePresupuestalMascara,cp.ClavePresupuestal),'')
FROM ClavePresupuestal cp JOIN Inserted i
ON i.ClavePresupuestal = cp.ClavePresupuestal JOIN Proy p
ON p.Proyecto = cp.Proyecto
END

