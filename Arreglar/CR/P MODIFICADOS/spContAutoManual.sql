SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spContAutoManual
@Modulo		char(5),
@ID		int,
@Ok		int		= NULL OUTPUT,
@OkRef		varchar(255)	= NULL OUTPUT

AS BEGIN
DECLARE
@Empresa			char(5),
@Sucursal			int,
@Estatus			char(15),
@EstatusNuevo		char(15),
@Usuario			char(10),
@FechaEmision		datetime,
@FechaRegistro 		datetime,
@Mov			char(20),
@MovID			varchar(20),
@MovTipo			char(20),
@ContMov			char(20),
@UEN			int,
@EstatusContabilizar	char(15),
@EstatusMovTipo		char(15),
@Mensaje			varchar(255),
@ContAutoEmpresa	varchar(10)
EXEC spMovInfo @ID, @Modulo, @Mov OUTPUT, @MovID OUTPUT, @Estatus OUTPUT, @Sucursal OUTPUT, @UEN OUTPUT
/*  SELECT @Mov = Mov, @MovID = MovID, @Estatus = Estatus, @Sucursal = Sucursal, @UEN = UEN
FROM dbo.fnMovReg(@Modulo, @ID)*/
SELECT @Empresa = Empresa,
@Usuario = Usuario,
@FechaRegistro = FechaRegistro,
@FechaEmision = FechaEmision
FROM Mov WITH (NOLOCK)
WHERE Modulo = @Modulo AND ID = @ID
SELECT @MovTipo = mc.Clave,
@EstatusContabilizar = NULLIF(RTRIM(mc.EstatusContabilizar), ''),
@EstatusMovTipo = NULLIF(RTRIM(mt.EstatusContabilizar), ''),
@ContMov = NULLIF(RTRIM(mc.ContMov), '')
FROM MovTipo mt WITH (NOLOCK), MovClave mc WITH (NOLOCK)
WHERE mt.Modulo = @Modulo AND mt.Mov = @Mov AND mc.Clave = mt.Clave
IF UPPER(@EstatusMovTipo) NOT IN (NULL, '(POR OMISION)') SELECT @EstatusContabilizar = @EstatusMovTipo
SELECT @EstatusNuevo = @Estatus
IF @ContMov IS NOT NULL AND @Estatus = @EstatusContabilizar
BEGIN
BEGIN TRANSACTION
IF EXISTS (SELECT * FROM MovTipoContAuto WITH (NOLOCK) WHERE Modulo=@Modulo AND Clave=@Mov AND Empresa=@Empresa)
SELECT @ContAutoEmpresa=@Empresa
ELSE
SELECT @ContAutoEmpresa='(Todas)'
EXEC spContAuto @Empresa, @Sucursal, @Modulo,  @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @ContMov, @Ok OUTPUT, @OkRef OUTPUT, @ContAutoEmpresa
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION
SELECT @Mensaje = NULL
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT @Mensaje = Descripcion+' '+RTRIM(ISNULL(@OkRef, RTRIM(@Mov)+' '+RTRIM(@MovID))) FROM MensajeLista WITH (NOLOCK) WHERE Mensaje = @Ok
END
END
SELECT @Mensaje
END

