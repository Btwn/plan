SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAEntidadOpcional AS
SELECT
entidad_clave          = '(todos)',
entidad_nombre         = '(todos)',
entidad_tipo           = NULL,
entidad_rfc            = NULL,
entidad_pais           = NULL,
entidad_nacionalidad   = NULL,
entidad_tipo_tercero   = NULL,
entidad_tipo_operacion = NULL
UNION ALL
SELECT
entidad_clave,
entidad_nombre,
entidad_tipo,
entidad_rfc,
entidad_pais,
entidad_nacionalidad,
entidad_tipo_tercero,
entidad_tipo_operacion
FROM MFAEntidad

