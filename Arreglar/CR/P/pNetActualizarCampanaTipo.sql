SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC pNetActualizarCampanaTipo
@Usuario       varchar(10) = NULL,
@Empresa       varchar(5)  = NULL,
@Sucursal      int         = NULL,
@CampanaTipo   varchar(50) = NULL
AS BEGIN
IF NOT EXISTS(SELECT 1 FROM CampanaTipo WHERE CampanaTipo = ISNULL(@CampanaTipo,''))
INSERT INTO CampanaTipo(CampanaTipo, ParaProspectos, ParaClientes, ParaProveedores, ParaPersonal, ParaAgentes)
SELECT @CampanaTipo, 1,              0,            0,               0,            0
ELSE
UPDATE CampanaTipo SET CampanaTipo = @CampanaTipo, ParaProspectos = 1 WHERE CampanaTipo = ISNULL(@CampanaTipo,'')
SELECT 'El registro se actualizó con éxito'
RETURN
END

