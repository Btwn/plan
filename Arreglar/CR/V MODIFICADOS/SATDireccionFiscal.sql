SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW SATDireccionFiscal

AS
SELECT
SATCatCP.ID 'ID',
SATCatCP.ClaveCP 'ClaveCP',
SATPais.ClavePais 'ClavePais',
SATPais.Descripcion 'SATPaisDescripcion',
SATCatCP.ClaveEstado 'ClaveEstado',
SATEstado.Descripcion 'SATEstadoDescripcion',
SATCatCP.ClaveMunicipio 'ClaveMunicipio',
SATMunicipio.Descripcion 'SATMunicipioDescripcion',
SATCatCP.ClaveLocalidad 'ClaveLocalidad',
SATLocalidad.Descripcion 'SATLocalidadDescripcion',
SATColonia.ClaveColonia 'ClaveColonia',
SATColonia.Descripcion 'SATColoniaDescripcion',
SATCatCP.HusoHorario 'HusoHorario',
SATCatCP.Descripcion 'Descripcion',
SATCatCP.VeranoMesInicio 'VeranoMesInicio',
SATCatCP.VeranoDiaInicio 'VeranoDiaInicio',
SATCatCP.VeranoHoraInicio 'VeranoHoraInicio',
SATCatCP.VeranoDiferenciaHoraria 'VeranoDiferenciaHoraria',
SATCatCP.InviernoMesInicio 'InviernoMesInicio',
SATCatCP.InviernoDiaInicio 'InviernoDiaInicio',
SATCatCP.InviernoHoraInicio 'InviernoHoraInicio',
SATCatCP.InviernoDiferenciaHoraria 'InviernoDiferenciaHoraria'
FROM SATCatCP WITH(NOLOCK)
LEFT OUTER JOIN SATEstado WITH(NOLOCK) ON SATCatCP.ClaveEstado=SATEstado.ClaveEstado
LEFT OUTER JOIN SATPais WITH(NOLOCK) ON SATEstado.ClavePais = SATPais.ClavePais
LEFT OUTER JOIN SATMunicipio WITH(NOLOCK) ON SATCatCP.ClaveMunicipio=SATMunicipio.ClaveMunicipio AND SATCatCP.ClaveEstado=SATMunicipio.ClaveEstado
LEFT OUTER JOIN SATLocalidad WITH(NOLOCK) ON SATCatCP.ClaveLocalidad=SATLocalidad.ClaveLocalidad AND SATCatCP.ClaveEstado=SATLocalidad.ClaveEstado
LEFT OUTER JOIN SATColonia WITH(NOLOCK) ON SATCatCP.ClaveCP = SATColonia.ClaveCP

