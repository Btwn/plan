SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgFechaTrabajoAB ON FechaTrabajo

FOR INSERT, UPDATE
AS BEGIN
DECLARE
@Dif		int,
@EmpresaA		varchar(5),
@EmpresaN		varchar(5),
@FechaTrabajoN	datetime,
@FechaTrabajoA	datetime,
@SucursalN		int,
@SucursalA		int,
@Ok			int,
@OkRef		varchar(255)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @Ok = NULL, @OkRef = NULL
SELECT @EmpresaN = Empresa, @FechaTrabajoN = FechaTrabajo, @SucursalN = Sucursal FROM Inserted
SELECT @EmpresaA = Empresa, @FechaTrabajoA = FechaTrabajo, @SucursalA = Sucursal FROM Deleted
IF @FechaTrabajoN = @FechaTrabajoA RETURN
/*  EXEC spExtraerFecha @Hoy OUTPUT
SELECT @Dif = DATEDIFF(day, @Hoy, @FechaTrabajoN)
IF ABS(@Dif) > 3
RAISERROR ('La Fecha de Trabajo Indicada No Corresponde con el Servidor',16,-1)
ELSE*/
/* Cerrar el Dia en Modulo donde unicamente cambia de estatus el movimiento */
IF (SELECT PC FROM EmpresaGral WHERE Empresa = @EmpresaN) = 1
EXEC spPCCerrarDia @FechaTrabajoN, @Ok OUTPUT, @OkRef OUTPUT
IF (SELECT OFER FROM EmpresaGral WHERE Empresa = @EmpresaN) = 1
EXEC spOfertaCerrarDia @FechaTrabajoN, @Ok OUTPUT, @OkRef OUTPUT
EXEC spOk_RAISERROR @Ok, @OkRef
END

