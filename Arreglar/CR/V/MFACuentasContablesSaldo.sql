SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFACuentasContablesSaldo AS
SELECT
cuenta_contable				= c.Cuenta,
cuenta_control				= CASE WHEN UPPER(c.Tipo) = 'MAYOR' THEN NULL ELSE c.Rama END,
descripcion					= c.Descripcion,
nivel							= CASE
WHEN UPPER(c.Tipo) = 'MAYOR'     THEN 1
WHEN UPPER(c.Tipo) = 'SUBCUENTA' THEN 2
WHEN UPPER(c.Tipo) = 'AUXILIAR'  THEN 3
END,
clase_cuenta                  = CASE
WHEN ISNULL(c.EsAcumulativa,0) = 1 THEN 'control'
WHEN ISNULL(c.EsAcumulativa,0) = 0 THEN 'registro'
END,
tipo_cuenta                   = dbo.fnMFATipoCuentaEstructura(c.Cuenta)
FROM Cta c
WHERE UPPER(c.Tipo) IN ('MAYOR','SUBCUENTA','AUXILIAR')

