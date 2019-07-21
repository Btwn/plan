SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fn_tipo_cuenta (@tipo_cuenta varchar(50))
RETURNS nvarchar(2)
AS BEGIN
RETURN
CASE LOWER(@tipo_cuenta)
WHEN 'activo_circulante'  THEN N'A1'
WHEN 'activo_fijo'		THEN N'A2'
WHEN 'activo_diferido'	THEN N'A3'
WHEN 'pasivo_corto_plazo'	THEN N'P1'
WHEN 'pasivo_largo_plazo'	THEN N'P2'
WHEN 'capital_contable'	THEN N'C1'
WHEN 'otros_gastos'		THEN N'F1'
WHEN 'otros_productos'	THEN N'H0'
WHEN 'gastos_operacion'	THEN N'G1'
WHEN 'impuestos'			THEN N'I1'
WHEN 'cuentas_orden'		THEN N'O1'
WHEN 'costos'				THEN N'T1'
WHEN 'ingresos'			THEN N'V1'
ELSE NULL
END
END

