SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW POSLDIVenta

AS
SELECT i.ID,i.Referencia1,i.Referencia2,i.Referencia3,p.Mov,p.MovID,v.Articulo
FROM POSLDIVentaID i
JOIN POSL p ON p.ID = i.ID
JOIN POSLVenta v ON p.ID = v.ID AND v.LDIServicio IS NOT NULL
WHERE p.Estatus = 'CONCLUIDO'

