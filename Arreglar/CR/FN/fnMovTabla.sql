SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnMovTabla (@Modulo char(5))
RETURNS varchar(50)

AS BEGIN
DECLARE
@Tabla	varchar(50)
SELECT @Tabla = NULL
SELECT @Tabla = CASE @Modulo
WHEN 'VTAS'  THEN 'Venta'
WHEN 'COMS'  THEN 'Compra'
WHEN 'ST'    THEN 'Soporte'
WHEN 'EMB'   THEN 'Embarque'
WHEN 'DIN'   THEN 'Dinero'
WHEN 'AF'    THEN 'ActivoFijo'
WHEN 'NOM'   THEN 'Nomina'
WHEN 'ASIS'  THEN 'Asiste'
WHEN 'GAS'   THEN 'Gasto'
WHEN 'CAP'   THEN 'Capital'
WHEN 'CAM'   THEN 'Cambio'
WHEN 'PROY'  THEN 'Proyecto'
WHEN 'INC'   THEN 'Incidencia'
WHEN 'CONC'  THEN 'Conciliacion'
WHEN 'PPTO'  THEN 'Presup'
WHEN 'CREDI' THEN 'Credito'
WHEN 'CMP'   THEN 'Campana'
WHEN 'FIS'   THEN 'Fiscal'
WHEN 'CONTP' THEN 'ContParalela'
WHEN 'OPORT' THEN 'Oportunidad'
WHEN 'CORTE' THEN 'Corte'
WHEN 'ORG'   THEN 'Organiza'
WHEN 'RE'	 THEN 'Recluta'
WHEN 'FRM'   THEN 'FormaExtra'
WHEN 'CAPT'  THEN 'Captura'
WHEN 'GES'   THEN 'Gestion'
WHEN 'OFER'  THEN 'Oferta'
WHEN 'PACTO' THEN 'Contrato'
WHEN 'CXP'   THEN 'CXP'
WHEN 'TMA'	 THEN 'TMA'
WHEN 'AGENT' THEN 'AGENT'
WHEN 'ISL'	 THEN 'ISL'
WHEN 'PROD'	 THEN 'PROD'
WHEN 'CONT'	 THEN 'CONT'
WHEN 'CP'	 THEN 'CP'
WHEN 'PCP'	 THEN 'PCP'
WHEN 'PC'    THEN 'PC'
WHEN 'RH'	 THEN 'RH'
WHEN 'CXC'	 THEN 'CXC'
WHEN 'VALE'	 THEN 'VALE'
WHEN 'RSS'	 THEN 'RSS'
WHEN 'CR'	 THEN 'CR'
WHEN 'INV'	 THEN 'INV'
WHEN 'SAUX'	 THEN 'SAUX'
ELSE dbo.xnMovTabla(@Modulo)
END
RETURN (@Tabla)
END

