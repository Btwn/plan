SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC pNetActualizarCampana
@Usuario       varchar(10),
@Empresa       varchar(5),
@Sucursal      int,
@ID            int = NULL,
@Asunto        varchar(100),
@Agente        varchar(10),
@CampanaTipo   varchar(50),
@Estatus       varchar(15),
@FechaEmision  datetime,
@Observaciones varchar(100),
@Proyecto      varchar(50),
@Concepto      varchar(50)
AS BEGIN
DECLARE
@UltimoCambio datetime,
@Mov          varchar(20)
SELECT @UltimoCambio = GETDATE()
SELECT @Mov = 'Campaña'
IF @ID IS NOT NULL AND EXISTS (SELECT 1 FROM Campana WHERE ID = @ID AND Estatus = 'SINAFECTAR')
UPDATE Campana SET
Empresa = @Empresa, Mov = @Mov, FechaEmision = @FechaEmision, UltimoCambio = @UltimoCambio,
Concepto = @Concepto, Proyecto = @Proyecto, Usuario = @Usuario, Observaciones = @Observaciones,
Estatus = @Estatus, FechaRegistro = @UltimoCambio, Sucursal = @Sucursal, Asunto = @Asunto,
Agente = @Agente, CampanaTipo = @CampanaTipo
WHERE ID = @ID
ELSE IF NOT EXISTS (SELECT 1 FROM Campana WHERE ID = @ID)
INSERT INTO Campana(Empresa, Mov, FechaEmision, UltimoCambio, Concepto, Proyecto, Usuario,
Observaciones, Estatus, FechaRegistro, Sucursal, Asunto, Agente, CampanaTipo)
SELECT @Empresa, @Mov, @FechaEmision, @UltimoCambio, @Concepto, @Proyecto, @Usuario,
@Observaciones, @Estatus, @UltimoCambio, @Sucursal, @Asunto, @Agente, @CampanaTipo
SELECT 'La Campaña se actualizó con éxito'
RETURN
END

