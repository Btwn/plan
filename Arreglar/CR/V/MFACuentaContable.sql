SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFACuentaContable AS
SELECT
cuenta_contable				'Cuenta_contable',
ISNULL(cuenta_control, '')	'Cuenta_control',
ISNULL(nivel, '')			'Nivel',
ISNULL(descripcion, '')		'Descripcion',
CASE clase_cuenta WHEN 'control' THEN 'C' ELSE 'R' END 'Clase_cuenta',
ISNULL(moneda, '')			'Moneda',
''							'Cuenta_orden',
1							'Estatus',
empresa						'Empresa',
EsComplementaria
FROM layout_cuentas

