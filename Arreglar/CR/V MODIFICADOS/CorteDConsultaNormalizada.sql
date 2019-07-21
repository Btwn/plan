SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CorteDConsultaNormalizada

AS
SELECT
cd.ID,
cd.RID,
CONVERT(varchar(5),NULLIF(NULLIF(cd.Empresa,'(TODOS)'), '')) Empresa,
CONVERT(int,NULLIF(NULLIF(cd.Sucursal,'(TODOS)'), '')) Sucursal,
CONVERT(int,NULLIF(NULLIF(cd.UEN,'(TODOS)'), '')) UEN,
NULLIF(NULLIF(cd.Usuario,'(TODOS)'), '') Usuario,
CONVERT(varchar(5),NULLIF(NULLIF(cd.Modulo,'(TODOS)'), '')) Modulo,
NULLIF(NULLIF(cd.Movimiento,'(TODOS)'), '') Movimiento,
e.Estatus Estatus,
NULLIF(NULLIF(cd.Situacion,'(TODOS)'), '') Situacion,
NULLIF(NULLIF(cd.Proyecto,'(TODOS)'), '') Proyecto,
NULLIF(NULLIF(cd.ContactoTipo,'(TODOS)'), '') ContactoTipo,
NULLIF(NULLIF(cd.Contacto,'(TODOS)'), '') Contacto,
NULLIF(cd.ImporteMin,0.0) ImporteMin,
NULLIF(cd.ImporteMax,0.0) ImporteMax,
ValidarAlEmitir ValidarAlEmitir,
Accion,
Desglosar,
Agrupador,
NULLIF(NULLIF(cd.Moneda,'(TODOS)'), '') Moneda,
Totalizador,
NULLIF(NULLIF(cd.Cuenta,'(TODOS)'), '') Cuenta,
NULLIF(NULLIF(cd.CtaCategoria,'(TODOS)'), '') CtaCategoria,
NULLIF(NULLIF(cd.CtaFamilia,'(TODOS)'), '') CtaFamilia,
NULLIF(NULLIF(cd.CtaGrupo,'(TODOS)'), '') CtaGrupo,
NULLIF(NULLIF(cd.CtaFabricante,'(TODOS)'), '')  CtaFabricante,
NULLIF(NULLIF(cd.CtaLinea,'(TODOS)'), '') CtaLinea,
NULLIF(NULLIF(cd.Rama,'(TODOS)'), '') Rama,
NULLIF(NULLIF(cd.Almacen,'(TODOS)'), '') Almacen,
NULLIF(NULLIF(cd.CtaTipo,'(TODOS)'), '') CtaTipo
FROM CorteDConsulta cd WITH (NOLOCK)
LEFT OUTER JOIN Estatus e WITH (NOLOCK) ON UPPER(RTRIM(e.Nombre)) = UPPER(RTRIM(NULLIF(NULLIF(cd.Estatus,'(TODOS)'), '')))

