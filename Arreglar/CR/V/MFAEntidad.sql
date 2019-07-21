SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAEntidad AS
SELECT
entidad_clave          = c.Cliente,
entidad_nombre         = c.Nombre,
entidad_tipo           = 'Cliente',
entidad_rfc            = c.RFC,
entidad_pais           = mp.Pais,
entidad_nacionalidad   = mp.Nacionalidad,
entidad_tipo_tercero   = CASE
WHEN ISNULL(fr.Extranjero,0) = 0 THEN 'nacional'
WHEN ISNULL(fr.Extranjero,0) = 1 THEN 'extranjero'
END,
entidad_tipo_operacion = c.MFATipoOperacion
FROM Cte c
LEFT OUTER JOIN Pais pa ON pa.Clave = c.Pais
LEFT OUTER JOIN MFAPais mp ON mp.Pais = pa.Pais
LEFT OUTER JOIN FiscalRegimen fr ON fr.FiscalRegimen = c.FiscalRegimen
WHERE c.Estatus IN ('ALTA')
UNION ALL
SELECT
entidad_clave          = p.Proveedor,
entidad_nombre         = p.Nombre,
entidad_tipo           = 'Proveedor',
entidad_rfc            = p.RFC,
entidad_pais           = mp.Pais,
entidad_nacionalidad   = mp.Nacionalidad,
entidad_tipo_tercero   = CASE
WHEN ISNULL(fr.Extranjero,0) = 0 THEN 'nacional'
WHEN ISNULL(fr.Extranjero,0) = 1 THEN 'extranjero'
END,
entidad_tipo_operacion = p.MFATipoOperacion
FROM Prov p
LEFT OUTER JOIN Pais pa ON pa.Clave = p.Pais
LEFT OUTER JOIN MFAPais mp ON mp.Pais = pa.Pais
LEFT OUTER JOIN FiscalRegimen fr ON fr.FiscalRegimen = p.FiscalRegimen
WHERE p.Estatus IN ('ALTA')

