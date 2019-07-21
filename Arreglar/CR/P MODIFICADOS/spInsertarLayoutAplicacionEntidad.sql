SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spInsertarLayoutAplicacionEntidad
@Empresa    varchar(5),
@Ok			int			= NULL OUTPUT,
@OkRef		varchar(255)= NULL OUTPUT

AS BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DELETE layout_aplicacion_entidad WHERE Empresa = @Empresa
INSERT layout_aplicacion_entidad (empresa, referencia, folio, entidad_clave, entidad_nombre, entidad_rfc, entidad_id_fiscal, entidad_tipo_tercero, entidad_tipo_operacion, entidad_pais, entidad_nacionalidad)
SELECT
empresa				 = la.empresa,
referencia             = la.referencia,
folio                  = la.folio,
entidad_clave          = ld.entidad_clave,
entidad_nombre         = ld.entidad_nombre,
entidad_rfc            = ld.entidad_rfc,
entidad_id_fiscal      = ld.entidad_id_fiscal,
entidad_tipo_tercero   = ld.entidad_tipo_tercero,
entidad_tipo_operacion = ld.entidad_tipo_operacion,
entidad_pais           = ld.entidad_pais,
entidad_nacionalidad   = ld.entidad_nacionalidad
FROM layout_aplicaciones la  WITH(NOLOCK)
JOIN layout_aplicaciones la2 WITH(NOLOCK) ON la2.folio = la.folio AND la2.Empresa = la.Empresa AND la2.Ejercicio = la.Ejercicio AND la2.Periodo = la.Periodo
JOIN layout_documentos ld    WITH(NOLOCK) ON la2.Referencia = ld.folio and la2.empresa = ld.empresa
WHERE la.referencia IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes')
AND la2.referencia NOT IN ('Redondeo','Saldo a favor','Vales en Circulacion','Consumos Pendientes')
AND la.Empresa = @Empresa
GROUP BY la.empresa, la.referencia, la.folio, ld.entidad_clave, ld.entidad_nombre, ld.entidad_rfc, ld.entidad_id_fiscal, ld.entidad_tipo_tercero, ld.entidad_tipo_operacion, ld.entidad_pais, ld.entidad_nacionalidad
END

