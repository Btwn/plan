SET DATEFIRST 7
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW NotificacionFiltroNormalizada

AS
SELECT
nf.Notificacion,
nf.RID,
CONVERT(varchar(5),NULLIF(nf.Empresa,'(TODOS)')) Empresa,
CONVERT(int,NULLIF(nf.Sucursal,'(TODOS)')) Sucursal,
CONVERT(int,NULLIF(nf.UEN,'(TODOS)')) UEN,
NULLIF(nf.Usuario,'(TODOS)') Usuario,
CONVERT(varchar(5),NULLIF(nf.Modulo,'(TODOS)')) Modulo,
NULLIF(nf.Movimiento,'(TODOS)') Movimiento,
e.Estatus Estatus,
NULLIF(nf.Situacion,'(TODOS)') Situacion,
NULLIF(nf.Proyecto,'(TODOS)') Proyecto,
NULLIF(nf.ContactoTipo,'(TODOS)') ContactoTipo,
NULLIF(nf.Contacto,'(TODOS)') Contacto,
NULLIF(nf.ImporteMin,0.0) ImporteMin,
NULLIF(nf.ImporteMax,0.0) ImporteMax,
ValidarAlEmitir ValidarAlEmitir
FROM NotificacionFiltro nf WITH(NOLOCK) LEFT OUTER JOIN Estatus e WITH(NOLOCK)
ON UPPER(RTRIM(e.Nombre)) = UPPER(RTRIM(NULLIF(nf.Estatus,'(TODOS)')))

