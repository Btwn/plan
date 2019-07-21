SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spProyectoGestionGenerar
@ID					int,
@Mov				varchar(20),
@MovID				varchar(20),
@Empresa			varchar(5),
@Sucursal			int,
@Usuario			varchar(15),
@Proyecto			varchar(50),
@UEN				int,
@Observaciones		varchar(100),
@Actividad			varchar(50),
@Asunto             varchar(100),
@PorcentajeAvance	float,
@Comentarios		varchar(max),
@Comienzo   		datetime,
@Conclusion			datetime,
@IDGestion			int,
@Ok					int			 = NULL OUTPUT,
@OkRef				varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE
@Recurso          varchar(10),
@NombreRecurso	varchar(100),
@Descripcion      varchar(255),
@MovGestion		varchar(20),
@FechaEmision		datetime,
@Concepto			varchar(50),
@ProyTareaEstado	varchar(30),
@Estatus			varchar(15),
@Avance			float,
@OkDesc           varchar(255),
@OkTipo           varchar(50),
@MovGES			varchar(50),
@GeneraMov		varchar(20),
@GeneraMovID		varchar(20)
SELECT @FechaEmision = GETDATE()
SELECT @Recurso = Recurso FROM ProyectoDRecurso WHERE ID = @ID AND Actividad = @Actividad
EXEC spExtraerFecha @FechaEmision OUTPUT
IF ISNULL(@Recurso,'') = ''
SELECT @Ok = 55105, @OkRef = 'Actividad: ' + ISNULL(@Actividad,'')
IF @IDGestion IS NOT NULL
SELECT @Ok = 14083, @OkRef = 'Actividad: ' + ISNULL(@Actividad,'')
IF YEAR(@Comienzo)  = 1899 SELECT @Comienzo = NULL
IF YEAR(@Conclusion) = 1899 SELECT @Conclusion = NULL
IF @Ok IS NULL
BEGIN
SELECT @NombreRecurso = Nombre FROM Recurso WHERE Recurso=@Recurso
SELECT @Descripcion = @Actividad + ' ' + @Asunto
SELECT @MovGestion = GESTarea FROM EmpresaCfgMov WHERE Empresa = @Empresa
SELECT @ProyTareaEstado = ProyTareaEstado FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @Comentarios = '{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil Tahoma;}{\f1\fnil\fcharset0 Tahoma;}}  {\colortbl ;\red0\green0\blue0;}  \viewkind4\uc1\pard\cf1\lang2058\f0\fs20  \f1 ' + ISNULL(@Comentarios, '') + '\f0   \par }  '
INSERT INTO Gestion(
Empresa,  Mov,         FechaEmision,  Concepto,  Proyecto,  UEN,  Usuario, Referencia,                         Observaciones,  Estatus,     OrigenTipo,  Origen,  OrigenID,  Sucursal,  Asunto,       Comentarios,   FechaD,    FechaA,       Estado,           Avance,           SucursalOrigen,  SucursalDestino,  PROYID)
SELECT @Empresa, @MovGestion, @FechaEmision, @Concepto, @Proyecto, @UEN, @Usuario, RTRIM(@Mov) + ' ' + RTRIM(@MovID), @Observaciones, 'SINAFECTAR', 'PROY',     @Mov,    @MovID,    @Sucursal,  @Descripcion, @Comentarios, @Comienzo, @Conclusion,  @ProyTareaEstado, @PorcentajeAvance, @Sucursal,       @Sucursal,      @ID
SELECT @IDGestion = SCOPE_IDENTITY()
INSERT INTO MovGrupo (Modulo, ModuloID, Recurso)
VALUES ('GES', @IDGestion, @Recurso)
EXEC spAfectar 'GES', @IDGestion, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion=@@SPID, @EnSilencio=1, @Conexion = 0, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF @Ok IS NULL
BEGIN
SELECT @Avance = Avance, @Estatus = Estatus, @MovGES = RTRIM(Mov)+' '+RTRIM(MovID), @GeneraMov = Mov, @GeneraMovID = MovID FROM Gestion WHERE ID=@IDGestion
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'PROY', @ID, @Mov, @MovID, 'GES', @IDGestion, @GeneraMov, @GeneraMovID, @Ok OUTPUT
UPDATE ProyectoD
SET IDGestion=@IDGestion,
Avance = @Avance,
Comienzo = @FechaEmision,
Usuario = @Usuario,
MovGestion = @MovGES
WHERE ID = @ID
AND Actividad = @Actividad
IF @@ERROR <> 0 SELECT @Ok = 1
END
IF @Ok IS NULL
SELECT @OkRef = NULL
ELSE
SELECT @OkDesc = Descripcion,
@OkTipo = Tipo
FROM MensajeLista
WHERE Mensaje = @Ok
SELECT @Ok, @OkDesc, @OkTipo, @OkRef, @IDGestion
RETURN
END

