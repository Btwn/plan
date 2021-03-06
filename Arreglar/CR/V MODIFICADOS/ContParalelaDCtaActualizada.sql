SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW ContParalelaDCtaActualizada

AS
SELECT
ID,
Renglon,
Cuenta,
Rama,
Descripcion,
Tipo,
Categoria,
Grupo,
Familia,
EsAcreedora,
EsAcumulativa,
CtaEstatus,
TieneMovimientos,
Estatus
FROM
ContParalelaD WITH (NOLOCK)
WHERE (CtaEstatus = 'Actualizada' OR Tipo IN('Estructura'))

