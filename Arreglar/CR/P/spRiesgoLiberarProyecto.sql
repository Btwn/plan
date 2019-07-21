SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRiesgoLiberarProyecto
@Estacion       int,
@Empresa        varchar(5),
@Sucursal       int,
@Usuario        varchar(10),
@Riesgo         varchar(20),
@Plantilla      varchar(50)

AS BEGIN
DECLARE
@ID                 int,
@Estatus            varchar(15),
@FechaEmision       datetime,
@Moneda             varchar(10),
@TipoCambio         float,
@Mov                varchar(20),
@MovID              varchar(20),
@Ok                 int,
@OkRef              varchar(255)
SELECT @Moneda = DefMoneda FROM Usuario WHERE Usuario = @Usuario
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
SELECT @Mov = ProyMitigacion FROM EmpresaCfgMov WHERE Empresa = @Empresa
SELECT @FechaEmision = GETDATE()
SELECT @Estatus = 'CONFIRMAR'
EXEC spExtraerFecha @FechaEmision OUTPUT
BEGIN TRANSACTION
EXEC spConsecutivoAuto @Sucursal, @Empresa, 'PROY', @Mov, NULL, NULL, NULL, @MovID OUTPUT, @Ok OUTPUT, @OkRef OUTPUT, NULL
IF @Ok IS NULL
BEGIN
INSERT Proyecto ( Empresa, Mov, MovID, ContactoTipo, Riesgo, Moneda, TipoCambio, Estatus, FechaEmision, Comienzo, Usuario)
VALUES        ( @Empresa, @Mov, @MovID, 'Riesgo', @Riesgo, @Moneda, @TipoCambio, @Estatus, @FechaEmision, @FechaEmision, @Usuario)
SELECT @ID = SCOPE_IDENTITY()
EXEC spProyectoNuevo @Estacion, @ID, @Plantilla, @Sucursal
COMMIT TRANSACTION
END ELSE
ROLLBACK TRANSACTION
SELECT @ID
RETURN
END

