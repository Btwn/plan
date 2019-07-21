SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC pNetActualizarCampanaTipoSituacion
@Usuario       varchar(10) = NULL,
@Empresa       varchar(5)  = NULL,
@Sucursal      int = NULL,
@CampanaTipo   varchar(50) = NULL,
@Situacion     varchar(50) = NULL,
@Flujo         varchar(20) = NULL,
@Orden         int = NULL
AS BEGIN
IF EXISTS(SELECT 1 FROM CampanaTipoSituacion WITH(NOLOCK) WHERE CampanaTipo = @CampanaTipo AND Situacion = @Situacion)
UPDATE CampanaTipoSituacion WITH(ROWLOCK) SET
Flujo = @Flujo,
Orden = @Orden
WHERE CampanaTipo = @CampanaTipo AND Situacion = @Situacion
ELSE
INSERT INTO CampanaTipoSituacion(CampanaTipo, Situacion, Flujo, Orden)
SELECT @CampanaTipo, @Situacion, @Flujo, @Orden
SELECT 'El Registro se actualizó con éxito'
RETURN
END

