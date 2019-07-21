SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW cCorteDConsulta

AS
SELECT
ID,
Renglon,
Empresa,
Sucursal,
UEN,
Usuario,
Modulo,
Movimiento,
Estatus,
Situacion,
Proyecto,
ContactoTipo,
Contacto,
ImporteMin,
ImporteMax,
ValidarAlEmitir,
Desglosar,
Agrupador,
Accion,
Moneda,
Totalizador,
Cuenta,
CtaCategoria,
CtaFamilia,
CtaGrupo,
Rama,
CtaFabricante,
CtaLinea,
Almacen,
CtaTipo
FROM
CorteDConsulta

