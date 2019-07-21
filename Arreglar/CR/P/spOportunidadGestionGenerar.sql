SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spOportunidadGestionGenerar
@ID					int,
@Mov				varchar(20),
@MovID				varchar(20),
@Empresa			varchar(5),
@Sucursal			int,
@Usuario			varchar(15),
@Proyecto			varchar(50),
@UEN				int,
@Observaciones		varchar(100),
@RID				int,
@Tipo				varchar(20),
@Clave				varchar(50),
@PorcentajeAvance	float,
@Comentarios		varchar(max),
@Fecha				datetime,
@FechaA				datetime,
@Recurso			varchar(10),
@IDGestion			int,
@Ok					int			 = NULL OUTPUT,
@OkRef				varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE
@NombreRecurso	varchar(100),
@Asunto			varchar(255),
@MovGestion		varchar(20),
@FechaEmision		datetime,
@Concepto			varchar(50),
@OPORTTareaEstado	varchar(30),
@Estatus			varchar(15),
@Avance			float,
@OkDesc           varchar(255),
@OkTipo           varchar(50),
@MovGES			varchar(50),
@GeneraMov		varchar(20),
@GeneraMovID		varchar(20)
SELECT @FechaEmision = GETDATE()
EXEC spExtraerFecha @FechaEmision OUTPUT
IF ISNULL(@Recurso,'') = ''
SELECT @Ok = 55105, @OkRef = 'Clave: ' + ISNULL(@Clave,'')
IF @IDGestion IS NOT NULL
SELECT @Ok = 14083, @OkRef = 'Clave: ' + ISNULL(@Clave,'')
IF YEAR(@Fecha)  = 1899 SELECT @Fecha = NULL
IF YEAR(@FechaA) = 1899 SELECT @FechaA = NULL
IF @Ok IS NULL
BEGIN
SELECT @NombreRecurso = Nombre FROM Recurso WHERE Recurso=@Recurso
SELECT @Asunto = @Tipo + ' ' + @Clave
SELECT @MovGestion = GESTarea FROM EmpresaCfgMov WHERE Empresa = @Empresa
SELECT @OPORTTareaEstado = OPORTTareaEstado FROM EmpresaCfg2 WHERE Empresa = @Empresa
SELECT @Comentarios = '{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil Tahoma;}{\f1\fnil\fcharset0 Tahoma;}}  {\colortbl ;\red0\green0\blue0;}  \viewkind4\uc1\pard\cf1\lang2058\f0\fs20  \f1 ' + ISNULL(@Comentarios, '') + '\f0   \par }  '
INSERT INTO Gestion(
Empresa,  Mov,         FechaEmision,  Concepto,  Proyecto,  UEN,  Usuario, Referencia,                         Observaciones,  Estatus,     OrigenTipo,  Origen,  OrigenID,  Sucursal,  Asunto,  Comentarios, FechaD,  FechaA,   Estado,           Avance,           SucursalOrigen,  SucursalDestino,  OPORTID)
SELECT @Empresa, @MovGestion, @FechaEmision, @Concepto, @Proyecto, @UEN, @Usuario, RTRIM(@Mov) + ' ' + RTRIM(@MovID), @Observaciones, 'SINAFECTAR', 'OPORT',     @Mov,    @MovID,    @Sucursal, @Asunto, @Comentarios, @Fecha, @FechaA,  @OPORTTareaEstado, @PorcentajeAvance, @Sucursal,       @Sucursal,      @ID
SELECT @IDGestion = @@IDENTITY
INSERT INTO MovGrupo (Modulo, ModuloID, Recurso)
VALUES ('GES', @IDGestion, @Recurso)
EXEC spAfectar 'GES', @IDGestion, 'AFECTAR', 'Todo', NULL, @Usuario, @Estacion=@@SPID, @EnSilencio=1, @Conexion = 0, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
END
IF @Ok IS NULL
BEGIN
SELECT @Avance = Avance, @Estatus = Estatus, @MovGES = RTRIM(Mov)+' '+RTRIM(MovID), @GeneraMov = Mov, @GeneraMovID = MovID FROM Gestion WHERE ID=@IDGestion
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, 'OPORT', @ID, @Mov, @MovID, 'GES', @IDGestion, @GeneraMov, @GeneraMovID, @Ok OUTPUT
UPDATE OportunidadD
SET IDGestion=@IDGestion,
PorcentajeAvance = @Avance,
Fecha = @FechaEmision,
Usuario = @Usuario,
MovGestion = @MovGES
WHERE ID = @ID
AND RID = @RID
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

